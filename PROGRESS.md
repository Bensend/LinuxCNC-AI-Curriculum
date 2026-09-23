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

Fresh-AI navigation is durable in `safety-course/2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`; concise course navigation is `safety-course/SAFETY_COURSE_INDEX.md`. The broad safety-course research/course plan remains the planning surface and is deliberately not replaced by another duplicate syllabus.

The mature hazard-to-release chain is formally placed as the learner-facing core of **2520 — From hazards to safety functions**. Formal placement is not a claim of blind/fresh competency graduation.

A clean evaluator-facing protocol exists at `evaluation/2520_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md`. Actual information-separated execution/scoring remains open and must not be replaced by self-generating then self-reading an answer key.

Verification/validation remains durable in `safety-course/2520_VERIFICATION_VALIDATION_AND_PHYSICAL_PROOF_2026-09-22.md` with reusable `safety-course/SAFETY_VERIFICATION_VALIDATION_MATRIX.md`. Commissioning/release/change control remains explicit in `safety-course/2520_COMMISSIONING_RELEASE_AND_CHANGE_CONTROL_2026-09-22.md`; the integrity-method gate remains `safety-course/2520_INTEGRITY_METHOD_SELECTION_AND_TARGET_ALLOCATION_2026-09-22.md` with its reusable worksheet.

Cross-machine transfer remains represented by `safety-course/2520_TRANSFER_EXERCISE_SPINDLE_ROBOT_CELL_HAZARD_TO_RELEASE_2026-09-22.md`. Because the 2520 external/fresh evaluator is an information-separated dependency, it remains branch-local under `WORK_SELECTION_POLICY.md`; 2520 is not declared graduated.

**2530 — E-stop systems from first principles** has a coherent learner-facing route in `safety-course/2530_ENTRY_MAP_AND_RELEASE_GATE_2026-09-22.md`. Architecture/fault mapping, LinuxCNC authority-boundary tracing, span/reset/human factors and machine-level validation are durable. The learner-readable methodology is ready for external/fresh evaluation, not graduated.

An evaluator-facing protocol now exists at `evaluation/2530_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md`. It defines challenge constraints, deliverables, critical-fail conditions and scoring without publishing a hidden solution. External/fresh execution remains OPEN and branch-local.

2530 evidence-backed freezes remain in force: **E-STOP PRESENT != PRIMARY RISK REDUCTION COMPLETE**, **E-STOP != UNIVERSAL COMPLETE ENERGY REMOVAL**, **STOP CATEGORY != SAFETY INTEGRITY CLAIM**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, **EDM HEALTHY != MACHINE PHYSICAL SAFE STATE PROVED**, **TWO INPUT CHANNELS != TWO INDEPENDENT PHYSICAL WITNESSES**, **TEST PULSES HEALTHY != E-STOP MECHANISM PHYSICALLY OPERATED**, **MONITORED RESET VALID != ZONE CLEAR != ORDINARY START AUTHORIZED**, **A PUBLISHED PL/SIL FOR ONE MANUFACTURER EXAMPLE DOES NOT TRANSFER TO A LOOKALIKE CIRCUIT**, **E-STOP SPAN LABELLED != INTERFACE HAZARDS ANALYZED**, **INACTIVE DETACHABLE E-STOP VISIBLE != ACCEPTABLE OPERATOR STATE**, and **ORDINARY LINUXCNC STOP/ESTOP STATE != INDEPENDENT PERSONNEL-SAFETY AUTHORITY**.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** is now the active source-preparation branch. `safety-course/2540_SAFETY_RELAY_MEANING_SOURCE_PREP_2026-09-23.md` begins the module by separating ordinary relays, force-guided relays, safety relay modules, and the complete machine safety function. Current manufacturer evidence from Siemens, Rockwell Automation and Pilz is used to trace force-guided contact behavior, B10d/reliability role, and safety-relay monitoring scope without transferring a component rating to a complete machine function.

2540 initial freezes: **FORCE-GUIDED CONTACTS != COMPLETE SAFETY FUNCTION**, **B10d DATA PRESENT != ACHIEVED PL/SIL**, **SAFETY RELAY MODULE PRESENT != FINAL-ELEMENT PHYSICAL STATE PROVED**, and **SIMILAR RELAY PACKAGE/CONTACT COUNT != EQUIVALENT SAFETY DIAGNOSTIC BEHAVIOR**.

Core 2520 freezes remain in force: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **TEST PASSED != CURRENT MACHINE PROVED IF CONFIGURATION IDENTITY IS LOST OR CHANGED**, **PARTIAL REVALIDATION SCOPE COMES FROM IMPACT ANALYSIS, NOT CONVENIENCE**, **PLr / REQUIRED SIL COMES FROM THE SAFETY FUNCTION'S RISK/SRS CONTEXT, NOT TOPOLOGY**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **TWO CHANNELS != TWO INDEPENDENT PHYSICAL PATHS**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520 and 2530 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Continue 2540 with the course-plan research lab: compare at least five current commercial safety-relay families. Capture only documented Category/PL/SIL/PFH data where actually published, response time, contact/load ratings, reset modes, cross-fault behavior, EDM/feedback behavior, mission/use assumptions and reliability data. Mark unavailable fields UNKNOWN.
3. Reverse-map each commercial feature to the fault hypothesis/proposition it actually addresses; do not let a family-level rating substitute for machine-level safety-function evidence.
4. Continue relay/contactor physics: contact welding, AC/DC interruption, inductive loads/suppression, B10d/use profile, force-guided feedback, and the boundary between logic/safety relays and hazardous-energy final elements.
5. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0048Z-safety-2540-source-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
