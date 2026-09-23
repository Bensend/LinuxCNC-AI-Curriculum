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

**2590 — Guards, interlocks, presence sensing, and two-hand controls** is now READY FOR EXTERNAL/FRESH EVALUATION. Its line-item syllabus audit found no material learner-facing gap. `research/2590_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md` provides the canonical route and `evaluation/2590_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` provides a no-solution fresh-evaluation contract. Actual machine stopping behavior, safety distance, guard-lock force, setup-mode speed/force and integrity targets remain `UNKNOWN` until application evidence exists. It is not self-graduated.

2590 freezes include: **GUARD CLOSED != DANGEROUS STATE ENDED**, **GUARD INTERLOCKED != GUARD LOCKED**, **GUARD LOCKED != APPLICATION-SUFFICIENT HOLDING FORCE PROVED**, **LIGHT CURTAIN INTERRUPTED != MACHINE PHYSICALLY STOPPED**, **PROTECTIVE FIELD CLEAR != PROTECTED SPACE EMPTY**, **DEVICE RESPONSE TIME != COMPLETE MACHINE STOPPING TIME**, **SAFETY DISTANCE != A CATALOG CONSTANT**, **HIGH-CODING INTERLOCK != DEFEAT IMPOSSIBLE**, **TWO BUTTONS TRUE != VALIDATED TWO-HAND SAFETY FUNCTION**, **TWO-HAND PROTECTION OF ONE OPERATOR != PROTECTION OF EVERY PERSON WITH HAZARD ACCESS**, **ENABLING MIDDLE POSITION != UNRESTRICTED MOTION AUTHORITY**, **THREE-POSITION DEVICE != COMPLETE SETUP-MODE SAFETY FUNCTION**, **SAFETY RESET/REARM != MACHINE START AUTHORIZATION**, **PRODUCTION SAFEGUARDING != MAINTENANCE ENERGY ISOLATION**, and **ORDINARY LINUXCNC/FPGA GUARD LOGIC != PERSONNEL-SAFETY AUTHORITY**.

**25A0 — Safety PLCs and programmable safety** is the active branch. Initial source preparation now separates safety-controller internal diagnostics, safe-input test pulses, discrepancy timing, safe-output diagnostic pulses, application logic, field wiring/final elements and physical safe-state proof. Manufacturer evidence is recorded in `research/25A0_PROGRAMMABLE_SAFETY_SOURCE_PREP_2026-09-23.md`.

25A0 initial freezes include: **SAFETY PLC INTERNAL DIAGNOSTICS != COMPLETE SAFETY FUNCTION VALIDATED**, **TEST PULSE PRESENT != EVERY WIRING FAULT DETECTED**, **TEST-PULSE DIAGNOSTIC != PHYSICAL SAFE-STATE PROOF**, **LONGER DISCREPANCY WINDOW != FREE NUISANCE-TRIP FIX**, **SAFE OUTPUT RATING MATCH != ACTUATOR TEST-PULSE COMPATIBILITY PROVED**, and **CERTIFIED FUNCTION BLOCK != CERTIFIED MACHINE SAFETY FUNCTION**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–2590 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Continue 25A0 by tracing one documented safety-controller family through CPU/self-test -> safe input diagnostics -> safety application -> safe output diagnostics -> external final element.
3. Build a fault-detection matrix comparing dual-channel dry-contact, OSSD, and test-pulse/PNP input patterns. State which opens, cross-shorts, 24 V/0 V faults and timing disagreements are detected, not detected, or topology-dependent.
4. Trace an authoritative black-channel safety-communication example and distinguish safety-protocol mechanisms from ordinary Ethernet/network availability.
5. Inspect at least one open/inspectable functional-safety project with published hazard analysis, tests and limitations as required by the syllabus; inspectability alone is not certification.
6. Build a 25A0 adversarial case where logically correct safety software still fails the machine-level safety proposition because of field-interface, timing, CCF or final-element assumptions.
7. Preserve maintenance energy isolation as separate from production safeguarding and LinuxCNC/FPGA as ordinary control/diagnostics rather than sole safety authority.

Newest precise checkpoint: `checkpoints/2026-09-23T1250Z-safety-25A0-programmable-safety-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
