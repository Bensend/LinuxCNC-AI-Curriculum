# BD74 — Release-Graph Dependency/Staleness Propagation and Change-Control Regression Planning

Status: durable board-design curriculum lane

## Purpose

BD73 taught students to find cross-domain contradictions in a frozen board candidate. BD74 teaches what happens next when engineering changes: determine exactly which downstream claims and evidence become stale, select the minimum justified regression set, and refuse to credit stale evidence without blindly rerunning every test.

Design flow:

`whole-board gate register + stable semantic IDs + dependency edges -> upstream engineering change -> affected-claim discovery -> stale evidence propagation -> minimum justified regression set -> re-review -> release-baseline update`

Central rules:

**A PASS BELONGS TO A CLAIM, SUBJECT REVISION, ENVELOPE, AND DEPENDENCY SET — NOT TO A FILENAME.**

**CHANGE PROPAGATION MUST BE TRANSITIVE, BUT REGRESSION MUST BE JUSTIFIED.**

## Learning objectives

Students shall be able to:

1. build a release dependency graph with stable semantic IDs rather than folder/name proximity;
2. distinguish implementation, requirement, envelope, connection, resource, physical-machine, and evidence changes;
3. propagate staleness transitively through affected claims while preserving unrelated valid evidence;
4. identify scope overlays without corrupting reusable block definitions;
5. calculate a minimum justified regression set from changed assumptions and affected claims;
6. prevent unresolved resources or diagnostics from silently becoming zero-cost dependencies;
7. preserve `VERIFY_AT_MACHINE` and `TBD` facts through change control;
8. keep ordinary LinuxCNC/FPGA authority separate from independent personnel-safety authority; and
9. produce a new release baseline whose credited evidence is traceable to the current dependency graph.

## 1. Release graph model

Represent release knowledge as typed nodes and typed edges.

Minimum node classes:

- `REQ` — machine or board requirement;
- `BLOCK` — reusable electrical/function contract;
- `CONN` — board-specific connection block or machine overlay;
- `RESOURCE` — FPGA pin/bank/bus/ADC/DAC/power/shared-resource allocation;
- `POWER` — rail/source/return/protection/enable contract;
- `CAD` — generated schematic/PCB object or semantic net graph;
- `FW` — FPGA/firmware transport/runtime semantic;
- `HAL` — LinuxCNC/HAL binding;
- `TEST` — executable or manual test procedure;
- `EVIDENCE` — result produced by a test or review;
- `CLAIM` — release statement supported by evidence;
- `PHYS` — physical-machine fact, measurement, connector/harness fact, or installed configuration; and
- `SAFETY_BOUNDARY` — authority boundary stating what ordinary control may observe/inhibit but does not own.

Minimum edge types:

- `IMPLEMENTS`
- `CONSUMES`
- `MAPS_TO`
- `POWERED_BY`
- `RETURNS_THROUGH`
- `QUALIFIED_BY`
- `EVIDENCE_FOR`
- `ASSUMES`
- `CONSTRAINS`
- `SUPERSEDES`
- `OBSERVES_ONLY`

Every release-significant edge must be explicit enough to answer: **if the source node changes, which downstream claims may no longer be true?**

## 2. Stable semantic IDs

Paths and labels change. Dependency identity must not rely on them alone.

Use stable IDs for externally meaningful semantics such as:

- `AO.X_SPEED_COMMAND`
- `AO.X_SPEED_COMMAND.ALLOWED_ENVELOPE`
- `AO.DAC_FAULT`
- `AO.TPS26611_SGOOD`
- `XDRIVE.T4`
- `XDRIVE.T1_RETURN`
- `XDRIVE.B5_REVERSE`
- `XDRIVE.B6_FORWARD`
- `AUTH.PILZ_B4_DRIVE_ACTIVE`

These are teaching examples, not a claim that OpenPressBrake already implements this exact identifier namespace.

The ID describes the semantic thing; revision/evidence metadata describes its current authority.

## 3. Change-event record

Every material engineering change should create or imply a change event containing at least:

`change_id | changed_node_ids | old_revision | new_revision | change_class | changed_claim_or_assumption | reason | known_dependents | discovery_method`

Recommended change classes:

- `REQUIREMENT_CHANGE`
- `IMPLEMENTATION_CHANGE`
- `ENVELOPE_CHANGE`
- `CONNECTION_CHANGE`
- `RESOURCE_BINDING_CHANGE`
- `POWER_RETURN_CHANGE`
- `AUTHORITY_CHANGE`
- `FIRMWARE_SEMANTIC_CHANGE`
- `PHYSICAL_FACT_CHANGE`
- `EVIDENCE_METHOD_CHANGE`
- `DOCUMENTATION_ONLY_NO_SEMANTIC_CHANGE`

A documentation-only classification requires review; it is not a convenient way to suppress regression.

## 4. Staleness propagation algorithm

For each material change:

1. lock the old and new authority revisions;
2. identify changed semantic nodes, not merely changed files;
3. traverse outgoing dependency edges;
4. inspect every downstream claim whose truth depends on the changed property;
5. mark supporting evidence stale when its tested subject, envelope, assumption, route, or dependency no longer matches;
6. continue transitively through claims that are prerequisites for other claims;
7. stop propagation only at a documented isolation boundary where the changed property cannot affect the downstream claim; and
8. record why each preserved evidence item remains valid.

Useful states:

- `CURRENT`
- `STALE_DEPENDENCY_CHANGED`
- `STALE_SUBJECT_CHANGED`
- `STALE_ENVELOPE_CHANGED`
- `STALE_TEST_METHOD_INVALIDATED`
- `UNAFFECTED_WITH_REVIEWED_BOUNDARY`
- `SUPERSEDED`
- `OPEN_NO_EVIDENCE`

Staleness is not failure. It means the evidence may no longer be credited until the affected claim is re-established.

## 5. Regression selection

Do not rerun everything by habit. For every stale claim ask what evidence type can actually re-establish it.

Examples:

- a changed machine command envelope may require configuration review, command-scaling regression, HAL range review, and commissioning checks, but not a repeat of unrelated encoder transient simulation;
- a changed field connector footprint may require pad-number verification, ERC/DRC, harness/mechanical review, and physical fit evidence, but not a DAC loop-stability test when electrical loading is unchanged;
- a changed FPGA diagnostic binding may require resource accounting, pin/bank review, firmware semantic binding, generated-HAL inspection, and diagnostic fault injection;
- a changed regulator/load allocation may require power-budget/current-return review and possibly startup/transient evidence if the changed load affects those claims.

The regression record should state:

`claim_id | stale_reason | required_evidence_type | selected_test_or_review | why_sufficient | unrelated_tests_not_rerun_and_why | new_evidence_revision`

Minimum regression is not minimum effort. It is the smallest evidence set that defensibly re-establishes all affected claims.

## 6. Reusable block versus board overlay

A narrower machine overlay does not automatically stale the reusable primitive's generic electrical qualification.

Example pattern:

`reusable capability [-10,+10] V -> board/machine overlay [0,10] V -> runtime scaling -> commissioning`

If the reusable hardware is unchanged, its generic bipolar capability evidence may remain current. The downstream board/runtime claims that previously assumed bipolar machine command become stale.

Conversely, changing the reusable primitive's output impedance, protection topology, supply requirement, default behavior, or diagnostic interface may stale both generic block evidence and every board that consumes those properties.

This boundary is why reusable BLOCK definitions and board-specific CONNECTION/overlay definitions must remain separate.

## 7. Unresolved dependencies are graph nodes, not zero

If a required diagnostic or connection route is unresolved, represent it explicitly:

`binding_state: UNRESOLVED`

Do not encode an unresolved FPGA input count as zero, omit the node, or let a generator infer a convenient route. The unresolved node must remain connected to the claims it blocks.

When engineering later resolves the route, that resolution is a material `RESOURCE_BINDING_CHANGE`; downstream FPGA allocation, firmware/HAL semantics, CAD connectivity, commissioning, and diagnostic evidence become review targets.

## 8. Physical-machine facts

A physical fact such as installed drive configuration, connector identity, harness return, wire destination, or mechanical clearance is a first-class dependency.

`VERIFY_AT_MACHINE` and `TBD` are valid states. They must not disappear during generation or regression planning.

When a measured physical fact replaces a TBD:

1. record the measurement/source and date/revision;
2. update the dependent connection/overlay contract;
3. propagate the new fact through board/runtime/CAD assumptions;
4. stale evidence that assumed a different value or an unresolved placeholder; and
5. run only the regressions needed for the affected claims.

## 9. Safety boundary during change control

Ordinary controller changes must not silently acquire personnel-safety authority.

If LinuxCNC, FPGA firmware, watchdog logic, HAL mapping, diagnostics, or a normal output-enable path changes, preserve the independent safety boundary unless a separate safety-rated design and validation explicitly changes it.

An ordinary-control regression can prove ordinary containment or observation behavior. It cannot promote that path into the independent personnel-safety authority.

## 10. Current OpenPressBrake worked example

OpenPressBrake main inspected for this lesson: `86915569066300908b0cfdc6e67739d0f8388fb9`.

The following student-facing sources were opened and inspected in their current form during this run:

- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for material-change maintenance/regression obligations and truthfulness of qualification claims.
- `hardware/blocks/analog_output/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the current analog-output maturity, machine-profile correction, open qualification gates, and explicit prohibition on overclaiming readiness.
- `hardware/blocks/analog_output/integration/REV1_COMMAND_PROFILE_OVERLAY.yaml` — **VERIFIED_FOR_LESSON** for the current first-machine 0..10-V T4 overlay, separate B5/B6 direction ownership, independent B4 safety ownership, and `CONFIGURATION_PENDING` state.
- `hardware/blocks/analog_output/integration/REV1_RESOURCE_CONTRACT.yaml` — **VERIFIED_FOR_LESSON** for the current resource contract and fail-closed unresolved `DAC_FAULT` / `TPS26611_SGOOD` binding.
- `hardware/REV1_BOARD_INTEGRATION.yaml` — **VERIFIED_FOR_LESSON** for the current board integration authority and as a live example of a downstream field that still carries `x_axis_analog.range_v: [-10, 10]` while the newer machine overlay authorizes 0..10 V.
- `board-design/BD73_WHOLE_BOARD_KITCHEN_SINK_RELEASE_REVIEW.md` — **VERIFIED_FOR_LESSON** as the prerequisite contradiction/gate-register method.

These sources are verified for the bounded claims above. They do not prove the OpenPressBrake board production-ready.

## 11. Worked change event A — Commander SK command-envelope correction

Current reusable analog hardware capability remains bipolar. Current first-machine authority constrains Commander SK T4 to `0..10 V` until installed configuration evidence authorizes another mode. The current board integration file still contains `x_axis_analog.range_v: [-10, 10]`.

Model the change as:

- changed semantic node: `AO.X_SPEED_COMMAND.ALLOWED_MACHINE_ENVELOPE`;
- class: `ENVELOPE_CHANGE` / machine-overlay correction;
- reusable primitive electrical topology: unchanged;
- machine command semantics: changed from stale signed assumption to current unipolar authority;
- safety authority: unchanged; B4 remains independently Pilz-owned.

Stale/review targets include:

- board-level X-axis command-envelope field;
- runtime/HAL command scaling and clamping;
- any generated UI/configuration that exposes a negative analog command;
- command-mapping regression based on the old signed assumption; and
- final scale/zero/direction commissioning evidence.

Evidence that need not automatically become stale includes generic bipolar DAC/protector electrical evidence whose tested hardware and declared generic envelope did not change.

This is the key distinction between transitive propagation and indiscriminate retesting.

## 12. Worked change event B — future diagnostic-binding closure

The current analog resource contract explicitly says the controller binding for required `DAC_FAULT` and `TPS26611_SGOOD` is unresolved and must not be assumed to cost zero resources.

When engineering eventually resolves that binding, treat it as a material `RESOURCE_BINDING_CHANGE`.

Review/stale targets will include, as applicable:

- FPGA GPIO/shared-bus resource allocation;
- bank/pin electrical compatibility;
- schematic connectivity;
- shared-converter ownership if status is transported through that resource;
- firmware interpretation;
- LinuxCNC/HAL diagnostic exposure;
- diagnostic power-validity semantics;
- fault-injection/commissioning procedure; and
- release claims requiring both diagnostics.

Do not preselect dedicated GPIO versus shared status in the lesson. Current engineering authority explicitly leaves that unresolved.

## 13. Catalog stress-test result

BD74 confirms the catalog still needs a machine-readable release/dependency graph rather than only human cross-references.

A useful future schema should support:

`semantic_id | node_type | owner | subject_revision | dependency_ids | dependency_edge_types | envelope | unresolved_state | evidence_ids | claim_ids | change_event_ids | stale_state | stale_reason | regression_ids | release_effect`

A validator should be able to answer:

- what becomes stale if this node changes?
- what evidence remains valid and why?
- which open TBD/VERIFY_AT_MACHINE fact blocks this claim?
- which boards consume this reusable block property?
- which tests are actually required to re-establish affected claims?
- did a narrower machine overlay propagate into runtime/CAD/commissioning?
- did an unresolved resource disappear by being counted as zero?
- did any ordinary-control change cross the independent-safety authority boundary?

This is a catalog infrastructure defect, not permission to hide dependencies in lesson prose.

OpenPressBrake remains read-only in this lesson because current main is actively advancing board/block engineering. The curriculum records the dependency/staleness requirement without racing engineering changes.

## 14. Lab deliverable

Given a frozen board baseline and a supplied material change, produce:

1. a minimum 30-node typed release graph spanning requirements, blocks, connections, resources, power, CAD, firmware/HAL, physical facts, tests, evidence, and claims;
2. a change-event record naming exact changed semantic nodes;
3. a transitive affected-claim report;
4. a stale-evidence register with reasons;
5. at least five items preserved as `UNAFFECTED_WITH_REVIEWED_BOUNDARY` with justification;
6. a minimum justified regression plan mapping each stale claim to evidence type;
7. an explicit list of tests not rerun and why they are unrelated;
8. an updated unresolved-gate register; and
9. a bounded new release disposition.

A passing submission must show both directions of discipline: it must not leave stale evidence credited, and it must not rerun unrelated verification merely because a file changed.

## 15. Exit criteria

BD74 is complete when the student can take one upstream engineering change and demonstrate, from explicit dependency edges, exactly:

- which claims are affected;
- which evidence is stale;
- which evidence remains valid;
- which regression is necessary;
- which regression is unnecessary;
- which physical facts remain unresolved; and
- what release scope remains defensible after the change.

The next curriculum step should turn this graph into a controlled engineering-change/release workflow: baseline locking, review ownership, change approval, regression evidence attachment, supersession, and auditable release history.