# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-23

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD50 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD50_GENERATED_ARTIFACT_EQUIVALENCE_CANONICALIZATION_AND_REPRODUCIBILITY_ACCEPTANCE.md`.

BD50 teaches:

`two candidate generations -> normalize non-semantic variation -> compare semantic model -> compare authority/provenance -> classify exact/equivalent/materially-different -> reproducibility evidence -> acceptance or investigation`

## BD50 hard student-material audit

Every repository file named to students as finished material by BD50 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `hardware/4000-board-design/BD49_CONFIGURATION_CHANGE_CONTROL_DETERMINISTIC_REGENERATION_AND_SEMANTIC_DIFF_REVIEW.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/analog_output/integration/REV1_BOARD_INTEGRATION_HANDOFF.md`
- OpenPressBrake `hardware/blocks/analog_output/STATUS_CHECKLIST.md`

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake `hardware/blocks/analog_output/manifest.yaml` as a complete current first-machine authority. The authoritative status checklist explicitly says `REV1_COMMAND_PROFILE_OVERLAY.yaml` supersedes stale first-machine +/-10-V manifest fields, while the manifest still contains first-machine bipolar wording/fields. Its machine-readable status wording also does not cleanly match the checklist's explicit **NOT YET SIMULATION-READY OR SCHEMATIC-READY** state.

The manifest is used only as inspected defect evidence, not assigned as finished student material. BD50 itself was re-opened from current main after commit and checked against the inspected sources.

## Rules frozen by BD50

- byte identity does not prove authorization;
- canonical identity does not prove release equivalence;
- visual identity does not prove semantic identity;
- normalizable formatting is not automatically normalizable engineering meaning;
- canonicalization may remove only variation proven non-semantic for that artifact class;
- canonicalization must remove no engineering question;
- repeated successful generation is not reproducibility without pinned inputs;
- authority/provenance changes remain visible even when connectivity is unchanged;
- unknown authority/canonicalization state fails closed;
- stale authority is reconciled, not normalized away;
- reusable electrical capability remains separate from board/machine configuration overlays;
- ordinary-controller equivalence does not establish independent personnel-safety validation;
- required executable verification uses only `[self-hosted, openpressbrake]`; unavailable authorized compute remains `BLOCKED/NOT_RUN`.

## Worked-example stress test

Current OpenPressBrake analog-output integration makes a useful authority-equivalence example. The reusable primitive remains bipolar, but the current first-machine Rev1 handoff constrains Commander SK T4 to the manufacturer-established 0..10-V profile, keeps B5/B6 as separate ordinary direction inputs, prohibits intentional negative T4 command until installed parameter/configuration evidence supports otherwise, and preserves B4/wire 63 as retained independent Pilz authority.

The authoritative `STATUS_CHECKLIST.md` explicitly says the first-machine profile is `CONFIGURATION_PENDING` and that the machine-readable command-profile overlay supersedes stale +/-10-V first-machine fields in the manifest. It also says the block is not yet SIMULATION-READY or SCHEMATIC-READY.

Therefore two generated artifacts can be visually or electrically similar yet not be release-equivalent if one consumed current overlay authority and the other consumed a stale copied manifest assumption. This is an authority-consumption/catalog defect; it is not justification to narrow the reusable bipolar electrical primitive.

## Catalog stress-test result

BD50 exposes two related missing infrastructure layers:

1. a machine-readable canonical semantic model/digest for generated board artifacts, with versioned normalization rules by artifact class; and
2. an authority-consumption consistency check that detects contradictions among manifests, overlays, status checklists, connection definitions, generated artifacts, and resource reports before generation or promotion.

The current analog-output discrepancy demonstrates why generators must fail closed on unresolved authority precedence instead of selecting whichever file is easiest to parse.

Proposed infrastructure remains `ENGINEERING_REVIEW_NEEDED`.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD49. Curriculum main also contained concurrent safety-course work, which remained intact. OpenPressBrake had advanced to active analog-output Rev1 board-integration work.

BD50 was committed as `f7a8c8f51616ec9b040b0ff175f08eac13864f0f` and re-opened from current main. Immediately before the checkpoint update, curriculum main still contained that lesson on top of the concurrent safety-course commits. OpenPressBrake current main observed for this run was `71d65e78a47ca212f6f9b1f5d726feded47859c2` (`analog output: publish Rev1 board integration handoff`). OpenPressBrake was consumed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD51 on **semantic digest schemas, authority precedence, and fail-closed source reconciliation**:

`source artifacts -> authority precedence -> semantic extraction -> contradiction detection -> unresolved-fact handling -> canonical semantic digest -> generated-consumer lock -> stale-source rejection -> audit`

Re-open the then-current analog-output files before using the discrepancy again; do not assume the current mismatch persists after active engineering work.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD50. No GitHub-hosted runner was used.

## Safety boundary

BD50 teaches generated-artifact equivalence and reproducibility for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. Equivalent ordinary-control artifacts remain ordinary-control artifacts unless a separately engineered and validated safety architecture establishes more.
