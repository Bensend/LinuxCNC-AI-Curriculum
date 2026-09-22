# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane remains active alongside the safety curriculum. Durable lessons BD01 through BD25 are present. This checkpoint is board-design authority only and does not alter the separate safety-course progress authority.

New this run:

- `BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md`

BD25 joins bounded qualification evidence with BD24's semantic dependency graph:

`semantic claim/revision -> evidence scope/envelope -> evidence lifecycle state -> dependency composition -> release gate -> causal blocked-state report`

The worked release graph is deliberately fictional/generic. No OpenPressBrake machine fact or qualification state was invented.

## BD25 hard student-material audit

Every repository file named to students by BD25 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD08_QUALIFICATION_EVIDENCE_VERIFICATION_MATRIX_AND_REGRESSION_TRIGGERS.md`
- Curriculum `hardware/4000-board-design/BD24_MACHINE_READABLE_CATALOG_DEPENDENCY_GRAPH_IMPLEMENTATION_AND_MIGRATION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake does not yet provide a repository-wide machine-readable evidence-to-semantic-claim binding layer or composed release-state evaluator. Existing status governance has the correct human-level principles, but legacy evidence must not be retroactively assigned scope/revision metadata it never recorded.

The newly created BD25 lesson was re-opened from current main after commit and checked for internal consistency.

Readiness remains claim-scoped. No artifact in this lesson establishes production readiness of the complete OpenPressBrake controller.

## Rules frozen by BD25

- `EVIDENCE FILE EXISTS != CURRENT CLAIM PROVED`.
- evidence result (`PASS/FAIL/PARTIAL`) and evidence lifecycle (`CURRENT/STALE/EXPIRED/SUPERSEDED/INVALID`) are separate axes.
- evidence must bind to exact semantic claim/revision/facets and an explicit applicability envelope.
- widening a claimed envelope does not widen old evidence.
- board bench evidence does not automatically become reusable-block qualification.
- reusable-block qualification does not prove a board instance, PCB, machine installation, or HAL mapping.
- complete-board release is a composed dependency claim, not a count of green artifacts.
- unresolved required `UNKNOWN`/`VERIFY_AT_MACHINE` facts propagate to a blocked release state.
- a board-only J-number/designator change does not automatically stale unchanged reusable electrical qualification.
- electrical verification of a safety-status interface does not validate the independent personnel-safety function.

## Catalog stress-test result

BD25 identifies the next catalog layer after semantic dependency tracking:

1. evidence records bound to exact claim IDs/revisions/facets;
2. explicit evidence scope/envelope/exclusions;
3. evidence lifecycle state independent of PASS/FAIL;
4. reusable-versus-board-versus-machine evidence ownership;
5. composed release propositions with fail-closed unresolved-dependency propagation;
6. shortest causal blocked-release reporting.

Current OpenPressBrake status rules already distinguish integration readiness from full qualification, require concrete evidence, prohibit `CI green` from becoming blanket qualification, and require status maintenance after material changes. Adapter/integration governance already prevents ordinary board or safety-status interface evidence from silently acquiring broader authority. BD25 builds on those rules rather than replacing them.

No OpenPressBrake engineering file was changed. Active block work continued during this curriculum run, so the repository was consumed read-only.

## Current repository reconciliation

At the start of this run, curriculum main had later safety-lane commits after the BD24 checkpoint. Those changes were preserved.

BD25 was committed as `8a4e13d723a3b78ded4a4abac9e9d66bca9a5a16` and re-opened from current main.

Immediately before this checkpoint write, curriculum main was re-read at `8a4e13d723a3b78ded4a4abac9e9d66bca9a5a16`; no overlapping post-BD25 board-design change was present.

Immediately before this checkpoint write, OpenPressBrake main was re-read at `ad315b8232f4e1fc8a4428e98f4585f98f646c06` (`relay driver: bound single-pulse inductive demag energy`). OpenPressBrake remained read-only.

## Next exact work

Build BD26 on **full-board qualification planning and evidence closure**.

Derive a release-oriented verification campaign from the dependency/evidence graph rather than from a generic checklist. Order checks by risk, information value, prerequisites, and destructive potential. Separate pre-power inspection, resistance/short checks, current-limited staged power, rail/default-state verification, partial-power/back-power challenges, interface-by-interface bench tests, PCB current/thermal evidence, FPGA image/timing evidence, LinuxCNC/HAL semantic mapping, fault/watchdog challenges, machine verification, and final residual-open-claim review.

Adversarially test a board that commissions successfully while one reusable-block qualification claim remains stale, a machine that works while a `VERIFY_AT_MACHINE` cable/load fact is still unrecorded, a passing FPGA image with stale pin/resource evidence, and a normal-control safety-status monitor that must remain outside personnel-safety release authority.

## Compute

No simulation, synthesis, place-and-route, benchmark, or executable engineering verification was justified for BD25. The work is evidence semantics and release-state composition. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD25 improves evidence traceability and release composition. It does not establish PL/SIL/category, diagnostic coverage, safety integrity, or independent personnel-safety authority. Ordinary LinuxCNC/FPGA evidence may prove an electrical status interface while remaining outside the independent safety decision path.