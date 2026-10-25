# 4400-OVERRIDE-01 — Twelve unscored recovery / bypass-incentive scenarios
**PAPER ONLY | NOT RUN | NOT BLIND | 2026-10-25**

Use the [original OEM audit](../research/4400_SICK_2026_MUTING_OVERRIDE_RESET_SHARED_CONTROL_AND_COUNTER_RESET_AUDIT_2026-10-25.md). For each: classify **what device indicates**, **what hazard remains**, **what is unknown**, and **what safer practical redesign prevents routine bypass**. Do not energize a machine to demonstrate these cases.

1. A material jam causes override-required while the curtain is interrupted. What must be distinguished from the actual physical hazard state?
2. The selected deTec4 override makes OSSDs ON. What separate downstream authority must prevent a retained LinuxCNC cycle-start command?
3. A shared reset/override button is marked only RESET. How could an operator misunderstand its role, and what should change?
4. A technician argues that five permitted consecutive overrides means a lifetime maximum of five. Identify the OEM counter behavior and its limited evidentiary value.
5. A supervisor proposes a power cycle to clear an override count. Explain why this is not an acceptable operational safety strategy.
6. A Smart Box Detection Override is active. Can the unmonitored protective field be treated as proof of person absence?
7. A recovery switch is inside the hazardous zone. What OEM location/visibility assumption is violated?
8. The recovery operator cannot see the rear of the cell. Identify the missing occupancy protection and safer workflow.
9. Automatic protective-field-width calibration begins while material blocks the curtain. Which product-specific termination uncertainty must be reviewed?
10. A conveyor's muting/override application note is copied into a hydraulic press-brake bend program. Identify the machine-class transfer error.
11. Recurrent nuisance trips lead to taped-over recovery controls. Propose a cheap, reliable fixture/guard redesign that removes the incentive while preserving independent protection.
12. All control indicators return READY after recovery but the Y1 ram can fall with lost pressure. Which physical safe-state propositions remain unproven?

**No answers scored, no machine tests, no evaluator execution.** Selected OpenPressBrake G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No people-exposed operation authorized.
