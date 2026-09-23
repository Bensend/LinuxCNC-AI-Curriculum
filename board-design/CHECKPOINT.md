# Board-Design Curriculum Checkpoint

Current durable lesson: **BD65 — KiCad Connection Generation, Provenance-Carrying Capture, and ERC Boundaries**

Curriculum lesson commit: `60b0505e11844df7f52f8d242101d3681d6ee1a0`.

OpenPressBrake engineering source inspected for BD65: `857108dc70c62bf4734dee5f4009f479d4ae51d4`.

## Verified student-facing sources for BD65

- `hardware/CONNECTION_DEFINITION_CONTRACT.md` — VERIFIED_FOR_LESSON for connection ownership, machine-readable handoff, release gates and generator fail-closed behavior.
- `hardware/connection_definition_schema.yaml` — VERIFIED_FOR_LESSON as the current fail-closed mold; checkpoint remains `SCHEMA_DEFINED_NOT_MIGRATED`.
- `hardware/blocks/STATUS_RULES.md` — VERIFIED_FOR_LESSON for evidence/status truthfulness and the rule that passing automation proves only what it actually tests.
- `board-design/BD64_CONNECTION_INSTANCE_CLOSURE_GENERATOR_READY.md` — VERIFIED_FOR_LESSON as the prerequisite closure/evidence-lock method.

## Closure result

BD65 freezes the rules `GENERATED != ENGINEERED` and `ERC-CLEAN != AUTHORITY-VALID`. Production KiCad generation may consume only BD64 capture-eligible facts; it may not turn `TBD` or `VERIFY_AT_MACHINE` into plausible production hardware. Generated connector objects should carry machine-readable provenance to exact connection, pin authority, functional block/resource contract, connector drawing, footprint, machine evidence and generator configuration.

ERC is treated as bounded downstream electrical-capture evidence. It does not prove connector identity, manufacturer pin numbering, footprint-pad correctness, derating, harness fit, service clearance, return/shield engineering, block qualification or safety authority.

Because current OpenPressBrake connection authority still reports `SCHEMA_DEFINED_NOT_MIGRATED` and retains unresolved physical connector facts, BD65 intentionally uses a fail-closed review-fixture method rather than inventing a production connector merely to demonstrate generation/ERC.

## Catalog stress-test finding

Current OpenPressBrake lacks a migrated release-consumable connection instance suitable as a truthful production KiCad-generation worked example. Treat this as ENGINEERING_REVIEW_NEEDED infrastructure. Later tooling should (1) enforce per-facet closure before production generation and (2) carry machine-readable provenance plus semantic-diff/reconciliation evidence for generated CAD objects.

OpenPressBrake remained read-only. Current main independently advanced `safety_interface` board-integration work during this run, so no overlapping engineering files were changed. No simulation, synthesis, timing, place-and-route, regression or other executable verification was required; no hosted compute was used.

## Next run

Develop **BD66 — Schematic Integration Reconciliation and Cross-Block Net Ownership**:

`generated/captured blocks + connection definitions + shared resources -> complete schematic net graph -> owner/driver/load/return reconciliation -> power-domain and authority checks -> ERC/structural evidence -> integration defect loop -> accepted schematic baseline`.

Re-open every student-facing source on current main before assigning it. Use current OpenPressBrake integration evidence only within its actual maturity, and do not claim the current board is production-proven.