# BD63 — Connection-Definition Validation and Authority-Reconciliation Tests

Status: student-ready lesson with bounded audited OpenPressBrake assertions  
Lane: independent BOARD-DESIGN CURRICULUM  
OpenPressBrake source revision inspected: `0f0b7bede913e27cdc249255cf6fb28bc6d46b0b`

## Purpose

BD62 showed how to migrate a board connector without collapsing reusable-block, board-integration, FPGA, power/return, and machine-harness authority. BD63 turns that review into a fail-closed validation method.

The validation chain is:

`source pin authority + connection record + reusable interface contract + board resource binding -> reconciliation assertions -> negative cases -> unresolved-fact gate -> board-capture decision`

The central rule is: **schema-valid is not authority-valid**. A record can contain every required field and still be wrong because it invents a physical fact, bypasses an interface block, collapses domains, repurposes an NC contact, or binds the wrong logical endpoint.

## Learning objectives

The student can:

1. distinguish schema validation from engineering-authority reconciliation;
2. identify the authority for each connector fact instead of treating the connection record as self-authorizing;
3. write positive assertions for pin count, disposition, functional owner, semantic path, power/return/shield domains, and logical binding;
4. write negative tests that deliberately introduce plausible migration errors;
5. keep `TBD` and `VERIFY_AT_MACHINE` facts unresolved without treating incompleteness as a validator failure;
6. fail board-capture promotion when required release facts are unresolved;
7. avoid turning an ordinary FPGA/LinuxCNC mapping into personnel-safety authority;
8. separate a documentation-only test specification from executable evidence.

## Four validation layers

### 1. Structural validity

Check that the record conforms to the connection-definition mold: required sections exist, every physical position is represented exactly once, dispositions use allowed classes, and release fields are present.

Structural validity answers only: **can this record be interpreted?**

### 2. Source-authority reconciliation

For every copied or normalized physical fact, compare the record with the current pin authority. Position count, legacy NC, wire number, source power domain, shield treatment, and preserved machine-facing function must not silently change.

A changed value requires an explicit new authority; a connection record cannot override its source merely by containing a concrete value.

### 3. Cross-domain semantic reconciliation

Trace each semantic signal through the owning functional block or shared resource before reaching FPGA/LinuxCNC semantics. The validator must understand stage boundaries. A field differential pair is not the same endpoint as the receiver's single-ended logic output.

Power and return validation is similarly typed. `ENCODER_0V`, logic `GND`, field/load return, `CHASSIS_PE`, and shield/drain are not interchangeable strings.

### 4. Promotion validity

`board_capture_ready: true` is a claim, not a user preference. It may be true only when every release prerequisite is supported by current evidence and the record does not duplicate functional-block engineering.

Unresolved machine facts are allowed during integration. They are not allowed to disappear during promotion.

## Audited OpenPressBrake worked example — Y1 scale

### Student-facing files opened in current form during this run

| File | Readiness | Bounded use |
|---|---|---|
| `hardware/CONNECTION_DEFINITION_CONTRACT.md` | VERIFIED_FOR_LESSON | ownership, required fields, release gates, safety boundary |
| `hardware/connection_definition_schema.yaml` | VERIFIED_FOR_LESSON | current fail-closed mold and validation rules; still `SCHEMA_DEFINED_NOT_MIGRATED` |
| `hardware/REV1_CONNECTOR_MAP.yaml` | VERIFIED_FOR_LESSON only as bounded electrical-pinout authority; ENGINEERING_REVIEW_NEEDED as a complete physical connection set | current Y1 nine-position electrical authority and unresolved mechanical facts |
| `hardware/REV1_MACHINE_CONFIG.yaml` | VERIFIED_FOR_LESSON for bounded Y1 allocation | first machine consumes three encoder primitives and identifies Y1 as an installed encoder channel |
| `hardware/blocks/differential_encoder/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` | VERIFIED_FOR_LESSON for reusable receiver/board-consumption boundary | field A/B/Z pairs, post-receiver logic, 3V3 allocation, field +5-V and termination boundaries |
| `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json` | VERIFIED_FOR_LESSON for current semantic binding | ENC1 post-receiver A/B/Z -> FPGA A15/A14/B14 -> LiteX-CNC `encoder_1` |
| `hardware/blocks/STATUS_RULES.md` | VERIFIED_FOR_LESSON for status/evidence truthfulness | CI/test pass does not by itself establish qualification or release |

