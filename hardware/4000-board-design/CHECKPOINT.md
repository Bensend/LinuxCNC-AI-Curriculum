# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD28 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD28_ENGINEERING_CHANGE_CONTROL_CATALOG_TO_RELEASED_VARIANTS.md`

BD28 teaches:

`change proposal -> old/new configuration baseline -> affected semantic IDs/facets -> compatibility classification -> owning revision -> SHOW WHERE USED -> evidence invalidation -> board/machine applicability -> migration/retrofit decision -> qualification/regression -> new baseline -> design release -> separate field-action decision`

## BD28 hard student-material audit

Every repository file named to students by BD28 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md`
- Curriculum `hardware/4000-board-design/BD27_QUALIFICATION_FINDING_DISPOSITION_AND_REGRESSION_CLOSURE.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/digital_input_24v/design/REV4_CURRENT_DATASHEET_REVALIDATION.md`
- OpenPressBrake `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md`

The newly created BD28 lesson was re-opened from current main after commit and checked for internal consistency.

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake still lacks a repository-wide variant-aware released-configuration registry binding each board/machine baseline to exact reusable semantic revisions, evidence applicability, compatibility classification, migration state, and field-action disposition.
- Current `digital_input_24v` remains SIMULATION-READY, not SCHEMATIC-READY or REV 1 READY; its PCB/layout review, cost/dependency completion, and human Rev-1 release gates remain open.

No inspected file is used to claim complete OpenPressBrake production readiness.

## Rules frozen by BD28

- a proposed edit is not itself a new engineering baseline;
- source/provenance revision can change without electrical semantic revision when evidence shows no material electrical delta;
- compatibility is classified explicitly as no-semantic-change, backward-compatible, conditional, breaking, board-only, machine-only, or unresolved;
- catalog head is not automatically the required revision for an already released board;
- backward-compatible improvement does not automatically require retrofit;
- BOM substitution requires facet-level equivalence evidence, not nominal-value/package matching;
- board-only connector/location/silkscreen changes do not automatically invalidate generic reusable electrical qualification;
- one machine retrofit does not mutate reusable catalog authority without independent generic justification;
- old configuration baselines and superseded evidence remain preserved;
- design-release approval and field-action/retrofit decisions are separate;
- change applicability follows exact consumed semantic revisions and `SHOW WHERE USED`, not family name alone;
- ordinary safety-status interface change does not grant authority to redesign independent personnel-safety functions.

## Current OpenPressBrake worked-example result

Current OpenPressBrake `digital_input_24v` provides a clean change-control example. The newest TI ISO1212 manufacturer-source revalidation found no material electrical delta requiring topology, component-value, operating-envelope, production-connectivity, or simulation change. The correct disposition was therefore to retain the frozen topology and existing applicable evidence rather than create gratuitous design churn. The block status correctly remains SIMULATION-READY and explicitly leaves downstream PCB/layout and human release work open.

This demonstrates a useful distinction for students: **SOURCE REVISION CHANGED != CIRCUIT SEMANTICS CHANGED != READINESS PROMOTED**.

No OpenPressBrake engineering file was changed during BD28.

## Current repository reconciliation

The curriculum repository contained newer safety-lane commits after the prior BD27 checkpoint; they were preserved.

BD28 was committed as `8d700f22540da95d08df582bd87c5af271729a4d` and re-opened from current main.

Immediately before this checkpoint write, current main was re-read in both repositories. Curriculum main was `8d700f22540da95d08df582bd87c5af271729a4d`; no overlapping post-BD28 board-design change was present. OpenPressBrake main was `511b08e7e2608b6c2af4653c663deca0bcdfce61` (`digital input: revalidate ISO1212 baseline against current datasheet`) and remained read-only.

## Next exact work

Build BD29 on **released-configuration identity, traceability, and variant applicability records**.

Teach the flow:

`release proposition -> immutable released baseline ID -> exact block/adapter/board/PCB/BOM/FPGA/HAL revisions -> machine applicability -> evidence snapshot/bindings -> supported/superseded/withdrawn state -> SHOW WHERE USED / SHOW WHAT IS INSTALLED -> change applicability -> migration/field-action traceability`

The adversarial lab should include:

- two board variants using different qualified revisions of the same reusable block;
- a new catalog revision that applies to new builds but not an old released variant;
- a board assembled with a BOM substitution whose identity was not captured and therefore cannot inherit the released baseline by assumption;
- an FPGA image/HAL configuration mismatch on otherwise identical hardware;
- a machine retrofit whose installed baseline differs from the board's original release record;
- a superseded but still-supported legacy baseline;
- a withdrawn/blocked baseline with explicit field-action applicability;
- an ordinary safety-status interface revision whose installed identity is tracked without granting safety authority.

Require explicit stable release IDs, installed-versus-designed distinction, immutable historical baselines, exact evidence binding, and reverse lookup from a changed semantic facet to affected released/installed populations.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD28. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD28 teaches engineering change control for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, diagnostic coverage, stopping performance, or independent personnel-safety authority. A change that actually alters an independent safety function belongs to the separate safety design and validation process.