# BD62 — Connection-Definition Migration and Cross-Domain Consistency

Status: student-ready lesson with a bounded audited OpenPressBrake migration exercise  
Lane: independent BOARD-DESIGN CURRICULUM  
OpenPressBrake source revision inspected: `2b542508ac335eddb24023e4448495016c9c98f1`

## Purpose

BD61 established what a complete board-specific connection definition must own. BD62 teaches how to migrate a known electrical pinout into that mold without creating a second authority, inventing missing physical facts, or breaking the chain from field wiring through reusable circuitry to FPGA/LinuxCNC semantics.

The migration path is:

`electrical pin authority -> semantic endpoint -> functional owner -> FPGA/logical resource -> power/return/shield domain -> connector contact -> KiCad capture requirement -> placement/marking -> harness evidence -> release decision`

Migration is reconciliation, not transcription. A copied pin table is incomplete until every semantic owner and cross-domain dependency is checked.

## Learning objectives

The student can:

1. preserve a legacy/current electrical-pin authority while a new connection record is incomplete;
2. map each physical contact to a stable semantic endpoint and owning block/shared resource/domain;
3. distinguish field differential pairs from the post-receiver single-ended FPGA interface;
4. trace field power, logic power, return, shield, and transient-current domains independently;
5. reconcile connector semantics against FPGA/LiteX-CNC resource bindings without making the connector own FPGA behavior;
6. identify which KiCad facts can be captured now and which must fail closed;
7. keep manufacturer/footprint/mate/placement/harness facts `VERIFY_AT_MACHINE` when current evidence does not prove them;
8. decide whether a migrated record is useful for integration while still not board-capture-ready.

## Migration authority rule

Until migration is reconciled, the source electrical pinout remains authoritative. The draft connection definition is a derived integration record, not a competing pin authority.

For every migrated fact record:

- source artifact and revision;
- source connector/contact;
- semantic endpoint;
- owning layer;
- whether the value is copied, normalized, derived, or unresolved;
- evidence needed to promote an unresolved field.

A migration must never silently convert `VERIFY_AT_MACHINE` into a value.

## Cross-domain consistency checks

### Field connector -> reusable block

The connector may expose field A/A-bar, B/B-bar, Z/Z-bar pairs. The reusable receiver owns how those field pairs become logic signals. The connection definition references that interface; it does not duplicate receiver resistors, protection, termination topology, or component values.

### Reusable block -> FPGA

The board integration layer maps the receiver's post-stage logic outputs to FPGA resources. A physical connector contact must not be mapped directly to an FPGA ball when a reusable receiver sits between them.

### FPGA -> LinuxCNC/LiteX-CNC

Logical instance identity must remain stable across physical connector or footprint changes. Changing a connector MPN must not rename or reinterpret the encoder instance.

### Power and returns

Field encoder +5 V, encoder return, receiver 3V3/GND, and CHASSIS_PE are separate semantic concerns. A connection definition must not collapse them to generic `GND`. The encoder receiver primitive does not own the field +5-V source; that remains a board/shared-resource responsibility.

### KiCad capture

A connection record can drive connector instantiation only after exact connector MPN, footprint and pad numbering are verified. Before then, the semantic pin map is useful engineering data but is not permission to freeze production CAD.

## Audited OpenPressBrake worked example — Y1 scale connector

### Student-facing files opened in current form during this run

| File | Readiness | Bounded use |
|---|---|---|
| `hardware/CONNECTION_DEFINITION_CONTRACT.md` | VERIFIED_FOR_LESSON | ownership, required fields, release gates, safety boundary |
| `hardware/connection_definition_schema.yaml` | VERIFIED_FOR_LESSON | current fail-closed migration mold; checkpoint remains `SCHEMA_DEFINED_NOT_MIGRATED` |
| `hardware/REV1_CONNECTOR_MAP.yaml` | VERIFIED_FOR_LESSON only as bounded electrical pinout authority; ENGINEERING_REVIEW_NEEDED as a completed connection set | Y1 electrical positions and unresolved mechanical facts |
| `hardware/REV1_MACHINE_CONFIG.yaml` | VERIFIED_FOR_LESSON for bounded Rev1 Y1 encoder allocation | confirms Y1 ATEK scale maps to encoder instance ENC1 and preserves the source pin pattern |
| `hardware/blocks/differential_encoder/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` | VERIFIED_FOR_LESSON for the board-consumption boundary | field pairs, receiver ownership, FPGA resource count, 3V3 allocation rule, field-power and termination boundaries |
| `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json` | VERIFIED_FOR_LESSON for current semantic ENC1 A/B/Z FPGA/LiteX-CNC binding | ENC1 post-receiver logic maps to A15/A14/B14 and LiteX-CNC `encoder_1` |

