# 4000 Safety Curriculum Checkpoint — Hazard-to-Function Derivation and Composition

UTC checkpoint: 2026-09-22T14:46Z

## Durable work completed

Added three learner-facing artifacts after auditing the current safety-course sequence and mature 25E0 recovery branch:

- `safety-course/2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`
- `safety-course/2520_SAFETY_FUNCTION_COMPOSITION_CONFLICT_AND_SHARED_FINAL_ELEMENT_2026-09-22.md`
- `safety-course/2520_MACHINE_LEVEL_SRS_DERIVATION_EXERCISE_2026-09-22.md`

The audit found that `SAFETY_COURSE_RESEARCH.md` names 2520 `From hazards to safety functions`, but the repository lacked one explicit instruction-ready derivation/allocation workflow tying machine boundaries and hazardous events through safe-state propositions, safety functions, final physical elements, proof obligations, reset/restart, validation and residual risk.

The first module closes that gap and preserves `UNKNOWN` for design-specific PL/SIL targets, stopping distances/times, pressure thresholds, hydraulic truth tables and other physical facts not established by evidence.

The second module continues into safety-function composition: mode/function matrices, shared final elements and dependencies, simultaneous-demand conflicts, physical-proposition dominance, narrow setup/enabling substitutions, reverse `show where used`, and human-factors review. Professional evidence includes SICK's explicit guidance that switching/combining safety functions must not create a dangerous state and that mode changes can require a fresh manual start; Rockwell/Pilz enabling-device guidance supports narrowly scoped substitution rather than blanket bypass.

The third artifact stress-tests the method on a generic automated cut/feed cell spanning rotating tooling, feed motion, pneumatics, full-body access, E-stop, setup/enabling, process faults, shared field power and ordinary LinuxCNC/FPGA control. It requires a compact SRS and derives the validation matrix directly from requirements.

No executable compute was justified. No GitHub-hosted runner was used.

## Exact next work

1. Audit the remaining safety-course workflow against the now-explicit chain: boundary/hazard -> safe-state proposition -> safety function -> composition/allocation -> fault analysis/diagnostics -> architecture/integrity -> verification/validation -> maintenance/change control.
2. Highest-value likely gap: **fault-analysis and diagnostic design before architecture/component selection**. Teach the learner to derive credible single faults, common-cause faults and latent faults from each allocated function/final element/dependency; decide what must be detected and when; and map diagnostics to the proposition they actually support.
3. Build a compact `SF -> fault -> effect -> detection -> diagnostic reaction -> residual proposition -> proof/VAL` worksheet. Keep diagnostic status separate from physical proof.
4. Stress-test it on the cut/feed SRS plus a gravity/fluid-power example. Do not invent diagnostic coverage percentages, PL/SIL, valve truth tables, stopping distances or proof intervals.
5. Preserve independent safety authority and the human-factors rule. A diagnostic scheme that creates nuisance trips/bypass pressure needs engineering correction, not weaker fault handling.
