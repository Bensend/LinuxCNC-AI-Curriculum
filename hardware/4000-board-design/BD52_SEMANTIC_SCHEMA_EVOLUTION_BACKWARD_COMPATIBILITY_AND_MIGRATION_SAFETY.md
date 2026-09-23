# BD52 — Semantic-Schema Evolution, Backward Compatibility, and Migration Safety

## Purpose

BD51 established a canonical semantic digest with scoped authority and fail-closed reconciliation. BD52 addresses what happens when that semantic schema itself must change:

`existing semantic digests -> schema change -> compatibility classification -> migration transform -> loss/ambiguity detection -> consumer revalidation -> dual-read transition -> old-schema retirement -> audit`

A schema migration is an engineering change, not clerical serialization maintenance. Renaming a key can be non-semantic; changing units can be mechanically lossless; splitting an overloaded field can expose previously hidden ownership; adding a previously implicit return, default-state, resource, or safety-boundary facet can make an old record impossible to migrate without new evidence.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD51_SEMANTIC_DIGEST_SCHEMAS_AUTHORITY_PRECEDENCE_AND_FAIL_CLOSED_SOURCE_RECONCILIATION.md` — **VERIFIED_FOR_LESSON** for semantic-facet authority, canonical digests, unresolved facts, and consumer locks.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for the board-design handoff through BD51.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for evidence truthfulness, status authority, integration-versus-qualification separation, and maintenance requirements.
- OpenPressBrake `hardware/blocks/analog_input/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for current analog-input status and current reconciled Rev31 authority state.
- OpenPressBrake `hardware/blocks/analog_input/design/REV31_SHARED_ADC_CONSUMER_RECONCILIATION.md` — **VERIFIED_FOR_LESSON** as the historical/current authority-transition record for the 100-ohm burden, REF5020/Range-2 converter contract, shared acquisition ownership, and stale-value prohibition.
- OpenPressBrake `hardware/blocks/analog_input/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` — **VERIFIED_FOR_LESSON** for current board-consumption/resource boundaries and unresolved machine facts.

The analog-input block is **not** presented as schematic-ready or Rev-1 released. Its current checklist explicitly keeps validator execution, CAD assets, final accuracy/fault work, board integration, and human release open.

## Learning objectives

The student must be able to:

1. distinguish serialization-only schema edits from semantic contract changes;
2. classify schema changes by compatibility and migration risk;
3. preserve stable semantic identity across harmless renames;
4. perform exact unit migration without changing physical meaning;
5. split overloaded facets without inventing missing ownership or values;
6. represent newly explicit facts as unresolved when historical evidence cannot establish them;
7. preserve historical release locks under their original schema rather than rewriting history;
8. support bounded dual-read/dual-version transitions without accepting ambiguous mixed authority;
9. revalidate consumers according to changed semantic reach; and
10. retire an old schema only after remaining consumers and historical reconstruction are accounted for.

## 1. Schema version is part of engineering identity

Every semantic digest and generated-consumer lock shall identify the schema used to interpret it.

A digest value without its schema is not self-describing. The same serialized field name can acquire a different meaning over time, and a later parser can otherwise reinterpret an old release silently.

**SAME FIELD NAME ≠ SAME SEMANTIC CONTRACT.**

**NEW PARSER CAN READ OLD BYTES ≠ OLD ENGINEERING MEANING PRESERVED.**

Historical release identity therefore includes at least:

- schema identifier and version;
- semantic digest under that schema;
- exact source/revision identities;
- migration state, if any;
- generated-consumer identity; and
- unresolved/unknown facts as they were known at release time.

## 2. Compatibility classes

Classify every schema change before migration.

### `REPRESENTATION_ONLY`
Formatting or serialization changes with a proven one-to-one semantic mapping. Examples: key ordering, whitespace, or a field rename where the stable facet ID and meaning remain unchanged.

### `LOSSLESS_SEMANTIC_MIGRATION`
Representation changes but physical meaning can be transformed exactly. Example: volts to millivolts when units are explicit and the transform is exact for the stored precision.

### `SEMANTIC_SPLIT_OR_MERGE`
One old field becomes multiple authority-owned facets, or multiple facets are combined. This requires evidence that each resulting value and owner can be reconstructed. If not, migration is blocked or partial.

### `NEW_REQUIRED_FACET`
The new schema makes a previously implicit engineering question explicit: return domain, startup/default state, enable authority, shared-resource demand, connector ownership, fault behavior, or safety-boundary owner. Old data cannot be assigned a value merely because old designs functioned.

