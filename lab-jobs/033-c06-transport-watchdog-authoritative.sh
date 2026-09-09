#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c06-030"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
EVID="$ROOT/lab-results/c06-030-evidence"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"

printf '== C06-030 authoritative transport error vs watchdog bite ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$PINNED"
printf '%s\n' 'Frozen plan=experiments/C06-030-transport-watchdog-fault-plan.md'
printf '%s\n' 'Frozen prediction=low-level communication escalation can assert real io_error without watchdog.has_bit; separately a healthy read of fake watchdog status bit 0 can assert the real watchdog.has_bit without io_error.'
printf '%s\n' 'Boundary=transport recovery != watchdog recovery != proof of physical safe state; ordinary HostMot2/HAL behavior is not functional-safety certification.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps python3
rm -rf "$WORK" "$EVID"
mkdir -p "$EVID" "$RUN_EVID"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$PINNED"
[[ "$(git rev-parse HEAD)" == "$PINNED" ]] || { echo 'HARNESS_INVALID: pinned checkout mismatch' >&2; exit 20; }

HM2=src/hal/drivers/mesa-hostmot2/hm2_test.c
CORE=src/hal/drivers/mesa-hostmot2/hostmot2.c
TRAM=src/hal/drivers/mesa-hostmot2/tram.c
WD=src/hal/drivers/mesa-hostmot2/watchdog.c
LLIO=src/hal/drivers/mesa-hostmot2/hostmot2-lowlevel.h
sha256sum "$CORE" "$TRAM" "$WD" "$LLIO" | tee /tmp/c06-production-before.sha
sha256sum "$HM2" | tee /tmp/c06-hm2test-before.sha

python3 - <<'PY'
from pathlib import Path
p=Path('src/hal/drivers/mesa-hostmot2/hm2_test.c')
s=p.read_text()

# Lab-only C06 controls. They are exported only for test_pattern 15.
anchor='''static hm2_test_t board[1];\n'''
insert='''static hm2_test_t board[1];\n\n// C06 lab-only deterministic fault controls and observation pins.\nstatic hal_u32_t *c06_fail_reads_remaining;\nstatic hal_bit_t *c06_watchdog_status_command;\nstatic hal_u32_t *c06_read_success_count;\nstatic hal_u32_t *c06_read_fail_count;\nstatic hal_u32_t *c06_write_success_count;\nstatic hal_u32_t *c06_consecutive_failures;\nstatic hal_bit_t *c06_io_error_mirror;\nstatic hal_bit_t *c06_watchdog_status_mirror;\n\n#define C06_IO_ERROR_THRESHOLD 3\n'''
assert anchor in s
s=s.replace(anchor,insert,1)

old_read='''static int hm2_test_read(hm2_lowlevel_io_t *this, rtapi_u32 addr, void *buffer, int size) {\n    hm2_test_t *me = this->private;\n    memcpy(buffer, &me->test_pattern.tp8[addr], size);\n    return 1;  // success\n}\n'''
new_read='''static int hm2_test_read(hm2_lowlevel_io_t *this, rtapi_u32 addr, void *buffer, int size) {\n    hm2_test_t *me = this->private;\n\n    if (test_pattern == 15 && c06_fail_reads_remaining != NULL) {\n        if (*c06_fail_reads_remaining > 0) {\n            (*c06_fail_reads_remaining)--;\n            (*c06_read_fail_count)++;\n            (*c06_consecutive_failures)++;\n            if (*c06_consecutive_failures >= C06_IO_ERROR_THRESHOLD && this->io_error != NULL) {\n                *(this->io_error) = 1;\n            }\n            if (this->io_error != NULL) *c06_io_error_mirror = *(this->io_error);\n            return 0;\n        }\n\n        *c06_consecutive_failures = 0;\n        // Watchdog bite injection enters only through the pretend board status image.\n        if (c06_watchdog_status_command != NULL && *c06_watchdog_status_command) {\n            me->test_pattern.tp32[0x2004 / 4] |= 1u;\n            *c06_watchdog_status_mirror = 1;\n        } else {\n            me->test_pattern.tp32[0x2004 / 4] &= ~1u;\n            *c06_watchdog_status_mirror = 0;\n        }\n    }\n\n    memcpy(buffer, &me->test_pattern.tp8[addr], size);\n    if (test_pattern == 15 && c06_read_success_count != NULL) {\n        (*c06_read_success_count)++;\n        if (this->io_error != NULL) *c06_io_error_mirror = *(this->io_error);\n    }\n    return 1;  // success\n}\n'''
assert old_read in s
s=s.replace(old_read,new_read,1)

