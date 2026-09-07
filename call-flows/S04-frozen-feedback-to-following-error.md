# S04 — Frozen feedback to following-error disable call flow

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

Representative case: an ordinary active joint is commanded to move while `joint.N.motor-pos-fb` remains frozen. This is a command-versus-feedback mismatch path, not a generic sample-age detector.

## HAL boundary

`src/emc/motion/motion.c::export_joint()` exports:

- `joint.N.motor-pos-fb` — HAL_IN real
- `joint.N.motor-pos-cmd` — HAL_OUT real
- `joint.N.f-error` — HAL_OUT real
- `joint.N.f-error-lim` — HAL_OUT real
- `joint.N.f-errored` — HAL_OUT bool
- `joint.N.error` — HAL_OUT bool
- `joint.N.amp-enable-out` — HAL_OUT bool

`motion.motion-enabled` is the machine-wide HAL output used to observe the motion enable state.

## Servo-cycle execution path

### 1. `process_inputs()` samples feedback

`src/emc/motion/control.c::process_inputs()` reads `joint_data->motor_pos_fb` into `joint->motor_pos_fb` for each active joint.

Normal case:

`joint->pos_fb = joint->motor_pos_fb - (joint->backlash_filt + joint->motor_offset)`

Then, except for a homed extra joint:

`joint->ferror = joint->pos_cmd - joint->pos_fb`

A frozen `motor-pos-fb` therefore holds `pos_fb` fixed while a moving `pos_cmd` makes the magnitude of `ferror` grow.

### 2. Velocity-dependent threshold

For `joint->vel_limit > 0`, motion computes:

`ferror_limit = max_ferror * abs(vel_cmd) / vel_limit`

and clamps the result no lower than `min_ferror`.

If `abs(ferror) > ferror_limit`, `SET_JOINT_FERROR_FLAG(joint, 1)` is set; otherwise the flag is cleared.

This means following error is a mismatch threshold whose tolerance depends on commanded velocity. It is not a timer proving that a sensor delivered a new sample.

### 3. Special cases that prevent over-generalization

During homing index-search wait, when index enable has just cleared, `process_inputs()` deliberately substitutes `joint->pos_cmd` for `joint->pos_fb` because encoder position may step at index capture. That suppresses the ordinary command-minus-feedback interpretation for that special interval.

For a homed extra joint, `joint->ferror` is forced to zero because following error is not relevant to that extra-joint mode.

### 4. `check_for_faults()` converts mismatch into a motion fault

For an active, enabled joint, `check_for_faults()` tests `GET_JOINT_FERROR_FLAG(joint)`. On assertion it reports `joint N following error`, sets the joint error flag, and sets `emcmotInternal->enabling = 0`.

### 5. `set_operating_mode()` removes motion/joint enable

When internal enabling is false while motion is enabled, `set_operating_mode()` clears the trajectory planner/interpolators, disables free planners, clears each active joint's enable flag, cancels homing, aborts axis jogs, and clears the motion-enable flag. It deliberately does not clear the joint error flag that explains the disable.

### 6. `output_to_hal()` publishes externally observable evidence

`output_to_hal()` publishes:

- `joint.N.f-error = joint->ferror`
- `joint.N.f-error-lim = joint->ferror_limit`
- `joint.N.f-errored = GET_JOINT_FERROR_FLAG(joint)`
- `joint.N.error = GET_JOINT_ERROR_FLAG(joint)`
- `joint.N.amp-enable-out = GET_JOINT_ENABLE_FLAG(joint)`
- `motion.motion-enabled = GET_MOTION_ENABLE_FLAG()`

The same internal values are also copied into `emcmotStatus` by `update_status()` for userspace status consumers.

## Representative failure chain

`motor-pos-fb frozen`  
→ `process_inputs()` repeatedly reads same value  
→ moving `pos_cmd` separates from fixed `pos_fb`  
→ `abs(ferror)` exceeds velocity-dependent limit  
→ joint following-error flag  
→ `check_for_faults()` sets joint error and clears enabling intent  
→ `set_operating_mode()` disables motion/joints  
→ `output_to_hal()` publishes mismatch, fault and disabled state.

## Stationary counterexample

If command and frozen feedback are already equal and the joint remains stationary, `ferror` remains near zero. Nothing in this path establishes sample age, so the following-error flag need not assert. This is an essential limitation: one unchanged scalar cannot distinguish a genuinely stationary sensor from a frozen sensor without independent freshness/process evidence.

## Evidence classification

- HAL exports and execution path above: **SOURCE-CONFIRMED** at pinned revision.
- Public `MIN_FERROR`/`FERROR` velocity-ramp semantics: **DOC-CONFIRMED** by current LinuxCNC INI documentation.
- Frozen-during-motion and stationary-frozen behavior: **PREDICTION** pending S04-014 experiment.

## Safety boundary

This path is ordinary LinuxCNC motion fault handling. It does not establish encoder diagnostic coverage, physical stopping time, STO/torque removal, or any PL/SIL/category claim.