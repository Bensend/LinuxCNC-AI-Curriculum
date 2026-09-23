# BD65 — KiCad Connection Generation, Provenance-Carrying Capture, and ERC Boundaries

Status: student-ready method lesson with audited fail-closed OpenPressBrake fixture  
Lane: independent BOARD-DESIGN CURRICULUM  
OpenPressBrake source revision inspected: `857108dc70c62bf4734dee5f4009f479d4ae51d4`

## Purpose

BD64 established that semantic closure is not physical closure and that a connection instance is not production-capture eligible until connector, footprint, electrical envelope, placement, marking, harness and evidence prerequisites close. BD65 addresses the next failure mode: assuming that deterministic KiCad generation or clean ERC proves those prerequisites.

The flow is:

`capture-eligible instance -> deterministic KiCad objects -> provenance metadata -> ERC -> semantic reconciliation -> generated-artifact diff -> evidence lock -> board-integration acceptance`

The central rule is: **GENERATED != ENGINEERED, and ERC-CLEAN != AUTHORITY-VALID.**

## Learning objectives

The student can:

1. distinguish generator input authority from generator output;
2. define deterministic generation for connector symbol, footprint, pins, nets, labels and constraints;
3. carry source provenance into generated capture;
4. explain exactly what KiCad ERC can and cannot prove;
5. reconcile generated objects back to semantic owners and typed return domains;
6. compare regenerated artifacts semantically rather than trusting a visually unchanged schematic;
7. lock generated artifacts to exact consumed authorities and invalidate them on drift;
8. use a fail-closed review fixture when no production-capture-eligible connector exists.

## Student-facing source audit

Every file named below was opened in its current form during this run.

| File | Readiness | Bounded use |
|---|---|---|
| `hardware/CONNECTION_DEFINITION_CONTRACT.md` | VERIFIED_FOR_LESSON | connection ownership, machine-readable handoff, release gates and generator fail-closed rule |
| `hardware/connection_definition_schema.yaml` | VERIFIED_FOR_LESSON | current fail-closed mold; checkpoint is still `SCHEMA_DEFINED_NOT_MIGRATED` |
| `hardware/blocks/STATUS_RULES.md` | VERIFIED_FOR_LESSON | evidence truthfulness and the rule that passing automation proves only the checks actually executed |
| `board-design/BD64_CONNECTION_INSTANCE_CLOSURE_GENERATOR_READY.md` | VERIFIED_FOR_LESSON | prerequisite closure facets, evidence lock and board-capture eligibility method |

No audited OpenPressBrake connection instance is presented here as production-capture eligible. Current schema authority explicitly says migration is not complete and leaves connector/footprint/placement/mating facts unresolved. Therefore this lesson uses a **review-only fail-closed generator fixture**, not a production OpenPressBrake connector capture.

## 1. Generator input contract

A production-intent generator may consume only facts that have already crossed the BD64 closure gates. Its input should identify at minimum:

- board/revision and connection-instance ID;
- exact connector MPN and evidence;
- verified KiCad symbol/pin model;
- exact footprint and independently verified pad mapping;
- every physical contact and explicit disposition;
- semantic net and functional owner for every active contact;
- typed power, signal-return, field-return, chassis/PE and shield domains;
- supported electrical envelope and derating basis;
- placement/orientation/access/keepout constraints;
- silkscreen and service markings;
- mate/harness decision;
- source authority revisions/digests;
- generator version/configuration.

The generator must reject production mode when any required closure fact is `TBD`, `VERIFY_AT_MACHINE`, contradictory, or unsupported.

## 2. Deterministic generated objects

For the same locked input and generator version, generation should produce the same engineering meaning. At minimum it must deterministically resolve:

- connector reference and value/MPN;
- symbol pin numbers;
- footprint pad numbers;
- pin-to-net assignments;
- explicit NC/reserved/key/shield dispositions;
- functional-owner references;
- power/return/chassis distinctions;
- footprint identity;
- required labels and polarity/orientation marks;
- applicable placement/keepout metadata.

Formatting UUIDs or KiCad serialization details may vary when the toolchain requires it; acceptance must therefore compare semantic objects as well as raw files.

## 3. Provenance-carrying capture

Each generated connection object should retain enough metadata to answer:

**Why does this object exist, and which exact authority supplied its value?**

A practical provenance record includes:

- connection-instance stable ID;
- source repository commit;
- schema/contract version;
- source pin-authority digest;
- functional block/resource-contract IDs and revisions;
- connector manufacturer-document identity/revision;
- footprint-library path plus digest/revision;
- machine-survey evidence ID when physical facts came from the installed machine;
- generator name/version/configuration digest;
- generation timestamp as traceability only, never as authority.

Do not encode provenance only in a human comment that downstream tooling cannot reconcile.

## 4. ERC boundary

KiCad ERC is valuable downstream evidence for electrical capture consistency. Depending on the symbol/pin types and rules, it can expose classes of problems such as incompatible pin electrical types, unconnected required pins, missing power-driver declarations, or conflicting electrical connections.

ERC does **not** establish:

