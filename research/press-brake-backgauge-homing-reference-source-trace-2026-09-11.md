# Press-brake backgauge — homing/reference source trace

Date: 2026-09-11
Course context: dependency-safe 3600 press-brake preparation while F02 fresh-AI handoff remains information-separated
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Objective

Trace the LinuxCNC reference boundary for an extra-joint backgauge axis far enough to define what a production HMI may call `referenced` or `at position`, without inventing machine-specific speeds, switch geometry, tolerances, or functional-safety properties.

This follows PB-BG-002, which test-confirmed typed-position ownership/revocation but deliberately left physical/reference establishment as the next source question.

## Pre-source prediction

Prediction before inspecting the pinned homing state machine: a failed home search or limit event must leave the extra joint unhomed, and `joint.N.posthome-cmd` must remain unable to become the motor command until homing reaches a completed state. Therefore a typed target retained by the HMI must not become motion authority merely because its numeric target remains present across a failed home attempt.

## Official documentation pass

LinuxCNC's Homing Configuration documentation defines four basic homing forms from `HOME_SEARCH_VEL`, `HOME_LATCH_VEL`, and `HOME_USE_INDEX`: immediate, index-only, switch-only, and switch+index. Important generic semantics for a backgauge are:

- `HOME_SEARCH_VEL` starts the switch search and first backs off if the switch is already active;
- `HOME_LATCH_VEL` performs the accurate latch/index approach;
- `HOME_OFFSET` assigns a coordinate to the found switch/index location;
- `HOME` is the final commanded location on the newly established joint coordinate scale;
- `HOME_FINAL_VEL` bounds the final move when configured;
- `HOME_IGNORE_LIMITS` is a specific homing configuration choice, not a generic permission to disregard limits;
- `HOME_SEQUENCE` controls order and optional synchronized final moves;
- `VOLATILE_HOME` causes a joint to lose home when the machine transitions OFF;
- `motion.homing-inhibit` can prevent homing initiation.

Official reference: `https://www.linuxcnc.org/docs/devel/html/config/ini-homing.html` (same semantics are present in current translated mirrors).

## Pinned source inventory

### `src/emc/motion/homing.c`

Relevant structures/functions/states:

- `home_state_t`: full per-joint state machine from `HOME_IDLE` through search/latch/index/final-move states, plus `HOME_FINISHED` and `HOME_ABORT`;
- `home_start_move()`: creates a long free-planner move in the requested direction and clamps homing velocity to the joint velocity limit;
- `home_do_moving_checks()`: rejects an unexpected limit unless `HOME_IGNORE_LIMITS` is configured and rejects reaching the end of the generated search move without the expected homing event;
- `base_do_cancel_homing()`: moves an active/in-sequence joint to `HOME_ABORT`;
- `set_all_unhomed()`: refuses inappropriate unhome operations while moving/homing and, importantly for extra joints, refuses unhoming an extra joint while motion remains enabled;
- `HOME_FINISHED`: clears `homing`, sets `homed=1`, returns the state machine to `HOME_IDLE`, and establishes the final free-planner current position for non-absolute-encoder homing;
- `HOME_ABORT`: clears homing and homed state, clears sequence membership, disables free-planner motion, returns state to idle, and clears index-enable. The implementation does this across the active homing set rather than leaving a partially trustworthy sequence behind.

### `src/emc/motion/control.c`

`emcmotController()` executes each servo invocation in a fixed high-level order that includes reading homing inputs, processing inputs/faults, operating-mode logic, `do_homing()` in FREE mode, then command generation/output/status publication.

In `output_to_hal()`, the extra-joint post-home path is explicit:

```text
if (IS_EXTRA_JOINT(joint_num) && get_homed(joint_num)) {
    motor-pos-cmd = posthome_cmd + motor_offset;
    continue;
}
```

So the `posthome-cmd` path is conditional on LinuxCNC's `homed` state. Before successful homing, the extra joint remains under the ordinary homing/free-planner path rather than accepting the post-home application target as its motor-position command.

## Function/call-flow consequence

For the extra-joint backgauge topology, the generic authority sequence is:

`home request -> homing.c per-joint state machine -> switch/index/limit checks -> coordinate establishment -> optional final HOME move -> HOME_FINISHED -> homed=1 -> control.c allows posthome_cmd + motor_offset -> motor-pos-cmd`

Failure/cancel path:

