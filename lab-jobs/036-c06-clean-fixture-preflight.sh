#!/usr/bin/env bash
set -euo pipefail

# C06 clean-fixture redesign preflight.
# NON-AUTHORITATIVE: compile/load/object proof only. Do not score C06-030 P0-P6 or Gates A-H here.
UPSTREAM="https://github.com/LinuxCNC/linuxcnc.git"
PINNED="8bf4605ae81042248add031e94c77300406e0413"
WORK="${RUNNER_TEMP:-/tmp}/linuxcnc-c06-clean-preflight"
ROOT="${GITHUB_WORKSPACE:-$PWD}"
RUN_EVID="$ROOT/lab-results/run-${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
mkdir -p "$RUN_EVID"

printf '== C06 clean standalone hm2_test pattern-15 preflight ==\n'
date -u '+UTC start: %Y-%m-%dT%H:%M:%SZ'
printf 'Pinned upstream commit: %s\n' "$PINNED"
printf '%s\n' 'NON-AUTHORITATIVE: compile/load/object proof only; frozen C06-030 behavioral gates remain unscored.'

sudo apt-get update
sudo apt-get install -y build-essential git devscripts equivs procps python3
rm -rf "$WORK"
git clone --filter=blob:none "$UPSTREAM" "$WORK"
cd "$WORK"
git checkout --detach "$PINNED"
[[ "$(git rev-parse HEAD)" == "$PINNED" ]] || { echo 'HARNESS_INVALID: pinned checkout mismatch' >&2; exit 20; }

HM2=src/hal/drivers/mesa-hostmot2/hm2_test.c
CORE=src/hal/drivers/mesa-hostmot2/hostmot2.c
TRAM=src/hal/drivers/mesa-hostmot2/tram.c
WD=src/hal/drivers/mesa-hostmot2/watchdog.c
LLIO=src/hal/drivers/mesa-hostmot2/hostmot2-lowlevel.h
sha256sum "$CORE" "$TRAM" "$WD" "$LLIO" | tee "$RUN_EVID/production-source-before.sha256"
sha256sum "$HM2" | tee "$RUN_EVID/hm2-test-upstream.sha256"

python3 - <<'PY'
from pathlib import Path
p=Path('src/hal/drivers/mesa-hostmot2/hm2_test.c')
s=p.read_text()

anchor='''static hm2_test_t board[1];\n'''
insert='''static hm2_test_t board[1];\n\n// C06 lab-only deterministic controls. Opaque HAL handle storage itself must\n// reside in HAL shared memory; c06_hal is allocated with hal_malloc().\ntypedef struct {\n    hal_uint_t fail_reads_remaining;\n    hal_bool_t watchdog_status_command;\n    hal_uint_t read_success_count;\n    hal_uint_t read_fail_count;\n    hal_uint_t write_success_count;\n    hal_uint_t consecutive_failures;\n    hal_bool_t io_error_mirror;\n    hal_bool_t watchdog_status_mirror;\n} c06_hal_refs_t;\nstatic c06_hal_refs_t *c06_hal;\n#define C06_IO_ERROR_THRESHOLD 3\n'''
if s.count(anchor) != 1: raise SystemExit('fixture anchor board[1] not unique')
s=s.replace(anchor,insert,1)

old='''static int hm2_test_read(hm2_lowlevel_io_t *this, rtapi_u32 addr, void *buffer, int size) {\n    hm2_test_t *me = this->private;\n    memcpy(buffer, &me->test_pattern.tp8[addr], size);\n    return 1;  // success\n}\n'''
new='''static int hm2_test_read(hm2_lowlevel_io_t *this, rtapi_u32 addr, void *buffer, int size) {\n    hm2_test_t *me = this->private;\n    if (test_pattern == 15 && c06_hal != NULL) {\n        if (hal_get_uint(c06_hal->fail_reads_remaining) > 0) {\n            hal_set_uint(c06_hal->fail_reads_remaining, hal_get_uint(c06_hal->fail_reads_remaining) - 1);\n            hal_set_uint(c06_hal->read_fail_count, hal_get_uint(c06_hal->read_fail_count) + 1);\n            hal_set_uint(c06_hal->consecutive_failures, hal_get_uint(c06_hal->consecutive_failures) + 1);\n            if (hal_get_uint(c06_hal->consecutive_failures) >= C06_IO_ERROR_THRESHOLD && this->io_error != NULL)\n                hal_set_bool(*this->io_error, 1);\n            if (this->io_error != NULL) hal_set_bool(c06_hal->io_error_mirror, hal_get_bool(*this->io_error));\n            return 0;\n        }\n        hal_set_uint(c06_hal->consecutive_failures, 0);\n        if (hal_get_bool(c06_hal->watchdog_status_command)) {\n            me->test_pattern.tp32[0x2004 / 4] |= 1u;\n            hal_set_bool(c06_hal->watchdog_status_mirror, 1);\n        } else {\n            me->test_pattern.tp32[0x2004 / 4] &= ~1u;\n            hal_set_bool(c06_hal->watchdog_status_mirror, 0);\n        }\n    }\n    memcpy(buffer, &me->test_pattern.tp8[addr], size);\n    if (test_pattern == 15 && c06_hal != NULL) {\n        hal_set_uint(c06_hal->read_success_count, hal_get_uint(c06_hal->read_success_count) + 1);\n        if (this->io_error != NULL) hal_set_bool(c06_hal->io_error_mirror, hal_get_bool(*this->io_error));\n    }\n    return 1;\n}\n'''
if s.count(old) != 1: raise SystemExit('fixture read function anchor not unique')
s=s.replace(old,new,1)

