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

2520 through 2570 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** remains READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** is READY FOR EXTERNAL/FRESH EVALUATION. `safety-course/2570_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md` confirms coverage of drive enable/STO, SS1/SS2/SOS, braking/holding, inertia/coast, gravity/external forces, ordinary-drive fallback, stored energy, reset/restart, isolation, LinuxCNC authority boundary and validation. `evaluation/2570_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` preserves a no-solution external evaluation path.

**2580 — Hydraulic and pneumatic safety** is the active branch. `safety-course/2580_HYDRAULIC_PNEUMATIC_SAFETY_SOURCE_PREP_2026-09-23.md` established the initial physical-proposition map. `safety-course/2580_FLUID_POWER_FAULT_TREE_AND_PNEUMATIC_ANALOGUE_2026-09-23.md` now works backward from `hazardous closing/descent prevented`, explicitly separates directional blocking, supply isolation, decompression and load holding, and adds stuck-spool, leakage/drift, accumulator/trapped-volume, hose/fitting, cylinder/seal, diagnostic disagreement and common-hydraulic-path branches. It also adds the pneumatic safe-exhaust/repressurization analogue using current Festo and SMC manufacturer evidence.

2580 freezes now include: **PUMP OFF != HYDRAULIC ENERGY GONE**, **VALVE COMMANDED SAFE != VALVE PHYSICALLY SAFE**, **VALVE POSITION SAFE != DOWNSTREAM PRESSURE PROVED SAFE**, **SUPPLY SHUTOFF != TRAPPED ENERGY EXHAUSTED**, **DUMP COMMANDED != RESIDUAL PRESSURE PROVED SAFE**, **DIRECTIONAL NEUTRAL != GRAVITY LOAD HELD**, **PRESSURE LOW AT ONE SENSOR != ALL HAZARDOUS VOLUMES DE-ENERGIZED**, **LOSS OF PUMP/ELECTRIC POWER != LOSS OF ACCUMULATOR ENERGY**, **REDUNDANT ELECTRICAL CHANNELS != REDUNDANT HYDRAULIC FINAL ELEMENTS**, **SAFE EXHAUST VALVE OPEN != EVERY DOWNSTREAM VOLUME PROVED DEPRESSURIZED**, **PNEUMATIC SUPPLY EXHAUSTED != GRAVITY LOAD RESTRAINED**, **SAFETY RESET != REPRESSURIZATION != MOTION START AUTHORIZATION**, and **FUNCTIONAL FLUID-POWER SAFE STATE != MAINTENANCE ENERGY ISOLATION**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–2570 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Build the 2580 adversarial assessment around a mixed hydraulic/pneumatic machine with gravity load, accumulator/trapped energy, monitored valves, hose/cylinder failure and maintenance access.
3. Require the learner to state, for each diagnostic witness, exactly what it proves and what physical proposition remains unproved.
4. Audit 2580 syllabus coverage for stored energy, gravity loads, redundant/monitored valves, accumulators/trapped pressure, hose/cylinder failures, maintenance restraint, safe exhaust and repressurization/restart human factors.
5. If coverage is coherent, create the concise 2580 learner route and information-separated evaluator handoff, then rotate to the next named safety module.
6. Keep machine-specific hydraulic truth tables, pressure thresholds, stopping times, valve diagnostic coverage, PL/SIL and load capacity UNKNOWN unless applicable evidence exists.
7. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0952Z-safety-2580-assessment-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.