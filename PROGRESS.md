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

2520 through 25C0 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** remains READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** remains READY FOR EXTERNAL/FRESH EVALUATION with its drive-function physical-proposition map, ordinary-drive fallback, adversarial assessment, learner route and no-solution handoff.

**2580 — Hydraulic and pneumatic safety** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. It is not self-graduated.

**2590 — Guards, interlocks, presence sensing, and two-hand controls** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. Application-specific stopping behavior, safety distance and integrity targets remain UNKNOWN until evidence exists.

**25A0 — Safety PLCs and programmable safety** remains READY FOR EXTERNAL/FRESH EVALUATION with lifecycle/change-control coverage, canonical learner route and no-solution handoff. It is not self-graduated.

**25B0 — Failure analysis and fault injection** remains READY FOR EXTERNAL/FRESH EVALUATION with its quantitative/DC/proof-test boundary, canonical learner route and no-solution evaluator contract. Percentage of hand-selected injections is not DCavg and missing quantitative inputs remain UNKNOWN.

**25C0 — Designing for humans who will defeat safeguards** is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated. Reset/restart/visibility/setup evidence, canonical learner route and no-solution external gate are durable.

**25D0 — Low-cost safety architectures** is the active branch. `research/25D0_LOW_COST_ARCHITECTURES_ENTRY_2026-09-23.md` defines the comparison contract and Tier A-E ladder. `research/25D0_TIER_ABC_FAULT_COMPARISON_2026-09-23.md` compares Tier A single-path, Tier B dual-channel safety-module and Tier C redundant-final-element + EDM architectures. `research/25D0_VFD_STO_AND_FLUID_POWER_COMPARISON_2026-09-23.md` now completes the requested drive comparison and retains Tier E as a materially necessary fluid-power competency. ABB/Rockwell evidence bounds integrated STO to prevention of drive-generated torque under stated assumptions, not standstill/electrical isolation/stored-energy discharge. Tier E explicitly separates supply isolation, dump/decompression and load holding/restraint without inventing machine-specific hydraulic truth. Current source work still does not justify comparable public dollar pricing, so cost remains expressed as named proposition/failure path bought rather than fabricated figures.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **MORE COMPONENTS != MORE SAFETY**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25C0 information-separated competency gates; do not contaminate them.
2. Audit 25D0 line-by-line against its current safety-course syllabus and competency requirements.
3. Fill only a genuine learner-facing gap; otherwise create the canonical learner route/release gate and separate no-solution information-separated evaluator handoff.
4. Mark 25D0 READY FOR EXTERNAL/FRESH EVALUATION rather than self-graduating if the audit is coherent.
5. Keep all physical propositions bounded: STO is not standstill/isolation; external switching is not stored-energy proof; fluid supply isolation is not decompression/load holding; maintenance isolation remains separately justified.
6. Add actual cost figures only if traceable like-for-like current sources exist; otherwise preserve cost classes and explain what each increment buys.
7. Freeze executable compute only if a concrete unresolved implementation question survives authoritative evidence; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-23T1836Z-safety-25D0-audit-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.