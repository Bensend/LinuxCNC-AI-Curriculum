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

2520 through 25E0 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** remains READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** remains READY FOR EXTERNAL/FRESH EVALUATION with its drive-function physical-proposition map, ordinary-drive fallback, adversarial assessment, learner route and no-solution handoff.

**2580 — Hydraulic and pneumatic safety** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. It is not self-graduated.

**2590 — Guards, interlocks, presence sensing, and two-hand controls** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. Application-specific stopping behavior, safety distance and integrity targets remain UNKNOWN until evidence exists.

**25A0 — Safety PLCs and programmable safety** remains READY FOR EXTERNAL/FRESH EVALUATION with lifecycle/change-control coverage, canonical learner route and no-solution handoff. It is not self-graduated.

**25B0 — Failure analysis and fault injection** remains READY FOR EXTERNAL/FRESH EVALUATION with its quantitative/DC/proof-test boundary, canonical learner route and no-solution evaluator contract. Percentage of hand-selected injections is not DCavg and missing quantitative inputs remain UNKNOWN.

**25C0 — Designing for humans who will defeat safeguards** remains READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated. Reset/restart/visibility/setup evidence, canonical learner route and no-solution external gate are durable.

**25D0 — Low-cost safety architectures** remains READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated. Actual dollar pricing remains unfrozen absent traceable like-for-like current sources.

**25E0 — Validation, commissioning, and proof testing** is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated. `research/25E0_COVERAGE_AUDIT_AND_LEARNER_ROUTE_2026-09-23.md` records the line-by-line syllabus audit and canonical learner route. `evaluation/25E0_EXTERNAL_EVALUATOR_HANDOFF_2026-09-23.md` is the no-solution information-separated competency handoff. Existing canonical artifacts cover SRS-derived validation, restart/power-restoration tests, stopping-time measurement/revalidation, latent-failure proof testing, configuration/version control, exceptional-mode restoration and ordinary-controller authority boundaries. Machine-specific thresholds and intervals remain UNKNOWN absent evidence.

**25F0 — Machine safety capstones** is the active branch. `research/25F0_MACHINE_SAFETY_CAPSTONE_CONTRACT_2026-09-23.md` defines the cross-machine capstone package and preserves machine-specific differences. The first baseline capstone is mill/VMC; press-brake depth follows after the transferable template is proven, without inventing hydraulic truth tables, stopping distances, pressure thresholds or integrity targets.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **MORE COMPONENTS != MORE SAFETY**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **GUARD CLOSED != DANGEROUS STATE ENDED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, **UNCHANGED SAFETY PROGRAM != UNCHANGED VALIDATED SAFETY FUNCTION**, **STOPPING TIME ON COMMISSIONING DAY != STOPPING TIME PROVED FOR ALL FUTURE MACHINE STATES**, **STATUS BIT TIMING != PHYSICAL CESSATION TIMING**, **RETURN TO NORMAL SOFTWARE STATE != PRODUCTION SAFEGUARDS PHYSICALLY RESTORED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25E0 information-separated competency gates; do not contaminate them.
2. Continue 25F0 with the mill/VMC capstone hazard/energy boundary and SRS skeleton.
3. Ground guard-access, spindle/motion cessation and stored-energy propositions in authoritative manufacturer/standards evidence.
4. Explicitly allocate ordinary LinuxCNC/FPGA control, diagnostics, independent safety-related control and physical final elements.
5. Include production, setup, clearing, cleaning and maintenance defeat incentives in the human-factors pass.
6. Keep stopping limits, proof-test intervals, quantitative integrity claims and machine-specific physical thresholds UNKNOWN until justified evidence exists.
7. Freeze executable compute only if a concrete unresolved implementation question survives authoritative evidence; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-23T2150Z-safety-25F0-mill-capstone-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
