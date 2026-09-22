# BD23 — Interface-Contract Schema, Stable Semantic IDs, and Change-Impact Invalidation

## Purpose

BD22 proved that a compatibility matcher needs structured interface facts. BD23 asks the maintenance question that follows immediately: **when one of those facts changes, can the catalog identify every downstream engineering claim that depended on it without relying on filenames, copied prose, or designer memory?**

This lesson develops both linked skills:

1. **block engineering** — publish stable semantic requirement/interface/assumption IDs, revision them deliberately, and declare evidence and invalidation semantics; and
2. **board integration** — consume exact semantic revisions, support `SHOW WHERE USED`, and automatically mark dependent boundary decisions, adapters, connection definitions, resource plans, schematic claims, and qualification evidence stale when an upstream proposition changes.

The OpenPressBrake controller is a worked architectural example, not a production-proven reference board. The method applies equally to mills, lathes, plasma tables, routers, robots, press brakes, and custom automation.

## Student-material verification status for this run

The following current files were opened and inspected before this lesson was written:

- Curriculum `hardware/4000-board-design/BD22_BOUNDARY_COMPATIBILITY_MATRICES_AND_MACHINE_READABLE_INTERFACE_MATCHING.md` — **VERIFIED_FOR_LESSON** as the prerequisite compatibility model and field-state/result vocabulary.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — **VERIFIED_FOR_LESSON** for the lane checkpoint and the exact BD23 work item.
- Curriculum `WORK_SELECTION_POLICY.md` — **VERIFIED_FOR_LESSON** for independent-lane work selection and branch-local blocking.
- Curriculum `SOURCE_POLICY.md` — **VERIFIED_FOR_LESSON** for evidence classes, provenance, conflict handling, and revision-specific claims.
- OpenPressBrake `hardware/blocks/BLOCK_DEVELOPMENT_TEMPLATE.md` — **VERIFIED_FOR_LESSON** for current block identity, semantic-interface, shared-resource, reference/delta, calculation, and verification ownership. It does not yet define the dependency graph taught here.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for integration versus qualification gates and same-change status maintenance.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for immutable reusable contracts during composition, adapter ownership, and fail-closed `UNRESOLVED`/`VERIFY_AT_MACHINE` behavior.

Readiness is claim-scoped. None of these labels establishes production readiness of the complete OpenPressBrake controller.

---

## 1. A file path is not a semantic identity

A downstream design may depend on one proposition inside a large manifest, not on every byte in the file. Conversely, the same proposition may be restated in several files and drift.

Freeze:

> **FILE PATH != SEMANTIC ID**

Use stable semantic IDs for engineering propositions that downstream artifacts may consume. Minimum families are:

- `REQ.*` — requirement;
- `IF.*` — reusable electrical/logical interface contract;
- `ASM.*` — assumption, including machine facts not yet verified;
- `RES.*` — reusable resource/power contract;
- `EVD.*` — evidence claim or qualification result where stable reference is useful.

The exact prefix spelling is less important than stable identity, namespace ownership, uniqueness, and machine-readable references.

Do not encode a board J-number, connector location, machine wire number, or current instance count into a reusable semantic ID unless that fact is intrinsically part of the reusable proposition. Board-specific instance records may have their own stable IDs in the board-integration namespace.

---

## 2. Identity and revision are different

An ID answers **which proposition is this?** A revision answers **which meaning of that proposition did the consumer evaluate?**

Example shape:

```yaml
interface:
  id: IF.LOGIC.GPIO_3V3.PUSHPULL_OUT
  revision: 3
  owner: reusable_interface_catalog
  status: ACTIVE
```

Do not create a new ID merely because wording improved. Do create a new semantic revision when a compatibility-relevant meaning changes.

### Changes that normally require a semantic revision

