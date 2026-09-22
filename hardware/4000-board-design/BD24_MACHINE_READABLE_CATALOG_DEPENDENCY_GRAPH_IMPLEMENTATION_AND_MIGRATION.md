# BD24 — Machine-Readable Catalog Dependency Graph Implementation and Migration

## Purpose

BD23 established stable semantic IDs, exact revisions, declared dependencies, reverse `SHOW WHERE USED`, and stale-state propagation as engineering requirements. BD24 asks the implementation question: **how can a live hardware catalog adopt those rules incrementally without breaking current engineering authority, inventing facts, or treating ordinary Git/file churn as electrical change?**

This lesson develops both linked skills:

1. **block engineering** — register reusable requirements/interfaces/resources/assumptions with stable ownership, revision semantics, evidence, supersession, and dependency edges; and
2. **board integration** — consume exact registered propositions, generate reverse impact indexes, fail closed on unresolved/deleted dependencies, and migrate board composition without leaking board-specific mapping into reusable blocks.

The worked migration below is deliberately fictional/generic. Current OpenPressBrake governance is used only to establish architectural constraints; this lesson does not invent OpenPressBrake interface IDs or migrate active OpenPressBrake blocks prematurely.

## Student-material verification status for this run

The following current files were opened and inspected before this lesson was written:

- Curriculum `hardware/4000-board-design/BD23_INTERFACE_CONTRACT_SCHEMA_STABLE_IDS_AND_CHANGE_IMPACT_INVALIDATION.md` — **VERIFIED_FOR_LESSON** as the prerequisite semantic-ID/revision/dependency model.
- Curriculum `hardware/4000-board-design/BD22_BOUNDARY_COMPATIBILITY_MATRICES_AND_MACHINE_READABLE_INTERFACE_MATCHING.md` — **VERIFIED_FOR_LESSON** for fail-closed compatibility fields and `KNOWN | NOT_APPLICABLE | VERIFY_AT_MACHINE | UNKNOWN` semantics.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — **VERIFIED_FOR_LESSON** for the exact BD24 work item and current board-design lane state.
- Curriculum `WORK_SELECTION_POLICY.md` — **VERIFIED_FOR_LESSON** for independent-lane selection and branch-local blocking.
- Curriculum `SOURCE_POLICY.md` — **VERIFIED_FOR_LESSON** for evidence/provenance/conflict rules and the public-repository boundary.
- OpenPressBrake `hardware/blocks/BLOCK_DEVELOPMENT_TEMPLATE.md` — **VERIFIED_FOR_LESSON** for reusable-block ownership, semantic interfaces, shared resources, provenance, exact-connectivity handoff, and reuse boundaries. It does not currently define the repository-wide graph implemented here.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for integration versus qualification gates and same-change status maintenance.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for immutable reusable contracts during composition, adapter ownership, board-only mapping, and fail-closed unresolved machine facts.

Readiness is claim-scoped. None of these labels establishes production readiness of the complete OpenPressBrake controller.

---

## 1. Implement a registry, not a second source of electrical truth

The dependency layer must identify and connect engineering propositions; it must not become a parallel place where engineers manually retype electrical values.

A registry entry should point to the owning artifact and identify the proposition/revision it publishes:

```yaml
schema_version: 1
items:
  - id: IF.GENERIC.GPIO_3V3.PUSHPULL_OUT
    kind: interface
    revision: 1
    owner: reusable_catalog
    authority:
      path: catalog/gpio_3v3_output.yaml
      selector: interface
    status: ACTIVE
```

The authoritative interface values remain in the owning contract. The registry owns identity, discoverability, uniqueness, revision linkage, lifecycle state, and dependency navigation.

Freeze:

> **REGISTRY != DUPLICATED ELECTRICAL AUTHORITY**

If the registry copies thresholds, voltages, reset behavior, or protection envelopes, it creates another stale-data problem instead of solving one.

---

## 2. Namespace ownership

Stable IDs need owners. A practical namespace policy can reserve families such as:

