#!/usr/bin/env bash
set -euo pipefail

# C06-030 attempt 2. This wrapper preserves attempt-1 exactly and applies only
# the source-grounded HAL opaque-reference correction documented in
# results/C06-033-attempt-1-reconciliation.md. Frozen Gates A-H / P0-P6 are
# not changed.
ROOT="${GITHUB_WORKSPACE:-$PWD}"
BASE="$ROOT/lab-jobs/033-c06-transport-watchdog-authoritative.sh"
FIXED="${RUNNER_TEMP:-/tmp}/c06-030-attempt2.sh"
cp "$BASE" "$FIXED"

python3 - "$FIXED" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
repls={
'''static hal_u32_t *c06_fail_reads_remaining;''':'''static hal_uint_t c06_fail_reads_remaining;''',
'''static hal_bit_t *c06_watchdog_status_command;''':'''static hal_bool_t c06_watchdog_status_command;''',
'''static hal_u32_t *c06_read_success_count;''':'''static hal_uint_t c06_read_success_count;''',
'''static hal_u32_t *c06_read_fail_count;''':'''static hal_uint_t c06_read_fail_count;''',
'''static hal_u32_t *c06_write_success_count;''':'''static hal_uint_t c06_write_success_count;''',
'''static hal_u32_t *c06_consecutive_failures;''':'''static hal_uint_t c06_consecutive_failures;''',
'''static hal_bit_t *c06_io_error_mirror;''':'''static hal_bool_t c06_io_error_mirror;''',
'''static hal_bit_t *c06_watchdog_status_mirror;''':'''static hal_bool_t c06_watchdog_status_mirror;''',
'''if (*c06_fail_reads_remaining > 0) {''':'''if (hal_get_uint(c06_fail_reads_remaining) > 0) {''',
'''(*c06_fail_reads_remaining)--;''':'''hal_set_uint(c06_fail_reads_remaining, hal_get_uint(c06_fail_reads_remaining) - 1);''',
'''(*c06_read_fail_count)++;''':'''hal_set_uint(c06_read_fail_count, hal_get_uint(c06_read_fail_count) + 1);''',
'''(*c06_consecutive_failures)++;''':'''hal_set_uint(c06_consecutive_failures, hal_get_uint(c06_consecutive_failures) + 1);''',
'''if (*c06_consecutive_failures >= C06_IO_ERROR_THRESHOLD && this->io_error != NULL) {''':'''if (hal_get_uint(c06_consecutive_failures) >= C06_IO_ERROR_THRESHOLD && this->io_error != NULL) {''',
'''*(this->io_error) = 1;''':'''hal_set_bool(*this->io_error, 1);''',
'''if (this->io_error != NULL) *c06_io_error_mirror = *(this->io_error);''':'''if (this->io_error != NULL) hal_set_bool(c06_io_error_mirror, hal_get_bool(*this->io_error));''',
'''*c06_consecutive_failures = 0;''':'''hal_set_uint(c06_consecutive_failures, 0);''',
'''if (c06_watchdog_status_command != NULL && *c06_watchdog_status_command) {''':'''if (c06_watchdog_status_command != NULL && hal_get_bool(c06_watchdog_status_command)) {''',
'''*c06_watchdog_status_mirror = 1;''':'''hal_set_bool(c06_watchdog_status_mirror, 1);''',
'''*c06_watchdog_status_mirror = 0;''':'''hal_set_bool(c06_watchdog_status_mirror, 0);''',
'''(*c06_read_success_count)++;''':'''hal_set_uint(c06_read_success_count, hal_get_uint(c06_read_success_count) + 1);''',
'''(*c06_write_success_count)++;''':'''hal_set_uint(c06_write_success_count, hal_get_uint(c06_write_success_count) + 1);''',
'''r = hal_pin_u32_newf(HAL_IO, &c06_fail_reads_remaining, comp_id, "hm2_test.0.c06.fail-reads-remaining");''':'''r = hal_pin_new_ui32(comp_id, HAL_IO, &c06_fail_reads_remaining, 0, "hm2_test.0.c06.fail-reads-remaining");''',
'''r = hal_pin_bit_newf(HAL_IN, &c06_watchdog_status_command, comp_id, "hm2_test.0.c06.watchdog-status-command");''':'''r = hal_pin_new_bool(comp_id, HAL_IN, &c06_watchdog_status_command, 0, "hm2_test.0.c06.watchdog-status-command");''',
'''r = hal_pin_u32_newf(HAL_OUT, &c06_read_success_count, comp_id, "hm2_test.0.c06.read-success-count");''':'''r = hal_pin_new_ui32(comp_id, HAL_OUT, &c06_read_success_count, 0, "hm2_test.0.c06.read-success-count");''',
'''r = hal_pin_u32_newf(HAL_OUT, &c06_read_fail_count, comp_id, "hm2_test.0.c06.read-fail-count");''':'''r = hal_pin_new_ui32(comp_id, HAL_OUT, &c06_read_fail_count, 0, "hm2_test.0.c06.read-fail-count");''',
'''r = hal_pin_u32_newf(HAL_OUT, &c06_write_success_count, comp_id, "hm2_test.0.c06.write-success-count");''':'''r = hal_pin_new_ui32(comp_id, HAL_OUT, &c06_write_success_count, 0, "hm2_test.0.c06.write-success-count");''',
'''r = hal_pin_u32_newf(HAL_OUT, &c06_consecutive_failures, comp_id, "hm2_test.0.c06.consecutive-failures");''':'''r = hal_pin_new_ui32(comp_id, HAL_OUT, &c06_consecutive_failures, 0, "hm2_test.0.c06.consecutive-failures");''',
'''r = hal_pin_bit_newf(HAL_OUT, &c06_io_error_mirror, comp_id, "hm2_test.0.c06.io-error-mirror");''':'''r = hal_pin_new_bool(comp_id, HAL_OUT, &c06_io_error_mirror, 0, "hm2_test.0.c06.io-error-mirror");''',
'''r = hal_pin_bit_newf(HAL_OUT, &c06_watchdog_status_mirror, comp_id, "hm2_test.0.c06.watchdog-status-mirror");''':'''r = hal_pin_new_bool(comp_id, HAL_OUT, &c06_watchdog_status_mirror, 0, "hm2_test.0.c06.watchdog-status-mirror");''',
'''*c06_fail_reads_remaining = 0;''':'''hal_set_uint(c06_fail_reads_remaining, 0);''',
'''*c06_watchdog_status_command = 0;''':'''hal_set_bool(c06_watchdog_status_command, 0);''',
'''*c06_read_success_count = 0;''':'''hal_set_uint(c06_read_success_count, 0);''',
'''*c06_read_fail_count = 0;''':'''hal_set_uint(c06_read_fail_count, 0);''',
'''*c06_write_success_count = 0;''':'''hal_set_uint(c06_write_success_count, 0);''',
'''*c06_io_error_mirror = 0;''':'''hal_set_bool(c06_io_error_mirror, 0);''',
}
for old,new in repls.items():
    n=s.count(old)
    if n == 0:
        raise SystemExit(f'HARNESS_INVALID: expected attempt-1 source token missing: {old!r}')
    s=s.replace(old,new)
# The consecutive-failure initializer appears once but was transformed above.
# Guard against any legacy lab-only value dereference or direct opaque io_error assignment.
for bad in ('static hal_u32_t *c06_', 'static hal_bit_t *c06_', '*(this->io_error) =', '(*c06_'):
    if bad in s:
        raise SystemExit(f'HARNESS_INVALID: legacy HAL access remains after correction: {bad}')
p.write_text(s)
PY

chmod +x "$FIXED"
printf 'C06-030 attempt-2 correction: opaque HAL refs/getters/setters only; frozen Gates A-H unchanged.\n'
exec bash "$FIXED"