### `MEANING_CHANGE`
A facet's physical meaning, scope, allowed envelope, authority owner, or interpretation changes. This is an engineering change and requires dependency impact analysis and consumer revalidation; it is not a compatibility transform.

### `NON_MIGRATABLE_AMBIGUITY`
Available historical evidence supports more than one plausible new representation or none. Preserve the old record and mark the new facet `UNKNOWN`/`VERIFY_AT_MACHINE`/engineering-review-needed as appropriate.

## 3. Stable semantic IDs survive harmless renames

A display/key rename such as:

`adc_range_v` -> `converter.input_span_v`

is representation-only only if the stable semantic facet identity, owner, unit, envelope, and evidence meaning remain unchanged.

Do not create a new semantic ID merely because prose or serialization improves. Conversely, do not retain an old ID if its engineering meaning changed.

**KEY RENAME ≠ NEW ENGINEERING FACT.**

**REUSED ID ≠ PERMISSION TO CHANGE MEANING.**

A migration record should contain old key/path, new key/path, stable facet ID, transform, compatibility class, and proof/rationale.

## 4. Unit migration must preserve dimensional meaning

For an exact unit migration, carry both source and target units and define the transform explicitly.

Example:

```yaml
facet_id: block.analog_input.burden.resistance
from:
  schema: semantic-digest/v1
  value: 0.1
  unit: kohm
to:
  schema: semantic-digest/v2
  value: 100
  unit: ohm
transform: multiply_by_1000
classification: LOSSLESS_SEMANTIC_MIGRATION
```

The migration must fail if the old record omitted units or if precision/rounding can change a limit decision.

**NUMERICALLY CONVERTIBLE ≠ ENGINEERING-EQUIVALENT WHEN UNITS OR PRECISION ARE AMBIGUOUS.**

Limit values, tolerances, temperatures, timing, current, voltage, resistance, capacitance, frequency, and resource quantities all require typed units or explicit dimensionless classification.

## 5. Splitting an overloaded facet exposes ownership

Suppose an old schema had:

`analog_input.adc_path = "0..5V direct"`

A newer architecture needs separate facets for:

- reusable sensor/burden capability;
- semantic ADC sample-node handoff;
- shared ADC reference/range;
- shared acquisition-driver ownership;
- board physical channel allocation;
- scan order/settling contract.

There is no safe generic transform from the old overloaded string into all new facets unless historical evidence establishes each one.

This is exactly the kind of weakness the block catalog must expose rather than hide.

**ONE OLD FIELD -> MANY NEW FIELDS ≠ VALUES MAY BE INFERRED.**

A migration may populate proven facets and leave the rest unresolved. Partial migration is preferable to fabricated completeness.

## 6. Current OpenPressBrake analog-input stress test

Current analog-input authority demonstrates a real authority evolution without claiming production completion.

The Rev31 reconciliation records that older descriptions used a superseded 120-ohm / approximately 0..5-V / per-channel direct-drive 49.9-ohm path, while current Rev1 authority uses a 100-ohm burden, REF5020 2.048-V reference, ADS7953 Range 2 with nominal 0..4.096-V span, and a shared converter-owned MXO/OPA192 acquisition driver. It also separates analog-input primitive ownership from board ADC-channel allocation and shared-converter acquisition ownership.

A future semantic schema must not migrate a historical overloaded `adc_path` field by simply substituting the newest values. Historical records retain what they actually meant. Current candidates consume the reconciled facets.

For a current Rev1 candidate, the new semantic model can truthfully carry:

- one-channel reusable primitive;
- 100-ohm burden identity;
- semantic `ADC_SAMPLE_NODE` consumption;
- one board-allocated ADS7953 physical channel per primitive;
- shared converter/reference/acquisition circuitry counted once;
- zero direct FPGA GPIOs for the primitive;
- up to 1.75 mA `5V_MAIN` TPS26612 bias demand per powered-transmitter channel;
- separate `24V_SENSOR_SOURCE` field-power demand; and
- unresolved `ANALOG_GND` relationship to chassis/PE/machine return as a board/machine-close fact.

The final grounding relationship must not be backfilled into historical or current digests without evidence.

## 7. Adding a previously implicit facet

When a new schema adds a required facet such as:

- `return_domain`;
- `startup_state`;
- `deenergized_state`;
- `enable_owner`;
- `fpga_gpio_count`;
- `shared_resource_owner`;
- `fault_containment_boundary`; or
- `personnel_safety_authority`,

