# Board-Design Curriculum Checkpoint

Current durable lesson: **BD62 — Connection-Definition Migration and Cross-Domain Consistency**

Curriculum lesson commit: `88aeff83409b5ede6c169702c19fd030b8cdab37`.

OpenPressBrake engineering source inspected for BD62: `2b542508ac335eddb24023e4448495016c9c98f1`.

## Verified student-facing sources for BD62

- `hardware/CONNECTION_DEFINITION_CONTRACT.md` — VERIFIED_FOR_LESSON for connection ownership, required fields, release gates and safety boundary.
- `hardware/connection_definition_schema.yaml` — VERIFIED_FOR_LESSON as the current fail-closed mold; still `SCHEMA_DEFINED_NOT_MIGRATED`.
- `hardware/REV1_CONNECTOR_MAP.yaml` — VERIFIED_FOR_LESSON only as bounded electrical-pinout authority; ENGINEERING_REVIEW_NEEDED as a completed physical connection-definition set.
- `hardware/REV1_MACHINE_CONFIG.yaml` — VERIFIED_FOR_LESSON for the bounded Rev1 Y1 encoder allocation and source-derived pin pattern.
- `hardware/blocks/differential_encoder/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` — VERIFIED_FOR_LESSON for reusable receiver/board-consumption boundaries, field-pair ownership, 3V3 resource rule, termination boundary and field-power boundary.
- `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json` — VERIFIED_FOR_LESSON for current ENC1 A/B/Z post-receiver FPGA/LiteX-CNC binding.

## Worked migration result

Y1 scale is a useful bounded migration exercise. Current pin authority establishes a nine-position encoder interface with A/A-bar, B/B-bar, Z/Z-bar, protected +5 V, encoder return, explicit legacy NC and chassis/PE shield treatment. The reusable differential-encoder handoff establishes that field pairs terminate in an AM26LV32E receiver primitive, while current FPGA/LiteX-CNC authority maps post-receiver ENC1 A/B/Z to A15/A14/B14 and `encoder_1`.

The draft semantic migration is **not board-capture-ready** because exact connector/footprint/pad numbering, mate, harness condition, installed encoder power requirement, termination selection, placement/orientation/service clearance and undocumented shield/ground facts remain unresolved. Do not infer these values.

## Catalog stress-test finding

The architecture boundary remains sound. The missing infrastructure is release-consumable per-connector migration plus automated reconciliation. A validator should reject ownerless semantic contacts, direct field-to-FPGA shortcuts across required receiver blocks, domain collapse, repurposed NC contacts, invented physical facts, and premature `board_capture_ready` promotion.

OpenPressBrake remained read-only because current main advanced active board-integration work during this run (`digital input: publish machine-readable Rev1 resource contract`). No simulation, synthesis, timing, place-and-route, regression or other executable verification was required; no hosted compute was used.

## Next run

Develop **BD63 — Connection-Definition Validation and Authority-Reconciliation Tests**:

`source pin authority + draft connection record + reusable interface contract + FPGA/resource binding -> automated consistency assertions -> negative migration cases -> unresolved-field checks -> board-capture readiness gate`.

Re-open all student-facing sources on current main. If an executable validator is justified, it may run only on `[self-hosted, openpressbrake]`; otherwise keep the work to documentation/source review and record the executable-verification blocker rather than using hosted compute.