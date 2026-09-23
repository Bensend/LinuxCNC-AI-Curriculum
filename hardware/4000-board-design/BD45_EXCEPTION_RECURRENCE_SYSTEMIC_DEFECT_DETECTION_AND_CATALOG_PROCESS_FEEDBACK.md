# BD45 — Exception Recurrence, Systemic Defect Detection, and Catalog/Process Feedback

## Purpose

A closed exception can still be evidence of a systemic defect. This lesson teaches how to detect recurrence without grouping superficially similar events, find the common semantic cause, classify the correction at the proper architectural layer, propagate impact across boards and populations, and prove that the corrective action actually reduces recurrence.

Design flow:

`closed/current exceptions -> recurrence clustering -> common semantic cause -> board-only pattern vs reusable defect vs process defect -> corrective action -> cross-population impact -> catalog/process update -> regression -> recurrence monitoring`

This lesson links block engineering and board integration. Repeated board pain is useful evidence, but repetition does not grant permission to contaminate reusable blocks with machine-specific assumptions.

## Student-material readiness audit

The following current repository files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD44_EXCEPTION_DEBT_WAIVER_BURNDOWN_AND_TEMPORARY_CONTROL_RETIREMENT.md` — **VERIFIED_FOR_LESSON** for exception lifecycle, scope, semantic impact, closure, and temporary-control retirement semantics.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — **VERIFIED_FOR_LESSON** for the BD45 handoff and current board-design lane state.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for evidence/status truthfulness, maintenance synchronization, and baseline-versus-qualification semantics.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for block/adapter/board-integration ownership and the incompatibility decision test.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/REV1_BOARD_INTEGRATION_HANDOFF.md` — **VERIFIED_FOR_LESSON** only for the bounded one-port integration contract and explicit board-owned/VERIFY_AT_MACHINE responsibilities stated there.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml` — **VERIFIED_FOR_LESSON** only for the selected nonisolated variant's declared reusable interface/resource contract and unresolved FPGA estimates.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for its current status and open qualification gates.

The RS-485 primitive is not presented as production-proven or REV 1 READY. Its current checklist explicitly leaves gateware execution, fault/EMC qualification, connector/shield/topology integration, PCB review, cost/resource closure, and human release open.

## Learning objectives

The student must be able to:

1. preserve exception history after closure and use it as recurrence evidence;
2. cluster events by semantic cause rather than filename, symptom, or component name;
3. distinguish a board-only integration pattern from a reusable block defect, missing adapter, shared-resource defect, and process/governance defect;
4. avoid promoting repeated service substitutions into generic new-build authority;
5. identify all affected consumers and installed populations before changing a reusable contract;
6. choose corrective action at the narrowest correct architectural layer;
7. rerun only evidence invalidated by the changed semantic facets while preserving valid evidence;
8. monitor recurrence after correction using normalized cause IDs and exposure denominators; and
9. preserve the independent personnel-safety boundary.

## 1. Closure is not the end of learning

BD44 closes a bounded exception when normal evidence is restored. Do not discard the event afterward. A sequence of individually closed exceptions can reveal a defect that no single event proves.

**EXCEPTION CLOSED ≠ ROOT CAUSE SYSTEMICALLY CLOSED.**

Retain at least the original symptom, affected semantic IDs, actual cause, scope, correction, evidence, population, and closure state. Recurrence analysis needs the cause history, including negative evidence and false leads.

## 2. Cluster by semantic cause, not appearance

Two failures can look identical and have different causes. Two very different symptoms can share one cause.

Bad clustering keys include:

- same connector number;
- same component family;
- same machine type;
- same error message;
- same technician workaround;
- same repository directory.

Prefer normalized semantic causes such as:

- interface voltage contract mismatch;
- missing return-path ownership;
- startup/default-state contract incomplete;
- shared-rail capacity omitted from integration;
- FPGA resource demand missing;
- machine connector mapping wrong;
- adapter transformation absent;
- checklist/status maintenance drift;
- VERIFY_AT_MACHINE fact guessed instead of measured.

**SAME SYMPTOM ≠ SAME ROOT CAUSE.**

**DIFFERENT SYMPTOM ≠ DIFFERENT ROOT CAUSE.**

## 3. Classify the systemic defect at the correct layer

For each recurrence cluster, remove board names, connector numbers, and machine instance names and ask what remains.

### Board-only integration pattern

Use when reusable contracts are correct and the repeated error is assignment/composition: wrong connector pin, incorrect instance mapping, bad silkscreen, wrong board-specific termination population, or a repeated harness mapping mistake.

Correct the connection/integration mold, validator, template, or review process. Do not edit the reusable primitive merely to prevent one board's mapping mistake.

### Reusable block defect

Use when the generic electrical/function contract itself is incomplete, incorrect, unsafe, or misleading across valid consumers. Revise the block on generic engineering grounds and invalidate/requalify the affected semantic claims.

### Missing adapter/interface block

Use when two individually valid contracts repeatedly require a meaningful electrical transformation, isolation, conditioning, protection, or protocol/physical-layer conversion. Engineer the transformation as its own reusable block rather than duplicating glue circuitry in multiple boards.

### Shared-resource defect

Use when primitives are individually valid but recurrence comes from hidden aggregate requirements such as rail current, startup capacitance, ADC/reference sharing, clocking, bus arbitration, FPGA banks, LUT/BRAM/PLL demand, or return-domain behavior. Make the shared resource explicit and integrate it at board level.

### Process/governance defect

Use when the engineering content is correct but the process repeatedly permits stale status, missing evidence, guessed machine facts, unreviewed generated artifacts, or unsynchronized manifests/checklists.

**REPEATED BOARD ERROR ≠ AUTOMATIC BLOCK DEFECT.**

**REPEATED GLUE CIRCUIT ≠ BOARD MAPPING.**

## 4. Recurrence can reveal a missing adapter

Suppose several boards connect valid Block A and Block B through slightly different hand-built level-shift/clamp networks. Each exception was closed locally.

The recurrence test asks whether the transformation still makes engineering sense with board names removed. If yes, and it owns real circuitry, the pattern is strong evidence for a reusable adapter. The adapter receives its own contract, provenance, calculations, protection, BOM, verification, resource data, and qualification.

Do not solve recurrence by teaching Block A about Block B or by copying the glue into a connection block.

## 5. Repeated status drift is a process defect

OpenPressBrake's current status governance requires material changes to design, simulation, BOM, component selection, schematic, PCB constraints, integration results, external-skill findings, or declared envelope to update `STATUS_CHECKLIST.md` in the same change.

If repeated audits find manifests or implementation evidence ahead of their checklists, the systemic correction is not merely to fix each checkbox. Investigate why the same-change maintenance rule is not being enforced. Possible corrective actions include a validator, review gate, stable semantic dependency record, or generated consistency report.

**CHECKLIST REPAIRED ONCE ≠ STATUS-DRIFT PROCESS FIXED.**

## 6. Worked bounded example: RS-485 integration contract

The current OpenPressBrake `modbus_rtu_rs485` primitive publishes a one-port reusable contract. It owns the selected nonisolated transceiver/protection/default-state electrical design and declares per-port 3V3 and FPGA-side demands. Board integration owns installed port count, FPGA pin assignment, baud/protocol role, connector/pin mapping, shield/chassis strategy, bus topology, termination location, aggregate 3V3 capacity, and installation ground-potential/isolation assessment.

That separation gives a recurrence classifier:

- repeated wrong connector pin mapping -> board integration/process defect;
- repeated ad-hoc isolator insertion because installations prove isolation is needed -> investigate a separately engineered isolated variant/adapter, not hidden board glue;
- repeated 3V3 overload because integrators ignored the published per-port demand -> integration/resource-planning process defect unless the published demand itself is wrong;
- repeated inability to allocate gateware because LUT/register demand remains `TBD_after_gateware` -> reusable resource-contract incompleteness that must be closed when final gateware evidence exists;
- repeated incorrect 120-ohm population -> board/network integration and VERIFY_AT_MACHINE discipline, because physical bus-end location is intentionally not owned by the primitive.

Do not infer any of these failures actually occurred on OpenPressBrake. They are adversarial classifications derived from the inspected current contract.

## 7. Cross-population impact before correction

A systemic correction may affect more than the boards that exposed it.

Before changing a reusable contract, determine:

`cause -> changed semantic facets -> SHOW WHERE USED -> candidate/release consumers -> installed/as-maintained populations -> stale evidence -> required regression`

A board-only template fix may need no block requalification. A generic block-contract revision may invalidate multiple boards. A process validator may apply prospectively while historical releases need an audit. Keep those cases separate.

**FIRST OBSERVED POPULATION ≠ ONLY AFFECTED POPULATION.**

## 8. Corrective action must match the cause

A corrective action record should state:

- normalized recurrence/cause ID;
- supporting exception/event IDs;
- rejected alternative causes and evidence;
- architectural classification;
- semantic facets changed;
- exact block/adapter/integration/process artifacts changed;
- affected consumers/populations;
- regression/requalification required;
- migration or field-action applicability;
- authority approving the systemic correction.

If the evidence cannot distinguish two causes, keep the cause unresolved and gather the discriminating evidence. Do not choose the easier catalog edit.

## 9. Regression after systemic correction

Use semantic invalidation rather than indiscriminate reruns.

A block-contract correction requires block requalification of affected claims and downstream board re-promotion where those claims are consumed. A board-only mapping-template correction needs board/integration regression, not generic block qualification. A process correction needs evidence that the process now detects/prevents the targeted failure mode.

Executable simulation, FPGA synthesis/place-and-route, timing/resource checks, or regressions that are genuinely required must run only on `[self-hosted, openpressbrake]`. If authorized local compute is unavailable, leave the gate `BLOCKED/NOT_RUN` rather than substituting hosted compute.

## 10. Recurrence monitoring needs a denominator

Counting events alone can mislead. Track recurrence against exposure where possible:

- boards built;
- block instances populated;
- service interventions;
- machine-hours or cycles when justified;
- releases passing through the affected process;
- audits performed.

A drop from four events to one is not improvement if exposure fell from 400 boards to 10.

Useful states include `OPEN_CLUSTER`, `CAUSE_UNRESOLVED`, `CORRECTIVE_ACTION_ACTIVE`, `MONITORING`, `RECURRENCE_DETECTED`, and `SYSTEMIC_CLOSURE_SUPPORTED`.

**NO NEW REPORTS ≠ RECURRENCE ELIMINATED.**

## 11. Service substitutions do not become new-build alternates by recurrence

If technicians repeatedly use the same service-only substitution, the recurrence may justify engineering an approved alternate. It does not itself qualify the part.

Preserve exact old/new identity, consumed semantic facets, datasheet/reference evidence, qualification envelope, new-build versus service applicability, and population history. Until that work is complete:

**REPEATED SERVICE SUCCESS ≠ QUALIFIED NEW-BUILD ALTERNATE.**

## 12. Safety boundary

A recurrence involving an ordinary controller's safety-status input, watchdog, handshake, STO request, or inhibit path can expose an ordinary-controller block/integration defect. Correct it under this methodology.

That recurrence history cannot establish PL/SIL/category, stopping performance, final-element validation, or personnel-safety authority. The independent safety architecture remains authoritative unless separately engineered and validated.

**RELIABLE SAFETY MONITORING ≠ SAFETY FUNCTION VALIDATION.**

## 13. Adversarial lab

### Case A — three similar connector failures

Three boards have intermittent field inputs at the same connector family. One is a crimp defect, one is an omitted return conductor, and one is an input-block threshold problem.

Expected reasoning: do not cluster by connector family. These are manufacturing/harness, board connection-contract, and reusable electrical-contract causes respectively.

### Case B — repeated hand-built interface network

Four board variants each contain a small level-shift/protection network between the same two interface classes.

Expected reasoning: test for a genuine reusable transformation. If supported, create/qualify an adapter; do not duplicate it in connection blocks or alter both neighboring primitives.

### Case C — checklist drift

Three unrelated blocks have implementation evidence that materially advanced without same-change checklist reconciliation.

Expected reasoning: repair the individual records, then treat recurrence as a process/governance defect and add a preventive/detective control. Do not claim the blocks share an electrical defect.

### Case D — recurring service substitution

A legacy component is unavailable and the same substitute has worked in several repairs.

Expected reasoning: service history is evidence input, not alternate qualification. Keep new-build authority blocked until exact equivalence/qualification work supports it.

### Case E — ordinary safety-status monitor

A non-safety FPGA input repeatedly misreports an independent safety relay's status because board-specific mapping is wrong.

Expected reasoning: fix the ordinary monitoring integration and affected diagnostics. Do not reinterpret successful monitoring as validation or authority for the independent safety function.

## 14. Machine-readable recurrence/systemic-corrective-action record

A future release/catalog layer should support records conceptually like:

```yaml
recurrence_id: REC-<stable-id>
state: OPEN_CLUSTER
source_event_ids: []
normalized_symptoms: []
normalized_cause:
  semantic_id: null
  state: UNRESOLVED
