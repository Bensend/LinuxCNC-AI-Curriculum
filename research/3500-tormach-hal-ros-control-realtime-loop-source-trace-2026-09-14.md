# 3500 ROS2 — Tormach HAL/ros2_control realtime loop source trace

Date: 2026-09-14
Pinned implementation revision: `tormach/hal_ros_control@506a3d109cb306e1d1cdb70f24440bde1159b256`
Status: **SOURCE-CONFIRMED IMPLEMENTATION CONTRACT**

## Purpose

Trace one real ROS2/HAL execution architecture deeply enough to identify who owns command/state transfer, realtime ordering, controller reset and shutdown behavior. This supplements the existing 3500 ROS/ROS2 implementation deep dive.

This is Machinekit-HAL-derived Tormach code, not LinuxCNC Motion. Do not import the behavior into native LinuxCNC robot control without an explicit compatibility trace.

## Realtime ownership

`hal_control_node.cpp` creates a ROS2 `controller_manager::ControllerManager`, exports a HAL realtime function named `hal_control_node.funct`, and expects that function to be scheduled in a HAL realtime thread.

The realtime function executes exactly:

`controller_manager.read(now, period)`
`-> controller_manager.update(now, period)`
`-> controller_manager.write(now, period)`

and records maximum observed duration separately for read, update and write.

The RRBot reference HAL creates a 100 Hz thread and adds `hal_control_node.funct` to it. This proves that in this architecture the controller-manager update cadence is owned by the HAL thread, not by an ordinary ROS executor timer.

The ROS `MultiThreadedExecutor` runs separately in a userspace thread for services/timers/node work.

## Hardware-interface data path

`HalSystemInterface` implements `hardware_interface::SystemInterface`.

For every declared joint command interface it creates a HAL **output** pin named conceptually:

`<system>.<joint>.<interface>_cmd`

For every declared joint/sensor state interface it creates a HAL **input** pin named:

`<system>.<joint>.<interface>_fb`.

The `read()` callback copies HAL feedback pin values into ros2_control state-interface storage.

The `write()` callback copies ros2_control command-interface storage into HAL command pins.

Therefore the exact runtime flow is:

`field/HAL feedback -> HAL *_fb pin -> HalSystemInterface::read -> ros2_control state -> controller update -> ros2_control command -> HalSystemInterface::write -> HAL *_cmd pin -> field/HAL command path`

This is a memory-copy bridge at the SystemInterface boundary; it does not by itself impose servo limits, drive readiness, brake authority, watchdog semantics or fieldbus safety.

## Controller reset behavior

`hal_control_node` exports a `reset` HAL pin. A non-realtime 10 ms timer watches it. When high, the callback:

1. clears the pin;
2. enumerates active controllers;
3. requests each active controller be stopped and started again with `BEST_EFFORT` and `start_asap=true`.

The source comment states the intent is to reset controller command to feedback through controller `on_activate()` behavior.

This is an important boundary: the reset mechanism relies on each controller's activation semantics. The generic HAL SystemInterface itself does not force command==feedback in `on_activate()`.

## Lifecycle and stale-output boundary

`HalSystemInterface::on_activate()` and `on_deactivate()` only log and return SUCCESS. They do not explicitly overwrite HAL command pins.

Likewise, `hal_control_node::funct()` checks `CM_OK`; when false it returns before read/update/write. `rtapi_app_exit()` sets `CM_OK=0` before tearing down the ROS executor/controller manager, but the inspected source does not explicitly zero the HAL joint command pins first.

Therefore at this bridge layer:

`controller manager stopped/unhealthy != command pin explicitly driven to safe value`.

A downstream HAL component, EtherCAT drive layer, device manager, watchdog, enable chain or external safety circuit may still make the machine safe. This source trace simply shows that **the generic bridge itself is not the safe-output owner**.

That finding mirrors a reusable cross-machine lesson from native LinuxCNC Motion DOUT work: persistence of a software command value and physical actuator authorization are separate state domains.

## RRBot example ordering

The RRBot HAL file demonstrates a simple simulated plant:

- `hal_control_node.funct` is added to the 100 Hz thread first;
- position command pins feed `limit3` components;
- `limit3` outputs return as position feedback;
- the thread is then started.

Because HAL function execution order matters, the controller manager reads feedback from the prior plant update, updates controllers, writes new commands, and the later `limit3` functions advance simulated position in the same thread cycle. This example is a useful timing fixture but is not a real-drive commissioning contract.

## ROS executor vs realtime loop

The asynchronous ROS executor handles node/service/timer work in a separate pthread named `ros2_ctl_mgr`. The controller-manager realtime read/update/write is called from the HAL realtime function. This partition is one of the strongest architectural reasons the Tormach implementation is more than a naive 'ROS topic to HAL pin' bridge.

However, source-level proof of the HAL thread's realtime properties does not prove DDS/services/timers are realtime; they are intentionally outside the HAL realtime execution function.

## Failure/authority model

The implementation should be taught with at least these distinct states:

1. ROS graph/executor alive;
2. controller manager healthy (`cm_ok`);
3. controller lifecycle active;
4. command-interface storage value;
5. HAL command-pin value;
6. downstream HAL/drive enable state;
7. EtherCAT/device-manager freshness/fault state;
8. brake state;
9. safety/STO state.

A value at layer 4 or 5 is not proof of authorization at layers 6-9.

## Adversarial review

1. **Does ros2_control update on an ordinary ROS timer in this implementation?** No. The read/update/write sequence runs from an exported HAL realtime function.
2. **Does the ROS executor share the realtime HAL thread?** No. It is spun in a separate userspace thread.
3. **Does `HalSystemInterface::on_deactivate()` explicitly zero command pins?** No.
4. **Does `CM_OK=0` explicitly zero command pins before the realtime function returns?** No source-visible reset in the inspected layer.
5. **Does the HAL bridge itself prove drive/brake safety?** No.
6. **Does the reset pin directly copy feedback into command pins?** No; it restarts active controllers and relies on their activation behavior.
7. **Can the RRBot loop order be treated as a production EtherCAT timing contract?** No; it is a simulation/reference fixture.
8. **Is this evidence for LinuxCNC Motion behavior?** No; it is a distinct ROS2 + Machinekit-HAL-derived execution architecture.

Result: **8/8 boundaries preserved.**

## Next work

1. Trace the current ros2_control `controller_manager`/ResourceManager read-update-write and hardware lifecycle contracts at the version used by the current ZA6 stack, then compare to this pinned bridge.
2. Trace JointTrajectoryController action cancellation/tolerance/error behavior and what command remains after cancel/deactivate.
3. Trace ZA6 downstream enable/device-manager/EtherCAT authority to find the actual stale-command and fault-containment owner.
4. Only then assess direct current-LinuxCNC HAL compatibility; do not assume Machinekit private HAL APIs map unchanged.

## Lab decision

No lab is run yet. Source already resolves the read/update/write ordering and exposes a more valuable unresolved question: downstream stale-command containment. A bounded RRBot cancel/reset experiment becomes useful only after JointTrajectoryController lifecycle semantics are source-traced so the expected behavior is explicit.
