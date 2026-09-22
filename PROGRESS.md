# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14. F02 GRADUATED.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15.

Do not routinely reopen closed levels without a genuinely new material defect.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

### Primary active priority — safety course / professional machine implementation

Routine controller-board development remains a separate automation concern and must not displace safety work here.

The repeatable safety-design methodology now explicitly covers:

`machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function/SRS derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/dependency/CCF allocation -> integrity-method selection/target allocation -> verification/validation/physical proof -> commissioning/release -> maintenance/change control/revalidation`

Fresh-AI navigation is durable in `safety-course/2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`. A path/ownership audit in `safety-course/2520_FRESH_AI_HANDOFF_AUDIT_AND_FORMAL_PLACEMENT_2026-09-22.md` verified the referenced learner path exists and has non-conflicting ownership. The audit deliberately declined to create a redundant commissioning worksheet because the existing validation matrix plus commissioning lesson already provide the needed record surfaces.

The audit also makes the formal placement decision: the mature hazard-to-release chain is ready to serve as the learner-facing core of **2520 — From hazards to safety functions** under the existing 2500 Practical Machine Safety Engineering course. This placement is not a claim of blind/fresh competency graduation; an information-separated transfer evaluation remains open.

Verification/validation is durable in `safety-course/2520_VERIFICATION_VALIDATION_AND_PHYSICAL_PROOF_2026-09-22.md` with reusable `safety-course/SAFETY_VERIFICATION_VALIDATION_MATRIX.md`. It separates design verification, functional validation, fault/diagnostic validation, physical-process proof, recovery/restart validation and maintenance/change revalidation, and marks machine/human evidence boundaries instead of inventing results.

Commissioning/release/change control is explicit in `safety-course/2520_COMMISSIONING_RELEASE_AND_CHANGE_CONTROL_2026-09-22.md`. It adds configuration identity, commissioning-readiness gates, temporary-measure tracking/removal, release-baseline control, bidirectional change-impact tracing and impact-derived partial/full revalidation.

The integrity-method gate remains `safety-course/2520_INTEGRITY_METHOD_SELECTION_AND_TARGET_ALLOCATION_2026-09-22.md` with `safety-course/SAFETY_INTEGRITY_METHOD_GATE_WORKSHEET.md`. It requires the target to come from the safety function's risk/SRS context rather than topology and separates architecture, reliability, diagnostics, CCF, systematic controls and validation.

A formal chain-level assessment remains `safety-course/2520_ADVERSARIAL_ASSESSMENT_HAZARD_TO_INTEGRITY_GATE_2026-09-22.md`; its existing review is non-blind curriculum evidence and must not be mistaken for a future information-separated external evaluation.

Cross-machine transfer is now represented by `safety-course/2520_TRANSFER_EXERCISE_SPINDLE_ROBOT_CELL_HAZARD_TO_RELEASE_2026-09-22.md`. It exercises the complete method on a guarded spindle/robot-tending cell with pneumatic energy, retained kinetic energy, full-body access, setup/recovery and maintenance change while deliberately leaving machine-specific stopping, distance, pressure, integrity and final-element facts `UNKNOWN`.

Prior 2520 prerequisites remain durable: hazard/SRS derivation, safety-function composition/shared-final-element analysis, fault/diagnostic design, architecture/integrity allocation, and their reusable worksheets. Recovery/return-to-service material remains supporting evidence for validation/recovery and must not displace the core hazard-to-release sequence.

Core freezes remain in force: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **TEST PASSED != CURRENT MACHINE PROVED IF CONFIGURATION IDENTITY IS LOST OR CHANGED**, **PARTIAL REVALIDATION SCOPE COMES FROM IMPACT ANALYSIS, NOT CONVENIENCE**, **PLr / REQUIRED SIL COMES FROM THE SAFETY FUNCTION'S RISK/SRS CONTEXT, NOT TOPOLOGY**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **TWO CHANNELS != TWO INDEPENDENT PHYSICAL PATHS**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Prepare the 2520 information-separated competency-check handoff/protocol without exposing a solution: choose a new machine scenario distinct from learner-readable worked examples and define scoring dimensions only.
2. Reconcile the formal 2520 placement into the course sequence/navigation surface if a dedicated safety-course index/syllabus artifact exists or is justified; avoid duplicating `SAFETY_COURSE_RESEARCH.md`.
3. Continue to 2530 only when doing so does not bypass the open 2520 external/fresh competency gate; source/research preparation for 2530 may proceed in parallel under `WORK_SELECTION_POLICY.md`.
4. Preserve machine-specific `UNKNOWN`s and independent safety authority. Ordinary LinuxCNC/FPGA remains non-authoritative for personnel safety.

Newest precise checkpoint: `checkpoints/2026-09-22T2050Z-safety-2520-placement-transfer-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
