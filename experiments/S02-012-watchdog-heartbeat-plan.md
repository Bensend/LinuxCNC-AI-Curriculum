# S02-012 — Generic HAL watchdog heartbeat/freeze/re-arm experiment

LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
Status: PLANNED
Evidence target: independent software/runtime verification of the generic `watchdog(9)` component only.

## Predeclared prediction

With production `watchdog(9)` loaded and both exported functions scheduled, an enabled watchdog with a toggling input will remain OK. Freezing that input longer than its configured countdown will clear `watchdog.ok-out`. Restoring input transitions alone will not recover. `enable-in` must be observed FALSE and then TRUE by `watchdog.set-timeouts` to reload countdown state and re-arm.

## Harness requirements

- Use the pinned LinuxCNC build already produced by the repository lab.
- `loadrt watchdog num_inputs=1`.
- Add `watchdog.process` to a deterministic realtime thread and `watchdog.set-timeouts` to a floating-point-capable servo thread.
- Record actual thread periods and `show funct`/thread ordering before interpreting timing.
- Use one controlled heartbeat writer. Do not leave multiple HAL writers that make freeze injection ambiguous.
- Set a timeout comfortably larger than one scheduling period so a one-cycle phase difference cannot flip the verdict.
- Capture pin state across baseline, freeze, post-freeze-resume-without-rearm, enable-low, and enable-high stages.

## Required gates

1. Initial disabled state: `enable-in=0`, `ok-out=0`.
2. Arming edge: `enable-in 0->1` produces `ok-out=1` after `set-timeouts` executes.
3. Healthy heartbeat: multiple transitions occur and `ok-out` stays 1.
4. Freeze: heartbeat stops transitioning; `ok-out` becomes 0 after timeout budget expires.
5. Latch behavior: restart heartbeat while keeping enable high; require `ok-out` to remain 0.
6. Re-arm: drive enable low, let `set-timeouts` observe low, then drive high; require `ok-out=1` again.
7. No claim of physical stopping time, STO, contactor state, or functional-safety performance.

## Failure classification

- If component/function load or HAL scheduling fails, classify HARNESS INVALID before altering the prediction.
- If wiring/sole-writer evidence is ambiguous, classify HARNESS INVALID.
- If all harness gates are valid but the production component violates the prediction, classify PREDICTION FAILURE and return to source/version analysis.

## Interpretation boundary

PASS would TEST-CONFIRM the software heartbeat timeout/re-arm behavior at the pinned revision in the lab. It would not validate realtime worst-case response on a production PC, external charge-pump electronics, HostMot2 watchdog behavior, drive/STO behavior, or machine safety.
