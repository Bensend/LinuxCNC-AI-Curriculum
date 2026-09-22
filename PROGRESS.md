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

Fresh-AI navigation is now durable in `safety-course/2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`. It assigns ownership to the existing detailed 2520 lessons/worksheets, defines the canonical reading order, preserves evidence vocabulary, and explicitly discourages manufacturing duplicate narrow notes.

Verification/validation is durable in `safety-course/2520_VERIFICATION_VALIDATION_AND_PHYSICAL_PROOF_2026-09-22.md` with reusable `safety-course/SAFETY_VERIFICATION_VALIDATION_MATRIX.md`. It separates design verification, functional validation, fault/diagnostic validation, physical-process proof, recovery/restart validation and maintenance/change revalidation, and marks machine/human evidence boundaries instead of inventing results.

Commissioning/release/change control is now explicit in `safety-course/2520_COMMISSIONING_RELEASE_AND_CHANGE_CONTROL_2026-09-22.md`. It adds configuration identity, commissioning-readiness gates, temporary-measure tracking/removal, release-baseline control, bidirectional change-impact tracing and impact-derived partial/full revalidation. Professional anchors include current Rockwell commissioning/signature guidance, Rockwell AADvance commissioning/validation guidance, and Siemens Safety Integrated acceptance/retest guidance.

The integrity-method gate remains `safety-course/2520_INTEGRITY_METHOD_SELECTION_AND_TARGET_ALLOCATION_2026-09-22.md` with `safety-course/SAFETY_INTEGRITY_METHOD_GATE_WORKSHEET.md`. It requires the target to come from the safety function's risk/SRS context rather than topology and separates architecture, reliability, diagnostics, CCF, systematic controls and validation.

A formal chain-level assessment remains `safety-course/2520_ADVERSARIAL_ASSESSMENT_HAZARD_TO_INTEGRITY_GATE_2026-09-22.md`; its existing review is non-blind curriculum evidence and must not be mistaken for a future information-separated external evaluation.

Prior 2520 prerequisites remain durable: hazard/SRS derivation, safety-function composition/shared-final-element analysis, fault/diagnostic design, architecture/integrity allocation, and their reusable worksheets. Recovery/return-to-service material remains supporting evidence for validation/recovery and must not displace the core hazard-to-release sequence.

Newest methodology freezes include: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **TEST PASSED != CURRENT MACHINE PROVED IF CONFIGURATION IDENTITY IS LOST OR CHANGED**, **PARTIAL REVALIDATION SCOPE COMES FROM IMPACT ANALYSIS, NOT CONVENIENCE**, **PLr / REQUIRED SIL COMES FROM THE SAFETY FUNCTION'S RISK/SRS CONTEXT, NOT TOPOLOGY**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **TWO CHANNELS != TWO INDEPENDENT PHYSICAL PATHS**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

Core safety freezes from prior sessions remain in force, including independent safety authority, physical proof versus command/status, reset/rearm versus start authority, evidence freshness, finding disposition, recovery/reintegration, common-cause reverse tracing, fault/diagnostic scope, and the prohibition on inventing machine-specific physical facts or integrity targets.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

The 2520 methodology is now integrated enough that the next work should test transfer and formal-course placement rather than add another narrow methodology note:

1. Perform a fresh-AI handoff audit using `2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`: verify every referenced path exists, ownership is non-conflicting, and a learner can traverse the chain without chat history.
2. Build a compact commissioning/change-control worksheet only if the handoff audit shows learners need a reusable record surface; do not duplicate the validation matrix.
3. Stress-test the full hazard-to-release method on a substantially different machine class not used as the primary worked example (robot/automated cell, spindle machine, or another justified class), preserving machine-specific UNKNOWNs.
4. Decide whether 2520 is ready for formal placement/promotion in the safety-course syllabus and what evidence is still required for a genuine fresh/information-separated competency check.
5. Preserve human factors and independent safety authority; ordinary LinuxCNC/FPGA remains non-authoritative for personnel safety.

Newest precise checkpoint: `checkpoints/2026-09-22T1950Z-safety-2520-integration-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
