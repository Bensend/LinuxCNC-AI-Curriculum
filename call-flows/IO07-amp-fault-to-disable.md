# IO07 — joint amplifier fault to disable call flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence state: SOURCE-CONFIRMED unless marked otherwise.

## Servo-cycle fault path

1. `emcmotController()` runs once per servo period.
2. `process_inputs()` reads `joint.N.amp-fault-in` for each active joint and copies it into the internal JOINT_FAULT flag.
3. `check_for_faults()` runs in the same controller invocation. For an active+enabled joint with JOINT_FAULT set, it reports `joint N amplifier fault`, sets JOINT_ERROR, and clears `emcmotInternal->enabling`.
4. `set_operating_mode()` sees the desired-enable state low while the controller is currently enabled. It clears the trajectory planner/interpolators, disables free planners, cancels homing, sets each active joint's JOINT_ENABLE flag false, and clears MOTION_ENABLE. It intentionally does not clear joint/motion error flags.
5. Later in the same `emcmotController()` invocation, `output_to_hal()` publishes:
   - `motion.motion-enabled = GET_MOTION_ENABLE_FLAG()`;
   - `joint.N.amp-enable-out = GET_JOINT_ENABLE_FLAG(joint)`;
   - `joint.N.error` and `joint.N.faulted` from their internal flags.
6. HAL functions ordered after motion may consume the newly published amp-enable state according to the configured thread/function order. IO04/IO05 then define the downstream HostMot2/module-specific command path.

## What this proves

A cleanly sampled joint amp fault is designed to collapse LinuxCNC motion/joint enable state and publish `amp-enable-out = FALSE` within the same motion-controller invocation. This is a software/realtime control path.

It does **not** prove:

- the downstream HAL net exists or is correctly wired;
- a HostMot2 write is successfully delivered;
- a remote/drive accepts or acts on the disable;
- motor torque reaches zero within a bounded time;
- stored energy is removed;
- the path is safety-rated.

## Communication-fault contrast

A HostMot2 `io_error` or failed read/write is a different path. Generic HostMot2 may stop processing fresh I/O while communication is unhealthy. Motion can therefore continue seeing stale HAL values unless some separately wired fault/watchdog/logic causes it to disable. Do not describe `io_error` as if it were automatically `joint.N.amp-fault-in`.

HM08 watchdog bite state is also separate. A watchdog may drive firmware-defined fail behavior and exposes `watchdog.has_bit`, but that is not the same state variable or call chain as motion's joint amp fault.

## Safety boundary

A real machine can and often should arrange an external safety function so STO/safety relays remove hazardous drive capability independently of LinuxCNC. LinuxCNC may observe that safety state and coordinate orderly machine-control behavior, but the safety function must not depend solely on this software call flow unless independently justified by a suitable safety architecture.
