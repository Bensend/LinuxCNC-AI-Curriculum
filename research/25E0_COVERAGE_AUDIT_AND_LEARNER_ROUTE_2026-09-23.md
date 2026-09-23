# 25E0 — coverage audit, learner route, and release gate

Session start UTC: 2026-09-23T21:38:00Z

## Syllabus audit

Audited against `SAFETY_COURSE_RESEARCH.md` 25E0 requirements.

| Required competency | Durable coverage | Result |
|---|---|---|
| validation versus “it seems to work” | `25E0_VALIDATION_COMMISSIONING_ENTRY_2026-09-23.md` separates verification, validation and commissioning and requires physical propositions | COVERED |
| test plans derived from safety requirements | canonical SRS trace chain plus `25E0_SRS_VALIDATION_MATRIX_AND_ADVERSARIAL_COMMISSIONING_2026-09-23.md` | COVERED |
| restart tests | reset/rearm row includes guard closure, field clearing, E-stop release and power restoration | COVERED |
| fault injection | entry requires justified fault tests and the adversarial matrix demonstrates status-vs-physical failures | COVERED, with hazardous physical injection bounded by safe-test escalation |
| stopping-time measurement | physical measurement and lifecycle remeasurement rules; device/status timing explicitly rejected as substitute | COVERED |
| periodic proof tests | latent-failure-first proof-test reasoning and UNKNOWN interval rule | COVERED |
| inspection intervals | interval selection is tied to architecture, manufacturer assumptions, usage/environment and change history; no invented calendar period | COVERED |
| configuration/version control | commissioning evidence bundle and revalidation-trigger model preserve machine/configuration identity and baseline | COVERED |
| changes that invalidate assumptions | explicit sensor/wiring/logic/firmware/final-element/mechanical/guard/load/mode/environment revalidation triggers | COVERED |
| capstone-ready evidence package | entry requires SRS identity, architecture-relevant identities/configuration, inspections, tests, physical evidence, acceptance criteria, deviations, release decision and baseline | COVERED |

No genuine learner-facing syllabus gap remains. The audit therefore does not manufacture additional prose or a lab.

## Existing exceptional-mode evidence

The canonical 25E0 artifacts already preserve the specialist exceptional-mode/muting/override reasoning as a commissioning challenge: eligibility, altered safeguard, alternate protection, bounded persistence, fault/exit behavior, power-cycle behavior and physical restoration of production safeguards. Repository code search did not expose a separately named current file containing `MUTING`; therefore this route links the exact current canonical artifact that contains the durable exceptional-mode treatment rather than inventing a filename:

- `research/25E0_SRS_VALIDATION_MATRIX_AND_ADVERSARIAL_COMMISSIONING_2026-09-23.md` — section `Exceptional-mode / muting / override reconciliation`.

If an older historical artifact is later recovered, it may be added as provenance, but its absence does not leave a competency gap in the current learner route.

## Canonical learner route

Read in this order:

1. `SAFETY_COURSE_RESEARCH.md` — 25E0 syllabus contract.
2. `research/25E0_VALIDATION_COMMISSIONING_ENTRY_2026-09-23.md` — verification/validation/commissioning distinctions, evidence bundle, proof-test and change-control boundaries.
3. `research/25E0_SRS_VALIDATION_MATRIX_AND_ADVERSARIAL_COMMISSIONING_2026-09-23.md` — requirement-to-physical-proof matrix, adversarial commissioning, stopping-time lifecycle and exceptional-mode reconciliation.
4. Revisit prerequisite boundaries from 25B0–25D0 where a proposed test depends on diagnostic coverage, latent faults, human defeat incentives or low-cost architecture assumptions.
5. Perform the external information-separated competency exercise below without exposing a solution key to the learner.

## Required learner capabilities

A fresh learner must be able to:

- derive validation tests from an SRS rather than from a generic checklist;
- state the physical proposition each test establishes and what its evidence cannot establish;
- distinguish command/status/EDM evidence from actual hazardous-motion, energy, pressure, restraint and access evidence;
- design reset/restart and power-restoration tests;
- identify when stopping behavior must be physically measured or remeasured;
- design a proof test around a named latent dangerous failure without inventing its interval;
- define configuration/version/change records sufficient to decide revalidation scope;
- validate exceptional modes as bounded alternate-protection states rather than Boolean bypasses;
- keep LinuxCNC and ordinary FPGA/controller diagnostics outside sole personnel-safety authority;
- refuse to invent machine-specific thresholds, PL/SIL, stopping margins or proof-test intervals.

## Release gate

25E0 is **READY FOR EXTERNAL/FRESH EVALUATION**. It is not self-graduated.

External evaluation must remain information-separated. A pass should require mechanism-level reasoning, not vocabulary matching. A central miss involving physical proof, restart behavior, revalidation, or ordinary-controller authority blocks promotion until corrected and retested.

## Durable freezes

- **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION.**
- **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED.**
- **DEVICE RESPONSE TIME != COMPLETE MACHINE STOPPING TIME.**
- **STATUS BIT TIMING != PHYSICAL CESSATION TIMING.**
- **UNCHANGED SAFETY PROGRAM != UNCHANGED VALIDATED SAFETY FUNCTION.**
- **ROUTINE MAINTENANCE != PROOF TEST UNLESS IT EXPOSES THE ASSUMED LATENT FAILURE.**
- **RETURN TO NORMAL SOFTWARE STATE != PRODUCTION SAFEGUARDS PHYSICALLY RESTORED.**
- **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY.**

## Next branch

Preserve this external gate without contamination and rotate to 25F0 machine-safety capstones. Begin with a cross-machine capstone contract before deep press-brake work: require hazard/energy boundary, SRS, architecture/authority allocation, fault analysis, validation plan, human-factors review, maintenance/change-control and residual-risk statement for each machine class. Then select the highest-value first capstone while preserving machine-specific UNKNOWNs.
