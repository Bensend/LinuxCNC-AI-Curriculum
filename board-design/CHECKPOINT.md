# Board-Design Curriculum Checkpoint

Current durable lesson: **BD61 — Connection-Block Completeness, Semantic Endpoint Identity, and Harness Closure**

Curriculum repository head after lesson creation: `b5a273c92dc1d75402c55d0672d09a13a3dca450`.

OpenPressBrake engineering source inspected for BD61: `6ed297bd40e6cd2c3df11b9188e396eb8e2daf8b`.

## Verified student-facing sources for BD61

- `hardware/CONNECTION_DEFINITION_CONTRACT.md` — VERIFIED_FOR_LESSON for connection-definition ownership, fields, release gates, and safety boundary.
- `hardware/connection_definition_schema.yaml` — VERIFIED_FOR_LESSON as the current machine-readable mold; it explicitly remains `SCHEMA_DEFINED_NOT_MIGRATED`.
- `hardware/REV1_CONNECTOR_MAP.yaml` — VERIFIED_FOR_LESSON only as the bounded current Rev1 electrical pinout authority; ENGINEERING_REVIEW_NEEDED as a completed physical connection-definition set because connector MPNs, footprints, mating parts, placement/service clearances, harness facts, and other machine facts remain unresolved.

## Catalog stress-test finding

The architecture boundary is sound: reusable functional blocks and board-specific connection definitions remain separate. The current integration gap is migration/closure. `REV1_CONNECTOR_MAP.yaml` has not yet been instantiated connector-by-connector into release-consumable connection-definition records, and the schema correctly refuses to invent unresolved physical-machine facts.

Do not fix this by moving connector-specific names, pins, harness assumptions, or physical placement into reusable block definitions.

## Next run

Develop BD62 around **connection-definition migration and cross-domain consistency**. Select one bounded, non-safety connector whose reusable functional mapping is sufficiently clear. Re-open all referenced files on current main, instantiate or audit the mapping against the connection-definition mold, and cross-check:

`electrical pin authority -> semantic endpoint -> functional owner -> FPGA/logical resource -> power/return/shield domain -> connector contact -> KiCad capture requirement -> placement/marking -> harness evidence`.

Keep exact connector/footprint/mating/placement facts `VERIFY_AT_MACHINE` unless current evidence proves them. If OpenPressBrake main shows active overlapping connector migration, consume it read-only or choose another independent example.

No simulation, synthesis, timing, or other executable engineering verification was needed for BD61; no hosted compute was used.
