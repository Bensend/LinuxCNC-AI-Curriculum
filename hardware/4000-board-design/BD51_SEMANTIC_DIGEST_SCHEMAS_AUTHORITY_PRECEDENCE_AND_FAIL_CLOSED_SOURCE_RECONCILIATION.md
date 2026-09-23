# BD51 — Semantic Digest Schemas, Authority Precedence, and Fail-Closed Source Reconciliation

## Purpose

BD50 established that generated-artifact equivalence needs a canonical semantic model. BD51 moves one step upstream:

`source artifacts -> authority precedence -> semantic extraction -> contradiction detection -> unresolved-fact handling -> canonical semantic digest -> generated-consumer lock -> stale-source rejection -> audit`

The design problem is not merely parsing YAML or rendering KiCad. A board generator must know which source is authoritative for each semantic facet, whether a more-specific overlay narrows a reusable contract, whether two sources contradict each other, and whether an unresolved physical-machine fact blocks only one decision or the entire design.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD50_GENERATED_ARTIFACT_EQUIVALENCE_CANONICALIZATION_AND_REPRODUCIBILITY_ACCEPTANCE.md` — **VERIFIED_FOR_LESSON** for equivalence, canonicalization, provenance, and stale-authority rules.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for the current board-design handoff.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for human-readable status authority, evidence truthfulness, maintenance, and integration-versus-qualification separation.
- OpenPressBrake `hardware/blocks/analog_output/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for current status and the explicit first-machine authority relationship.
- OpenPressBrake `hardware/blocks/analog_output/integration/REV1_COMMAND_PROFILE_OVERLAY.yaml` — **VERIFIED_FOR_LESSON** for the bounded first-machine command-profile overlay.
- OpenPressBrake `hardware/blocks/analog_output/manifest.yaml` — **ENGINEERING_REVIEW_NEEDED** as a complete current first-machine authority. It still publishes first-machine +/-10-V purpose/variant/mapping fields that the current checklist explicitly says are superseded by the Rev1 command-profile overlay. It is used only as inspected defect evidence, not as finished student authority.

The discrepancy identified in BD50 therefore still exists on current main. BD51 does not normalize it away or redesign the reusable bipolar primitive.

## Learning objectives

The student must be able to:

1. define semantic facets with stable IDs rather than treating whole files as indivisible authority;
2. separate reusable-block capability from board connection and machine-configuration constraints;
3. define explicit precedence rules for overlays without allowing arbitrary “last file wins” behavior;
4. detect contradictions before generation;
5. distinguish a legitimate narrowing constraint from an incompatible source conflict;
6. carry unresolved `VERIFY_AT_MACHINE` facts explicitly and fail closed only where they matter;
7. produce a canonical semantic digest with source/revision/evidence provenance;
8. lock generated consumers to that digest; and
9. reject stale or ambiguous source consumption.

## 1. Authority belongs to semantic facets, not filenames

A source file may be authoritative for one question and non-authoritative for another. Define stable semantic facet IDs such as:

- `block.analog_output.capability.output_voltage_range`
- `machine.rev1.x_drive.allowed_command_voltage`
- `machine.rev1.x_drive.direction_owner`
- `board.rev1.x_drive.connector_pin.command`
- `board.rev1.x_drive.connector_pin.return`
- `block.analog_output.safe_state`
- `block.analog_output.fpga.rearm_gpio_count`
- `machine.rev1.x_drive.installed_parameterization`
- `safety.rev1.x_drive.drive_active_owner`

A manifest may own reusable capability while a machine overlay owns allowed use on one machine. A connection block may own connector/pin placement without owning the reusable voltage envelope.

**FILE AUTHORITY ≠ AUTHORITY FOR EVERY FIELD IN THE FILE.**

## 2. Required authority layers

Use explicit layers rather than filename order:

1. **Reusable block contract** — generic electrical function, limits, resources, defaults, protection, dependencies.
2. **Adapter contract** — reusable electrical/protocol transformation between otherwise stable interfaces.
3. **Board-specific connection block** — connector type/pins, board mapping, placement, labels/silkscreen, harness destination.
4. **Machine/configuration overlay** — machine-specific permitted operating profile, scaling, installed parameter choices, population/use constraints.
5. **Verified physical-machine fact** — measured or inspected fact with evidence identity and date/revision.
6. **Release/configuration lock** — exact selected authorities and resolved facts for one generated candidate.

A more-specific layer may constrain use of a broader reusable capability. It may not silently rewrite the reusable block itself.

**MORE SPECIFIC CONSTRAINT ≠ REUSABLE CONTRACT REDEFINITION.**

## 3. Precedence must be declared, scoped, and type-safe

Do not implement generic “overlay wins.” Each facet declares whether narrowing is allowed.

Example schema concept:

```yaml
facet_id: machine.rev1.x_drive.allowed_command_voltage
value: [0, 10]
unit: V
owner_scope: machine_configuration
source:
  artifact: hardware/blocks/analog_output/integration/REV1_COMMAND_PROFILE_OVERLAY.yaml
  revision: <git-sha>
relationship_to_parent:
  parent_facet: block.analog_output.capability.output_voltage_range
  rule: subset_required
state: CURRENT
```

The resolver checks that `[0,10]` is a subset of the reusable `[-10,10]` capability. If an overlay demanded `[0,15]`, that is not precedence; it is an incompatibility requiring engineering review.

**PRECEDENCE ≠ PERMISSION TO VIOLATE A PARENT CONTRACT.**

## 4. Contradiction classes

Classify reconciliation results explicitly:

### `CONSISTENT`
Sources agree for the facet.

### `VALID_NARROWING`
A more-specific authority constrains a broader parent contract within its allowed envelope.

### `STALE_SHADOWED_SOURCE`
An older/lower-specificity source still contains a value explicitly superseded for this scope. It remains historical evidence but is not consumable authority for the selected configuration.

### `CONTRADICTION`
Two sources claim authority over the same scope/facet and cannot both be true.

### `BLOCKED_UNKNOWN`
The facet requires a physical-machine or configuration fact not yet established.

### `NOT_APPLICABLE`
The facet does not apply to the selected configuration.

Unknown and contradictory authority fail closed.

**LAST PARSED VALUE ≠ RESOLVED VALUE.**

## 5. Current OpenPressBrake analog-output example

Current OpenPressBrake evidence makes the distinction concrete:

- the reusable `analog_output` primitive retains `[-10,+10] V` capability;
- the current first-machine Rev1 overlay authorizes only `0..10 V` at Commander SK T4;
- B5/B6 remain separate ordinary direction inputs;
- B4/wire 63 remains owned by the retained independent Pilz safety system;
- ordinary safe/startup/reset/watchdog-clear command is 0 V;
- intentional negative T4 voltage is prohibited until configuration evidence says otherwise;
- installed Commander SK parameterization and resulting scale/direction semantics remain unresolved.

This is a legitimate `VALID_NARROWING` of reusable capability by machine configuration.

The current reusable manifest still contains first-machine `plusminus_10V` purpose/variant/mapping fields. Because the authoritative checklist explicitly says the Rev1 overlay supersedes those stale first-machine fields, those particular manifest fields are `STALE_SHADOWED_SOURCE` for first-machine command-profile generation. They are not evidence that the reusable bipolar hardware capability is obsolete.

A resolver must therefore retain both facts:

- reusable capability: `[-10,+10] V`;
- Rev1 machine allowed command: `[0,+10] V`.

Collapsing both to one generic “analog output range” destroys ownership and provenance.

## 6. Unresolved facts are first-class data

Do not replace unknowns with guessed defaults.

A semantic facet should carry:

```yaml
state: VERIFY_AT_MACHINE
required_for:
  - final_command_scaling
  - direction_interaction_commissioning
not_required_for:
  - reusable_bipolar_output_topology
  - connector_pin_identity_already_frozen
```