### Positive reconciliation assertions

For a future migrated `J_Y1_SCALE` connection record, require at minimum:

- connector position count equals 9;
- positions 2/7 are the B/B-bar field pair, 3/8 are Z/Z-bar, and 9/6 are A/A-bar;
- position 4 remains explicit `NC_LEGACY`;
- position 5 remains protected encoder field +5 V and is owned by a board/shared field-power resource, not by the AM26LV32E receiver's 3V3 supply;
- position 1 remains encoder field return with an explicit typed return relationship;
- connector-region shield treatment remains associated with `CHASSIS_PE` unless newer evidence explicitly changes it;
- the three differential pairs are consumed by differential-encoder instance ENC1 before FPGA mapping;
- only the post-receiver A/B/Z logic semantics map to FPGA balls A15/A14/B14 and LiteX-CNC `encoder_1`;
- no personnel-safety credit is assigned;
- termination population remains unresolved until actual cable/end-point evidence supports one assembly variant;
- exact connector MPN, footprint/pad numbering, mate, harness condition, placement/orientation and service-clearance facts remain `VERIFY_AT_MACHINE` while evidence is absent.

These checks deliberately span multiple authorities. No single file proves the whole path.

## Negative reconciliation corpus

A useful validator must reject plausible, well-formed wrong records rather than only malformed YAML. At minimum test these mutations:

| Mutation | Required result | Reason |
|---|---|---|
| change positions from 9 to 8 | reject | contradicts current pin authority |
| repurpose position 4 as a spare input | reject | violates explicit `NC_LEGACY` disposition |
| map connector A/A-bar directly to FPGA balls | reject | bypasses required AM26LV32E functional owner |
| map field A and A-bar to two independent FPGA inputs | reject | confuses differential field interface with post-receiver logic |
| make the receiver block own encoder field +5 V | reject | field supply is board/shared-resource responsibility |
| rename encoder return, logic GND and CHASSIS_PE all `GND` | reject | collapses typed return/chassis domains |
| populate 120-ohm termination without machine evidence | reject | converts `VERIFY_AT_MACHINE` into an unsupported fact |
| invent a 9-position connector MPN/footprint | reject | position count is not mechanical-part evidence |
| change ENC1 A/B/Z to another FPGA instance without updated binding authority | reject | contradicts current board resource binding |
| set `board_capture_ready: true` while connector/footprint/harness/placement facts remain unresolved | reject | promotion prerequisites are not closed |
| assign safety authority because position is used for control feedback | reject | ordinary encoder path has zero personnel-safety credit |

A validator that accepts any of these cases has a semantic coverage defect even if its schema tests are green.

## Unknowns are first-class validation states

Fail-closed does not mean every unknown makes the engineering record useless. It means the validator must distinguish:

- **KNOWN_AND_RECONCILED** — value has current supporting authority;
- **UNRESOLVED_ALLOWED_FOR_INTEGRATION** — `TBD`/`VERIFY_AT_MACHINE` is permitted at the current development gate;
- **UNRESOLVED_BLOCKS_PROMOTION** — the same unknown prevents board capture or release;
- **CONTRADICTS_AUTHORITY** — concrete value disagrees with current authority;
- **UNSUPPORTED_CONCRETE_VALUE** — a concrete value appears where only an unresolved fact is currently justified.

This prevents the common anti-pattern of filling unknown fields merely to make validation pass.

