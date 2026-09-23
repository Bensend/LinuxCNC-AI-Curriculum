# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD47 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD47_AUTHORITY_STATE_PROPAGATION_SUPERSESSION_SAFE_DISCOVERY_AND_CONFIGURATION_CONSUMPTION.md`.

BD47 teaches:

`current/superseded/deprecated artifacts -> machine-readable authority state -> search/discovery -> consumer eligibility -> stale-consumer detection -> board generation/resource budgeting -> audit -> safe historical retention`

## BD47 hard student-material audit

Every repository file named to students as finished material by BD47 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD46_CORRECTIVE_ACTION_EFFECTIVENESS_LEADING_INDICATORS_AND_PREVENTION_EVIDENCE.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/motor_drive_interface/manifest.yaml` for the current reusable electrical/resource contract and declared configuration-owned facts
- OpenPressBrake `hardware/blocks/motor_drive_interface/STATUS_CHECKLIST.md` for current `SIMULATION-READY` status and remaining qualification/release gates
- OpenPressBrake `hardware/blocks/motor_drive_interface/REV1_BOARD_INTEGRATION_HANDOFF.md` for current Rev 1 package packing, resource allocation, integration invariants, selected-drive configuration gates, and `VERIFY_AT_MACHINE` facts

The motor-drive block remains `SIMULATION-READY`, not production-proven, safety-rated, or `REV 1 READY`. The newly created BD47 lesson was re-opened from current main after commit and checked against these inspected sources.

## Rules frozen by BD47

- found by search does not mean authorized to consume;
- newest file does not establish current engineering authority;
- missing authority state must not default to `CURRENT`;
- authority is scoped to artifact role, revision/configuration/population, and new-build/service applicability;
- historical restore authority does not reactivate an artifact for new builds;
- supersession should name a successor and changed semantic facets so `SHOW WHERE USED` can identify affected consumers;
- parsable artifacts are not automatically eligible inputs to board generation or resource budgeting;
- derived BOM/resource/schematic/FPGA/HAL outputs inherit authority dependencies from their inputs;
- regenerated output is not current when generated from stale authority;
- historical artifacts should remain discoverable for provenance while current configuration selection filters them by authority and scope;
- current reusable-block authority does not establish complete board or machine-configuration authority;
- unresolved machine/configuration facts remain `VERIFY_AT_MACHINE`/blocked rather than being invented to satisfy compatibility;
- current ordinary-controller authority does not confer independent personnel-safety authority;
- required executable reconciliation uses only `[self-hosted, openpressbrake]`; unavailable authorized compute remains `BLOCKED/NOT_RUN`.

## Worked-example stress test

Current OpenPressBrake `motor_drive_interface` provides a bounded real multi-layer authority example. Its reusable manifest owns the generic two-differential-pair primitive and exactly two 3V3 FPGA command GPIOs per instance while leaving physical connector selection to board integration. The current Rev 1 handoff separately owns package packing (`ceil(instances / 2)` AM26LV31E packages), per-primitive ESD allocation, package-local decoupling, conservative 3V3 capacity allocation, and fail-closed board integration invariants.

Selected-drive timing, polarity, scaling, and manufacturer-declared cable/termination requirements remain configuration-owned. Installed drive identity, legacy connector/wire mapping, cable facts, undocumented cabinet changes, and similar physical facts remain `VERIFY_AT_MACHINE` where not established. BD47 uses this separation to show why a single global `current` bit cannot represent block, board, configuration, and installed-machine authority.

The status checklist still leaves abnormal fault qualification, physical connector/cable integration, board-level selected-drive checks, schematic visual review, price refresh, and human Rev 1 signoff open. The handoff is therefore bounded integration authority, not proof of full release.

## Catalog stress-test result

BD47 exposes a missing machine-readable **authority-state and consumption-eligibility layer** above individual reusable block manifests. It should join stable artifact/semantic IDs, authority state, scope, successor/predecessor relationships, exact release identity, new-build/service eligibility, reverse dependencies, derived-resource records, stale-consumer state, historical-release pins, unresolved machine facts, and evidence provenance.

This belongs above the reusable catalog because generic block authority, board composition authority, selected machine configuration, and installed-machine facts have different owners. Proposed infrastructure remains `ENGINEERING_REVIEW_NEEDED`.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD46. Curriculum main also contained concurrent safety-course work, which remained intact. OpenPressBrake had advanced to active `motor_drive_interface` Rev 1 integration work.

BD47 was committed as `1c76c11ab906846938e74f001f53509222aa7579` and re-opened from current main. Immediately before this checkpoint write, curriculum main still had BD47 as the newest board-design lesson. OpenPressBrake current main was `91d7dcb52efff9838738ea291e7d21cc771e12dc` (`motor drive: publish Rev1 board integration handoff`). OpenPressBrake was consumed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD48 on **configuration selection closure, ambiguity resolution, and fail-closed board generation**:

`eligible authorities -> exact configuration intent -> compatibility/constraint solving -> ambiguity detection -> explicit selection/VERIFY_AT_MACHINE -> deterministic board/resource output -> provenance lock -> generation audit`

Stress two individually eligible blocks that cannot both satisfy a board resource constraint, multiple eligible connector/adapter choices with no justified preference, a selected-drive configuration with an unresolved physical fact, a deterministic generated board whose provenance must pin every consumed authority, and a safety-related interface where ordinary configuration closure must not imply safety validation.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD47. No GitHub-hosted runner was used.

## Safety boundary

BD47 teaches authority selection and consumption for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. Marking an ordinary safety-status monitor, watchdog, handshake, STO request, or inhibit artifact `CURRENT` proves only current authority for its declared ordinary-controller role unless a separate safety-rated design and validation establishes more.
