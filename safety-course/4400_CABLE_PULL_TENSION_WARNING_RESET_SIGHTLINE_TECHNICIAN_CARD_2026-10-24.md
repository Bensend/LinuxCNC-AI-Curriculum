# 4400 technician card — cable-pull E-stop warning is not proof of effective protection

**PAPER TRAINING ONLY.** Companion to [original manufacturer-source audit](../research/4400_CABLE_PULL_ESTOP_TENSION_MARGIN_GUARDLINK_STANDARD_TAG_SOURCE_AUDIT_2026-10-24.md). The cited Rockwell Lifeline 5 manual is **440E-IN008H-EN-P, February 2026**; Schmersal ZQ 900 manual is **103000117-EN/G, November 2023**. None of these devices is established as installed on OpenPressBrake. No energized fault injection, exposed-person machine test or safety release is authorized.

## First sketch four separate paths

`person can reach cable -> cable switch safety output -> independent safety controller/final element -> measured physical stop/hold`

**Parallel, not interchangeable:** `tension warning / GuardLink device tags -> maintenance diagnostics`.

**Separate recovery:** `fault diagnosed -> cable physically restored -> local device reset -> independent safety-controller rearm -> clear zone and fresh production start`.

## Twelve adversarial field scenarios

| ID | Technician situation | Required disposition and source-scope reasoning |
|---|---|---|
| CP-01 | Green Lifeline 5, amber flashing tension LED; machine runs. | **Do not call it healthy.** OEM table 6/7 says low **or** high tension warnings can coexist with safety outputs ON. Escalate inspection/adjustment, document owner and risk; warning is not a safety trip. |
| CP-02 | Lifeline 5 cable is cut; PLC HMI shows a stale green status. | OEM says cut/not tensioned should turn its safety outputs OFF; stale ordinary HMI status is not the safety path. Verify independent safety output/final element and physical safe state; no exposure while unknown. |
| CP-03 | Cable is accessible at both ends but hidden behind stored stock in the middle. | Reject full-span protection. Assess trapped rope, reach and pull directions. Re-route/add appropriately assessed protection; OEM requires full-span functional coverage. |
| CP-04 | Builder installs a generic spring and copies another vendor's support spacing. | Reject cross-product dimension transfer. Select exact model and its spring/anchors/supports/temperature envelope; verify cable geometry and activation. |
| CP-05 | A long cable's tension alarm appears only during cold mornings; staff wants to silence it. | Treat as temperature/stretch/maintenance design problem. Improve OEM-compatible tensioner, routing and service access. Disabling the warning is not a safety improvement. |
| CP-06 | Maintenance presses local rope-switch reset while the far end is out of view. | OEM Lifeline 5 requires entire cable visible **or inspected along its full length before and after resetting**. Verify hidden occupancy separately. Local reset does not restart machinery. |
| CP-07 | HMI `Reset` tag recovers a Lifeline 5 device after a GuardLink fault. | This is an OEM **standard-class** recoverable-device-fault reset command, not a safety PLC reset or proof of safe rearm. Confirm physical cause, safety output/final elements and separate start. |
| CP-08 | Engineer connects a LinuxCNC input to a 432ES `Data` device status tag as the sole E-stop condition. | Reject. OEM states that the `Data` connection and Lifeline 5 device tags are **non-safety-rated**. The qualified safety function must stay outside ordinary LinuxCNC/FPGA. |
| CP-09 | Retrofit swaps a Lifeline 5 5-pin device between OSSD and GuardLink modes without rewiring. | Reject. OEM table 4 assigns different functions to pins by mode. Freeze exact model, mode, connector, wiring, safety controller and revalidate. |
| CP-10 | Configured device says stainless single-head but discovered physical device is aluminum with local E-stop. | Treat as a variant mismatch; correct exact catalog/series/firmware and qualified integration. Do not disable electronic keying as a production workaround. |
| CP-11 | An OSSD series chain includes a dry-contact guard; engineer cites the OEM's all-OSSD `up to PLe` note. | Reject blanket transfer. OEM separately discusses a lower *maximum achievable* rating for mixed voltage-free-contact series **depending on installation**. Calculate/validate actual complete safety function, not a diagram label. |
| CP-12 | Rope pull turns OSSDs OFF; a suspended press-brake ram continues descending under gravity. | Device OFF is not sufficient. Hold exposure; identify independent physical stopping and gravity-load restraint, and require qualified physical witness. Do not invent pressure/stop-distance values. |

## The practical anti-bypass design review

- Can a person find and pull the cable **anywhere along its intended span**, including corners, at a realistic emergency posture, without tools or moving stock?
- Is the warning LED visible from the normal work area, and can tension be adjusted using the OEM procedure without awkward dismantling?
- Is the cable route protected from material snagging, debris and moving machinery, yet reachable by the person?
- Is the reset position in sight of the entire span? If not, is there an **effective, documented inspection and occupancy procedure** rather than an unrealistic instruction that operators will predictably skip?
- Does the maintenance procedure prevent the easiest shortcut from being tying the cable off, bridging the safety input or silencing nuisance alarms?
- Can operators distinguish **rope trip, rope slack/break, warning margin, electronic fault, controller rearm and ordinary start** in the interface?
- Can a technician replace a damaged switch without a production-only bypass? Keep correct spares and accessible connectors, but preserve safety validation after replacement.

## Blank evidence record

| Field | Record actual evidence or UNKNOWN |
|---|---|
| Machine/zone and hazard(s) covered; neighboring hazards | |
| Exact switch catalog, version/firmware and OEM document revision | |
| Cable span map, physical route, anchors, pulleys, guards and reset sightline | |
| Correct spring/tensioner and environment/temperature range | |
| Safety outputs, connector/mode, independent safety-controller input and diagnostics | |
| Qualified final elements, gravity/other stored energy and actual stop/hold witnesses | |
| Ordinary LinuxCNC status interface (read-only) and what it **cannot** prove | |
| Maintenance warning policy, inspection evidence, known nuisance incentives | |
| Distinct local release, safety reset/rearm, occupancy check, fresh start | |
| `CHG` after replacement/route change; stale `VAL/PT` evidence | |
| Current release status and unresolved hazards | **UNKNOWN / NOT RUN until demonstrated** |

**Grading cue for a fresh learner:** In every case distinguish `DOC-CONFIRMED` OEM behavior from `INFERENCE` failure risk and `UNKNOWN` selected physical machine state. These answers are learner-visible practice, **not** a blind evaluation key.

**Safety boundary:** If the required E-stop span or final-element stop/hold/occupancy proof is missing, the machine should **not** run with people exposed to the hazard. Any justified experiment must be isolated/remote, with people outside the danger zone and residual risk stated plainly.
