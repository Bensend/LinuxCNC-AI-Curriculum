# BD58 — Equivalence-Proof Lifecycle, Review Expiration, and Assumption Drift

## Purpose

BD57 established that preserving old evidence after a change is a claim-specific proof obligation. BD58 adds the missing lifecycle rule: a preservation proof is itself evidence with dependencies and can later become stale.

`preserved-evidence record -> monitored assumptions -> authority/resource/machine-fact drift -> trigger evaluation -> proof expiration or continued validity -> targeted revalidation -> renewed promotion`

This applies to BLOCK ENGINEERING and BOARD INTEGRATION. It grants no personnel-safety authority to ordinary LinuxCNC/FPGA evidence.

## Student-material readiness audit

Every repository file named below was opened and inspected in its CURRENT form during this run before being used here.

**VERIFIED_FOR_LESSON** for the bounded claims used:

- Curriculum `README.md` — provenance, reproducibility, uncertainty and technical-handoff criteria.
- Curriculum `WORK_SELECTION_POLICY.md` — evidence-gaining autonomous work selection.
- Curriculum `hardware/4000-board-design/BD57_EVIDENCE_EQUIVALENCE_DECISIONS_AND_PRESERVATION_PROOFS.md` — preservation proof method and future invalidation triggers.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — board-design progress through BD57.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthful status, concrete evidence and mandatory maintenance after material changes.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block/adapter/board-integration ownership.
- OpenPressBrake `hardware/blocks/shared_adc_dac/design/REV32_ADC_REFERENCE_POWER_RECONCILIATION.md` — current bounded REF5020/ADS7953 power facts and explicit open terms.

**ENGINEERING_REVIEW_NEEDED** as complete current status authority:

- OpenPressBrake `hardware/blocks/shared_adc_dac/STATUS_CHECKLIST.md` — the current checklist still describes authority through Rev31 and does not list the already-current Rev32 REF5020 power reconciliation in its status/evidence/next-checkpoint sections. Its other bounded statements remain useful, but the omission is status drift under the repository maintenance rule.

No file above is presented as evidence that the OpenPressBrake controller is production-proven.

## Learning objectives

The student must be able to:

1. treat an equivalence/preservation proof as a versioned evidence object rather than a permanent waiver;
2. identify the assumptions and authority facets that must remain true for that proof to stay valid;
3. distinguish semantic drift from irrelevant repository churn;
4. define machine-checkable expiration triggers where possible;
5. classify a proof as current, narrowed, stale, blocked, superseded or historical;
6. calculate the minimum-safe revalidation required after a trigger;
7. renew promotion only against current authority and current evidence identity;
8. keep reusable-block evidence separate from board-specific integration evidence; and
9. refuse to inherit personnel-safety credit from ordinary-control preservation proofs.

## 1. Preservation proofs have dependencies too

A BD57 proof says old evidence `E` still supports claim `C` under a new state because every claim-relevant changed premise was shown equivalent. That decision creates a new evidence object `P`.

`P` depends on at least:

- the exact claim identity;
- the old evidence identity;
- the old and new authority revisions/digests compared;
- the equivalence dimensions actually proved;
- unresolved facts explicitly excluded from the proof;
- the board/configuration scope;
- shared-resource assumptions;
- model/tool assumptions where relevant;
- reviewer authority; and
- future invalidation triggers.

If one of those premises later changes, `P` must be reconsidered even when `E` and the original proof file are untouched.

**PROOF FILE UNCHANGED ≠ PROOF CURRENT.**

**PRIOR ENGINEERING REVIEW ≠ PERMANENT ENGINEERING AUTHORITY.**

**SAME NOMINAL FUNCTION ≠ SAME PRESERVATION PREMISES.**

## 2. Lifecycle states

Use explicit states rather than a permanent boolean `preserved: true`:

- `CURRENT_PRESERVED` — all monitored premises remain satisfied.
- `CURRENT_NARROWED` — proof remains valid only for a reduced claim/envelope.
- `STALE_TRIGGERED` — a monitored premise changed and affected claims require re-evaluation.
- `BLOCKED_UNKNOWN` — current validity depends on an unresolved fact.
- `SUPERSEDED` — newer evidence/authority replaces the preservation decision.
- `HISTORICAL_ONLY` — retained for traceability but forbidden as current release evidence.

Expiration does not mean the old test was wrong. It means the proof that connected that test to the current claim is no longer established.

## 3. Trigger classes

A preservation record should monitor semantic triggers, not arbitrary elapsed time alone.

### Authority drift

Examples: block contract revision, machine overlay revision, changed status authority, corrected datasheet limit, changed configuration lock.

### Operating-envelope drift

Examples: higher voltage/current, temperature extension, faster scan/update rate, different source/load impedance, changed simultaneous-channel assumptions.

### Shared-resource drift

Examples: another consumer is added to an ADC, bus, rail, FPGA bank or reference; aggregate loading changes; allocation order/timing changes.

