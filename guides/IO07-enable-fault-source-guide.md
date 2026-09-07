# IO07 — hardware enable and fault patterns — source guide

Course level: 1000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Evidence: SOURCE-CONFIRMED unless marked otherwise.

## Objective

Distinguish command intent, ordinary LinuxCNC fault handling, hardware-facing enable signals, transport/watchdog faults, and external safety functions. A fresh AI must not equate a HAL enable bit, a HostMot2 watchdog, or a drive's ordinary enable input with a safety-rated STO function.

## Taxonomy

1. **Motion enable state / command intent.** `emcmotInternal->enabling` is the desired controller enable state. `GET_MOTION_ENABLE_FLAG()` is the current motion-enabled state. They are ordinary machine-control state.
2. **Joint amplifier enable intent.** `joint.N.amp-enable-out` is a HAL OUT bit documented as TRUE when the joint amplifier *should* be enabled. Pinned motion publishes it from `GET_JOINT_ENABLE_FLAG(joint)` in `output_to_hal()`.
3. **Joint amplifier fault input.** `joint.N.amp-fault-in` is HAL IN. `process_inputs()` samples it into the joint fault flag. `check_for_faults()` treats a fault on an active+enabled joint as a controller fault: it sets joint error and clears `emcmotInternal->enabling`.
4. **Output-module enable.** HAL commonly routes `joint.N.amp-enable-out` to a PID/stepgen/Smart-Serial enable. IO04/IO05 show these are module/remote command paths, not independent safety channels.
5. **HostMot2 communication/watchdog fault state.** HM08 established that `watchdog.has_bit`, `needs_reset`, and LLIO `io_error` are driver/recovery state. They can inhibit fresh I/O but do not establish a safety-rated stop.
6. **External drive fault/status.** Smart Serial remotes and external drives can report faults that may be mapped into LinuxCNC HAL. Those reports are diagnostics/control inputs; exact semantics are drive/interface specific.
7. **External safety function.** STO, safety relays/controllers, force-guided contactors, and other safety-rated architecture are outside ordinary LinuxCNC HAL semantics. Functional-safety validity requires device certifications, wiring/category/PL/SIL analysis, diagnostics, reaction-time analysis, and machine hazard analysis.

## Official documentation pass

Current LinuxCNC `motion(9)` documentation states:

- `joint.N.amp-enable-out`: TRUE if the amplifier for the joint should be enabled.
- `joint.N.amp-fault-in`: should be driven TRUE when an external amplifier fault is detected.
- `joint.N.error`: reports a joint error condition.

Reference: https://www.linuxcnc.org/docs/devel/html/en/man/man9/axis.9.html

Current Code Notes describe controller ENABLE/DISABLE as turning active-joint amp-enable outputs on/off; these are controller semantics, not a certification claim. Reference: https://www.linuxcnc.org/docs/master/html/en/code/code-notes.html (language-localized mirrors may differ).

## Community pass

Community reports are retained as diagnostic leads, not authoritative safety claims:

- Forum users routinely connect drive alarm outputs to `joint.N.amp-fault-in` to stop motion and surface an amplifier fault: https://forum.linuxcnc.org/24-hal-components/49026-amp-fault-setup-joint-x-amp-fault-in
- Experienced users distinguish normal LinuxCNC control from an external E-stop/STO safety circuit; recent field discussions explicitly recommend safety-rated external hardware rather than relying on LinuxCNC software alone: https://www.forum.linuxcnc.org/9-installing-linuxcnc/59173-external-estop-trouble
- Systems without STO may remove drive power or use other hardware, but recovery and stopping behavior are machine/drive dependent: https://forum.linuxcnc.org/ethercat/55333-e-stop-and-ethercat-drives-going-offline

These posts are COMMUNITY-REPORTED. They do not substitute for a standards-compliant machine safety analysis.

## Pinned source inventory

### `src/emc/motion/control.c`

