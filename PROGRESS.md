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

Fresh-AI navigation is durable in `safety-course/2520_ENTRY_MAP_AND_FRESH_AI_HANDOFF_2026-09-22.md`; concise course navigation is now `safety-course/SAFETY_COURSE_INDEX.md`. The broad `SAFETY_COURSE_RESEARCH.md` remains the research/course plan and was deliberately not replaced by another duplicate syllabus.

The mature hazard-to-release chain is formally placed as the learner-facing core of **2520 — From hazards to safety functions**. Formal placement is not a claim of blind/fresh competency graduation.

A clean evaluator-facing protocol now exists at `evaluation/2520_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md`. It defines challenge-selection requirements, learner deliverables, scoring dimensions, critical-fail conditions and information-separation procedure **without storing a hidden solution**. The challenge must use a machine surface materially distinct from learner-readable worked examples. Actual information-separated execution/scoring remains open and must not be replaced by self-generating then self-reading an answer key.

Verification/validation remains durable in `safety-course/2520_VERIFICATION_VALIDATION_AND_PHYSICAL_PROOF_2026-09-22.md` with reusable `safety-course/SAFETY_VERIFICATION_VALIDATION_MATRIX.md`. Commissioning/release/change control remains explicit in `safety-course/2520_COMMISSIONING_RELEASE_AND_CHANGE_CONTROL_2026-09-22.md`; the integrity-method gate remains `safety-course/2520_INTEGRITY_METHOD_SELECTION_AND_TARGET_ALLOCATION_2026-09-22.md` with its reusable worksheet.

Cross-machine transfer remains represented by `safety-course/2520_TRANSFER_EXERCISE_SPINDLE_ROBOT_CELL_HAZARD_TO_RELEASE_2026-09-22.md`. Recovery/return-to-service material remains supporting evidence and must not displace the core hazard-to-release sequence.

Because the 2520 external/fresh evaluator is an information-separated dependency, it is branch-local under `WORK_SELECTION_POLICY.md`. High-value **2530 — E-stop systems from first principles** source preparation has therefore begun in `safety-course/2530_ESTOP_FIRST_PRINCIPLES_SOURCE_PREP_2026-09-22.md` without declaring 2520 graduated.

2530 initial evidence-backed freezes: **E-STOP PRESENT != PRIMARY RISK REDUCTION COMPLETE**, **E-STOP != UNIVERSAL COMPLETE ENERGY REMOVAL**, **STOP CATEGORY != SAFETY INTEGRITY CLAIM**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, **EDM HEALTHY != MACHINE PHYSICAL SAFE STATE PROVED**, and **ORDINARY LINUXCNC STOP/ESTOP STATE != INDEPENDENT PERSONNEL-SAFETY AUTHORITY**.

Core 2520 freezes remain in force: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **TEST PASSED != CURRENT MACHINE PROVED IF CONFIGURATION IDENTITY IS LOST OR CHANGED**, **PARTIAL REVALIDATION SCOPE COMES FROM IMPACT ANALYSIS, NOT CONVENIENCE**, **PLr / REQUIRED SIL COMES FROM THE SAFETY FUNCTION'S RISK/SRS CONTEXT, NOT TOPOLOGY**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **TWO CHANNELS != TWO INDEPENDENT PHYSICAL PATHS**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520 information-separated competency gate until an actually separated evaluator/oracle can execute it; do not contaminate it by committing a hidden answer learner-side.
2. Continue 2530 source/professional-architecture work: compare at least three current manufacturer E-stop/safety-relay application architectures and reverse-map inputs, reset, diagnostics/EDM and final elements to explicit fault hypotheses and physical propositions.
3. Build the learner-facing incremental single-channel -> fault analysis -> monitored/redundant architecture exercise only after the source comparison; topology alone must not be presented as a PL/SIL claim.
4. Trace LinuxCNC `estop_latch` / machine-control interaction only to establish the ordinary-control boundary; do not migrate personnel-safety authority into LinuxCNC/HAL/normal FPGA logic.
5. Preserve machine-specific stop selection, stopping time/distance, hydraulic/pneumatic behavior and integrity targets as `UNKNOWN` until design-specific evidence exists.

Newest precise checkpoint: `checkpoints/2026-09-22T2150Z-safety-2520-gate-2530-source-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