- `REQ.*` — reusable or board requirement propositions;
- `IF.*` — electrical/logical interface propositions;
- `RES.*` — power, FPGA, bus, clock, ADC/DAC, or other reusable resource propositions;
- `ASM.*` — assumptions and `VERIFY_AT_MACHINE` facts;
- `EVD.*` — evidence propositions where stable reference is useful;
- `BND.*` — board boundary decisions;
- `CONN.*` — board-specific connection definitions;
- `QUAL.*` — qualification/release propositions.

Namespace ownership prevents two teams from independently creating the same apparent identity for different meanings.

Minimum registry checks:

1. ID syntax valid;
2. ID globally unique within the catalog scope;
3. owner declared;
4. kind allowed for namespace;
5. positive semantic revision present;
6. authority target exists;
7. lifecycle state valid;
8. supersession/alias target valid when present.

Do not encode a Git SHA or file path into the stable ID. Those identify storage/revision context, not engineering meaning.

---

## 3. Forward dependencies are authoritative; reverse indexes are generated

Consumers declare forward edges:

```yaml
id: BND.GENERIC.DRIVE_ENABLE
revision: 2
depends_on:
  - id: IF.GENERIC.GPIO_3V3.PUSHPULL_OUT
    revision: 1
    facets: [logic.direction, logic.drive, lifecycle.reset_behavior]
  - id: IF.GENERIC.ENABLE_INPUT_3V3
    revision: 3
    facets: [logic.thresholds, lifecycle.unpowered_behavior]
validation_state: CURRENT
```

The catalog tool generates reverse lookup:

```text
SHOW WHERE USED IF.GENERIC.GPIO_3V3.PUSHPULL_OUT@1
  BND.GENERIC.DRIVE_ENABLE@2
    facets: logic.direction, logic.drive, lifecycle.reset_behavior
    state: CURRENT
```

Do not maintain forward and reverse dependency lists manually. Two editable directions guarantee drift.

Freeze:

> **FORWARD EDGES ARE AUTHORITY; REVERSE INDEX IS DERIVED**

---

## 4. Validation pass order

A deterministic graph checker should run in this order:

1. parse schema versions;
2. validate IDs and namespace ownership;
3. reject duplicate IDs;
4. resolve aliases/supersession records;
5. resolve every forward reference to an exact ID/revision;
6. reject references to deleted/unavailable identities unless an explicit migration rule exists;
7. validate facet names against the referenced proposition schema;
8. classify dependency cycles;
9. build reverse index;
10. calculate current/stale/blocked state;
11. evaluate release gates;
12. emit machine-readable diagnostics and human-readable `SHOW WHERE USED` output.

Fail before calculating a reassuring green release state if graph integrity is broken.

---

## 5. Duplicate and deleted IDs

### Duplicate ID

Two active authorities publishing the same stable ID are a hard graph error even if their current values happen to match.

```text
ERROR DUPLICATE_ID IF.GENERIC.ENABLE_INPUT_3V3
  catalog/enable_a.yaml
  catalog/enable_b.yaml
```

Do not auto-select the newest file, alphabetically first file, or highest Git timestamp.

### Deleted ID

A stable ID with consumers must not simply disappear. Either:

- restore it;
- supersede it explicitly;
- migrate every consumer to a replacement with recorded revalidation; or
- leave consumers blocked/stale.

Freeze:

> **MISSING AUTHORITY != ZERO DEPENDENTS**

The reverse index is precisely what tells maintainers that deletion is not local.

---

## 6. Aliases and supersession

Aliases are for identity migration, not for hiding changed semantics.

A safe alias record states whether the old and new identities are semantically identical for the declared revision. If meaning changed, use supersession plus consumer revalidation rather than an invisible alias.

```yaml
id: IF.GENERIC.OLD_ENABLE_NAME
status: ALIAS
alias_of: IF.GENERIC.ENABLE_INPUT_3V3
semantic_equivalence: true
```

Supersession is stronger:

```yaml
id: IF.GENERIC.LEGACY_ENABLE
status: SUPERSEDED
replacement: IF.GENERIC.ENABLE_INPUT_3V3
migration: REVALIDATION_REQUIRED
```

Rules:

- alias chains must resolve to one active identity;
- alias loops are errors;
- an alias may not silently bridge incompatible semantic revisions;
- supersession does not automatically rewrite consumers;
- historical evidence retains the exact identity/revision it originally proved.

Freeze:

> **REPLACEMENT AVAILABLE != CONSUMER REVALIDATED**

---

## 7. Cycle handling

Not every graph cycle means the same thing.

### Forbidden authority cycle

If proposition A requires proposition B to define its meaning while B requires A to define its meaning, neither has independent authority. Reject the cycle.

### Composition/reporting cycle

Generated reports may cross-reference each other, but generated artifacts must not become semantic authorities merely to close a cycle.

### Mutual physical interaction

Two blocks can physically interact bidirectionally without their *authority definitions* being cyclic. Model separate propositions/ports and dependency directions rather than declaring each whole block to depend on the other whole block.

The checker should report the shortest strongly connected component and the edge types involved. Human review decides whether the model is wrong or the cycle is an allowed non-authority reporting relationship.

Freeze:

> **BIDIRECTIONAL PHYSICS != CYCLIC AUTHORITY**

---

## 8. Semantic revision and stale propagation

A semantic revision change causes consumers of affected propositions/facets to lose `CURRENT` status until revalidated.

Recommended consumer states:

- `CURRENT`
- `STALE_PENDING_REVALIDATION`
- `BLOCKED_UNKNOWN`
- `INVALID`
- `SUPERSEDED`

Propagation algorithm:

1. compare consumed revision with active revision;
2. if unchanged, preserve current state subject to evidence freshness;
3. if changed, compare affected facets/change record;
4. mark direct affected consumers stale;
5. traverse reverse edges from those consumers;
6. mark transitive release claims stale where their proposition depends on the stale result;
7. never clear stale state merely because a later CI run parses successfully;
8. clear only after recorded revalidation binds the consumer to the new revision.

A semantic revision bump can therefore invalidate zero, some, or many consumers depending on declared facet use. The graph must not assume every file edit is electrical change.

---

## 9. Git/file churn is not semantic churn

Three cases must remain distinct.

### File move, same authority and meaning

`catalog/a.yaml` moves to `catalog/interfaces/a.yaml`; stable ID and semantic revision remain unchanged. Update registry authority path. Consumers remain electrically current.

### Text edit, same meaning

Typo/provenance/formatting correction. No semantic revision required if the proposition's meaning is unchanged. Record the decision when non-obvious.

### Meaning change, same filename

A reset state changes from high-Z to driven-low but the filename stays identical. This **must** increment semantic revision and stale affected consumers.

Freeze:

> **UNCHANGED FILENAME != UNCHANGED SEMANTICS**
>
> **CHANGED PATH != CHANGED SEMANTICS**

CI must inspect declared semantic metadata/change records, not use Git rename/edit status as an electrical oracle.

---

## 10. Schema-version migration

`schema_version` describes representation, not the engineering proposition revision.

Example:

- interface semantic revision remains `4`;
- catalog schema migrates from version `1` to `2` because dependency facet syntax changes;
- a lossless migration produces identical normalized semantics;
- consumers do not become electrically stale solely because serialization changed.

Migration rules:

1. migrations are explicit and versioned;
2. preserve stable IDs and semantic revisions when meaning is unchanged;
3. emit a normalized before/after semantic comparison;
4. refuse lossy migration of required fields without review;
5. convert absent legacy fields to `UNKNOWN`, not plausible defaults;
6. never resolve `VERIFY_AT_MACHINE` during schema migration;
7. retain provenance to the original authority/revision.

Freeze:

> **SCHEMA REVISION != SEMANTIC REVISION**

---

## 11. Incremental migration strategy for a live catalog

Do not stop active board engineering to rewrite every artifact at once.

### Phase A — registry-only inventory

Register existing authorities with stable IDs and owners. Do not alter electrical contracts merely to make registration easy. Record unregistrable/ambiguous items as defects.

### Phase B — new/changed work declares dependencies

Require new blocks, adapters, boundaries, connection molds, and release claims to declare forward dependencies. Existing untouched artifacts may remain legacy but cannot be advertised as graph-complete.

### Phase C — migrate high-fan-out authorities

