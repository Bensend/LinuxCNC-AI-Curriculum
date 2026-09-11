# Press-brake backgauge — MDI/G53 typed-move lifecycle

Date: 2026-09-11
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`
Scope: ordinary-control call-flow evidence for the 3600 press-brake backgauge preparation track.

## Operator intent

A referenced backgauge operator types an absolute machine-coordinate target. The HMI has already established exclusive `TYPED_MOVE` ownership and validated the target against the commissioned application range.

For an ordinary LinuxCNC coordinate, the proposed public Python surface is:

1. enter/confirm MDI mode when ownership rules permit;
2. send an explicit `G53 G0 <axis><target>` (or deliberately controlled `G53 G1 ...`) through `linuxcnc.command().mdi()`;
3. supervise Task/motion/feedback state until success, fault, or operator/application abort;
4. never replay the string automatically after a fault/reconciliation episode.

## Call flow

### 1. Python command surface

The documented Python API exposes `linuxcnc.command().mdi(string)`. Unlike the internal `EMC_JOG_ABS` NML message, this is a documented first-class Python interface.

The HMI must poll status before sending and reject incompatible owner/mode/state combinations. LinuxCNC's own Python-interface documentation recommends this status-before-command pattern.

### 2. Task receives `EMC_TASK_PLAN_EXECUTE`

Pinned `src/emc/task/emctaskmain.cc` applies the default reference gate before executing MDI:

- `all_homed()` must be true unless `[TRAJ]NO_FORCE_HOMING=1`;
- otherwise Task emits `Can't issue MDI command when not homed` and rejects the request.

The press-brake contract retains the stricter application-level requirement that the **specific backgauge reference** is valid. Do not use `NO_FORCE_HOMING` to bypass reference validity.

### 3. Interpreter resolves `G53`

`G53` makes the linear target a machine-coordinate move for that block. It is nonmodal and therefore must be included on every generated typed-position line. This prevents G54-G59.3/G92/G52 work offsets from silently changing the dimensional meaning of a backgauge target.

### 4. Interpreter output enters Task's queued execution path

`emctaskmain.cc` documents an important structural difference from immediate jog commands: interpreter-generated NML commands are placed on `interp_list`; `emcTaskExecute()` applies command-specific preconditions and postconditions before advancing the list.

A generated linear move becomes `EMC_TRAJ_LINEAR_MOVE` and is issued through `emcTrajLinearMove(...)`.

The pre/postcondition machinery is therefore part of the MDI lifecycle. This is not true of immediate jog commands such as `EMC_JOG_ABS`, which `emcTaskIssueCommand()` can send directly.

### 5. Motion performs trajectory/range checking

Pinned `src/emc/motion/command.c` runs ordinary coordinated-motion range checking for linear/circular targets. `inRange(...)` checks coordinate constraints and inverse-kinematic joint endpoints against joint min/max position limits before accepting an endpoint.

This remains a downstream LinuxCNC protection. The HMI still pre-validates the dimensional target so an operator receives a domain-specific rejection before ownership is transferred.

### 6. Task waits on motion status where required

`emcTaskCheckPreconditions()` / `emcTaskCheckPostconditions()` assign execution-wait states to interpreter-list commands. `emcTaskExecute()` resolves `WAITING_FOR_MOTION` only when motion reports `RCS_STATUS::DONE`, or enters error if motion reports `ERROR`.

This establishes a stronger lifecycle than merely writing an immediate jog command, but it must not be stretched into proof of physical backgauge truth.

### 7. HMI completion witness

The documented `linuxcnc.command().wait_complete()` returns the last command's command/status execution result (`RCS_DONE`, `RCS_ERROR`, or timeout). The status interface separately exposes `inpos`, interpreter state, motion mode/type, actual position, homed flags and other witnesses.

The application-level `TYPED_MOVE_COMPLETE` condition should therefore be a conjunction, not a single API return:

- no command/error-channel failure;
- Task/interpreter/motion lifecycle is complete/idle as appropriate;
- `inpos` is true as appropriate;
- reference remains valid;
- feedback remains valid;
- backgauge position is within a commissioned tolerance of the requested target;
- drive/stall/authorization supervision remains healthy;
- no abort/revocation episode occurred.

Numeric tolerance remains deliberately unspecified until real feedback/commissioning evidence exists.

## Abort/revocation flow

Pinned `emctaskmain.cc` handles `EMC_TASK_ABORT_TYPE` by calling `emcTaskAbort()` and then `emcMotionAbort()` before state restoration. This is the ordinary software abort path the application can use when its typed-move owner is revoked.

The PB-BG-001 rule is stronger than 'abort then resume':

1. drop application `TYPED_MOVE` ownership;
2. issue the ordinary abort/revoke action appropriate to the active LinuxCNC state;
3. enter `FAULTED`/`RECONCILE`;
4. revalidate feedback, drive, authorization and reference;
5. discard the interrupted target as an executable request;
6. require a **new operator request** before sending another typed move.

Returning machine authorization alone is never a replay trigger.

## Important distinction: LinuxCNC DONE versus independent physical truth

Task/motion completion and `inpos` are controller-state evidence. They do not independently prove:

- the encoder is mechanically coupled to the gauge;
- the drive obeyed the command physically;
- no collision occurred;
- stopping distance is acceptable;
- functional-safety requirements are met.

The Ursviken field incident retained in the 3600 research is exactly why physical/feedback plausibility and stall supervision stay separate from the command-lifecycle mechanism.

## Architectural boundary

This call flow applies when the backgauge is represented by an ordinary trajectory coordinate that `G53` can command.

If later evidence chooses a LinuxCNC **extra joint** for an independently owned gauge axis, this flow is not automatically reusable: extra-joint post-home command ownership is outside ordinary coordinated kinematics and must be traced separately before implementation.

## Verification result

The MDI/G53 lifecycle is now source-traced sufficiently to freeze a software-level PB-BG-002 experiment **if** the backgauge remains an ordinary coordinate. The remaining architecture discriminator is whether public/target press-brake implementations treat X/R/Z gauges as ordinary trajectory coordinates or separately owned joints/actuators.

## Next checkpoint

Perform one bounded public-source search for the Ursviken/Pullmax X/R/Z/backstop implementation and at least one independent LinuxCNC press-brake/backgauge config. Record the ownership topology. If ordinary-coordinate ownership is supported or no contrary source is available, freeze PB-BG-002 with MDI/G53 target, offset immunity, range rejection, completion witness, abort/reconcile and stale-target non-replay gates. If an extra-joint topology is found, trace that path first and compare it explicitly before freezing the test.