`emcmotController()` executes once per servo period. Relevant ordering is:

`process_inputs()` -> `check_for_faults()` -> `set_operating_mode()` -> position/control work -> `output_to_hal()`.

`process_inputs()` samples `joint_data->amp_fault` every cycle for active joints and sets/clears the internal JOINT_FAULT flag.

`check_for_faults()` checks only active+enabled joints for amp fault. On fault it reports `joint %d amplifier fault`, sets JOINT_ERROR, and clears `emcmotInternal->enabling`.

`set_operating_mode()` observes `!emcmotInternal->enabling && GET_MOTION_ENABLE_FLAG()`, flushes planner/interpolator state, disables active joints with `SET_JOINT_ENABLE_FLAG(joint, 0)`, cancels homing, and clears the motion-enable flag. It deliberately preserves joint/motion error flags so the reason for disable is not erased.

`output_to_hal()` later publishes `joint.N.amp-enable-out` from the joint-enable flag and `motion.motion-enabled` from the motion-enable flag. Thus a sampled amp fault can produce a published disabled state in the same invocation of the controller, subject to the normal HAL/thread scheduling boundary after motion.

### `src/emc/motion/motion.c`

Exports `joint.N.amp-enable-out` as HAL OUT and `joint.N.amp-fault-in` as HAL IN. This is the public HAL interface; source does not grant it safety integrity.

### HostMot2 prerequisite

HM08: generic HostMot2 reads/writes stop while LLIO `io_error` is asserted; watchdog bite/recovery is separate from motion's amp-fault state machine. A frozen/stale HAL signal must not be interpreted as fresh hardware state without proving the transport/read path completed.

### IO04/IO05 prerequisites

A downstream PWMGen/Smart-Serial `enable` is an output command into that subsystem. Its disabled electrical behavior is mode/firmware/device dependent. The fact that a controller writes `enable=0` is not physical proof of zero torque or safe energy removal.

## Important distinctions

- `joint.N.amp-enable-out = 0` means LinuxCNC is commanding that amplifier path disabled; it is not proof that the drive is torque-free.
- `joint.N.amp-fault-in = 1` is a controller fault input; it is not necessarily latched by LinuxCNC forever. The current sampled fault flag follows HAL input, while joint error state can remain to explain the disable until the controller is re-enabled/recovered.
- A HostMot2 watchdog bite can make hardware outputs enter a firmware-defined fail state, but HM08 has only DOC/SOURCE evidence for that boundary here; it is not a safety-rating claim.
- `io_error` can prevent fresh HostMot2 I/O; stale HAL observations are therefore a separate failure class from a cleanly processed drive fault.
- External STO is a safety function only when implemented/validated using suitable safety-rated hardware and architecture. Ordinary HAL wiring is not transformed into STO by naming it `estop`, `enable`, or `fault`.

## Failure-oriented debugging sequence

For a drive that unexpectedly disables: establish whether motion itself disabled (`motion.motion-enabled`, `joint.N.error`, `joint.N.faulted`), whether the drive reported `amp-fault-in`, whether HostMot2 communication is healthy, whether the downstream enable pin actually changed, and only then diagnose physical drive/STO/power behavior.

For a drive that stays energized after LinuxCNC disables: verify the HAL net and downstream module/remote enable, then treat physical torque removal as an electrical/drive/safety investigation. Do not infer successful disable from the HAL bit alone.

## Higher-level promotion

- Exact command-to-physical-torque reaction time across HAL/HostMot2/network/drive: 2000 + commissioning / CRITICAL.
- Integrated fault injection combining `amp-fault-in`, HostMot2 `io_error`, watchdog bite, and stale feedback: S03/S06/2000 / HIGH.
- Drive-specific fault-reset/STO semantics and certified safety architecture: safety/commissioning / CRITICAL.
- Cross-version motion enable/fault state-machine differences: 2000 / MEDIUM.
