# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD42 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD42_CHANGE_WAVE_PLANNING_REGRESSION_ORDERING_AND_RELEASE_TRAIN_CONTAINMENT.md`.

BD42 teaches:

`multiple upstream changes -> dependency graph -> common affected consumers -> merge/separate change waves -> regression ordering -> candidate lineage -> partial promotion -> incompatible population handling -> rollback points -> release-train closure`

## BD42 hard student-material audit

Every repository file named to students by BD42 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD41_RELEASE_DEPENDENCY_INVALIDATION_SEMANTIC_CHANGE_AND_CONTROLLED_REPROMOTION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `.github/workflows/digital-output-24v-sim.yml`

`ENGINEERING_REVIEW_NEEDED` and deliberately not assigned as finished student material:

- OpenPressBrake `hardware/blocks/digital_output_24v/integration/validate_rev1_board_contract.py`
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md`

The newly created BD42 lesson was re-opened from current main after commit and checked against the inspected sources.

## Catalog defect exposed by teaching

Current OpenPressBrake main `1293c80e8586c097a477ac6c13794da0acc4af48` has an active digital-output Rev1 change wave. The inspected self-hosted workflow now executes `integration/validate_rev1_board_contract.py` on `[self-hosted, openpressbrake]`. The validator checks substantial frozen isolation/BOM/domain rules including L7/L07 ownership, L07-to-L06/logic-ground bridge prohibitions, STISO620/STISO621 population and pin-domain rules, isolation/support BOM identities, `SWITCHED_IO_5V` regulator authority, ordinary X-axis command mapping, retained direct Pilz drive-enable ownership, and PCB-release gates.

The current `digital_output_24v/STATUS_CHECKLIST.md` still leaves unchecked the item saying that validator must be updated to fail on L07/L06 bridge, unswitched `SWITCHED_IO_5V`, wrong regulator divider/pins, or missing isolation topology. This is a concrete wave-closure/status-reconciliation defect. It does not prove every intended structural case has been covered, so the curriculum did not check the box or modify active engineering. The active OpenPressBrake lane must reconcile exact validator coverage, actual self-hosted run evidence, and checklist state.

## Rules frozen by BD42

- same release date does not define a common change wave;
- a common downstream board does not automatically require independent block changes to be qualified together;
- merge waves when causal evidence or atomic compatibility genuinely couples them; separate waves when independent qualification/rollback preserves diagnostic value;
- build the semantic affected-consumer graph before ordering regression;
- order regression from changed generic claims through adapters/shared resources, board composition, structural checks, executable checks, whole-board behavior, HAL mapping, and physical evidence as applicable;
- later integration success does not erase earlier failed claims;
- candidate lineage must identify the exact semantic change set tested;
- a pass on a superset candidate does not prove every subset candidate;
- partial promotion is bounded authority, not release-train closure;
- late fixes invalidate only evidence actually affected, but pre-fix evidence is not presumed current;
- rollback points are exact supported configuration identities, not merely Git commits or old boards;
- new-build convergence does not imply service/installed-population convergence;
- board-only connector changes remain integration when the reusable electrical contract is unchanged;
- ordinary-controller release-train closure does not validate an independent personnel-safety function.

## Catalog stress-test result

BD42 exposes a release-management need above the reusable catalog: a machine-readable change-wave/release-train ledger should bind wave IDs and semantic deltas to dependency-graph snapshots, merge/separate rationale, candidate lineage, ordered regression prerequisites, preserved/stale/failed evidence, block-requalification versus board-repromotion ownership, partial-promotion authority, rollback identities, population applicability, `VERIFY_AT_MACHINE` dependencies, closure authority, and retained negative evidence.

Reusable blocks continue to publish stable generic contracts/evidence. Release infrastructure composes changes without contaminating reusable blocks with board- or fleet-specific authority.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD41. Concurrent curriculum commits were safety/timing work and did not add a post-BD41 board-design lesson. OpenPressBrake had advanced from the prior safety-interface work to active digital-output and analog-input integration work; the exact digital-output area used by BD42 was therefore consumed read-only.

BD42 was committed as `357fe44121644a47998d108e04e5796b7fcaf7f3` and re-opened from current main. Immediately before this checkpoint write, curriculum main still had BD42 as the newest board-design lesson and OpenPressBrake main remained `1293c80e8586c097a477ac6c13794da0acc4af48`.

## Next exact work

Build BD43 on **release-train observability, gate dashboards, and exception authority**:

`change waves -> gate graph -> machine-readable status -> evidence freshness -> blocked/waived/failed states -> exception authority -> expiry/revalidation -> promotion visibility -> audit reconstruction`

Stress a green dashboard built from stale evidence, a waiver with no expiry, a skipped self-hosted FPGA check, a board-only exception incorrectly mutating reusable-block status, and an ordinary safety-status monitor whose exception must not imply safety-function acceptance.

## Compute

No new simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD42. The inspected OpenPressBrake workflow itself correctly targets `[self-hosted, openpressbrake]`. No GitHub-hosted runner was used by this curriculum run.

## Safety boundary

BD42 teaches change-wave/release-train control for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. A release-train pass on ordinary monitors, handshakes, or control outputs proves nothing about validation of the independent safety function.
