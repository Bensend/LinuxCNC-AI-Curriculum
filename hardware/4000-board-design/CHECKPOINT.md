# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD39 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD39_CONFIGURATION_EVIDENCE_ESCROW_DISASTER_RECOVERY_AND_REPRODUCIBILITY.md`.

BD39 teaches:

`released/as-maintained identity -> authoritative artifact inventory -> integrity verification -> redundant archive/escrow -> toolchain/environment capture -> restore drill -> programming/test recovery -> reproducibility evidence -> loss/degradation disposition`

## BD39 hard student-material audit

Every repository file named to students by BD39 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD38_FLEET_CLOSURE_RESIDUAL_SUPPORT_AND_LEGACY_RETIREMENT.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_input_24v/manifest.yaml`
- OpenPressBrake `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md`

The newly created BD39 lesson was re-opened from current main after commit and checked against the inspected sources.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `digital_input_24v` remains `SIMULATION-READY`, not `REV 1 READY`;
- fault/abnormal-condition work, rendered-schematic review, PCB/layout review, complete cost/shared-resource resolution and human Rev-1 signoff remain open;
- OpenPressBrake has no repository-wide configuration-evidence escrow/recovery manifest joined to exact release/as-maintained identities;
- current engineering evidence does not establish a released OpenPressBrake fleet, disaster-recovery archive, reproducible released FPGA/HAL environment, service programmer/fixture inventory or restore-drill history.

No inspected file is used to claim complete OpenPressBrake production, fleet, recovery or long-horizon support readiness.

## Rules frozen by BD39

- file existence does not prove configuration recoverability;
- a hash without the artifact is identity evidence, not recovery;
- an artifact without trusted release binding does not prove release identity;
- multiple copies do not prove failure-independent escrow;
- archived source does not prove the build environment is recoverable;
- a successful build does not by itself prove the released artifact was reproduced;
- backup-job success does not prove a restore drill succeeds;
- a system boot does not prove the released board/FPGA/HAL configuration is restored;
- programmer, fixture and calibration capability are part of recoverability when the support claim depends on them;
- loss of required recovery capability must change or explicitly narrow the support claim;
- reusable engineering evidence remains separate from board/configuration escrow but must be joinable;
- ordinary-controller recovery does not validate an independent personnel-safety function.

## Current OpenPressBrake worked-example result

The current `digital_input_24v` reusable block publishes protected 24 V field-input/return semantics, 3.3 V logic outputs, FPGA resource needs, return/isolation constraints, selected component identities and verification artifacts while keeping physical field-connector selection and board-specific mapping in integration. Its status checklist remains `SIMULATION-READY` and explicitly records remaining release work.

This is a useful recovery boundary: preserving only the reusable manifest would not reconstruct an actual controller board. A future recoverable configuration would also require exact board/BOM/connection definitions, FPGA image/resource/pin identity, LinuxCNC/HAL configuration, final release evidence, and any required programmer/test-fixture capability. Conversely, an archived board image alone would not preserve the generic electrical contract and evidence consumed by that board.

No actual OpenPressBrake escrow, fleet, release or disaster-recovery capability is asserted. OpenPressBrake remained read-only.

## Current repository reconciliation

At run start, curriculum main contained concurrent safety-lane work after the BD38 checkpoint but no overlapping board-design lesson change. OpenPressBrake main had advanced to `b4e1a4b4b50c2204e4a1e8a75a4588e735aaa75c` (`digital input: freeze scalable board integration handoff`), so the newly active digital-input engineering was consumed read-only.

BD39 was committed as `4a75652ff40c17f1fe85b322bd25f7115e045048` and re-opened from current main. Immediately before this checkpoint write, curriculum main was re-read and contained BD39 with no overlapping post-BD39 board-design change; OpenPressBrake main was also re-read and remained `b4e1a4b4b50c2204e4a1e8a75a4588e735aaa75c`.

## Catalog stress-test result

BD39 exposes a lifecycle infrastructure need above the reusable catalog: a configuration-evidence escrow/recovery manifest should bind exact release/as-maintained identity to authoritative artifact IDs/digests, repository/dependency identities, board/BOM/adapter/connection revisions, FPGA source/toolchain/settings/image/resource map, firmware/software, LinuxCNC/HAL configuration, environment provenance, programmer/fixture/calibration dependencies, independent archive locations, retention authority, restore-drill evidence, exact-image recovery status, rebuild-reproducibility status/equivalence criterion, known degraded dependencies and resulting support restrictions.

This lifecycle/configuration evidence belongs outside reusable block manifests. Reusable blocks continue to own generic engineering contracts and evidence. This infrastructure need remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing archive locations, credentials, serial assets or reproducibility claims.

## Next exact work

Build BD40 on **configuration provenance attestations, trust boundaries, and artifact promotion**:

`engineering evidence -> candidate artifact -> automated checks -> human release authority -> immutable release identity -> provenance/attestation -> promotion to programming/service artifact -> downstream consumption -> revocation/supersession`

Stress locally built binaries with no release provenance, CI artifacts from the wrong commit, signed hashes whose signer authority is unclear, mutable `latest` URLs, a programmer selecting an unpromoted engineering image, and superseded artifacts that remain valid historical evidence but are no longer authorized for new programming.

Require students to distinguish integrity from authority, candidate artifacts from promoted release artifacts, provenance from mere filenames, and supersession/revocation from deletion of historical evidence.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD39. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD39 teaches evidence recovery for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, or independent personnel-safety authority. Recovering an ordinary controller's released artifacts proves nothing about recovery or validation of an independent personnel-safety function.