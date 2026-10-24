# 4400-MAT-01 — Floor occupancy sensing and safe rearm (source-reading module)
**Date:** 2026-10-24. **Status:** SOURCE-READING / PAPER PRACTICE / NOT GRADUATED. **Machine applicability:** conditional. This is a 4000-level practical safety-design follow-on to 2520, 2530, 2540, 2570, 2590, 25E0 and 4400-ESPE-01; it does not replace them or reopen graduated 1000–3000 work.

## Objective
A fresh AI engineer or technician should be able to distinguish a floor mat used as (1) a trip sensor during approach, (2) an occupancy sensor inside a guarded cell, and (3) an **inadequate** proxy for physical stopping, gravity-load holding or energy isolation. They should be able to trace a chosen OEM sensor/trim/evaluator/safety-controller/final-element/rearm chain, find bypassable standing surfaces, and specify safe qualification without fabricating stop times or a PL/SIL.

## Required source reading
- [Rockwell 440F-C4000P/D January 2024 and Schmersal SMS4/5 OEM/ISO source audit](../research/4400_PRESSURE_MAT_OCCUPANCY_DEAD_ZONE_RESET_AND_OEM_SCOPE_AUDIT_2026-10-24.md) with exact manufacturer URLs/printed pages.
- [Fourteen adversarial technician scenarios](4400_PRESSURE_MAT_OCCUPANCY_SEAM_RESET_TECHNICIAN_CARD_2026-10-24.md).
- [Blank selected-machine floor/coverage/restart worksheet](4400_PRESSURE_MAT_FLOOR_COVERAGE_AND_RESET_BLANK_WITNESS_2026-10-24.md).
- Existing [SICK S300/S3000 ESPE source-reading module](4400_ESPE_01_SAFETY_SCANNER_EFI_SIGNAL_SEMANTICS_AND_RESTART_MODULE_2026-10-24.md) and [cable-pull versus tactile-edge function matrix](4400_CABLE_PULL_VS_TACTILE_EDGE_FUNCTION_SELECTION_AND_HUMAN_FACTORS_MATRIX_2026-10-24.md).

## Functional decomposition: five boundaries
| Boundary | Required proposition | Common false shortcut |
|---|---|---|
| `BND/HAZ` | All accessible floor/raised paths, modes and material-handling tasks identified | 'Mat covers the doorway' means cell cannot be occupied |
| `SF/SRS` | Define trip, continuous presence, stop/hold and fresh-start requirements **separately** | A mat output proves no person is in the machine |
| `ARC/DEP` | Exact sensor, active joining trim, cable/monitor, safety controller, independent final element and reset wiring | Four wires and a green HMI status are sufficient |
| `PHY/VAL/PT` | Qualified physical stop, hold, residual energy, occupancy and rearm proof under approved isolation/remote plan | Mat's 35 ms output response is machine stopping time |
| `CHG` | Floor cover, trim, pallet route, platform, mat replacement, software/mode and hydraulic changes invalidate relevant proof | Previously accepted mat test survives any floor change |

## Critical source lessons
1. **Effective sensing area is installed geometry, not nominal mat dimensions.** Rockwell uses active uniting trim and explicitly requires inspection of mat joints. Schmersal requires properly joined, secured adjacent mats and cable protection. A pallet bridge, machine base, stool or overhead platform is an independent bypass path.
2. **Product detection population matters.** Rockwell's cited 2024 system targets adults >=35 kg and is explicitly unsuitable for children. ISO 13856-1:2013's public scope for some >20 kg designs does not change that selected product's capability. Do not infer safety for an unmeasured body/posture.
3. **Controller reset is not machine restart.** Rockwell's auto-reset mode requires a separate machine reset; manual mode still must not turn reset into a motion command. The auxiliary output is for status, not safety. Schmersal's monitor-specific autostart/reset positions cannot be generalized to another unit.
4. **Output OFF is not necessarily a stopped/held ram.** The Rockwell manual explicitly distinguishes single-contactor weld vulnerability from dual-contactor monitoring. Neither schematic proves independent hydraulic load holding or safe residual-energy removal.
5. **Manufacturer calculations are not portable.** The Rockwell January 2024 example uses an older ISO 13855 method and its own 35 ms mat response plus an illustrative machine response. Actual current-edition method, Type-C rules, worst-case measured machine stopping, guard geometry and gravity effects must be established before numerical acceptance.

## Architecture sketch — conceptual only
`[floor mat + active joints] -> [compatible monitored evaluator] -> [independent safety logic with rearm/occupancy] -> [qualified final elements] -> [verified physical stop/hold]`

A separate non-safety diagnostic branch may provide `mat-zone-state / warning / stale` to LinuxCNC. **Never** route that ordinary diagnostic bit as sole personnel-safety authority. Reset the safety function only when the selected risk assessment's occupancy-clearing conditions are satisfied; a separate deliberate new start is required when hazardous motion could otherwise resume.

## Applied comparison
**Press brake rear:** A mat may contribute to rear access detection if actual access/standing routes and stopping/holding requirements support it. It does not guard the front bending point or restrain Y1/Y2. **Robot cell:** A mat within fixed guarding can help detect someone remaining on the floor, but does not see a person standing on a fixture or suspended platform. **Conveyor/feeder:** Floor mat may be vulnerable to pallet traffic; fix logistics and provide guarding rather than encouraging plywood bridges. **Mill/lathe:** A mat cannot replace guarding against flying chips or spindle door interlocks. **Plasma/laser:** A mat does not protect against fumes, heat or optical radiation.

## Adversarial completion criteria
- Identify at least two credible unsensed paths for a proposed floor layout; do not claim all-area presence from a doorway trip.
- Explain why a Rockwell 35 kg claim cannot be replaced by ISO's >20 kg device-class scope.
- Trace auto-reset plus retained ordinary CNC demand into a hazardous restart *unless* independent machine logic blocks it.
- Explain why a single welded contactor may defeat a copied OEM example and why the hydraulic press needs a separate gravity-load hold claim.
- Give a qualified, non-human-exposure commissioning plan with machine prime mover isolated for sensor/logic checks and independent physical validation planned separately.
- Explain what floor/joint/trim/mode changes stale the acceptance package and how to make the guard easy to maintain without bypass.

## Evidence / graduation decision
**DOC-CONFIRMED:** OEM behavior in cited revisions and ISO public scope. **INFERENCE:** bypass paths and human-factor incentives until observed at the selected machine. **UNKNOWN:** installed mats, coverage, actual safety wiring, Y1/Y2 stop/hold, safe rearm, physical tests, required PL/SIL and numeric distances. **TEST-CONFIRMED:** none. No fresh independent handoff or external score has been obtained for this module; the paper scenarios are not blind. The counterfactual test fails for any selected-machine claim because physical/coverage facts could overturn it; therefore **NOT GRADUATED / NOT AUTHORIZED** for personnel-exposed operation. External independent assessment should use a new OEM/layout case, sealed source until learner precommit, not the published practice answers. No lab is justified: the unresolved questions require actual selected-machine geometry and physical evidence.
