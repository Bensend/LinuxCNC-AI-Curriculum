# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD35 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD35_SERVICE_PARTS_APPROVED_ALTERNATES_OBSOLESCENCE_AND_LIFECYCLE_MIGRATION.md`

BD35 teaches:

`lifecycle event -> consumed semantic facets -> alternate/equivalence evidence -> affected blocks/releases/installed assets -> new-build vs service-only policy -> qualification/regression -> service-parts baseline -> obsolescence migration -> field applicability`

## BD35 hard student-material audit

Every repository file named to students by BD35 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD34_FIELD_RETURN_REPAIR_RETROFIT_AND_AS_MAINTAINED_CONFIGURATION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/motor_drive_interface/manifest.yaml`
- OpenPressBrake `hardware/blocks/motor_drive_interface/production_bom_rev1.yaml`
- OpenPressBrake `hardware/blocks/motor_drive_interface/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/motor_drive_interface/REV1_3V3_POWER_HANDOFF.md`

The newly created BD35 lesson was re-opened from current main after commit and checked against the inspected sources.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `motor_drive_interface` remains `SIMULATION-READY`, not Rev 1 released;
- abnormal fault qualification, schematic visual review, selected connector/cable integration, board integration, simultaneous-axis thermal/SI evidence and human signoff remain open;
- OpenPressBrake has no repository-wide immutable approved-alternate/lifecycle/applicability record joined to exact engineering and installed/as-maintained identity;
- current engineering evidence does not establish any actual AM26LV31E obsolescence, approved alternate, last-time-buy, service stock, released production population or field retrofit.

No inspected file is used to claim complete OpenPressBrake production/lifecycle readiness.

## Rules frozen by BD35

- part availability change does not itself change an electrical contract;
- same package and headline ratings do not establish an approved alternate;
- alternate approval is bound to exact identity, semantic facets and an explicit applicability envelope;
- an alternate qualified for one consumer/envelope is not automatically universal;
- new-build and service-only policies are separate;
- last-time-buy is a controlled engineering/configuration decision, not an automatic redesign or unrestricted substitution;
- obsolescence does not permit reusable-block/adapter/integration boundaries to be broken;
- later alternate approval does not rewrite historical releases;
- dependency (`SHOW WHERE USED`) and installed/as-maintained (`SHOW WHAT IS INSTALLED`) graphs must both be used for lifecycle applicability;
- evidence inheritance follows changed semantic facets rather than purchasing convenience;
- FPGA/toolchain migration is part of controller configuration and must preserve or deliberately revise resource/timing/watchdog/HAL semantics;
- ordinary safety-status interface migration is not personnel-safety revalidation.

## Current OpenPressBrake worked-example result

The current `motor_drive_interface` freezes exact TI `AM26LV31EIDR` and `TPD4E05U06DQAR` identities, two differential command pairs per reusable primitive, two primitives per quad driver package, and board-owned physical connector selection. Its current status remains `SIMULATION-READY` with explicit release gates still open.

The current 3V3 power handoff uses the AM26LV31E output-drive capability only as a conservative board source-capacity allocation and explicitly does not treat that allocation as normal operating current or package dissipation. Actual receiver/cable/termination and simultaneous-axis thermal evidence remain integration/configuration responsibilities.

A hypothetical future lifecycle event therefore cannot be closed by choosing another package-compatible “RS-422” part. The consumed logic, drive/load, timing, enable/default, package/pinout, thermal and protection facets must be compared and changed facets propagated to dependent power/timing/SI/thermal/qualification evidence.

No actual OpenPressBrake component obsolescence or approved alternate is asserted. OpenPressBrake remained read-only.

## Current repository reconciliation

At run start, current curriculum main was `fbe1e8b1c2de667453da2902b80b527788b05543`; concurrent safety-lane work did not overlap the board-design lesson path. OpenPressBrake current main was `4e70ac8a05642c888b910da3c42a93e8b45c0a05` (`motor drive: publish AM26LV31E 3V3 power handoff`). The current motor-drive files were consumed read-only because active engineering had just changed that block.

BD35 was committed as `d5c0e170a7bb043f56ad4e8dd2f74d6f3ff9a78b` and re-opened from current main. Current main was re-read immediately before this checkpoint update; no post-BD35 overlapping board-design change was present.

## Catalog stress-test result

BD35 exposes a concrete lifecycle infrastructure need: future tooling should represent an immutable approved-alternate/lifecycle record joining exact original/alternate identities, manufacturer/source provenance, consumed semantic IDs/facets, equivalence/delta evidence, qualification envelope/exclusions, block/adapter/board/release applicability, new-build versus service-only policy, controlled last-time-buy/service-stock identity, stale/preserved evidence, installed/as-maintained applicability, migration history, lifecycle state and effective dates.

Procurement status should not be dumped into reusable block manifests as a substitute for this layer. Reusable blocks own exact engineering identities and generic requirements; lifecycle policy and population applicability need separate traceability.

This infrastructure need remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing alternates, service stocks, releases or installed assets.

## Next exact work

Build BD36 on **lifecycle migration planning across multiple board variants and installed populations**.

Teach:

`replacement strategy -> compatibility matrix -> coexistence window -> manufacturing cut-in -> service transition -> FPGA/software/HAL compatibility -> migration evidence -> field rollout -> rollback/containment -> legacy retirement`

The adversarial lab should include mixed old/new boards sharing software, staged manufacturing cut-in, spare-board compatibility, rollback after a field finding, unknown legacy identity, and a case where forcing one reusable block contract to cover incompatible generations would corrupt the architecture.

Require students to preserve exact configuration identity across coexistence, define forward/backward compatibility explicitly, keep rollback as a real supported configuration, use as-maintained field identity rather than family-name inference, and retire legacy support only with evidence that affected production/service/installed populations are actually closed or intentionally unsupported.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD35. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD35 teaches lifecycle/alternate management for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, or independent personnel-safety authority. A lifecycle migration of an ordinary safety-status receiver proves only the bounded ordinary electrical/status claims actually verified.