Prioritize rails, FPGA port classes, shared buses, output-authority/watchdog propositions, common connector electrical classes, and other items with many consumers.

### Phase D — generate reverse index and stale reports

Use forward declarations to create `SHOW WHERE USED`. Legacy untracked areas remain explicitly `INCOMPLETE_NOT_STUDENT_MATERIAL` for graph-completeness claims.

### Phase E — enforce release gates

Only after coverage is sufficient should CI reject new release claims that lack required dependency edges.

This avoids a dangerous migration anti-pattern: inventing semantic IDs/values in bulk just to reach 100% coverage.

---

## 12. Worked fictional migration

Assume a generic controller catalog with these authorities:

```yaml
- IF.GENERIC.GPIO_3V3.PUSHPULL_OUT@1
- IF.GENERIC.ENABLE_INPUT_3V3@3
- RES.GENERIC.RAIL_3V3@2
- ASM.MACHINE.DRIVE_ENABLE_COMMON@1  # VERIFY_AT_MACHINE
- BND.BOARD.DRIVE_ENABLE@2
- CONN.BOARD.J7_DRIVE_ENABLE@1
- QUAL.BOARD.OUTPUT_DEFAULTS@1
```

Dependencies:

```text
BND.BOARD.DRIVE_ENABLE@2
  -> IF.GENERIC.GPIO_3V3.PUSHPULL_OUT@1
  -> IF.GENERIC.ENABLE_INPUT_3V3@3
  -> ASM.MACHINE.DRIVE_ENABLE_COMMON@1

CONN.BOARD.J7_DRIVE_ENABLE@1
  -> BND.BOARD.DRIVE_ENABLE@2

QUAL.BOARD.OUTPUT_DEFAULTS@1
  -> BND.BOARD.DRIVE_ENABLE@2
  -> RES.GENERIC.RAIL_3V3@2
```

Because the machine common assumption is `VERIFY_AT_MACHINE`, the boundary cannot be `CURRENT/COMPATIBLE`; dependent release claims remain blocked. The graph is useful precisely because it refuses to hide that missing physical fact.

If the GPIO reset behavior changes in revision 2, the boundary and default-state qualification become stale. If only J7 is renamed J9 with identical electrical mapping, the board connection revision changes but reusable GPIO qualification does not.

---

## 13. CI checks: what they can and cannot prove

Useful graph CI checks:

- schema parses;
- registry IDs unique;
- namespace ownership valid;
- authority targets exist;
- forward references resolve to exact revisions;
- alias chains terminate and do not loop;
- forbidden authority cycles absent;
- facet names valid;
- reverse index reproducibly generated;
- stale state propagates deterministically;
- release claim cannot be `CURRENT` while a required dependency is stale, missing, `UNKNOWN`, or `VERIFY_AT_MACHINE`;
- schema migration produces expected normalized semantics;
- changed semantic authority includes an intentional semantic-revision/change record.

CI does **not** prove the electrical values are correct, the physical machine matches assumptions, a block is qualified, or a controller is production-safe.

Freeze:

> **GRAPH-CLEAN != ELECTRICALLY VERIFIED**

---

## 14. Adversarial migration lab

Build a small fictional catalog and exercise these cases separately:

1. **duplicate ID** — two authorities publish `IF.GENERIC.ENABLE_INPUT_3V3`; checker must hard-fail;
2. **deleted ID** — remove an interface with consumers; consumers become blocked/stale, not silently detached;
3. **alias chain** — old name -> intermediate -> active name; resolve deterministically, then introduce an alias loop and reject it;
4. **dependency cycle** — create A -> B -> A authority cycle and report the strongly connected component;
5. **stale consumer** — bump an interface semantic revision; affected consumers lose `CURRENT`;
6. **hidden semantic change** — alter reset behavior in the same filename without a semantic revision; CI must flag the undeclared semantic-change condition when normalized semantic metadata differs;
7. **harmless file move** — move authority path with stable ID/revision/normalized semantics; no electrical invalidation;
8. **board-only connection change** — change J-number/placement/silkscreen only; reusable electrical qualification remains current;
9. **schema migration** — migrate representation while preserving normalized semantics; no electrical invalidation;
10. **unknown legacy field** — migration discovers absent lifecycle data; emit `UNKNOWN` and block dependent compatibility instead of filling a default.

