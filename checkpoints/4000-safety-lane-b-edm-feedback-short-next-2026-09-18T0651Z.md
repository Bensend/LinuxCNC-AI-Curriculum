# 4000 safety Lane B checkpoint — EDM feedback short/bypass boundary — 2026-09-18T06:51Z

## Parallel-state check

Before selection, Lane B read the required curriculum control files and inspected current safety-course artifacts and recent commits. The primary lane's newest durable work was `3767fd67` / checkpoint `4a751ca0`, the gravity-axis Safe Brake Control / Safe Brake Test mechanical-proof branch. Lane B selected a different evidence package and different files: EDM/feedback-conductor false-healthy faults.

Immediately before the substantive write, current main still ended at `4a751ca0`; no overlapping file had changed. After the write, `40528cfb` was directly above that primary checkpoint.

## Durable work

Created `safety-course/EDM_FEEDBACK_SHORT_BYPASS_PROTECTED_WIRING_BOUNDARY_STUDY_2026-09-18.md` in commit `40528cfb`.

Frozen distinction:

**FINAL ELEMENT COMMANDED OFF != FINAL ELEMENT PHYSICALLY OFF != FEEDBACK CONTACT IN EXPECTED STATE != FEEDBACK CONDUCTOR TRUTHFUL != EDM INPUT HEALTHY != ALL HAZARDOUS ENERGY ABSENT.**

Manufacturer evidence from SICK establishes that feedback wiring can require protected routing against feedback-to-feedback and feedback-to-output shorts. Pilz evidence reinforces that named diagnostics/feedback loops do not justify assuming every field-wiring fault is continuously self-detected.

The new commissioning card explicitly challenges false-healthy feedback faults, cross-shorts, maintenance jumpers/bypasses, stale feedback across power/reset, wrong auxiliary witnesses, and ordinary-control contamination of the safety witness.

No OpenPressBrake wiring topology, feedback device, discrepancy timing, PL/SIL/category/DC, hydraulic truth table, stopping performance, or physical response was invented.

## Compute

No executable verification was justified. No GitHub-hosted Actions compute was used. Future executable work, if genuinely needed, must use `[self-hosted, openpressbrake]` only.

## Precise next independent work

Find a complete professional implementation exposing:

**safety output -> contactor/valve -> physical feedback witness -> protected feedback wiring -> safety input/EDM -> false-healthy wiring fault -> restart inhibition/recovery.**

Prefer a manufacturer package that explicitly states which cross-faults are diagnosed and which must be prevented by protected/separate routing. If the primary lane moves into that package first, rotate Lane B to maintenance-bypass/keyed-override lifecycle and return-to-service validation rather than overlapping gravity-axis brake work.