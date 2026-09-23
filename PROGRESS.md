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

2520 through 2590 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** remains READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** remains READY FOR EXTERNAL/FRESH EVALUATION with its drive-function physical-proposition map, ordinary-drive fallback, adversarial assessment, learner route and no-solution handoff.

**2580 — Hydraulic and pneumatic safety** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. It is not self-graduated.

**2590 — Guards, interlocks, presence sensing, and two-hand controls** is READY FOR EXTERNAL/FRESH EVALUATION. Its line-item syllabus audit found no material learner-facing gap. `research/2590_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md` provides the canonical route and `evaluation/2590_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` provides a no-solution fresh-evaluation contract. Actual machine stopping behavior, safety distance, guard-lock force, setup-mode speed/force and integrity targets remain `UNKNOWN` until application evidence exists. It is not self-graduated.

**25A0 — Safety PLCs and programmable safety** is the active branch. Initial source preparation is now extended by `research/25A0_END_TO_END_AND_BLACK_CHANNEL_2026-09-23.md`, which traces a Siemens fail-safe-controller family across CPU/internal diagnostics -> F-DI diagnostics -> safety application -> F-DQ diagnostics -> external final element; adds a dry-contact/OSSD/PNP fault-detection matrix; separates PROFIsafe black-channel mechanisms from ordinary network availability; records an inspectable open assurance project with explicit non-certification limits; and adds an adversarial machine case where correct PLC logic still fails because field/timing/CCF/final-element assumptions are wrong.

25A0 freezes include: **SAFETY PLC INTERNAL DIAGNOSTICS != COMPLETE SAFETY FUNCTION VALIDATED**, **TEST PULSE PRESENT != EVERY WIRING FAULT DETECTED**, **TEST-PULSE DIAGNOSTIC != PHYSICAL SAFE-STATE PROOF**, **LONGER DISCREPANCY WINDOW != FREE NUISANCE-TRIP FIX**, **SAFE OUTPUT RATING MATCH != ACTUATOR TEST-PULSE COMPATIBILITY PROVED**, **CERTIFIED FUNCTION BLOCK != CERTIFIED MACHINE SAFETY FUNCTION**, **CORRECT SAFETY-PLC LOGIC != CORRECT FIELD ASSUMPTIONS**, **SAFE OUTPUT OFF != FINAL ELEMENT PHYSICALLY SAFE**, **TWO VALID INPUT BITS != TWO INDEPENDENT PHYSICAL SAFETY CHANNELS**, **ELECTRICAL FAULT DETECTION != COMMON-CAUSE CONTROL**, **LOGIC UNCHANGED != SAFETY FUNCTION UNCHANGED WHEN TIMING PARAMETERS CHANGE**, **BLACK-CHANNEL SAFETY != SAFETY-RATED ETHERNET**, **SAFETY TELEGRAM ACCEPTED != PHYSICAL SAFE STATE PROVED**, **COMMUNICATION TIMEOUT TO SAFE COMMAND != FINAL ELEMENT SUCCESS**, **OPEN SOURCE + TESTS != FUNCTIONAL-SAFETY CERTIFICATION**, and **SAFETY PROGRAM REVIEW PASS != MACHINE SAFETY VALIDATION PASS**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–2590 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Perform a 25A0 syllabus/competency coverage audit and fill only a material learner-facing gap.
3. Strengthen programmable-safety lifecycle/change-control coverage if needed: configuration/version identity, parameter changes, replacement hardware/firmware, proof-test assumptions and revalidation triggers.
4. Add a compact learner exercise separating input-diagnostic, safety-program, communication, final-element and physical-safe-state evidence.
5. If coverage is coherent, create the canonical 25A0 learner route and information-separated evaluator handoff; mark READY FOR EXTERNAL/FRESH EVALUATION rather than self-graduating.
6. Rotate immediately to the next named safety-course module after 25A0 when its release gate is ready.

Newest precise checkpoint: `checkpoints/2026-09-23T1349Z-safety-25A0-integration-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
