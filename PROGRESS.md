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

**2560 — IEC 62061 / SIL concepts for machine builders** has completed its learner-facing syllabus pass. `safety-course/2560_DUAL_METHOD_PL_SIL_COMPARISON_2026-09-23.md` analyzes one symbolic guarded-motion safety function independently through ISO 13849-style and IEC 62061-style reasoning, maps shared versus method-specific evidence, and includes cases where attractive arithmetic is defeated by architecture/dependency/application evidence. `safety-course/2560_ADVERSARIAL_ASSESSMENT_SIL_WITHOUT_LABEL_TRANSFER_2026-09-23.md` tests the boundary. `safety-course/2560_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md` found no remaining material syllabus gap, and `evaluation/2560_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` provides a no-solution external gate. 2560 is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.

2560 freezes include: **SIL TARGET != COMPONENT SIL LABEL**, **PFHd IN RANGE != COMPLETE SAFETY FUNCTION VALIDATED**, **SMALL PFHd NUMBER != PERMISSION TO IGNORE ARCHITECTURAL CONSTRAINTS**, **RANDOM-HARDWARE CALCULATION != SYSTEMATIC-CORRECTNESS EVIDENCE**, **CORRECT ARITHMETIC OVER AN INCOMPLETE ARCHITECTURE IS STILL THE WRONG MODEL**, **FIX AN OBVIOUS SINGLE-POINT/COMMON-CAUSE WEAKNESS BEFORE OPTIMIZING THE RELIABILITY MODEL AROUND IT**, and **A VALID METHOD CANNOT RESCUE INVALID INPUT PROVENANCE**.

**2570 — Drives, STO, braking, and hazardous motion** is now the active source branch. `safety-course/2570_DRIVES_STO_BRAKING_HAZARDOUS_MOTION_SOURCE_PREP_2026-09-23.md` establishes from current Rockwell and Siemens manufacturer evidence that STO removes torque-producing capability under its stated architecture but is not electrical isolation, does not establish standstill, and does not control gravity/external-force motion by itself. It distinguishes STO, SS1, SS2, SOS and safe brake control and preserves machine-specific stopping/brake/load facts as UNKNOWN.

Initial 2570 freezes: **STO ACTIVE != SHAFT STANDSTILL**, **STO ACTIVE != ELECTRICAL ISOLATION**, **TORQUE REMOVED != GRAVITY OR EXTERNAL FORCE CONTROLLED**, **STO != SS1 != SS2 != SOS**, **SAFE BRAKE COMMAND != LOAD PHYSICALLY RESTRAINED**, and **FASTEST POWER REMOVAL != SHORTEST OR SAFEST MACHINE STOP IN EVERY MECHANISM**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–2560 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Continue 2570 by mapping one current servo/VFD manufacturer's STO/SS1/SS2/SOS/brake functions to machine-level physical propositions and explicit non-propositions.
3. Build the syllabus-required low-cost ordinary-drive fallback architecture for a drive without certified STO, with contactor/energy/restart/feedback limitations stated explicitly and no certification claim.
4. Include gravity-axis and spindle/coast-down cases so torque removal, motion stopping, holding/restraint and electrical isolation remain distinct.
5. Keep all absent machine stopping times, brake capacities, coast times, safe distances and load behavior UNKNOWN.
6. Keep ordinary LinuxCNC/FPGA control, safety-related control, diagnostics/monitoring and physical energy-removal mechanisms explicitly separated.

Newest precise checkpoint: `checkpoints/2026-09-23T0651Z-safety-2570-drive-map-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
