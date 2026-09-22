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

The repeatable safety-design methodology now explicitly covers: machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/integrity requirements -> verification/validation -> maintenance/change control.

Newest learner-facing methodology: `safety-course/2520_ARCHITECTURE_INTEGRITY_ALLOCATION_FROM_FAULT_ANALYSIS_2026-09-22.md`, with reusable `safety-course/SAFETY_ARCHITECTURE_ALLOCATION_WORKSHEET.md`. This converts dangerous-undetected/latent/common-cause gaps from the fault analysis into architecture requirements before component selection or integrity arithmetic. It explicitly separates redundancy, fault tolerance, diagnostic coverage and physical independence; requires reverse `DEP-*` tracing for every claimed independent path; derives final-element/process proof surfaces from the physical proposition; and treats CCF controls and practical validation access as architecture requirements rather than afterthoughts.

Prior 2520 prerequisites remain: `2520_FAULT_ANALYSIS_DIAGNOSTIC_DESIGN_AND_RESIDUAL_PROPOSITION_2026-09-22.md`, `SAFETY_FUNCTION_FAULT_DIAGNOSTIC_WORKSHEET.md`, `2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`, `2520_SAFETY_FUNCTION_COMPOSITION_CONFLICT_AND_SHARED_FINAL_ELEMENT_2026-09-22.md`, and `2520_MACHINE_LEVEL_SRS_DERIVATION_EXERCISE_2026-09-22.md`.

Recovery/return-to-service material remains consolidated and retained, including the cell auxiliary-energy assessment and reusable FIND/handoff/power-recovery/reintegration records.

Newest methodology freezes: **REDUNDANCY != FAULT TOLERANCE != DIAGNOSTIC COVERAGE != PHYSICAL INDEPENDENCE**, **TWO CHANNELS != TWO INDEPENDENT PATHS**, **TWO SAFETY FUNCTIONS != TWO INDEPENDENT FINAL-ELEMENT PATHS**, **DIVERSE COMPONENTS != COMMON-CAUSE CONTROL UNLESS THE DIVERSITY ADDRESSES A DEFINED CAUSE**, **FINAL-ELEMENT FEEDBACK != PROCESS SAFE STATE UNLESS THAT EQUIVALENCE IS ESTABLISHED**, **ALL ELECTRONIC DIAGNOSTICS HEALTHY != REQUIRED PHYSICAL PROCESS PROPOSITION PROVED**, **ARCHITECTURE SKETCH != CATEGORY / PL / SIL CLAIM**, **COMPONENT SAFETY RATING != MACHINE SAFETY-FUNCTION INTEGRITY**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

Core safety freezes from prior sessions remain in force, including independent safety authority, physical proof versus command/status, reset/rearm versus start authority, evidence freshness, finding disposition, recovery/reintegration, common-cause reverse tracing, fault/diagnostic scope, and the prohibition on inventing machine-specific physical facts or integrity targets.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

Continue from architecture requirements into **integrity-method selection and requirements allocation without turning the course into component arithmetic**:

1. Build a learner-facing gate for selecting the applicable machinery functional-safety method (for example ISO 13849-1 versus IEC 62061 context) and deriving the required integrity target from risk assessment/SRS rather than topology.
2. Teach what Category/architecture, reliability data, diagnostic coverage, CCF/systematic-fault controls and validation each contribute, while keeping standard-edition/applicability boundaries explicit and avoiding invented values.
3. Use one bounded worked example with symbolic/placeholder values first; only use manufacturer numerical data where provenance and applicability are explicit. The objective is to teach the evidence chain, not optimize a fake machine.
4. Add a counterexample showing why a high-rated component or redundant safety controller cannot rescue an unproved shared final element/process proposition.
5. Decide whether the completed 2520 chain is mature enough for a formal adversarial assessment covering derivation -> faults -> architecture -> integrity-method gate.
6. Preserve human factors and independent safety authority; ordinary LinuxCNC/FPGA remains non-authoritative for personnel safety.

Newest precise checkpoint: `checkpoints/2026-09-22T1651Z-safety-architecture-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
