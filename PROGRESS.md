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

2520 through 2580 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** remains READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** remains READY FOR EXTERNAL/FRESH EVALUATION with its drive-function physical-proposition map, ordinary-drive fallback, adversarial assessment, learner route and no-solution handoff.

**2580 — Hydraulic and pneumatic safety** is READY FOR EXTERNAL/FRESH EVALUATION. `safety-course/2580_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md` records a completed syllabus audit and canonical learner route. `evaluation/2580_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` preserves a no-solution external evaluation path. The release gate confirms coverage of stored pressure/accumulators, gravity loads, directional blocking versus supply isolation versus decompression versus load holding, monitored/redundant final elements, trapped volumes, spool/hose/cylinder failures, pneumatic safe exhaust, controlled repressurization/restart, maintenance restraint and human factors. It is not self-graduated.

**2590 — Guards, interlocks, presence sensing, and two-hand controls** is now the active branch. `safety-course/2590_GUARDS_INTERLOCKS_PRESENCE_SENSING_SOURCE_PREP_2026-09-23.md` establishes the first physical-access proposition map, separates guard interlocking from guard locking, ties presence-sensing position to actual stopping behavior, introduces pass-through/inside-zone and reset-visibility problems, and treats foreseeable defeat/usability as engineering inputs.

2590 freezes include: **GUARD CLOSED != DANGEROUS STATE ENDED**, **GUARD INTERLOCKED != GUARD LOCKED**, **GUARD LOCKED != APPLICATION-SUFFICIENT HOLDING FORCE PROVED**, **LIGHT CURTAIN INTERRUPTED != MACHINE PHYSICALLY STOPPED**, **PROTECTIVE FIELD CLEAR != PROTECTED SPACE EMPTY**, **DEVICE RESPONSE TIME != COMPLETE MACHINE STOPPING TIME**, **SAFETY DISTANCE != A CATALOG CONSTANT**, **HIGH-CODING INTERLOCK != DEFEAT IMPOSSIBLE**, **SAFETY RESET != MACHINE START AUTHORIZATION**, and **ORDINARY LINUXCNC/FPGA GUARD LOGIC != PERSONNEL-SAFETY AUTHORITY**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–2580 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Continue 2590 with a safeguard-selection map distinguishing fixed guards, interlocked movable guards, guard locking, presence sensing, two-hand controls and enabling/hold-to-run by physical proposition and lifecycle use.
3. Add an adversarial defeat analysis for mechanical, coded/non-contact and guard-locking devices; make safeguard usability/diagnostics part of the design rather than relying on warnings against bypass.
4. Teach ISO 13855-style minimum-distance/stopping-time reasoning symbolically and with an explicitly sourced sample, keeping actual machine stopping time/distance UNKNOWN until measured/validated.
5. Trace pass-through/inside-zone occupancy, reset visibility and restart prevention.
6. Add authoritative two-hand anti-tie-down/concurrent-operation and enabling-device evidence.
7. Keep maintenance energy isolation separate from production guarding and keep ordinary LinuxCNC/FPGA logic outside sole personnel-safety authority.

Newest precise checkpoint: `checkpoints/2026-09-23T1048Z-safety-2590-selection-map-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