old records have three possible outcomes:

1. evidence proves the value -> migrate with provenance;
2. evidence proves the facet did not apply -> `NOT_APPLICABLE` with rationale;
3. evidence does not prove it -> `UNKNOWN` / `VERIFY_AT_MACHINE` / `ENGINEERING_REVIEW_NEEDED`.

Never use a parser default to manufacture engineering history.

**NEW REQUIRED FIELD DEFAULT ≠ HISTORICAL ENGINEERING FACT.**

## 8. Historical releases are immutable evidence

Do not rewrite a released v1 semantic digest into v2 and pretend v2 was the original release record.

Preserve:

- original schema and digest;
- original sources and generated artifacts;
- original unresolved facts;
- later migration transform/version;
- migrated view, if one can be produced; and
- any ambiguity or evidence added after release.

The migrated view is a derived interpretation, not replacement history.

**MIGRATED VIEW ≠ ORIGINAL RELEASE IDENTITY.**

This matters for field service, rollback, nonconformance investigation, and proving which assumptions were actually present when a board was built.

## 9. Consumer revalidation follows semantic reach

After schema migration, classify each consumer:

- `UNCHANGED_SEMANTICS` — representation-only migration; consumer may retain engineering evidence if canonical semantic equivalence is proved.
- `REENCODED_EQUIVALENT` — exact unit/type migration; verify canonical equivalence and tool interpretation.
- `NEWLY_EXPLICIT_DEPENDENCY` — old consumer did not declare a now-required facet; consumer becomes stale until that dependency is resolved/reviewed.
- `MEANING_CHANGED` — affected engineering evidence is stale; perform targeted regression according to dependency reach.
- `AMBIGUOUS_MIGRATION` — generation/release fails closed until resolved.

Do not invalidate every qualification result because a YAML key changed. Do not preserve every result merely because the generated schematic looks the same.

**SCHEMA CHANGE ≠ AUTOMATIC FULL REQUALIFICATION.**

**SCHEMA CHANGE ≠ AUTOMATIC EVIDENCE PRESERVATION.**

## 10. Dual-read transition

During a bounded migration window, tooling may read both old and new schema versions only if:

- schema version is explicit;
- each parser has a defined semantic contract;
- old-to-new transforms are versioned and tested;
- ambiguous transforms fail closed;
- generated candidates lock to exactly one resolved canonical semantic model;
- mixed old/new claims cannot silently override one another; and
- retirement criteria are defined before the transition is declared complete.

A writer should normally emit only the new schema once migration begins. Continuing to generate new old-schema authority creates fresh debt.

**DUAL READ ≠ DUAL AUTHORITY.**

## 11. Old-schema retirement gate

Retire old-schema consumption for new design only when:

1. all current-authority sources have migrated or have explicit exceptions;
2. reverse dependency search finds no new-build consumer requiring old-schema interpretation;
3. historical releases remain reconstructable with the archived old parser/schema or a proven migration view;
4. ambiguous records are explicitly quarantined rather than silently converted;
5. generated-output equivalence has been reviewed where claimed;
6. release tooling rejects accidental creation of new old-schema authority; and
7. migration evidence is retained.

Historical readers may remain for service/reconstruction after new-build consumption is retired.

**OLD SCHEMA RETIRED FOR NEW BUILD ≠ HISTORICAL EVIDENCE DELETED.**

## 12. Migration manifest

A durable migration should publish a machine-readable manifest containing at least:

```yaml
migration_id: semantic-digest-v1-to-v2
from_schema: semantic-digest/v1
to_schema: semantic-digest/v2
rules:
  - facet_id: block.analog_input.burden.resistance
    classification: LOSSLESS_SEMANTIC_MIGRATION
    transform: kohm_to_ohm
  - old_facet: analog_input.adc_path
    classification: SEMANTIC_SPLIT_OR_MERGE
    outputs:
      - block.analog_input.sample_node
      - shared_adc.reference_voltage
      - shared_adc.input_span
      - board.adc.channel_allocation
    unresolved_if_missing_evidence: true
retirement:
  new_build_old_schema_allowed: false
  historical_read_required: true
```

The manifest is migration logic, not authority to invent facts.

## 13. Adversarial exercises

### Case A — harmless rename
`fpga_gpio_count` becomes `resources.fpga.gpio.count`, stable facet ID unchanged.

