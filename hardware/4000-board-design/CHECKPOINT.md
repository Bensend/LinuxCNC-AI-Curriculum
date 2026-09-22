# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD40 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD40_CONFIGURATION_PROVENANCE_ATTESTATIONS_TRUST_AND_ARTIFACT_PROMOTION.md`.

BD40 teaches:

`engineering evidence -> candidate artifact -> automated checks -> human release authority -> immutable release identity -> provenance/attestation -> promotion to programming/service artifact -> downstream consumption -> revocation/supersession`

## BD40 hard student-material audit

Every repository file named to students by BD40 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD39_CONFIGURATION_EVIDENCE_ESCROW_DISASTER_RECOVERY_AND_REPRODUCIBILITY.md`
- Curriculum `hardware/4000-board-design/BD38_FLEET_CLOSURE_RESIDUAL_SUPPORT_AND_LEGACY_RETIREMENT.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/differential_encoder/manifest.yaml`
- OpenPressBrake `hardware/blocks/differential_encoder/REV1_3V3_POWER_HANDOFF.yaml`
- OpenPressBrake `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`

The newly created BD40 lesson was re-opened from current main after commit and checked against the inspected sources.

`ENGINEERING_REVIEW_NEEDED`:

- current OpenPressBrake `differential_encoder` remains `SIMULATION-READY`, not `REV 1 READY`;
- cable/termination selection, protected encoder field power, abnormal/transient work, schematic visual review, PCB integration, final cost, board-integration closure and human release remain open;
- FPGA LUT/register estimates remain TBD in the reusable manifest even though concrete board/image bindings exist elsewhere;
- OpenPressBrake has no repository-wide immutable artifact-promotion/provenance authority joining exact candidates to released programming/service artifacts;
- current engineering evidence does not establish a released OpenPressBrake fleet, signing authority, production programmer policy, immutable release store, or production artifact promotion history.

No inspected file is used to claim complete OpenPressBrake production, release, fleet, signing, or programming authority.

## Rules frozen by BD40

- integrity does not establish release authority;
- candidate build success does not promote an artifact;
- CI success proves only the checks actually run and does not replace human/defined release authority;
- mutable locations such as `latest` do not establish immutable release identity;
- a valid signature does not establish that the signer was authorized for the asserted claim;
- programming capability does not establish permission to program an artifact;
- promotion cannot make stale candidate inputs consume newer evidence;
- superseded artifacts remain historical evidence and may retain bounded service applicability;
- revocation withdraws authority for a stated scope but does not justify deleting failure/configuration history;
- release metadata belongs to the release/configuration layer rather than leaking machine-specific authority into reusable block circuitry;
- ordinary-controller artifact promotion does not validate an independent personnel-safety function.

## Current OpenPressBrake worked-example result

The current `differential_encoder` reusable block owns one-encoder A/Abar, B/Bbar and Z/Zbar receive semantics, AM26LV32E receiver/protection topology, generic FPGA demand and exact reference provenance. Its current machine-readable 3V3 handoff publishes a 17.0 mA maximum receiver-source planning load and 0.1 uF local bypass per populated primitive, while board integration owns instance count, aggregate rail capacity, FPGA A/B/Z allocation, physical connector/shield implementation, termination selection from actual cable evidence and any encoder field supply.

The handoff explicitly records `electrical_topology_changed: false` and `formal_status_advanced: false`; publishing a machine-readable board-power contract is not qualification or release promotion. The current status checklist likewise remains `SIMULATION-READY` and preserves open physical-machine and release gates.

This makes the encoder a useful artifact-authority example without pretending it is released hardware: a future board release may consume the reusable evidence, but a signed or hashed FPGA image cannot promote the reusable block to `REV 1 READY`, and the reusable block must not absorb board release signers, serial populations, connector J-numbers or service-programming authority.

## Current repository reconciliation

At run start, curriculum main had concurrent safety-lane work after the BD39 checkpoint but no overlapping post-BD39 board-design lesson. OpenPressBrake main had advanced to `998437beef98de11d2a249842c01712db31022f4` (`encoder: publish reusable 3V3 power handoff`), so the newly active encoder work was consumed read-only.

BD40 was committed as `09cfdfcf599d84d2703abb1f01cb888aaf799367` and re-opened from current main. Immediately before this checkpoint write, curriculum main was re-read and contained BD40 with no overlapping post-BD40 board-design change; OpenPressBrake main was also re-read and remained `998437beef98de11d2a249842c01712db31022f4`.

## Catalog stress-test result

BD40 exposes a release/configuration infrastructure need above the reusable catalog: an artifact-promotion/provenance record should bind exact candidate and release identities to artifact digests/types, source/dependency/toolchain/environment identity, consumed block/adapter/board/BOM/connection/resource revisions, automated evidence and skipped gates, release/configuration identity and assembly variants, issuer/signer identity and authority scope, human release decision, promotion state, new-build/service/as-maintained applicability, programming-distribution authority, semantic dependency/staleness state, supersession/revocation/quarantine state, affected installed populations and retained negative/rollback evidence.

This authority belongs outside reusable block manifests. Reusable blocks continue to own generic electrical contracts and evidence. This infrastructure need remains `ENGINEERING_REVIEW_NEEDED`; current OpenPressBrake evidence does not justify inventing signing keys, release approvers, immutable stores, serial assets or production authority.

## Next exact work

Build BD41 on **release dependency invalidation, semantic change impact, and controlled re-promotion**:

`released artifact -> upstream semantic change -> SHOW WHERE USED -> affected claim/evidence classification -> stale/quarantine decision -> bounded regression -> new candidate -> re-promotion or documented non-impact -> downstream fleet/service applicability`

Stress component substitutions that preserve topology but alter limits, FPGA resource-map changes with unchanged HAL names, board connector remaps hidden behind stable logical names, toolchain rebuilds that produce different binaries, and a generic block evidence correction that invalidates only one consumed semantic facet rather than every historical release.

Require students to invalidate by semantic dependency rather than filename proximity, preserve unaffected evidence, fail closed when dependency identity is unknown, and distinguish requalification of a reusable block from re-promotion of a board/configuration artifact.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD40. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD40 teaches provenance, trust and promotion authority for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, safety diagnostic coverage, stopping performance, final-element validation, safety-rated signing/change control, or independent personnel-safety authority. Promotion of an ordinary controller artifact proves nothing about validation of an independent personnel-safety function.