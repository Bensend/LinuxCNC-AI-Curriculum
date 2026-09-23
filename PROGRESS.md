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

**2580 — Hydraulic and pneumatic safety** is now the active branch. `safety-course/2580_HYDRAULIC_PNEUMATIC_SAFETY_SOURCE_PREP_2026-09-23.md` establishes the first physical-proposition map for pump shutdown, directional commands, monitored valve position, supply shutoff, dump/decompression, load holding, pressure sensing and mechanical restraint. Manufacturer evidence anchors hydraulic area shutoff, monitored press-control integration and hose-failure/load-holding architectures without transferring component claims to complete-machine claims.

2580 freezes include: **PUMP OFF != HYDRAULIC ENERGY GONE**, **VALVE COMMANDED SAFE != VALVE PHYSICALLY SAFE**, **VALVE POSITION SAFE != DOWNSTREAM PRESSURE PROVED SAFE**, **SUPPLY SHUTOFF != TRAPPED ENERGY EXHAUSTED**, **DUMP COMMANDED != RESIDUAL PRESSURE PROVED SAFE**, **DIRECTIONAL NEUTRAL != GRAVITY LOAD HELD**, **PRESSURE LOW AT ONE SENSOR != ALL HAZARDOUS VOLUMES DE-ENERGIZED**, **ELECTRICAL STOP != HYDRAULIC/MECHANICAL SAFE STATE**, and **FUNCTIONAL FLUID-POWER SAFE STATE != MAINTENANCE ENERGY ISOLATION**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–2570 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Build the 2580 generic hydraulic press/vertical-axis fault tree backward from `hazardous closing/descent prevented`.
3. Distinguish blocked-center, shutoff, dump/decompression and load-holding functions and add accumulator/trapped-volume plus hose/cylinder failure branches.
4. Add the pneumatic analogue: safe exhaust, trapped downstream volume, gravity loads and restart/repressurization.
5. Explicitly classify which risk reductions can be electrical and which require fluid-power or mechanical measures.
6. Keep machine-specific hydraulic truth tables, pressure thresholds, stopping times, valve diagnostic coverage, PL/SIL and load capacity UNKNOWN unless applicable evidence exists.
7. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0855Z-safety-2580-fault-tree-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.