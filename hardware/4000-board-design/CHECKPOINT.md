# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD30 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD30_MANUFACTURING_PROGRAMMING_COMMISSIONING_HANDOFF_AND_AS_BUILT_RECONCILIATION.md`

BD30 teaches:

`released baseline -> manufacturing package -> actual population/options -> programmed identity -> assembly inspection -> first-power record -> as-built deviations -> engineering disposition -> commissioned identity -> installed baseline -> release inheritance`

## BD30 hard student-material audit

Every repository file named to students by BD30 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD29_RELEASED_CONFIGURATION_IDENTITY_TRACEABILITY_AND_VARIANT_APPLICABILITY.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/dry_contact_relay_output/REV1_BOARD_POWER_HANDOFF.md`
- OpenPressBrake `hardware/blocks/dry_contact_relay_output/STATUS_CHECKLIST.md`

The newly created BD30 lesson was re-opened from current main after commit and checked for internal consistency.

`ENGINEERING_REVIEW_NEEDED`:

- the current OpenPressBrake dry-contact relay primitive remains `NOT READY`; CAD mapping, rendered schematic/ERC, PCB copper/creepage, first-machine mapping, bench checks, and board-level worst-case source/thermal qualification remain open;
- OpenPressBrake still lacks a repository-wide released-configuration/serialized as-built/programming/deviation/installed-asset registry;
- current engineering activity is not evidence of a production-released or serialized OpenPressBrake controller population, so no release or serial identities are invented.

No inspected file is used to claim complete OpenPressBrake production readiness.

## Rules frozen by BD30

- released design identity and physical as-built identity are different propositions;
- manufacturing work instructions may resolve a release into process detail but may not silently redesign it;
- reusable blocks publish per-instance/scalable handoffs while board releases own population and simultaneous-use assumptions;
- procurement similarity is not release applicability;
- programming success is not proof that the correct FPGA/software/HAL identity was loaded;
- inspection reconciles configuration identity as well as workmanship;
- material rework/deviation history is preserved rather than erased after correction;
- successful first power/basic I/O does not prove release inheritance;
- release inheritance fails closed while material hardware/programming identity is unresolved;
- a valid replacement board still requires machine-specific harness/HAL mapping reconciliation before commissioning;
- connector/pin/location/silkscreen/harness mapping remains board-specific connection authority through manufacturing;
- manufacturing/commissioning evidence for an ordinary safety-status receiver does not establish personnel-safety validation.

## Current OpenPressBrake worked-example result

Current `dry_contact_relay_output` provides a useful bounded handoff example. Its board-power artifact publishes 16.7 mA nominal `24V_MACHINE` current and approximately 0.40 W coil dissipation per energized primitive instance, while explicitly leaving configured quantity, credible simultaneous energization, source sizing, thermal density, and machine load facts to board integration/qualification. The status checklist truthfully remains `NOT READY` and keeps the unresolved CAD, PCB, machine, bench, and qualification gates visible.

That is suitable for teaching the direction of manufacturing authority: the reusable primitive publishes scalable facts; the released board would own population; manufacturing would record actual population; commissioning would reconcile installed mapping. It is not presented as a finished student block or production release.

No OpenPressBrake engineering file was changed during BD30.

## Current repository reconciliation

BD30 was committed as `c782ab91272fb74f6eccbf32efd7e1f4cd1540e3` and re-opened from current main.

Immediately before this checkpoint write, current main was re-read in both repositories. Curriculum main was `c782ab91272fb74f6eccbf32efd7e1f4cd1540e3`; newer safety-lane commits from earlier in the hour were preserved and no overlapping post-BD30 board-design change was present. OpenPressBrake main was `73e6ec20ca4ed9e3fc6251709b75ee98a95a4a9e` (`dry contact relay: record coil power handoff evidence`) and remained read-only.

## Catalog stress-test result

BD30 exposes a concrete infrastructure gap: configuration traceability needs a machine-readable as-built record joining immutable release identity to actual PCB/BOM/options, approved alternates, programming artifacts/hashes, deviations/rework, inspection/test evidence, commissioning mapping, and installed asset identity.

Do not solve this by adding manufacturing quantity or machine-specific connector data to reusable block contracts. The missing layer is release/as-built/integration traceability.

## Next exact work

Build BD31 on **production test architecture, fixture contracts, calibration identity, and serialized evidence capture**.

Teach the flow:

`released/as-built identity -> testable production claims -> fixture interface contract -> test limits/procedure revision -> programmed/calibration identity -> serialized execution -> bounded result/evidence -> deviation/retest rules -> shipment/installation gate`

The adversarial lab should include:

- a fixture that can test a board electrically but is wired to an obsolete connection-definition revision;
- a production test that passes while using limits from an older semantic revision;
- a calibration constant written successfully but not bound to the serialized board identity;
- a reused fixture adapter containing real conditioning that should be independently qualified rather than hidden as fixture wiring;
- a test escape caused by checking only FPGA command state rather than field-side behavior;
- a retest after rework where original failed evidence must remain preserved;
- a cross-machine reusable block whose production test requirement stays generic while each board fixture owns physical pin mapping;
- an ordinary safety-status input production check that proves ordinary electrical function only, not safety validation.

Require students to distinguish qualification evidence from production-screen evidence, product circuitry from fixture circuitry, generic block test requirements from board-specific fixture mappings, and calibration/configuration identity from mere write success.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD30. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD30 teaches manufacturing/programming/commissioning traceability for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, diagnostic coverage, stopping performance, or independent personnel-safety authority. Manufacturing or commissioning evidence for a safety-status interface proves only the bounded ordinary-interface claim actually tested.