# Board-Design Curriculum Checkpoint

Current durable lesson: **BD64 — Connection-Definition Instance Closure and Generator-Ready Contracts**

Curriculum lesson commit: `d449e9f7035e73045e558816dfad42731793a0db`.

OpenPressBrake engineering source inspected for BD64: `a644326acd6fcd57dc7f57dd2d86ae1e51dda00b`.

## Verified student-facing sources for BD64

- `hardware/CONNECTION_DEFINITION_CONTRACT.md` — VERIFIED_FOR_LESSON for connection ownership, closure fields, generator boundary and release gates.
- `hardware/connection_definition_schema.yaml` — VERIFIED_FOR_LESSON as the current fail-closed mold; checkpoint remains `SCHEMA_DEFINED_NOT_MIGRATED`.
- `hardware/REV1_FIELD_CONNECTOR_INTEGRATION_BOUNDARY.md` — VERIFIED_FOR_LESSON for physical-part ownership, selection classes, derating and physical-machine survey boundary.
- `hardware/REV1_CONNECTOR_MAP.yaml` — VERIFIED_FOR_LESSON only as bounded electrical-pinout authority; ENGINEERING_REVIEW_NEEDED as a complete physical connection-definition set.
- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for evidence/status truthfulness and the distinction between integration readiness and qualification.
- `board-design/BD63_CONNECTION_VALIDATION_AUTHORITY_RECONCILIATION.md` — VERIFIED_FOR_LESSON as the prerequisite validation method.

## Closure result

BD64 separates semantic, physical-part, footprint/pad, electrical-envelope, and placement/service/manufacturing closure. It freezes the rule that semantic reconciliation does not make a connector generator-ready and that generator output must never convert `TBD` or `VERIFY_AT_MACHINE` into plausible-looking production hardware.

The bounded `J_DNC_PWR` example is intentionally simple. Current authority supports DNC60 J19, two positions, pin 1 wire 9/L9/controller 24 V and pin 2 wire 4/L06/controller return. It does not support an exact connector MPN, footprint/pad geometry, mate, keying, harness condition, installed conductor size, placement/orientation, service clearance, or released current rating. Therefore it is semantically useful but board-capture-ineligible.

BD64 introduces explicit closure states: `SEMANTICALLY_RECONCILED`, `PHYSICAL_PART_FROZEN`, `FOOTPRINT_VERIFIED`, `ELECTRICAL_ENVELOPE_SUPPORTED`, `PLACEMENT_HARNESS_MARKING_CLOSED`, `BOARD_CAPTURE_ELIGIBLE`, and `GENERATED_ARTIFACT_LOCKED`. A single Boolean is insufficient to explain why a connection can or cannot advance.

## Catalog stress-test finding

The current OpenPressBrake architecture has the correct ownership boundary, but it still lacks migrated release-consumable legacy connection instances with exact physical connector evidence. Treat this as ENGINEERING_REVIEW_NEEDED infrastructure, not as permission to select convenient parts. Connection instances should ultimately carry machine-readable closure state and evidence references per facet so tooling can distinguish semantic migration from physical/manufacturing closure.

OpenPressBrake remained read-only. Current main is independently advancing reusable resource contracts, and no current evidence justified freezing legacy connector mechanics without machine survey. No simulation, synthesis, timing, place-and-route, regression or other executable verification was required; no hosted compute was used.

## Next run

Develop **BD65 — KiCad Connection Generation, Provenance-Carrying Capture, and ERC Boundaries**:

`capture-eligible connection instance -> deterministic symbol/footprint/net generation -> provenance metadata -> ERC -> semantic reconciliation -> generated-artifact diff -> evidence lock -> board-integration acceptance`.

Use only a connection whose capture prerequisites are actually supported, or explicitly teach a fail-closed generator fixture that cannot masquerade as production capture. Re-open every student-facing source on current main before assigning it. Do not let ERC or successful generation substitute for connector identity, pad proof, current/derating, harness, safety, or machine-verification evidence.