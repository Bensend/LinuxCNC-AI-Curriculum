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

**25A0 — Safety PLCs and programmable safety** is READY FOR EXTERNAL/FRESH EVALUATION. `research/25A0_LIFECYCLE_CHANGE_CONTROL_AND_RELEASE_GATE_2026-09-23.md` closes lifecycle/change-control, configuration/signature/replacement/revalidation and evidence-separation coverage. `evaluation/25A0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` is the no-solution fresh-evaluation contract. It is not self-graduated.

**25B0 — Failure analysis and fault injection** is the active branch. `research/25B0_FAILURE_ANALYSIS_ENTRY_2026-09-23.md` defines the SRS-to-fault-to-evidence chain, FMEA/FMEDA/fault-tree roles and question-driven injection rule. `research/25B0_FAULT_INJECTION_MATRIX_2026-09-23.md` now spans power, wiring, sensor, logic, configuration, communication, output, final-element and physical-state faults; demonstrates latent-fault and CCF failures missed by naive single-fault testing; defines the source/static/low-energy/isolated/remote-machine test hierarchy; and supplies adversarial frozen-feedback, welded-contactor, stuck-valve, corrupted-parameter and network-timeout cases. No executable lab is justified yet.

25B0 freezes include **FAULT INJECTION COUNT != DIAGNOSTIC COVERAGE**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **SINGLE-FAULT TEST PASS != COMMON-CAUSE RESILIENCE PROVED**, **SOFTWARE-INJECTED FAULT != PHYSICAL FAILURE EQUIVALENCE PROVED**, **FIRST FAULT TOLERATED != FIRST FAULT SAFELY DIAGNOSED**, and **TWO SINGLE-CHANNEL TESTS PASS != COMMON-CAUSE PATH TESTED**.

Core earlier freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **CATEGORY / ARCHITECTURE != ACHIEVED PL OR SIL**, **CERTIFIED COMPONENT CAPABILITY != COMPLETE SAFETY-FUNCTION INTEGRITY**, **DIAGNOSTIC COVERAGE CLAIM != PHYSICAL SAFE-STATE PROOF**, **DEVICE RELEASED != SAFETY FUNCTION RESET/REARMED != MACHINE START AUTHORIZED**, and **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25A0 information-separated competency gates; do not contaminate them with learner-readable hidden solutions.
2. Turn the 25B0 adversarial cases into an information-separated competency exercise.
3. Strengthen quantitative boundaries: when FMEDA/diagnostic-coverage arithmetic is justified versus when absent source data requires qualitative fault analysis.
4. Add proof-test/latent-fault interval reasoning without inventing application intervals or failure rates.
5. Audit 25B0 syllabus coverage and fill only genuine learner-facing gaps.
6. Freeze executable compute only if a concrete unresolved implementation question survives authoritative source/engineering analysis; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-23T1448Z-safety-25B0-failure-analysis-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.