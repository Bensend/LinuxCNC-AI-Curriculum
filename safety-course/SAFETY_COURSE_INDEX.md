# Practical Machine Safety Engineering — Learner Navigation

This is the concise navigation surface for the 2500 safety course. `SAFETY_COURSE_RESEARCH.md` remains the broad research/course plan; this index points learners to mature course artifacts without duplicating that plan.

## Current sequence

- **2510 — Safety as an engineering problem:** prerequisite mental model from the research/course plan and existing safety-boundary material.
- **2520 — From hazards to safety functions:** mature learner-facing methodology. Start at `2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`; it owns the ordered path through hazard/SRS derivation, composition, fault/diagnostic analysis, architecture/dependency/CCF allocation, integrity-method gate, verification/validation/physical proof, and commissioning/change control.
- **2530 — E-stop systems from first principles:** learner-facing methodology now has a canonical route in `2530_ENTRY_MAP_AND_RELEASE_GATE_2026-09-22.md`. It treats emergency stop as a complementary protective measure and derives machine-specific stop/reaction, fault coverage, span, reset/restart and physical proof from hazards and machine physics rather than assuming every E-stop simply removes all power. The methodology is ready for external/fresh evaluation, not self-certified as graduated.
- **2540+ —** continue in the sequence defined by `SAFETY_COURSE_RESEARCH.md`.

## 2520 competency status

Formal learner placement is complete, but information-separated transfer evidence remains open. Use `../evaluation/2520_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` with `../evaluation/BLIND_FEEDBACK_PROTOCOL.md`. Do not create or expose the hidden evaluator solution in learner-readable curriculum state before learner precommitment.

A blocked external/fresh evaluator is branch-local: preserve the open gate and continue high-value safety-course source/research work rather than self-grading the same material. Apply the same information-separation rule when 2530 receives its formal competency challenge.

## Safety-authority boundary

Ordinary LinuxCNC, HAL, normal FPGA control, PC software and ordinary communications may request stops, inhibit production behavior, display state and support diagnostics. They do not acquire personnel-safety authority merely because they participate in the machine-control architecture. Safety-related control and physical energy/motion control must be allocated and evidenced independently for the actual safety function.

## Evidence discipline

Use `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`. Machine-specific stopping times/distances, hydraulic/pneumatic truth, required PL/SIL, diagnostic coverage, reliability values and physical safe-state facts remain `UNKNOWN` until supported by the appropriate design-specific evidence.
