# 2580 — Entry map and release gate

## Status

**READY FOR EXTERNAL/FRESH EVALUATION.** This is not self-graduation.

## Coverage audit

The 2580 syllabus requires stored pressure, gravity loads, blocked-center versus dump/decompression concepts, monitored valves, justified redundancy, trapped pressure/accumulators, spool sticking, hose/cylinder failures, maintenance restraint, and press-brake energy/synchronization concerns.

Existing learner-readable artifacts cover the required branch coherently:

1. `2580_HYDRAULIC_PNEUMATIC_SAFETY_SOURCE_PREP_2026-09-23.md`
   - establishes the physical-proposition chain;
   - separates supply shutoff, decompression and load holding;
   - introduces monitored hydraulic components, gravity loads, hose failure and mechanical restraint;
   - preserves press-brake-specific truth tables/thresholds as UNKNOWN.
2. `2580_FLUID_POWER_FAULT_TREE_AND_PNEUMATIC_ANALOGUE_2026-09-23.md`
   - explicitly separates directional blocking, supply isolation, dump/decompression and load holding;
   - covers spool sticking, leakage/drift, accumulators, trapped volumes, hose/fitting and cylinder/seal failure;
   - distinguishes electrical redundancy from hydraulic final-element redundancy;
   - adds pneumatic safe exhaust, trapped downstream volume and controlled repressurization/restart;
   - treats maintenance restraint and human factors as first-class design requirements.
3. `2580_ADVERSARIAL_ASSESSMENT_FLUID_POWER_SAFE_STATE_2026-09-23.md`
   - tests transfer across common-final-element, misleading-pressure, gravity-load, hose-failure, trapped-volume, repressurization, maintenance and replacement-drift scenarios.

No material syllabus gap was found that justifies manufacturing another learner note.

## Canonical learner route

A fresh learner should proceed in this order:

1. Read the source-preparation artifact and be able to state why `electrical stop`, `valve command`, `valve position`, `pressure observation`, and `physical safe state` are different propositions.
2. Read the fault-tree artifact and reconstruct the four distinct fluid-power functions without collapsing them into “hydraulics off.”
3. For a novel circuit, enumerate every credible source of hazardous energy: supply, accumulator, trapped volume, gravity/external load, cross-port/regeneration path, pneumatic reservoir, and mechanical stored energy.
4. For every diagnostic witness, write what it proves and what it does not prove.
5. Decide which risk-reduction propositions require electrical, fluid-power, and/or mechanical measures.
6. Trace reset/rearm, controlled repressurization and normal start as separate lifecycle events.
7. Complete the adversarial assessment without inventing circuit-specific pressure, timing, integrity or load data.

## Competency gate

A learner is ready for independent evaluation only if it can, on a previously unseen fluid-power machine scenario:

- define the physical safe-state proposition before selecting components;
- distinguish directional blocking, source isolation, decompression and load holding;
- find stored-energy and gravity/external-load paths that survive electrical shutdown;
- identify common final elements hidden behind apparently redundant electrical channels;
- bound valve-position and pressure diagnostics to the physical propositions they actually witness;
- reason about hose/cylinder/valve failures without assuming an unspecified circuit response;
- specify maintenance restraint when fluid-power state alone does not safely control the load;
- separate reset, repressurization and motion-start authorization;
- preserve ordinary LinuxCNC/FPGA control as non-safety authority; and
- leave machine-specific thresholds, stopping times, Category/PL/SIL and diagnostic coverage UNKNOWN when evidence is absent.

## Critical-fail conditions

External evaluation should fail the competency if the learner:

- treats pump-off or solenoid-off as proof that hazardous fluid energy is gone;
- treats a monitored valve position as proof of downstream pressure or load state;
- treats one low pressure measurement as proof every hazardous volume is depressurized;
- ignores an accumulator, trapped chamber, gravity load or credible hose/cylinder failure;
- counts electrical channels as independent hydraulic final elements without dependency analysis;
- allows exposed maintenance based only on an ordinary functional stop where positive restraint is required;
- transfers a component PL/SIL claim to the complete machine function; or
- grants ordinary LinuxCNC/HAL/FPGA logic sole personnel-safety authority.

## Release decision

2580 has adequate learner-facing coverage for a fresh, information-separated competency test. Preserve the assessment/handoff boundary and do not self-score. The next curriculum branch is **2590 — Guards, interlocks, presence sensing, and two-hand controls**.
