# 25B0 — Syllabus coverage audit and learner route

## Coverage audit

Compared against `SAFETY_COURSE_RESEARCH.md` 25B0 requirements.

| Required topic/output | Durable coverage | Status |
|---|---|---|
| FMEA/FMEDA concepts | `25B0_FAILURE_ANALYSIS_ENTRY_2026-09-23.md`; quantitative boundary note | covered |
| fault trees | entry artifact guarded-motion tree and proposition-first method | covered |
| single-fault thinking | entry + injection matrix | covered |
| latent faults | injection matrix + quantitative/proof-test note | covered |
| common-cause faults | injection matrix dependency example + quantitative beta/CCF boundary | covered |
| diagnostic coverage in practical terms | quantitative boundary note; test-count/DC distinction | covered |
| power-supply failure | injection matrix | covered |
| broken wires and shorts | injection matrix | covered |
| welded contacts | injection matrix + proof-test note | covered |
| stuck valves | injection matrix | covered |
| sensor disagreement/frozen sensor | injection matrix | covered |
| frozen software | injection matrix watchdog case | covered |
| network loss | injection matrix | covered |
| corrupted configuration | injection matrix | covered |
| bench/simulated fault-injection matrix | machine-neutral matrix exists; executable bench/simulation intentionally not frozen because no unresolved implementation question currently requires it | covered at curriculum-design level; runtime evidence not claimed |
| verify expected safe-state transitions / surprises | test hierarchy requires physical proposition and observation; actual machine-specific transition remains application validation work | covered methodologically; machine result UNKNOWN until tested |

No material learner-facing syllabus hole was found. The absence of a synthetic executable campaign is deliberate: the current unresolved questions concern missing application evidence, and simulation would not establish machine physics or quantitative failure data.

## Canonical learner route

1. Read `research/25B0_FAILURE_ANALYSIS_ENTRY_2026-09-23.md` to learn proposition-first FMEA/FMEDA/fault-tree roles and injection selection.
2. Read `research/25B0_FAULT_INJECTION_MATRIX_2026-09-23.md` and work each layer from fault -> predicted diagnostic/reaction -> physical observation -> limitation.
3. Read `research/25B0_QUANTITATIVE_BOUNDARIES_AND_PROOF_TESTS_2026-09-23.md` to learn when arithmetic is justified, why injection-count percentages are not DCavg, and how latent faults relate to automatic diagnostics and proof tests.
4. Rework the adversarial cases without looking for hidden expected answers. For each, state the physical safe-state proposition, dependency/CCF path, diagnostic evidence, latent-fault consequence, restart rule, and UNKNOWNs.
5. Use `evaluation/25B0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` only as an evaluator contract. A fresh evaluator must construct a novel scenario and withhold its expected solution until learner commitment.

## Release gate

25B0 is **READY FOR EXTERNAL/FRESH EVALUATION**, not self-graduated.

A passing evaluation must demonstrate transfer to a novel topology and preserve these boundaries:

- **FAULT INJECTION COUNT != DIAGNOSTIC COVERAGE**;
- **PERCENT OF TEST CASES DETECTED != DCavg**;
- **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**;
- **FIRST FAULT TOLERATED != FIRST FAULT SAFELY DIAGNOSED**;
- **TWO SINGLE-CHANNEL TESTS PASS != COMMON-CAUSE PATH TESTED**;
- **ROUTINE MAINTENANCE != PROOF TEST UNLESS IT DETECTS THE ASSUMED LATENT FAILURES**;
- **QUALITATIVE FAULT ANALYSIS CAN JUSTIFY REDESIGN WITHOUT JUSTIFYING A PL/SIL CLAIM**.

Application-specific failure rates, DCavg, CCF/beta values, proof-test intervals/effectiveness, stopping times, pressure thresholds and PL/SIL remain UNKNOWN unless supplied by authoritative design evidence.

## Next branch

With 25B0 internally coherent and externally gated, rotate immediately to **25C0 — Designing for humans who will defeat safeguards**. Start from bypass incentives, nuisance trips, diagnostics, maintenance access, reset placement, visibility, setup/recovery modes, and procedure-only fragility. The goal is an actionable human-factors review method that makes the safer path easier than defeat.
