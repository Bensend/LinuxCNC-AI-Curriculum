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

2520 through 2560 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** is READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** is the active branch. `safety-course/2570_DRIVES_STO_BRAKING_HAZARDOUS_MOTION_SOURCE_PREP_2026-09-23.md` establishes the base drive-safety boundaries. `safety-course/2570_DRIVE_FUNCTION_PHYSICAL_PROPOSITION_MAP_2026-09-23.md` now maps SINAMICS S120 STO, SS1, SS2, SOS, SBC and SBT to exact physical propositions and non-propositions, traces spindle/coast and vertical/gravity hazards, and develops the syllabus-required ordinary-drive contactor fallback pattern using manufacturer evidence without claiming certification. `safety-course/2570_ADVERSARIAL_ASSESSMENT_DRIVE_SAFETY_2026-09-23.md` tests these boundaries.

2570 freezes include: **STO ACTIVE != SHAFT STANDSTILL**, **STO ACTIVE != ELECTRICAL ISOLATION**, **TORQUE REMOVED != GRAVITY OR EXTERNAL FORCE CONTROLLED**, **STO != SS1 != SS2 != SOS**, **SAFE BRAKE COMMAND != LOAD PHYSICALLY RESTRAINED**, **TORQUE-PRODUCING CAPABILITY INHIBITED != MOTION PROVED STOPPED**, **SAFE MONITORED STANDSTILL != DE-ENERGIZED DRIVE**, **SAFE BRAKE COMMAND != MECHANICAL BRAKE EFFECT PROVED**, **SUCCESSFUL BRAKE TEST != PERMANENT BRAKE HEALTH**, **CONTACTOR POWER REMOVAL != INTEGRATED STO BY LABEL SUBSTITUTION**, **CONTACTOR OPEN != DC BUS PROVED SAFE**, and **SAFETY RESET != NORMAL MOTION START AUTHORIZATION**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–2560 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Audit 2570 against the current safety-course syllabus, filling only genuine learner-facing gaps.
3. If coherent, create the concise 2570 entry map/release gate and information-separated evaluator handoff.
4. Then recover the next named safety-course module and begin authoritative source preparation rather than manufacturing additional 2570 material.
5. Keep all absent machine stopping times, brake capacities, coast times, safe distances, load behavior and integrity claims UNKNOWN.
6. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0750Z-safety-2570-coverage-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
