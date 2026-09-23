# 25D0 — Coverage audit and canonical learner route

## Syllabus audit

Compared line-by-line with `SAFETY_COURSE_RESEARCH.md` 25D0 requirements.

| Required topic/output | Durable coverage | Status |
|---|---|---|
| hazards addressed / not addressed | entry comparison contract + A/B/C, VFD/STO, fluid-power and guard comparisons | COVERED |
| assumed loads/environment | contract requires them; machine-specific values remain UNKNOWN until selected architecture | COVERED / BOUNDED |
| single faults detected/not detected | A/B/C fault table; guard table; D/E residual-fault reasoning | COVERED |
| reset behavior | A/B/C reset fault + monitored/manual reset reasoning; guard comparison | COVERED |
| power-loss/restoration behavior | A/B/C table + guard comparison; D/E proposition boundaries | COVERED |
| restart behavior | reset/rearm separated from motion start throughout | COVERED |
| expected failure modes | welded/stuck contacts, cross faults, CCF, drive coast/external forces, stored fluid energy, stuck valves, guard defeat | COVERED |
| approximate parts cost | cost classes used because like-for-like current public transaction pricing was not established | COVERED WITHOUT FALSE PRECISION |
| what next money buys | each comparison maps increment -> named proposition/failure path -> residual uncertainty | COVERED |
| simple NC E-stop / single contactor | Tier A | COVERED |
| dual-channel E-stop / monitored restart | Tier B | COVERED |
| force-guided/EDM architecture | Tier C | COVERED |
| drive STO + external-energy/isolation distinction | D1/D2 comparison | COVERED |
| hydraulic dump/enable architecture | E1/E2/E3 function comparison | COVERED |
| guard-interlock architecture | `25D0_GUARD_INTERLOCK_LOW_COST_COMPARISON_2026-09-23.md` | COVERED |
| educational/reference, not automatically safety-rated | all artifacts | COVERED |

### Audit finding

One genuine learner-facing gap existed at audit start: the syllabus candidate guard-interlock reference architecture was not explicit in 25D0 even though 2590 already taught guard concepts. That gap was closed with the dedicated low-cost guard comparison. No other material syllabus gap remains.

Actual dollar prices remain intentionally unfrozen. Mixed distributor prices or non-like-for-like product classes would create false precision. The learner must use current traceable sources if a future application needs dollar BOM comparison.

## Canonical learner route

A fresh learner should use this order:

1. `research/25D0_LOW_COST_ARCHITECTURES_ENTRY_2026-09-23.md` — learn the comparison contract and the rule that cost is justified by a named dangerous failure path/proposition.
2. `research/25D0_TIER_ABC_FAULT_COMPARISON_2026-09-23.md` — compare single path, dual-channel safety evaluation, redundant final elements and EDM.
3. `research/25D0_VFD_STO_AND_FLUID_POWER_COMPARISON_2026-09-23.md` — transfer the method to drive torque prevention, electrical isolation, stored energy, fluid decompression and load holding.
4. `research/25D0_GUARD_INTERLOCK_LOW_COST_COMPARISON_2026-09-23.md` — transfer it again to ordinary guard permissives, safety-related interlocking and guard locking without conflating guard state with dangerous-state cessation.
5. Apply the method to a novel machine without selecting a tier from price alone. Start from hazard/lifecycle boundary and physical safe-state proposition; preserve missing physical facts as UNKNOWN.

## Competency release gate

A fresh learner is ready for external evaluation when it can:

- compare architectures by `incremental cost -> named dangerous failure path closed -> residual failure paths -> usability/maintenance consequence`;
- explain why de-energize-to-trip is useful but does not make a single path tolerant of every dangerous single fault;
- separate input-channel diagnostics from downstream final-element redundancy;
- explain what EDM witnesses and refuse to treat it as direct proof of zero energy/standstill/pressure;
- distinguish STO from standstill, electrical isolation and stored-energy discharge;
- distinguish fluid supply isolation, decompression and load holding/restraint;
- distinguish guard closed, guard interlocked, guard locked and dangerous-state ended;
- reason about power loss/restoration and keep reset/rearm separate from motion start;
- identify common dependencies/CCF that can collapse nominal redundancy;
- incorporate bypass incentive, diagnostics, maintenance access and recovery usability into the low-cost decision;
- refuse unsupported PL/SIL/DC/stopping-time/pressure claims and preserve machine-specific UNKNOWNs;
- keep ordinary LinuxCNC/FPGA logic outside personnel-safety authority absent independent safety evidence.

## Release decision

25D0 is **READY FOR EXTERNAL/FRESH EVALUATION**, not self-graduated. The evaluation must remain information-separated. This authoring context must not create or inspect hidden expected answers before learner commitment.

No executable question remains that authoritative/static engineering evidence requires simulation to answer. Do not run compute merely to create activity.
