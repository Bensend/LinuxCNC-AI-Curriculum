# Final-element witness contract reconciliation and hydraulic contradiction case — 2026-09-25

Status: learner-facing source/design audit. No machine design, certification, or runtime evidence.

## Question

Does the reusable SO implementation template force the eight-field final-element witness contract from `FINAL_ELEMENT_WITNESS_MATRIX_2026-09-24.md` to survive schematic qualification, commissioning and Safety Design Package handoff?

## Result

The prior SO template contained all eight concepts, but scattered them across traceability, class evidence, authority, CCF, maintenance and validation sections. That made omission during handoff plausible. The template is revised to require one auditable record carrying:

1. commanded safety action;
2. physical final element;
3. exact feedback target;
4. legitimate feedback proposition and non-claims;
5. shared dependencies/CCFs;
6. residual hazardous-energy paths;
7. required machine-level physical witness;
8. maintenance-isolation/blocking boundary.

The selected-block qualification worksheet already carries these concepts across Sections B, E, F, G, J and L; no duplicate field system is required.

## Safety Design Package mapping

- commanded action -> `SRS-*`, `AUTH-*`
- final element -> `AUTH-*`, `ARC-*`
- feedback target/proposition -> `PHY-*`, `SRS-*`, `VAL-*`
- shared dependencies -> `DEP-*`, `ARC-*`, `VAL-*`
- residual energy -> `PHY-*`, `SRS-*`, `ARC-*`, plus `ENE-*`/residual-risk/UNKNOWN where applicable
- physical witness -> `PHY-*`, `VAL-*`
- maintenance isolation/blocking -> `SRS-*`, `AUTH-*`, `ARC-*`, `VAL-*`

A material edit to any of these is a change-control input: create/review `CHG-*`, mark affected evidence `STALE`, and revalidate only the affected dependency chain.

## Hydraulic evidence boundary

**DOC-CONFIRMED:** Fiessler AKAS-F with AKFH/AKFR reads hydraulic-valve position transmitters, transfers linked information to AKAS-F, checks valve operation, and blocks valve release on protective-field interruption, guard opening, E-stop, valve-switching error or subsystem error.

**DOC-CONFIRMED:** Bosch Rexroth's published press-brake system solution separates servo-motor/four-quadrant-pump normal motion from a safety block containing end-position-monitored on/off valves.

These sources support monitored valve/final-element architectures and the separation of normal-motion and safety-final-element authority. They do **not** establish a generic press-brake hydraulic truth table, pressure threshold, trapped-volume behavior, stopping distance, valve fail state, proof-test interval, diagnostic coverage or machine-level integrity target. Those remain `UNKNOWN` until selected-machine evidence exists.

## Adversarial commissioning / proof-test mini-case

Precondition: a selected machine's `PHY-*` requires a physical safe-state proposition beyond valve position. The selected valve-position channel reports its expected state after a safety demand, but the independent physical witness required by that `PHY-*` contradicts the safe-state claim.

Required disposition:

- Credit valve feedback only for the narrow valve-state proposition its sensing relationship supports.
- Set the broader machine `PHY-*` to **NOT ESTABLISHED**.
- Do not infer rearm/release eligibility from safety-controller or valve status.
- Keep the discrepancy open in the associated `VAL-*`; inspect `DEP-*` for shared/reference/pilot/mechanical causes and create/retain `UNK-*` for unresolved physical cause.
- If architecture, requirement, witness or dependency changes, create `CHG-*` and mark dependent validation/proof evidence `STALE`.
- If the missing proposition is required for basic safe operation, experimental diagnosis must be isolated/remote with people outside the danger zone until the physical proposition is established.

This is intentionally proposition-based. It does not invent pressure or motion thresholds.

## New freeze

**FINAL-ELEMENT STATUS EXPECTED + CONTRADICTORY PHYSICAL WITNESS != MACHINE SAFE STATE PROVED.**

The physical proposition required by the SRS wins over a controller-status narrative.

## Lab decision

No lab frozen. The present uncertainty is not an executable interface question; authoritative documentation and engineering traceability answer it. A bounded self-hosted lab is justified only if a concrete selected-interface behavior remains unresolved after product documentation.
