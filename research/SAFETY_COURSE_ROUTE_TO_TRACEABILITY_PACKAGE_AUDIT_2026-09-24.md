# Safety-course learner-route -> cumulative traceability-package audit — 2026-09-24

Session start UTC: 2026-09-24T05:34:10Z

## Purpose

Audit the canonical 2520–25F0 learner sequence against `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` so a learner cannot silently restart the design at a module boundary, discard upstream assumptions/UNKNOWNs, or continue crediting evidence after a material upstream change.

This audit does not alter any information-separated evaluator answer or self-score an open competency gate.

## Cross-course continuity rule

The Safety Design Package is one cumulative engineering artifact. Every module must:

1. **consume** the current upstream IDs and their provenance/status;
2. **create/refine** only the ID families appropriate to its work;
3. declare downstream dependencies explicitly rather than copying facts into unlinked prose;
4. preserve `UNKNOWN`, `RETIRED`, `STALE`, residual-risk and operational-restriction state;
5. run the stale-dependency check before crediting prior verification/validation evidence;
6. never treat an ordinary LinuxCNC/HAL/FPGA status indication as proof of a physical proposition unless that indication itself is the proposition being tested.

A module is not complete merely because its local worksheet is complete if its new claims cannot be traced back through the cumulative package.

## Route map

| Course | Must consume/check on entry | Primarily creates/refines | Must validate/check before handoff |
|---|---|---|---|
| 2520 | machine facts, source provenance, lifecycle assumptions | `BND`, `ENE`, `HAZ`, `UNK` | every hazardous event links to boundary/task/mode and relevant energy; unresolved machine facts remain `UNK` |
| 2530 | `BND`, `ENE`, `HAZ`, `UNK` | `SF`, early `PHY`, `RR` | safety functions trace to hazards; risk-reduction choice does not erase residual risk or unknown physical data |
| 2540 | `SF`, `PHY`, energy paths, restart assumptions | `SF`, `PHY`, early `SRS` reset/E-stop constraints | stopping/requested state is not silently substituted for physical cessation/isolation; reset is not start authorization |
| 2550 | energy register plus relevant `SF/PHY` | isolation/stored-energy `PHY`, `SRS`, `UNK`, `RR` | electrical/fluid/mechanical isolation, discharge and restraint propositions remain distinct where physics differ |
| 2560 | motion/drive hazards and physical propositions | drive/motion `SF`, `PHY`, `SRS`, dependencies | STO/drive state is not credited as standstill or electrical isolation without the corresponding proposition/evidence |
| 2570 | input-device hazards, `SF/PHY/SRS` | input-channel requirements, `DEP`, diagnostic assumptions | dual-channel sensing does not imply redundant final elements; shared dependencies remain visible |
| 2580 | output/final-element safety functions and dependencies | `AUTH`, `DEP`, final-element `PHY/SRS` | relay/output-off indication does not replace proof of the final hazardous-energy proposition |
| 2590 | access hazards, stopping behavior, lifecycle tasks | guard/access `SF/PHY/SRS`, defeat-related `HF/DEP` | guard closed/interlocked/locked, field clear, occupancy and end-of-dangerous-state remain separate propositions |
| 25A0 | complete upstream hazards/functions/propositions/unknowns | formal `PHY`, `SRS`, acceptance criteria, black-channel/lifecycle constraints | every SRS traces to hazard/function and states an acceptance proposition; quantitative values without evidence stay `UNKNOWN` |
| 25B0 | current `SRS/PHY` and upstream assumptions | `AUTH`, `ARC`, `DEP`, fault paths, `VAL` candidates | fault detection is not credited as safe-state achievement; CCF/shared-resource paths are linked to affected SRS/architecture |
| 25C0 | architecture, fault paths, task/lifecycle model | `HF`, `DEP`, `SRS/ARC` refinements, `VAL` candidates | foreseeable defeat is treated as design input; any safeguard/architecture change triggers dependency review rather than silently retaining old validation |
| 25D0 | `SRS`, failure paths, CCF, human-factor findings | `ARC` alternatives/cost decisions, `HF/DEP` refinements | low-cost choice still addresses named failure paths; component count/cost does not substitute for architecture evidence |
| 25E0 | `SRS`, `PHY`, `ARC`, `DEP`, `HF`, current stale state | `VAL`, `PT`, `CHG`, commissioning evidence | each credited physical validation has an appropriate physical witness; changed upstream items mark affected evidence `STALE`; proof-test intervals without basis remain `UNKNOWN` |
| 25F0 | complete current package | machine-transfer deltas across all ID families, `RR/UNK/CHG` | transferred claims are distinguished from machine-specific facts; novel-machine assumptions do not inherit unsupported truth tables, limits or validation results |

