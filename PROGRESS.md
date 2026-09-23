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

2520 and 2530 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** now has a coherent learner route in `safety-course/2540_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md`. The route owns: component/relay meaning; the five-family commercial comparison and switching/reliability physics; contactor/STO/fluid-power final-element boundaries; and the adversarial assessment `2540_ADVERSARIAL_ASSESSMENT_RELAY_TO_SAFE_STATE_2026-09-23.md`. `evaluation/2540_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` preserves a no-solution external evaluator gate. 2540 is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.

2540 freezes remain: **FORCE-GUIDED CONTACTS != COMPLETE SAFETY FUNCTION**, **CONTACT CARRY CURRENT != SWITCHING SUITABILITY**, **FINAL-ELEMENT COMMAND != FINAL-ELEMENT STATE**, **FINAL-ELEMENT STATE != HAZARDOUS-ENERGY STATE**, **MIRROR/EDM FEEDBACK != SHAFT STANDSTILL OR COMPLETE ENERGY REMOVAL**, **STO ACTIVE != ELECTRICAL ISOLATION, STANDSTILL, OR GRAVITY-LOAD RESTRAINT**, **VALVE POSITION FEEDBACK != DOWNSTREAM SAFE PRESSURE**, **OUTPUT CURRENT RATING != PERMISSION TO SWITCH AN ARBITRARY LOAD**, and **COMPONENT PL/SIL/PFH != COMPLETE SAFETY-FUNCTION PL/SIL/PFH**.

**2550 — ISO 13849 without the mystique** is now the active source branch. Initial source framing is `safety-course/2550_ISO_13849_WITHOUT_MYSTIQUE_SOURCE_PREP_2026-09-23.md`. Current-edition orientation uses ISO 13849-1:2023 evidence from DGUV/IFA and current manufacturer standards guidance. The module explicitly separates PLr, Category, MTTFd, DC/DCavg, CCF, and validation/systematic correctness. SISTEMA is treated as an evaluation/calculation aid whose result remains dependent on defensible inputs and does not replace machine validation.

Initial 2550 freezes: **ARCHITECTURE DOES NOT CREATE PLr**, **CATEGORY 4 != PL e BY DEFINITION**, **DC CLAIM != PHYSICAL SAFE-STATE PROOF**, and **SISTEMA PASS != MACHINE VALIDATION PASS**.

Core 2520/2530 freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520, 2530 and 2540 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Build 2550 example architectures with symbolic or explicitly sourced data so Category, MTTFd, DCavg and CCF can be varied independently without inventing machine-specific values.
3. Include a case where nominal redundancy fails to improve the defensible result because a common final element or common-cause dependency dominates.
4. Include a case where a plausible numerical/SISTEMA result is invalidated by a bad application assumption or stale component/use-profile evidence.
5. Teach B10d/switching-cycle reasoning and subsystem decomposition only to the depth justified by authoritative evidence; distinguish illustrative math from formal certification.
6. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0348Z-safety-2550-examples-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
