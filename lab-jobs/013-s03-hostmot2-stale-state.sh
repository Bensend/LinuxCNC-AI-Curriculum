#!/usr/bin/env bash
set -euo pipefail
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
LINUXCNC_COMMIT="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-s03-013"
printf '== S03-013 mutable HostMot2 stale-state lab ==\nPinned revision: %s\n' "$LINUXCNC_COMMIT"
printf '%s\n' 'Prediction: after a fresh IOPort publication, persistent llio.io_error leaves the prior HAL input visible and suppresses LLIO writes; clearing io_error permits fresh publication and writes to resume.'
printf '%s\n' 'Boundary: production HostMot2 host path with test-only mutable LLIO; not Ethernet/FPGA/drive/physical-safety evidence.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$LINUXCNC_COMMIT"

python3 - <<'PY'
from pathlib import Path
p=Path('src/hal/drivers/mesa-hostmot2/hm2_test.c')
s=p.read_text()
s=s.replace('static hm2_test_t board[1];', '''static hm2_test_t board[1];
static hal_u32_t *s03_input_word;
static hal_u32_t *s03_write_count;
static hal_u32_t *s03_last_write_addr;
static hal_u32_t *s03_last_write_word;''')
s=s.replace('''static int hm2_test_read(hm2_lowlevel_io_t *this, rtapi_u32 addr, void *buffer, int size) {
    hm2_test_t *me = this->private;
    memcpy(buffer, &me->test_pattern.tp8[addr], size);
    return 1;  // success
}''','''static int hm2_test_read(hm2_lowlevel_io_t *this, rtapi_u32 addr, void *buffer, int size) {
    hm2_test_t *me = this->private;
    if (test_pattern == 15 && addr == 0x1000 && size == 4) {
        rtapi_u32 v = *s03_input_word;
        memcpy(buffer, &v, 4);
    } else {
        memcpy(buffer, &me->test_pattern.tp8[addr], size);
    }
    return 1;
}''')
s=s.replace('''static int hm2_test_write(hm2_lowlevel_io_t *this, rtapi_u32 addr, const void *buffer, int size) {
    (void)this;
    (void)addr;
    (void)buffer;
    (void)size;
    return 1;  // success
}''','''static int hm2_test_write(hm2_lowlevel_io_t *this, rtapi_u32 addr, const void *buffer, int size) {
    (void)this;
    if (test_pattern == 15) {
        (*s03_write_count)++;
        *s03_last_write_addr = addr;
        if (size >= 4) {
            rtapi_u32 v;
            memcpy(&v, buffer, 4);
            *s03_last_write_word = v;
        }
    }
    return 1;
}''')
needle='''        case 14: {'''
idx=s.index(needle)
case15='''        // S03 test-only valid one-IOPort mutable board\n        case 15: {\n            int pd_index;\n            set32(me, HM2_ADDR_IOCOOKIE, HM2_IOCOOKIE);\n            set8(me, HM2_ADDR_CONFIGNAME+0, 'H'); set8(me, HM2_ADDR_CONFIGNAME+1, 'O');\n            set8(me, HM2_ADDR_CONFIGNAME+2, 'S'); set8(me, HM2_ADDR_CONFIGNAME+3, 'T');\n            set8(me, HM2_ADDR_CONFIGNAME+4, 'M'); set8(me, HM2_ADDR_CONFIGNAME+5, 'O');\n            set8(me, HM2_ADDR_CONFIGNAME+6, 'T'); set8(me, HM2_ADDR_CONFIGNAME+7, '2');\n            set32(me, HM2_ADDR_IDROM_OFFSET, 0x400);\n            set32(me, 0x400, 2); set32(me, 0x404, 64); set32(me, 0x408, 0x200);\n            set32(me, 0x41c, 1); set32(me, 0x420, 24); set32(me, 0x424, 24);\n            set32(me, 0x428, 2000000); set32(me, 0x42c, 20000000);\n            set32(me, 0x430, 4); set32(me, 0x434, 4);\n            set32(me, 0x438, 0x100); set32(me, 0x43c, 0x100);\n            set32(me, 0x440, 0x01010003); set32(me, 0x444, 0x00051000); set32(me, 0x448, 0x0000001f);\n            for (pd_index=0; pd_index<24; pd_index++) {\n                set8(me, 0x600 + pd_index*4 + 0, 0); set8(me, 0x600 + pd_index*4 + 1, 0);\n                set8(me, 0x600 + pd_index*4 + 2, 0); set8(me, 0x600 + pd_index*4 + 3, HM2_GTAG_IOPORT);\n            }\n            break;\n        }\n\n'''
s=s[:idx]+case15+s[idx:]
needle='''    me->llio.read = hm2_test_read;\n    me->llio.write = hm2_test_write;\n\n    r = hm2_register(&board->llio, config[0]);'''
repl='''    me->llio.read = hm2_test_read;\n    me->llio.write = hm2_test_write;\n\n    // Allocate test-only mutable backing and write observability before hm2_register():\n    // registration performs LLIO force-writes, so callbacks must never see NULL test storage.\n    if (test_pattern == 15) {\n        if (hal_pin_u32_newf(HAL_IN, &s03_input_word, comp_id, "%s.s03-input-word", me->llio.name) < 0) return -EIO;\n        if (hal_pin_u32_newf(HAL_OUT, &s03_write_count, comp_id, "%s.s03-write-count", me->llio.name) < 0) return -EIO;\n        if (hal_pin_u32_newf(HAL_OUT, &s03_last_write_addr, comp_id, "%s.s03-last-write-addr", me->llio.name) < 0) return -EIO;\n        if (hal_pin_u32_newf(HAL_OUT, &s03_last_write_word, comp_id, "%s.s03-last-write-word", me->llio.name) < 0) return -EIO;\n        *s03_input_word = 0; *s03_write_count = 0; *s03_last_write_addr = 0; *s03_last_write_word = 0;\n    }\n\n    r = hm2_register(&board->llio, config[0]);'''
if needle not in s: raise SystemExit('pre-registration insertion point missing')
s=s.replace(needle,repl)
p.write_text(s)
PY

