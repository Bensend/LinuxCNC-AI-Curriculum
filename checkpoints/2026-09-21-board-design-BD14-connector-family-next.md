# Board-design curriculum checkpoint — BD14

Date: 2026-09-21
Lane: independent LinuxCNC/OpenPressBrake board-design curriculum

## Completed

Created `hardware/4000-board-design/BD14_CONNECTOR_FAMILY_QUALIFICATION.md`.

BD14 adds a deliberately separate reusable evidence layer:

`manufacturer drawing -> exact family/MPN/contact system -> mating parts -> footprint/pad proof -> conductor range -> voltage/current/temperature derating -> creepage/clearance -> keying/polarization -> mechanical model/keepout -> sourcing/substitution rules -> evidence revision -> regression triggers -> connection-instance consumption`

The lesson freezes that connector-family qualification is reusable physical-component evidence, not a functional electrical block and not a board-specific connection instance.

## Student-facing verification

Before finalizing BD14, current OpenPressBrake `main` versions of these artifacts were opened directly and inspected:

- `hardware/CONNECTION_DEFINITION_CONTRACT.md`
- `hardware/REV1_FIELD_CONNECTOR_INTEGRATION_BOUNDARY.md`
- `hardware/connection_definition_schema.yaml`
- `hardware/connections/REV1_ENCODER_CONNECTIONS.yaml`
- `hardware/connections/REV1_VALVE_POSITION_CONNECTIONS.yaml`

They are `VERIFIED_FOR_LESSON` only for the bounded ownership, fail-closed, interface-class and unresolved-physical-identity claims made in BD14.

The encoder and valve-position files do not prove a shared connector family. Exact physical connector manufacturer/family/MPN/footprint/mate remains unresolved in those instances. BD14 therefore deliberately does not create a speculative OpenPressBrake connector-family record.

The same artifacts are `INCOMPLETE_NOT_STUDENT_MATERIAL` if presented as completed physical connector-family qualifications.

## Catalog stress-test findings

1. A machine-readable connector-family qualification layer would be useful between reusable functional blocks and board-specific connection instances.
2. That record should carry durable qualification ID/revision, exact MPN/variant scope, source-document revisions, mating/contact system, footprint/pad proof, component limits, conductor/derating rules, keying/polarization, substitution status and regression triggers.
3. The family record must contain no J-number, machine semantic mapping, board placement or service labels.
4. A board connection should reference the family qualification and separately prove board current-path/derating, harness compatibility, placement and machine mapping.
5. Unknown physical machine identity remains `VERIFY_AT_MACHINE`; missing identity is not permission to create catalog authority.

No OpenPressBrake patch was made because exact family identity is not yet evidence-backed in the inspected instances and current integration work is active.

## Current-main re-read

Immediately before this checkpoint:

- LinuxCNC-AI-Curriculum main included BD14 at `1ec4fbf1ef9ce6c60001e0c8a136e7705fdb4fdf`.
- OpenPressBrake main was `22bb08bc7af1c813ad45a7d69b9bc2a98633465a` (`integration: close stale board return precedence gap`).

No executable compute was justified; no GitHub-hosted compute was used.

## Durable freezes

- `CONNECTOR-FAMILY EVIDENCE != FUNCTIONAL BLOCK != CONNECTION INSTANCE`.
- `SAME FAMILY NAME != SAME QUALIFIED PHYSICAL INTERFACE`.
- `LIBRARY FOOTPRINT EXISTS != PAD NUMBERING VERIFIED`.
- `QUALIFIED CONNECTOR RATING != RELEASED CHANNEL RATING`.
- `PHYSICALLY MATES != SHOULD BE ALLOWED TO MATE`.
- `DISTRIBUTOR FILTER MATCH != QUALIFIED SUBSTITUTE`.
- `MACHINE IDENTITY UNKNOWN != PERMISSION TO CREATE A FAMILY RECORD`.
- `QUALIFICATION REUSE != J-NUMBER/NET/PLACEMENT/LABEL REUSE`.
- `VERIFY_AT_MACHINE != LICENSE TO GUESS`.
- `ORDINARY CONNECTOR EVIDENCE != PERSONNEL-SAFETY AUTHORITY`.

## Exact next work — BD15

Build **KiCad capture hierarchy, ERC, and rendered-authority validation**.

Start from current main in both repositories. Re-open every OpenPressBrake file exposed to students. Select only a bounded slice whose reusable connectivity and board-integration ownership are current enough to teach capture without inventing missing connector/field facts.

Teach:

`engineering authority -> reusable block sheet/instance -> board integration/shared resources -> board-specific connection binding -> hierarchical/global/local net ownership -> symbol/footprint authority -> generated/rendered schematic -> ERC -> visual review -> rendered-net validator -> release evidence`

Adversarially distinguish:

- semantic contract from exact pin connectivity;
- machine-readable authority from renderer output;
- ERC pass from engineering correctness;
- generated schematic from verified schematic;
- schematic connectivity from PCB current-path/return correctness;
- reusable block hierarchy from board-specific connection ownership.

If current OpenPressBrake capture authority is still incomplete, use that incompleteness explicitly and do not portray a generated whole-board schematic as released.