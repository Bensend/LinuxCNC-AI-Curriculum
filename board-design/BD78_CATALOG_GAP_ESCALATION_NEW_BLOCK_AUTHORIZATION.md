# BD78 — Catalog Gap Escalation and New-Block Authorization

Status: durable board-design curriculum lane

## Purpose

BD78 teaches what to do when the BD77 selection process ends `ENGINEERING_REQUIRED_BEFORE_SELECTION` or `NO_CATALOG_CANDIDATE_FITS`.

Design flow:

`failed/held selection -> prove no existing contract fits -> classify gap -> anti-duplication/Where Used review -> reusable requirement charter -> engineering/evidence plan -> authorization gate -> block-development handoff`

Central rules:

**NO CATALOG MATCH DOES NOT AUTOMATICALLY AUTHORIZE A NEW BLOCK.**

**CREATE A NEW REUSABLE PRIMITIVE ONLY FOR A NEW REUSABLE ELECTRICAL FUNCTION OR ENVELOPE — NOT FOR A CONNECTOR, PINOUT, MACHINE NAME, OR INSTANCE COUNT.**

**AN ADAPTER IS REAL ENGINEERING; BOARD-SPECIFIC MAPPING IS NOT A REUSABLE CIRCUIT.**

## Learning objectives

Students shall be able to:

1. prove that an apparent catalog gap is real rather than a search, evidence, or requirement-decomposition failure;
2. distinguish `EXISTING_BLOCK_FITS`, `EXISTING_BLOCK_VARIANT`, `BLOCK_CONTRACT_DEFECT`, `ADAPTER_REQUIRED`, `BOARD_CONNECTION_ONLY`, and `NEW_PRIMITIVE_REQUIRED`;
3. use reverse Where Used and contract comparison to prevent duplicate primitives;
4. keep machine connector, harness, label, placement, FPGA pin assignment, and quantity out of reusable circuitry;
5. write a technology-neutral reusable requirement charter before choosing topology or parts;
6. define evidence, resource, power, protection, default-state, fault, qualification, and cost obligations before authorizing development;
7. preserve exact provenance and unresolved `VERIFY_AT_MACHINE/TBD` facts; and
8. preserve the independent personnel-safety boundary.

## 1. Start from the failed selection record

A gap escalation begins with a BD77 Selection Decision Record, not with a proposed part.

Required inputs:

`gap_id | originating_requirement_ids | SDR_id | candidates_checked | exact_candidate_revisions | mandatory_failures | unknowns | machine_facts_still_TBD | safety_authority | requested_decision`

If the machine requirement itself is vague, stop and repair the requirement. A vague requirement is not evidence of a catalog gap.

## 2. Prove the catalog was actually searched

Before authorizing new circuitry:

- inspect the current block-local manifests/status evidence for plausible candidates;
- inspect compatible variants, shared-resource blocks, and adapters;
- compare semantic interface contracts rather than filenames;
- check superseded/deprecated records where useful so an old solution is not unknowingly reinvented;
- perform reverse `Where Used` review for neighboring interface classes;
- record why each near-match fails.

Top-level summaries may help discovery, but a stale catalog summary may not override the current block-local contract/status.

Allowed search result states:

- `EXISTING_BLOCK_FITS`
- `EXISTING_BLOCK_FITS_PENDING_MACHINE_FACT`
- `EXISTING_VARIANT_CAN_BE_EXTENDED`
- `BLOCK_CONTRACT_DEFECT`
- `EXISTING_ADAPTER_FITS`
- `GAP_CONFIRMED`

`GAP_CONFIRMED` requires evidence, not “I did not find one quickly.”

## 3. Classify the gap at the correct architectural layer

Use this decision order.

### A. Board connection only

If published electrical/semantic contracts already match and the remaining work is connector family/pinout, physical location, labels, silkscreen, harness destination, FPGA package pin, or instance mapping, classify `BOARD_CONNECTION_ONLY`.

Do not create a block for a wire or connector assignment.

### B. Existing block contract defect

If an existing primitive's generic contract is internally incomplete or wrong for the reusable function it already claims, classify `BLOCK_CONTRACT_DEFECT`. Repair the existing block on generic engineering grounds and propagate affected qualification/evidence staleness. Do not fork a duplicate merely to avoid revising it.

### C. Variant