- operating voltage/threshold envelope changes;
- direction or drive type changes;
- return/reference or isolation semantics change;
- startup, reset, unpowered, default, watchdog, or back-power behavior changes;
- timing/protocol envelope changes;
- protection/fault assumption changes;
- resource or power dependency changes that consumers rely on;
- a former `UNKNOWN`/`VERIFY_AT_MACHINE` fact becomes established and changes what may be claimed.

### Changes that normally do not require a semantic revision

- typo or grammar correction with identical meaning;
- formatting/reordering only;
- adding provenance that supports an unchanged claim;
- adding a board-specific instance/J-number elsewhere without changing the reusable contract;
- renaming an internal component reference that does not alter the published interface.

When uncertain, record the decision and its reason. Revision churn is undesirable, but silent semantic change is worse.

Freeze:

> **TEXT CHANGE != ALWAYS SEMANTIC CHANGE**
>
> **SEMANTIC CHANGE != PERMITTED WITHOUT REVISION**

---

## 3. Minimal extensible interface schema

Do not create one giant electrical union in which every possible field is mandatory. Use a small common header plus typed facets.

```yaml
interface:
  id: IF.EXAMPLE
  revision: 1
  owner: block_or_catalog_owner
  role: source
  facets:
    logic:
      direction: output
      drive: push_pull
      operating_voltage_V: {nominal: 3.3}
      thresholds: {state: UNKNOWN}
    reference:
      return_id: IFREF.LOGIC_GND
      isolation: none
    lifecycle:
      unpowered_behavior: {state: UNKNOWN}
      reset_behavior: {state: KNOWN, value: high_z}
    resources:
      depends_on:
        - RES.RAIL.3V3
  evidence:
    - EVD.EXAMPLE.DATASHEET
  invalidation_triggers:
    - logic
    - reference
    - lifecycle
    - resources
```

A typed facet can be absent only when it is genuinely outside the interface class. Within an applicable facet, use BD22's explicit states `KNOWN | NOT_APPLICABLE | VERIFY_AT_MACHINE | UNKNOWN`. Missing required information remains fail-closed.

---

## 4. Dependencies are edges, not copied prose

Every downstream artifact that makes an engineering claim must declare the semantic propositions it consumes.

```yaml
boundary:
  id: BND.EXAMPLE.001
  depends_on:
    - {id: IF.LOGIC.GPIO_3V3.PUSHPULL_OUT, revision: 3}
    - {id: IF.LOGIC.GPIO_3V3.INPUT, revision: 2}
    - {id: ASM.MACHINE.COMMON_REFERENCE, revision: 1}
  result: COMPATIBLE
  validation_state: CURRENT
```

Do not copy the interface voltage, threshold, or lifecycle prose into the boundary as its authority. A cached display value may exist for humans, but the authoritative dependency remains the ID/revision edge.

Freeze:

> **COPIED VALUE != DEPENDENCY**

This directly prevents the stale-status failure mode in which an old handoff continues to say a contract is missing after the owning block has published it.

---

## 5. `SHOW WHERE USED` is a required catalog operation

Given any stable semantic ID, reverse lookup must answer where it is consumed.

For `IF.LOGIC.GPIO_3V3.PUSHPULL_OUT`, useful results might include:

- block-side adapter contracts;
- board boundary decisions;
- board-specific connection definitions;
- FPGA resource assignments;
- power/resource plans;
- generated schematic assertions;
- verification/qualification cases;
- LinuxCNC/HAL mapping assertions;
- release/checklist claims.

The reverse index may be generated from declared forward dependencies. It must not depend on searching for a familiar net name in prose.

A useful result includes consumer ID, artifact path, consumed revision, current/stale state, and the exact claim that depends on the source.

---

## 6. Change-impact invalidation

When a semantic item changes from revision `N` to `N+1`, the catalog does **not** automatically declare every consumer wrong. It automatically declares affected consumers **STALE_PENDING_REVALIDATION** until their dependency is evaluated against the new revision.

Recommended states:

