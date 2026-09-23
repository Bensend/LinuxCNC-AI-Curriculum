# BD47 — Authority-State Propagation, Supersession-Safe Discovery, and Configuration Consumption

## Purpose

BD46 showed that retaining historical engineering evidence is necessary, but retained evidence can become dangerous when search, automation, or a designer mistakes it for current authority. BD47 makes **discoverability** and **consumability** separate properties.

Design flow:

`current/superseded/deprecated artifacts -> machine-readable authority state -> search/discovery -> consumer eligibility -> stale-consumer detection -> board generation/resource budgeting -> audit -> safe historical retention`

This lesson links block engineering and board integration. A reusable block must publish what is authoritative now; a board integrator or configurator must consume only authority applicable to its exact release/configuration context while preserving the ability to reconstruct historical releases.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD46_CORRECTIVE_ACTION_EFFECTIVENESS_LEADING_INDICATORS_AND_PREVENTION_EVIDENCE.md` — **VERIFIED_FOR_LESSON** for the distinction between retained superseded evidence and current consumption authority.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — **VERIFIED_FOR_LESSON** for the current board-design handoff.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for evidence truthfulness, status levels, and same-change maintenance.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for immutable reusable contracts during composition and fail-closed handling of unresolved compatibility.
- OpenPressBrake `hardware/blocks/motor_drive_interface/manifest.yaml` — **VERIFIED_FOR_LESSON** for the current reusable motor-drive interface/resource contract and unresolved configuration-owned facts.
- OpenPressBrake `hardware/blocks/motor_drive_interface/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for its current `SIMULATION-READY` state and remaining qualification/release gates.
- OpenPressBrake `hardware/blocks/motor_drive_interface/REV1_BOARD_INTEGRATION_HANDOFF.md` — **VERIFIED_FOR_LESSON** as the current board-integration handoff at inspection time, including package packing, 3V3 capacity allocation, integration invariants, selected-drive configuration gates, and `VERIFY_AT_MACHINE` facts.

The motor-drive material is not presented as production-proven, `REV 1 READY`, safety-rated, or complete machine configuration.

## Learning objectives

The student must be able to:

1. separate search/discovery from authority to consume an artifact;
2. define explicit authority states and applicability scopes;
3. preserve historical release reconstruction without allowing historical artifacts into new builds;
4. propagate supersession through semantic dependencies and derived board/resource records;
5. detect stale consumers after an authority transition;
6. fail closed when authority is ambiguous or unresolved;
7. distinguish reusable-block authority from board/configuration authority; and
8. preserve the independent personnel-safety boundary.

## 1. Discovery is not authority

Search systems optimize for relevance, text match, recency, or indexing quality. None of those establish engineering authority.

A technically detailed superseded contract can rank above the current one. A copied spreadsheet can be newer than its source. A historical release file can be exactly correct for an old installed machine and still be prohibited for a new build.

**FOUND BY SEARCH ≠ AUTHORIZED TO CONSUME.**

**NEWEST FILE ≠ CURRENT ENGINEERING AUTHORITY.**

Every consumer must resolve authority explicitly before using an artifact to generate connectivity, choose parts, budget resources, configure FPGA/HAL, or authorize programming/service work.

## 2. Authority state needs machine-readable semantics

A practical authority model needs more than `active: true/false`. At minimum distinguish concepts such as:

- `CURRENT` — authoritative for the declared scope;
- `SUPERSEDED` — replaced by a named successor for current/new consumption, retained for provenance and historical releases;
- `DEPRECATED` — still consumable only inside a bounded declared policy/window; replacement expected;
- `HISTORICAL_RELEASE_ONLY` — authoritative only when reconstructing or servicing explicitly identified historical configurations;
- `QUARANTINED` — retained but prohibited from consumption pending investigation;
- `DRAFT` — not released consumption authority;
- `UNKNOWN` — authority cannot be established; fail closed.

Names may evolve, but the semantics must remain explicit.

**NO AUTHORITY STATE ≠ CURRENT.**

## 3. Authority is scoped, not global

An artifact can be current for one purpose and not another. Record the scope that grants consumption rights:

- reusable block revision;
- board revision;
- BOM/configuration variant;
- FPGA/gateware release;
- LinuxCNC/HAL configuration;
- new-build versus service use;
- machine/serial population where applicable;
- effective revision/date or release identity.

A historical board may legitimately require a superseded block revision for exact restoration. That does not reactivate the block for current board generation.