`unexpected limit / missing expected event / invalid home configuration / cancel -> HOME_ABORT -> homed=0 + homing=0 + free planner disabled + index request cleared -> posthome_cmd remains excluded from extra-joint motor-pos-cmd`

This confirms the prediction: a numeric typed target may remain in application memory, but failed/cancelled homing does not make it a valid referenced command.

## Community/field cross-check

The previously retained Ursviken Pullmax Optima field study is consistent with this source boundary. That retrofit intentionally uses LinuxCNC extra joints for the real press mechanisms and reports UI target -> `limit3` -> `joint.N.posthome-cmd` after homing. The builder had to correct `HOME_OFFSET` to make the R-axis LinuxCNC joint coordinate agree with the intended physical/readout zero and changed the GUI to use joint position feedback rather than raw encoder position. That is practical evidence that raw encoder count and referenced machine coordinate are not interchangeable.

The same diary also reported a bad-feedback event that drove R into a hard stop, reinforcing that successful reference establishment does not replace independent feedback/drive/stall supervision.

Prior field artifact: `research/press-brake-backgauge-extra-joint-field-topology-2026-09-11.md`.

## Production HMI semantics

### `Referenced`

At the generic curriculum level, `Referenced` may be asserted only when LinuxCNC reports the relevant joint homed **and** the application has not independently invalidated reference because of a fault/reconciliation rule. Merely seeing the home switch, merely finishing a UI procedure, or merely retaining a prior target is insufficient.

If `VOLATILE_HOME` applies and machine OFF unhomes the joint, the HMI reference indication must follow the new unhomed state. It must not preserve a cosmetic `referenced` latch.

### `At position`

`homed` is necessary for an extra-joint post-home typed target but is not an `at position` witness. A production `at position` indication should require, at minimum:

1. referenced/homed state remains valid;
2. the currently authorized owner still owns the target;
3. the bounded planner output has converged to the intended target;
4. valid feedback agrees with the target within a commissioned tolerance;
5. no drive, feedback, stall, limit, or authorization fault is active;
6. the completion observation belongs to the current command episode, not a stale pre-fault target.

The curriculum must not invent the numeric tolerance, settle time, or machine travel envelope.

## Adversarial checks

1. **Target entered before home:** storing a target is allowed as UI data, but `posthome-cmd` cannot become the extra-joint motor-position command until `homed=1`. Application policy should still require a fresh post-reference authorization rather than auto-replaying it.
2. **Home switch seen, final move not complete:** do not call the joint referenced yet; the state machine has not reached `HOME_FINISHED`.
3. **Unexpected limit during search:** unless explicitly configured `HOME_IGNORE_LIMITS`, source moves to abort; no reference validity may be retained.
4. **Homing cancelled midway:** source takes the abort path and clears homed state; stale typed/program targets require reconciliation/new authorization.
5. **Homed but feedback later implausible:** `homed` alone cannot prove present physical truth; PB-BG-002's feedback/stall supervision remains required.
6. **GUI misses a one-cycle reference/authorization loss:** GUI refresh timing cannot override the realtime/source state transition; diagnostic history and reconciliation rules must follow the control-side witness.

## Experiment decision

No additional motor-physics simulation is justified by this trace. The LinuxCNC-specific ambiguity that motivated the lesson—whether an extra-joint post-home target can bypass failed/incomplete homing—is resolved directly by pinned source.

A new laboratory experiment becomes justified only if it tests an integration question not settled by the code, such as a concrete HMI/HAL ownership implementation ensuring stale targets are not replayed across `homed 1 -> 0 -> 1`, or validating an atomic `at position` witness with planner and feedback provenance. Do not create a simulation merely to restate the source state machine.

## Claims boundary

This trace establishes LinuxCNC software reference/command ownership semantics at the pinned revision. It does **not** establish:

- actual switch placement or repeatability;
- encoder accuracy, coupling, or physical truth;
- commissioned homing speeds/tolerances;
- physical stopping distance;
- safe hydraulic/drive behavior;
- functional-safety PL/SIL or safeguarding performance.

## Precise next checkpoint

When the 2000-level F02 information-separated handoff is available, close that gate first. For dependency-safe 3600 preparation, the next unblocked backgauge item is an **atomic production `at position`/reference-loss integration contract**: trace the HAL/UI signals available for `joint.N.homed`, `joint.N.pos-fb`, bounded-planner output/velocity, drive/feedback validity, and command-episode identity; then freeze an experiment only if the integration semantics remain ambiguous after source review.
