# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD36 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD36_MULTI_VARIANT_LIFECYCLE_MIGRATION_AND_COEXISTENCE.md`

BD36 teaches:

`replacement strategy -> compatibility matrix -> coexistence window -> manufacturing cut-in -> service transition -> FPGA/software/HAL compatibility -> migration evidence -> field rollout -> rollback/containment -> legacy retirement`

## BD36 hard student-material audit

Every repository file named to students by BD36 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD35_SERVICE_PARTS_APPROVED_ALTERNATES_OBSOLESCENCE_AND_LIFECYCLE_MIGRATION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/motor_drive_interface/manifest.yaml`
- OpenPressBrake `hardware/blocks/motor_drive_interface/STATUS_CHECKLIST.md`

The newly created BD36 lesson was re-opened from current main after commit and checked against the inspected sources.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `motor_drive_interface` remains `SIMULATION-READY`, not Rev 1 released;
- selected-drive timing, abnormal fault qualification, schematic visual review, final connector/cable integration, board integration, simultaneous-axis thermal/SI evidence and human signoff remain open;
- OpenPressBrake has no repository-wide versioned compatibility/migration graph joining engineering generations to manufacturing, service and installed/as-maintained populations;
- current engineering evidence does not establish actual released board generations, migration populations, spare compatibility, field rollout or retirement state.

No inspected file is used to claim complete OpenPressBrake production/migration readiness.

## Rules frozen by BD36

- a new generation release does not prove the old population migrated;
- compatibility is directional and must be recorded by semantic facet;
- common software does not imply common hardware semantics;
- manufacturing cut-in and service transition are separate controlled boundaries;
- a mechanically fitting spare is not automatically service-compatible;
- migration convenience is not a reason to widen a reusable block contract;
- board connector/pin generation differences remain board connection/integration facts when the reusable electrical contract is unchanged;
- real reusable transformations belong in qualified adapters;
- FPGA image, resource map, watchdog behavior and LinuxCNC/HAL configuration are first-class configuration identity;
- migration evidence follows changed semantic facets;
- rollback must be a real supported configuration, not merely possession of old hardware;
- unknown legacy identity remains `VERIFY_AT_MACHINE` and fails closed;
- legacy support cannot be retired merely because new manufacturing has stopped using it;
- ordinary controller-generation compatibility does not revalidate an independent personnel-safety function.

## Current OpenPressBrake worked-example result

The current `motor_drive_interface` publishes a generic two-pair differential command primitive using exact `AM26LV31EIDR` and `TPD4E05U06DQAR` identities while deliberately keeping physical connector choice in board integration. Its status remains `SIMULATION-READY` with explicit selected-drive timing, fault, schematic, connector/cable, thermal/SI, integration and human-release gates open.

This provides a bounded migration example: a future board generation that changes only connector or FPGA-to-instance mapping should carry those differences in board connection/integration and configuration records rather than adding old/new generation names to the reusable primitive. A materially different transmitter contract would require a real reusable-block revision or qualified adapter.

No actual OpenPressBrake released generations, installed population, migration, spare policy, rollout or retirement are asserted. OpenPressBrake remained read-only.

## Current repository reconciliation

At run start, current curriculum main had advanced through `1719fdd57f6f1f6436b27a27deff653985690e35` with concurrent safety-lane work that did not overlap the board-design lesson path. OpenPressBrake current main had advanced to `2f2730400d0fbd171a877596f8c5216354502559` (`lvdt input: bound LT6015 5V rail maximum`), with adjacent shared-ADC and analog hardware work active. The motor-drive example was therefore consumed read-only.

BD36 was committed as `16bd40d4d28315444150b81f1545518635869ba3` and re-opened from current main. Current curriculum main was re-read immediately before this checkpoint update and contained BD36 with no overlapping post-BD36 board-design change.

## Catalog stress-test result

BD36 exposes a concrete migration infrastructure need: future tooling should represent a versioned compatibility/migration graph joining old/new release and board identities, reusable block/adapter revisions, connector/harness definitions, FPGA image/toolchain/resource-map identity, LinuxCNC/HAL/machine configuration, directional compatibility by semantic facet, manufacturing cut-in/WIP disposition, service/spare policy, installed/as-maintained applicability, stale/preserved/regression evidence, rollout/rollback states, unknown `VERIFY_AT_MACHINE` populations, and support/retirement state.

Do not encode machine-generation exceptions inside reusable block manifests. Reusable blocks own generic electrical function and contract; coexistence and population migration require a separate traceable configuration layer.

This infrastructure need remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing released generations or installed assets.

## Next exact work

Build BD37 on **migration execution evidence and fleet convergence**.

Teach:

`planned population -> serialized migration work package -> pre-change identity capture -> hardware/configuration change -> verification -> as-maintained update -> exception handling -> fleet convergence metrics -> residual legacy/unknown population -> closure decision`

The adversarial lab should include partial migrations, failed field updates, wrong FPGA/HAL profile detection, rollback records, units unreachable for inspection, and the difference between rollout completion percentage and evidence-backed configuration convergence.

Require students to preserve pre/post identity and negative evidence, fail closed on ambiguous hardware/profile matching, distinguish planned/attempted/successfully-verified migration counts, retain rollback as configuration history, and refuse fleet-closure claims while unknown or unsupported residual populations remain.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD36. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD36 teaches lifecycle migration/coexistence for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, or independent personnel-safety authority. A controller-generation migration preserving an ordinary safety-status interface proves only the bounded ordinary electrical/configuration claims actually verified.