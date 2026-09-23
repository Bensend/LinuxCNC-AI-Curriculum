# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD51 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD51_SEMANTIC_DIGEST_SCHEMAS_AUTHORITY_PRECEDENCE_AND_FAIL_CLOSED_SOURCE_RECONCILIATION.md`.

BD51 teaches:

`source artifacts -> authority precedence -> semantic extraction -> contradiction detection -> unresolved-fact handling -> canonical semantic digest -> generated-consumer lock -> stale-source rejection -> audit`

## BD51 hard student-material audit

Every repository file named to students as finished material by BD51 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `hardware/4000-board-design/BD50_GENERATED_ARTIFACT_EQUIVALENCE_CANONICALIZATION_AND_REPRODUCIBILITY_ACCEPTANCE.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/analog_output/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/blocks/analog_output/integration/REV1_COMMAND_PROFILE_OVERLAY.yaml`

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake `hardware/blocks/analog_output/manifest.yaml` as a complete first-machine command-profile authority. Current checklist explicitly says the Rev1 command-profile overlay supersedes stale first-machine +/-10-V fields, while the manifest still contains first-machine bipolar purpose/variant/mapping fields.

The manifest is used only as inspected defect evidence, not assigned as finished student authority. BD51 itself was re-opened from current main after commit.

## Rules frozen by BD51

- authority belongs to semantic facets, not entire filenames;
- file authority does not imply authority for every field in that file;
- reusable capability, adapter transformation, board connection, machine configuration, verified machine facts, and release locks remain distinct authority layers;
- more-specific constraints may narrow but may not silently redefine reusable capability;
- precedence is scoped and type-safe, never generic `overlay wins`;
- last parsed value is not a resolved value;
- stale shadowed evidence remains recoverable but is not consumable for the superseded scope;
- unknown physical facts remain explicit `VERIFY_AT_MACHINE` data;
- unknown facts do not become guessed defaults and do not block unrelated frozen work;
- semantic digests include authority/provenance and unresolved state, not only electrical values;
- generated consumers lock to exact semantic input identity;
- ordinary-control authority reconciliation cannot transfer independent personnel-safety authority;
- required executable verification uses only `[self-hosted, openpressbrake]`; unavailable authorized compute remains `BLOCKED/NOT_RUN`.

## Worked-example stress test

Current OpenPressBrake analog-output authority still demonstrates the problem. The reusable primitive retains `[-10,+10] V` capability, while the first-machine Rev1 overlay authorizes only `0..10 V` at Commander SK T4, keeps B5/B6 as separate ordinary direction inputs, and preserves B4/wire 63 under retained independent Pilz authority. Installed Commander SK parameterization and resulting command-scale/direction semantics remain unresolved.

This is a legitimate machine-specific narrowing of reusable capability, not a reusable-block redesign. The manifest's stale first-machine bipolar fields are shadowed for Rev1 command-profile generation because the authoritative checklist explicitly names the overlay as superseding them.

## Catalog stress-test result

BD51 confirms the need for a machine-readable authority-reconciliation layer with stable semantic facet IDs, scoped owners, parent/narrowing relationships, authority states, exact source/evidence identity, contradiction detection, `VERIFY_AT_MACHINE` dependency reach, canonical semantic digests, consumer locks, and reverse lookup from changed facets to generated consumers.

The infrastructure remains `ENGINEERING_REVIEW_NEEDED`. OpenPressBrake was consumed read-only because active board-development work continues.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD50. Curriculum main also contained concurrent safety-course work, which remained intact. OpenPressBrake had advanced beyond the prior analog-output work into active Rev1 shared-converter integration.

BD51 was committed as `4ea448ea9935e668740474d35b34d386bf95339f` and re-opened from current main. Immediately before this checkpoint write, curriculum main was that BD51 commit. OpenPressBrake current main was `b140efff8474b40fb8823870bbe2fe73a7c4eb4f` (`shared converter: publish Rev1 board integration handoff`). OpenPressBrake was consumed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD52 on **semantic-schema evolution, backward compatibility, and migration safety**:

`existing semantic digests -> schema change -> compatibility classification -> migration transform -> loss/ambiguity detection -> consumer revalidation -> dual-read transition -> old-schema retirement -> audit`

Stress renames versus meaning changes, unit migrations, splitting one overloaded facet into reusable capability plus machine constraint, adding a previously implicit return/default/resource facet, and migration of historical release locks without rewriting history.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD51. No GitHub-hosted runner was used.

## Safety boundary

BD51 teaches authority reconciliation for ordinary controller design artifacts. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. Any ordinary-controller source that conflicts with retained independent safety ownership is a contradiction requiring engineering review, not a precedence choice.