The learner loses credit for using commit SHA as semantic identity, auto-following a supersession without revalidation, treating a deleted dependency as zero/no-op, or clearing stale state merely because CI is green.

---

## 15. OpenPressBrake catalog stress-test result

Current OpenPressBrake governance already provides the architectural prerequisites this graph must respect:

- reusable blocks own their generic circuit/function and semantic interface;
- board integration consumes those contracts rather than rewriting them;
- adapters own real transformations and require independent qualification;
- board-only pin/net/connector/placement mapping remains integration;
- material engineering changes require corresponding status maintenance;
- unresolved machine facts remain `VERIFY_AT_MACHINE` rather than guessed.

What remains `ENGINEERING_REVIEW_NEEDED` is the repository-wide implementation layer: namespace registry, stable semantic revisions, forward dependency declarations, generated reverse index, stale propagation, alias/supersession policy, and migration tooling.

Do not retrofit those fields into active OpenPressBrake block manifests ad hoc. Introduce them with a versioned schema and migration plan after ownership is agreed. A half-migrated graph presented as complete would be worse than an explicitly incomplete graph.

---

## 16. Safety boundary

Dependency tracking can show where a safety-system status proposition is consumed. It cannot grant safety integrity to the consumer.

An ordinary FPGA/LinuxCNC controller may depend on a safety-status interface for indication, inhibit coordination, or diagnostics while remaining outside the independently validated personnel-safety authority. Graph migration must preserve that classification rather than flattening every dependency into ordinary control equivalence.

Freeze:

> **DEPENDENCY TRACEABILITY != SAFETY AUTHORITY**

---

## 17. Release gate

A catalog dependency-graph implementation is ready to gate board release only when:

- namespaces and owners are explicit;
- stable IDs are unique;
- exact semantic revisions are addressable;
- authority locations resolve;
- consumers declare forward dependencies;
- reverse lookup is generated from those edges;
- aliases/supersession are explicit and loop-free;
- required dependency cycles are rejected;
- missing/deleted/unknown/`VERIFY_AT_MACHINE` dependencies fail closed;
- semantic change invalidates affected consumers;
- file/schema churn alone does not create false electrical invalidation;
- stale state clears only through recorded revalidation;
- graph coverage is declared honestly during migration;
- board-specific connection data remains separate from reusable electrical authority;
- safety authority remains independently bounded.

Freeze:

- **REGISTRY != DUPLICATED ELECTRICAL AUTHORITY.**
- **FORWARD EDGES ARE AUTHORITY; REVERSE INDEX IS DERIVED.**
- **MISSING AUTHORITY != ZERO DEPENDENTS.**
- **REPLACEMENT AVAILABLE != CONSUMER REVALIDATED.**
- **BIDIRECTIONAL PHYSICS != CYCLIC AUTHORITY.**
- **UNCHANGED FILENAME != UNCHANGED SEMANTICS.**
- **CHANGED PATH != CHANGED SEMANTICS.**
- **SCHEMA REVISION != SEMANTIC REVISION.**
- **GRAPH-CLEAN != ELECTRICALLY VERIFIED.**
- **DEPENDENCY TRACEABILITY != SAFETY AUTHORITY.**

## 18. Completion artifact

Submit:

1. a registry/namespace fragment for at least ten fictional semantic items;
2. forward dependencies spanning reusable blocks, an adapter, board boundaries, connection definitions, resources, evidence, and one `VERIFY_AT_MACHINE` assumption;
3. generated `SHOW WHERE USED` output for at least three IDs;
4. results for all ten adversarial migration cases;
5. one schema-version migration with before/after normalized-semantic comparison; and
6. a migration coverage statement identifying which artifacts are graph-complete, legacy/untracked, stale, or blocked.

The lesson is complete only when another engineer can add, move, revise, supersede, or remove one proposition and determine from the graph — without tribal knowledge — which downstream claims remain current, which become stale, and which are blocked.