# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD38 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD38_FLEET_CLOSURE_RESIDUAL_SUPPORT_AND_LEGACY_RETIREMENT.md`

BD38 teaches:

`migration ledger -> reconciliation audit -> unresolved identity/finding closure -> support-state classification -> spare/tool/software retention -> evidence archive -> retirement authorization -> future SHOW WHAT IS INSTALLED / field-action discoverability`

## BD38 hard student-material audit

Every repository file named to students by BD38 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD37_MIGRATION_EXECUTION_EVIDENCE_AND_FLEET_CONVERGENCE.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/dry_contact_relay_output/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/dry_contact_relay_output/CAD_CAPTURE_HANDOFF_REV1.md`

The newly created BD38 lesson was re-opened from current main after commit and checked against the inspected sources.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `dry_contact_relay_output` remains `NOT READY`, not Rev 1 released;
- installed KiCad library verification, rendered schematic/ERC, actual PCB current geometry, first-machine mapping, creepage/clearance, board-level source/thermal qualification and human release remain open;
- OpenPressBrake has no repository-wide support/retirement registry joined to exact as-maintained assets, retained programming/toolchain capability and historical field-action applicability;
- current engineering evidence does not establish a real released OpenPressBrake installed population, service stock, support state, legacy fleet or retirement population.

No inspected file is used to claim complete OpenPressBrake production, fleet, support or retirement readiness.

## Rules frozen by BD38

- migration work ending does not retire legacy support obligations;
- administrative retirement does not prove physical removal;
- unknown configuration does not become retired configuration;
- support states attach to exact configuration identities/envelopes rather than vague generations;
- a support claim requires retained programming/test/configuration capability appropriate to that claim;
- archived binary existence does not by itself prove support capability;
- archived source does not by itself prove release reproducibility;
- a spare on a shelf is not automatically a supported spare;
- retirement from support does not erase engineering/configuration traceability;
- negative evidence remains immutable after retirement;
- no planned service does not prove retirement authorization;
- unsupported-but-installed is a real discoverable state;
- fleet retirement does not rewrite reusable block history;
- ordinary-controller support retirement does not retire or revalidate an independent personnel-safety function.

## Current OpenPressBrake worked-example result

The current `dry_contact_relay_output` has frozen Rev-1 electrical capture input around K1 `G5Q-1 DC24`, Q1 `2N7002BK`, D1 `BAS21GW-Q`, R1 1 kOhm and R2 100 kOhm. Its field COM/NC/NO boundary remains abstract in the reusable primitive; physical connector selection/pin mapping remains board integration. The current CAD handoff explicitly requires installed KiCad library/pin verification and forbids changing manufacturer-backed connectivity merely to fit a candidate CAD asset.

That is a useful lifecycle boundary: a future service/support claim would have to bind the actual board revision, connector mapping, programmed controller configuration, applicable electrical envelope and retained programming/verification capability. Possessing a relay or an unidentified shelf board would not establish a supported spare.

The block remains `NOT READY`, and no actual OpenPressBrake service stock, support state, fleet or retirement action is asserted. OpenPressBrake remained read-only.

## Current repository reconciliation

At run start, curriculum main had concurrent safety-lane work after the BD37 checkpoint but no overlapping board-design lesson change. OpenPressBrake main had advanced to `14005fbe05a998ab2ca49b83057e933871ab1d37` (`dry contact relay: freeze Rev1 CAD capture handoff`), so that active block was consumed read-only.

BD38 was committed as `2576afa80bfdcdf03c11aabad7b23a32037235be` and re-opened from current main. Immediately before this checkpoint write, curriculum main was re-read and contained BD38 with no overlapping post-BD38 board-design change; OpenPressBrake main was also re-read and remained `14005fbe05a998ab2ca49b83057e933871ab1d37`.

## Catalog stress-test result

BD38 exposes a lifecycle infrastructure need above the reusable catalog: future tooling should join the BD36 compatibility graph and BD37 serialized migration ledger to a support/retirement registry binding exact configuration identity/envelope, support state, installed/historical applicability, physical disposition evidence, board/BOM/adapter/connection definitions, FPGA/firmware binary identity and hashes, source/toolchain/reproducibility state, LinuxCNC/HAL configuration, programming/test/fixture capability, service stock/approved alternates, field actions/nonconformances, negative evidence, archive authority and retirement authorization.

This population/lifecycle state belongs outside reusable block manifests. Reusable blocks own generic engineering contracts; support/retirement records own configuration and population history.

This infrastructure need remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing serial assets, service inventory or retirement state.

## Next exact work

Build BD39 on **configuration evidence escrow, disaster recovery, and long-horizon reproducibility**.

Teach:

`released/as-maintained identities -> authoritative artifact inventory -> integrity/hash/signature verification -> redundant archive/escrow -> toolchain/environment capture -> restore drill -> programming/test recovery -> evidence of reproducibility -> loss/degradation disposition`

Stress corrupted archives, missing proprietary tool installers/licenses, hashes without binaries, source without submodules/dependencies, VM/container drift, undocumented programmer hardware, calibration/test fixtures that cannot be recreated, and a disaster-recovery restore that boots but cannot prove the released FPGA/HAL identity.

Require students to distinguish possession from recoverability; preserve exact artifact and environment identity; prove restoration with an actual bounded drill rather than a backup-success log; keep loss/degradation explicit; and refuse support/retirement claims that depend on unrecoverable evidence.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD38. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD38 teaches lifecycle closure and support/retirement evidence for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, or independent personnel-safety authority. Retirement of ordinary controller support proves nothing about retirement, modification or validation of an independent personnel-safety function.