old='''static int hm2_test_write(hm2_lowlevel_io_t *this, rtapi_u32 addr, const void *buffer, int size) {\n    (void)this;\n    (void)addr;\n    (void)buffer;\n    (void)size;\n    return 1;  // success\n}\n'''
new='''static int hm2_test_write(hm2_lowlevel_io_t *this, rtapi_u32 addr, const void *buffer, int size) {\n    (void)this; (void)addr; (void)buffer; (void)size;\n    if (test_pattern == 15 && c06_hal != NULL) {\n        hal_set_uint(c06_hal->write_success_count, hal_get_uint(c06_hal->write_success_count) + 1);\n        if (this->io_error != NULL) hal_set_bool(c06_hal->io_error_mirror, hal_get_bool(*this->io_error));\n    }\n    return 1;\n}\n'''
if s.count(old) != 1: raise SystemExit('fixture write function anchor not unique')
s=s.replace(old,new,1)

needle='''        default: {\n            LL_ERR("unknown test pattern %d", test_pattern);'''
case='''        // C06 lab-only pattern: one valid IOPort plus one valid watchdog.\n        case 15: {\n            int num_io_pins = 24;\n            int pd_index;\n            set32(me, HM2_ADDR_IOCOOKIE, HM2_IOCOOKIE);\n            set8(me, HM2_ADDR_CONFIGNAME+0, 'H'); set8(me, HM2_ADDR_CONFIGNAME+1, 'O');\n            set8(me, HM2_ADDR_CONFIGNAME+2, 'S'); set8(me, HM2_ADDR_CONFIGNAME+3, 'T');\n            set8(me, HM2_ADDR_CONFIGNAME+4, 'M'); set8(me, HM2_ADDR_CONFIGNAME+5, 'O');\n            set8(me, HM2_ADDR_CONFIGNAME+6, 'T'); set8(me, HM2_ADDR_CONFIGNAME+7, '2');\n            set32(me, HM2_ADDR_IDROM_OFFSET, 0x400);\n            set32(me, 0x400, 2); set32(me, 0x404, 0x40); set32(me, 0x408, 0x200);\n            set32(me, 0x41c, 1); set32(me, 0x420, num_io_pins); set32(me, 0x424, 24);\n            set32(me, 0x428, 2000000); set32(me, 0x42c, 20000000);\n            set32(me, 0x430, 4); set32(me, 0x434, 4); set32(me, 0x438, 4); set32(me, 0x43c, 4);\n            set32(me, 0x440, 0x01010003); set32(me, 0x444, 0x00051000); set32(me, 0x448, 0x0000001F);\n            set32(me, 0x44c, 0x01010002); set32(me, 0x450, 0x00032000); set32(me, 0x454, 0x00000000);\n            set32(me, 0x458, 0); set32(me, 0x45c, 0); set32(me, 0x460, 0);\n            me->llio.num_ioport_connectors = 1;\n            me->llio.ioport_connector_name[0] = "P3";\n            for (pd_index = 0; pd_index < num_io_pins; pd_index++) {\n                set8(me, 0x600 + pd_index*4 + 0, 0); set8(me, 0x600 + pd_index*4 + 1, 0);\n                set8(me, 0x600 + pd_index*4 + 2, 0); set8(me, 0x600 + pd_index*4 + 3, HM2_GTAG_IOPORT);\n            }\n            break;\n        }\n\n'''
if s.count(needle) != 1: raise SystemExit('fixture switch default anchor not unique')
s=s.replace(needle,case+needle,1)