## Board-capture readiness gate

A future automated gate should compute readiness from evidence rather than trust a stored Boolean. For the current schema, promotion requires all release conditions to be supported, including exact connector freeze, verified footprint/pad mapping, electrical envelope, typed power/return/shield domains, functional-instance mapping, placement/orientation/access, silkscreen, harness compatibility, and explicit unresolved-machine-fact handling. `duplicates_functional_block_engineering` must remain false.

The current Y1 record cannot pass that gate because the project has not yet migrated a release-consumable connector instance and the physical connector/harness/placement facts remain unresolved.

## Executable validator architecture

When implementation is justified, keep the validator read-only and deterministic. Inputs should be explicit paths/revisions for:

1. source electrical pin authority;
2. one connection-definition instance;
3. relevant reusable block interface/handoff;
4. board FPGA/resource binding where applicable;
5. schema/contract version.

Emit stable diagnostic IDs such as `CONN_PIN_AUTHORITY_MISMATCH`, `CONN_NC_REPURPOSED`, `CONN_OWNER_BYPASS`, `CONN_DOMAIN_COLLAPSE`, `CONN_UNSUPPORTED_PHYSICAL_FACT`, and `CONN_PREMATURE_CAPTURE_READY`. Stable diagnostics allow later mutation testing and evidence promotion to prove which semantic rule detected each fault.

Do not make the validator an alternate engineering database. It checks authority; it does not invent connector MPNs, electrical limits, termination choices, machine wires, or FPGA allocations.

## Local-compute boundary

This run defines the validator contract and negative corpus but does **not** claim executable validator evidence. No executable verification was necessary to establish these teaching rules. If a validator/regression suite is later implemented or run, it must execute only on the OpenPressBrake self-hosted runner labeled `[self-hosted, openpressbrake]`. A hosted green workflow is not acceptable substitute evidence.

## Catalog stress-test result

The existing OpenPressBrake connection schema already contains strong fail-closed prose rules, but the audited current repository does not yet provide a release-consumable migrated Y1 connection instance plus an executable authority-reconciliation validator demonstrating these cross-file assertions. Classify that infrastructure gap as **ENGINEERING_REVIEW_NEEDED**; do not downgrade the verified bounded source artifacts themselves.

This is a catalog defect worth fixing because a human currently has to know that `REV1_CONNECTOR_MAP.yaml`, the differential-encoder handoff, the FPGA binding, and physical-machine unknowns must all be reconciled. That is precisely the unwritten-knowledge failure the reusable catalog is meant to remove.

OpenPressBrake current main also contains newer analog-input board-integration work. This lesson therefore consumes the encoder/connection sources read-only and does not modify active engineering files.

## Transfer exercise

Apply the same method to one non-safety connector on a mill, lathe, plasma table, router, robot, or custom automation controller. Create five positive cross-authority assertions and five plausible negative mutations. At least one mutation must cross a functional-block boundary, one must concern power/return/shield semantics, and one must concern an unresolved physical fact. Explain which unknowns may remain during integration and which block board-capture promotion.

The exercise is complete only when every assertion identifies the authority that proves it.

## Safety boundary

Connection validation can prove that an ordinary control signal is routed and named consistently. It cannot grant safety integrity. FPGA/LinuxCNC I/O may monitor safety status or participate in ordinary inhibits, but independent personnel-safety authority remains outside this curriculum lane unless a separately safety-rated architecture and validation explicitly establish it.

## Checkpoint

BD63 is complete. Next develop **BD64 — Connection-Definition Instance Closure and Generator-Ready Contracts**:

`validated semantic record -> physical connector evidence -> footprint/pad proof -> electrical derating -> placement/marking/harness closure -> generator inputs -> KiCad capture eligibility -> evidence lock`

Prefer a bounded non-safety connector whose physical facts can actually be supported. Do not invent machine measurements. Re-open every student-facing file in current form before assigning it.