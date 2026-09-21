# BD11 — Release Maintenance and Evidence Invalidation Under Design Change

## Purpose

A reusable hardware block is not finished when it passes once. It remains trustworthy only if later changes invalidate exactly the evidence they should invalidate — no less and no more.

This lesson teaches the BLOCK ENGINEERING maintenance chain:

`requirement -> failure mode -> evidence -> applicability boundary -> design change -> affected-evidence graph -> RERUN / RECALCULATE / REVIEW / REQUALIFY -> revised release state`

The adversarial question is: **after a change, can another engineer determine from durable authority which claims remain proved, which evidence is stale, and which release gates reopen without relying on memory?**

## Hard student-material audit

The following current OpenPressBrake files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims made here:

- `hardware/blocks/differential_encoder/engineering.yaml`
- `hardware/blocks/differential_encoder/manifest.yaml`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`
- `hardware/blocks/differential_encoder/design/REV1_RECEIVER_TIMING_CONTRACT.md`

They are suitable for teaching ownership, evidence classes, recalculation triggers, release-gate reopening, and the distinction between reusable-block changes and machine/board-configuration changes. They are **not** evidence that the differential-encoder block or the OpenPressBrake board is fully qualified or production-proven.

Current limitations verified directly from those files include cable/termination selection, protected encoder +5 V field power, cable/reflection qualification, board-level abnormal-condition/ESD/surge work, schematic visual review, PCB integration, synthesis/P&R/timing evidence, cost, and final release gates.

The newest OpenPressBrake main also contains active board-level return-domain integration work. This lesson therefore consumes the encoder package read-only and does not modify overlapping OpenPressBrake engineering files.

## 1. Evidence proves a bounded claim, not a block forever

Every retained item of evidence should be read as a tuple:

`claim + design/configuration identity + operating envelope + evidence method + acceptance criterion + result`

If any element that matters to the claim changes, applicability must be reconsidered.

Examples:

- TI receiver timing data can remain applicable when a board connector changes, provided the receiver part and relevant operating conditions did not change.
- A cable-reflection result does not remain applicable after cable type, length, remote termination, or selected local termination changes unless the prior evidence explicitly bounded the new case.
- A production-connectivity validator does not prove a new PCB layout's transient-current path.
- A successful FPGA package binding does not automatically survive a package-pin plan change.

Freeze:

`EVIDENCE EXISTS != EVIDENCE STILL APPLIES`

## 2. Use four different change responses

BD08 introduced four responses. BD11 makes their boundaries explicit.

### RERUN

Use when the evidence method remains valid and the changed artifact is one of its inputs.

Examples:

- rerun a deterministic connectivity validator after connectivity changes;
- rerun synthesis/P&R/timing after HDL, FPGA pin, clock, constraint, or relevant module configuration changes;
- rerun a bounded simulation after a component/value/topology change that the model actually represents.

A rerun is not automatically enough if the model itself no longer represents the changed physics.

### RECALCULATE

Use when an engineering equation remains valid but an input changed.

The current encoder engineering file explicitly gives examples:

- instance-count change -> aggregate 3V3 receiver current, GPIO count, package count, FPGA pin fit, connector count and field-supply budget;
- installed encoder/rate change -> rate compatibility, field-supply budget and termination review;
- cable/remote-termination change -> rate compatibility, termination selection and reflection/SI review.

### REVIEW

Use when the change affects architecture, ownership, geometry, current path, assumptions, or evidence applicability and cannot be disposed of by a scalar recalculation alone.

The current encoder contract requires review when PCB geometry or chassis path changes materially, specifically for pair routing, connector-protection placement and chassis transient return.

### REQUALIFY

Use when the changed item can invalidate physical qualification or the operating envelope in a way that requires new physical evidence.

Examples include changed connector/protection layout affecting ESD current path, changed cable/termination at the qualified edge rate, changed field-supply fault behavior, or a component substitution whose relevant abnormal-condition behavior is not already bounded by accepted evidence.

Freeze:

`RERUN != RECALCULATE != REVIEW != REQUALIFY`

## 3. Build an affected-evidence graph

Do not maintain evidence as an unstructured folder of reports. For each claim, record dependencies.

A useful conceptual record is:

```text
claim: receiver_timing_within_contract
requires:
  - selected_receiver == AM26LV32EIPWR
  - receiver_supply/temperature within manufacturer contract
  - installed_edge_rate known
  - FPGA decoder/timing behavior applicable
  - cable/termination channel qualified
supporting_evidence:
  - manufacturer timing contract
  - installed machine rate evidence
  - cable/termination evidence
  - FPGA timing/runtime evidence