anchor2='''    me->llio.read = hm2_test_read;\n    me->llio.write = hm2_test_write;\n\n    r = hm2_register(&board->llio, config[0]);\n'''
export='''    me->llio.read = hm2_test_read;\n    me->llio.write = hm2_test_write;\n\n    if (test_pattern == 15) {\n        c06_hal = hal_malloc(sizeof(*c06_hal));\n        if (c06_hal == NULL) return -ENOMEM;\n        r = hal_pin_new_ui32(comp_id, HAL_IO, &c06_hal->fail_reads_remaining, 0, "hm2_test.0.c06.fail-reads-remaining"); if (r) return r;\n        r = hal_pin_new_bool(comp_id, HAL_IN, &c06_hal->watchdog_status_command, 0, "hm2_test.0.c06.watchdog-status-command"); if (r) return r;\n        r = hal_pin_new_ui32(comp_id, HAL_OUT, &c06_hal->read_success_count, 0, "hm2_test.0.c06.read-success-count"); if (r) return r;\n        r = hal_pin_new_ui32(comp_id, HAL_OUT, &c06_hal->read_fail_count, 0, "hm2_test.0.c06.read-fail-count"); if (r) return r;\n        r = hal_pin_new_ui32(comp_id, HAL_OUT, &c06_hal->write_success_count, 0, "hm2_test.0.c06.write-success-count"); if (r) return r;\n        r = hal_pin_new_ui32(comp_id, HAL_OUT, &c06_hal->consecutive_failures, 0, "hm2_test.0.c06.consecutive-failures"); if (r) return r;\n        r = hal_pin_new_bool(comp_id, HAL_OUT, &c06_hal->io_error_mirror, 0, "hm2_test.0.c06.io-error-mirror"); if (r) return r;\n        r = hal_pin_new_bool(comp_id, HAL_OUT, &c06_hal->watchdog_status_mirror, 0, "hm2_test.0.c06.watchdog-status-mirror"); if (r) return r;\n        hal_set_uint(c06_hal->fail_reads_remaining, 0); hal_set_bool(c06_hal->watchdog_status_command, 0);\n        hal_set_uint(c06_hal->read_success_count, 0); hal_set_uint(c06_hal->read_fail_count, 0);\n        hal_set_uint(c06_hal->write_success_count, 0); hal_set_uint(c06_hal->consecutive_failures, 0);\n        hal_set_bool(c06_hal->io_error_mirror, 0); hal_set_bool(c06_hal->watchdog_status_mirror, 0);\n    }\n\n    r = hm2_register(&board->llio, config[0]);\n'''
if s.count(anchor2) != 1: raise SystemExit('fixture export anchor not unique')
s=s.replace(anchor2,export,1)

p.write_text(s)
PY

git diff -- "$HM2" | tee "$RUN_EVID/c06-clean-hm2test.patch"
[[ -s "$RUN_EVID/c06-clean-hm2test.patch" ]] || { echo 'HARNESS_INVALID: fixture patch missing' >&2; exit 21; }
sha256sum "$HM2" | tee "$RUN_EVID/hm2-test-patched.sha256"
sha256sum "$CORE" "$TRAM" "$WD" "$LLIO" | tee "$RUN_EVID/production-source-after.sha256"
cmp "$RUN_EVID/production-source-before.sha256" "$RUN_EVID/production-source-after.sha256" || { echo 'HARNESS_INVALID: generic HostMot2 source changed' >&2; exit 22; }

# Explicitly prove this is the redesigned construction, not a retired wrapper lineage.
grep -q 'c06_hal = hal_malloc(sizeof(\*c06_hal))' "$HM2" || { echo 'HARNESS_INVALID: missing hal_malloc-backed reference storage' >&2; exit 23; }
! grep -qE 'static hal_(uint|bool)_t c06_' "$HM2" || { echo 'HARNESS_INVALID: file-scope opaque reference slot remains' >&2; exit 24; }

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

cat >/tmp/c06-clean-preflight.hal <<'EOF'
loadrt hostmot2
loadrt hm2_test test_pattern=15
show pin hm2_test.0.c06
show pin hm2_test.0.watchdog
show param hm2_test.0.io_error
show param hm2_test.0.watchdog.timeout_ns
exit
EOF
halrun -f /tmp/c06-clean-preflight.hal 2>&1 | tee "$RUN_EVID/hal-object-proof.txt"

PROOF="$RUN_EVID/hal-object-proof.txt"
for token in \
  hm2_test.0.c06.fail-reads-remaining \
  hm2_test.0.c06.watchdog-status-command \
  hm2_test.0.c06.read-success-count \
  hm2_test.0.c06.read-fail-count \
  hm2_test.0.c06.write-success-count \
  hm2_test.0.c06.consecutive-failures \
  hm2_test.0.c06.io-error-mirror \
  hm2_test.0.c06.watchdog-status-mirror \
  hm2_test.0.watchdog.has_bit \
  hm2_test.0.watchdog.timeout_ns \
  hm2_test.0.io_error; do
    grep -Fq "$token" "$PROOF" || { echo "HARNESS_INVALID: required HAL object missing: $token" >&2; exit 25; }
done

printf '%s\n' 'PREFLIGHT PASS: clean pattern-15 fixture compiled and loaded; all required lab controls plus real io_error/watchdog objects exist.' | tee "$RUN_EVID/preflight-verdict.txt"
printf '%s\n' 'No P0-P6 behavioral phase executed; frozen C06-030 Gates A-H remain unscored.' | tee -a "$RUN_EVID/preflight-verdict.txt"
date -u '+UTC finish: %Y-%m-%dT%H:%M:%SZ'
