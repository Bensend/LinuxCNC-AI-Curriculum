# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD52 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD52_SEMANTIC_SCHEMA_EVOLUTION_BACKWARD_COMPATIBILITY_AND_MIGRATION_SAFETY.md`.

BD52 teaches:

`existing semantic digests -> schema change -> compatibility classification -> migration transform -> loss/ambiguity detection -> consumer revalidation -> dual-read transition -> old-schema retirement -> audit`

## BD52 hard student-material audit

Every repository file named to students as finished material by BD52 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `hardware/4000-board-design/BD51_SEMANTIC_DIGEST_SCHEMAS_AUTHORITY_PRECEDENCE_AND_FAIL_CLOSED_SOURCE_RECONCILIATION.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/analog_input/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/analog_input/design/REV31_SHARED_ADC_CONSUMER_RECONCILIATION.md`
- OpenPressBrake `hardware/blocks/analog_input/integration/REV1_BOARD_INTEGRATION_HANDOFF.md`

The current analog-input block itself is not presented as schematic-ready or Rev-1 released. Its checklist explicitly leaves panel-run validator execution, production CAD assets, final accuracy/fault work, board integration, and human release open.

BD52 itself was re-opened from current main after commit.

## Rules frozen by BD52

- schema version is part of engineering identity;
- same field name does not guarantee the same semantic contract;
- stable semantic IDs survive harmless serialization renames but not meaning changes;
- unit migrations require explicit dimensions, precision, and exact transforms;
- overloaded-facet splits may migrate only what evidence proves;
- newly explicit return/default/resource/authority facets remain unknown when historical evidence is absent;
- parser defaults do not create historical engineering facts;
- migrated views never replace original release digests;
- schema-change regression scope follows semantic dependency reach;
- dual read is not dual authority;
- old-schema retirement for new build does not delete historical evidence;
- schema migration cannot transfer or manufacture personnel-safety authority;
- executable migration regressions, when justified, use only `[self-hosted, openpressbrake]`; unavailable authorized compute remains `BLOCKED/NOT_RUN`.

## Worked-example stress test

Current OpenPressBrake analog-input authority supplies a concrete schema-evolution example. Historical authority included a 120-ohm / approximately 0..5-V / per-channel direct-drive 49.9-ohm description. Current Rev31/Rev1 authority uses a 100-ohm burden, REF5020 2.048-V reference, ADS7953 Range 2 with nominal 0..4.096-V span, and a shared converter-owned MXO/OPA192 acquisition driver.

The current integration handoff further separates one-channel reusable primitive ownership from board-level ADS7953 physical-channel allocation, shared-converter resource ownership, `5V_MAIN` TPS26612 bias budgeting, `24V_SENSOR_SOURCE` field demand, and unresolved board/machine grounding facts.

A future schema must therefore not migrate an old overloaded `adc_path` field by substituting current values. Historical records retain their original meaning; current candidates consume the reconciled facets. Any old record that cannot prove a new return/default/resource/authority facet remains unresolved rather than receiving a guessed default.

## Catalog stress-test result

BD52 confirms a missing versioned semantic-schema migration layer above per-block authority files. Minimum infrastructure should include schema IDs/versions, stable facet IDs independent of serialization keys, typed units/precision rules, versioned migration manifests, compatibility classes, partial-migration states, immutable historical digest retention, consumer stale/revalidation propagation, dual-read controls, old-schema new-build retirement gates, and reverse lookup for old-schema consumers.

This infrastructure remains `ENGINEERING_REVIEW_NEEDED`. OpenPressBrake was consumed read-only because current main is actively integrating analog input.

## Current repository reconciliation

At run start, the board-design lane ended at BD51. Curriculum main also contained concurrent safety-course work; it was preserved. OpenPressBrake main was `50bae43f29b3cb68af424d10981679452e4c157e` (`analog input: publish Rev1 board integration handoff`).

BD52 was committed as `faac25a63dcdee82576ea74d1cffe3cd724cf938` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD52 commit and OpenPressBrake remained at `50bae43f29b3cb68af424d10981679452e4c157e`. OpenPressBrake stayed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD53 on **semantic migration verification, golden corpora, and negative compatibility tests**:

`migration rules -> representative historical corpus -> expected canonical outputs -> negative/ambiguous cases -> round-trip/loss checks -> consumer-impact oracle -> regression gate -> migration release`

Stress validators that merely parse successfully, transforms that round-trip bytes but lose provenance, hidden unit precision changes, stale historical fixtures, and negative cases proving ambiguous return/default/resource/safety ownership is rejected.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD52. No GitHub-hosted runner was used.

## Safety boundary

BD52 teaches schema evolution for ordinary board-design authority. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. Schema migration cannot confer safety status or replace missing physical-machine evidence.