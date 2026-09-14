# 3500 ROS2 — ZA6 joint command and quick-stop source trace

Date: 2026-09-14
Pinned ZA6 revision: `tormach/tormach_za_ros2_drivers@b58078aac3004f3932079ea7228ab0432cf8ac18`
Status: **SOURCE-CONFIRMED DOWNSTREAM COMMAND/FAULT PIPELINE**

## Command path below ros2_control

Pinned `za6_hardware/hal_plumber/joint.py` documents and implements the per-joint path:

`hal_hw_interface position_cmd`
`-> ros_pos_cmd`
`-> limit3v3 joint limits`
`-> jlimits_pos_cmd`
`-> PLL/QC command shaping`
`-> pos_cmd / vel_cmd / torque_cmd`
`-> lcec EtherCAT position/velocity/torque reference pins`.

Feedback returns from EtherCAT actual-position/following-error/torque signals through the HAL plumbing to the ros2_control state pins.

This is important because a ROS command is not written directly to an EtherCAT target. There is an intermediate realtime HAL limit/shaping pipeline.

## Reset integration

The source comments and links establish that the global reset/load state used around drive enabling reaches both:

- the HAL/ros2_control reset mechanism, intended to make controller command match feedback; and
- the per-joint `jlimits.load` pin, which makes the joint-limit component load output from input.

Therefore command reconciliation crosses more than one stateful layer before enable.

## Drive enable gating of command dynamics

The EtherCAT joint plumbing extracts the CiA-402 `enable_operation` control-word bit and uses it to enable the command PLL/QC and feedback PLL. Drive operation authority is therefore distinct from the mere presence of a ROS/HAL position command.

## Cross-drive quick-stop behavior

The source documents a dedicated safety-chain transformation around CiA-402 control words:

- each drive's raw control word originates from `hw_device_mgr`;
- drive status/fault signals feed a `drive_safety` chain;
- if **any drive faults**, the quick-stop bit is forced low for all drives before the control words reach EtherCAT;
- the device manager is then responsible for stopping enabled drives and waiting for fault reset.

This is substantially stronger evidence than the generic HAL bridge: runtime drive fault can affect the actual CiA-402 authorization word across the robot, rather than relying on JointTrajectoryController cancellation.

It is still ordinary machine-control logic, not proof of a safety-rated protective stop.

## EtherCAT state witnesses

The per-joint layer keeps these facts separate:

- control word;
- status word;
- control mode command and feedback;
- error code;
- slave `online`;
- slave `oper`;
- STO witness where supported;
- actual position / following error / torque feedback.

The source explicitly notes that older IS620N drives do not expose the same STO function as SV660N/simulation. Safety capability therefore differs by drive generation; it cannot be inferred from the common high-level ROS interface.

## Remaining stale-command gap

This pass establishes fault-triggered quick-stop/control-word masking and enable-operation gating, but it still does not prove what happens if:

- `hal_control_node.funct` stops updating while EtherCAT and drives remain healthy;
- the ROS controller manager dies without generating a drive FAULT;
- a HAL command pin simply remains at its last finite value.

That requires tracing EtherCAT/device-manager watchdog/freshness and/or a specific controller-manager-loss path. Do not substitute the any-drive-fault quick-stop for a communications-staleness watchdog unless source proves they are coupled.

## Adversarial review

1. Does ros2_control position command go directly to an EtherCAT target? **No; joint limits and realtime shaping intervene.**
2. Is command presence equivalent to drive operation authority? **No; enable-operation gates the command/feedback processing path.**
3. Can one drive fault affect the others? **Yes; source describes forcing quick-stop low across all drive control words.**
4. Is this the same as safety-rated STO? **No.**
5. Are online/oper/error/STO interchangeable? **No; separate witnesses.**
6. Does cross-drive fault quick-stop prove stale ROS command containment? **No; controller-manager-loss without drive fault remains unresolved.**
7. Can STO assumptions be generalized across all ZA6 drive types? **No; source distinguishes models.**

Result: **7/7 boundaries preserved.**

## Next work

Trace `hw_device_mgr` and lcec/EtherCAT watchdog/freshness behavior specifically for loss of realtime command updates while drives are STARTed. In parallel trace JointTrajectoryController cancel/deactivate/hold semantics. Only after both ends are known should an RRBot or simulated ZA6 stale-command experiment be frozen.