old_write='''static int hm2_test_write(hm2_lowlevel_io_t *this, rtapi_u32 addr, const void *buffer, int size) {\n    (void)this;\n    (void)addr;\n    (void)buffer;\n    (void)size;\n    return 1;  // success\n}\n'''
new_write='''static int hm2_test_write(hm2_lowlevel_io_t *this, rtapi_u32 addr, const void *buffer, int size) {\n    (void)this;\n    (void)addr;\n    (void)buffer;\n    (void)size;\n    if (test_pattern == 15 && c06_write_success_count != NULL) {\n        (*c06_write_success_count)++;\n        if (this->io_error != NULL) *c06_io_error_mirror = *(this->io_error);\n    }\n    return 1;  // success\n}\n'''
assert old_write in s
s=s.replace(old_write,new_write,1)

needle='''        default: {\n            LL_ERR("unknown test pattern %d", test_pattern); '''
assert needle in s
case='''        // Lab-only C06 fixture: one valid IOPort plus one valid watchdog.\n        // Existing upstream patterns 0-14 remain byte-for-byte unchanged.\n        case 15: {\n            int num_io_pins = 24;\n            int pd_index;\n\n            set32(me, HM2_ADDR_IOCOOKIE, HM2_IOCOOKIE);\n            set8(me, HM2_ADDR_CONFIGNAME+0, 'H');\n            set8(me, HM2_ADDR_CONFIGNAME+1, 'O');\n            set8(me, HM2_ADDR_CONFIGNAME+2, 'S');\n            set8(me, HM2_ADDR_CONFIGNAME+3, 'T');\n            set8(me, HM2_ADDR_CONFIGNAME+4, 'M');\n            set8(me, HM2_ADDR_CONFIGNAME+5, 'O');\n            set8(me, HM2_ADDR_CONFIGNAME+6, 'T');\n            set8(me, HM2_ADDR_CONFIGNAME+7, '2');\n            set32(me, HM2_ADDR_IDROM_OFFSET, 0x400);\n            set32(me, 0x400, 2);\n            set32(me, 0x404, 0x40);\n            set32(me, 0x408, 0x200);\n            set32(me, 0x41c, 1);\n            set32(me, 0x420, num_io_pins);\n            set32(me, 0x424, 24);\n            set32(me, 0x428, 2000000);\n            set32(me, 0x42c, 20000000);\n            set32(me, 0x430, 4);\n            set32(me, 0x434, 4);\n            set32(me, 0x438, 4);\n            set32(me, 0x43c, 4);\n\n            // IOPort MD followed by watchdog MD, then terminator.\n            set32(me, 0x440, 0x01010003);\n            set32(me, 0x444, 0x00051000);\n            set32(me, 0x448, 0x0000001F);\n            set32(me, 0x44c, 0x01010002);\n            set32(me, 0x450, 0x00032000);\n            set32(me, 0x454, 0x00000000);\n            set32(me, 0x458, 0); set32(me, 0x45c, 0); set32(me, 0x460, 0);\n\n            me->llio.num_ioport_connectors = 1;\n            me->llio.ioport_connector_name[0] = "P3";\n            for (pd_index = 0; pd_index < num_io_pins; pd_index ++) {\n                set8(me, 0x600 + (pd_index * 4) + 0, 0);\n                set8(me, 0x600 + (pd_index * 4) + 1, 0);\n                set8(me, 0x600 + (pd_index * 4) + 2, 0);\n                set8(me, 0x600 + (pd_index * 4) + 3, HM2_GTAG_IOPORT);\n            }\n            break;\n        }\n\n'''
s=s.replace(needle,case+needle,1)

