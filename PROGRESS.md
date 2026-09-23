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

2520 through 25D0 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** remains READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** remains READY FOR EXTERNAL/FRESH EVALUATION with its drive-function physical-proposition map, ordinary-drive fallback, adversarial assessment, learner route and no-solution handoff.

**2580 — Hydraulic and pneumatic safety** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. It is not self-graduated.

**2590 — Guards, interlocks, presence sensing, and two-hand controls** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. Application-specific stopping behavior, safety distance and integrity targets remain UNKNOWN until evidence exists.

**25A0 — Safety PLCs and programmable safety** remains READY FOR EXTERNAL/FRESH EVALUATION with lifecycle/change-control coverage, canonical learner route and no-solution handoff. It is not self-graduated.

**25B0 — Failure analysis and fault injection** remains READY FOR EXTERNAL/FRESH EVALUATION with its quantitative/DC/proof-test boundary, canonical learner route and no-solution evaluator contract. Percentage of hand-selected injections is not DCavg and missing quantitative inputs remain UNKNOWN.

**25C0 — Designing for humans who will defeat safeguards** remains READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated. Reset/restart/visibility/setup evidence, canonical learner route and no-solution external gate are durable.

**25D0 — Low-cost safety architectures** is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated. Its low-cost guard-interlock gap is closed; canonical learner route and information-separated evaluator contract are durable. Actual dollar pricing remains unfrozen absent traceable like-for-like current sources.

**25E0 — Validation, commissioning, and proof testing** is the active branch. `research/25E0_VALIDATION_COMMISSIONING_ENTRY_2026-09-23.md` remains the canonical syllabus entry. `research/25E0_SRS_VALIDATION_MATRIX_AND_ADVERSARIAL_COMMISSIONING_2026-09-23.md` now adds an SRS-to-validation matrix spanning E-stop, guard/interlock, STO/coast, fluid-power safe state and reset/restart; five adversarial commissioning cases where software/status evidence can pass while the physical proposition fails; lifecycle stopping-time/revalidation reasoning; proof-test interval boundaries; and reconciliation rules for exceptional-mode/muting/override evidence. SICK stop-time guidance supports physical remeasurement before initial commissioning and after significant or expected usage-related changes such as brake wear. No universal stopping margin, proof-test interval or machine integrity claim is frozen.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **MORE COMPONENTS != MORE SAFETY**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **GUARD CLOSED != DANGEROUS STATE ENDED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, **UNCHANGED SAFETY PROGRAM != UNCHANGED VALIDATED SAFETY FUNCTION**, **STOPPING TIME ON COMMISSIONING DAY != STOPPING TIME PROVED FOR ALL FUTURE MACHINE STATES**, **STATUS BIT TIMING != PHYSICAL CESSATION TIMING**, **RETURN TO NORMAL SOFTWARE STATE != PRODUCTION SAFEGUARDS PHYSICALLY RESTORED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25D0 information-separated competency gates; do not contaminate them.
2. Perform the 25E0 line-by-line syllabus/competency audit.
3. Inspect existing exceptional-mode/muting/override artifacts by exact filename and link them into the canonical route rather than duplicating their solution content.
4. If the audit finds a genuine learner-facing gap, fill only that gap; otherwise create the canonical 25E0 learner route/release gate and separate information-separated no-solution evaluator handoff.
5. Keep stopping limits, proof-test intervals, quantitative integrity claims and machine-specific physical thresholds UNKNOWN until justified evidence exists.
6. Freeze executable compute only if a concrete unresolved implementation question survives authoritative evidence; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-23T2049Z-safety-25E0-audit-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
