# 4400-RAD-01 — Staged commissioning and adversarial radio-control verification plan
**Status:** DESIGN/VERIFICATION PLAN ONLY — no machine, simulation or physical test executed. **Scope:** any selected machine with purpose-built wireless pendant or mobile control. This is not a step-by-step energized test authorization. Actual tests require qualified personnel, an approved site-specific risk assessment and persons excluded from the hazard zone.

## Why this plan exists
A transmitter's certified STOP claim, a receiver's PLd LED, a LinuxCNC E-stop bit and a safety PLC's ready status can all look healthy while an actual ram, spindle, robot or suspended workpiece remains hazardous. The critical engineering question is **which physical final element changes, what energy is removed or retained, and what prevents motion after communication returns?**

Read [R15/T19 exact OEM evidence](../research/4400_TELE_RADIO_R15_T19_WIRELESS_STOP_CONFIGURATION_AND_RESTART_OEM_AUDIT_2026-10-24.md), [R15 v09/v11 edition differences](../research/4400_TELE_RADIO_R15_V09_V11_VERSION_SCOPE_AND_POWER_CYCLE_AUDIT_2026-10-24.md), [IEC/FME general-purpose-device scope](../research/4400_IEC62745_FME_MOBILE_DEVICE_CABLELESS_SAFETY_AUTHORITY_SCOPE_2026-10-24.md), [RST-01](4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md), [HYD-01](4400_HYD_01_FASTDOWN_DRIVE_LOSS_VALVE_FEEDBACK_AND_PHYSICAL_HOLD_MODULE_2026-10-24.md) and [selected physical evidence intake](4400_SELECTED_MACHINE_PHYSICAL_WITNESS_INTAKE_AND_RELEASE_GATE_2026-10-23.md).

## Evidence gate 0 — Inventory, hazard map and machine-specific safe-state proposition
Without operating the machine, document exact transmitter/receiver/firmware/edition/certification, all paired devices, safety-rated versus standard outputs, normal LinuxCNC/FPGA I/O, local fixed E-stops, guards, isolation points, Y1/Y2 or other load-bearing actuators, and accessible stop/hold witness points. Distinguish each zone's STOP, gravity retention, workpiece retention and service isolation. Mark missing schematics, physical state and PL/SIL as UNKNOWN. **Gate remains HOLD** if basic independent protection cannot be established.

## Evidence gate 1 — Source and configuration consistency
Qualified reviewer checks manual applicability to exact firmware and transmitter pair, readback of continuous radio mode, all relays OFF on link loss, timeout, unique ID, login/logout and Require start, and OEM change-control/power-cycle rules. Do not treat the receiver PLd LED as proof of the actual final element. Compare as-built safety relay wiring to manufacturer terminal mapping and selected safety SRS. Check whether a standard CAN/PWM/relay or GUI input has been substituted for a certified STOP output. Record configuration hash/readback and revision, but do not claim physical proof.

## Evidence gate 2 — Deenergized / isolated chain inspection
With proper electrical/hydraulic isolation and gravity support, qualified personnel inspect the stop relay circuit, safety controller inputs, contactor/drive/valve final-element wiring, feedback/EDM, fusing, common 24 V/0 V, sensor cables, and alternate energization paths. A wired circuit diagram is source evidence, not terminal state. Avoid intrusive changes to a loaded or pressurized system; stop if isolation cannot be proven. No personnel enter a hazardous zone based solely on E-stop or radio link loss.

## Evidence gate 3 — Bounded nonhazardous electrical functional evidence
Only after independent hazard exclusion and a written qualified test procedure, observe the selected radio STOP terminals, safety-controller decisions and downstream final elements under a **nonhazardous configuration**. Preserve raw time-correlated terminal evidence and uncertainty. Separate button stop, link loss, receiver power loss, transmitter power loss and wrong-transmitter ownership. Do not assert that a green LED, software trace or relay coil dropout proves physical contact separation. This gate does not yet validate actual Y1/Y2 or machine stopping/holding.