# Export lab-only controls before hm2_register so low-level callbacks can observe them.
anchor2='''    me->llio.read = hm2_test_read;\n    me->llio.write = hm2_test_write;\n\n    r = hm2_register(&board->llio, config[0]);\n'''
export='''    me->llio.read = hm2_test_read;\n    me->llio.write = hm2_test_write;\n\n    if (test_pattern == 15) {\n        r = hal_pin_u32_newf(HAL_IO, &c06_fail_reads_remaining, comp_id, "hm2_test.0.c06.fail-reads-remaining");\n        if (r) return r;\n        r = hal_pin_bit_newf(HAL_IN, &c06_watchdog_status_command, comp_id, "hm2_test.0.c06.watchdog-status-command");\n        if (r) return r;\n        r = hal_pin_u32_newf(HAL_OUT, &c06_read_success_count, comp_id, "hm2_test.0.c06.read-success-count");\n        if (r) return r;\n        r = hal_pin_u32_newf(HAL_OUT, &c06_read_fail_count, comp_id, "hm2_test.0.c06.read-fail-count");\n        if (r) return r;\n        r = hal_pin_u32_newf(HAL_OUT, &c06_write_success_count, comp_id, "hm2_test.0.c06.write-success-count");\n        if (r) return r;\n        r = hal_pin_u32_newf(HAL_OUT, &c06_consecutive_failures, comp_id, "hm2_test.0.c06.consecutive-failures");\n        if (r) return r;\n        r = hal_pin_bit_newf(HAL_OUT, &c06_io_error_mirror, comp_id, "hm2_test.0.c06.io-error-mirror");\n        if (r) return r;\n        r = hal_pin_bit_newf(HAL_OUT, &c06_watchdog_status_mirror, comp_id, "hm2_test.0.c06.watchdog-status-mirror");\n        if (r) return r;\n        *c06_fail_reads_remaining = 0;\n        *c06_watchdog_status_command = 0;\n        *c06_read_success_count = 0;\n        *c06_read_fail_count = 0;\n        *c06_write_success_count = 0;\n        *c06_consecutive_failures = 0;\n        *c06_io_error_mirror = 0;\n        *c06_watchdog_status_mirror = 0;\n    }\n\n    r = hm2_register(&board->llio, config[0]);\n'''
assert anchor2 in s
s=s.replace(anchor2,export,1)
p.write_text(s)
PY

git diff -- "$HM2" | tee /tmp/c06-hm2test.patch
[[ -s /tmp/c06-hm2test.patch ]] || { echo 'HARNESS_INVALID: missing fixture patch' >&2; exit 21; }
sha256sum "$CORE" "$TRAM" "$WD" "$LLIO" | tee /tmp/c06-production-after.sha
cmp /tmp/c06-production-before.sha /tmp/c06-production-after.sha || { echo 'HARNESS_INVALID: generic HostMot2 source changed' >&2; exit 22; }
cp /tmp/c06-hm2test.patch "$RUN_EVID/c06-hm2test.patch"
cp /tmp/c06-production-before.sha "$RUN_EVID/production-source-sha256.txt"

./debian/configure uspace
sudo apt-get build-dep -y .
cd src
./autogen.sh
./configure --with-realtime=uspace --disable-gui --disable-manpages --disable-build-documentation
make -j"$(nproc)" 2>&1 | tee "$RUN_EVID/build.log"
cd ..
set +u
source scripts/rip-environment
set -u

