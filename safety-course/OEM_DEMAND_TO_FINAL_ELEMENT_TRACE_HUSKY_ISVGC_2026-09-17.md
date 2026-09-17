# OEM demand-to-final-element trace — Husky Altanium ISVGC

Date: 2026-09-17

## Purpose

Trace a real professional machine subsystem far enough to distinguish protective-device demand, E-stop demand, safety logic, ordinary-control reaction, physical final safety action, diagnostics, and restart. This is a curriculum evidence artifact, not a design prescription for OpenPressBrake.

## Source

Primary manufacturer document: Husky Technologies, *Altanium Individual Servo Valve Gate Controller (ISVGC) User Guide*, v1.0, March 2023, 176 pages.

Public manufacturer URL: https://www.husky.co/contentassets/59b3dcff9d564dc998b386aa0f5ebb6b/altanium_individualservovalvegatecontroller_userguide_v1.0.pdf

Relevant material: connector/safety signal definitions pp. 19–21; safety-signal architecture pp. 26–30; safety-signal HMI definitions pp. 124–125; maintenance functional checks near p. 165.

## Evidence classification

All manufacturer-manual claims below are **DOC-CONFIRMED**. Architecture consequences not explicitly stated by Husky are labeled **INFERENCE**. Missing machine details remain **UNKNOWN**.

## Demand paths

| Demand | Input evidence | Safety processing | Immediate ordinary-control consequence | Delayed/final safety action | Physical result stated by OEM | Diagnostic/status evidence |
|---|---|---|---|---|---|---|
| IMM safety gate opens | Two isolated safety-gate channels from IMM; contacts closed only when mold-area safety devices permit injection | Gate channels feed isolated channels of safety relay K1 | Immediate relay contact tells control logic E-stop/safety-gates-open; controller commands valve stems closed | Time-released safety-relay contacts invoke servo STO after fixed 0.6 s | Valve stems move closed first, then actuator movement is stopped | HMI exposes `IMM Safety Gates Closed`; K1 LEDs provide relay-state troubleshooting |
| IMM/cell E-stop demand | Two isolated IMM E-stop channels; contacts open when IMM/cell E-stop operates | E-stop channels feed isolated channels of safety relay K2 | Immediate relay contact tells control logic of demand; valve stems are commanded closed | Time-released contacts invoke servo STO after fixed 0.6 s | All valve-gate stem movement is stopped after the close-before-STO sequence | HMI exposes `IMM E-Stop OK`; K2 LEDs provide relay-state troubleshooting |
| ISVGC local E-stop | Two isolated NC channels are exported into the IMM E-stop circuit; IMM returns its E-stop state to ISVGC | In integrated operation, local E-stop participates in the IMM E-stop chain; returned IMM E-stop channels then act through K2 | Same close-first control response when returned safety demand opens | Same delayed STO path | Local E-stop must cause emergency stop of IMM; returned E-stop state stops ISVGC movement | Software separately monitors local button for alarm as a diagnostic, not as sole safety authority |
| Broken/disconnected safety-signal wiring | Normally-closed safety circuits open on broken wire/cable disconnect | K1/K2 safety relay input path drops | Same safe-state sequence is initiated | Delayed STO follows | OEM states system defaults to safe condition with stems moving closed | Relay LEDs and HMI states assist troubleshooting |

## Important physical-final-element finding

**DOC-CONFIRMED:** The manual exposes the final servo safety function: time-released contacts from the safety relays invoke the servo system's **Safe Torque Off (STO)** function. Husky states that STO stops control of the servo-system power unit and prevents dangerous axis movement.

This is stronger evidence than an application example that ends at a safety-controller output: the documented chain reaches the drive safety integration function and the required machine-motion consequence.

The 0.6-second value is **machine/product-specific OEM evidence** for this ISVGC sequence only. It must not be reused as a generic LinuxCNC, press-brake, robot, or servo timing value.

## Safety demand versus process-protective sequencing

The architecture deliberately does not apply STO instantaneously. A safety demand first causes the ordinary controller to command the valve stems closed to reduce plastic drooling, then the time-delayed safety path invokes STO.

**INFERENCE:** This is a useful example of ordinary control participating in a process-friendly stop sequence while independent safety hardware still owns the eventual torque-removal boundary. The ordinary close command is not the personnel-safety final element.

Frozen curriculum rule:

> A safety demand may legitimately trigger an ordinary-control deceleration/positioning/process sequence before the independent final safety action, but the safety case must not depend on ordinary LinuxCNC/HAL/FPGA software successfully completing that sequence unless that path is itself established as safety-related by the machine design.