- `CURRENT` — dependency revisions match and required validation is current;
- `STALE_PENDING_REVALIDATION` — upstream semantic revision changed;
- `BLOCKED_UNKNOWN` — a required dependency is `UNKNOWN`/`VERIFY_AT_MACHINE`;
- `INVALID` — established incompatibility or failed evidence;
- `SUPERSEDED` — consumer intentionally replaced.

Invalidation should propagate transitively. If a boundary becomes stale and an adapter selection depends on that boundary, the adapter selection is stale. If a schematic release claim depends on the adapter selection, that claim is stale too.

Freeze:

> **UPSTREAM CHANGE != AUTOMATIC FAILURE**
>
> **UPSTREAM CHANGE == AUTOMATIC LOSS OF CURRENT STATUS UNTIL REVALIDATED**

---

## 7. Scope the invalidation by dependency type

Avoid both extremes: invalidating nothing and invalidating the entire repository for every edit.

A consumer should declare which semantic facet or claim it uses when practical:

```yaml
depends_on:
  - id: IF.LOGIC.GPIO_3V3.PUSHPULL_OUT
    revision: 3
    facets: [logic.direction, logic.drive, logic.thresholds, lifecycle.reset_behavior]
```

If revision 4 changes only documentation provenance while those semantics remain identical, the dependency can be mechanically or manually revalidated without rerunning unrelated electrical tests. If revision 4 changes reset behavior, every consumer that relied on reset/default authority must become stale.

Qualification evidence also declares what it proves. A nominal voltage test does not remain authority for a newly widened transient envelope merely because the same test file still exists.

---

## 8. Assumptions and `VERIFY_AT_MACHINE` are first-class dependencies

Machine facts must not live only in prose notes.

```yaml
assumption:
  id: ASM.MACHINE.RS485_REFERENCE_ENVELOPE
  revision: 1
  state: VERIFY_AT_MACHINE
  owner: machine_integration
```

Any boundary requiring that fact is `BLOCKED_UNKNOWN`/`UNRESOLVED`. When the physical measurement is later recorded, revise the assumption with provenance and re-evaluate all reverse dependencies.

Do not convert a machine-specific assumption into a reusable block fact merely to clear the graph.

---

## 9. Board-specific connection blocks remain separate

A board connection definition can depend on reusable interfaces while owning physical facts such as:

- J-number and pin mapping;
- selected connector family/MPN;
- FPGA package pin assignment;
- board edge/location;
- silkscreen/service label;
- harness/machine destination.

Example:

```yaml
connection:
  id: CONN.BOARD.REV1.ENCODER_X
  depends_on:
    - {id: IF.ENCODER.RECEIVER.LOGIC_OUT, revision: 2}
    - {id: IF.FPGA.GPIO.INPUT_3V3, revision: 4}
  connector_instance: J17
  machine_destination: VERIFY_AT_MACHINE
```

The reusable interface IDs remain generic; the connection ID is board-specific. Do not leak `J17`, `X_AXIS`, or a harness destination into the reusable electrical contract.

---

## 10. OpenPressBrake adversarial audit

Current OpenPressBrake governance already has strong ownership boundaries:

- the block-development template requires a block identity, semantic interface contract, shared-resource declaration, proven-reference audit, calculations, and verification handoff;
- status rules require the external semantic interface to be complete enough for board assembly before baseline integration status is claimed;
- adapter/integration rules require reusable contracts to remain immutable during composition and prohibit automation from guessing through an incompatibility.

The missing layer is a repository-wide stable semantic dependency graph. The current governance files do not yet define a common requirement/interface/assumption ID namespace, forward dependency declarations, reverse `SHOW WHERE USED`, or automatic stale propagation.

**Catalog defect/action item:** introduce that layer deliberately, after ownership/schema/versioning are agreed, rather than retrofitting active block manifests ad hoc. This run does not modify OpenPressBrake because current main is actively changing FPGA configuration-bias/reference governance and adjacent board-development authority.

