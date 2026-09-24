# Safety course — top-level release/readiness audit — 2026-09-24

## Decision

**INTERNALLY RELEASE-READY FOR INFORMATION-SEPARATED EVALUATION; NOT GRADUATED.**

The 2520–25F0 sequence has a coherent cumulative engineering path and a canonical cross-course Safety Design Package. Open external/fresh competency gates remain authoritative and must not be self-scored or bypassed.

## Integration checks

| Check | Result |
|---|---|
| machine/lifecycle boundary precedes architecture choice | PASS |
| hazardous energy/events remain traceable into safety functions | PASS |
| physical propositions are separated from controller/status propositions | PASS |
| SRS requirements trace upstream and carry acceptance criteria/UNKNOWNs | PASS |
| normal LinuxCNC/HAL/FPGA control is separated from independent personnel-safety authority | PASS |
| final elements/physical energy mechanisms remain explicit | PASS |
| fault, latent-fault and CCF/dependency reasoning survives into validation | PASS |
| human factors/foreseeable defeat can trigger architecture/change review | PASS |
| low-cost architecture does not relax named safety requirements | PASS |
| verification is distinguished from machine validation | PASS |
| commissioning/proof-test/change-control preserve stale evidence rules | PASS |
| machine transfer retains machine-specific UNKNOWNs rather than copying quantitative truth | PASS |
| unmet basic safe-to-operate propositions create operational restriction | PASS |
| external/fresh evaluation gates remain open and information-separated | PASS / OPEN GATE |

## Evaluator-handoff leakage audit

Sampled `evaluation/25B0_INFORMATION_SEPARATED_COMPETENCY_HANDOFF.md` against its canonical learner route and the cumulative package contract.

The handoff specifies scenario-construction constraints, required competency outputs, critical-failure categories and scoring dimensions. It does **not** provide a concrete machine instance with its hidden expected fault tree/architecture or a sealed benchmark resolution. It explicitly requires a novel scenario and withholds the intended failure tree/scoring key until learner commitment.

This is acceptable **only if the evaluator contract remains evaluator-only during the blind attempt**. A learner that reads the evaluator contract before commitment has gained prompt-shape information and the attempt must not be represented as fully information-separated. The course should therefore distinguish:

- learner-visible curriculum + Safety Design Package;
- evaluator-only scenario construction/scoring contract;
- learner submission/commitment;
- post-commit reveal/scoring/correction.

No hidden expected solution should be copied into learner-facing route documents merely to make evaluation easier.

## Release package requirements

A fresh evaluator should receive:

1. the learner's current Safety Design Package;
2. learner-visible curriculum/source/evidence artifacts appropriate to the course;
3. the evaluator-only handoff for the course being tested;
4. no pre-revealed expected architecture, hidden machine answer, scoring key or sealed resolution.

The evaluator should score both module competency and package discipline: traceability, stale-dependency handling, physical-witness selection, uncertainty/residual-risk handling, change/revalidation behavior and authority separation.

## Graduation boundary

Internal completeness, document quality and self-consistency are not graduation evidence. Courses with outstanding fresh/external gates remain READY FOR EXTERNAL/FRESH EVALUATION. A material external miss must produce a minimal curriculum correction and novel transfer retest before the affected competency is treated as securely transferable.

## Highest-value work while gates are pending

Do not idle or contaminate the gates. Continue safety-related 4000 work that improves reusable implementation competence without assuming a passing evaluator result. Highest-value branch: translate the independent-safety boundary into reusable hardware/interface contracts for safety inputs, core safety controller, safety outputs/final-element interfaces, and the FPGA-to-safety interface, while preserving that ordinary FPGA/LinuxCNC control has no personnel-safety authority by convenience.

That work should consume the cumulative Safety Design Package concepts (`SRS`, `PHY`, `AUTH`, `DEP`, `ARC`, `VAL`) and should not invent machine-specific PL/SIL targets, hydraulic truth tables, stopping limits, diagnostic coverage or proof-test intervals.

## Compute decision

No executable implementation question is required to establish this release decision. No simulation/build/test compute is justified by this audit.