classification: null # BOARD_INTEGRATION | BLOCK_DEFECT | ADAPTER_GAP | SHARED_RESOURCE | PROCESS
rejected_causes: []
changed_semantic_ids: []
affected_consumers: []
affected_populations: []
corrective_action:
  artifact_revisions: []
  authority_record: null
regression:
  required_gate_ids: []
  evidence_ids: []
monitoring:
  exposure_basis: null
  exposure_count: null
  recurrence_count: null
  observation_window: null
systemic_closure:
  state: OPEN
  authority_record: null
```

This is schema direction, not a claim that OpenPressBrake currently implements this record.

## Catalog stress-test result

BD45 exposes a missing recurrence/systemic-corrective-action layer joining closed/current exception history to normalized semantic causes, architectural classification, reverse dependencies, affected populations, corrective-action revisions, targeted regression, exposure denominators, and recurrence monitoring.

The teaching stress test also reinforces a catalog requirement: reusable blocks need stable semantic IDs and sufficiently complete machine-readable resource/interface contracts for recurrence clustering to identify a generic defect without relying on unwritten board knowledge. Current RS-485 FPGA LUT/register estimates remain explicitly TBD until gateware evidence exists; that is visible incompleteness, not permission to invent numbers.

Internal readiness of the proposed recurrence infrastructure: **ENGINEERING_REVIEW_NEEDED**.

## Completion criteria

The student passes BD45 when they can take a mixed exception history, avoid false clustering, identify common semantic causes, classify each systemic issue at the correct block/adapter/shared-resource/integration/process layer, determine cross-population reach, choose bounded regression, preserve service/new-build and safety boundaries, and define evidence-based recurrence monitoring.

## Next lesson

BD46 should cover **corrective-action effectiveness, leading indicators, and prevention evidence**:

`systemic correction -> preventive/detective controls -> leading indicators -> exposure-normalized monitoring -> escape detection -> effectiveness review -> control tuning -> sustained closure or recurrence reopen`
