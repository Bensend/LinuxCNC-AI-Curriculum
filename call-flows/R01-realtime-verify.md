# R01 — `realtime verify` capability-classification call flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

This note closes an experiment-harness ambiguity discovered by R01 lab run `34008620114`. The first version of `005-r01-realtime-boundaries.sh` invoked `realtime check`, but the public wrapper at the pinned revision accepts `verify`, not `check`. The failed run is therefore **HARNESS INVALID** and cannot be used as scheduler evidence.

## Public wrapper call flow

For a run-in-place uspace build:

1. `scripts/realtime verify` enters the `verify)` case in `scripts/realtime.in`.
2. `CheckConfig` loads the generated `rtapi.conf`, including `RTPREFIX=uspace`.
3. `Verify()` executes `rtapi_app check_rt && HAS_REALTIME=true`.
4. The wrapper exits `0` only when `HAS_REALTIME=true`; otherwise it exits nonzero.

The nonzero status is therefore an expected semantic result when the host is classified `REALTIME_TYPE_NONE`. It is not, by itself, a wrapper execution failure.

## `rtapi_app check_rt` call flow

At the pinned revision, `rtapi_app` dispatches the one-token `check_rt` command to `do_check_rt_cmd(out)`.

`do_check_rt_cmd()`:

- calls `rtapi_get_realtime_type()`;
- writes `realtime_type_name(type)` into the output string; and
- returns true/nonzero when `rtapi_is_realtime() == 0`.

The command-line dispatch prints the output string before returning that status.

For `REALTIME_TYPE_NONE`, `realtime_type_name()` returns exactly `No realtime`.

Therefore the bounded lab can distinguish the predicted fallback path using **both** observations:

- `realtime verify` returns nonzero; and
- its output contains `No realtime` (or a source-grounded accompanying non-realtime diagnostic).

A nonzero status without a recognized classification string is not sufficient and must fail closed.

## Capability probe beneath classification

`rtapi_get_realtime_type()` first attempts an actual `SCHED_FIFO` transition through `can_set_sched_fifo()` unless `LINUXCNC_FORCE_REALTIME` is set. If that probe fails, the cached type is immediately set to `REALTIME_TYPE_NONE`.

Thus `realtime verify` is stronger evidence than reading the kernel name or checking whether `rtapi_app` merely exists. It observes LinuxCNC's own process-level capability classification for the executing binary/environment.

It still does **not** prove:

- acceptable latency or jitter;
- PREEMPT_RT suitability of a physical controller;
- deadline compliance under machine load;
- successful memory locking on the non-realtime path; or
- that a later-created periodic pthread actually obtained the scheduler policy implied by the classification.

Those require separate observations.

## Backend consequence

At the same pinned revision, `makeApp()` selects `liblinuxcnc-uspace-posix.so.0` with `SCHED_OTHER` directly when the type is `REALTIME_TYPE_NONE`. The realtime hardening path is skipped in that branch.

R01 therefore treats the following as separate assertions:

1. **Classification:** `realtime verify` reports `No realtime` and returns nonzero.
2. **Backend expectation:** source says `REALTIME_TYPE_NONE` selects the POSIX backend with `SCHED_OTHER`.
3. **Runtime scheduler verification:** inspect the created RTAPI periodic pthreads with the OS and independently confirm they are not FIFO/RR.
4. **Period verification:** inspect HAL's actual thread report rather than infer periods from requested values.

Only agreement among these layers may be promoted to `TEST-CONFIRMED` for the lab environment.

## Harness correction

Commit `ac479678abec2e4933447b1d5d03eb51c7569fc6` changes only the capability-classification invocation/labels from `realtime check` to `realtime verify`, preserves explicit expected-nonzero capture, and keeps the fail-closed classification grep.

The corrected push launched exactly one workflow run, `34011177375`. Its result must be inspected by run ID and source SHA before any R01 runtime claim is promoted.