This allows partial deterministic closure without false finality.

**UNKNOWN FACT ≠ ZERO.**

**UNKNOWN FACT ≠ PERMISSION TO BLOCK UNRELATED FROZEN WORK.**

## 7. Canonical semantic digest

The digest input should contain normalized semantic records, not raw prose. At minimum each record carries:

- stable `facet_id`;
- semantic value and unit/type;
- owner scope;
- authority state;
- exact source artifact and revision/digest;
- parent/constraint relationship;
- evidence class: datasheet, calculation, simulation, bench, machine verification, inference, unknown;
- unresolved state if applicable;
- successor/supersession relationship;
- consumer eligibility; and
- safety-boundary classification where relevant.

Canonical ordering may sort by stable facet ID. It may normalize formatting proven non-semantic. It must not discard source identity, authority state, unresolved state, return-domain distinctions, default state, resource allocation, or safety ownership.

The resulting semantic digest identifies the resolved engineering input set for generation.

**DIGEST OF RAW FILES ≠ SEMANTIC DIGEST.**

## 8. Generated-consumer lock

Every generated board artifact should record:

- semantic-digest schema version;
- resolved semantic digest;
- exact configuration lock;
- exact source revisions consumed;
- generator/tool versions;
- unresolved facets intentionally carried forward;
- generation timestamp as provenance, not semantic authority; and
- output raw/canonical digests.

A later source change does not silently mutate an existing release. It marks affected consumers stale through dependency tracking and requires deliberate regeneration/review.

**SOURCE UPDATED ≠ RELEASE SILENTLY UPDATED.**

## 9. Fail-closed source reconciliation algorithm

Before schematic/resource/HAL generation:

1. enumerate required semantic facets from selected blocks, adapters, connection blocks, machine overlays, and board molds;
2. collect candidate source claims with exact revision identity;
3. reject unknown authority states;
4. apply only declared scope/type precedence rules;
5. verify narrowing constraints remain within parent contracts;
6. detect duplicate incompatible authority;
7. carry unresolved `VERIFY_AT_MACHINE` facets explicitly;
8. verify required facets for the requested generation stage are resolved;
9. build the canonical semantic model/digest;
10. lock the consumer to that digest; and
11. only then generate schematic, resource plan, FPGA mapping, HAL/configuration, BOM, or release artifacts.

If a required facet is `CONTRADICTION` or `BLOCKED_UNKNOWN`, generation of the dependent output stops. Do not pick the newest file, alphabetically last file, or easiest-to-parse value.

## 10. Board-specific connection blocks remain separate

A connection block can legitimately constrain:

- connector family and pinout;
- physical board edge/location;
- silkscreen/label;
- FPGA/logical mapping;
- harness/machine destination;
- board-side power/ground pins.

It must not become the hidden owner of reusable electrical protection or capability. Conversely, the reusable block must not acquire `J_X_DRIVE`, wire 128, or one-machine placement assumptions merely because those are convenient for generation.

The semantic digest joins these layers without melding them.

## 11. Adversarial exercises

### Case A — valid narrowing
Reusable block supports 0..24-V input; one machine overlay permits only 0..10 V.

Expected: `VALID_NARROWING`, provided all downstream electrical assumptions remain within the reusable envelope.

### Case B — invalid widening
Reusable block is qualified to 24 V; overlay requests 30 V.

Expected: `CONTRADICTION`/engineering change, not “overlay wins.”

### Case C — stale manifest shadow
A current machine overlay supersedes a copied machine-specific field in a generic manifest.

Expected: mark the stale field `STALE_SHADOWED_SOURCE` for that scope, retain historical provenance, and consume the current overlay.

### Case D — unresolved return join
Connector pin and field return are known, but whether that return may join logic/chassis depends on machine verification.

Expected: generate only artifacts that do not require the join decision; block any artifact that would make the join implicitly.

