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

Because the 2520 external/fresh evaluator is an information-separated dependency, it remains branch-local under `WORK_SELECTION_POLICY.md`; 2520 is not declared graduated.

**2530 — E-stop systems from first principles** has now advanced beyond initial source preparation. `safety-course/2530_ESTOP_ARCHITECTURE_COMPARISON_AND_FAULT_MAP_2026-09-22.md` compares current Rockwell Guardmaster, Siemens SIRIUS 3SK1 and Pilz PNOZ application architectures and reverse-maps input diagnostics, monitored reset/start, feedback/EDM, output/final-element structure and physical proof limits to explicit fault hypotheses. It also contains the required incremental learner exercise: proposition first, then single-channel fault attack, justified diagnostics/redundancy, common-cause attack, reset/restart attack and physical-proof attack. No topology is assigned a generic PL/SIL.

LinuxCNC's ordinary-control boundary is now source-traced at pinned upstream commit `514be4f657b2f1c432ebaaebd117ef112e3e7565` in `safety-course/2530_LINUXCNC_ESTOP_LATCH_BOUNDARY_TRACE_2026-09-22.md`. `estop_latch` is explicitly treated as software state/coordination logic; its reset edge, latch state and watchdog are not evidence of a machine physical safe state or independent personnel-safety authority.

2530 evidence-backed freezes include: **E-STOP PRESENT != PRIMARY RISK REDUCTION COMPLETE**, **E-STOP != UNIVERSAL COMPLETE ENERGY REMOVAL**, **STOP CATEGORY != SAFETY INTEGRITY CLAIM**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, **EDM HEALTHY != MACHINE PHYSICAL SAFE STATE PROVED**, **TWO INPUT CHANNELS != TWO INDEPENDENT PHYSICAL WITNESSES**, **TEST PULSES HEALTHY != E-STOP MECHANISM PHYSICALLY OPERATED**, **MONITORED RESET VALID != ZONE CLEAR != ORDINARY START AUTHORIZED**, **A PUBLISHED PL/SIL FOR ONE MANUFACTURER EXAMPLE DOES NOT TRANSFER TO A LOOKALIKE CIRCUIT**, and **ORDINARY LINUXCNC STOP/ESTOP STATE != INDEPENDENT PERSONNEL-SAFETY AUTHORITY**.

Core 2520 freezes remain in force: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **TEST PASSED != CURRENT MACHINE PROVED IF CONFIGURATION IDENTITY IS LOST OR CHANGED**, **PARTIAL REVALIDATION SCOPE COMES FROM IMPACT ANALYSIS, NOT CONVENIENCE**, **PLr / REQUIRED SIL COMES FROM THE SAFETY FUNCTION'S RISK/SRS CONTEXT, NOT TOPOLOGY**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **TWO CHANNELS != TWO INDEPENDENT PHYSICAL PATHS**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520 information-separated competency gate until an actually separated evaluator/oracle can execute it; do not contaminate it by committing a hidden answer learner-side.
2. Continue 2530 with emergency-stop span/segmentation and reset-location/zone-visibility human factors for linked machines and cells using current authoritative manufacturer/standards guidance where accessible.
3. Build a 2530 adversarial assessment that makes the learner select between controlled/uncontrolled stopping conceptually from hazard physics while keeping machine-specific stopping time/distance and brake/hydraulic/pneumatic behavior `UNKNOWN` unless evidence is supplied.
4. Add commissioning/validation checks specific to E-stop: every device/span, covered input faults, reset behavior, final-element feedback, retained production demand, power-cycle/recovery and physical stopping proposition.
5. Do not infer PL/SIL, diagnostic coverage percentages, stopping distance, stop category or final-element adequacy from the three manufacturer examples.

Newest precise checkpoint: `checkpoints/2026-09-22T2250Z-safety-2530-architecture-fault-map-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
