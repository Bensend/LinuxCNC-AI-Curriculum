# 3500 — ZA6 runtime stale-command and fault-containment source trace

Date: 2026-09-14
Status: SOURCE / bounded conclusion

## Question

For the Tormach ZA6 ROS2/HAL architecture, what happens after drives are already STARTed if the high-level ros2_control/JointTrajectoryController path stops updating while EtherCAT and the drives themselves remain healthy? Which downstream mechanisms actually contain faults, and which mechanisms only prove fieldbus/drive health?

## Pinned source

- `tormach/tormach_za_ros2_drivers@b58078aac3004f3932079ea7228ab0432cf8ac18`
- `zultron/hw_device_mgr@f577727363735fb52d41be7ffa4cd9bb9b5c0c82`, selected by the ZA6 `devel_scripts/docker/ros_custom/repos.yaml` branch dependency `zultron/2025-08-04_ros2_fixes-dev`
- LinuxCNC-EtherCAT/lcec behavior is observed through the ZA6 HAL plumbing, not promoted here as a complete independent audit of lcec internals.
- For JointTrajectoryController, the ZA6 repository establishes ROS 2 Humble but does **not** pin the exact `ros2_controllers` commit/package. Current Humble branch source may therefore be used only as a semantic comparator, not as exact deployed provenance.

## Source chain

### Command path

The real ZA6 per-joint HAL plumbing documents and implements:

`hal_hw_interface position_cmd -> ros_pos_cmd -> jlimits -> cmd PLL -> qc -> pos_cmd -> lcec position_reference`

with velocity and torque references generated alongside the position reference. `cw_bit_enable_operation` enables the command PLL/QC path.

Important consequence: after a value has reached the HAL command pin, the downstream path is a continuously evaluated realtime signal chain. Nothing in this path inherently proves that the upstream ros2_control value was refreshed during the current or recent cycle.

### Drive-state / EtherCAT observability

Each joint exposes distinct lcec-derived:

- `slave-online`
- `slave-oper`
- CiA-402 status word
- control mode feedback
- error code
- optional STO state
- position/torque/following-error feedback

These are connected into `hw_device_mgr` and `drive_safety`.

`CiA301Device.get_feedback()` treats loss of `online` as `goal_reached=False`; a transition offline raises `Drive went offline/non-operational` fault. Loss of `oper` similarly raises `Drive went non-operational`. The manager aggregates a new device fault, then `HWDeviceMgr.set_command()` forces manager `STATE_FAULT`.

Thus loss of EtherCAT slave online/oper state is a real detected fault path.

### CiA-402 / safety containment

ZA6 `drive_safety.icomp` masks every drive's raw control word through `0xFFF2` when any of these is true:

1. not all drives report motor voltage enabled;
2. external quick stop is asserted;
3. any drive status word reports FAULT;
4. both safety input and enabling input are low.

The result forces CiA-402 quick-stop/disabled-compatible control words across the drive set. The component also issues the configured manager quick-stop state command once on entry.

This is meaningful operational containment for named unsafe/drive-fault conditions. It is not proof of a safety-rated STO chain.

## Stale-command result

The searched ZA6/hw_device_mgr path contains **no source-visible command-age/generation/heartbeat check tied to `hal_hw_interface.*.position_cmd` or the derived `lcec.*.position_reference`**.

Therefore the following failure must remain distinct from EtherCAT loss:

`controller/JTC/hal_control_node stops updating -> last HAL position command remains -> downstream HAL/LCEC still executes with online+oper drives`

The already-preserved `hal_ros_control` trace established that if its controller-manager path is not OK it returns without directly resetting the HAL command pins. This downstream audit finds no later generic freshness witness that converts that condition into quick stop merely because the high-level command is stale.

Do **not** overstate this as proof that a physical ZA6 will continue moving indefinitely after every ROS2 failure. If the last position reference is a stationary target, the drive may simply continue holding that target; other process/supervisor shutdown paths may also act. The defensible claim is narrower: fieldbus/drive-health containment is not equivalent to high-level command-freshness containment.

## Current Humble JTC comparator

Current `ros-controls/ros2_controllers` Humble source (`2105376a66d51341dcb213f096ada9af92cb23aa`, 2026-09-02) provides useful comparator semantics:

- path-tolerance and goal-time failures replace the trajectory with `set_hold_position()`;
- activation begins with a hold trajectory;
- deactivation aborts the active action goal;
- with a position command interface, deactivation leaves the position command at its existing value while explicitly zeroing velocity, acceleration and effort command interfaces.

These semantics are compatible with a hold-last-position model, but the ZA6 repository does not pin the exact deployed `ros2_controllers` revision. Do not silently import this 2026 Humble implementation as historical ZA6 fact.

## Authority model

Preserve these independent layers:

1. **Trajectory/action authority** — JTC owns goal/cancel/tolerance/hold semantics.
2. **ros2_control/HAL bridge freshness** — copies controller commands into HAL; current trace has no downstream command-age witness.
3. **HAL command shaping** — jlimits/PLL/QC continuously shape the current stored command.
4. **EtherCAT transport health** — lcec online/oper proves slave/bus state, not freshness of the high-level target.
5. **CiA-402 drive state** — status word/control mode/fault/following error.
6. **cross-drive quick-stop containment** — `drive_safety` masks all drive control words on its explicit trigger set.
7. **functional safety/STO** — separate authority; not established by software quick stop.

## Adversarial review

1. **Does online+oper mean fresh ROS2 command?** No.
2. **Does a controller-manager failure necessarily create an EtherCAT fault?** No evidence of that coupling.
3. **Does drive_safety have a high-level command-age timer?** Not found.
4. **Does any drive fault affect only that drive?** No; drive_safety applies quick-stop masking across all configured drives.
5. **Does hw_device_mgr react to lcec online/oper loss?** Yes; per-device feedback faults propagate into manager fault state.
6. **Is software quick stop equivalent to STO?** No.
7. **Can current Humble JTC source be claimed as exact ZA6 deployed behavior?** No; exact ros2_controllers package/commit is not pinned by the inspected ZA6 source.
8. **Is a synthetic stale-command lab required now?** Not yet. Source already establishes the important ownership gap. A lab is justified only if the curriculum needs runtime timing/transition evidence for a named failure injection (for example controller-manager disappearance while HAL/LCEC remains live), not to rediscover static command persistence.

Adversarial result: **8/8 bounded claims survive.**

## Promotion decision

Promote to the 3500 playbook:

> Robot command freshness must be modeled separately from EtherCAT slave health and CiA-402 drive health. A healthy fieldbus can faithfully carry or retain an old high-level target. If stale high-level commands are unacceptable, require an explicit generation/heartbeat/age authority with a defined transition to hold, controlled stop, quick stop, or independent safety action.

## Remaining evidence gap

Next high-value work is no longer generic downstream fault tracing. Instead:

1. determine the exact `ros2_controllers`/JTC package used by a preserved ZA6 deployment if provenance becomes available;
2. inspect ZA6 supervisory launch/shutdown/process monitoring for node-death handling that may command STOP independently of HAL;
3. inspect a second real ROS2/LinuxCNC robot stack for command-freshness containment;
4. only then decide whether a targeted node-death/stale-command experiment adds independent evidence.
