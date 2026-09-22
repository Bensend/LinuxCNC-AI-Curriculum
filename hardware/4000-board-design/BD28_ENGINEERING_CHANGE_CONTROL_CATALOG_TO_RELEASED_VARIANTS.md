# BD28 — Engineering Change Control from Qualified Catalog to Released Board Variants

## Purpose

BD27 taught how to disposition a qualification finding and close the causal regression loop. BD28 generalizes that discipline to intentional engineering changes after reusable blocks, adapters, board variants, FPGA/HAL configurations, or installed machines already have qualification evidence.

The governing flow is:

`change proposal -> old/new configuration baseline -> affected semantic IDs/facets -> compatibility classification -> owning revision -> SHOW WHERE USED -> evidence invalidation -> board/machine applicability -> migration/retrofit decision -> qualification/regression -> new baseline -> design release -> separate field-action decision`

This lesson develops both linked skills:

1. **block engineering** — improve reusable hardware without silently changing its contract, preserve superseded revisions/evidence, classify compatibility, and requalify only the affected semantic envelope; and
2. **board integration** — decide which board variants and installed machines actually consume the changed semantics, distinguish connector/mapping changes from reusable electrical changes, and avoid turning every catalog improvement into an automatic board respin or field retrofit.

OpenPressBrake is used only for bounded current governance and a source-revalidation example. Nothing here claims the complete controller is production-qualified.

## Hard student-material audit

The following files were opened and inspected in their current `main` form during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md` — exact claim/revision evidence binding and separation of evidence result from lifecycle state.
- Curriculum `hardware/4000-board-design/BD27_QUALIFICATION_FINDING_DISPOSITION_AND_REGRESSION_CLOSURE.md` — owning-authority classification, `SHOW WHERE USED`, facet-driven regression, retained failed/superseded evidence, and release recomposition.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — board-design lane state and exact BD28 assignment before this lesson.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — integration readiness versus full qualification, concrete-evidence requirement, and same-change status maintenance.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable block/adapter/board-integration boundaries and immutable-contract composition rule.
- OpenPressBrake `hardware/blocks/digital_input_24v/design/REV4_CURRENT_DATASHEET_REVALIDATION.md` — current example of a newer manufacturer-source revision that produced no material electrical change and therefore justified no redesign or simulation rerun.
- OpenPressBrake `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md` — current readiness boundary showing the block remains SIMULATION-READY with PCB/layout, cost/dependencies, and human Rev-1 release work still open.

The digital-input files are not authority for a completed OpenPressBrake Rev-1 board. Their bounded use here is change disposition: a newer source revision can be reviewed, found semantically non-material, and retained without gratuitous design churn.

---

## 1. A change starts with two baselines, not an edit

Before changing a qualified or released artifact, identify the old configuration baseline and the proposed new one.

A useful change record starts with:

```yaml
change_id: CHG.GENERIC.014
reason: manufacturer_source_revision_review
old_baseline:
  block: BLOCK.DIN24@3
  interface: IFACE.DIN24.FIELD@2
  board_consumers: [BOARD.A@5, BOARD.B@2]
new_candidate:
  block: BLOCK.DIN24@3
  interface: IFACE.DIN24.FIELD@2
changed_facets: []
unchanged_facets:
  - electrical_topology
  - component_values
  - operating_envelope
  - production_connectivity
