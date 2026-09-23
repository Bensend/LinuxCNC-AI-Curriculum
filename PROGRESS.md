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

2520 through 25A0 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** remains READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** remains READY FOR EXTERNAL/FRESH EVALUATION with its drive-function physical-proposition map, ordinary-drive fallback, adversarial assessment, learner route and no-solution handoff.

**2580 — Hydraulic and pneumatic safety** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. It is not self-graduated.

**2590 — Guards, interlocks, presence sensing, and two-hand controls** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. Application-specific stopping behavior, safety distance and integrity targets remain UNKNOWN until evidence exists.

**25A0 — Safety PLCs and programmable safety** is now READY FOR EXTERNAL/FRESH EVALUATION. `research/25A0_LIFECYCLE_CHANGE_CONTROL_AND_RELEASE_GATE_2026-09-23.md` closes the lifecycle/change-control gap, adds configuration/signature/replacement/revalidation reasoning, a five-layer evidence-separation exercise, syllabus audit and canonical learner route. `evaluation/25A0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` is the no-solution fresh-evaluation contract. It is not self-graduated.

25A0 freezes include: **SAFETY PLC INTERNAL DIAGNOSTICS != COMPLETE SAFETY FUNCTION VALIDATED**, **TEST PULSE PRESENT != EVERY WIRING FAULT DETECTED**, **TEST-PULSE DIAGNOSTIC != PHYSICAL SAFE-STATE PROOF**, **SAFE OUTPUT OFF != FINAL ELEMENT PHYSICALLY SAFE**, **TWO VALID INPUT BITS != TWO INDEPENDENT PHYSICAL SAFETY CHANNELS**, **BLACK-CHANNEL SAFETY != SAFETY-RATED ETHERNET**, **SAFETY TELEGRAM ACCEPTED != PHYSICAL SAFE STATE PROVED**, **SAFETY PROGRAM REVIEW PASS != MACHINE SAFETY VALIDATION PASS**, **F-SW SIGNATURE UNCHANGED != COMPLETE SAFETY FUNCTION UNCHANGED**, and **PARAMETER-ONLY CHANGE != NON-SAFETY CHANGE**.

**25B0 — Failure analysis and fault injection** is the active branch. `research/25B0_FAILURE_ANALYSIS_ENTRY_2026-09-23.md` defines the SRS-to-fault-to-evidence chain; separates FMEA/FMEDA/fault-tree roles; enumerates single, latent, CCF, power, wiring, final-element, feedback, software, network and configuration fault classes; defines a guarded-spindle fault-tree example; and imposes a question-driven fault-injection rule. No executable lab is justified yet.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25A0 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Continue 25B0 with a machine-neutral fault-injection matrix across power, wiring, sensor, logic, communication, final-element and physical-state faults.
3. Add latent-fault and common-cause examples demonstrating limits of sequential single-fault tests.
4. Build the safe test-selection hierarchy from authoritative source/static reasoning through low-energy/isolated tests; do not run machine tests merely for activity.
5. Add adversarial cases for frozen plausible feedback, welded output plus misleading feedback, stuck valve, corrupted parameters and network timeout.
6. Freeze executable compute only if a concrete unresolved question survives source/engineering analysis; if so use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-23T1448Z-safety-25B0-failure-analysis-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.