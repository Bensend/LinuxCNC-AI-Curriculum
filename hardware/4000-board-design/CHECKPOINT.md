# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane remains active alongside the safety curriculum. Durable lessons BD01 through BD23 are present. This checkpoint is board-design authority only and does not alter the separate safety-course progress authority.

New this run:

- `BD23_INTERFACE_CONTRACT_SCHEMA_STABLE_IDS_AND_CHANGE_IMPACT_INVALIDATION.md`

BD23 teaches the maintenance chain:

`stable semantic ID -> exact semantic revision -> declared forward dependency -> SHOW WHERE USED reverse lookup -> upstream semantic change -> STALE_PENDING_REVALIDATION -> scoped/transitive revalidation -> CURRENT`

The central adversarial requirement is that downstream engineering claims depend on exact semantic propositions rather than copied prose, familiar filenames, net-name searches, or designer memory.

## BD23 hard student-material audit

Every repository file named to students by BD23 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD22_BOUNDARY_COMPATIBILITY_MATRICES_AND_MACHINE_READABLE_INTERFACE_MATCHING.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `SOURCE_POLICY.md`
- OpenPressBrake `hardware/blocks/BLOCK_DEVELOPMENT_TEMPLATE.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake repository-wide dependency tracking — current governance has strong block identity/interface/ownership/status rules but does not yet define a common stable requirement/interface/assumption namespace, forward dependency declarations, reverse `SHOW WHERE USED`, or automatic stale propagation.

The newly created BD23 lesson was re-opened from current main after commit and checked for internal consistency.

Readiness remains claim-scoped. No artifact in this lesson establishes production readiness of the complete OpenPressBrake controller.

## Rules frozen by BD23

- `FILE PATH != SEMANTIC ID`.
- `TEXT CHANGE != ALWAYS SEMANTIC CHANGE`.
- `SEMANTIC CHANGE != PERMITTED WITHOUT REVISION`.
- `COPIED VALUE != DEPENDENCY`.
- upstream semantic change causes automatic loss of `CURRENT` status until revalidation; it does not automatically prove failure.
- invalidation should be facet/dependency scoped where possible and transitively propagated where required.
- `VERIFY_AT_MACHINE` assumptions are first-class dependencies, not prose escape hatches.
- board-specific connection IDs may depend on reusable interface IDs without leaking J-numbers, placement, harness destination, or machine naming into reusable contracts.
- `TRACEABLE != SAFETY-RATED`.

## Catalog stress-test result

BD23 exposed a durable catalog layer that is still missing from current OpenPressBrake governance:

1. stable semantic IDs/revisions for reusable requirements, interfaces, assumptions, resources and important evidence claims;
2. explicit downstream `depends_on` edges with optional facet scope;
3. generated reverse lookup supporting `SHOW WHERE USED`;
4. automatic `STALE_PENDING_REVALIDATION` propagation when an upstream semantic revision changes;
5. recorded revalidation evidence before stale claims regain `CURRENT` status.

The existing OpenPressBrake block-development template already requires block identity, semantic interface contracts, shared-resource declarations, provenance/deltas, calculations and verification. Status rules already require same-change maintenance when material engineering changes. Adapter/integration governance already treats reusable contracts as immutable inputs during composition and fails closed on unresolved boundaries. The new dependency layer should build on those authorities rather than replace them.

No OpenPressBrake engineering file was changed. Current OpenPressBrake main is actively changing FPGA configuration-bias/reference governance and related board-development authority, so this run recorded the catalog defect/action item in curriculum rather than racing active engineering with an ad hoc schema migration.

## Current repository reconciliation

At the start of this run, curriculum main had later safety-lane commits after the prior BD22 checkpoint; those changes were preserved.

BD23 was committed as `94f38c486b88df4cc71a7541125231e36dad23c5` and re-opened from current main.

Immediately before this checkpoint write, curriculum main was re-read at `94f38c486b88df4cc71a7541125231e36dad23c5`; no overlapping post-BD23 board-design change was present.

Immediately before this checkpoint write, OpenPressBrake main was re-read at `891b0bc8cb8b1953085deb1370bdb85643e16c5a` (`governance: correct encoder reference source`). OpenPressBrake remained read-only.

## Next exact work

Build BD24 on **machine-readable catalog dependency graph implementation and migration strategy** without prematurely modifying active OpenPressBrake blocks.

The lesson should define how a real catalog can introduce stable IDs incrementally: registry/namespace ownership, uniqueness checks, forward-reference validation, reverse-index generation, semantic-revision rules, stale-state propagation, cycle handling, supersession/aliases, schema-version migration, and CI checks that do not confuse Git/file churn with semantic change. Include a worked migration of a small fictional/generic block set so students can exercise the mechanism without inventing OpenPressBrake facts.

Adversarially test deleted IDs, duplicate IDs, alias chains, dependency cycles, stale consumers, a semantic change hidden inside an unchanged filename, a file move with unchanged semantics, and a board-only connection change that must not invalidate reusable electrical qualification. Keep the safety boundary explicit.

## Compute

No simulation, synthesis, place-and-route, benchmark or executable verification was justified for BD23. The work is schema semantics, provenance, dependency modeling, and release-state invalidation. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD23 improves traceability and change control. It does not establish PL/SIL/category, diagnostic coverage, safety integrity, or independent personnel-safety authority. Ordinary LinuxCNC/FPGA dependencies may reference safety-system status interfaces while remaining outside the independent safety decision path.
