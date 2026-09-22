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

The repeatable safety-design methodology now explicitly covers: machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/integrity -> verification/validation -> maintenance/change control.

Newest learner-facing methodology: `safety-course/2520_FAULT_ANALYSIS_DIAGNOSTIC_DESIGN_AND_RESIDUAL_PROPOSITION_2026-09-22.md`, with reusable `safety-course/SAFETY_FUNCTION_FAULT_DIAGNOSTIC_WORKSHEET.md`. This closes the next gap identified by the 2520 checkpoint: credible single/common-cause/latent faults are derived from the allocated function and dependencies before component selection; each diagnostic is mapped to the physical proposition it actually supports; detection timing and diagnostic reaction are explicit; dangerous-undetected gaps remain design gaps; and diagnostic health is kept separate from final-element/process proof.

The prior 2520 derivation/composition artifacts remain prerequisites: `2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`, `2520_SAFETY_FUNCTION_COMPOSITION_CONFLICT_AND_SHARED_FINAL_ELEMENT_2026-09-22.md`, and `2520_MACHINE_LEVEL_SRS_DERIVATION_EXERCISE_2026-09-22.md`.

Recovery/return-to-service material remains consolidated and retained, including the cell auxiliary-energy assessment and reusable FIND/handoff/power-recovery/reintegration records.

Newest methodology freezes: **FAULT DETECTED != PHYSICAL SAFE STATE PROVED**, **DUAL-CHANNEL AGREEMENT != COMMON-CAUSE INDEPENDENCE**, **DIAGNOSTIC COVERAGE FEATURE PRESENT != APPLICATION DIAGNOSTIC COVERAGE ESTABLISHED**, **DISCREPANCY TIMER CONFIGURED != DISCREPANCY TIME JUSTIFIED**, **PULSE TEST HEALTHY != SENSOR MECHANICS / GUARD GEOMETRY VALIDATED**, **SAFETY NETWORK HEALTHY != FINAL ELEMENT / PROCESS RESPONSE PROVED**, **DIAGNOSTIC RESET != FAULT CAUSE CORRECTED != RETURN-TO-SERVICE ACCEPTED**, **NUISANCE TRIP != PERMISSION TO WEAKEN SAFETY DIAGNOSTICS**, **TWO CHANNELS != TWO INDEPENDENT PHYSICAL WITNESSES**, and **UNKNOWN DIAGNOSTIC SUFFICIENCY != PERMISSION TO INVENT A NUMBER**.

Core safety freezes from prior sessions remain in force, including independent safety authority, physical proof versus command/status, reset/rearm versus start authority, evidence freshness, finding disposition, recovery/reintegration, common-cause reverse tracing, and the prohibition on inventing machine-specific physical facts or integrity targets.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

Continue the methodology from fault analysis into **architecture and integrity allocation without premature component arithmetic**:

1. Build the learner-facing transition from the completed `SF -> fault -> effect -> detection -> reaction -> residual PROP -> EVID/VAL` analysis into architecture requirements: independence/diversity where justified, diagnostic path independence, final-element monitoring, common-cause controls, and required proof/test surfaces.
2. Explicitly distinguish architectural fault tolerance from diagnostic coverage and from physical redundancy. Do not assign PL/SIL, DC percentages, MTTFd/PFH/PFD values, beta factors, proof intervals, or Category claims until the machine/function requirements and applicable standard method justify them.
3. Stress-test architecture derivation on two unlike cases: the automated cut/feed cell and a gravity/fluid-power axis. Require reverse `DEP-*` tracing and expose any single shared final element or shared witness that defeats claimed independence.
4. Add an adversarial case where a sophisticated diagnostic architecture still cannot prove the required physical process proposition, forcing a separate physical witness or validation obligation.
5. Keep human factors first-class: diagnostic/architecture choices that cause predictable nuisance trips or difficult recovery must be corrected without weakening the required safety function.
6. Preserve the independent safety boundary; ordinary LinuxCNC/FPGA may provide normal control and non-authoritative diagnostics but must not silently become personnel-safety logic.

Newest precise checkpoint: `checkpoints/2026-09-22T1550Z-safety-fault-diagnostic-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