### Physical-machine fact drift

Examples: `VERIFY_AT_MACHINE` is resolved differently than assumed, replacement sensor differs, harness/grounding is changed, installed drive parameters change.

### PCB/physical-implementation drift

Examples: placement/routing changes alter analog return, thermal coupling, creepage, EMC exposure or current path assumed by evidence.

### Tool/model/method drift

Examples: model fidelity changes, simulator/synthesis interpretation changes, test fixture changes, calibration expires, or a prior surrogate is replaced by manufacturing-intent topology.

### Safety-authority drift

Ordinary board-control proof state never grants personnel-safety authority. If an independent safety design changes, ordinary-control evidence must not be silently promoted to fill the gap.

## 4. Do not expire proofs merely because time passed

Calendar age can be a review trigger when external assumptions are known to age—calibration, supplier revision, standards baseline, environmental qualification, etc. But arbitrary annual expiration is not a substitute for semantic dependency tracking.

Likewise, a new commit somewhere in the repository is not itself a reason to invalidate every proof.

The correct question is:

`Did a claim-relevant monitored premise change?`

BD56 reverse dependencies and BD57 preservation records should answer that question together.

## 5. Worked OpenPressBrake case: shared ADC power handoff

Current Rev32 closes one narrow power-budget fact without changing the circuit topology: one populated shared ADC resource now has a guaranteed known `5V_ANALOG` subtotal of 4.2 mA maximum from ADS7953 +VA (3.0 mA max) plus REF5020 VIN (1.2 mA max over -40 C to +125 C).

Rev32 explicitly leaves two controller-side power terms open: OPA192 on `5V_ANALOG` and ADS7953 `+VBD` on `3V3`. It also states that the 4.2-mA subtotal is a rail-local contract and must not be summed directly into upstream 24-V current without the actual conversion topology/efficiency/startup behavior.

This is a useful lifecycle example because a preservation decision such as:

`PRESERVE: existing ADC topology evidence remains applicable; only a manufacturer-backed power bound was tightened`

can be valid for topology/connectivity claims while changing downstream board-power evidence.

### 5.1 What survives Rev32

Because Rev32 says topology, voltage range and loading topology are unchanged, existing evidence for the already-frozen ADC/reference connectivity is not automatically invalidated merely by replacing a typical-only REF5020 power estimate with a guaranteed maximum.

That is bounded preservation, not whole-block qualification.

### 5.2 What must update

Any board-level power-budget claim that previously consumed only the older guaranteed subtotal is now stale until it consumes the new 4.2-mA `5V_ANALOG` subtotal exactly once per populated shared resource.

Any claim that the shared ADC's total controller-side power is fully bounded remains `BLOCKED_UNKNOWN` because OPA192 and ADS7953 +VBD maxima remain open.

Any upstream protected-24-V budget must preserve rail conversion boundaries rather than treating 5-V milliamps as 24-V milliamps.

### 5.3 The adversarial catalog finding

The current `shared_adc_dac/STATUS_CHECKLIST.md` still describes authority through Rev31 and its authoritative-evidence list/next checkpoint omit Rev32, even though Rev32 is already on current main. Under `STATUS_RULES.md`, material design/evidence changes require the checklist to be updated in the same change.

Classification: **ENGINEERING_REVIEW_NEEDED** for the checklist as complete current-status authority until Rev32 is reconciled.

This is exactly the BD58 failure mode: a technically valid new evidence item exists, but a lifecycle consumer looking only at the prior status authority can miss the drift. Proof/current-status maintenance must be dependency-driven and fail closed when authority surfaces disagree.

OpenPressBrake remains read-only in this lesson because current main is actively advancing block/integration work. The curriculum records the defect rather than racing active engineering changes.

## 6. Preservation record with lifecycle fields

A durable machine-readable record should extend BD57 with lifecycle metadata:

```yaml
preservation_id: PRES-SHARED-ADC-001
claim_id: shared_adc.connectivity.current
state: CURRENT_PRESERVED
old_evidence_id: exact_prior_result
proof_authority_digest: exact_digest
scope:
  block_revision: exact_revision
  board_configuration: exact_or_not_applicable
monitored_dependencies:
  - shared_adc.topology
  - shared_adc.range
  - shared_adc.consumer_source_impedance_contract
invalidation_triggers:
  - topology_change
  - range_change
  - source_impedance_or_scan_contract_change
negative_scope:
  - complete_power_budget
  - pcb_layout
  - surge_eft
last_reviewed_against: exact_current_authority
reviewer_authority: engineering_review_required
```

For a power claim, the monitored dependency set would be different. That is the point: lifecycle state is claim-specific.

## 7. Trigger evaluation algorithm

For each semantic change:

1. resolve current authority first;
2. map changed facets to stable semantic IDs;
3. reverse-traverse to preservation records that monitor those IDs;
4. evaluate each proof's stated equivalence dimensions and negative scope;
5. classify `CURRENT_PRESERVED`, `CURRENT_NARROWED`, `STALE_TRIGGERED`, `BLOCKED_UNKNOWN`, `SUPERSEDED`, or `HISTORICAL_ONLY`;
6. propagate staleness to generated artifacts/releases that consumed the proof;
7. derive the minimum evidence needed to restore each stale claim; and
8. require promotion against the new exact authority identity.

A proof may survive one changed facet while a neighboring proof expires. Never invalidate or preserve an entire block by filename when the claims differ.

## 8. Minimum-safe renewal

When a trigger fires, do not automatically rerun every test. Re-open the affected proof and ask what premise changed.

Examples:

- New guaranteed REF5020 current: update/review the affected power budget; no SPICE rerun is justified solely by that datasheet maximum.
- Added ADC consumer: re-evaluate allocation, source impedance/scan-rate settling and aggregate power; primitive evidence may survive if its own premises are unchanged.
- Changed ADC range/reference: nominal scaling evidence becomes stale and requires recalculation/revalidation.
- PCB analog-return change: layout-sensitive noise/EMC evidence becomes stale even if the schematic is identical.
- New machine measurement contradicts an assumed endpoint: invalidate the assumption-dependent mapping/calibration proof; do not edit the reusable primitive merely to fit the machine.

Use the evidence class required by the changed premise. Documentation review cannot replace a physical measurement, and simulation cannot replace routed timing or commissioning evidence.

## 9. Renewal is a new promotion event

After targeted revalidation, record:

- exact prior proof ID;
- trigger that expired/narrowed it;
- exact new authority and configuration;
- evidence rerun/recalculated/remeasured;
- evidence explicitly preserved;
- negative scope;
- reviewer/promoter identity/authority; and
- new future invalidation triggers.

Do not mutate history to make an old proof look continuously valid. Preserve the old decision and create a new promoted state linked to it.

## 10. Reusable blocks versus board integration

Lifecycle tracking reinforces modularity.

A board-specific connector, allocation or harness change may expire board-integration evidence while reusable primitive calculations remain current. A changed shared resource may stale several consumers without changing their primitive schematics. A primitive contract revision may invalidate many boards even if their connection blocks did not change.

Do not solve these cases by copying board-specific assumptions into reusable blocks. Use typed dependencies and the block/adapter/integration boundary.

## 11. Lab — expire, narrow, or preserve?

Start with a hypothetical promoted preservation proof for one shared ADS7953 consumer. For each event, classify proof lifecycle and derive the minimum-safe renewal plan:

1. REF5020 quiescent-current authority changes from typical-only to a guaranteed 1.2-mA full-temperature maximum.
2. A second identical consumer is allocated while per-channel topology is unchanged.
3. Scan rate doubles but remains inside a previously proven settling envelope.
4. Scan rate crosses the consumer's proven source-impedance boundary.
5. OPA192 maximum current becomes defensibly bounded.
6. PCB placement moves the analog acquisition path next to a high-di/dt switching loop.
7. A machine measurement resolves a previously unknown sensor endpoint outside the assumed nominal range.
8. An unrelated documentation typo is fixed.

For each submit: claim ID, monitored dependency, trigger/no-trigger reason, lifecycle state, preserved evidence, stale evidence, negative scope, minimum-safe revalidation, reviewer authority and next invalidation trigger.

## 12. Catalog stress-test result

OpenPressBrake has strong local reasoning about changed envelopes and deferred qualification, but the current Rev32/checklist mismatch shows that lifecycle state is not yet mechanically joined across evidence and status authority.

Classification: **ENGINEERING_REVIEW_NEEDED** for a machine-readable proof-lifecycle layer that supports:

- stable proof/claim/facet IDs;
- reverse dependencies from semantic facets to preservation proofs;
- exact authority/configuration digests;
- trigger classes and trigger evaluation;
- partial/narrowed proof state;
- unresolved physical facts;
- proof-to-generated-artifact/release consumption;
- renewal/promotion lineage;
- Show Where Used for evidence; and
- fail-closed detection when current status authority omits a material newer evidence item.

Do not solve this with blanket expiration dates, blanket reruns, or whole-file current/stale flags.

## 13. Completion standard

A student passes BD58 only if they can take a previously justified preservation proof, expose its monitored assumptions, detect later semantic drift, preserve only unaffected claims, choose the minimum evidence needed for stale claims, and renew promotion without rewriting history.

## Compute

No simulation, synthesis, place-and-route, timing run or other executable engineering verification is required for this methodology or the audited Rev32/status-drift finding. No GitHub-hosted compute is authorized. If a future lifecycle trigger genuinely requires executable verification, use only `[self-hosted, openpressbrake]`.

## Safety boundary

BD58 concerns lifecycle management for ordinary board-design/controller evidence. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation or personnel-safety authority. Ordinary LinuxCNC/FPGA evidence receives zero personnel-safety credit unless a separate safety-rated design and validation explicitly supports that claim.
