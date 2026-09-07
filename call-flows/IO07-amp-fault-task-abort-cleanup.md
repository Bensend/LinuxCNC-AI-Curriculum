# IO07 — amplifier fault through Task-state abort cleanup

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Evidence: SOURCE-CONFIRMED; experiment cross-check pending corrected lab 010 attempt 2.

## Why this flow matters

The immediate motion-controller path and the later Task lifecycle expose different snapshots. A clean amplifier fault can publish `joint.N.error=TRUE` during the servo invocation that detects the fault, but a userspace observer may later see `joint.N.faulted=TRUE` while `joint.N.error=FALSE`. That is not inherently contradictory.

## Cross-boundary flow

1. **Motion servo cycle:** `process_inputs()` samples `joint.N.amp-fault-in` and sets JOINT_FAULT.
2. **Motion servo cycle:** for an active+enabled joint, `check_for_faults()` reports the amplifier fault, sets JOINT_ERROR, and clears `emcmotInternal->enabling`.
3. **Same motion servo invocation:** `set_operating_mode()` disables active joints and clears MOTION_ENABLE without clearing JOINT_ERROR.
4. **Same motion servo invocation:** `output_to_hal()` publishes `faulted=TRUE`, `error=TRUE`, `amp-enable-out=FALSE`, and `motion.motion-enabled=FALSE`.
5. **Task/userspace update:** Task derives state from subsystem status. `determineState()` returns `ESTOP_RESET` whenever I/O is out of estop but `emcStatus->motion.traj.enabled` is false.
6. **Task ON→not-ON transition:** `emcTaskUpdate()` detects that its previous state was ON and the newly derived state is not ON. It calls `emcTaskAbort()` (and spindle/I/O abort helpers).
7. **Task→motion command:** `emcTaskAbort()` calls `emcMotionAbort()`, which sends the motion `EMCMOT_ABORT` command through the normal Task/motion command boundary.
8. **Motion command handler:** the `EMCMOT_ABORT` case clears JOINT_ERROR and JOINT_FAULT flags as part of abort cleanup.
9. **Subsequent servo input sample:** if the external amplifier-fault input is still TRUE, `process_inputs()` sets JOINT_FAULT again.
10. **Subsequent fault check:** the joint is disabled, and `check_for_faults()` only evaluates active **and enabled** joints, so it does not set JOINT_ERROR again merely because the sampled fault input remains TRUE.
11. **Later HAL snapshot:** a delayed observer can therefore legitimately see `faulted=TRUE`, `error=FALSE`, `motion.motion-enabled=FALSE`, and `amp-enable-out=FALSE`.

## Diagnostic implication

`joint.N.error` is not a durable historical record of every earlier amplifier-fault cycle. For cycle-level causality, use a realtime recorder such as `sampler`/Halscope placed after motion in the relevant thread. For later diagnosis, combine current `faulted`/enable state with LinuxCNC's error channel/log and the Task/motion lifecycle rather than treating one asynchronously sampled HAL bit as the whole history.

## Safety boundary

Neither the immediate disable path nor Task's subsequent abort cleanup establishes that a physical amplifier removed torque. This remains ordinary LinuxCNC software state handling. Downstream transport, device behavior, STO, stored energy, reaction time, and functional-safety validation are separate evidence domains.