### Case E — safety authority collision
Ordinary controller mapping claims ownership of a signal already declared retained independent safety authority.

Expected: `CONTRADICTION`; ordinary-controller generation must fail closed. Do not resolve by precedence in favor of normal control.

## 12. Verification and compute

This lesson establishes source-reconciliation semantics from inspected repository evidence; no simulation, synthesis, place-and-route, timing, or other executable engineering verification is required.

When a resolved semantic change later requires executable verification, use only the local OpenPressBrake panel PC through `[self-hosted, openpressbrake]`. If unavailable, mark the gate `BLOCKED/NOT_RUN`; never substitute GitHub-hosted Actions minutes.

## 13. Safety boundary

Authority reconciliation must preserve the boundary between ordinary controller functions and independent personnel safety. A semantic digest may record that ordinary logic monitors safety status or requests STO/enable behavior, but it cannot promote that ordinary path into safety authority.

In the current bounded example, B4/wire 63 remains retained independent Pilz authority. Any ordinary-controller source claiming otherwise is a contradiction requiring engineering review, not a precedence choice.

**AUTHORITY PRECEDENCE ≠ SAFETY AUTHORITY TRANSFER.**

## Lab — build and reconcile a semantic digest

Given a reusable block manifest, board connection definition, machine overlay, status checklist, and one unresolved physical-machine fact:

1. define stable semantic facet IDs;
2. identify owner scope for every facet;
3. record exact source revision/digest;
4. classify each source claim as current, stale/shadowed, unresolved, or contradictory;
5. prove every narrowing is within the parent reusable contract;
6. identify outputs that may still be generated under partial closure;
7. identify outputs that must fail closed;
8. produce a canonical semantic model and digest input record;
9. produce a generated-consumer lock; and
10. show how a later source change would mark consumers stale.

The evaluator must reject any solution that uses filename order, newest-file wins, blanket overlay precedence, guessed machine facts, or merged reusable/connection ownership.

## Catalog stress-test result

The current analog-output discrepancy confirms that OpenPressBrake needs a machine-readable authority-reconciliation layer rather than additional prose alone. The minimum durable infrastructure is:

- stable semantic facet IDs;
- scoped authority ownership;
- explicit parent/narrowing relationships;
- current/superseded/shadowed/unresolved states;
- exact source revision/evidence identity;
- contradiction detection;
- `VERIFY_AT_MACHINE` dependency reach;
- canonical semantic digest generation;
- consumer locks; and
- reverse lookup from changed facets to generated consumers.

This remains **ENGINEERING_REVIEW_NEEDED**. Because active OpenPressBrake board development is moving, BD51 records the defect without editing the analog-output implementation files in parallel.

## Durable rules frozen by BD51

- authority belongs to semantic facets, not entire filenames;
- file authority does not imply authority for every field in that file;
- more-specific constraints may narrow but may not silently redefine reusable capability;
- precedence is scoped and type-safe, never generic “overlay wins”;
- last parsed value is not a resolved value;
- stale shadowed evidence remains recoverable but is not consumable for the superseded scope;
- unknown physical facts remain explicit `VERIFY_AT_MACHINE` data;
- unknown facts neither become guessed defaults nor unnecessarily block unrelated frozen work;
- a semantic digest includes authority/provenance, not only electrical values;
- generated consumers lock to exact semantic input identity;
- ordinary-control authority reconciliation cannot transfer independent personnel-safety authority.

## Next exact work

Build BD52 on **semantic-schema evolution, backward compatibility, and migration safety**:

`existing semantic digests -> schema change -> compatibility classification -> migration transform -> loss/ambiguity detection -> consumer revalidation -> dual-read transition -> old-schema retirement -> audit`

Stress renames versus meaning changes, unit migrations, splitting one overloaded facet into reusable capability plus machine constraint, adding a previously implicit return/default/resource facet, and migration of historical release locks without rewriting history.