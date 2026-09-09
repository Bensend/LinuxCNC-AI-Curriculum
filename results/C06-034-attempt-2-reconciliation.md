# C06-030 Attempt 2 Reconciliation

Classification: **HARNESS INVALID before P0**

Workflow: `34299295015`
Job: `102302593867`
Artifact: `10084380381` (`linuxcnc-lab-034-c06-transport-watchdog-authoritative-api-fix-34299295015-1`)
Curriculum source commit: `994f452da0a599d13e4d41ce560c977dabe216be`
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Inner lab UTC: `2026-09-09T01:28:03Z` to `2026-09-09T01:31:11Z`
Inner exit code: `24`

## Evidence retained

The artifact retains metadata, complete stdout/stderr, build log, HAL configuration, the exact `c06-hm2test.patch`, production-source hashes, HAL-run stdout/stderr, and exit code. The outer GitHub Actions job concluded success because the runner deliberately captures the inner result before the workflow's final status handling; the authoritative classification is based on the retained inner evidence, not the outer job badge.

The build completed, but `hm2_test` failed during HAL object export before the realtime fixture became ready:

```text
HAL: ERROR: data_ptr_addr not in shared memory
hm2_test: rtapi_app_main: Invalid argument (-22)
HARNESS_INVALID: HAL runtime not ready
```

No P0-P6 phase executed. Frozen Gates A-H therefore remain **UNSCORED**. This result cannot falsify the frozen behavioral prediction.

## Root cause

Attempt 1 correctly revealed that the pinned revision uses opaque HAL references rather than the legacy direct data-pointer API. Attempt 2 switched the lab-only objects to `hal_uint_t` / `hal_bool_t`, `hal_pin_new_*()`, and `hal_get_*()` / `hal_set_*()`, but it left the reference-storage variables as C file-scope statics.

That is still invalid at this pinned HAL revision. `hal_pin_new_*()` stores the HAL reference through the address supplied as its third argument, and that address must itself reside in HAL shared memory. Pinned `hal.h` documents that `hal_malloc()` allocates from the main HAL shared-memory area and should be used by components for HAL pin/parameter storage. The emitted error is the runtime enforcement of that contract.

Thus the previous correction fixed **reference semantics** but not **reference-storage location**.

## Attempt-control decision

This is the second C06-030 authoritative attempt and the second pre-P0 harness failure. A third attempt is technically justified because the failure is now source-isolated to one narrow, non-behavioral construction defect: move only the lab control/observation reference fields into one `hal_malloc()`-allocated structure. Do not alter the frozen P0-P6 phases, failure threshold, watchdog status address/bit, sampler fields, Gates A-H, or production HostMot2 sources.

If attempt 3 fails for another construction/sampling defect before valid behavioral evidence, invoke the curriculum three-attempt rule rather than continuing incremental harness tuning.

## Verification target for attempt 3

Before accepting any behavioral result, prove:

1. the lab-only reference-storage structure is allocated with `hal_malloc()` after HAL initialization;
2. each `hal_pin_new_*()` receives the address of a field inside that shared-memory allocation;
3. lab code accesses values only via `hal_get_*()` / `hal_set_*()` opaque-reference operations;
4. `hostmot2.c`, `tram.c`, and `watchdog.c` remain byte-identical to the pinned checkout;
5. the fixture reaches P0 and retains the atomic trace before Gates A-H are scored.
