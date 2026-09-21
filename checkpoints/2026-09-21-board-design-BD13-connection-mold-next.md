# Board-design curriculum checkpoint — BD13

Date: 2026-09-21
Lane: independent LinuxCNC/OpenPressBrake board-design curriculum

## Completed

Created `hardware/4000-board-design/BD13_BOARD_SPECIFIC_CONNECTION_MOLD_QUALIFICATION.md`.

BD13 returns to BLOCK/CONNECTION methodology and teaches:

`machine endpoint evidence -> connection-mold fields -> connector electrical/mechanical requirements -> pin mapping -> power/return requirements -> functional mapping -> placement/orientation -> silkscreen -> harness destination -> derating/clearance -> machine verification -> capture/PCB release state`

The lesson treats the connection **mold/schema/method** as reusable while keeping each completed J-number/board instance deliberately board-specific.

## Student-facing verification

Before finalizing BD13, the current OpenPressBrake `main` versions of these artifacts were opened directly and inspected:

- `hardware/CONNECTION_DEFINITION_CONTRACT.md`
- `hardware/connection_definition_schema.yaml`
- `hardware/connections/REV1_ENCODER_CONNECTIONS.yaml`
- `hardware/connections/REV1_CONNECTION_COVERAGE_CHECKPOINT.md`
- `hardware/blocks/differential_encoder/manifest.yaml`

They are `VERIFIED_FOR_LESSON` only for the bounded claims made in BD13. In particular, `REV1_ENCODER_CONNECTIONS.yaml` is a verified example of correctly bounded electrical connection instantiation, not a finished physical connector/PCB-release example. Its exact connector, footprint/pad mapping, physical placement/access, harness compatibility, electrical envelope/derating, and cable/termination facts remain open; its own `board_capture_ready` flag remains false.

The complete OpenPressBrake board is not presented as production-proven.

## Catalog stress-test findings

1. Connection readiness should eventually have mechanical/physical validation in addition to electrical mapping validation.
2. Connector-family qualification is reusable engineering data without being a reusable functional electrical block.
3. `electrical mapping complete` and `physical connection qualified` should remain separate maturity states.
4. `VERIFY_AT_MACHINE` facts would benefit from field-level provenance so later closure and regression review can identify exactly which measured fact established which field.
5. Retained harness identity/condition/compatibility deserves a durable qualified identifier rather than being inferred from connector family alone.

No OpenPressBrake patch was made. Current OpenPressBrake integration is active in the same power/return/field-connector area; the curriculum consumed current authority read-only rather than racing it.

## Current-main re-read

Immediately before this checkpoint:

- LinuxCNC-AI-Curriculum main included BD13 at `cddc6a71ca490e6fbb632c0aaa5a145779fe0de8`.
- OpenPressBrake main remained `29cd632ad83a3e1beab1661055f136bc2e6cd2db` (`integration: preserve encoder return boundary after Rev15`).

No executable compute was justified; no GitHub-hosted compute was used.

## Durable freezes

- `REUSABLE BLOCK != BOARD-SPECIFIC CONNECTION INSTANCE`.
- `CONNECTION MOLD REUSE != CONNECTION INSTANCE REUSE`.
- `ELECTRICAL PINOUT KNOWN != PHYSICAL CONNECTOR QUALIFIED`.
- `RIGHT PIN COUNT != VERIFIED FOOTPRINT/PAD MAPPING`.
- `CONNECTOR COMPONENT RATING != RELEASED BOARD/CHANNEL RATING`.
- `SAME NOMINAL RETURN != PERMISSION TO SHARE PCB CURRENT PATH`.
- `SAME MACHINE WIRE NUMBER != PROVEN COMMON NET`.
- `SCHEMATIC NET NAME != SERVICE LABEL`.
- `VERIFY_AT_MACHINE != LICENSE TO GUESS`.
- `GENERATOR RENDERS/CHECKS AUTHORITY; GENERATOR DOES NOT INVENT AUTHORITY`.
- `ELECTRICAL CONNECTION COMPLETE != CAPTURE READY != PCB READY != MACHINE QUALIFIED`.
- `ORDINARY CONNECTION TO SAFETY STATUS != PERSONNEL-SAFETY AUTHORITY`.

## Exact next work — BD14

Build **connector-family qualification and reusable physical-interface evidence** without turning connector families into functional electrical blocks.

Start from current main in both repositories. Inspect current connection governance plus at least two connection definitions that could plausibly consume the same connector-family evidence. If exact physical connector identity is still `VERIFY_AT_MACHINE`, do not invent a family; instead teach the qualification artifact/schema using evidence-backed generic fields and preserve the OpenPressBrake instance as blocked.

BD14 should teach:

`manufacturer drawing -> exact family/MPN/contact system -> mating parts -> footprint/pad proof -> conductor range -> voltage/current/temperature derating -> creepage/clearance -> keying/polarization -> mechanical model/keepout -> sourcing/substitution rules -> evidence revision -> regression triggers -> connection-instance consumption`

Adversarially prove that reusable connector-family evidence can be consumed by multiple board-specific connection instances while J-number, semantic net mapping, machine destination, placement and silkscreen remain board-specific. A connector-family record must never become an alternate source for functional-block electrical topology or machine wiring.