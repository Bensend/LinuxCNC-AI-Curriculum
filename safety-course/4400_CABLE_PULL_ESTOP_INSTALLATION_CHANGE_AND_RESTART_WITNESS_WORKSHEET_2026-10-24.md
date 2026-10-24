# 4400 — Cable-pull E-stop installation, change and restart witness worksheet

**Blank engineering record.** Complete only for a selected machine with an actual cable-pull emergency-stop device. This is not a substitute for the manufacturer's installation manual, machine risk assessment, independent safety validation or qualified commissioning. Keep restricted machine drawings in the machine's private engineering records, not this public curriculum.

Reference [Rockwell Lifeline 5 / Lifeline 4 and Schmersal ZQ 900 source audit](../research/4400_CABLE_PULL_ESTOP_TENSION_MARGIN_GUARDLINK_STANDARD_TAG_SOURCE_AUDIT_2026-10-24.md). Mark every unobserved item **UNKNOWN**. Never mark a test passed from a green HMI/diagnostic bit.

## A. Hazard span and mechanical route

| Record ID | Required selected-machine evidence | Observation / source ID / status |
|---|---|---|
| `BND-CP` | Machine/zone, use case (conveyor, feeder, table perimeter etc.), lifecycle phases and whether this device is actually installed | UNKNOWN |
| `HAZ-CP` | Exposed people, locations, workpiece/robot/backgauge/ram hazards, adjacent E-stop spans | UNKNOWN |
| `SF-CP` | Exactly which hazardous motions/energies the cable pull must stop and what must remain held | UNKNOWN |
| `ARC-CP-ROPE` | Full route, cable length, reachable pull points, corners/pulleys, first/subsequent supports, spring/tensioner/anchors, obstructed or trapped-rope locations | UNKNOWN |
| `ARC-CP-ENV` | Temperature variation, debris, washdown, vibration, abrasion, stock interference and post-install stretch/retension | UNKNOWN |
| `ARC-CP-RESET` | Local reset position, full-span visibility or enforceable before/after inspection, hidden-person/whole-body access protections | UNKNOWN |

**Usability challenge:** A person with hands occupied or wearing gloves must be able to identify and actuate the intended cable in the real emergency posture. If not, redesign the route/protection; do not write a procedure that assumes impossible access.

## B. Safety chain versus diagnostic path

| Record ID | Selected evidence | Observation / status |
|---|---|---|
| `ARC-CP-DEVICE` | Exact OEM, model/suffix, series, firmware, date/code and **exact** manual edition | UNKNOWN |
| `ARC-CP-PINS` | NC/NO contacts **or** OSSD 5-/8-pin, mode, conductor map, protected routing, selected input fault detection | UNKNOWN |
| `ARC-CP-SAFETY` | Independent safety relay/PLC/safety network, actual safety input/channel, configuration/revision/CRC, fault/restart ownership | UNKNOWN |
| `ARC-CP-DIAG` | Ordinary warning/aux/GuardLink/diagnostic/HMI tags, freshness and display meaning; confirm none is silently promoted to personnel-safety authority | UNKNOWN |
| `ARC-CP-FINAL` | Exact contactors, drive STO, hydraulic/pneumatic valves, brake/hold mechanisms and actual protected loads | UNKNOWN |
| `DEP-CP` | 24 V/0 V, cable connectors, series device effects, contactor feedback, shared energy/common-cause dependencies | UNKNOWN |

**Special case:** Lifeline 5 warning-margin tension states can have **safety outputs ON**. A green indicator is not a pass. GuardLink 432ES device tags and `Data` connection are standard/non-safety-rated in the cited OEM edition; only a separately qualified safety path may own the protective function.

## C. Qualified validation witness plan (no live test authorized here)

| Witness ID | Physical or documentary proposition to establish | Qualified method/acceptance owner | Evidence / result |
|---|---|---|---|
| `VAL-CP-01` | Selected OEM cable routing, correct spring/tension, support/deflection and all intended pull directions/locations | To be specified by qualified reviewer | NOT RUN |
| `VAL-CP-02` | Pull/trip and broken/slack cable safety-chain response; no single status-bit substitution | To be specified with safe isolated test envelope | NOT RUN |
| `VAL-CP-03` | Warning margin escalation and repair before deterioration; maintenance access practical and bypass-resistant | To be specified by maintainer/owner | NOT RUN |
| `PHY-CP-STOP` | Actual downstream hazardous motion stops within machine-specific validated limits | Requires independent measurement/design-specific criteria | UNKNOWN |
| `PHY-CP-HOLD` | Gravity/external-load restraint after protective stop; stored energy remains controlled | Requires actual selected hardware witness | UNKNOWN |
| `PHY-CP-ACCESS` | Person cannot be trapped or newly exposed by partial span stop/adjacent motion | Requires selected hazard map and physical witness | UNKNOWN |
| `VAL-CP-04` | Local device reset does not itself start motion; independent safety rearm and fresh ordinary start | Qualified isolated verification plan | NOT RUN |
| `VAL-CP-05` | Loss/return of power, device replacement, changed rope route or firmware does not silently reauthorize motion | Qualified fault/change review | NOT RUN |

**Do not derive acceptance times, rope force, safety PL/SIL, stopping distance, or gravity restraint from the example OEM numbers.** Obtain selected-machine criteria and use qualified isolation/remote test methods with nobody exposed.

## D. Maintenance/change control and release

| `CHG-CP` trigger | Stale evidence to review |
|---|---|
| Switch or connector/firmware replacement, OSSD↔GuardLink mode change, changed controller mapping | `ARC-CP-PINS/SAFETY/DIAG`, `VAL-CP-02/04/05`, affected `PHY` |
| Cable replacement, support/pulley/anchor/guard or stock-route change | `ARC-CP-ROPE/ENV/RESET`, `VAL-CP-01/03`, `PHY-CP-ACCESS` |
| New workpiece/process/adjacent hazard or E-stop span | `BND/HAZ/SF` and every dependent `ARC/DEP/PHY/VAL/PT` |
| Safety final-element, hydraulic/drive, PSU, relay or controller change | `ARC-CP-FINAL/SAFETY`, `DEP-CP`, `PHY-CP-STOP/HOLD`, restart `VAL` |

**Release gate:** `G0/G1 HOLD` until selected machine intake and risk/architecture review; `G2 NOT RUN` until qualified physical validation; `G3/G4 NOT AUTHORIZED` for personnel-exposed hazardous operation while critical protection is unproved. Keep residual hazards and bypass/maintenance incentives visible in the record.

**Operator-facing principle:** The correct installation should be easier to reach, inspect, adjust and restore than to defeat. Make warning, fault, reset and start visibly different. An E-stop cable is supplementary protective equipment; it is **not** a guard, gravity hold, machine isolator, or ordinary LinuxCNC stop command.