on_change:
  receiver MPN -> REVIEW + RECALCULATE + likely REQUALIFY
  installed rate -> RECALCULATE + REVIEW
  cable/termination -> RECALCULATE + REVIEW + physical qualification as required
  FPGA image/timing -> RERUN synthesis/P&R/timing + REVIEW
```

The graph should allow a release tool or reviewer to answer both directions:

1. **What evidence supports this claim?**
2. **What claims become suspect if this item changes?**

## 4. Worked change A — instance count changes

Suppose a different machine needs four encoder primitives rather than three.

What changes:

- board configuration instance count;
- aggregate receiver 3V3 current;
- FPGA GPIO demand;
- receiver package count;
- connector count;
- protected encoder field-supply budget;
- FPGA pin-fit/integration work.

What does **not** automatically change:

- AM26LV32E per-instance topology;
- 26 ns maximum receiver propagation-delay authority;
- 6 ns intra-device skew authority;
- reusable one-encoder-per-primitive contract;
- personnel-safety boundary.

This is a strong example of why `block changed` and `board configuration changed` must not be collapsed into one state.

Freeze:

`INSTANCE COUNT CHANGE != REUSABLE RECEIVER TOPOLOGY CHANGE`

## 5. Worked change B — cable or termination changes

The current reusable encoder deliberately does not select populated termination from the primitive. The machine cable/end topology owns that fact.

A cable or remote-termination change triggers:

- recalculation/review of installed rate compatibility;
- termination-variant selection review;
- reflection/signal-integrity review;
- physical qualification when the prior bounded evidence no longer covers the new channel.

It does **not** justify changing the reusable receiver circuit merely to avoid obtaining machine evidence.

The current timing contract is explicit that the published typical 32 MHz characteristic is not a guaranteed all-corners system acceptance limit. A cable change therefore cannot be accepted merely because `new edge rate < 32 MHz`.

Freeze:

`DATASHEET RECEIVER CAPABILITY != CABLE/SYSTEM QUALIFICATION`

## 6. Worked change C — receiver or protection substitution

A substitute component with similar headline specifications is a design change, not a procurement footnote.

Review at minimum:

- exact pin/package connectivity;
- supply/current envelope;
- differential threshold and common-mode behavior;
- propagation delay/skew;
- fail-safe/open-input behavior;
- protection standoff/capacitance/clamp behavior;
- temperature and abnormal-condition ratings;
- PCB footprint and transient-current geometry;
- model/validator applicability;
- BOM and provenance authority.

Existing cable, transient, simulation or manufacturer evidence may be partially reusable, fully stale, or irrelevant depending on what changed. Record that determination claim by claim.

Freeze:

`FORM/FIT SIMILAR != EVIDENCE EQUIVALENT`

## 7. Worked change D — PCB geometry or chassis path changes

The current encoder engineering contract explicitly reopens pair-routing, connector-protection-placement and chassis-transient-return review when PCB geometry or chassis path changes materially.

This matters because a schematic can remain electrically identical while physical qualification changes substantially.

Examples:

- moving the TVS away from the connector;
- changing the `CHASSIS_PE` entry path;
- routing transient return through logic copper;
- changing pair geometry/stackup;
- adding a mounting or shield path that creates a new chassis join.

A schematic connectivity validator can still pass while the relevant physical claim becomes false.

Freeze:

`SCHEMATIC UNCHANGED != PHYSICAL EVIDENCE UNCHANGED`

## 8. Release state must move backward when evidence becomes stale

Release status is not monotonic.

If a released or nearly released block changes, reopen every gate whose evidence no longer applies. Do not preserve a green checkbox because it was green on the previous revision.

A useful state transition is:

`qualified revision A -> change detected -> impact analysis -> affected claims NOT CURRENT -> required evidence regenerated -> review -> qualified revision B`

Retain the old evidence with its old revision identity. Do not rewrite history to make it appear that revision-A testing was performed on revision B.

Freeze:

`PREVIOUS PASS + NEW REVISION != CURRENT PASS`

## 9. Machine facts have their own invalidation triggers

`VERIFY_AT_MACHINE` is not a one-time ritual. Machine configuration can change after commissioning.

For the encoder example, machine-side invalidation events include:

- encoder replacement with a different model/output class;
- machine speed increase that changes maximum edge rate;
- cable replacement/reroute;
- termination added/removed at the far end;
- encoder supply rewiring;
- shield/bond changes;
- undocumented cabinet modifications.

Commissioning records should identify the machine configuration they witnessed. A later machine change may require new machine verification even when the PCB did not change.

## 10. FPGA and software evidence participates in the same graph

Hardware release maintenance does not stop at the schematic.

Reopen FPGA evidence when relevant changes include:

- package-pin allocation;
- FPGA device/package;
- clocks/PLL plan;
- HDL/module implementation;
- LiteX-CNC module configuration;
- timing constraints;
- transport/register layout;
- driver/runtime revision where host semantics are part of the claim.

For synthesis/place-route/timing questions, executable evidence must use only the self-hosted `[self-hosted, openpressbrake]` runner. This lesson does not require such compute because no FPGA design input is being changed here.

## 11. Change-control ledger

For each proposed change, create a durable ledger before declaring the new revision ready:

| Field | Required content |
|---|---|
| change ID | unique revision/change reference |
| changed authority | exact file/component/configuration/machine fact |
| old -> new | explicit delta |
| ownership layer | reusable block / board integration / connection / FPGA / machine configuration |
| affected claims | IDs or named claims |
| existing evidence | exact artifact/revision |
| applicability | RETAIN / PARTIAL / STALE / UNKNOWN |
| response | RERUN / RECALCULATE / REVIEW / REQUALIFY |
| acceptance criterion | defined before execution |
| result | PASS / FAIL / BLOCKED / TBD |
| release gates reopened | explicit list |
| reviewer/signoff | when required |

`UNKNOWN` must fail closed. It is not equivalent to retained.

## 12. Catalog stress-test result

The differential-encoder engineering package performs well for this lesson because it already exposes ownership, validation states, deferred qualification, `VERIFY_AT_MACHINE` facts, and several explicit recalculation/review triggers.

The stress test also reveals a catalog-wide improvement opportunity: **change-impact semantics should eventually become a first-class machine-readable block-contract field rather than depending on each block author to remember an informal list.** A mature schema should distinguish at least `RERUN`, `RECALCULATE`, `REVIEW`, and `REQUALIFY`, link triggers to claim/evidence IDs, and allow board integration to aggregate affected evidence across block boundaries.

This is recorded as a curriculum/catalog action item. It is not patched into OpenPressBrake during this run because the repository has active board-integration work and a schema-level change should be coordinated rather than introduced from one lesson opportunistically.

## Lab — adversarial revision change

Using a current reusable block that you personally open and verify:

1. choose one bounded current claim;
2. identify every artifact that supports it;
3. state the design/configuration envelope to which the evidence applies;
4. introduce one reusable-block component/value/topology change;
5. introduce one board-integration change;
6. introduce one machine-configuration change;
7. for each change, classify every affected evidence item as `RETAIN`, `PARTIAL`, `STALE`, or `UNKNOWN`;
8. assign `RERUN`, `RECALCULATE`, `REVIEW`, or `REQUALIFY` as appropriate;
9. identify which release gates reopen;
10. identify any evidence that remains valid and explain why;
11. preserve the old revision/evidence rather than rewriting it;
12. state the exact evidence needed before the new revision can regain its former release state.

### Lab pass criteria

A passing submission must:

- distinguish reusable-block, board-integration and machine-configuration changes;
- invalidate evidence claim by claim rather than all-or-nothing;
- retain still-applicable manufacturer/calculation evidence where justified;
- reopen physical qualification when physical implementation changes outside the prior evidence envelope;
- never treat CI green as universal qualification;
- keep `VERIFY_AT_MACHINE` facts tied to the actual installed configuration;
- require self-hosted local compute only when executable verification is genuinely needed;
- preserve the ordinary-control versus personnel-safety boundary.

## Durable freezes

- `EVIDENCE EXISTS != EVIDENCE STILL APPLIES`.
- `RERUN != RECALCULATE != REVIEW != REQUALIFY`.
- `INSTANCE COUNT CHANGE != REUSABLE RECEIVER TOPOLOGY CHANGE`.
- `DATASHEET RECEIVER CAPABILITY != CABLE/SYSTEM QUALIFICATION`.
- `FORM/FIT SIMILAR != EVIDENCE EQUIVALENT`.
- `SCHEMATIC UNCHANGED != PHYSICAL EVIDENCE UNCHANGED`.
- `PREVIOUS PASS + NEW REVISION != CURRENT PASS`.
- `UNKNOWN EVIDENCE APPLICABILITY -> FAIL CLOSED`.
- `ORDINARY LINUXCNC/FPGA CONTROL != PERSONNEL-SAFETY AUTHORITY`.

## Safety boundary

This lesson concerns engineering evidence and release maintenance for ordinary controller hardware. It does not grant personnel-safety authority to LinuxCNC, FPGA logic, encoder feedback, watchdogs, or ordinary board-control functions. A change affecting a separately engineered safety-rated function must follow that safety function's own change-control and validation process.