compatibility: NO_SEMANTIC_CHANGE
```

The baseline is more than a commit hash. It identifies the engineering identities that release evidence actually consumed: reusable semantic revisions, adapter revisions, board variant, PCB/BOM revision, FPGA image/configuration, LinuxCNC/HAL configuration, and machine applicability where relevant.

Freeze:

> **EDIT PROPOSED != ENGINEERING BASELINE CHANGED**

---

## 2. Classify compatibility before deciding who must migrate

Use an explicit compatibility result. A practical set is:

- `NO_SEMANTIC_CHANGE` — provenance/documentation/source revision changed, but consumed engineering semantics did not;
- `BACKWARD_COMPATIBLE` — new revision preserves the old published contract for existing consumers while adding an optional capability or stronger implementation margin;
- `CONDITIONALLY_COMPATIBLE` — compatible only for consumers whose declared envelope/configuration satisfies named conditions;
- `BREAKING_INTERFACE_CHANGE` — an existing consumer cannot satisfy the new A/B contract without another block, adapter, or board change;
- `BOARD_ONLY_CHANGE` — reusable electrical contracts are unchanged; applicability belongs to a board variant/connection definition;
- `MACHINE_ONLY_CHANGE` — installed machine/harness/configuration changes without generic catalog semantics changing;
- `UNRESOLVED` — insufficient evidence to classify; stop rather than assume compatibility.

Nominal part values, pin counts, package names, or signal names are not compatibility proofs.

Freeze:

> **NEWER != BETTER FOR EVERY EXISTING CONSUMER**

---

## 3. Source revision can legitimately produce no design revision

Current OpenPressBrake `digital_input_24v` provides a bounded example. The current TI ISO1212 source revision was re-inspected and found to continue supporting the frozen Type-3 receiver, supply range, selected support values, and published input boundary. The review explicitly records that no component value, topology, operating envelope, or production connectivity changed; therefore no new SPICE run or redesign was justified by the source revision alone.

That is disciplined change control. The source/provenance record changed; the electrical semantic revision did not need to change merely to demonstrate activity.

The current block status also correctly remains SIMULATION-READY rather than being promoted by that revalidation. Existing PCB/layout and human release gates remain open.

Freeze:

> **SOURCE REVISION CHANGED != CIRCUIT SEMANTICS CHANGED**

---

## 4. Backward-compatible improvement does not automatically force a board respin

Suppose a reusable output block revision improves component derating or substitutes a better-qualified passive while preserving:

- external voltage/current envelope;
- logic thresholds and polarity;
- power/return requirements;
- startup/default/fault behavior;
- mechanical/package/PCB compatibility where the board consumes it;
- resource demand within the previously qualified bound.

If evidence supports those unchanged facets, existing released boards can remain on the old qualified block revision. New boards may adopt the new revision according to configuration policy.

The new revision still needs its own affected qualification evidence. Backward compatibility means the old consumer contract remains satisfiable; it does not mean the new implementation inherits every old test automatically.

Freeze:

> **BACKWARD COMPATIBLE != RETROFIT REQUIRED**

---

## 5. Breaking interface change must be explicit

If a block changes an externally consumed semantic — for example supply requirement, reference domain, logic threshold, field range, lifecycle/default behavior, protocol, isolation boundary, timing, or required FPGA resource — classify it as breaking for consumers that depended on the old facet.

Do not silently edit board integration until it works.

For each affected consumer choose deliberately among:

1. retain the old qualified block revision;
2. select another qualified block with a compatible contract;
3. use a qualified adapter if a genuine reusable transformation exists;
4. create a new board variant/respin;
5. leave the migration blocked if facts/evidence are insufficient.

This follows current OpenPressBrake governance: reusable contracts are immutable inputs during composition, and genuine transformation belongs in an adapter rather than hidden board glue.

Freeze:

> **CATALOG HEAD != MANDATORY BOARD REVISION**

---

## 6. BOM substitution is an engineering change, not a purchasing synonym

A proposed substitute is not equivalent merely because its nominal value and package match.

Check the facets the design actually consumes, which can include:

- tolerance and drift;
- voltage/current/power ratings and derating;
- ESR/ESL, dielectric class, saturation, recovery, leakage, or switching behavior as applicable;
- absolute and recommended operating limits;
- fault behavior;
- lifecycle/availability constraints where material;
- footprint/pinout/assembly compatibility;
- regulatory/isolation/flammability qualifications where the claim depends on them;
- model/provenance differences that affect existing evidence.

Classify the substitution by changed semantics and evidence, not by distributor description.

Freeze:

> **SAME NOMINAL VALUE != QUALIFIED EQUIVALENT PART**

---

## 7. Board-specific connection changes stay board-specific

Changing connector family, J-number, pin order, physical location, silkscreen, or harness destination while preserving the reusable electrical contract is a board-variant/connection-definition change.

It may stale:

- connector/harness mapping evidence;
- PCB footprint/routing/mechanical evidence;
- silkscreen/drawing review;
- installed-machine verification tied to the old mapping.

It does not automatically stale:

- generic reusable electrical qualification;
- unrelated adapter qualification;
- unrelated FPGA timing;
- unrelated machine variants.

If the connector change introduces a real electrical transformation, protection requirement, or altered return/reference contract, reclassify the change at the appropriate electrical authority rather than hiding it as mapping.

Freeze:

> **BOARD VARIANT CHANGE != REUSABLE BLOCK REVISION**

---

## 8. Machine retrofit does not mutate catalog authority

An installed machine may need a new sensor, harness, drive, valve interface, connector, or other physical adaptation. Record the old/new machine baseline and determine whether the existing board contracts still apply.

If the retrofit is inside existing qualified interfaces, it may remain machine configuration work. If it needs a meaningful electrical transformation, select or engineer an adapter. Revise the reusable block only when generic engineering independently justifies a changed reusable contract.

Physical facts not established remain `VERIFY_AT_MACHINE`/`UNKNOWN`. Do not broaden the catalog by guessing what a legacy machine contains.

Freeze:

> **ONE MACHINE NEEDS IT != GENERIC CATALOG REQUIREMENT**

---

## 9. Design release and field action are separate decisions

A technically superior revision may be approved for future production while already released machines remain unchanged.

After engineering qualification, make two separate decisions:

### Design-release decision

Does the new block/adapter/board/configuration revision have sufficient current evidence for its claimed envelope and intended consumers?

### Field-action decision

Do existing released units require action?

Possible field dispositions include:

- `NO_FIELD_ACTION` — old baseline remains acceptable;
- `OPTIONAL_UPGRADE` — improvement is useful but old baseline remains within released claims;
- `APPLY_ON_SERVICE` — adopt during normal service when justified;
- `TARGETED_RETROFIT` — named affected variants/serial populations require migration;
- `STOP_USE_OR_CONTAIN` — only when evidence actually supports an unacceptable current condition requiring containment;
- `UNRESOLVED` — applicability/risk evidence insufficient.

Do not infer urgency merely because a new design exists. Conversely, do not leave an actually invalidated old release in service merely because retrofit is inconvenient.

Freeze:

> **NEW DESIGN RELEASED != FIELD RETROFIT REQUIRED**

---

## 10. `SHOW WHERE USED` determines applicability

For a material semantic change:

1. enumerate changed stable IDs/facets;
2. run reverse dependency lookup;
3. identify exact block/adapter/board/FPGA/HAL/release consumers;
4. filter by the old semantic revision actually consumed;
5. determine which consumers are compatible, stale, blocked, or unaffected;
6. preserve evidence outside the causal dependency set;
7. derive regressions for affected consumers;
8. recompute each release proposition independently.

Do not treat every product that contains the same family name as affected. Applicability follows the consumed semantics and configuration baseline.

Freeze:

> **SAME CATALOG FAMILY != SAME CHANGE APPLICABILITY**

---

## 11. Configuration baselines must survive supersession

Do not delete the old released definition after approving a new one. Preserve enough authority to answer:

- what revision was installed/released;
- which semantic contracts it consumed;
- which BOM/PCB/FPGA/HAL configuration applied;
- what evidence supported that release;
- what findings/limitations were open or accepted;
- what change superseded it;
- whether a field action applies to it.

A useful release history can therefore distinguish `CURRENT_FOR_NEW_BUILD`, `SUPPORTED_LEGACY`, `SUPERSEDED_NOT_FOR_NEW_BUILD`, `RETROFIT_REQUIRED`, and `WITHDRAWN/BLOCKED` without pretending all older hardware is identical.

Freeze:

> **SUPERSEDED != ERASED**

---

## 12. Safety-status interface changes preserve the authority boundary

An ordinary controller may change how it electrically receives or reports status from an independent safety system. Apply the same change-control discipline to that ordinary interface.

Do not use the change process to move E-stop, guard, safety reset, stopping, safe-speed, hydraulic safety, or other personnel-safety authority into ordinary FPGA/LinuxCNC control. If a proposed change actually modifies a safety function, it leaves this board-design curriculum's authority and requires the independent safety design/validation process.

Freeze:

> **SAFETY-STATUS INTERFACE REVISION != SAFETY-FUNCTION REDESIGN AUTHORITY**

---

## Lab — seven adversarial change proposals

Use a fictional controller assembled from qualified reusable blocks, one adapter, board-specific connection definitions, a shared power resource, FPGA/HAL mapping, and two released board/machine variants.

Disposition these changes:

1. **Backward-compatible reusable improvement:** improved derating with unchanged external contract. Decide whether new builds adopt it and whether existing boards need action.
2. **Breaking reusable interface revision:** a logic-side supply/reference or lifecycle semantic changes. Identify consumers and choose old block, alternate block, qualified adapter, respin, or blocked migration.
3. **BOM substitution:** same nominal value/package but different electrical technology/rating. Prove or reject equivalence facet by facet.
4. **Machine-only retrofit:** one legacy machine receives a different sensor/harness. Keep generic catalog authority unchanged unless independent generic justification exists.
5. **Board-only connector/location revision:** alter connector/pin/location/silkscreen while keeping electrical semantics unchanged; invalidate only causal evidence.
6. **Real improvement without automatic retrofit:** a new block revision improves margin but the old released revision remains inside its accepted envelope. Separate new-build release from field action.
7. **Safety-status interface revision:** change ordinary monitoring polarity/mapping or electrical receiver while preserving independent safety authority.

For each submit:

- old configuration baseline;
- proposed new baseline;
- reason/source of change;
- changed and unchanged semantic IDs/facets;
- compatibility classification;
- owning revision layer;
- `SHOW WHERE USED` impact set;
- evidence made stale/superseded and evidence preserved current;
- qualification/regression plan;
- board/machine applicability;
- migration decision;
- resulting design-release state;
- separate field-action disposition.

### Lab pass criteria

A passing submission must:

- never equate newest catalog revision with mandatory migration;
- never accept a BOM substitute from nominal value alone;
- keep board-only and machine-only changes out of reusable authority unless real generic semantics change;
- classify breaking interfaces before inventing board glue;
- preserve old configuration baselines and superseded evidence;
- select regressions from changed facets and dependency paths;
- distinguish new-build design release from field action;
- keep unknown machine facts unresolved rather than guessed;
- preserve the independent personnel-safety boundary.

---

## Catalog stress-test result

BD28 exposes the next machine-readable catalog pressure: **variant-aware change applicability and migration state**. Stable semantic IDs and `SHOW WHERE USED` are not enough unless each released board/machine baseline records exactly which semantic revisions it consumed.

A mature configurator/change system should be able to answer:

- which released variants consume the changed facet;
- whether the new revision is no-change/backward-compatible/conditional/breaking;
- which evidence becomes stale for each variant;
- which old baselines remain supported;
- whether migration is optional, required, blocked, or not applicable;
- whether a design release implies any field action.

This is recorded as `ENGINEERING_REVIEW_NEEDED` for future OpenPressBrake catalog infrastructure. No active OpenPressBrake engineering file is modified by this lesson.

## Compute

No simulation, synthesis, place-and-route, timing, or executable engineering verification is justified for BD28. The work is configuration/change authority and applicability methodology. Future executable verification remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Durable freezes

- `EDIT PROPOSED != ENGINEERING BASELINE CHANGED`.
- `NEWER != BETTER FOR EVERY EXISTING CONSUMER`.
- `SOURCE REVISION CHANGED != CIRCUIT SEMANTICS CHANGED`.
- `BACKWARD COMPATIBLE != RETROFIT REQUIRED`.
- `CATALOG HEAD != MANDATORY BOARD REVISION`.
- `SAME NOMINAL VALUE != QUALIFIED EQUIVALENT PART`.
- `BOARD VARIANT CHANGE != REUSABLE BLOCK REVISION`.
- `ONE MACHINE NEEDS IT != GENERIC CATALOG REQUIREMENT`.
- `NEW DESIGN RELEASED != FIELD RETROFIT REQUIRED`.
- `SAME CATALOG FAMILY != SAME CHANGE APPLICABILITY`.
- `SUPERSEDED != ERASED`.
- `SAFETY-STATUS INTERFACE REVISION != SAFETY-FUNCTION REDESIGN AUTHORITY`.
