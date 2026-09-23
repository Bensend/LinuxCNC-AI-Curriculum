# Practical Machine Safety Engineering — Learner Navigation

This is the concise navigation surface for the 2500 safety course. `../SAFETY_COURSE_RESEARCH.md` remains the broad research/course plan; this index points learners to mature course artifacts without duplicating that plan.

## Current sequence

- **2510 — Safety as an engineering problem:** prerequisite mental model from the research/course plan and existing safety-boundary material.
- **2520 — From hazards to safety functions:** mature learner-facing methodology. Start at `2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`; it owns the ordered path through hazard/SRS derivation, composition, fault/diagnostic analysis, architecture/dependency/CCF allocation, integrity-method gate, verification/validation/physical proof, and commissioning/change control.
- **2530 — E-stop systems from first principles:** start at `2530_ENTRY_MAP_AND_RELEASE_GATE_2026-09-22.md`. The methodology is ready for external/fresh evaluation, not self-certified as graduated.
- **2540 — Relays, contactors, and the real meaning of a safety relay:** start at `2540_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`. The route covers relay meaning, five commercial families and switching/reliability physics, machine final elements, and adversarial relay-to-safe-state reasoning. External/fresh evaluation remains open via `../evaluation/2540_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md`.
- **2550 — ISO 13849 without the mystique:** active source branch. Begin with `2550_ISO_13849_WITHOUT_MYSTIQUE_SOURCE_PREP_2026-09-23.md`.
- **2560+ —** continue in the sequence defined by `../SAFETY_COURSE_RESEARCH.md`.

## Information-separated competency status

2520, 2530, and 2540 have learner-facing methodology plus no-solution evaluator handoffs. Their external/fresh execution remains OPEN and branch-local. Do not self-score or expose hidden evaluator solutions before learner precommitment.

A blocked external/fresh evaluator is not a reason to idle the safety course. Continue the next unblocked source/research branch while preserving information separation.

## Safety-authority boundary

Ordinary LinuxCNC, HAL, normal FPGA control, PC software and ordinary communications may request stops, inhibit production behavior, display state and support diagnostics. They do not acquire personnel-safety authority merely because they participate in the machine-control architecture. Safety-related control and physical energy/motion control must be allocated and evidenced independently for the actual safety function.

## Evidence discipline

Use `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`. Machine-specific stopping times/distances, hydraulic/pneumatic truth, required PL/SIL, diagnostic coverage, reliability values and physical safe-state facts remain `UNKNOWN` until supported by the appropriate design-specific evidence.
