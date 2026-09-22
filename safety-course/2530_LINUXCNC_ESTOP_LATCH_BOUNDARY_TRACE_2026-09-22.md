# 2530 — LinuxCNC `estop_latch` boundary trace

Purpose: establish what LinuxCNC's software E-stop latch actually does so the safety course can use it correctly for ordinary control/coordination without assigning it independent personnel-safety authority.

Pinned upstream revision: `LinuxCNC/linuxcnc` commit `514be4f657b2f1c432ebaaebd117ef112e3e7565`.

Source: `src/hal/components/estop_latch.comp`.

## Source-confirmed state machine

**SOURCE-CONFIRMED:** The component describes itself as a **Software ESTOP latch** and as part of a **simple software ESTOP chain**. It has `OK` and `Faulted` states. Initial state is faulted.

Inputs:

- `ok_in`, default true;
- `fault_in`, default false;
- `reset`.

Outputs:

- `ok_out`, initial false;
- `fault_out`, initial true;
- `watchdog`.

The function enters/indicates OK only when `ok_in` is true, `fault_in` is false, and `reset` has a false-to-true transition. In OK, `ok_out` is true, `fault_out` is false, and `watchdog` toggles. If `ok_in` becomes false or `fault_in` true, the function clears `ok_out` and asserts `fault_out`. Reset is edge-detected by retaining `old_reset` in component state.

The source's typical integration suggestion is external fault/E-stop -> `fault_in`, `iocontrol.0.user-request-enable` -> `reset`, and `ok_out` -> `iocontrol.0.emc-enable-in`. It says more complex software chains may use ClassicLadder.

Source URL: https://github.com/LinuxCNC/linuxcnc/blob/514be4f657b2f1c432ebaaebd117ef112e3e7565/src/hal/components/estop_latch.comp

## What this proves

The component is useful ordinary-control logic for:

- latching a software fault state;
- requiring a reset edge before returning its software permission output;
- combining an `ok_in` permissive with a `fault_in` trip;
- presenting fault/OK/watchdog state to other HAL logic;
- coordinating LinuxCNC machine-enable behavior with an external fault/safety system.

## What it does not prove

Nothing in this source establishes a safety-rated execution environment, certified safety integrity, redundant physical input path, cross-short detection, safety-rated final element, EDM, physical standstill, pressure exhaustion, brake engagement, personnel clearance, stopping distance, or machine-specific emergency safe state.

Therefore:

- **SOURCE-CONFIRMED:** `estop_latch` is software state/coordination logic.
- **INFERENCE constrained by the course safety boundary:** it may mirror or coordinate with an independent safety system, but this source is not evidence that the component itself can own a personnel-safety function.
- **UNKNOWN:** any safety-integrity claim for a larger architecture containing LinuxCNC would require independent evidence for that architecture; do not infer one from this component.

## Important implementation trap

The component defaults unconnected `ok_in` and `fault_in` to non-fault-causing values. Its own description says at least one relevant fault source must be connected for it to signal a fault. A learner must therefore inspect the actual HAL net, not infer an external E-stop path merely because `estop_latch` is loaded.

Also, the watchdog toggles only while the component's software state is OK. That is a useful liveness signal, but **WATCHDOG TOGGLING != PHYSICAL SAFE STATE PROVED** and **WATCHDOG STOPPED != A DEFINED MACHINE-SAFE REACTION** unless downstream independent architecture explicitly establishes that reaction.

## Integration pattern for the safety course

Preferred conceptual boundary:

`physical E-stop/protective device -> independent safety-related logic -> safety-rated/appropriate final elements -> hazardous energy reaction`

and separately:

`independent safety state / diagnostics -> LinuxCNC HAL ordinary-control permission and status`

LinuxCNC can stop issuing normal motion, inhibit cycle execution, display the trip, record diagnostics, and require an ordinary-control reset sequence. Those functions improve coordination and usability. They do not replace the independent path that must achieve the required physical emergency reaction.

## Freeze

**LINUXCNC `estop_latch` RESET EDGE != SAFETY-SYSTEM RESET VALIDATION != PERSONNEL CLEAR != MACHINE START AUTHORIZED.**

**LINUXCNC SOFTWARE WATCHDOG/LATCH STATE != MACHINE PHYSICAL SAFE-STATE EVIDENCE.**
