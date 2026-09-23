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

2520 through 25B0 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them.

**2540 — Relays, contactors, and the real meaning of a “safety relay”** remains READY FOR EXTERNAL/FRESH EVALUATION with its existing learner route and no-solution handoff.

**2550 — ISO 13849 without the mystique** remains READY FOR EXTERNAL/FRESH EVALUATION with explicit Category B/1/2/3/4 fault-behavior teaching, canonical learner route and no-solution handoff.

**2560 — IEC 62061 / SIL concepts for machine builders** remains READY FOR EXTERNAL/FRESH EVALUATION with its dual-method PL/SIL comparison, adversarial assessment, learner route and no-solution handoff.

**2570 — Drives, STO, braking, and hazardous motion** remains READY FOR EXTERNAL/FRESH EVALUATION with its drive-function physical-proposition map, ordinary-drive fallback, adversarial assessment, learner route and no-solution handoff.

**2580 — Hydraulic and pneumatic safety** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. It is not self-graduated.

**2590 — Guards, interlocks, presence sensing, and two-hand controls** remains READY FOR EXTERNAL/FRESH EVALUATION with its completed syllabus audit, canonical learner route and no-solution handoff. Application-specific stopping behavior, safety distance and integrity targets remain UNKNOWN until evidence exists.

**25A0 — Safety PLCs and programmable safety** remains READY FOR EXTERNAL/FRESH EVALUATION with lifecycle/change-control coverage, canonical learner route and no-solution handoff. It is not self-graduated.

**25B0 — Failure analysis and fault injection** is now READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated. `research/25B0_QUANTITATIVE_BOUNDARIES_AND_PROOF_TESTS_2026-09-23.md` closes the quantitative/DC/proof-test boundary: percentage of hand-selected injections is not DCavg; quantitative reliability arithmetic requires defensible failure, operating-cycle, diagnostic, proof-test and CCF inputs; missing inputs remain UNKNOWN rather than guessed. `research/25B0_COVERAGE_AUDIT_AND_LEARNER_ROUTE_2026-09-23.md` found no material syllabus gap and defines the canonical route. `evaluation/25B0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` is the no-solution evaluator contract. No executable lab is justified by the current questions.

**25C0 — Designing for humans who will defeat safeguards** is the active branch. `research/25C0_HUMAN_FACTORS_ENTRY_2026-09-23.md` defines a defeat-pressure model, human-factors review table and anti-defeat design sequence grounded in ISO 14119-oriented manufacturer guidance. It freezes the distinction between defeat resistance and low defeat incentive and treats nuisance trips, visibility, diagnostics, setup/recovery, reset placement and easy guard restoration as engineering inputs.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **PERCENT OF TEST CASES DETECTED != DIAGNOSTIC COVERAGE**, **ROUTINE MAINTENANCE != PROOF TEST UNLESS IT DETECTS THE ASSUMED LATENT FAILURES**, **HIGH-CODING INTERLOCK != LOW DEFEAT INCENTIVE**, **DIFFICULT TO BYPASS != CONVENIENT TO USE CORRECTLY**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25B0 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Continue 25C0 by turning the entry model into the required machine-playbook human-factors review checklist.
3. Add adversarial cases for nuisance-trip pressure, blind reset, maintenance guard removal, setup-mode abuse, poor diagnostics and production pressure.
4. Trace authoritative evidence for reset visibility, unexpected restart prevention, setup/recovery modes and foreseeable defeat; distinguish standard/manufacturer guidance from inference.
5. Audit 25C0 against `SAFETY_COURSE_RESEARCH.md`; fill only genuine learner-facing gaps.
6. Freeze executable compute only if a concrete unresolved implementation question survives authoritative source/engineering analysis; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-23T1551Z-safety-25C0-human-factors-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
