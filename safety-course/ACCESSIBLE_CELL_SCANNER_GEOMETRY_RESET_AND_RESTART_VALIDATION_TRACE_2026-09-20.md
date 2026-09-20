# Accessible-Cell Scanner Geometry, Reset and Restart Validation Trace

Date: 2026-09-20

## Purpose

Advance Lane B from general presence-sensing guidance toward an inspectable commissioning/validation contract for cells where a person can enter or stand behind an access field.

## Evidence classification

- **DOC-CONFIRMED:** current SICK S300 operating instructions (2024-09-12 revision).
- **DOC-CONFIRMED:** SICK safety-scanner configuration guidance for S3000/S300/S200.
- **DOC-CONFIRMED:** Pilz PSENscan area-monitoring application guidance.
- **INFERENCE:** curriculum validation contract below.
- **UNKNOWN:** a single manufacturer document found in this bounded pass that performs every desired adversarial commissioning action—deliberate stand-behind occupancy, stale-start challenge, final-element observation and fresh restart—in one scripted procedure.

## Geometry comes before reset logic

SICK explicitly requires restart interlock when a protective field can be left in the direction of the hazardous point or when a person cannot be detected at every point in the hazard area. Its configuration guidance tells the assessor to consider mounting-created unprotected areas and the scanner's unprotected near range.

Pilz independently states that protection against encroachment from behind is required where a person can enter a danger zone, and describes 2D scanner area monitoring that prevents hazardous movement from restarting while someone remains in the protected area.

Therefore a clear access field cannot be treated as personnel-clear evidence when the geometry permits a person to pass beyond that field.

## Reset location and visibility

Current SICK S300 instructions require the restart/reset control outside the hazardous area, inaccessible to a person inside, and located so the operator has a full view of the hazardous area.

SICK also distinguishes scanner reset from machine restart. With internal scanner restart interlock plus an external machine restart interlock, clearing the field and operating scanner reset can return the scanner OSSDs to ON, but the external restart interlock still prevents machine restart. The operator must then separately activate the machine-controller restart control.

That is strong manufacturer evidence for:

**PROTECTIVE FIELD CLEAR -> RESET/PREPARATION FOR RESTART -> SAFETY OUTPUT READY != MACHINE RESTART**

and for a deliberately fresh, separate machine-start authority after reset.

## Commissioning/validation contract derived from the sources

The following is a curriculum **INFERENCE**, not a claim that SICK or Pilz publishes this exact script. It is the minimum adversarial validation we should teach for an accessible cell when the architecture relies on area sensing plus manual restart:

1. Verify scanner mounting, protective-field geometry, near-field gaps, crawl-under/climb-over routes and any route that lets a person leave the access field toward the hazard.
2. If a person can become undetected after entry, do not authorize automatic restart merely because the access field becomes clear. Add validated continued-presence/clearance architecture or manual restart interlock appropriate to the geometry.
3. Deliberately occupy every credible stand-behind/blind location during validation; determine whether the designed presence/retention architecture continues to inhibit hazardous restart.
4. Verify the reset control cannot be reached from inside the hazardous area and that the operator at reset can actually see the area that the design assumes they are clearing.
5. Trigger the protective device and establish the safe output/final-element response required by the machine safety function.
6. Clear the access field while intentionally preserving a simulated retained-person condition. The machine must not silently convert `field clear` into `personnel clear` where the design says retained occupancy remains possible.
7. Exercise reset. Reset may prepare the safety function for restart; it must not itself create hazardous motion.
8. Challenge stale ordinary commands that were present before the protective-device trip/reset. They must not become fresh motion authority solely because the scanner OSSDs returned ON.
9. Require the defined fresh machine restart/start action after the safety function has been requalified and the area-clearance assumptions are satisfied.
10. Observe the physical final element/machine response, not just scanner LEDs or controller bits.

## Durable freezes

**ACCESS FIELD CLEAR != HAZARD AREA PERSONNEL-CLEAR.**

**SCANNER OSSD ON != MACHINE RESTART AUTHORIZED.**

**RESET OPERATED != HAZARDOUS MOTION AUTHORIZED.**

**RESET LOCATION OUTSIDE CELL != RESET OPERATOR HAS FULL VIEW OF REQUIRED CLEARANCE AREA.** Both placement and actual visibility matter.

**PROTECTIVE FIELD DRAWN IN SOFTWARE != INSTALLED GEOMETRY VALIDATED.** Mounting, near-field gaps and routes around/over/under the field are physical facts.

**FRESH SAFETY OUTPUT READY != STALE ORDINARY MOTION COMMAND FRESH.** Ordinary control must not acquire restart authority merely because the safety device recovered.

## Human factors

A reset station with poor visibility, awkward access or frequent nuisance trips creates predictable pressure to relocate, bypass or automate reset. Treat that inconvenience as a design defect. The intended safe recovery path should be obvious, quick and physically convenient while still forcing the operator to perform the required area-clearance check.

## OpenPressBrake / machine-class transfer

This pattern transfers to robot cells, automated feeders, saw cells, pallet systems and rear-access press-brake guarding, but the geometry and hazardous-energy final elements remain machine-specific. LinuxCNC/HMI may show scanner status and guide recovery, but a GUI acknowledgment must not substitute for validated area clearance, safety reset, final-element readiness and fresh start.

## Source provenance

1. SICK, S300 Safety Laser Scanner Operating Instructions, revision 2024-09-12: reset/restart control outside hazard, not operable from inside, full view required; scanner reset and external machine restart are separate actions; universal non-safe I/O must not control safety functions.
2. SICK, S3000/S300/S200 configuration guidance: restart interlock required where field can be left toward hazard or personnel cannot be detected everywhere; assess unprotected areas and near range.
3. Pilz, PSENscan area-monitoring guidance: encroachment-from-behind protection and continued area monitoring prevent hazardous restart while a person remains in the protected field.

## Remaining evidence target

Seek a manufacturer commissioning/acceptance procedure that explicitly scripts deliberate stand-behind occupancy and a stale-command restart challenge with observed final-element behavior. Do not invent that manufacturer procedure from the derived validation contract above.
