# 3500 ROS2 — Tormach ZA6 drive-enable, zero-error and brake authority source trace

Date: 2026-09-14
Pinned ZA6 revision: `tormach/tormach_za_ros2_drivers@b58078aac3004f3932079ea7228ab0432cf8ac18`
Status: **SOURCE-CONFIRMED FIELD-AUTHORITY LAYER**

## Purpose

Continue below the generic `hal_ros_control` bridge and identify who actually owns ZA6 drive enable/disable, command-to-feedback reconciliation, fault state and brake manipulation. This answers part of the stale-command question exposed by the generic bridge trace.

## Controller configuration

The pinned ZA6 ros2_control configuration defines:

- six joints;
- `joint_trajectory_controller` with position + velocity command interfaces and position + velocity state interfaces;
- a separate position-only `streaming_controller`;
- `joint_state_broadcaster`;
- `allow_nonzero_velocity_at_trajectory_end: false`.

MoveIt names both the trajectory and streaming controllers. Controller selection therefore remains distinct from drive electrical enable.

## Drive-state authority

`za6_hardware/hal_plumber/drive_state.py` is a userspace ROS/HAL component layered over `hw_device_mgr`. It creates explicit HAL command/feedback state pins:

- `state_cmd` output;
- `state_fb` input;
- `state_set` command latch;
- `goal_reached` input;
- per-joint position feedback/command observations;
- per-joint homing request/success/error.

The state model distinguishes INIT, STOP, START and FAULT.

Enable and disable are ROS services that request START or STOP respectively. `set_state()` does not treat command issuance as completion: it latches the requested state, waits for both `state_fb == state_cmd` and `goal_reached`, requires that success to be observed through a second cycle to avoid a false positive, and faults the service if the device manager enters FAULT or a timeout expires.

Therefore:

`enable service success = observed device-manager state transition + goal reached`

not merely `enable command was sent`.

## Zero command error before drive START

The most important startup behavior is explicit command-to-feedback reconciliation.

When requesting `STATE_START`, `set_state_start()` calls `zero_error()` before completing the drive-state transition.

`zero_error()`:

1. reads each joint's current `pos_fb`;
2. builds a one-point `JointTrajectory` whose positions equal current feedback and whose velocity/acceleration are zero;
3. asserts a `load` HAL pin;
4. publishes that trajectory to the configured JointTrajectoryController topic;
5. waits until every observed `pos_cmd - pos_fb` is within `0.001 rad`;
6. times out on failure;
7. clears `load` in a `finally` block.

This directly answers one part of the stale-command problem: the ZA6 does not simply enable drives against an arbitrary pre-existing trajectory command. It first requests that controller command state be reconciled to current measured position.

That mechanism is userspace/service-owned and depends on the trajectory controller and HAL feedback/command observations functioning. It is not a safety-rated torque/brake mechanism.

## Fault handling

The component monitors `state_fb` transitions. Entering device-manager FAULT raises a `StateError`, which causes enable/disable services to report failure. Timeout also clears `state_set`, resets the local service state and raises failure.

This provides an explicit field-state witness missing from the generic HalSystemInterface.

Do not equate `/drives_faulted` or service failure with safety STO; it is operational drive/device-manager state.

## Brake authority during homing

Homing exposes a subtle authority inversion.

The code comments state that Inovance drives stop holding position in homing mode. Before requesting a joint home, `home_joint()` calls `force_brakes(..., engage=True)`, then asserts the joint `home_request` and waits for either `home_success`, `home_error`, or timeout.

`force_brakes()` modifies drive SDO configuration controlling the brake output function. On cleanup it:

1. calls `zero_error()`;
2. waits one update period;
3. clears `home_request`;
4. restores the normal drive brake function (`engage=False` in the helper's naming).

Thus brake behavior is not merely a single HAL boolean adjacent to joint command. It is coupled to drive configuration and homing mode, and cleanup deliberately reconciles command to feedback before restoring the normal brake-control function.

This is exactly the kind of gravity-axis sequencing that the 3500 playbook must preserve as a separate state machine.

## Authority stack now visible

For ZA6 startup/enabling, the source-visible chain is approximately:

`ROS enable service`
`-> zero controller command to measured joints`
`-> request hw_device_mgr START`
`-> latch request`
`-> wait state_fb + goal_reached`
`-> drives_enabled publication`

For command execution:

`JTC/streaming controller`
`-> ros2_control command interfaces`
`-> HalSystemInterface write`
`-> HAL command pins`
`-> downstream device/drive path`.

For homing/brake handling:

`home service`
`-> force brake function`
`-> home_request`
`-> success/error/timeout`
`-> zero command error`
`-> clear request`
`-> restore normal brake function`.

These are related but distinct control paths.

## Important unresolved question

The source now shows protection against stale **initial command error when enabling**, but it does not yet establish the full behavior if the ROS controller manager dies while drives are already STARTed or if EtherCAT command freshness is lost downstream.

The next trace must therefore continue into `hw_device_mgr`, joint HAL plumbing and EtherCAT/CSP control-word/fault/watchdog behavior. Do not assume the zero-error enable sequence is a runtime communications watchdog.

## Adversarial review

1. **Does `/enable_drives` simply toggle a bit and return?** No; it waits for device-manager state feedback and goal completion.
2. **Can drives be STARTed against an arbitrary old joint command without reconciliation?** The inspected path explicitly runs `zero_error()` first.
3. **Does `zero_error()` directly command drive torque?** No; it publishes a trajectory/controller command and waits for HAL-observed command-feedback agreement.
4. **Is a drive FAULT state identical to safety STO?** No.
5. **Are brakes controlled only by ros2_control joint interfaces?** No; homing manipulates drive SDO brake-function configuration separately.
6. **Does homing cleanup restore brake function before command reconciliation?** No; it zeroes command error first, then clears home request and restores normal brake function.
7. **Does this prove runtime stale-command containment after controller-manager death?** No; that remains unresolved downstream.
8. **Can controller selection be conflated with drive enable?** No; trajectory/streaming controller ownership and device START/STOP are separate layers.

Result: **8/8 boundaries preserved.**

## Next work

Trace `hw_device_mgr` and per-joint HAL/EtherCAT wiring for START/STOP/FAULT, quick-stop/control-word masking, CSP command validity and any watchdog/freshness behavior. Then source-trace JointTrajectoryController cancellation/deactivation to connect controller-side stop semantics to this drive-side authority.

No lab yet: source is still yielding stronger evidence than an RRBot fixture.