This is `ENGINEERING_REVIEW_NEEDED`, not permission for curriculum prose to become the engineering source of truth.

---

## 11. Adversarial change lab

Start with a small graph containing at least:

- two reusable interfaces;
- one adapter;
- two board boundary decisions;
- one connection definition;
- one FPGA/resource allocation;
- one schematic assertion;
- one qualification result;
- one `VERIFY_AT_MACHINE` assumption.

Apply these changes separately and record the reverse impact:

1. correct a typo only — no semantic invalidation;
2. add stronger provenance for an unchanged threshold — no electrical requalification merely because the file changed;
3. change output drive from push-pull to open-drain — semantic revision; invalidate affected boundary/default/timing claims;
4. widen a voltage envelope with new evidence — semantic revision; re-evaluate compatibility and protection claims, but do not blindly rerun unrelated FPGA resource tests;
5. change reset behavior from high-Z to driven-low — invalidate startup/default/output-authority consumers;
6. resolve a `VERIFY_AT_MACHINE` common-reference assumption — re-evaluate only consumers that depended on it;
7. change a J-number with identical electrical mapping — board connection revision, not reusable interface revision;
8. move an FPGA signal to another package pin in the same compatible bank — board resource/connection consumers change; generic electrical interface need not change;
9. change the FPGA bank voltage — invalidate both resource and electrical compatibility consumers;
10. supersede an adapter — downstream board composition and schematic claims become stale until rebound to an exact replacement revision.

The learner loses credit for treating Git commit SHA alone as semantic identity or for clearing stale state without recording revalidation evidence.

---

## 12. Safety boundary

Dependency tracking improves traceability; it does not create safety integrity.

A dependency graph may show that an ordinary FPGA status input consumes an independent safety-system diagnostic interface. That does not make the FPGA/LinuxCNC path the personnel-safety authority. Safety-rated requirements, diagnostics, fault assumptions, validation evidence, and final elements remain in the independently engineered safety architecture unless explicit evidence establishes otherwise.

Freeze:

> **TRACEABLE != SAFETY-RATED**

---

## 13. Release gate

A board composition claim may be considered current only when:

- every required upstream semantic item has a stable ID and exact consumed revision;
- required dependency fields are declared rather than copied as unaudited prose;
- no required dependency is `UNKNOWN` or unresolved `VERIFY_AT_MACHINE`;
- reverse lookup can identify the consumer from each upstream item;
- every changed upstream semantic revision has been re-evaluated;
- transitive stale state has been cleared only by recorded revalidation;
- board-specific physical mapping remains in board integration;
- reusable blocks were not edited merely to clear a board dependency;
- evidence still proves the exact current claim/envelope;
- safety authority remains correctly bounded.

Freeze:

- **FILE PATH != SEMANTIC ID.**
- **TEXT CHANGE != ALWAYS SEMANTIC CHANGE.**
- **SEMANTIC CHANGE != PERMITTED WITHOUT REVISION.**
- **COPIED VALUE != DEPENDENCY.**
- **UPSTREAM CHANGE == AUTOMATIC LOSS OF CURRENT STATUS UNTIL REVALIDATED.**
- **TRACEABLE != SAFETY-RATED.**

## 14. Completion artifact

Submit:

1. a minimal interface-schema fragment with stable IDs/revisions and typed facets;
2. a ten-node dependency graph spanning block, adapter, board integration, resource, schematic, evidence, and machine-assumption layers;
3. `SHOW WHERE USED` output for two semantic IDs;
4. the ten adversarial change cases with expected stale/revalidation scope; and
5. one explanation of why a board-specific connector/pin change does not automatically create a new reusable interface revision.

The lesson is complete only when another engineer can change one upstream proposition and determine, from declared repository dependencies rather than memory, exactly which downstream claims lost current status and why.