### Source electrical pin authority

The current Rev1 map defines `J_Y1_SCALE` as a nine-position differential-encoder interface:

| Position | Electrical meaning |
|---|---|
| 1 | encoder return |
| 2 | B |
| 3 | Z |
| 4 | explicit `NC_LEGACY` |
| 5 | protected encoder +5 V |
| 6 | A-bar |
| 7 | B-bar |
| 8 | Z-bar |
| 9 | A |

It also records shield treatment at the connector region as chassis/PE. The exact mechanical connector remains `VERIFY_AT_MACHINE`.

### Semantic migration

A correct draft connection definition may normalize those contacts as field endpoints belonging to three different ownership classes:

- positions 2/7, 3/8 and 9/6: field differential pairs consumed by `differential_encoder` instance ENC1;
- position 5: board/shared protected encoder-field +5-V resource, **not** the receiver's 3V3 rail;
- position 1: encoder field return whose final board/shared-resource relationship must remain explicit;
- shield: CHASSIS_PE connector-region treatment;
- position 4: `NC_LEGACY`, not a spare input.

The reusable receiver then produces three ordinary 3.3-V logic outputs. Current machine-readable FPGA authority maps ENC1 A/B/Z semantics to FPGA balls A15/A14/B14 and LiteX-CNC `encoder_1`. This mapping is downstream of the receiver. It does not turn connector positions 9/2/3 into direct FPGA pins.

### Facts that remain unresolved

Do not fill these fields from inference:

- connector manufacturer/family/MPN;
- exact production footprint and verified pad numbering;
- mating shell/contact hardware;
- retained harness compatibility and condition;
- installed encoder make/model and exact field-power current requirement;
- actual line topology and termination population;
- board edge/side/orientation and service/cable-bend clearances;
- undocumented shield/drain or ground bonds.

Therefore the migrated Y1 record is **not board-capture-ready**. It is nevertheless useful because the semantic owner chain can be checked now without corrupting unresolved physical evidence.

## Adversarial checks

A reviewer should deliberately try these bad migrations:

1. map A/A-bar directly to two FPGA balls;
2. call encoder return, logic GND and CHASSIS_PE all `GND`;
3. make the differential-encoder primitive own the field +5-V supply merely because +5 V is on the same connector;
4. repurpose position 4 because it is electrically unused;
5. populate 120-ohm termination without cable/end-point evidence;
6. invent a connector footprint from the nine-position count;
7. copy ENC1 FPGA balls into the reusable primitive as machine-specific constants;
8. mark the record board-capture-ready while physical connector/harness fields remain unresolved.

Every case must fail review.

## Student lab

Choose one bounded non-safety connector on a mill, lathe, router, plasma table, robot, or custom automation controller. Begin from an existing electrical pin authority and create a draft connection-definition record. Produce a cross-domain trace for every semantic contact through its functional owner to FPGA/logical mapping where applicable. Separately trace power, return, chassis and shield domains. Then mark every unresolved physical fact explicitly and explain which evidence would close it.

The deliverable is not judged by how many fields are filled. It is judged by whether every filled field has authority and every unknown remains visible.

## Catalog stress-test result

The current OpenPressBrake architecture passes the ownership test: the connector schema, differential-encoder block handoff, and FPGA/LiteX-CNC binding form distinct layers. The unresolved defect remains migration tooling/data closure: no release-consumable per-connector instance records yet reconcile the current pin authority with functional ownership, physical connector evidence, placement/marking and harness evidence.

The current digital-input work also advanced on main during this run, publishing a new Rev1 resource handoff. That is active overlapping board-integration work, so this lesson does not modify OpenPressBrake engineering files.

A useful future catalog improvement is a migration validator that rejects ownerless semantic contacts, direct field-to-FPGA shortcuts across required interface blocks, unresolved fields promoted to concrete values without evidence, domain collapse, and premature `board_capture_ready` promotion.

## Safety boundary

This lesson uses an ordinary encoder path. It receives zero personnel-safety credit. Connection migration must preserve any independent safety boundary encountered, but ordinary FPGA/LinuxCNC semantics never become independent personnel-safety authority through a connector mapping.

## Checkpoint

BD62 is complete. Next develop **BD63 — Connection-Definition Validation and Authority-Reconciliation Tests**:

`source pin authority + draft connection record + reusable interface contract + FPGA/resource binding -> automated consistency assertions -> negative migration cases -> unresolved-field checks -> board-capture readiness gate`.

Use documentation/source review unless executable verification is genuinely required. Any executable verification must run only on `[self-hosted, openpressbrake]`; never use hosted Actions compute.