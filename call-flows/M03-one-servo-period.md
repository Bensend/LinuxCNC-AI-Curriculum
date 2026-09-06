# M03 — one servo-period call flow

Status: SOURCE-CONFIRMED foundation trace; runtime experiment pending

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

This trace answers a deliberately narrow question: once a conventional `servo-thread` invokes LinuxCNC motion functions, where does one joint's feedback enter `motmod`, what major work happens during that controller invocation, and where does the new motor command leave `motmod`? It does not claim that every machine uses the same surrounding HAL functions, that separate realtime threads have a total order, or that the software is realtime/safety qualified.

## Layer 1 — HAL thread composition

`motmod` creates `servo-thread` and exports `motion-command-handler` and `motion-controller`; it does not itself insert them with `addf`. HAL configuration therefore owns the surrounding composition.

Pinned canonical simulation `tests/linuxcncrsh/lcncrsh_sim.hal` schedules:

1. `motion-command-handler`
2. `motion-controller`
3. X/Y/Z differentiators
4. velocity hypot functions

and loops each `joint.N.motor-pos-cmd` signal directly back into `joint.N.motor-pos-fb`.

Pinned library examples show the same motion-function order, while servo/stepper configurations place control or step-generation functions after motion. This is configuration evidence, not a hard-coded motmod guarantee.

## Layer 2 — command ingestion

Pinned `src/emc/motion/command.c`:

`emcmotCommandHandler(void *, long)`

- runs as the exported realtime HAL function;
- attempts `rtapi_mutex_try(&emcmotStruct->command_mutex)`;
- if Task owns the command mutex, the realtime invocation does not wait: the command-handler opportunity is skipped/deferred for that invocation;
- if the try-lock succeeds, it enters `emcmotCommandHandler_locked()` and later releases the mutex.

Inside the locked handler, a command is treated as new when `emcmotCommand->commandNum != emcmotStatus->commandNumEcho`. For a new command it increments status/internal head counters, copies `command` to `commandEcho`, copies `commandNum` to `commandNumEcho`, initializes `commandStatus` to `EMCMOT_COMMAND_OK`, dispatches the large `EMCMOT_*` switch, and synchronizes status/config tail counters after processing.

### Foundation consequence

A userspace Task write and a servo-period command-handler invocation are decoupled by the command mutex. “Task has begun updating the shared command” does not imply “this exact servo invocation processes it.” When the mutex is unavailable, the realtime function returns rather than blocking on Task. The next successful invocation can observe/process the command number if it differs from the echoed number.

This is a source-level scheduling/acknowledgment boundary, not a measured latency guarantee.

## Layer 3 — `emcmotController()` top-level order

Pinned `src/emc/motion/control.c` explicitly documents its local helpers as being called in order. The actual controller body performs this top-level sequence for each invocation:

1. one-time command-position pointer setup;
2. measure/store actual invocation interval in `motion.servo.last-period`-related HAL state;
3. convert supplied period to seconds and update cycle time if the period changed;
4. increment `emcmotStatus->head` to mark work in progress;
5. `read_homing_in_pins(ALL_JOINTS)`;
6. `handle_kinematicsSwitch()`;
7. `process_inputs()`;
8. `do_forward_kins()`;
9. `process_probe_inputs()`;
10. `check_for_faults()`;
11. `set_operating_mode()`;
12. joint/axis jogwheel handling when not inhibited;
13. `do_homing()` in free mode, with possible teleop transition;
14. apply any deferred planner-type switch when its conditions are satisfied;
15. `get_pos_cmds(period)`;
16. `compute_screw_comp()`;
17. plan/apply external offsets;
18. `output_to_hal()`;
19. `write_homing_out_pins(ALL_JOINTS)`;
20. `update_status()`;
21. increment heartbeat;
22. set `emcmotStatus->tail = emcmotStatus->head` to mark controller work complete.

The foundation trace does not descend into every state-machine branch. The important one-period ordering is that HAL feedback sampling occurs in `process_inputs()` before trajectory/position-command generation and before final HAL output publication.

## Exact joint feedback sampling point

Within `process_inputs()` the active-joint path executes:

```c
joint->motor_pos_fb = hal_get_real(joint_data->motor_pos_fb);
```

For the normal non-index-search case it then computes:

```c
joint->pos_fb = joint->motor_pos_fb -
                (joint->backlash_filt + joint->motor_offset);
```

and calculates following error from the resulting joint feedback and command state. There is a special homing/index-search branch where feedback is temporarily forced to commanded position because encoder position may step at index capture. Therefore a one-period “motor feedback becomes joint feedback” rule must always retain that homing exception.

## Kinematics boundary at foundation depth

After HAL input sampling, `do_forward_kins()` converts joint feedback into Cartesian feedback where supported/valid. The controller later calls `get_pos_cmds(period)` to produce position setpoints; mode and kinematics determine how coordinated, teleop, free/joint, and homing paths obtain/update command positions. Those detailed planners are prerequisites for later motion modules and are not required to establish the M03 feedback-to-command phase ordering.

Important ordering facts for M03:

- forward kinematics uses joint feedback already sampled this controller invocation;
- probe handling is intentionally after forward kinematics so a probe latch can use Cartesian feedback from the current sampled joint feedback;
- command/setpoint generation occurs after fault/mode processing;
- final motor command publication occurs near the end.

## Exact motor command publication point

