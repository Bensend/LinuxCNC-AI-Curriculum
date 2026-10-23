# 4400 source reasoning card — Held reset at the first HAL cycle

**Learner-facing practice, not blind evaluation and not a live safety test.** Pinned source: LinuxCNC `v2.9.10`, `src/hal/components/estop_latch.comp` and `src/hal/utils/halcompile.g`.

A LinuxCNC retrofit ties a reset input HIGH before `estop_latch` executes for the first time. Its `ok_in` is TRUE, `fault_in` FALSE. The operator did not newly press a reset button after the software component started. A developer argues that `estop_latch` requires a rising edge, so its `ok_out` must remain FALSE.

**Tasks:** (1) trace the component's `old_reset` allocation/initialization and first invocation; (2) predict `ok_out`, `fault_out` and watchdog under these exact inputs; (3) distinguish software history edge from independently verified deliberate human reset; (4) explain why `iocontrol.0.emc-enable-in` cannot be credited as a physical final-element witness; (5) propose an independent safety authority and separate ordinary start while retaining LinuxCNC diagnostics; (6) identify which selected-machine facts remain UNKNOWN.

**Review discriminator:** The generator zeroes instance data, so `old_reset=0`; first `reset=1` satisfies `reset && !old_reset` and `ok_out` becomes TRUE under the stated `ok_in/fault_in` conditions. This is a **SOURCE-CONFIRMED software behavior**, not a claim that an actual machine energizes or that an external safety controller accepts the reset. The appropriate correction is an independent safety-related reset/rearm/anti-restart design with machine-level physical evidence, not an assumption that HAL's software edge is a safety-certified manual-reset witness.
