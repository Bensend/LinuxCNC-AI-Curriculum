# C06-030 Authoritative Attempt 1 Reconciliation

Date: 2026-09-09
Workflow: `34298423081`
Job: `102299966701`
Artifact: `10084069925`
Head commit: `77a274b1275cea22dd3f8df63c866b20ba4c4c40`
Final classification: **HARNESS INVALID — no behavioral gate scored**

## What happened

The pinned LinuxCNC checkout built successfully and the workflow retained the fixture patch, build log, HAL configuration, stderr/stdout, source hashes, and exit code. The run then failed before P0 because the lab-only `hm2_test` control pins were exported with the deprecated pointer API against a pinned HAL revision whose current pin/parameter representation uses opaque getter/setter references.

The compiler already exposed the mismatch: the lab patch declared deprecated `hal_u32_t *` / `hal_bit_t *` objects, while `hostmot2-lowlevel.h` declares `io_error` as a pointer to an opaque `hal_bool_t` reference. It also warned that direct assignment through `this->io_error` was assigning an integer to an opaque pointer type.

At load, HAL rejected the first legacy exported control with:

```text
HAL: ERROR: data_ptr_addr not in shared memory
hm2_test: rtapi_app_main: Invalid argument (-22)
```

Because `hm2_test` never became ready, `hm2_test.0.read`, `.write`, all C06 lab pins, the real generic `hm2_test.0.io_error`, and the real watchdog pins were unavailable. The harness readiness check therefore ended with:

```text
HARNESS_INVALID: HAL runtime not ready
```

## Why this is not C06 behavioral evidence

No P0 baseline was established, no realtime sampler stream began, no transient read failure was injected, no `io_error` escalation was observed, and no watchdog status bit was injected or processed. Therefore frozen C06-030 Gates A–H remain **UNSCORED**. This attempt cannot support or contradict the frozen transport-vs-watchdog prediction.

## Source-grounded correction

Pinned `hal.h` defines the current opaque reference types `hal_bool_t` and `hal_uint_t`, provides `hal_pin_new_bool()` / `hal_pin_new_ui32()`, and requires `hal_get_bool()` / `hal_set_bool()` and `hal_get_uint()` / `hal_set_uint()` for value access. Pinned `hostmot2-lowlevel.h` explicitly defines `io_error` as `hal_bool_t *` and states that the low-level driver sets it while users may clear the generic HAL parameter.

Attempt 2 may therefore change only the lab fixture access mechanics:

- replace deprecated C06 `hal_bit_t *` / `hal_u32_t *` controls with opaque `hal_bool_t` / `hal_uint_t` references;
- export them with `hal_pin_new_bool()` / `hal_pin_new_ui32()`;
- access them only with `hal_get_*()` / `hal_set_*()`;
- assert the real generic I/O error with `hal_set_bool(*this->io_error, 1)` rather than direct pointer assignment.

No frozen Gate A–H condition, P0–P6 meaning, threshold, prediction, watchdog register address, source-integrity requirement, or interpretation boundary is changed.

## Additional preflight correction before attempt 2

Pinned `watchdog.c` exports `watchdog.has_bit` as a `HAL_IO` pin and its recovery path explicitly says it waits for the user to clear that bit; once clear and transport is healthy, `hm2_watchdog_write()` performs the reset/force-write recovery and clears `needs_reset`. Attempt 2 must therefore use the ordinary HAL-visible `has_bit` clear semantics without bypassing generic watchdog logic. If sampling topology makes the `HAL_IO` value non-writable from userspace, that is a harness-topology issue to resolve without modifying `watchdog.c` or weakening Gate H.

## Frozen status

C06-030 remains frozen. Attempt 1 is retained permanently as a harness-invalid construction attempt; it must not be deleted, relabeled as behavioral failure, or used to retune the experiment.
