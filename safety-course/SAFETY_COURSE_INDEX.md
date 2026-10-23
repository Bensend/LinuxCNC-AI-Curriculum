# Practical Machine Safety Engineering — Learner Navigation

This is the concise navigation surface for the 2500 safety course. `../SAFETY_COURSE_RESEARCH.md` remains the broad research/course plan; this index points learners to mature course artifacts without duplicating that plan.

## Current sequence

- **2510 — Safety as an engineering problem:** prerequisite mental model from the research/course plan and existing safety-boundary material.
- **2520 — From hazards to safety functions:** mature learner-facing methodology. Start at `2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`; it owns the ordered path through hazard/SRS derivation, composition, fault/diagnostic analysis, architecture/dependency/CCF allocation, integrity-method gate, verification/validation/physical proof, and commissioning/change control.
- **2530 — E-stop systems from first principles:** start at `2530_ENTRY_MAP_AND_RELEASE_GATE_2026-09-22.md`. The methodology is ready for external/fresh evaluation, not self-certified as graduated.
- **2540 — Relays, contactors, and the real meaning of a safety relay:** start at `2540_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`. The route covers relay meaning, five commercial families and switching/reliability physics, machine final elements, and adversarial relay-to-safe-state reasoning. External/fresh evaluation remains open via `../evaluation/2540_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md`.
- **2550 — ISO 13849 without the mystique:** begin at `2550_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`; learner-facing method READY FOR EXTERNAL/FRESH EVALUATION, not graduated.
- **2560 — IEC 62061 / SIL concepts:** begin at `2560_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`; learner-facing method READY FOR EXTERNAL/FRESH EVALUATION, not graduated.
- **2570 — Drives, STO, braking and hazardous motion:** begin at `2570_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`; learner-facing method READY FOR EXTERNAL/FRESH EVALUATION, not graduated.
- **2580 — Hydraulic and pneumatic safety:** begin at `2580_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`; learner-facing method READY FOR EXTERNAL/FRESH EVALUATION, not graduated.
- **2590 — Guards, interlocks and presence sensing:** begin at `2590_GUARDS_INTERLOCKS_PRESENCE_SENSING_SOURCE_PREP_2026-09-23.md`; verify its independent release/evaluation record before assigning readiness.
- **25A0–25F0 —** follow `../SAFETY_COURSE_RESEARCH.md`, current learner-facing module artifacts and `SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md`; do not infer graduation from a completed lesson or from an unexecuted external gate.

## 4400 safety implementation deepening (does not change 2500 graduation)

The current 4000 safety branch extends the existing 2520–25F0 course without reopening graduated 1000–3000 levels. For the operator-interface distinction `dual foot-pedal AND != two-hand protective function`, read `../research/4400_TWO_PEDAL_AND_VS_TWO_HAND_SAFETY_FUNCTION_BOUNDARY_2026-10-23.md` and complete `4400_DUAL_PEDAL_AND_TWO_HAND_NON_EQUIVALENCE_FIELD_CARD_2026-10-23.md`. These are source-based learning artifacts, **not** a selected press-brake circuit, validated safeguard or external competency score. Additional published 4400 follow-ons: `4400_MODE_DEPENDENT_SAFEGUARD_VALIDATION_MATRIX_2026-10-23.md` (all cases NOT RUN); `../research/4400_AKAS5M_VS_LC5M_VARIANT_TRANSFER_TRAP_2026-10-23.md` with `4400_AKAS_VARIANT_SUBSTITUTION_CHANGE_REVIEW_2026-10-23.md`; `../research/4400_GUARD_RELEASE_STOP_REQUEST_VS_PHYSICAL_EGRESS_2026-10-22.md` with `4400_GUARD_RELEASE_PROPOSITION_AND_MAINTENANCE_TECHNICIAN_EXERCISE_2026-10-22.md`; and `4400_ESTOP_LATCH_FIRST_SCAN_ADVERSARIAL_CARD_2026-10-22.md`. These are published learning materials, not physical validation or new external graduation evidence. All machine-specific stopping/holding and protective coverage remain to be demonstrated.

