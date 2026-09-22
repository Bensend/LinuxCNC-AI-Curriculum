# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD37 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD37_MIGRATION_EXECUTION_EVIDENCE_AND_FLEET_CONVERGENCE.md`

BD37 teaches:

`planned population -> serialized work package -> pre-change identity capture -> controlled change -> verification -> as-maintained update -> exception/rollback handling -> convergence accounting -> residual legacy/unknown population -> closure decision`

## BD37 hard student-material audit

Every repository file named to students by BD37 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD36_MULTI_VARIANT_LIFECYCLE_MIGRATION_AND_COEXISTENCE.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/relay_contactor_driver/manifest.yaml`
- OpenPressBrake `hardware/blocks/relay_contactor_driver/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/relay_contactor_driver/REV1_LOGIC_3V3_POWER_HANDOFF.md`

The newly created BD37 lesson was re-opened from current main after commit and checked against the inspected sources.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `relay_contactor_driver` remains `SIMULATION-READY`, not Rev 1 released;
- released current/repetition/simultaneity, final connector/current path, PCB/layout, branch coordination, abnormal-condition, repeated-cycle thermal, board-integration and human-release gates remain open;
- OpenPressBrake has no repository-wide serialized migration ledger joined to exact as-maintained assets and the BD36 compatibility graph;
- current engineering evidence does not establish a real released OpenPressBrake migration population, serial fleet, rollout, rollback or fleet-convergence state.

No inspected file is used to claim complete OpenPressBrake production/migration readiness.

## Rules frozen by BD37

- work-order closure does not prove configuration convergence;
- expected old configuration is not a substitute for observed pre-change identity;
- installing a new PCB does not prove the configuration-complete target is installed;
- FPGA/HAL programming success does not prove the correct hardware profile;
- functional pass does not prove exact configuration identity;
- failed and partial migration attempts remain immutable evidence after retry/recovery;
- rollback is another controlled migration and produces its own as-maintained identity;
- service restoration does not count as target migration when the unit was rolled back;
- fleet metrics derive from per-unit evidence, not technician activity counts;
- unreachable/unknown population remains visible rather than disappearing from the denominator;
- no open work orders does not prove no residual legacy/unknown population;
- recurring migration inconvenience does not justify contaminating reusable block contracts;
- real reusable transformations belong in adapters; connector/pin/profile mapping remains board/configuration integration when the generic electrical contract is unchanged;
- ordinary fleet convergence does not revalidate independent personnel-safety functions.

## Current OpenPressBrake worked-example result

The current `relay_contactor_driver` remains a one-coil reusable primitive. Its manifest deliberately leaves board-owned released current, simultaneous-instance assumptions, connector/contact selection, PCB geometry and branch protection unresolved. Its current 3V3 handoff publishes a conservative 4.2 mA maximum `LOGIC_3V3` source-capacity allocation plus 100 nF local bypass per populated primitive while explicitly distinguishing that sizing bound from expected operating current and from any released coil/channel rating.

That is a useful migration boundary: a future board generation can change instance count, connector mapping, branch protection or FPGA-to-instance mapping without rewriting the reusable primitive. A serialized migration work package would instead bind the exact board/configuration target and aggregate the reusable resource contract for the actual population.

Undocumented machine coil/load/harness/suppression facts remain `VERIFY_AT_MACHINE`; they cannot be invented to improve a convergence dashboard. No actual OpenPressBrake fleet or field migration is asserted. OpenPressBrake remained read-only.

## Current repository reconciliation

At run start, curriculum main was `b82632145af4e2460707fbae57486c5e9ed73e8a`, containing separate safety-lane work after BD36 but no overlapping board-design change. OpenPressBrake main was `7f3ddff3c71028ed4982e4024e1b10753047c72e` (`relay driver: publish conservative 3V3 logic handoff`), so the newly active relay-driver engineering was consumed read-only.

BD37 was committed as `6aac7ef652f4e00f975c0f2fed39fc9f75e5e697` and re-opened from current main. Immediately before this checkpoint write, curriculum main was re-read and contained BD37 with no overlapping post-BD37 board-design change; OpenPressBrake main was also re-read and remained `7f3ddff3c71028ed4982e4024e1b10753047c72e`.

## Catalog stress-test result

BD37 exposes a concrete execution-infrastructure need: future tooling should provide a serialized migration ledger joined to the BD36 compatibility graph. It should bind asset identity, applicability provenance, pre-change as-maintained configuration, target release/board/BOM/options, block/adapter/connection revisions, FPGA/toolchain/image/resource map, LinuxCNC/HAL/machine configuration, work-package revision, `VERIFY_AT_MACHINE` observations, actual actions/intermediate state, verification evidence, failure/exception/rollback history, final as-maintained identity, convergence classification and residual support/retirement state.

Fleet dashboards should be derived from this ledger, not maintained as an independent optimistic spreadsheet. Serialized fleet history belongs in configuration/service records, not reusable block manifests.

This infrastructure need remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing serial assets or field migrations.

## Next exact work

Build BD38 on **fleet-closure audit, residual support states, and evidence-backed legacy retirement**.

Teach:

`migration ledger -> reconciliation audit -> unresolved identity/finding closure -> support-state classification -> spare/tool/software retention -> evidence archive -> retirement authorization -> future SHOW WHAT IS INSTALLED / field-action discoverability`

Stress units administratively retired but still physically installed, lost serial traceability, unsupported legacy boards that remain operational, service stock with obsolete FPGA/HAL tooling, archived evidence that can no longer reproduce a programmed image, and the difference between ending migration work and retiring support obligations.

Require students to distinguish target convergence from support retirement; preserve historical configuration and negative evidence; prove reproducibility or explicitly bound its loss; keep unsupported-but-installed assets discoverable; retain enough tooling/images/configuration identity for any support state still claimed; and refuse fleet-retirement claims while unknown installed populations remain unresolved.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD37. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD37 teaches migration execution and configuration convergence for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, or independent personnel-safety authority. A fleet of ordinary controllers reaching the intended target profile proves only the bounded ordinary-controller claims actually verified.