## Canonical-route audit findings

### 2590

`research/2590_ENTRY_MAP_AND_RELEASE_GATE_2026-09-23.md` already teaches proposition-first safeguard selection, explicit non-propositions, complete sensor->logic->final-element->end-of-danger trace, defeat paths, reset/start separation and maintenance isolation. The gap is not technical content; it is persistence. The route must be interpreted as operating on the current package IDs, not as a fresh standalone exercise.

### 25B0

`research/25B0_COVERAGE_AUDIT_AND_LEARNER_ROUTE_2026-09-23.md` correctly requires the physical proposition, dependency/CCF path, diagnostic evidence, latent-fault consequence, restart rule and UNKNOWNs. Those items map directly to `PHY`, `DEP`, `VAL`, `SRS` and `UNK`. The route must preserve the originating SRS/hazard IDs and mark affected validation evidence stale if fault analysis causes architecture or requirement changes.

### 25C0

`research/25C0_COVERAGE_AUDIT_AND_LEARNER_ROUTE_2026-09-23.md` correctly requires human-factor review across production/setup/recovery/maintenance and preserves unknown physical parameters. Its continuity obligation is explicit here: a human-factors redesign that changes a guard, reset location, operating mode, architecture, timing assumption or final-element path is a `CHG` event and requires downstream stale-dependency review.

### Remaining canonical routes

The current sequence-level package map is technically compatible with the existing module progression and no contradictory authority allocation was found in the prior whole-sequence audit. The important repair is therefore a **global route invariant**, not duplicating package instructions into every historical learner-route document. Historical routes remain provenance artifacts; `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` plus this audit govern continuity across them.

## Stale-evidence adversarial checks

The following are release-blocking mistakes for the cumulative package:

- a changed hazard boundary leaves old SRS/validation rows marked current without dependency review;
- a new energy source is added but no affected safety function/physical proposition is reviewed;
- a guard or reset redesign leaves old stopping/occupancy validation credited automatically;
- a final-element architecture changes but old proof-test or fault-injection evidence remains `PASS` without applicability review;
- a machine transfer copies stopping time, pressure threshold, safe speed, valve truth table, integrity target or proof-test interval from another machine without authoritative applicability evidence;
- a controller/HMI/FPGA status bit replaces a required physical witness;
- an `UNKNOWN` disappears because a later module did not copy it forward.

## Repair decision

No broad rewrite of historical learner routes is justified. The durable repair is to make cumulative-package continuity a governing rule in the package itself and in the next-work/release audit. This avoids document drift while preserving old artifacts for provenance.

## Evaluator-handoff boundary

Evaluators may receive the learner's submitted Safety Design Package and learner-visible source/evidence context. Evaluators must not expose hidden expected architectures, scoring keys, preferred fault trees, machine-specific hidden answers or sealed benchmark resolutions before learner commitment. The evaluator should score traceability quality, dependency/stale handling, physical-evidence discipline, uncertainty handling and authority separation in addition to the module-specific competency.

## Release implication

The safety-course sequence is internally ready for a top-level release/readiness audit **only after** the package template is amended to state the global route invariant and evaluator-package boundary. Open fresh/external competency gates remain open; this audit is not graduation evidence.

No executable question was created by this audit. No simulation/build/test compute is justified.