**VALID FOR HISTORICAL RESTORE ≠ VALID FOR NEW BUILD.**

## 4. Supersession must name the successor and affected semantics

A safe transition should record:

`old authority -> successor authority -> changed semantic IDs/facets -> affected consumers -> preserved historical applicability -> required reconciliation`

A filename rename or free-text note is insufficient. Downstream consumers need to know whether the changed facet affects them.

If only a cost source changed, electrical evidence may remain current. If a return-domain contract, FPGA resource count, rail allocation, protection topology, or package-packing rule changed, dependent board evidence may become stale.

Use `SHOW WHERE USED` to find semantic consumers, not just textual references.

## 5. Consumer eligibility is an engineering gate

Before board generation or resource budgeting, a consumer should establish:

1. artifact identity and digest/revision;
2. authority state;
3. applicability scope;
4. successor relationship if not current;
5. semantic contract compatibility;
6. unresolved `VERIFY_AT_MACHINE` facts;
7. release/configuration policy for new-build versus service use; and
8. whether dependent evidence is current for the selected authority.

If these cannot be established, stop rather than guess.

**PARSABLE ARTIFACT ≠ ELIGIBLE ARTIFACT.**

## 6. Derived data inherits authority dependencies

A generated board resource table, BOM, FPGA allocation, schematic, HAL map, or configuration package is not independent merely because it is a new file.

It must retain dependency edges to the authority records that produced it. When an upstream semantic authority is superseded, derived consumers become candidates for staleness until impact is classified.

**REGENERATED OUTPUT ≠ CURRENT OUTPUT IF INPUT AUTHORITY WAS STALE.**

This is especially important for copied spreadsheets and generated files that otherwise lose provenance.

## 7. Worked bounded example: motor-drive board handoff

Current OpenPressBrake evidence provides a useful consumption example without claiming a completed machine release.

The reusable `motor_drive_interface` manifest defines one primitive as two deterministic differential command pairs and declares exactly two single-ended 3V3 FPGA GPIOs per primitive. It also makes the physical connector a board-integration resource and leaves selected-drive electrical/timing details to configuration where required.

The current Rev 1 board-integration handoff adds board-owned consumption rules without modifying the primitive: two primitives may share one four-channel AM26LV31E package, package count is `ceil(instances / 2)`, each primitive retains its own four-line ESD array, package-local decoupling is allocated per transmitter package, and the conservative 3V3 source-capacity allocation is preserved until selected-drive loading is known.

This demonstrates multiple authority scopes:

- the **reusable manifest** owns generic electrical/resource semantics;
- the **board handoff** owns Rev 1 composition/packing/resource rules;
- the **selected-drive configuration** must own pulse timing, polarity, scaling, and manufacturer-declared cable/termination requirements;
- actual installed drive, connector/wire mapping, cable, undocumented cabinet changes, and related physical facts remain `VERIFY_AT_MACHINE` where not established.

A configurator must not promote the board handoff into generic block topology, and it must not invent missing machine configuration merely because the block contract is complete enough for integration.

**CURRENT BLOCK AUTHORITY ≠ COMPLETE BOARD CONFIGURATION AUTHORITY.**

The status checklist still leaves abnormal fault qualification, physical connector/cable integration, board-level selected-drive checks, schematic visual review, price refresh, and human Rev 1 signoff open. Therefore the handoff is consumable for bounded integration work while the block remains `SIMULATION-READY`.

## 8. Stale-consumer detection

After an authority transition, inspect at least:

- board manifests and connection blocks;
- resource/power budgets;
- BOMs and package packing;
- generated schematics/netlists;
- FPGA pin/resource maps;
- LinuxCNC/HAL configuration;
- release/programming packages;
- service instructions and spares policy;
- validators and fixtures that encode the old contract.

Classify each dependent as `RECONCILED`, `STALE`, `NOT_AFFECTED_WITH_EVIDENCE`, `HISTORICAL_RELEASE_PINNED`, or `UNKNOWN/BLOCKED` rather than silently assuming freshness.

## 9. Search and UI behavior should be supersession-safe

A useful engineering search result should show authority state and successor context before a user opens the artifact. Automation should filter consumption candidates by authority and scope, while still allowing explicit historical/provenance search.

Do not hide superseded artifacts completely; that breaks auditability and service reconstruction. Do not present them identically to current authority; that invites accidental resurrection.

A robust interface can support two distinct actions:

- **inspect evidence/history** — broad discovery allowed;
- **select for current configuration** — eligibility filter enforced.