Use `EXISTING_BLOCK_VARIANT` when the semantic function is unchanged but a materially different reusable operating envelope or implementation class is justified. Examples may include light/medium/heavy current classes or package/core variants where the resource/PCB contract changes materially.

A variant must not mean “same circuit, different machine connector” or “same primitive, six channels.”

### D. Adapter

Classify `ADAPTER_REQUIRED` when two valid contracts need a meaningful reusable transformation: level translation, galvanic isolation, differential conversion, protocol/physical-layer conversion, analog scaling/buffering/filtering, or independently meaningful protection/conditioning.

The adapter owns only the transformation. It gets its own interface contract, calculations, provenance, BOM, verification, status, resource/power declarations, and qualification.

### E. New primitive

Authorize `NEW_PRIMITIVE_REQUIRED` only when the machine requirement exposes a reusable electrical function not represented by an existing block or justified variant/adapter.

Remove the current machine name, connector numbers, wire numbers, and quantity. If the proposed item stops making engineering sense, it is probably not a reusable primitive.

## 4. Anti-duplication review

Every proposed new primitive/variant/adapter must include:

`proposed_id | semantic_function | A_side_contract | B_side_contract_if_adapter | claimed_envelope | nearest_existing_ids | exact_differences | why_composition_is_insufficient | expected_consumers | Where_Used_neighbors | duplication_risk | disposition`

Reject authorization when differences are only naming, pin rearrangement, connector choice, quantity, or one-board placement.

Expected reuse is supporting evidence, not the definition of a block. A one-off transformation may still deserve an adapter if it is real circuitry requiring independent qualification; a frequently repeated wire still does not become a block.

## 5. Reusable requirement charter before topology

For an authorized engineering candidate, write the charter before selecting a favorite IC or copying the first machine:

`block_id | category | primitive_unit | semantic_purpose | external_interfaces | supported_envelope | default/deenergized_state | power_domains | return_domains | protection | diagnostics | fault_behavior | timing_bandwidth | isolation | FPGA_bus_resources | shared_resources | connector_requirements_not_connector_selection | PCB_thermal_constraints | evidence_required | qualification_claims | cost_target | provenance_requirements | exclusions | safety_role | unresolved_facts`

Unknown values remain `TBD`; machine measurements remain `VERIFY_AT_MACHINE`.

## 6. Engineering authorization gate

Authorization answers “is engineering this reusable item justified?” It does not claim the item works.

Required gate:

- requirement and failed-selection evidence are inspectable;
- current catalog/near matches were checked;
- architectural classification is justified;
- no duplicate primitive is being created for board convenience;
- reusable scope and exclusions are explicit;
- block versus connection ownership is explicit;
- power/return/resource/protection/default/fault obligations are identified;
- provenance/reference search is planned;
- calculation and question-driven simulation plan is defined;
- schematic/CAD/ERC and board-integration evidence gates are named;
- cost/BOM ownership is named;
- qualification claims are bounded;
- safety authority is explicit;
- physical unknowns remain unresolved rather than guessed.

Authorization states:

- `REJECT_USE_EXISTING_BLOCK`
- `REJECT_CONNECTION_BLOCK_ONLY`
- `REVISE_EXISTING_BLOCK`
- `AUTHORIZE_VARIANT_ENGINEERING`
- `AUTHORIZE_ADAPTER_ENGINEERING`
- `AUTHORIZE_NEW_PRIMITIVE_ENGINEERING`
- `HOLD_PENDING_MACHINE_FACT`
- `HOLD_PENDING_EVIDENCE`

## 7. Current OpenPressBrake adversarial worked example

OpenPressBrake current main inspected for this lesson: `a0e974c985162f2577dd194a022f055bd3b978e1`.

Student-facing sources opened and inspected in current form during this run:

- `hardware/blocks/README.md` — **VERIFIED_FOR_LESSON** for primitive/shared-resource decomposition, request-to-board assembly, reusable-envelope rules, connector separation, exact-connectivity expectations, and verification hierarchy.
- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for maturity, baseline-versus-qualification, evidence truthfulness, and material-change maintenance.
- `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for the reusable-block/adapter/board-integration decision test and automation classifications.
- `hardware/blocks/digital_output_24v/manifest.yaml` — **VERIFIED_FOR_LESSON** for a one-channel protected high-side primitive whose machine current/inrush/connector/thermal envelope remains integration/qualification work.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for current Rev1 isolated-path maturity and open KiCad/connectivity/qualification gates.
- `hardware/blocks/dry_contact_relay_output/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for a distinct voltage-free SPDT primitive that remains NOT READY and therefore cannot be treated as a qualified substitute merely because its function is useful.
- `board-design/BD77_CATALOG_SELECTION_DECISION_RECORDS_TRADE_STUDIES.md` — **VERIFIED_FOR_LESSON** as the prerequisite selection method.

