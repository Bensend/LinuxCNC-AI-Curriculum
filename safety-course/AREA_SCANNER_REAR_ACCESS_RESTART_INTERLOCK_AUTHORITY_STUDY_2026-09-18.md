# Area-Scanner Rear-Access / Restart-Interlock Authority Study — 2026-09-18

## Lane and scope
Independent Lane B study. Selected after reading current repository guidance and recent primary-lane work. The primary lane is advancing hydraulic return-to-service physical re-proof; this artifact stays on the protective-device/restart-authority side and does not modify primary hydraulic files.

This is an architecture/evidence study, not a machine-specific design. It does not assign OpenPressBrake scanner geometry, stopping distance/time, field size, hydraulic truth table, PL/SIL/category/DC, reset location, or pressure thresholds.

## Evidence labels
- **SOURCE-CONFIRMED** — directly supported by authoritative manufacturer material cited below.
- **DOC-CONFIRMED** — confirmed by repository durable documentation.
- **TEST-CONFIRMED** — requires an executed test with retained evidence; none newly claimed here.
- **COMMUNITY-REPORTED** — community evidence only; none used for the freezes below.
- **INFERENCE** — engineering conclusion drawn from confirmed source behavior; must not be promoted to machine fact without validation.
- **UNKNOWN** — machine-specific fact not established.

## Architecture freeze

**PROTECTIVE FIELD CLEAR != HAZARD AREA PERSONNEL CLEAR != RESTART INTERLOCK SATISFIED != RESET ACCEPTED != SAFETY OUTPUT RESTORED != EXTERNAL FINAL ELEMENT PROVED != HAZARDOUS MOTION AUTHORIZED != FRESH ORDINARY START.**

Additional freeze:

**WARNING FIELD CLEAR != PROTECTIVE FIELD CLEAR.** A warning/pre-warning field may be used to warn or initiate a non-final response; the protective field is the safety field whose intrusion drives the protective stop function in the documented scanner architectures.

**RESET != START.** Reset/restart-interlock acknowledgement restores the protective-device/safety-side readiness condition; it must not itself command hazardous motion. Ordinary LinuxCNC/HAL/FPGA START/JOG/CYCLE remains a separate, fresh command after safety authority has returned.

## Source trace

### SICK S300 / S3000 family
**SOURCE-CONFIRMED:** SICK defines the protective field as the area whose intrusion switches associated safety outputs OFF so the dangerous state can be brought to an end. SICK separately defines reset and restart interlock: after a protective-device stop, the stopped state is maintained until reset; reset returns the protective device to monitoring state, but movement is only permitted after a separate start command.

**SOURCE-CONFIRMED:** SICK states restart interlock is required where the protective field can be left in the direction of the hazardous point or where a person cannot be detected at every point in the hazard area. In that case, clearing the field alone must not restore the OSSD outputs; an operator restart/reset action is required.

**SOURCE-CONFIRMED:** In S300 integration with a Flexi Soft safety controller, using OSSD status versus raw protective-field status changes where restart-interlock authority resides. If the controller consumes protective-field status rather than OSSD status, the scanner's internal restart interlock does not automatically act on the controller; the restart interlock must be implemented in the safety controller. This is an important interface-boundary lesson: a diagnostic/sensor status bit is not equivalent to the scanner's safety-output state machine.

**SOURCE-CONFIRMED:** SICK microScan3 supports external device monitoring (EDM). When configured, the scanner checks external-device feedback after its OSSDs switch off; missing expected feedback can place the scanner in a locking state and prevent OSSD re-enable.

Sources:
- SICK S300 operating instructions, current publication surfaced 2025-08-19: https://www.sick.com/media/docs/3/13/613/operating_instructions_s300_safety_laser_scanner_en_im0017613.pdf
- SICK S3000/S300/S200 configuration help, restart section: https://www.sick.com/media/content/h40/hff/9693003546654.pdf
- SICK microScan3 operating instructions, restart interlock + EDM: https://www.sick.com/media/docs/7/57/757/Operating_instructions_microScan3_Safety_laser_scanner_en_IM0063757.PDF

### Pilz PSENscan
**SOURCE-CONFIRMED:** Pilz distinguishes warning zones from protected fields. Its stationary safeguarding example describes warning-zone entry producing an earlier controlled reaction while protected-field entry stops hazardous movement. Pilz also identifies rear-access protection as an application where a scanner detects a person's location in a difficult-to-see danger zone to prevent hazardous movement from restarting.

