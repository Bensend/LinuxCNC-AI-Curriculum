# IO07 lab 010 — attempt 1 diagnosis

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Workflow run: `34075640467`  
Curriculum source commit: `7afcdff5a5fb12e082aee8477827a1c491795f63`  
Lab result: exit `1`, fresh result generated `2026-09-07T02:14:44Z`–`02:19:27Z`

## Observed evidence

Attempt 1 established a valid enabled baseline:

- `motion.motion-enabled=TRUE`
- `joint.0.amp-enable-out=TRUE`
- `joint.0.amp-fault-in=FALSE`
- the named `io07-amp-fault` signal was shown with sole writer `or2.0.out` and receiver `joint.0.amp-fault-in`.

After setting `or2.0.in0=1`, the signal and destination became TRUE. The asynchronous HAL poll then observed:

- `joint.0.faulted=TRUE`
- `joint.0.error=FALSE`
- `motion.motion-enabled=FALSE`
- `joint.0.amp-enable-out=FALSE`

The job failed because attempt 1 incorrectly required `joint.0.error` to remain TRUE long enough for a userspace `halcmd getp` polling loop. It stopped before its diagnostic-capture section.

## Source reconciliation

Pinned `control.c` is unambiguous about the controller invocation that samples an active+enabled amplifier fault: `check_for_faults()` reports `joint %d amplifier fault`, executes `SET_JOINT_ERROR_FLAG(joint, 1)`, and clears `emcmotInternal->enabling`. `set_operating_mode()` then disables the joint and motion and explicitly does **not** clear the joint error during that disable transition. `output_to_hal()` publishes both the error and fault flags later in the same `emcmotController()` invocation.

The later asynchronous `faulted=TRUE, error=FALSE` snapshot is also source-explainable, but through the Task/abort path rather than an immediate re-enable:

1. After motion disables, pinned Task `determineState()` returns `ESTOP_RESET` when I/O is out of estop but `emcStatus->motion.traj.enabled` is false.
2. `emcTaskUpdate()` compares the previous Task state with that derived state. On `ON -> not ON`, it calls `emcTaskAbort()`.
3. `emcTaskAbort()` calls the motion abort interface, producing an `EMCMOT_ABORT` command.
4. Pinned `command.c` handles `EMCMOT_ABORT` by clearing JOINT_ERROR and JOINT_FAULT flags for all joints as part of abort cleanup.
5. Because the physical/synthetic amplifier-fault HAL input is still TRUE, the next `process_inputs()` samples it and sets JOINT_FAULT again. But the joint is now disabled, and `check_for_faults()` only evaluates active **and enabled** joints, so it does not immediately set JOINT_ERROR again.

That sequence yields exactly the delayed state seen by attempt 1: fault input TRUE, `faulted=TRUE`, `error=FALSE`, motion disabled, amp-enable FALSE. This is a source-confirmed cross-boundary lifecycle effect, not evidence that `check_for_faults()` failed to set JOINT_ERROR in the original fault-processing cycle.

## Classification

**HARNESS OBSERVATION DEFECT — materially redesigned before rerun.**

This is not accepted as a contradiction of the pinned source. Nor is the missing asynchronous `joint.0.error=TRUE` silently ignored. The corrected run must capture values from a realtime `sampler` function scheduled after motion so it can distinguish the original fault-processing cycle from the later Task-driven abort cleanup state.

## Corrected experiment requirements

Attempt 2 will:

1. add a five-bit `sampler` after motion/fault-injector execution;
2. sample the fault signal, `joint.0.faulted`, `joint.0.error`, `motion.motion-enabled`, and `joint.0.amp-enable-out` every servo period;
3. prove at least one enabled baseline sample;
4. prove at least one post-injection sample with fault/faulted/error TRUE and motion/amp-enable FALSE;
5. preserve later `faulted=TRUE, error=FALSE` samples as expected Task/abort cleanup evidence if they occur;
6. retain asynchronous final-state capture only as diagnostic context, not as the oracle for a transient source-state claim;
7. query LinuxCNC's error channel (`linuxcncrsh get error`) so the amplifier-fault diagnostic is captured through the intended userspace interface rather than relying only on launcher stderr.

## Evidence boundary

Even a corrected pass remains software/simulation evidence only. It does not validate HostMot2 transport, FPGA output state, drive action, STO, torque-removal time, or functional safety.