Expected: `REPRESENTATION_ONLY`; prove canonical semantics unchanged.

### Case B — volts to millivolts
A 4.096-V span becomes 4096 mV with explicit units.

Expected: `LOSSLESS_SEMANTIC_MIGRATION` only if precision and limit behavior are preserved.

### Case C — overloaded analog path split
Old record says `0..5V direct`; new schema separates burden, shared ADC reference/range, acquisition ownership, physical channel allocation, and scan order.

Expected: migrate only values supported by exact historical evidence; unresolved facets block dependent consumers.

### Case D — new return-domain facet
Old connection data names `GND` but does not prove whether it was logic, analog, chassis, PE, or field return.

Expected: `NON_MIGRATABLE_AMBIGUITY`; do not map `GND` to `ANALOG_GND` by name similarity.

### Case E — new safety-owner facet
Old ordinary-control configuration contains an enable signal but does not establish personnel-safety authority.

Expected: ordinary-control ownership remains ordinary control. New safety-authority facet stays unknown/not-applicable as justified; migration cannot confer safety status.

## 14. Catalog stress-test result

The current analog-input history shows that the catalog needs versioned semantic-schema and migration infrastructure in addition to per-block authority files. A robust layer should provide:

- schema IDs/versions;
- stable facet IDs independent of serialization keys;
- typed units and precision rules;
- versioned migration manifests;
- compatibility classes;
- partial-migration/unresolved states;
- immutable historical digest retention;
- consumer stale/revalidation propagation;
- dual-read transition controls;
- new-build retirement gates; and
- reverse lookup for old-schema consumers.

This remains **ENGINEERING_REVIEW_NEEDED**. Active OpenPressBrake analog-input integration is moving on current main, so this lesson consumes it read-only rather than editing its authority files in parallel.

## 15. Verification and compute

BD52 is a documentation/source-reconciliation lesson. No simulation, synthesis, place-and-route, timing, or other executable engineering verification is required to establish these migration rules.

If a later migration changes executable FPGA/resource/timing behavior or requires regression, run it only on `[self-hosted, openpressbrake]`. If that runner is unavailable, record the gate `BLOCKED/NOT_RUN`; never substitute GitHub-hosted compute.

## 16. Safety boundary

Schema migration cannot upgrade ordinary controller evidence into personnel-safety evidence. Safety ownership, validation status, stopping behavior, final-element proof, PL/SIL/category claims, and physical-machine facts must retain their own authority and provenance.

**SCHEMA MIGRATION ≠ SAFETY VALIDATION.**

## Lab — migrate a semantic digest without rewriting history

Given one old semantic digest, current block authority, a board connection definition, and a new schema:

1. classify every schema delta;
2. preserve stable IDs for representation-only changes;
3. define exact unit transforms;
4. identify splits/merges and their authority owners;
5. mark newly explicit but unsupported facets unresolved;
6. create a versioned migration manifest;
7. generate a migrated view while preserving the original digest;
8. classify each consumer's revalidation state;
9. define a dual-read transition and retirement gate; and
10. demonstrate that an ambiguous return/default/safety-owner fact fails closed rather than receiving a guessed default.

The evaluator must reject any migration that rewrites historical release identity, silently fills new required fields, merges reusable and board ownership, treats parser success as semantic equivalence, or transfers personnel-safety authority.

## Durable rules frozen by BD52

- schema version is part of engineering identity;
- same field name does not guarantee same semantic contract;
- stable semantic IDs survive harmless serialization renames but not meaning changes;
- unit migrations require explicit dimensions, precision, and exact transforms;
- overloaded-facet splits may migrate only what evidence proves;
- newly explicit facets remain unknown when historical evidence is absent;
- parser defaults do not create historical engineering facts;
- migrated views never replace original release digests;
- schema-change regression scope follows semantic dependency reach;
- dual read is not dual authority;
- old-schema new-build retirement does not delete historical evidence;
- schema migration cannot transfer or manufacture personnel-safety authority.

## Next exact work

Build BD53 on **semantic migration verification, golden corpora, and negative compatibility tests**:

`migration rules -> representative historical corpus -> expected canonical outputs -> negative/ambiguous cases -> round-trip/loss checks -> consumer-impact oracle -> regression gate -> migration release`

Stress validators that merely parse successfully, transforms that round-trip bytes but lose provenance, hidden unit precision changes, stale historical fixtures, and negative cases proving ambiguous return/default/resource/safety ownership is rejected.