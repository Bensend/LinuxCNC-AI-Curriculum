# 2540 — Learner route and release gate

## Canonical route

2540 is about understanding what makes a relay-based safety architecture defensible, not memorizing product families.

Read in this order:

1. `2540_SAFETY_RELAY_MEANING_SOURCE_PREP_2026-09-23.md` — ordinary relay vs force-guided relay vs safety relay module vs complete machine safety function.
2. `2540_FIVE_FAMILY_SAFETY_RELAY_COMPARISON_AND_PHYSICS_BRIDGE_2026-09-23.md` — commercial evidence, ratings, switching physics, B10d/use profile, and bounded diagnostics.
3. `2540_MACHINE_FINAL_ELEMENTS_CONTACTOR_STO_FLUID_POWER_2026-09-23.md` — trace command through witness and final element to hazardous-energy and physical safe-state propositions.
4. `2540_ADVERSARIAL_ASSESSMENT_RELAY_TO_SAFE_STATE_2026-09-23.md` — attack the reasoning under welded contacts, wrong switching duty, suppression drift, STO, trapped fluid energy, common final elements and replacement drift.
5. Reuse the 2520 verification/validation methodology for any real design. 2540 does not replace machine-level validation.

## Competency target

A learner is ready for information-separated evaluation when it can:

- distinguish ordinary, force-guided and safety-relay-module capabilities without marketing inference;
- explain the diagnostic value and limits of force-guided/mirror contacts;
- distinguish carry current from actual switching suitability;
- explain why B10d, PFHd, Category/PL/SIL capability and response time remain conditional/application-bounded evidence;
- map each diagnostic witness to the exact proposition it observes;
- trace `command -> witness -> final element -> hazardous energy -> physical safe state` without skipping layers;
- identify common final elements and common-cause dependencies;
- analyze STO and fluid-power final elements without pretending their status proves standstill, restraint, isolation or pressure removal;
- recognize maintenance/replacement drift as a change-control and revalidation event;
- keep ordinary LinuxCNC/FPGA monitoring/control outside independent personnel-safety authority unless specifically evidenced otherwise.

## Release gate

Learner-facing methodology status: **READY FOR EXTERNAL/FRESH EVALUATION**.

This is not self-graduation. Formal competency evidence requires an information-separated evaluator challenge whose hidden scenario/expected analysis is not exposed to the learner before precommitment.

Critical failures for that evaluation include:

- assigning PL/SIL/PFH or physical timing from absent data;
- treating a safety-relay module's rating as the complete machine rating;
- treating EDM/mirror feedback as proof of machine standstill or total energy removal;
- treating STO as electrical isolation or gravity-load restraint;
- treating valve-position feedback as downstream safe pressure;
- ignoring a common final element while claiming redundant physical interruption;
- accepting a lookalike replacement without impact analysis;
- granting ordinary LinuxCNC/HAL/FPGA logic independent personnel-safety authority without evidence.

## Duplication audit

No additional general relay lesson is justified now. The current artifacts have distinct ownership:

- terminology/component boundary;
- commercial evidence and switching/reliability physics;
- machine final-element/physical-proposition boundary;
- adversarial competency surface.

Future 2540 additions should answer a newly identified evidence gap, not restate these boundaries.

## Next curriculum branch

With the external gate preserved as branch-local, proceed to **2550 — ISO 13849 without the mystique**. Begin from authoritative method evidence and the existing 2520 integrity-method gate. Do not turn example calculations into certification claims or invent application-specific PLr, MTTFd, DC, CCF, mission/use, or B10d values.
