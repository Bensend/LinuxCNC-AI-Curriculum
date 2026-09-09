#!/usr/bin/env bash
set -euo pipefail

# C06-030 authoritative attempt 3. Preserve attempt-2 behavior and change only
# the demonstrated HAL construction defect: opaque reference storage must live
# in HAL shared memory. Frozen P0-P6 and Gates A-H remain unchanged.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/034-c06-transport-watchdog-authoritative-api-fix.sh"
WRAPPED="${RUNNER_TEMP:-/tmp}/c06-030-attempt3-wrapper.sh"
cp "$BASE" "$WRAPPED"

python3 - "$WRAPPED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
needle='''chmod +x "$FIXED"\nprintf 'C06-030 attempt-2 correction: opaque HAL refs/getters/setters only; frozen Gates A-H unchanged.\\n'\nexec bash "$FIXED"\n'''
insert='''chmod +x "$FIXED"\nprintf 'C06-030 attempt-2 correction: opaque HAL refs/getters/setters only; frozen Gates A-H unchanged.\\n'\n\n# Attempt-3-only construction correction: after attempt 2 generates its fixed\n# lab script, move the eight opaque HAL reference slots from file-scope C\n# storage into one hal_malloc() allocation. No behavioral phase/gate changes.\npython3 - "$FIXED" <<'PY3'\nfrom pathlib import Path\nimport sys\np=Path(sys.argv[1])\ns=p.read_text()\nold='''static hal_uint_t c06_fail_reads_remaining;\nstatic hal_bool_t c06_watchdog_status_command;\nstatic hal_uint_t c06_read_success_count;\nstatic hal_uint_t c06_read_fail_count;\nstatic hal_uint_t c06_write_success_count;\nstatic hal_uint_t c06_consecutive_failures;\nstatic hal_bool_t c06_io_error_mirror;\nstatic hal_bool_t c06_watchdog_status_mirror;'''
new='''typedef struct {\n    hal_uint_t fail_reads_remaining;\n    hal_bool_t watchdog_status_command;\n    hal_uint_t read_success_count;\n    hal_uint_t read_fail_count;\n    hal_uint_t write_success_count;\n    hal_uint_t consecutive_failures;\n    hal_bool_t io_error_mirror;\n    hal_bool_t watchdog_status_mirror;\n} c06_hal_refs_t;\nstatic c06_hal_refs_t *c06_hal;'''
if s.count(old) != 1:\n    raise SystemExit('HARNESS_INVALID: attempt-2 static reference block not found exactly once')\ns=s.replace(old,new)\nrepls={\n'c06_fail_reads_remaining':'c06_hal->fail_reads_remaining',\n'c06_watchdog_status_command':'c06_hal->watchdog_status_command',\n'c06_read_success_count':'c06_hal->read_success_count',\n'c06_read_fail_count':'c06_hal->read_fail_count',\n'c06_write_success_count':'c06_hal->write_success_count',\n'c06_consecutive_failures':'c06_hal->consecutive_failures',\n'c06_io_error_mirror':'c06_hal->io_error_mirror',\n'c06_watchdog_status_mirror':'c06_hal->watchdog_status_mirror',\n}\nfor oldname,newname in repls.items():\n    s=s.replace(oldname,newname)\nanchor='''    if (test_pattern == 15) {\n        r = hal_pin_new_ui32(comp_id, HAL_IO, &c06_hal->fail_reads_remaining, 0, "hm2_test.0.c06.fail-reads-remaining");'''
replacement='''    if (test_pattern == 15) {\n        c06_hal = hal_malloc(sizeof(*c06_hal));\n        if (c06_hal == NULL) return -ENOMEM;\n        r = hal_pin_new_ui32(comp_id, HAL_IO, &c06_hal->fail_reads_remaining, 0, "hm2_test.0.c06.fail-reads-remaining");'''
if s.count(anchor) != 1:\n    raise SystemExit('HARNESS_INVALID: attempt-2 pin-export anchor not found exactly once')\ns=s.replace(anchor,replacement)\n# Construction invariants: no standalone static opaque-ref slots and all eight\n# pin export addresses must be fields of the hal_malloc-backed structure.\nfor bad in ('static hal_uint_t c06_', 'static hal_bool_t c06_'):\n    if bad in s:\n        raise SystemExit(f'HARNESS_INVALID: non-shared reference storage remains: {bad}')\nif s.count('&c06_hal->') < 8:\n    raise SystemExit('HARNESS_INVALID: not all C06 reference export addresses use shared structure fields')\np.write_text(s)\nPY3\n\nprintf 'C06-030 attempt-3 correction: lab-only opaque HAL reference slots allocated with hal_malloc(); frozen Gates A-H unchanged.\\n'\nexec bash "$FIXED"\n'''
if s.count(needle) != 1:
    raise SystemExit('HARNESS_INVALID: attempt-2 wrapper tail not found exactly once')
s=s.replace(needle,insert)
p.write_text(s)
PY

chmod +x "$WRAPPED"
exec bash "$WRAPPED"