Source: https://www.pilz.com/en-US/products/sensor-technology/safety-laser-scanner

## Transfer to LinuxCNC/OpenPressBrake curriculum

**INFERENCE:** Ordinary LinuxCNC may display scanner state, machine state, diagnostics, or a safety permissive, but it must not become the sole authority deciding that a hidden/person-retaining hazard area is clear when the safety architecture relies on rear-access presence detection or restart interlock.

**INFERENCE:** A machine UI showing `SCANNER CLEAR` is insufficient evidence for `PERSONNEL CLEAR`, particularly where someone can leave the currently active field, stand in an unobserved area, or where field-set selection/integration changes what the safety controller actually evaluates.

**INFERENCE:** If scanner OSSD state is replaced in an integration by lower-level field-status data, the designer must explicitly preserve restart-interlock behavior in the independent safety evaluator. Treating a raw `field clear` bit as equivalent to `OSSD ready after valid reset` can silently delete the restart barrier.

## Question-driven commissioning / failure-path matrix

| Challenge | Required evidence / expected architecture result |
|---|---|
| Person enters protective field | Safety-side stop demand; final element transitions to required safe reaction; physical hazard witness checked where required. |
| Person leaves active field but remains in hazard area | Restart must remain inhibited where rear-access/person-retention risk exists; clearing the active field is not personnel-clear proof. |
| Warning field clears while protective field remains occupied | No inference of protective-field clearance from warning-field state. |
| Protective field clears | No automatic hazardous restart where restart interlock is required. |
| Reset pressed with person still in retained/blind area | Reset must not be accepted as personnel-clear evidence merely because the immediate field is clear. |
| Reset accepted | No hazardous movement from reset itself; fresh ordinary START/JOG/CYCLE remains required. |
| OSSD OFF but external contactor/final element fails to change state | EDM/final-element disagreement must prevent normal safety-output restoration where that monitoring is part of the design. |
| Safety controller consumes raw protective-field status instead of scanner OSSD status | Verify restart interlock exists in the safety controller; do not assume scanner-local interlock still protects the machine output path. |
| Scanner/controller power cycle after intrusion | Verify no unintended restart and verify required reset/restart-interlock state is retained/re-established according to the actual safety design. |
| Field-set/mode selection changes | Verify the correct field is active before granting motion authority; ordinary LinuxCNC mode selection is not safety proof. |
| Scanner misalignment/obstruction/diagnostic fault | Required safety reaction and fault retention must be validated; do not substitute an ordinary-control warning for safety authority. |
| LinuxCNC START remains asserted while safety permission is absent | When safety permission returns, stale intent must not silently become a fresh hazardous-motion command. |

## Machine-specific UNKNOWNs
- Whether OpenPressBrake needs an area scanner at all.
- Whether bodily entry/rear access is possible in the final machine/guard arrangement.
- Required scanner type, field geometry, resolution, mounting, response time, separation distance, and field-set selection logic.
- Required stop category, hydraulic final elements, ram/load disposition, or stored-energy handling after a scanner demand.
- Required EDM/final-element feedback architecture.
- Reset location, visibility requirements, and personnel-clear method.
- Required performance level/SIL/category/diagnostic coverage/common-cause measures.

These must come from the actual risk assessment, machine geometry, stopping measurements, chosen safety hardware, applicable standards, and commissioning evidence.

## No compute used
No simulation, synthesis, benchmark, or executable verification was justified for this source-tracing question. No GitHub-hosted runner was used. Future executable work, if justified, must target `[self-hosted, openpressbrake]` only.

## Precise next Lane-B checkpoint
Find a complete professional stationary machine/cell implementation exposing:

`protective-field intrusion -> independent safety evaluator -> safety output -> physical final element -> physical stop witness -> person leaves field but remains in/re-enters retained area -> restart remains inhibited -> personnel-clear/rear-access proof -> deliberate reset -> EDM/final-element proof -> safety rearm -> separate fresh ordinary START`

Prefer an implementation that also documents one failure case: scanner/field-set mismatch, failed EDM/contact feedback, power restoration, blocked/misaligned scanner, or a raw-field-status integration that requires restart interlock in the safety controller.
