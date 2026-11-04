# MOTION-216 — HAL execution-time telemetry is not deadline-miss telemetry (4000, non-graduated)
Date: 2026-11-04. Scope: LinuxCNC v2.9.10, source-only.

## Question and result
Can an operator infer that every servo-thread deadline was met from `servo-thread.time`, `servo-thread.tmax`, and per-function `.time/.tmax`? **No.** The inspected HAL loop measures elapsed clock counts around function execution, then calls `rtapi_wait()`. It does not record the interval between the nominal release deadline and actual thread start, nor the return status/overrun count of the wait. A low execution-time maximum is therefore not proof of low release jitter or zero missed deadlines.

## Pinned upstream source
- LinuxCNC v2.9.10 `src/hal/hal_lib.c` [raw source](https://raw.githubusercontent.com/LinuxCNC/linuxcnc/v2.9.10/src/hal/hal_lib.c), lines 1888–1907: exported realtime function `<function>.time` pin (S32), `<function>.tmax` writable parameter, `<function>.tmax-increased` read-only bit parameter.
- Same file lines 2069–2082: thread `<thread>.tmax` writable parameter and `<thread>.time` S32 pin.
- Same file lines 2878–2925: `thread_task` runs functions in list order, measures each call with `rtapi_get_clocks()`, updates per-function maximum and increase flag, calculates thread execution time from first function start through last function end, updates thread maximum, then invokes `rtapi_wait()`.
- No `<thread>.tmax-increased` creation was found in inspected thread creation block. Do not assume symmetry with function telemetry.

**Important units:** Source stores raw `rtapi_get_clocks()` differences in signed 32-bit HAL values. This investigation does not establish a universal nanosecond conversion for all realtime backends; verify backend clock-frequency conversion before attaching units or comparing directly with INI `SERVO_PERIOD`.

## Disconnected worked example
A nominal 1,000,000 ns servo period and an observed execution time of 150,000 ns could coexist with either (A) a thread released on schedule or (B) a release delayed by 1,200,000 ns, because the measured window begins only when `thread_task` actually starts its function calls. Both can report the same `servo-thread.time` and `tmax`. Conversely a measured function maximum exceeding its allotted cycle budget is strong evidence of inadequate execution-time margin but does not by itself identify *which* backend release or network operation caused the delay.

## Reproducible inspection exercise (no machine)
1. Fetch pinned `hal_lib.c` and locate `hal_export_funct`, `hal_create_thread`, and `thread_task`.
2. Write a two-function HAL execution trace: function A takes 20 clock ticks, B takes 30; the thread's measured time is 50 ticks if no intervening overhead, while actual measurement includes dispatch/measurement overhead. Record `A.time`, `B.time`, thread `.time`, their maxima and function `.tmax-increased` after a second cycle of 10/40 ticks.
3. Add a hypothetical 100-tick scheduler release delay before A. Predict that the three function/thread execution measurements need not change, despite degraded release latency.
4. For runtime validation only on an authorized isolated LinuxCNC simulator, compare HAL execution-time telemetry with independently timestamped release/start intervals and backend overrun diagnostics. Precommit acceptable drift and timing thresholds; do not claim this source-only exercise has run.

## Diagnostic decision
For a real jitter investigation, capture separately: (1) HAL execution-time peaks, (2) scheduling release latency / missed periods from a backend-specific observable, (3) HostMot2/EtherCAT communication state and feedback freshness, and (4) following error. Do not substitute any one for the others. No HAL execution-time pin alone establishes fresh feedback, physical position, or personnel safety.

## Evidence ledger
- SOURCE-CONFIRMED: exported pin/parameter names, timing window, max-update logic, function `tmax-increased`, wait placement.
- ANALYTICAL: same execution time despite differing pre-function release delay.
- NOT VERIFIED: actual backend scheduling jitter, clock units, user-visible overrun pins, network timing, numerical traces, hardware behavior.
- TEST-CONFIRMED: none. No builds, simulations, Actions jobs or machine operation. No new laboratory compute; historical lab ledger consulted.
- Gates: 4000 NON-GRADUATED; independent safety authority, blind evaluator separation and physical-machine restrictions preserved.

## Next discriminating question
Locate the **actual realtime backend** `rtapi_wait()` and timing-status implementation in a pinned LinuxCNC version. Establish whether an overrun increments a counter, emits a diagnostic, or simply catches up; contrast PREEMPT_RT and other supported backends only with source. If backend implementation is unavailable, rotate to pinned EtherCAT working-counter/operational-state handling rather than assuming a pin name.