## Evidence gate 4 — Protected physical stop/hold and fresh-start validation
A separately approved, guarded/remote site-specific validation plan must establish actual machine motion arrest, gravity/workpiece holding, occupancy protection and deliberate new cycle-start under selected relevant conditions. The machine's reaction-time and distance budget must include **all** safety chain components, not only the radio subsystem's OEM response. Do not create hydraulic truth tables, stop distances, pressure limits or PL targets from catalog examples. Use qualified measurement, controls and exclusion zones; do not perform fault injection with people exposed.

## Evidence gate 5 — Change control, operator experience and continuing proof
After replacement of transmitter, receiver, firmware, mode, antenna, final element, guards or power supplies, mark dependent evidence STALE and requalify affected gates. Make correct operation easy: clear pendant ID and owner, fixed local emergency-stop access, convenient storage/charging, visible fault reasons, local authorized reset, explicit fresh start and easy-to-reinstall guards. Prevent bypass after nuisance radio dropouts by engineering coverage/placement and fault diagnosis, **not** disabling safety STOP or extending timeout beyond selected product limits.

## Fault/abuse matrix — qualify every row, do not run unsafely
| ID | Challenge | Diagnostic observation only | Physical question | Unsafe inference to reject |
|---|---|---|---|---|
| RF-01 | Radio interference / lost link | receiver link LED, timeout | stop terminal + actual actuator stop/hold | LinuxCNC feed-hold alone protects people |
| RF-02 | Dead transmitter battery | battery warning and status | independent STOP plus gravity retention | transmitter OFF means energy isolated |
| RF-03 | Receiver brownout/recovery | Require start and link status | no unexpected motion on return | receiver STOP relay rearm equals machine start |
| RF-04 | Held/stuck jog button | HMI demand | fresh start prevents retained demand | new packet is new deliberate start |
| RF-05 | Wrong registered transmitter | ID/session logs | only intended operator can command | registered means authorized to move |
| RF-06 | Lost transmitter replacement | logout/replace menu | safe custody and lockout during takeover | service menu is safe with loaded ram |
| RF-07 | Discontinuous mode selected | PLd status indicator | qualified STOP no longer credited | ordinary buttons working proves safety |
| RF-08 | Receiver safety output contact fault | controller input vs contact | final element actually withdrawn | output image equals physical contact |
| RF-09 | Welded contactor or stuck valve | EDM/status | real hazardous energy removed/held | safety relay opening proves stop |
| RF-10 | Loss of pneumatic/hydraulic holding | pressure/valve readback | no load fall / uncontrolled descent | energy dump always safe |
| RF-11 | Operator out of sight | radio RSSI/ownership | occupancy and guard protection | wireless range equals safe visibility |
| RF-12 | App/tablet network reconnect | software connected status | no auto restart or remote safety reset | browser STOP is certified E-stop |
| RF-13 | Receiver firmware/manual mismatch | product IDs and versions | invalid safety claim quarantined | all R15 manuals interchangeable |
| RF-14 | PLd status LED OFF | configuration indication | independent output and physical proof | certified receiver means certified machine |

## Release decision and evidence classification
**SOURCE/DOC-CONFIRMED** means original implementation/manufacturer material supports a *bounded* statement. **TEST-CONFIRMED** requires accepted actual physical or authoritative runtime evidence for the claimed behavior; none exists here. **INFERENCE** describes credible fault paths needing verification. **UNKNOWN** is a release blocker where hazard consequences are severe. **COMMUNITY-REPORTED** is not used as a machine acceptance source.

**Minimum threshold:** no personnel-exposed hazardous operation if independent stop, holding, guarding and deliberate restart cannot be demonstrated. Experimental operation, if any, must be isolated/remote with people outside danger zones and residual risks plainly documented. This paper plan does **not** authorize a test or certify a machine.
