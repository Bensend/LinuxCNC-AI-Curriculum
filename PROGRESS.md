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

The repeatable safety-design methodology now explicitly covers: machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/integrity requirements -> integrity-method selection/target allocation -> verification/validation -> maintenance/change control.

Newest learner-facing methodology: `safety-course/2520_INTEGRITY_METHOD_SELECTION_AND_TARGET_ALLOCATION_2026-09-22.md`, with reusable `safety-course/SAFETY_INTEGRITY_METHOD_GATE_WORKSHEET.md`. This places the ISO 13849-1 / IEC 62061 method-and-edition gate after the SRS, fault analysis and architecture allocation; requires the integrity target to come from the safety function's risk/SRS context rather than topology; separates structural architecture, reliability, diagnostics, CCF, systematic controls and validation; and uses symbolic placeholders rather than invented machine values.

A formal chain-level assessment now exists at `safety-course/2520_ADVERSARIAL_ASSESSMENT_HAZARD_TO_INTEGRITY_GATE_2026-09-22.md`. It spans hazard derivation through integrity-method selection and deliberately tests shared dependencies/final elements, systematic faults, maintenance-invalidated physical evidence, reset/start authority, and refusal to invent PLr/SIL or reliability/timing values.

Prior 2520 prerequisites remain: `2520_ARCHITECTURE_INTEGRITY_ALLOCATION_FROM_FAULT_ANALYSIS_2026-09-22.md`, `SAFETY_ARCHITECTURE_ALLOCATION_WORKSHEET.md`, `2520_FAULT_ANALYSIS_DIAGNOSTIC_DESIGN_AND_RESIDUAL_PROPOSITION_2026-09-22.md`, `SAFETY_FUNCTION_FAULT_DIAGNOSTIC_WORKSHEET.md`, `2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`, `2520_SAFETY_FUNCTION_COMPOSITION_CONFLICT_AND_SHARED_FINAL_ELEMENT_2026-09-22.md`, and `2520_MACHINE_LEVEL_SRS_DERIVATION_EXERCISE_2026-09-22.md`.

Recovery/return-to-service material remains consolidated and retained, including the cell auxiliary-energy assessment and reusable FIND/handoff/power-recovery/reintegration records.

Newest methodology freezes: **PLr / REQUIRED SIL COMES FROM THE SAFETY FUNCTION'S RISK/SRS CONTEXT, NOT TOPOLOGY**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **HIGH-RATED LOGIC CANNOT RESCUE AN UNPROVED SHARED FINAL ELEMENT**, **NUMERICAL TOOL OUTPUT != VALIDATION**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **STANDARD METHOD SELECTED != EDITION/APPLICABILITY ESTABLISHED**, **REDUNDANCY != FAULT TOLERANCE != DIAGNOSTIC COVERAGE != PHYSICAL INDEPENDENCE**, **TWO CHANNELS != TWO INDEPENDENT PATHS**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

Core safety freezes from prior sessions remain in force, including independent safety authority, physical proof versus command/status, reset/rearm versus start authority, evidence freshness, finding disposition, recovery/reintegration, common-cause reverse tracing, fault/diagnostic scope, and the prohibition on inventing machine-specific physical facts or integrity targets.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

The 2520 hazard-to-integrity chain is now mature enough for integration/validation work rather than another narrow integrity note:

1. Execute/review the new 2520 adversarial assessment against the durable methodology without contaminating any blind external evaluation; correct genuine chain gaps rather than memorizing answers.
2. Continue into verification-versus-validation planning: derive test cases directly from `HZ/PROP/SF/FLT/ARCH` requirements and distinguish design verification, functional validation, fault-injection/diagnostic validation, physical-process proof, recovery/restart validation and maintenance/change revalidation.
3. Build one reusable validation matrix that preserves evidence provenance and explicitly marks tests that require physical machine measurements/human involvement rather than inventing results.
4. Stress-test the method across two substantially different machine classes (gravity/fluid-power axis and rotating-tool/automated cell) without transferring machine physics.
5. Audit the complete 2520 methodology for duplication/gaps and decide whether it is ready for a fresh-AI handoff/promotion into the formal safety-course module sequence.
6. Preserve human factors and independent safety authority; ordinary LinuxCNC/FPGA remains non-authoritative for personnel safety.

Newest precise checkpoint: `checkpoints/2026-09-22T1744Z-safety-integrity-gate-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.