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

The repeatable safety-design methodology covers:

`machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function/SRS derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/dependency/CCF allocation -> integrity-method selection/target allocation -> verification/validation/physical proof -> commissioning/release -> maintenance/change control/revalidation`

2520, 2530, 2540 and now 2550 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** has completed its learner-facing coverage audit. `safety-course/2550_CATEGORY_B_TO_4_COVERAGE_AUDIT_AND_GAP_FILL_2026-09-23.md` filled the one material gap: explicit Category B/1/2/3/4 fault-behavior teaching without collapsing categories into PL labels. The canonical route is now `safety-course/2550_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`, and `evaluation/2550_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` provides a no-solution external gate. 2550 is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.

2550 freezes include: **ARCHITECTURE DOES NOT CREATE PLr**, **CATEGORY 4 != PL e BY DEFINITION**, **TEST CHANNEL != SECOND INDEPENDENT SAFETY-FUNCTION CHANNEL**, **HIGHER COMPONENT RELIABILITY != FAULT-TOLERANT ARCHITECTURE**, **DC CLAIM != PHYSICAL SAFE-STATE PROOF**, **SISTEMA PASS != MACHINE VALIDATION PASS**, **CHANNEL COUNT != CCF CONTROL**, **NUMERICALLY CORRECT MODEL + FALSE APPLICATION ASSUMPTION = UNDEFENSIBLE SAFETY CLAIM**, and **CERTIFIED SUBSYSTEM CAPABILITY != COMPLETE SAFETY-FUNCTION ACHIEVED INTEGRITY**.

**2560 — IEC 62061 / SIL concepts for machine builders** is now the active source branch. `safety-course/2560_IEC_62061_SIL_CONCEPTS_SOURCE_PREP_2026-09-23.md` establishes current IEC 62061:2021 orientation, PFHd bands, architectural/HFT/SFF constraints, random-hardware versus systematic-integrity separation, subsystem composition, PL-versus-SIL method boundaries, and the rule that quantitative precision must not distract from an obvious physical weak link.

Initial 2560 freezes: **SIL TARGET != COMPONENT SIL LABEL**, **PFHd IN RANGE != COMPLETE SAFETY FUNCTION VALIDATED**, **SMALL PFHd NUMBER != PERMISSION TO IGNORE ARCHITECTURAL CONSTRAINTS**, **RANDOM-HARDWARE CALCULATION != SYSTEMATIC-CORRECTNESS EVIDENCE**, and **MORE PRECISE MATH != MORE RISK REDUCTION WHEN THE PHYSICAL WEAK LINK IS STILL OBVIOUS**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–2550 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Continue 2560 by constructing one symbolic or explicitly sourced machine safety function and analyze it twice: ISO 13849 PL-style and IEC 62061 SIL-style.
3. Identify shared physical evidence, method-specific evidence, and invalid direct-conversion shortcuts; keep all absent machine values UNKNOWN.
4. Include a case where attractive PFHd arithmetic is defeated by architecture/systematic/application evidence and a case where obvious qualitative fault analysis gives the higher-value first correction.
5. Then audit 2560 against its syllabus before creating a learner route/evaluator handoff.
6. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0550Z-safety-2560-dual-method-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
