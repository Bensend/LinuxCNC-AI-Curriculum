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

Pinned `control.c` is unambiguous about the controller invocation that samples an active+enabled amplifier fault: `check_for_faults()` reports `joint %d amplifier fault`, executes `SET_JOINT_ERROR_FLAG(joint, 1)`, and clears `emcmotInternal->enabling`. `set_operating_mode()` then disables the joint and motion and explicitly does **not** clear the joint error during the disable transition. `output_to_hal()` publishes both the error and fault flags later in that same `emcmotController()` invocation.

However, `set_operating_mode()` also clears outstanding JOINT_ERROR flags when transitioning from disabled to enabled. Pinned `command.c` shows that an `EMCMOT_ENABLE` command sets `emcmotInternal->enabling=1`, deferring the actual enable transition to the controller cycle. Therefore an asynchronous userspace observation taken after the fault-triggered controller invocation is not a valid oracle for whether `joint.0.error` was TRUE during the exact fault-processing cycle. Attempt 1 proved the core disable/fault result but did not sample finely enough to prove the transient error publication.

The exact later command/task sequence that can request re-enable while the external fault remains asserted is deeper than needed to redesign this experiment; the corrected experiment will observe servo-cycle values directly instead of inferring them from delayed userspace polls.

## Classification

**HARNESS OBSERVATION DEFECT — materially redesign before rerun.**

This is not accepted as a contradiction of the pinned source. Nor is the missing asynchronous `joint.0.error=TRUE` silently ignored. The corrected run must capture the values from a realtime `sampler` function scheduled after motion so it can distinguish the fault-processing cycle from later controller/task state changes.

## Corrected experiment requirements

Attempt 2 will:

1. add a five-bit `sampler` after motion/fault-injector execution;
2. sample the fault signal, `joint.0.faulted`, `joint.0.error`, `motion.motion-enabled`, and `joint.0.amp-enable-out` every servo period;
3. prove at least one enabled baseline sample;
4. prove at least one post-injection sample with fault/faulted/error TRUE and motion/amp-enable FALSE;
5. retain asynchronous final-state capture only as diagnostic context, not as the oracle for a transient source-state claim;
6. query LinuxCNC's error channel (`linuxcncrsh get error`) so the amplifier-fault diagnostic is captured through the intended userspace interface rather than relying only on launcher stderr.

## Evidence boundary

Even a corrected pass remains software/simulation evidence only. It does not validate HostMot2 transport, FPGA output state, drive action, STO, torque-removal time, or functional safety.