SAMPLER_BIN="$(command -v halsampler)"
case "$(readlink -f "$SAMPLER_BIN")" in "$WORK"/*) ;; *) echo 'HARNESS_INVALID: halsampler not from pinned tree' >&2; exit 23;; esac

cat >/tmp/c06-030.hal <<'EOF'
loadrt hostmot2
loadrt hm2_test test_pattern=15
loadrt threads name1=c06-thread period1=1000000
loadrt sampler depth=30000 cfg=uubbbuuuub

addf hm2_test.0.read c06-thread
addf hm2_test.0.write c06-thread
addf sampler.0 c06-thread

newsig c06-phase u32
newsig c06-fail-remaining u32
newsig c06-watchdog-command bit
newsig c06-io-error-mirror bit
newsig c06-has-bit bit
newsig c06-read-success u32
newsig c06-read-fail u32
newsig c06-write-success u32
newsig c06-consecutive u32
newsig c06-watchdog-status-mirror bit

net c06-phase => sampler.0.pin.0
net c06-fail-remaining hm2_test.0.c06.fail-reads-remaining => sampler.0.pin.1
net c06-watchdog-command => hm2_test.0.c06.watchdog-status-command sampler.0.pin.2
net c06-io-error-mirror hm2_test.0.c06.io-error-mirror => sampler.0.pin.3
net c06-has-bit hm2_test.0.watchdog.has_bit => sampler.0.pin.4
net c06-read-success hm2_test.0.c06.read-success-count => sampler.0.pin.5
net c06-read-fail hm2_test.0.c06.read-fail-count => sampler.0.pin.6
net c06-write-success hm2_test.0.c06.write-success-count => sampler.0.pin.7
net c06-consecutive hm2_test.0.c06.consecutive-failures => sampler.0.pin.8
net c06-watchdog-status-mirror hm2_test.0.c06.watchdog-status-mirror => sampler.0.pin.9

sets c06-phase 0
sets c06-fail-remaining 0
sets c06-watchdog-command false
start
EOF
cp /tmp/c06-030.hal "$RUN_EVID/c06-030.hal"

FIFO=/tmp/c06-030-halrun.fifo
rm -f "$FIFO" /tmp/c06-030-trace.txt /tmp/c06-030-halrun.out /tmp/c06-030-halrun.err /tmp/c06-030-halsampler.err /tmp/c06-030-controller.log
mkfifo "$FIFO"
halrun <"$FIFO" >/tmp/c06-030-halrun.out 2>/tmp/c06-030-halrun.err &
HALRUN_PID=$!
exec 3>"$FIFO"
cat /tmp/c06-030.hal >&3

cleanup() {
  set +e
  if [[ -n "${SAMPLER_PID:-}" ]] && kill -0 "$SAMPLER_PID" 2>/dev/null; then kill -TERM "$SAMPLER_PID"; wait "$SAMPLER_PID"; fi
  printf 'stop\nunload all\nexit\n' >&3 2>/dev/null || true
  exec 3>&- || true
  wait "$HALRUN_PID" 2>/dev/null || true
  for f in /tmp/c06-030-trace.txt /tmp/c06-030-halrun.out /tmp/c06-030-halrun.err /tmp/c06-030-halsampler.err /tmp/c06-030-controller.log; do
    [[ -f "$f" ]] && cp "$f" "$RUN_EVID/$(basename "$f")" || true
  done
}
trap cleanup EXIT

READY=0
for i in $(seq 1 200); do
  if halcmd getp hm2_test.0.watchdog.has_bit >/dev/null 2>&1 && halcmd getp hm2_test.0.io_error >/dev/null 2>&1 && halcmd getp sampler.0.overruns >/dev/null 2>&1; then READY=1; echo "runtime-ready-probe=$i"; break; fi
  sleep .05
done
[[ "$READY" == 1 ]] || { echo 'HARNESS_INVALID: HAL runtime not ready' >&2; exit 24; }

# Gate-A topology proof uses real generic watchdog and io_error objects.
halcmd show pin hm2_test.0.watchdog.has_bit
halcmd show param hm2_test.0.io_error
halcmd show pin hm2_test.0.c06
printf 'gate-A-topology=PASS\n'

halsampler -c 0 -t >/tmp/c06-030-trace.txt 2>/tmp/c06-030-halsampler.err &
SAMPLER_PID=$!
sleep .10
kill -0 "$SAMPLER_PID" 2>/dev/null || { echo 'HARNESS_INVALID: halsampler exited early' >&2; exit 25; }

logstate() {
  printf '%s phase=%s io_error=%s has_bit=%s fail_remaining=%s watchdog_cmd=%s read_ok=%s read_fail=%s write_ok=%s\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)" \
    "$(halcmd gets c06-phase | tr -d '[:space:]')" \
    "$(halcmd getp hm2_test.0.io_error | tr -d '[:space:]')" \
    "$(halcmd getp hm2_test.0.watchdog.has_bit | tr -d '[:space:]')" \
    "$(halcmd gets c06-fail-remaining | tr -d '[:space:]')" \
    "$(halcmd gets c06-watchdog-command | tr -d '[:space:]')" \
    "$(halcmd getp hm2_test.0.c06.read-success-count | tr -d '[:space:]')" \
    "$(halcmd getp hm2_test.0.c06.read-fail-count | tr -d '[:space:]')" \
    "$(halcmd getp hm2_test.0.c06.write-success-count | tr -d '[:space:]')" | tee -a /tmp/c06-030-controller.log
}

# P0 BASELINE
halcmd sets c06-phase 0
sleep .35
logstate

# P1 TRANSIENT: exactly one low-level read failure, then automatic success.
halcmd sets c06-fail-remaining 1
halcmd sets c06-phase 1
sleep .40
logstate

# P2 ESCALATED IO: threshold is frozen in fixture at three consecutive failed reads.
halcmd sets c06-fail-remaining 5
halcmd sets c06-phase 2
sleep .40
logstate
[[ "$(halcmd getp hm2_test.0.io_error | tr -d '[:space:]')" == "TRUE" ]] || { echo 'C06-030 behavioral failure: P2 real io_error did not assert' >&2; }

# P3 IO RECOVERY: remove injection, explicitly clear the real generic parameter.
halcmd sets c06-fail-remaining 0
halcmd setp hm2_test.0.io_error false
halcmd sets c06-phase 3
sleep .40
logstate

# P4 WATCHDOG BITE: healthy transport, inject only fake status register 0x2004 bit 0.
halcmd sets c06-watchdog-command true
halcmd sets c06-phase 4
sleep .40
logstate

# P5 WATCHDOG HOLD: leave has_bit asserted and command/status high.
halcmd sets c06-phase 5
sleep .40
logstate

# P6 WATCHDOG RECOVERY: clear fake status input, then explicitly clear real has_bit signal.
halcmd sets c06-watchdog-command false
halcmd sets c06-has-bit false
halcmd sets c06-phase 6
sleep .50
logstate

OVERRUNS="$(halcmd getp sampler.0.overruns | tr -d '[:space:]')"
printf 'sampler-overruns=%s\n' "$OVERRUNS"
kill -TERM "$SAMPLER_PID" 2>/dev/null || true
wait "$SAMPLER_PID" 2>/dev/null || true
SAMPLER_PID=""
sleep .10

# Retain raw evidence before analysis, including on later behavioral failure.
for f in /tmp/c06-030-trace.txt /tmp/c06-030-halrun.out /tmp/c06-030-halrun.err /tmp/c06-030-halsampler.err /tmp/c06-030-controller.log; do
  [[ -f "$f" ]] || { echo "HARNESS_INVALID: required evidence missing before analysis: $f" >&2; exit 26; }
  cp "$f" "$RUN_EVID/$(basename "$f")"
  printf 'retained-evidence=%s sha256=%s bytes=%s\n' "$(basename "$f")" "$(sha256sum "$f" | awk '{print $1}')" "$(wc -c < "$f")"
done
printf 'retained-realtime-lines=%s\n' "$(wc -l < /tmp/c06-030-trace.txt)"

OVERRUNS="$OVERRUNS" TRACE=/tmp/c06-030-trace.txt python3 - <<'PY'
import os,sys
rows=[]
for line in open(os.environ['TRACE'],errors='replace'):
    p=line.split()
    if len(p) < 11: continue
    try:
        # n phase failRemaining wdCmd ioMirror hasBit readOK readFail writeOK consecutive wdMirror
        r=(int(p[0]), int(p[1]), int(p[2]), int(p[3]), int(p[4]), int(p[5]),
           int(p[6]), int(p[7]), int(p[8]), int(p[9]), int(p[10]))
    except ValueError:
        continue
    rows.append(r)
print(f'realtime-samples={len(rows)}')
if len(rows) < 1200:
    print('HARNESS_INVALID: insufficient realtime samples',file=sys.stderr); sys.exit(30)
nums=[r[0] for r in rows]
if any(b <= a for a,b in zip(nums,nums[1:])):
    print('HARNESS_INVALID: non-monotonic sample numbering',file=sys.stderr); sys.exit(31)
if int(float(os.environ.get('OVERRUNS','-1'))) != 0:
    print('HARNESS_INVALID: sampler overruns nonzero',file=sys.stderr); sys.exit(32)
by={k:[r for r in rows if r[1]==k] for k in range(7)}
for k,v in by.items(): print(f'phase-{k}-samples={len(v)}')
if any(len(by[k]) < 150 for k in range(7)):
    print('HARNESS_INVALID: missing decisive phase',file=sys.stderr); sys.exit(33)

checks=[]
def gate(name,ok,detail=''):
    print(f'gate-{name}={"PASS" if ok else "FAIL"}{(" "+detail) if detail else ""}')
    checks.append(ok)

# C baseline: no faults and both low-level service counters advance.
p0=by[0]
gate('A',True,'pinned SHA/patch/topology retained; generic source hashes unchanged')
gate('B',True,'single atomic realtime stream retained; monotonic samples; zero overruns')
gate('C', all(r[4]==0 and r[5]==0 for r in p0[-150:]) and p0[-1][6]>p0[-150][6] and p0[-1][8]>p0[-150][8])

# D transient: at least one failed read occurred, success resumes, no watchdog event.
p1=by[1]
gate('D', p1[-1][7] > p1[0][7] and p1[-1][6] > p1[0][6] and all(r[5]==0 for r in p1))

# E escalation: io_error becomes true with watchdog clear; service counters freeze afterwards.
p2=by[2]
true_idx=next((i for i,r in enumerate(p2) if r[4]==1),None)
e_ok=False
if true_idx is not None:
    tail=p2[true_idx+5:]
    if len(tail)>=20:
        e_ok=(all(r[2]>=0 and r[3]==0 and r[5]==0 and r[10]==0 for r in tail) and
              len({r[6] for r in tail})==1 and len({r[8] for r in tail})==1)
gate('E',e_ok)

# F communication recovery: io_error clears, watchdog stays false, read/write service advances.
p3=by[3]
gate('F', all(r[4]==0 and r[5]==0 for r in p3[-150:]) and p3[-1][6]>p3[-150][6] and p3[-1][8]>p3[-150][8])

# G watchdog bite/hold with healthy transport and no io_error.
p4,p5=by[4],by[5]
g_ok=(any(r[3]==1 and r[4]==0 and r[5]==1 and r[10]==1 for r in p4) and
      all(r[4]==0 and r[5]==1 for r in p5[-150:]))
gate('G',g_ok)

# H explicit has-bit/status clear with healthy service resumption.
p6=by[6]
h_ok=(all(r[3]==0 and r[4]==0 and r[5]==0 and r[10]==0 for r in p6[-150:]) and
      p6[-1][6]>p6[-150][6] and p6[-1][8]>p6[-150][8])
gate('H',h_ok,'transport recovery != watchdog recovery != proof of physical safe state')

print('interpretation-boundary=packet/read error != watchdog bite; io_error != necessarily watchdog.has_bit; transport recovery != watchdog recovery != proof of physical safe state; ordinary HostMot2/HAL fault handling != functional-safety certification')
if not all(checks):
    print('C06-030 overall=BEHAVIORAL_FAIL'); sys.exit(41)
print('C06-030 overall=PASS')
PY

printf '%s\n' 'C06-030 authoritative run complete.'
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