These labels are bounded to the teaching claims above and do not confer production qualification.

### Case 1 — “Need eight outputs” is not a new-block charter

The current protected high-side primitive is one channel. Its manifest separately records first-machine population and reusable board capacity. Therefore “need eight outputs” means instantiate eight primitives and allocate shared resources; it does not authorize an `eight_channel_output` primitive.

### Case 2 — dry contact versus high-side output is a real semantic difference

A voltage-free SPDT requirement cannot be repaired by changing the connector on the high-side output. The current dry-contact relay primitive represents a genuinely different reusable function. But because its current status is NOT READY, a board requiring it must carry engineering/evidence work; it must not invent a third duplicate relay primitive simply to obtain a green status.

### Case 3 — isolation added between valid contracts

OpenPressBrake's mandatory methodology says a meaningful reusable isolation/translation boundary normally belongs in an adapter or in a justified generic revision if the primitive's intended reusable contract itself requires it. Board integration may not hide the circuitry. The current digital-output Rev1 path illustrates why return-domain/isolation architecture is contract material rather than connector mapping.

## 8. Catalog stress-test result

BD77 found that the top-level catalog is not yet sufficient as the sole current selection authority. BD78 exposes the corresponding development-governance need: a machine-readable gap/authorization registry joined to the dependency/consumer graph.

Required future record:

`gap_id | requirement_ids | SDR_id | catalog_revision | candidates_checked | contract_revisions | failure_reasons | classification | proposed_block_or_variant_id | nearest_existing_ids | semantic_delta | envelope_delta | expected_consumers | Where_Used_links | unresolved_fact_ids | authorization_state | owner | engineering_plan_id | evidence_plan_id | downstream_status`

This should prevent repeated rediscovery of the same gap and make rejected duplicate proposals searchable.

No OpenPressBrake catalog file was changed in this lesson because current main is actively advancing board/block engineering and the discovered registry need is architectural tooling work rather than a technically safe one-file correction.

## 9. Multi-machine transfer

Apply the classification to hypothetical mill, lathe, plasma, router, robot, press-brake, and custom-automation needs. A machine-specific harness change should usually terminate in a connection block; a repeated voltage/interface transformation may justify an adapter; a genuinely new reusable sensing/actuation function may justify a primitive.

Do not invent real-machine values for these exercises.

## 10. Safety boundary

Ordinary block authorization cannot grant personnel-safety authority. If the originating requirement is safety-authoritative, ordinary LinuxCNC/FPGA primitives and adapters fail that authority requirement unless a separate safety-rated architecture and validation explicitly supports the role.

A monitoring/status interface to an independent safety system remains ordinary control/diagnostics unless separately justified. Do not convert “needs an inhibit” into a claim that the FPGA is the independent safety authority.

## 11. Lab deliverable

Given four failed or held BD77 SDRs, produce one each that resolves as connection-only, existing-block revision/variant, adapter, and new primitive or justified hold. For every case provide the catalog-search record, nearest-match comparison, Where Used/anti-duplication review, classification, authorization state, reusable charter when authorized, evidence plan, unresolved-fact register, and safety statement.

At least one proposed “new block” must be rejected because it is only a board-specific connector/pin/quantity change.

## 12. Exit criteria

BD78 is complete when a student can turn a failed selection into a controlled engineering decision without duplicating existing circuitry, contaminating reusable blocks with machine assumptions, hiding transformation circuitry in board integration, or claiming evidence that does not exist.

Next curriculum step: **BD79 — New-Block Engineering Charter to Qualified Baseline**: take an authorized primitive/variant/adapter through reference/topology selection, calculations/derating, protection/default/fault design, resource/power contract, exact connectivity, question-driven verification, status evidence, and a baseline integration handoff without prematurely claiming Rev 1 qualification.