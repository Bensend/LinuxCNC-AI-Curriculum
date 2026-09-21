# 25E0 checkpoint — heterogeneous witness commissioning / validation

Date: 2026-09-21

## Durable progress

- Added `safety-course/25E0_HETEROGENEOUS_WITNESS_COMMISSIONING_AND_VALIDATION_METHOD_2026-09-21.md`.
- Added `safety-course/25E0_COMMISSIONING_WITNESS_DISAGREEMENT_AND_REVALIDATION_EXERCISE_2026-09-21.md`.
- Added `safety-course/25E0_STOPPING_TIME_PHYSICAL_ENDPOINT_AND_SAFEGUARD_REVALIDATION_2026-09-21.md`.
- Source basis includes Rockwell field-device/fault validation guidance, Rockwell AADvance commissioning/temporary-measure guidance, Rockwell ISO 13849 validation application guidance, Pilz validation-plan material, and Pilz/Rockwell stopping-time evidence.
- No executable compute was justified. No GitHub-hosted runner was used.

## New freezes

- `SIGNAL TRUE != PHYSICAL PROPOSITION PROVED` unless the witness chain supports that proposition.
- `TWO SIGNALS != TWO INDEPENDENT WITNESSES`.
- `FINAL-ELEMENT FEEDBACK != PROCESS-RESULT FEEDBACK`.
- `RESET/REARM COMPLETE != FRESH ORDINARY DEMAND`.
- `CONTROLLER TIMING != PHYSICAL STOPPING TIME` unless the measurement chain witnesses the physical endpoint.
- `VALIDATED ONCE != VALID AFTER AN IMPACTING MODIFICATION`.

## Exact next work

Advance 25E0 into a **machine safety-function validation record/template and acceptance matrix** that a learner can use without collapsing evidence classes. Include: hazard/safety-function ID; required safe state; initiating device; safety authority; final elements; process witness; reset/rearm; ordinary demand freshness; timing endpoints; fault-injection cases; temporary commissioning states; modification/revalidation triggers; source/evidence classification; and explicit `UNKNOWN` handling.

Then stress-test that template against at least two different machine classes (preferably a press-brake-style gravity/hydraulic axis and a rotating spindle/table) to expose where a generic validation template must branch by physics. Do not invent machine-specific thresholds or claim the examples are validated designs.

If that template branch reaches a useful stop, rotate to maintenance/bypass human-factors validation or another open safety module rather than returning to repetitive product searches.