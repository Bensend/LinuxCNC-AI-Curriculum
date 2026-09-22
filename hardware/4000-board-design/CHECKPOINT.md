# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane remains active alongside the safety curriculum. Durable lessons BD01 through BD24 are present. This checkpoint is board-design authority only and does not alter the separate safety-course progress authority.

New this run:

- `BD24_MACHINE_READABLE_CATALOG_DEPENDENCY_GRAPH_IMPLEMENTATION_AND_MIGRATION.md`

BD24 turns the BD23 semantic-dependency model into an incremental live-catalog implementation strategy:

`authority -> stable registry ID/revision -> declared forward dependencies -> generated reverse index -> graph integrity checks -> stale propagation -> recorded revalidation -> release gate`

The migration is intentionally fictional/generic. No OpenPressBrake interface IDs or machine facts were invented merely to demonstrate graph mechanics.

## BD24 hard student-material audit

Every repository file named to students by BD24 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD23_INTERFACE_CONTRACT_SCHEMA_STABLE_IDS_AND_CHANGE_IMPACT_INVALIDATION.md`
- Curriculum `hardware/4000-board-design/BD22_BOUNDARY_COMPATIBILITY_MATRICES_AND_MACHINE_READABLE_INTERFACE_MATCHING.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `SOURCE_POLICY.md`
- OpenPressBrake `hardware/blocks/BLOCK_DEVELOPMENT_TEMPLATE.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake repository-wide dependency-graph implementation remains intentionally unmigrated. Current governance establishes strong block/integration/adapter boundaries but does not yet provide a common namespace registry, stable semantic revisions across artifacts, forward dependency declarations, generated reverse `SHOW WHERE USED`, alias/supersession policy, or automatic stale propagation.

The newly created BD24 lesson was re-opened from current main after commit and checked for internal consistency.

Readiness remains claim-scoped. No artifact in this lesson establishes production readiness of the complete OpenPressBrake controller.

## Rules frozen by BD24

- `REGISTRY != DUPLICATED ELECTRICAL AUTHORITY`.
- forward dependency edges are authoritative; reverse indexes are generated.
- duplicate semantic IDs are hard errors; do not select an authority by filename, timestamp, or Git recency.
- deleting an authority with consumers does not make those dependencies disappear.
- aliases are identity migrations only; changed semantics require explicit revision/supersession and consumer revalidation.
- `REPLACEMENT AVAILABLE != CONSUMER REVALIDATED`.
- `BIDIRECTIONAL PHYSICS != CYCLIC AUTHORITY`.
- `UNCHANGED FILENAME != UNCHANGED SEMANTICS` and `CHANGED PATH != CHANGED SEMANTICS`.
- schema representation revision is separate from engineering semantic revision.
- legacy absent fields migrate to `UNKNOWN`, never plausible defaults; `VERIFY_AT_MACHINE` is never resolved by migration.
- graph coverage must be declared honestly during incremental adoption.
- `GRAPH-CLEAN != ELECTRICALLY VERIFIED`.
- `DEPENDENCY TRACEABILITY != SAFETY AUTHORITY`.

## Catalog stress-test result

BD24 shows that the missing OpenPressBrake dependency layer can be introduced without a flag-day rewrite:

1. registry-only inventory of existing authorities;
2. dependency declarations for new/changed work;
3. migration of high-fan-out reusable authorities;
4. generated reverse indexes and stale reports;
5. release-gate enforcement only after graph coverage is sufficient.

This preserves the existing rule that reusable blocks own their generic electrical engineering while board integration owns instance/pin/connector/placement mapping. It also prevents migration tooling from inventing missing lifecycle, threshold, machine, or safety facts merely to achieve coverage.

No OpenPressBrake engineering file was changed. The repository was consumed read-only because active board/infrastructure work is continuing and an ad hoc schema retrofit would overlap that authority.

## Current repository reconciliation

At the start of this run, curriculum main had later safety-lane commits after the prior BD23 checkpoint; those changes were preserved.

BD24 was committed as `49263a7b1135c35f16ba87e1f0c65cf959d49af6` and re-opened from current main.

Immediately before this checkpoint write, curriculum main was re-read at `49263a7b1135c35f16ba87e1f0c65cf959d49af6`; no overlapping post-BD24 board-design change was present.

Immediately before this checkpoint write, OpenPressBrake main was re-read at `ce4821d3dc57282854600509f5fe5767871b1d08` (`infrastructure: run ChatGPT Linux staging on panel`). OpenPressBrake remained read-only.

## Next exact work

Build BD25 on **dependency-aware qualification evidence and release-state composition**.

The lesson should connect semantic dependencies to actual evidence propositions without treating an evidence file as universally valid. Teach evidence scope/envelope, evidence-to-claim bindings, qualification proposition IDs, current/stale/expired/superseded evidence, machine versus reusable evidence, and how a complete board release claim composes block qualification, board-integration verification, PCB/thermal/current-path evidence, FPGA image/timing evidence, LinuxCNC/HAL mapping evidence, and unresolved machine facts.

Adversarially test evidence that still exists but no longer proves the current semantic revision; evidence valid for nominal operation but not a widened envelope; board-specific bench evidence incorrectly promoted into a reusable block; a reusable qualification result that remains valid after a J-number-only change; and a safety-status interface whose electrical evidence must not be misrepresented as personnel-safety validation.

## Compute

No simulation, synthesis, place-and-route, benchmark or executable engineering verification was justified for BD24. The work is graph/schema/migration methodology. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD24 improves dependency integrity and change impact. It does not establish PL/SIL/category, diagnostic coverage, safety integrity, or independent personnel-safety authority. Ordinary LinuxCNC/FPGA dependencies may reference safety-system status interfaces while remaining outside the independent safety decision path.
