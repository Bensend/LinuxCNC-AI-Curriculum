# Presence sensing, rear access, and restart-interlock authority study

Date: 2026-09-20

## Purpose and parallel-lane boundary

This independent Lane-B study deliberately avoids the primary lane's current final-element EDM/STO/hydraulic physical-witness work. It addresses a different hazard: a person can cross an access-detection field and then occupy a hazardous area where the original access sensor no longer detects them.

The architectural question is: **what evidence prevents restart after access detection when the entrant may remain inside or behind the protective field?**

## Evidence classification

### SICK safety laser scanner restart-interlock guidance

**DOC-CONFIRMED:** SICK microScan3 documentation says a restart interlock prevents automatic restart after an ESPE demand or machine operating-mode change. Reset returns the protective device to monitoring status; machine start is a separate second step. Reset itself must not introduce movement or a dangerous situation.

**DOC-CONFIRMED:** SICK states that a restart interlock is required depending on the application, and specifically calls out the case where it is possible to stand behind the protective field. Automatic reset is only allowed in special cases where a person cannot be in the hazardous area without triggering the protective device, or where absence of people during/after reset is otherwise ensured.

**DOC-CONFIRMED:** SICK S300/S3000 instructions warn that when a protective field can be exited toward the hazardous point, or a person cannot be detected at every point in the hazardous area, restart interlock is imperative. They require the reset/restart control outside the hazardous area, inaccessible from inside it, and positioned so the operator has a full view of the hazardous area.

**DOC-CONFIRMED:** Where scanner-internal and machine-external restart interlocks are both used, SICK documents two distinct actions: first reset the scanner/protective device, then separately activate the machine-controller restart control.

### Pilz rear-access protection

**SOURCE-CONFIRMED:** Pilz describes safety laser scanner rear-access protection as detecting a person's current location in difficult-to-see danger zones so hazardous movement cannot restart while occupancy remains detected.

This is useful corroboration for the architectural distinction between **access detection** and **continued presence detection**.

## Architecture freeze

Preserve these distinctions:

`ACCESS FIELD BROKEN != PERSON ENTERED HAZARD AREA != PERSON CURRENTLY DETECTED != HAZARD AREA PERSONNEL-CLEAR`

`ACCESS FIELD CLEAR != HAZARD AREA CLEAR != RESTART INTERLOCK SATISFIED`

`PROTECTIVE DEVICE RESET != SAFETY REQUALIFIED != MACHINE RESTART AUTHORIZED != FRESH ORDINARY START`

`RESET BUTTON HAS VIEW OF AREA != AREA ACTUALLY INSPECTED/CLEAR`

A clear access light curtain/scanner field proves only that its current protective field is clear. If a person can pass beyond that field, field-clear is not evidence that the person left the hazard area.

## LinuxCNC / FPGA boundary

A LinuxCNC HAL bit such as `scanner_clear`, `guard_clear`, or `restart_ready` is useful for indication and sequencing but must not be promoted into personnel-safety authority merely because it is TRUE.

An ordinary FPGA can display/log access-field state and safety-system diagnostics. It does not acquire authority to decide that a hidden or stand-behind area is personnel-clear unless the complete sensing, logic, reset, diagnostic and final-element architecture is designed and validated for that safety function.

Freeze:

`HAL SCANNER_CLEAR = TRUE != PERSONNEL CLEAR`

and

`LINUXCNC START REQUEST != SAFETY RESTART PERMISSION`.

## Failure-path / commissioning matrix

A professional commissioning plan should deliberately challenge at least:

1. Person interrupts access field and immediately exits back out — stop/restart behavior follows the intended sequence.
2. Person interrupts access field, proceeds behind/outside the access field, and remains in the hazard area — clearing the access field must not silently become restart authority.
3. Person remains in an area intended to be covered by presence sensing — verify the protective function remains demanded according to the validated design.
4. Deliberate test of seams, occluded regions, near-field/unsecured regions, or scanner shadowing — record coverage limitations rather than assuming geometric completeness.
5. Reset attempted from inside the hazard area — the architecture must not rely on an inside-accessible reset where the documented application requires outside reset.
6. Reset attempted without full visibility/personnel-clear procedure — reject the assumption that reset-button operation itself proves clearance.
7. Protective-device reset with a stale LinuxCNC START/CYCLE/JOG request present — reset must not convert stale ordinary control into hazardous motion.
8. Scanner/protective-device reset succeeds but machine restart interlock remains unsatisfied — machine remains stopped.
9. Power restoration after an access demand — do not infer restart authority from a now-clear field.
10. Sensor replacement, field-set/configuration change, mounting movement, or machine geometry change — revalidate coverage and restart behavior before return to service.
11. Safety output/final-element response — separately verify the actual machine stopping function; presence sensing and restart interlock do not prove physical stop performance.

## What this study does not establish

The following OpenPressBrake facts remain **UNKNOWN** unless separately measured/designed/documented:

- whether a safety laser scanner, light curtain, mat, guard, or other device is appropriate;
- protective-field dimensions, resolution, mounting, blind zones, or separation distance;
- machine stopping time/distance;
- required PL/SIL/category/DC/CCF;
- exact reset location or personnel-clear procedure;
- whether automatic restart is permissible for any OpenPressBrake operating mode;
- hydraulic/electrical final-element topology or stopping behavior.

No machine-specific safety distance, scanner geometry, stopping performance, hydraulic truth table, or timing value is inferred here.

## Reusable design lesson

For accessible machinery, treat **entry detection**, **continued presence detection**, **personnel-clear determination**, **protective-device reset**, **safety requalification**, and **fresh production start** as separate authorities. Which layers are required depends on the actual hazard geometry and risk assessment, but one layer must not be silently substituted for another.

A practical sequence to validate is:

`APPROACH/ENTRY -> PROTECTIVE DEMAND -> ACTUAL MACHINE STOP -> POSSIBLE STAND-BEHIND OCCUPANCY -> PERSONNEL EXIT/CLEARANCE -> PROTECTIVE DEVICE RESET -> SAFETY REQUALIFICATION -> STALE-COMMAND CHALLENGE -> SEPARATE FRESH START`.

## Source provenance

- SICK, *microScan3 Safety Laser Scanner Operating Instructions*, restart-interlock section: restart interlock after ESPE response/mode change; reset returns monitoring state; separate start; stand-behind condition; automatic-reset restrictions. **DOC-CONFIRMED**.
- SICK, *S300 Safety Laser Scanner Operating Instructions* (2024-09-12), restart/reset section: reset control outside hazard area, inaccessible from inside, full view required; internal protective-device reset and external machine restart are distinct. **DOC-CONFIRMED**.
- SICK, *S3000 PROFINET IO operating instructions*, restart-interlock section: restart interlock required where protective field can be exited toward hazard or person cannot be detected everywhere. **DOC-CONFIRMED**.
- Pilz, *PSENscan safety laser scanner* product/application guidance: rear-access protection detects current location to prevent hazardous movement restarting. **SOURCE-CONFIRMED** at application-guidance level.

## Information-gain boundary / precise next work

This pass establishes the stand-behind/restart-interlock architecture without duplicating the primary final-element lane. Next Lane-B work should seek a complete professional **accessible-cell presence-sensing commissioning/validation sequence** showing field geometry or blind-area analysis, deliberate stand-behind occupancy, reset location/visibility, stale-command challenge, safety-output/final-element response, and fresh restart. Prefer a manufacturer/OEM validation example with diagrams and explicit test cases rather than another generic restart definition.

No executable verification is justified by the current question, so no runner compute is required.