**DISCOVERABLE ≠ SELECTABLE.**

## 10. Adversarial lab

### Case A — superseded file ranks first

Search returns a detailed historical power/resource contract before its successor.

Expected reasoning: inspect it as provenance if useful, but resolve machine-readable authority and successor before consumption. Search rank grants no authority.

### Case B — generated board consumes retired resource

A board generator finds a valid YAML record for a resource that is now superseded and adds its current/capacitance to the new board budget.

Expected reasoning: generation must reject it for current builds and report the authority conflict. Retention of the record is correct; current consumption is not.

### Case C — old machine needs exact repair

A serialized machine is verified to contain a historical released board/configuration that uses a now-superseded block revision.

Expected reasoning: historical/service scope may authorize that exact pinned artifact if support policy permits. Do not relabel the artifact `CURRENT` globally.

### Case D — current primitive, stale board handoff

A reusable block changes its FPGA GPIO requirement but an older board handoff still budgets the former count.

Expected reasoning: the block may be current while the board handoff is stale. `SHOW WHERE USED`, invalidate affected board resource evidence, and regenerate/review against the new semantic authority.

### Case E — machine fact guessed to satisfy eligibility

A selected drive's required pulse width is unknown, so automation assumes a convenient value inside the reusable envelope.

Expected reasoning: `VERIFY_AT_MACHINE`/configuration remains unresolved. Fail closed; do not invent a value to make the candidate selectable.

### Case F — historical safety-related artifact

Search finds an old ordinary FPGA interface document associated with a safety relay.

Expected reasoning: discoverability or historical correctness does not grant current personnel-safety authority. Only separately engineered and validated safety architecture can do that.

## 11. Machine-readable authority record

A future catalog/release layer should support a record conceptually like:

```yaml
authority_id: AUTH-<stable-id>
artifact_id: <stable-artifact-id>
revision_or_digest: null
authority_state: CURRENT
scope:
  artifact_role: null
  reusable_contract: null
  board_revisions: []
  configuration_population: []
  new_build: true
  service: true
supersession:
  successor_authority_id: null
  changed_semantic_ids: []
  reason: null
consumption:
  selectable: true
  unresolved_facts: []
  required_dependency_authorities: []
  required_evidence: []
dependents:
  reconciled: []
  stale: []
  historical_release_pinned: []
provenance:
  retained_for_history: true
  evidence_refs: []
```

This is schema direction, not a claim that OpenPressBrake currently implements it.

## 12. Catalog stress-test result

BD47 exposes a missing **authority-state and consumption-eligibility layer** above individual reusable block manifests. It should join stable artifact/semantic IDs, authority state, scope, successor/predecessor relationships, exact release identity, new-build/service eligibility, reverse dependencies, derived-resource records, stale-consumer state, historical-release pins, unresolved machine facts, and evidence provenance.

The motor-drive example also shows why this layer cannot live solely inside a generic block manifest: the reusable primitive, Rev 1 board packing/resource handoff, selected-drive configuration, and installed-machine facts have different authority owners.

Internal readiness of this proposed infrastructure: **ENGINEERING_REVIEW_NEEDED**.

## 13. Compute rule

No simulation, synthesis, place-and-route, timing/resource run, or executable regression is required merely to teach this lesson. When authority reconciliation genuinely requires executable engineering verification, it must run only on `[self-hosted, openpressbrake]`. If authorized local compute is unavailable, leave the applicable gate `BLOCKED/NOT_RUN`; never substitute hosted compute.

## 14. Safety boundary

Authority-state machinery can tell an ordinary controller which status, watchdog, inhibit, STO-request, or interface artifact is current for its declared non-safety role. It cannot create safety integrity or transfer personnel-safety authority into LinuxCNC/FPGA merely by marking an artifact `CURRENT`.

**CURRENT AUTHORITY ≠ SAFETY-RATED AUTHORITY.**

## Completion criteria

The student passes BD47 when they can distinguish discovery from selection, assign scoped authority states, preserve historical release reconstruction without contaminating new builds, propagate supersession through semantic dependencies, detect stale board/configuration consumers, fail closed on unresolved authority or machine facts, and keep block, board, configuration, and safety authority in their correct layers.

## Next lesson

BD48 should cover **configuration selection closure, ambiguity resolution, and fail-closed board generation**:

`eligible authorities -> exact configuration intent -> compatibility/constraint solving -> ambiguity detection -> explicit selection/VERIFY_AT_MACHINE -> deterministic board/resource output -> provenance lock -> generation audit`
