# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD29 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run:

- `BD29_RELEASED_CONFIGURATION_IDENTITY_TRACEABILITY_AND_VARIANT_APPLICABILITY.md`

BD29 teaches:

`release proposition -> immutable released baseline ID -> exact block/adapter/board/PCB/BOM/FPGA/HAL identities -> machine applicability -> evidence bindings -> designed identity -> built identity -> installed identity -> supported/superseded/withdrawn state -> SHOW WHERE USED / SHOW WHAT IS INSTALLED -> change applicability -> migration/field-action traceability`

## BD29 hard student-material audit

Every repository file named to students by BD29 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md`
- Curriculum `hardware/4000-board-design/BD28_ENGINEERING_CHANGE_CONTROL_CATALOG_TO_RELEASED_VARIANTS.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before this update
- Curriculum `WORK_SELECTION_POLICY.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`

The newly created BD29 lesson was re-opened from current main after commit and checked for internal consistency.

`ENGINEERING_REVIEW_NEEDED`:

- OpenPressBrake still lacks a repository-wide released-configuration/installed-asset registry that binds immutable release IDs to exact reusable semantic revisions, board/connection/PCB/BOM identity, FPGA/HAL identity, evidence bindings, built serial identity, installed identity, retrofit history, and lifecycle/applicability state.
- Current OpenPressBrake engineering activity is still block/integration development rather than evidence of a production-released controller; no release/serial population is invented for the lesson.

No inspected file is used to claim complete OpenPressBrake production readiness.

## Rules frozen by BD29

- a release ID is immutable and must not be a moving `main`/`latest` pointer;
- release records consume exact reusable semantic revisions, not only family names;
- board-specific connection identity remains board-specific even though release traceability records it;
- unrecorded BOM substitution blocks release inheritance until identity/equivalence is established;
- FPGA image and LinuxCNC/HAL configuration are first-class release components when behavior depends on them;
- designed, built, and installed identity are distinct propositions and must not be assumed equal;
- retrofit history does not rewrite the original release record;
- superseded/legacy does not automatically mean invalid or unsafe;
- `SHOW WHERE USED` engineering dependencies and `SHOW WHAT IS INSTALLED` asset records are separate graphs that must be joined for field applicability;
- unknown installed identity remains `VERIFY_AT_MACHINE`/blocked rather than a best-guess baseline;
- historical evidence/release state remains auditable after later evidence changes;
- ordinary safety-status interface identity can be traced without granting personnel-safety authority;
- cross-machine reuse preserves generic block identity while each board/machine owns its own configuration baseline.

## Current OpenPressBrake worked-example result

OpenPressBrake remains useful as engineering source-of-truth for reusable block and composition governance, but current main is not treated as a released product baseline. Current `STATUS_RULES.md` explicitly separates baseline/integration readiness from full Rev-1 qualification, and `BLOCK_ADAPTER_INTEGRATION_RULES.md` keeps reusable blocks, real adapters, board-only mappings, unknown machine facts, and safety authority separate.

During this run OpenPressBrake main advanced to `391b7a71b7540d18ef5c458ae79125908308a55c` (`lvdt input: bound LT6015 analog-5V rail demand`). That active work was left read-only. The commit itself demonstrates bounded engineering evidence: a current manufacturer cross-check adds a 315-uA-per-populated-channel `ANALOG_5V` load handoff for the selected LT6015 while explicitly not claiming PCB thermal qualification, sensor current, startup/fault closure, or safety authority. BD29 does not present that file to students and does not promote it into release evidence.

No OpenPressBrake engineering file was changed during BD29.

## Current repository reconciliation

BD29 was committed as `c9b413a6d71d6a3fc91be5fbe2b4a57db86b6f37` and re-opened from current main.

Immediately before this checkpoint write, current main was re-read in both repositories. Curriculum main was `c9b413a6d71d6a3fc91be5fbe2b4a57db86b6f37`; no overlapping post-BD29 board-design change was present. OpenPressBrake main was `391b7a71b7540d18ef5c458ae79125908308a55c` and remained read-only.

## Next exact work

Build BD30 on **manufacturing/programming/commissioning handoff and as-built reconciliation**.

Teach the flow:

`released baseline -> manufacturing package -> component/population/option traceability -> programmed FPGA/software identity -> assembly inspection -> first-power/bring-up record -> as-built deviations -> engineering disposition -> installed baseline -> release inheritance`

The adversarial lab should include:

- a wrong-population option on an otherwise correct PCB;
- an approved alternate that is qualified but absent from an obsolete manufacturing pick list;
- a correct PCB/BOM loaded with the wrong FPGA image;
- a reworked board whose as-built delta was not recorded;
- a board that passes basic bench I/O but has an unresolved identity mismatch;
- a field replacement board whose machine-specific HAL/harness mapping must be reconciled before commissioning;
- an unknown legacy installed board requiring a minimal `VERIFY_AT_MACHINE` identity task;
- an ordinary safety-status input whose configuration is traced without treating manufacturing/commissioning evidence as safety validation.

Require explicit distinction among released design authority, manufacturing work instructions, actual as-built population/programming, commissioning evidence, and installed machine identity. Release inheritance must fail closed on unresolved material deviations.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD29. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD29 teaches configuration identity and traceability for ordinary controller hardware/configuration and ordinary electrical/status interfaces. It does not establish PL/SIL/category, diagnostic coverage, stopping performance, or independent personnel-safety authority. An installed identity record for a safety-status interface proves configuration identity only; actual safety-function changes belong to the separate safety design and validation process.