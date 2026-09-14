# 3500 — ZA6 launch supervision and controller-death boundary

Date: 2026-09-14
Status: SOURCE / bounded conclusion

## Purpose

Continue the ZA6 stale-command audit above the HAL/EtherCAT layer: determine whether launch supervision automatically converts controller-manager or support-node death into a robot STOP/quick-stop, or whether the previously identified command-freshness gap remains.

## Pinned sources

- `tormach/tormach_za_ros2_drivers@b58078aac3004f3932079ea7228ab0432cf8ac18`
- `tormach/hal_ros_control@506a3d109cb306e1d1cdb70f24440bde1159b256`

## Launch architecture

`za6_hardware/launch/hal_hardware.launch.py` places the real-hardware path inside `HalConfig` and starts, in order:

1. realtime `hal_control_node` through `HalRTNode`;
2. userspace `hw_device_mgr`;
3. userspace `hal_io`;
4. userspace `drive_state`;
5. HAL configuration files.

No explicit per-node `on_exit` action is supplied for those ZA6 `HalUserNode` declarations in the inspected launch file.

## What `HalRTNode` actually means

`HalRTNode` is not simply an ordinary independent executable process. Its deferred worker calls `rtapi.loadrt()` on the component path and waits for the HAL component to become ready. Therefore failure semantics for `hal_control_node` must be read from both the HAL RT component and the outer launch/HAL manager lifecycle rather than assumed from normal ROS node process supervision.

`hal_control_node` itself exports the realtime function:

`ControllerManager.read -> ControllerManager.update -> ControllerManager.write`

and maintains a `cm_ok` HAL pin. If `rclcpp::ok()` becomes false, it sets `CM_OK=0`, publishes that to the HAL pin, and immediately returns from the realtime function. The source-visible path does **not** reset command pins in that branch.

At component exit it also sets `CM_OK=0` before shutting down the executor/controller manager.

## Is `cm_ok` a ZA6 drive permissive?

A repository-wide search of `tormach/tormach_za_ros2_drivers` for `cm_ok` returned no use. In the inspected ZA6 repository there is therefore no evidence that `hal_control_node.cm_ok` is wired into `drive_safety`, `hw_device_mgr`, drive enable, quick stop, or a separate command-freshness watchdog.

This is a bounded source result: absence from this repository is not proof that an external deployment layer cannot add such wiring.

## What launch failures definitely do

`HalMgr`, which owns the overall HAL runtime startup, explicitly installs a default `on_exit` action that emits a global ROS Launch `Shutdown`. Ordered HAL actions also emit global shutdown if deferred setup throws or a readiness timeout expires.

Therefore:

- **HAL manager exit** -> explicit global launch shutdown;
- **initialization/readiness failure** -> explicit global launch shutdown.

These are genuine supervisory behaviors.

## What is not established for individual userspace nodes

`HalUserNode` adds readiness polling but does not itself add a default "on any child exit, command robot STOP" policy. The ZA6 launch declarations inspected here also do not provide per-node `on_exit` handlers for `hw_device_mgr`, `drive_state`, or `hal_io`.

Do not infer from "global launch will eventually terminate" that a specific, timely CiA-402 STOP or quick-stop transition is guaranteed for every individual support-node death. The inspected code does not establish that chain.

## Combined stale-command conclusion

The source-visible architecture therefore separates three failure classes:

1. **EtherCAT/drive fault** — detected through online/oper/status feedback and propagated into manager fault / drive-safety quick-stop behavior.
2. **HAL-manager / launch startup failure** — explicitly causes global launch shutdown.
3. **High-level controller-update loss while HAL/EtherCAT stay live** — `cm_ok` can go false and stop `read/update/write`, but the ZA6 config does not visibly use that pin as a drive permissive or freshness authority.

The third class remains the important gap. A stale high-level position target can remain distinct from fieldbus failure.

## Adversarial review

1. Does `cm_ok=0` itself reset ZA6 position-command pins? **No source-visible reset.**
2. Is `cm_ok` wired to quick stop in the inspected ZA6 repo? **No use found.**
3. Does HAL manager exit cause global Launch shutdown? **Yes, explicitly.**
4. Does an ordered HAL startup exception/readiness timeout cause Launch shutdown? **Yes.**
5. Does `HalUserNode` prove STOP/quick-stop on every individual user-node death? **No.**
6. Is global process shutdown equivalent to functional safety/STO? **No.**
7. Can external deployment/safety layers add stronger behavior? **Yes; this source trace does not exclude them.**

Adversarial result: **7/7 bounded claims survive.**

## Playbook promotion

For robot stacks that bridge ROS2 trajectory control into a persistent realtime/fieldbus layer, require the design to answer explicitly:

- what proves the controller command is fresh;
- what event invalidates a previously valid command;
- whether controller-process death requests HOLD, STOP, QUICK STOP, drive disable, or independent safety action;
- whether the invalidation is implemented in the realtime path, supervisor, drive manager, or external safety controller;
- what happens if the supervisor itself dies.

`process alive`, `ROS context OK`, `fieldbus online`, `drive operation enabled`, and `fresh trajectory command` are separate witnesses.

## Lab decision

Still no generic lab. Static source has answered whether a built-in freshness/`cm_ok` permissive exists in the inspected ZA6 repository. A future experiment is justified only to measure the timing and exact physical command/state transitions of a named node-death scenario in a reproducible ZA6/RRBot setup.