- that the selected connector is the connector on the machine;
- that symbol pin numbers match the manufacturer's physical contact numbering;
- that footprint pads match the frozen connector drawing;
- that current, voltage, conductor or simultaneous-contact derating is adequate;
- that a return was assigned to the correct engineering domain before capture;
- that a shield/chassis strategy is correct;
- that placement, cable bend, service access or mating clearance is adequate;
- that the retained harness fits or is in acceptable condition;
- that a reusable block is qualified;
- that an ordinary controller path has personnel-safety authority.

Therefore `ERC PASS` may promote only claims that the executed ERC rules actually test.

## 5. Fail-closed OpenPressBrake fixture

Current OpenPressBrake authority still reports `SCHEMA_DEFINED_NOT_MIGRATED`. The schema itself contains unresolved connector manufacturer/family/MPN, footprint, mating hardware, electrical-envelope and placement fields. A production generator must therefore refuse to emit a release-consumable connector from that mold alone.

A teaching/review fixture may instead use explicit non-production placeholders if and only if:

1. its artifact is visibly marked `REVIEW_ONLY_NOT_BOARD_CAPTURE`;
2. no placeholder footprint can be mistaken for a released production footprint;
3. unresolved fields remain literal `TBD`/`VERIFY_AT_MACHINE` in the source record;
4. the fixture demonstrates mapping/provenance mechanics rather than claiming physical correctness;
5. it cannot satisfy the production promotion gate.

This is preferable to inventing a connector merely so ERC can run.

## 6. Semantic reconciliation after generation

After generation, independently reconcile the generated capture against the locked input:

- same physical contact count and numbering;
- same explicit disposition for every contact;
- same semantic net names;
- same functional owner/instance/interface;
- no direct field-to-FPGA shortcut across an owned interface block;
- no collapsed signal-return/field-return/chassis/shield domains;
- same exact connector and footprint IDs;
- same required markings and placement constraints;
- no new net, join, alias or NC repurpose introduced by rendering.

Generation success is not reconciliation success.

## 7. Generated-artifact diff

On regeneration, compare at two levels.

**Raw artifact diff** catches serialization and visible CAD changes.

**Semantic diff** compares normalized connector identity, contact disposition, net ownership, power/return domains, footprint/pad mapping, placement constraints, markings and evidence locks.

A raw diff with no semantic change may require no engineering requalification. A semantic change with a visually small diff can invalidate downstream evidence. Conversely, an unchanged generated file does not prove current validity if an authority changed but happened to render the same output.

## 8. Evidence lock and promotion

A generated artifact can advance to board integration only when:

- the source connection instance is `BOARD_CAPTURE_ELIGIBLE`;
- exact consumed authority revisions/digests are recorded;
- generation completed without unresolved production fields;
- semantic reconciliation passed;
- required ERC was run against the generated/current design and its exact rule configuration is identified;
- every ERC waiver has an engineering owner and rationale;
- generated-artifact semantic diff is reviewed;
- dependencies are re-resolved against current main immediately before promotion.

If an authority, footprint, block contract, resource allocation or machine fact changed materially, invalidate only the affected claims and rerun the minimum justified checks. Do not preserve a stale capture because ERC remains green.

## 9. Negative cases

Reject these arguments:

- `KiCad generated it, therefore the connector is correct.`
- `ERC is clean, therefore the footprint is correct.`
- `The footprint has the right number of pads, therefore pad numbering is proved.`
- `The net names look right, therefore field and chassis returns are correctly owned.`
- `The regenerated schematic is byte-identical, therefore changed source authority is irrelevant.`
- `A review placeholder survived ERC, therefore it can become the production connector.`
- `CI passed, therefore the connection or block is qualified.`

## Catalog stress-test result

The OpenPressBrake connection architecture has a strong fail-closed ownership contract, but current main still lacks a migrated, release-consumable connection instance that can serve as a truthful production KiCad-generation example. That remains **ENGINEERING_REVIEW_NEEDED** infrastructure.

BD65 exposes two tooling requirements for later engineering work:

1. a production generator must enforce BD64 facet closure rather than accepting any schema-shaped record; and
2. generated KiCad objects need machine-readable provenance plus semantic-diff/reconciliation support so CAD output can be traced back to exact connection, block, resource and physical evidence.

Do not solve this curriculum gap by weakening the release gate or choosing convenient connector hardware.

## Transfer exercise

For a mill, lathe, plasma table, router, robot, press brake or custom automation board, take one already closed ordinary non-safety connector. Define the generator inputs and provenance record, list which ERC assertions are meaningful, and list at least five required facts ERC cannot establish. Then define the semantic diff that would detect a changed return domain or pin mapping even if the schematic still looks visually reasonable.

## Safety boundary

KiCad capture, ERC and generator provenance are ordinary engineering controls. They do not grant personnel-safety authority. A safety-rated function requires its own architecture, evidence and validation.

## Checkpoint

BD65 is complete. Next develop **BD66 — Schematic Integration Reconciliation and Cross-Block Net Ownership**:

`generated/captured blocks + connection definitions + shared resources -> complete schematic net graph -> owner/driver/load/return reconciliation -> power-domain and authority checks -> ERC/structural evidence -> integration defect loop -> accepted schematic baseline`

Use current OpenPressBrake integration evidence only within its actual maturity. Do not call the current board production-proven.