grep -F 'case 15' src/hal/drivers/mesa-hostmot2/hm2_test.c
grep -F 'Allocate test-only mutable backing' src/hal/drivers/mesa-hostmot2/hm2_test.c
./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)"
cd ..
set +u; source scripts/rip-environment; set -u

FIFO=/tmp/s03-halrun.fifo
rm -f "$FIFO"; mkfifo "$FIFO"
halrun <"$FIFO" >/tmp/s03-halrun.out 2>/tmp/s03-halrun.err & HPID=$!
exec 3>"$FIFO"
printf '%s\n' 'loadrt hostmot2' 'loadrt hm2_test test_pattern=15' 'loadrt threads name1=s03-thread period1=1000000' 'addf hm2_test.0.read s03-thread' 'addf hm2_test.0.write s03-thread' 'start' >&3
sleep 1

halcmd show pin hm2_test.0.gpio.000.in >/tmp/s03-pin.txt
grep -F 'hm2_test.0.gpio.000.in' /tmp/s03-pin.txt
halcmd show pin hm2_test.0.s03-input-word hm2_test.0.s03-write-count >/tmp/s03-hooks.txt
cat /tmp/s03-hooks.txt
halcmd setp hm2_test.0.s03-input-word 1
sleep 0.05
BASE_IN="$(halcmd getp hm2_test.0.gpio.000.in)"
halcmd setp hm2_test.0.gpio.001.is_output true
halcmd setp hm2_test.0.gpio.001.out true
sleep 0.05
BASE_W="$(halcmd getp hm2_test.0.s03-write-count)"
printf 'gateA input=%s writes=%s\n' "$BASE_IN" "$BASE_W"
[[ "$BASE_IN" == "TRUE" ]]; [[ "$BASE_W" -gt 0 ]]

halcmd setp hm2_test.0.io_error true
halcmd setp hm2_test.0.s03-input-word 0
W0="$(halcmd getp hm2_test.0.s03-write-count)"
halcmd setp hm2_test.0.gpio.001.out false
sleep 0.05
FAULT_IN="$(halcmd getp hm2_test.0.gpio.000.in)"
W1="$(halcmd getp hm2_test.0.s03-write-count)"
printf 'gateBC stale-input=%s writes-before=%s writes-after=%s\n' "$FAULT_IN" "$W0" "$W1"
[[ "$FAULT_IN" == "TRUE" ]]; [[ "$W1" -eq "$W0" ]]

halcmd setp hm2_test.0.io_error false
sleep 0.05
REC_IN="$(halcmd getp hm2_test.0.gpio.000.in)"
W2="$(halcmd getp hm2_test.0.s03-write-count)"
printf 'gateD recovered-input=%s writes-after-recovery=%s\n' "$REC_IN" "$W2"
[[ "$REC_IN" == "FALSE" ]]; [[ "$W2" -gt "$W1" ]]

printf '%s\n' 'S03-013 PASS: production HostMot2 host path preserved stale HAL publication and suppressed LLIO writes under persistent io_error, then resumed after clear.'
printf '%s\n' 'No claim is made about Ethernet packet behavior, FPGA watchdog timing, hardware resynchronization, actuator response, or functional safety.'
printf '%s\n' 'stop' 'unloadrt all' 'exit' >&3 || true
exec 3>&-
wait "$HPID" || true
