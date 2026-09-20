# Lane B checkpoint — external device monitoring / final-element feedback

Date: 2026-09-20

## Parallel-lane check

Immediately before durable work, current `main` showed the primary safety lane advancing energized hydraulic diagnostic authority (`checkpoints/2026-09-20T0656Z-energized-hydraulic-test-authority-next.md`) and controlled-energy maintenance/setup evidence. Lane B therefore selected a different device/evidence family and did not modify the primary lane's files.

## Durable work completed

Added:

- `safety-course/EXTERNAL_DEVICE_MONITORING_FINAL_ELEMENT_FEEDBACK_AUTHORITY_STUDY_2026-09-20.md`

The study traces external device monitoring (EDM) / contactor feedback as a distinct downstream final-element diagnostic and preserves the boundary between safety-output state, feedback state, physical main-contact state, and actual hazardous-energy/hazard state.

## Frozen distinctions

`SAFETY INPUT DEMAND != SAFETY OUTPUT OFF != CONTACTOR COIL DE-ENERGIZED != CONTACTOR MAIN POLES PHYSICALLY OPEN != HAZARDOUS ENERGY REMOVED`.

`EDM FEEDBACK CORRECT != MAIN POWER PATH PHYSICALLY VERIFIED OPEN != MACHINE HAZARD PHYSICALLY CEASED`.

`RESET REQUEST != EDM HEALTHY != SAFETY REQUALIFIED != FRESH ORDINARY START`.

`HAL EDM_STATUS = TRUE != PERSONNEL-SAFETY AUTHORITY`.

## Evidence state

Manufacturer documentation from SICK and Pilz supports the core EDM/final-element feedback behavior. The study explicitly labels DOC-CONFIRMED, SOURCE-CONFIRMED, INFERENCE, TEST-CONFIRMED, COMMUNITY-REPORTED, and UNKNOWN and makes no OpenPressBrake-specific safety-performance assumptions.

No executable verification was justified. No GitHub-hosted runner was used.

## Exact next work

Find a complete professional machine/OEM or manufacturer application implementation exposing:

`PROTECTIVE DEMAND -> SAFETY EVALUATOR -> TWO/REDUNDANT FINAL SWITCHING ELEMENTS -> INDIVIDUAL FEEDBACK/EDM -> DELIBERATE ONE-ELEMENT STUCK/WELDED CHALLENGE -> RESTART INHIBIT -> PHYSICAL HAZARD/ENERGY WITNESS -> CORRECTION -> REVALIDATION -> SAFETY RESET/REARM -> FRESH ORDINARY START`.

Prefer a schematic/application example that visibly includes both main switching contacts and their positively guided feedback contacts, plus commissioning/fault behavior. Do not drift back into the primary lane's energized hydraulic diagnostic package unless its current checkpoint has moved away from that work.

Before the next Lane-B write, re-read current `main`, recent commits, primary checkpoint, and this checkpoint. If the primary lane has moved into EDM/final-element electrical feedback, switch Lane B to another independent open safety evidence family rather than duplicating it.