Within `output_to_hal()` the normal active-joint path computes:

```c
joint->motor_pos_cmd =
    joint->pos_cmd + joint->backlash_filt + joint->motor_offset;
```

and then writes:

```c
hal_set_real(joint_data->motor_offset, joint->motor_offset);
hal_set_real(joint_data->motor_pos_cmd, joint->motor_pos_cmd);
hal_set_real(joint_data->joint_pos_cmd, joint->pos_cmd);
hal_set_real(joint_data->joint_pos_fb, joint->pos_fb);
```

Extra joints have a separate post-home command passthrough branch, so the normal formula is not universal to every joint class.

## Same-cycle consequence for a conventional read -> motion -> control -> write HAL chain

For a conventional single servo thread:

`hardware read -> motion-command-handler -> motion-controller -> external PID/control -> hardware write`

an input producer scheduled before `motion-controller` can update `joint.N.motor-pos-fb`; `process_inputs()` then samples that value during the same controller invocation. `motion-controller` later publishes the new `joint.N.motor-pos-cmd`; a PID/control function scheduled after motion can consume that new command in the same HAL-thread pass. H04 provides the within-thread list-order execution guarantee; M03 adds the exact internal motion sampling/publication locations.

The inverse ordering matters too. If a feedback-producing function is scheduled *after* `motion-controller`, the controller cannot sample that newly produced value until a later controller invocation.

## Canonical simulation's intentional one-cycle loopback

Pinned `tests/linuxcncrsh/lcncrsh_sim.hal` directly nets `joint.0.motor-pos-cmd` back to `joint.0.motor-pos-fb` on signal `Xpos` and schedules only `motion-command-handler` and `motion-controller` before downstream differentiators. Because `process_inputs()` reads `Xpos` early in `motion-controller`, and `output_to_hal()` writes the new motor command to the same signal later in that controller invocation, the controller's `joint.0.pos-fb` publication should represent the *pre-update* `Xpos` value while `Xpos` after the controller represents the newly published command.

For zero backlash and zero motor offset during an ordinary move, this predicts an observable sample relation when a sampler is scheduled after `motion-controller`:

`joint-pos-fb[n] ~= motor-pos-cmd[n-1]`

while

`joint-pos-cmd[n] ~= motor-pos-cmd[n]`.

This is the discriminating runtime hypothesis for lab `008`; it is not TEST-CONFIRMED until the lab artifact is reconciled.

## Failure and exception boundaries

- Command mutex held by Task: command-handler skips/defer processing rather than blocking.
- Inactive joints: relevant input/output paths are skipped.
- Homing index-search transition: normal motor-feedback-to-joint-feedback calculation is intentionally overridden for that state.
- Fault, limit, following-error, mode, homing, kinematics, and planner branches can alter command evolution; this trace establishes ordering, not every branch's numerical result.
- Extra joints have distinct output behavior.
- HAL function placement around motion is configuration-defined.
- No claim here establishes realtime deadline compliance, scheduler latency, hardware I/O timing, or functional safety.

## Evidence ledger

| Claim | Classification | Evidence |
|---|---|---|
| motmod exports motion functions but HAL config schedules them | SOURCE-CONFIRMED | pinned `motion.c`; canonical HAL configs |
| command-handler uses nonblocking command-mutex acquisition | SOURCE-CONFIRMED | pinned `command.c` |
| a command is new when command number differs from echoed number | SOURCE-CONFIRMED | pinned `command.c` |
| controller samples motor feedback in `process_inputs()` before command generation | SOURCE-CONFIRMED | pinned `control.c` |
| normal joint motor command is published in `output_to_hal()` after `get_pos_cmds()`/compensation | SOURCE-CONFIRMED | pinned `control.c` |
| canonical linuxcncrsh loopback should expose a one-controller-invocation feedback lag | INFERENCE | source ordering + pinned HAL config; lab `008` designed to test |
| the same relationship holds on arbitrary hardware configs | UNKNOWN / configuration-dependent | must not be generalized |

## Promotion / uncertainty queue

| Item | Destination | Priority | Blocks 1000 graduation? | Reason |
|---|---|---:|---|---|
| exact Task-side mutex hold duration and command-to-echo latency distribution | 2000/R05/T02 | HIGH | no | source boundary is sufficient for foundation ordering; latency deserves dedicated test |
| full coordinated/free/teleop planner and kinematics branch trace | M08/M01/M02 then 2000 | HIGH | no | beyond one-period phase ordering |
| cross-thread memory visibility when hardware read/write is in another realtime thread | 2000/R02/H04 | HIGH | no | current trace is explicitly one-thread |
| physical hardware read/write timing relative to FPGA/network transactions | HM/E/IO series | CRITICAL | no | later critical-path modules own this boundary |
| safety significance of stale/faulted feedback | S-series | CRITICAL | no | must not infer safety from software trace |

## Next verification

Run bounded lab `008-m03-servo-cycle-loopback.sh` on the pinned linuxcncrsh simulation. Require fresh metadata and a moving interval in which sampled post-controller `joint.0.pos-fb[n]` matches prior-sample `Xpos[n-1]` materially better than same-sample `Xpos[n]`, while `joint.0.pos-cmd[n]` matches same-sample `Xpos[n]` under zero comp/offset. Any result that does not satisfy those conditions must be investigated before promoting the one-cycle loopback prediction.