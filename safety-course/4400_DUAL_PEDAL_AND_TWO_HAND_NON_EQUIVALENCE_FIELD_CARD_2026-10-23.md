# 4400 technician field card — dual-foot-pedal AND is not two-hand guarding

Date: 2026-10-23. Learner-facing exercise; **not a machine release checklist**. Companion research: `../research/4400_TWO_PEDAL_AND_VS_TWO_HAND_SAFETY_FUNCTION_BOUNDARY_2026-10-23.md`.

## Scenario

A hydraulic press brake has two guarded foot switches and a Fiessler FMSC-FP selector. The display reads `AND`. The installer proposes removing the point-of-operation light curtain because both operators must press their pedals.

**Assignment:** decide exactly which proposition the selector supports, what is unproven, what safety-related controller/final-element behavior must be separately established, and what the team should do before people are exposed.

## Fill in the evidence chain

| Link | Exact selected evidence (or UNKNOWN) | Proven proposition | Not proven / residual risk |
|---|---|---|---|
| Operator A / pedal 1 input | | | |
| Operator B / pedal 2 input | | | |
| FMSC-FP selected mode and fault response | | | |
| Independent safety-related logic / output | | | |
| Physical valve, brake, restraint or other final element | | | |
| Beam/ram stopping and load holding | | | |
| Hands, other persons and workpiece-sweep exposure | | | |
| Ordinary LinuxCNC start/reset/rearm | | | |

Do **not** write an invented hydraulic valve truth table, PL/SIL, stopping distance, or diagnostic interval.

## Four ordered challenges

1. **Steady-state AND:** pedal A is held before B is pressed. Identify whether the installed safety logic tests a fresh transition, simultaneity, release-before-reinitiation or only input levels. Do not borrow two-hand behavior from ISO 13851 without evidence for the installed pedal interface.
2. **Wrong mode:** a technician selects OR instead of AND and both LEDs appear healthy. Which `CHG/ARC/AUTH/VAL` records become stale? What would actually detect that one pedal can initiate the ordinary cycle?
3. **Wrong hazard coverage:** both operators press their pedals but one holds sheet metal near a die, and a bystander stands in a rear access zone. Identify separate safeguards needed for those exposures. A pedal cannot prove where a hand or bystander is.
4. **False confidence after reset:** both pedals remain depressed through a protective stop, E-stop reset or power restoration. Explain which safety and ordinary-cycle transitions must be independently verified, including actual final-element stop/hold and a new start requirement when specified by the selected machine SRS.

## Practical human-factors redesign

Sketch a configuration that makes the intended operation the easiest: guarded but usable pedals, clear authorized mode indication, controlled mode selection, reliable fault localization, quick guard restoration and a service method that does not reward bypassing safeguards. State which changes are ergonomic and which are actual credited safety functions.

## Minimum field evidence for a real machine

Record the exact FMSC-FP hardware/manual and wiring, selected safety-program revision, foot-switch model/contacts, operator/mode geometry, separate point-of-operation/rear/workpiece safeguards, output and physical energy-removal/holding path, reset/restart ownership, and validation witnesses. Mark absent facts `UNKNOWN` and corresponding tests `NOT RUN`. If basic protection cannot be established, do not run hazardous motion with people exposed; isolate/remote-test with all people outside the danger zone.

## Provenance / scope

- **DOC-CONFIRMED:** Fiessler's product page lists foot-pedal 1, foot-pedal 2, OR and AND selection: https://www.fiessler.de/en/products/safety-products/safety-footpedals/safety-foot-pedals-fe-fs.php
- **DOC-CONFIRMED:** ISO 13851:2019 defines a *two-hand* device by actuation by hand, and expressly does not select the device type for a given machine: https://www.iso.org/standard/70295.html
- **DOC-CONFIRMED:** OSHA's press-brake guidance identifies accidental foot-pedal cycling and workpiece motion as hazards: https://www.osha.gov/etools/machine-guarding/presses/powered-press-brakes
- **DOC-CONFIRMED scope caveat:** OSHA 1910.217(a)(5) excludes press brakes; do not apply its mechanical-power-press clauses as if binding here: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217
- **INFERENCE:** pedal AND concurrence does not establish the protective function of a two-hand device, machine stopping, or reach prevention.
- **UNKNOWN / NOT TEST-CONFIRMED:** all installed-machine circuit, geometry, reset and physical stopping/holding claims.

**Release rule:** no learner answer, Boolean truth table or safety-device LED alone constitutes machine safety validation.
