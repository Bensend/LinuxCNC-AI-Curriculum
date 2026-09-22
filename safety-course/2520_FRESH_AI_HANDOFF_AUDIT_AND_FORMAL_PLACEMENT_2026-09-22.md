# 2520 — Fresh-AI Handoff Audit and Formal Placement

Date: 2026-09-22
Status: integration audit / curriculum placement decision

## Question

Can a fresh learner enter the 2520 methodology from repository state alone, traverse hazard-to-release without chat history, and know which artifact owns each step?

## Path audit

The canonical entry map names the following learner path, and the current `safety-course/` directory contains each referenced artifact:

1. `2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`
2. `2520_MACHINE_LEVEL_SRS_DERIVATION_EXERCISE_2026-09-22.md`
3. `2520_SAFETY_FUNCTION_COMPOSITION_CONFLICT_AND_SHARED_FINAL_ELEMENT_2026-09-22.md`
4. `2520_FAULT_ANALYSIS_DIAGNOSTIC_DESIGN_AND_RESIDUAL_PROPOSITION_2026-09-22.md`
5. `SAFETY_FUNCTION_FAULT_DIAGNOSTIC_WORKSHEET.md`
6. `2520_ARCHITECTURE_INTEGRITY_ALLOCATION_FROM_FAULT_ANALYSIS_2026-09-22.md`
7. `SAFETY_ARCHITECTURE_ALLOCATION_WORKSHEET.md`
8. `2520_INTEGRITY_METHOD_SELECTION_AND_TARGET_ALLOCATION_2026-09-22.md`
9. `SAFETY_INTEGRITY_METHOD_GATE_WORKSHEET.md`
10. `2520_VERIFICATION_VALIDATION_AND_PHYSICAL_PROOF_2026-09-22.md`
11. `SAFETY_VERIFICATION_VALIDATION_MATRIX.md`
12. `2520_COMMISSIONING_RELEASE_AND_CHANGE_CONTROL_2026-09-22.md`
13. `2520_ADVERSARIAL_ASSESSMENT_HAZARD_TO_INTEGRITY_GATE_2026-09-22.md`

No missing referenced path was found in this audit.

## Ownership audit

Ownership is sufficiently non-conflicting for a fresh learner:

- hazard, lifecycle boundary, risk-reduction hierarchy, physical safe-state proposition and initial SF allocation: hazard-derivation lesson;
- machine-level requirements record: SRS exercise;
- simultaneous demands/modes/shared final elements: composition lesson;
- credible faults, detection timing, diagnostic reaction and residual proposition: fault-analysis lesson + worksheet;
- redundancy, independence, shared dependencies, final elements and CCF controls: architecture lesson + worksheet;
- applicable integrity method/edition and target gate: integrity lesson + worksheet;
- design verification, functional/fault validation, physical proof, recovery and maintenance revalidation: verification/validation lesson + matrix;
- configuration identity, commissioning release, temporary measures and change-impact/revalidation: commissioning lesson;
- chain-level challenge: adversarial assessment.

Boundary overlap is intentional. The entry map correctly prevents those overlaps from becoming competing ownership.

## Commissioning worksheet decision

Do **not** create another worksheet now.

The existing validation matrix already owns test identity, evidence, acceptance, findings and revalidation. The commissioning lesson adds configuration identity, release baseline, temporary-measure removal and change impact. A second worksheet would currently duplicate those surfaces more than it would close a demonstrated learner gap. Reconsider only if a fresh/information-separated learner fails specifically because release/change records are hard to construct from the current artifacts.

## Formal placement decision

The mature hazard-to-release chain is ready for formal **2520 learner-sequence placement** under the existing 2500 Practical Machine Safety Engineering course. `SAFETY_COURSE_RESEARCH.md` already defines 2520 as “From hazards to safety functions”; the developed material is a rigorous expansion of that objective rather than a new unrelated module.

The sequence should be treated as the implementation-ready 2520 core, with later 2530+ modules consuming it rather than independently re-deriving hazard/SRS/fault/validation methodology.

This is **not** a claim that 2520 has passed a genuine blind/fresh external competency evaluation. Formal learner-sequence placement and information-separated graduation evidence are different gates.

## Evidence still required for a genuine fresh competency check

A future information-separated learner should receive:

- the canonical 2520 entry map and normal course artifacts;
- a substantially different machine scenario not answered in learner-readable material;
- incomplete but realistic machine facts, requiring unsupported physical values to remain `UNKNOWN`;
- at least one shared dependency/common-cause trap;
- at least one misleading command/status indication that does not prove the physical proposition;
- a mode/restart or maintenance/change condition;
- a requirement to produce `HZ -> PROP -> SF/SRS -> FLT -> ARCH/DEP/CCF -> integrity gate -> VAL/EVID -> release/revalidation`.

Score mechanism understanding, physical-proof discipline, uncertainty handling, independence/common-cause reasoning, reset/start authority, and whether ordinary LinuxCNC/FPGA is incorrectly promoted to personnel-safety authority.

Do not expose a hidden expected solution before the learner commits.

## Result

**HANDOFF PATH: PASS (non-blind integration audit).**

**FORMAL 2520 PLACEMENT: READY.**

**BLIND/FRESH COMPETENCY EVIDENCE: STILL OPEN.**

No executable lab is justified by this audit. The open evidence gate is information separation/transfer, not a simulation question.
