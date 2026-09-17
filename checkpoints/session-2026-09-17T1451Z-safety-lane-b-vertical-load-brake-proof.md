# Safety curriculum Lane-B checkpoint — vertical-load brake proof

Date: 2026-09-17

## Parallel-work check

Before selection, current governance, `PROGRESS.md`, safety-course inventory, recent commits, the newest durable primary work, and the latest checkpoint were inspected. Primary work had just completed `PROFESSIONAL_PRESS_BRAKE_BENDGUARD_PERIODIC_VALIDATION_TRACE.md`, so Lane B did not touch BendGuard, TRUMPF/SICK protective-device validation, or those files.

The primary checkpoint explicitly identified a distinct safe-motion branch as useful next work. Existing `CROSS_MACHINE_SAFE_MOTION_AND_CELL_REFERENCE_2026-09-16.md` was also inspected; it already establishes the broad safe-motion/STO/maintenance-isolation distinctions. Lane B therefore narrowed its work to the unresolved physical brake/vertical-load proof chain rather than duplicating the overview.

Immediately before durable write, current `main` was re-read via the recent-commit list. No intervening overlapping commit had appeared. After commit `e7bb2c45`, current `main` was checked again; Lane B's commit was directly above the primary checkpoint with no overlap.

## Durable work

Commit `e7bb2c45` adds:

- `safety-course/PROFESSIONAL_SAFE_MOTION_VERTICAL_LOAD_BRAKE_PROOF_TRACE.md`

Evidence gain:

- `DOC-CONFIRMED` Schneider Lexium 32M: STO disables the power stage, but vertical/external-force loads may require additional measures; where hanging-load retention is a safety objective, Schneider requires an appropriate external safety-related brake rather than crediting the internal holding brake.
- `DOC-CONFIRMED` Siemens SINAMICS S120 separates SS1, STO, Safe Brake Control (SBC), and Safe Brake Test (SBT).
- `DOC-CONFIRMED` Siemens SBT physically challenges a closed brake using configured test torque/force and evaluates movement/position deviation over a configured duration; electrical brake control/status is therefore not the complete holding-capability claim.
- `DOC-CONFIRMED` Siemens requires renewed acceptance testing after safety-function changes and warns that measured acceptance-test distance/time values are typical observations, not worst-case values from which maximum overtravel may be derived.
- `INFERENCE` the curriculum must preserve separate claims for safe stop, torque removal, brake control, physical load retention, and servicing isolation.

Frozen rules:

> STO does not inherently prove gravity/external-load retention.

> Brake-command/coil diagnostics do not inherently prove physical holding capability.

> A measured successful stop is evidence for the tested condition, not automatically a worst-case safety distance.

## Deliberate UNKNOWNs

No OpenPressBrake brake architecture, safe speed, stopping time/distance, brake torque/force, permitted movement, proof-test interval, PL/SIL/DC, hydraulic truth table, pressure threshold, or worst-case load condition was invented.

## Compute

None. This was source/documentation work. No simulation or executable verification question justified use of the self-hosted `[self-hosted, openpressbrake]` runner, and no GitHub-hosted runner was used.

## Precise next independent work

Trace a professional robot/automation-cell application with zone-specific safety authority and visible final elements: protective demand -> safety logic -> affected-zone STO/SS1/SLS and/or fluid-energy isolation -> unaffected-zone behavior -> reset/restart. The goal is to distinguish safety-rated zone logic from ordinary PLC/robot/LinuxCNC state and to identify common-cause/final-element verification obligations. Prefer a manufacturer application guide or OEM documentation exposing the end-to-end chain. If the primary lane enters robot/cell work first, rotate to pneumatic dump/monitored-valve periodic proof or hydraulic load-holding valve proof.