For a **GuardLink 432ES appended-node topology change**, use `../research/4400_432ES_APPENDED_NODE_INACTIVE_SAFETY_FUNCTION_SOURCE_TRACE_2026-10-23.md` and `4400_GUARDLINK_NODE_CHANGE_PHYSICAL_PROOF_TECHNICIAN_CARD_2026-10-23.md`. Manufacturer documentation warns that an appended node can remain inactive if its documented link sequence is skipped; a pre-existing protective stop can mask an unproven new guard. The cumulative design package now includes section 11C for causal and physical-proof continuity. **Documentary lesson only; all selected-machine `VAL`/`PT` cases remain NOT RUN.**

For **guard-lock replacement and safety I/O interface qualification**, use `4400_CTP_STATE_TABLE_REPLACEMENT_ADVERSARIAL_CARD_2026-10-22.md` (EUCHNER CTP-I1 versus CTP-L1 closed/unlocked output semantics) and `../research/4400_CTP_SAFE_RECEIVER_VS_SOLENOID_PULSE_INTERFACE_NOTE_2026-10-22.md` (OSSD test pulses versus solenoid-drive pulses versus supply dips). The selected-safety-block worksheet now requires pulse parameter ownership by signal direction. No replacement equivalence, filter value, stop/hold behavior or machine-level safety claim is established by the examples.

For **hydraulic pressure-zone and residual-energy evidence**, use `../research/4400_HYDAC_SAF_EXACT_CATALOG_SELECTED_BLOCK_GATE.md` and `4400_HYDAC_SAF_GAUGE_ZERO_TECHNICIAN_ADVERSARIAL_EXERCISE.md`. These distinguish the selected catalog part's optional gauge/bleed features from an installed machine's trapped volumes, elevated-load restraint, maintenance isolation and independently witnessed physical safe state. The selected-block qualification worksheet now requires pressure-port-to-zone mapping. **No selected hydraulic schematic, stopping/holding result, pressure threshold or machine release is implied.**

For **diagnostic tag validity and misleading HMI indications**, read `../research/4400_440R_ENETR_2026_TABLE5_DIAGNOSTIC_QUALITY_GATE_2026-10-23.md` and complete `4400_GUARDLINK_DIAGNOSTIC_DECODER_ADVERSARIAL_WORKSHEET_2026-10-23.md`. The manufacturer documents inactive-mode zeroed tags and inconsistent fault-example bit interpretation; the cumulative package now requires product/firmware/epoch/freshness and live-versus-event provenance before crediting any diagnostic witness. HMI data cannot prove independent physical safe state.

For **guard-defeat human factors**, complete `4400_GUARD_DEFEAT_INCENTIVE_DESIGN_REVIEW_2026-10-22.md`. The IFA/DGUV MaSeM method examines real task/mode/guard combinations and the benefit of bypass; the cumulative `HF` section now requires observed legitimate workflow friction, practical design mitigation, and revalidation of unchanged physical safety protection. No site observation or MaSeM result has been fabricated.

For **maintenance hydraulic isolation versus production stopping**, use `../research/4400_ROSS_HLOX_MANUAL_ISOLATION_VS_RAM_PROOF_SOURCE_NOTE_2026-10-22.md`. A padlockable valve with a local gauge can aid maintenance energy control but cannot prove every trapped hydraulic volume or gravity-loaded beam restraint; the cumulative package §11A now explicitly preserves that distinction. Manufacturer product-family documentation is not selected-machine physical proof.

## Information-separated competency status

2520–2580 have learner-facing methodology and entry routes; 2520–25F0 external/fresh competency execution gates remain OPEN unless separately supported by independent evaluator records. READY FOR EXTERNAL/FRESH EVALUATION is not graduation. Do not self-score or expose hidden evaluator solutions before learner precommitment.

A blocked external/fresh evaluator is not a reason to idle the safety course. Continue the next unblocked source/research branch while preserving information separation.

## Safety-authority boundary

Ordinary LinuxCNC, HAL, normal FPGA control, PC software and ordinary communications may request stops, inhibit production behavior, display state and support diagnostics. They do not acquire personnel-safety authority merely because they participate in the machine-control architecture. Safety-related control and physical energy/motion control must be allocated and evidenced independently for the actual safety function.

## Evidence discipline

Use `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`. Machine-specific stopping times/distances, hydraulic/pneumatic truth, required PL/SIL, diagnostic coverage, reliability values and physical safe-state facts remain `UNKNOWN` until supported by the appropriate design-specific evidence.