## Status/diagnostic boundary

The manual provides unusually clear separation:

- Safety signals are non-adjustable and part of a relay safety circuit.
- HMI exposes `IMM E-Stop OK`, `IMM Safety Gates Closed`, `Controller E-Stop OK`, and bench-plug status.
- Local E-stop status is software-monitored for diagnostic alarm purposes.
- K1/K2 LEDs provide relay troubleshooting states.
- Controller logic checks the configured 0.6-second relay delay and alarms if it is incorrect.

None of these diagnostic/status indications independently proves that STO actually removed torque or that all hazards in the injection-molding cell are isolated.

Frozen proof hierarchy:

`displayed safety input state -> safety-relay state -> delayed safety-output action -> drive STO function -> observed hazardous-motion result`

Each arrow requires evidence appropriate to the claim. A green HMI status is not a substitute for the physical functional check.

## Restart / functional-test evidence

The maintenance procedure requires physical checks of E-stop devices and safety gates: operate/open the device, verify movement in the molding cell stops, restore the device, and then start the IMM. The separate `start` after restoring the safeguard is important evidence that safeguard restoration is not intended to be motion-start authority.

This supports the existing curriculum rule:

`RESET / SAFEGUARD RESTORATION != START`

## What remains energized / what is not proved

**UNKNOWN:** The public manual does not establish that all electrical power is removed when STO is active. STO is a drive torque-prevention function, not a general lockout/isolation claim.

**UNKNOWN:** Exact servo-drive model and internal STO topology are not exposed in the inspected passages.

**UNKNOWN:** Complete IMM hydraulic, pneumatic, heater, clamp, injection, robot, hot-runner, gravity and stored-energy paths are outside this subsystem trace.

**UNKNOWN:** Exact external IMM safety logic and final elements are not established by this ISVGC manual.

Therefore this architecture cannot support the statement `E-STOP = MACHINE DE-ENERGIZED` or `STO = SAFE FOR MAINTENANCE`.

## Failure-path review

1. **Ordinary controller fails to command stems closed:** the delayed hardware path must still reach STO after the documented interval; loss of the process-friendly close sequence must not silently cancel final safety action.
2. **Safety relay timing misconfigured:** controller checks the 0.6-s setting and alarms. Diagnostic checking is useful, but commissioning/maintenance still needs functional proof of the resulting stop behavior.
3. **One safety-signal conductor opens:** NC/two-channel architecture is intended to move toward the safe state rather than interpret loss of wiring as permission.
4. **HMI freezes on `OK`:** stale display cannot overrule the hardwired safety-relay path; the HMI indication must be treated as diagnostic/status evidence only.
5. **STO active while other energy remains:** maintenance still requires task-specific hazardous-energy control. STO does not prove heaters, stored mechanical energy, pressure, or other cell hazards are absent.
6. **Safeguard restored:** restoration alone must not create hazardous motion; OEM maintenance procedure explicitly calls for a subsequent start action.

## Transfer to LinuxCNC/OpenPressBrake

For an ordinary LinuxCNC/FPGA machine, preserve four lanes:

1. **Safety demand acquisition** — independent safety devices/safety logic.
2. **Ordinary-control reaction** — LinuxCNC/HAL/FPGA may receive a status and perform useful process handling, diagnostics or commanded stopping.
3. **Independent final safety action** — safety-rated contactor/STO/valve/brake/blocking architecture appropriate to the actual machine hazard.
4. **Physical validation** — prove the hazardous motion/energy result on the installed machine and prove deliberate reset/rearm/start behavior.

Do not copy Husky's 0.6-s delay, PL claim, relay configuration, or STO architecture into OpenPressBrake without machine-specific risk analysis and manufacturer evidence.

## Information-gain result

This source closes the prior checkpoint's main evidence gap for a professional implementation: it exposes **both safety-gate and E-stop demands**, separate hardwired safety relays, ordinary-control response, a delayed **physical drive safety function (STO)**, HMI/relay diagnostics, and physical maintenance checks with a separate subsequent start.

The remaining high-value gap is now different: trace a professional hydraulic vertical-axis/press implementation where the final safety elements include actual hydraulic blocking/dump/holding elements and where the documentation exposes their feedback/monitoring and reset/restart behavior. That would test transfer of the same demand-to-final-element method where `remove torque` is insufficient because gravity/stored hydraulic energy remains.
