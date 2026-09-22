# 4000 Safety Curriculum Checkpoint — Hazard-to-Function Derivation

UTC checkpoint: 2026-09-22T14:46Z

## Durable work completed

Added `safety-course/2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md` after auditing the current safety-course sequence and mature 25E0 recovery branch.

The audit found that `SAFETY_COURSE_RESEARCH.md` names 2520 `From hazards to safety functions`, but the repository lacked one explicit learner-facing, repeatable derivation/allocation workflow tying machine boundaries and hazardous events through safe-state propositions, safety functions, final physical elements, proof obligations, reset/restart, validation and residual risk.

The new module closes that gap and preserves `UNKNOWN` for design-specific PL/SIL targets, stopping distances/times, pressure thresholds, hydraulic truth tables and other physical facts not established by evidence.

Professional evidence used: SICK ISO-12100-style risk-assessment/risk-reduction workflow; Pilz safety concept and ISO 13849 SRS guidance; Rockwell safety lifecycle/SFRS, safety-function element, specification and STO-boundary guidance.

No executable compute was justified. No GitHub-hosted runner was used.

## Exact next work

1. Stress-test the 2520 worksheet on a substantially different machine/cell, preferably robot/automation or saw/feed cell, without transferring press/spindle physics.
2. Build the next learner-facing methodology stage: **safety-function composition and conflict analysis**. Teach how multiple derived safety functions share final elements, have mode-dependent demands, depend on common power/mechanics/networks, or request physical states that can conflict.
3. Include a dependency/allocation matrix that traces `HZ -> PROP -> SF -> input/logic/final element -> DEP -> EVID -> VAL` and makes ordinary LinuxCNC/FPGA authority explicit.
4. Add an adversarial case where one final element is shared by E-stop, guard, setup/enabling, and process-fault functions, and require the learner to prove that combining the functions does not erase a stronger safe-state requirement.
5. Do not move to PL/SIL arithmetic or component selection until composition is coherent. Do not invent machine-specific integrity targets or physical thresholds.
6. Preserve the human-factors gate: legitimate setup/recovery must be easier than bypass.
