# BD57 — Evidence-Equivalence Decisions and Preservation Proofs

## Purpose

BD56 taught selective invalidation. BD57 addresses the dangerous middle case: a dependency changed, but an engineer believes an existing result still applies.

`changed dependency -> claimed equivalence -> equivalence criteria -> counterexample search -> bounded preservation proof -> reviewer authority -> preserved-evidence record -> future invalidation trigger`

The goal is not to avoid reruns. It is to distinguish a defensible preservation proof from an unsupported assertion that “nothing important changed.” This applies to BLOCK ENGINEERING and BOARD INTEGRATION. It grants no personnel-safety authority to ordinary LinuxCNC/FPGA evidence.

## Student-material readiness audit

The following current files were opened and inspected during this run before being used here:

- Curriculum `README.md` — **VERIFIED_FOR_LESSON** for provenance, reproducibility, uncertainty handling, and technical-handoff completion criteria.
- Curriculum `WORK_SELECTION_POLICY.md` — **VERIFIED_FOR_LESSON** for evidence-gaining work selection.
- Curriculum `hardware/4000-board-design/BD56_EVIDENCE_DEPENDENCY_GRAPHS_SELECTIVE_INVALIDATION_AND_MINIMUM_SAFE_REVALIDATION.md` — **VERIFIED_FOR_LESSON** for typed dependency graphs, selective invalidation, and minimum-safe revalidation.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for progress through BD56 and the BD57 checkpoint.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for truthful status, concrete evidence, and maintenance after material changes.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for reusable-block versus adapter versus board-integration ownership.
- OpenPressBrake `hardware/blocks/lvdt_input/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for current `SIMULATION-READY` status, Rev-9 manifest reconciliation, retained historical evidence, and remaining release gates.
- OpenPressBrake `hardware/blocks/lvdt_input/manifest.yaml` — **VERIFIED_FOR_LESSON** for the current Rev-9-reconciled machine-readable contract, including the 0..12-V powered-transducer interface, LT6015 front end, 1-kOhm ADC isolation, shared ADS7953 ownership, unresolved machine facts, and zero direct FPGA GPIO.
- OpenPressBrake `hardware/blocks/lvdt_input/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` — **VERIFIED_FOR_LESSON** for the current board-consumption boundary, N-channel scaling rule, shared-converter ownership, and `VERIFY_AT_MACHINE` facts.
- OpenPressBrake `hardware/blocks/lvdt_input/REFERENCE_REBASE.md` — **ENGINEERING_REVIEW_NEEDED** as a complete current-status authority because its current-exact-connectivity section still says `manifest.yaml` is Rev-2-era and must be reconciled, while the current manifest and authoritative status checklist say Rev 9 already performed that reconciliation. It is used here only for bounded provenance/delta facts that remain consistent with current authority and as a concrete stale-prose defect.

No file above is presented as evidence that the OpenPressBrake controller is production-proven.

## Learning objectives

The student must be able to:

1. distinguish unchanged bytes, unchanged topology, unchanged interface semantics, and unchanged evidence applicability;
2. define the exact claim whose evidence is proposed for preservation;
3. identify every premise on which the old evidence depended;
4. define equivalence criteria before deciding that evidence survives;
5. search for counterexamples and hidden changed premises;
6. recognize changes that require rerun, recalculation, remeasurement, or requalification;
7. record bounded preservation with provenance, reviewer authority, negative scope, and future invalidation triggers;
8. preserve reusable-block versus board-integration ownership; and
9. refuse to turn ordinary-controller equivalence arguments into personnel-safety credit.

## 1. Preservation is a proof obligation

Suppose evidence `E_old` supported claim `C` under dependency set `D_old`. A dependency changes to `D_new`.

Do not begin with “can we keep the test result?” Begin with:

`Does E_old still prove C under D_new for every premise relevant to C?`

A preservation decision is valid only when the changed dependency is shown equivalent with respect to the claim's complete relevant premise set.

**UNCHANGED OUTPUT ≠ UNCHANGED PREMISES.**

**UNCHANGED TOPOLOGY ≠ UNCHANGED OPERATING ENVELOPE.**

**SAME PART NUMBER ≠ SAME BOARD CONTEXT.**

**NO NEW FAILURE OBSERVED ≠ OLD EVIDENCE PRESERVED.**

## 2. Evidence equivalence is claim-specific

Two configurations can be equivalent for one claim and materially different for another.

Example: changing a board connector while preserving the exact electrical net may be equivalent for a reusable analog-divider calculation. It is not automatically equivalent for creepage, current rating, harness pinout, shielding, placement, EMC, or machine commissioning evidence.

Therefore never record a global statement such as `old_evidence_still_valid: true` without naming the claim and the bounded semantic dimensions.

A useful decision set is:

- `PROVEN_EQUIVALENT_FOR_CLAIM` — changed dependency is equivalent for the named claim;
- `PRESERVED_WITH_NARROWER_SCOPE` — old evidence survives only for a subset of its prior claim set;
- `NOT_EQUIVALENT_REVALIDATE` — a relevant premise changed;
- `BLOCKED_UNKNOWN` — equivalence depends on an unresolved fact;
- `SUPERSEDED` — new authority intentionally replaces the old claim/evidence;
- `HISTORICAL_ONLY` — retained for provenance, not current consumption.

## 3. Define equivalence criteria before inspecting the desired outcome

For each proposed preservation, write the criteria first. Typical dimensions include:

- topology and component identity/value;
- electrical operating envelope;
- supply/return domains;
- startup, shutdown and de-energized behavior;
- protection/fault paths;
- source/load impedance;
- sample/update rate and timing assumptions;
- FPGA bank voltage, pin capability and clocking;
- shared-bus loading and protocol semantics;
- shared-resource population/capacity;
- connector/harness electrical constraints;
- PCB parasitics/thermal/current-return assumptions;
- software/HAL interpretation and scaling;
- physical-machine facts;
- evidence method/model/tool assumptions.

Not every dimension applies to every claim. The proof must state which dimensions matter and why the others do not.

## 4. Counterexample search is mandatory

A preservation proof must actively try to disprove itself.

Ask:

- Could the changed dependency alter a limit without changing nominal behavior?
- Could startup/de-energized behavior differ while powered steady-state behavior matches?
- Could a shared resource now be oversubscribed?
- Could a return path or fault path have moved?
- Could a board mapping preserve logical names but change electrical pin capability?
- Could a new machine fact narrow the allowed envelope?
- Could the old evidence have exercised a historical topology rather than the current one?
- Could a current source file contain stale prose that falsely suggests the old state is still current?

If a plausible counterexample cannot be ruled out from evidence, classify `BLOCKED_UNKNOWN` or revalidate. Convenience is not evidence.

## 5. Worked OpenPressBrake case: valve-position feedback

The current block retains the legacy ID `lvdt_input`, but the current Rev-1 machine interface is not a raw LVDT. Current machine evidence resolves a powered three-wire 0..12-V valve-position transducer. The current primitive uses a 49.9-kOhm/24.9-kOhm divider, 2.2-nF filter, lower BAS116, LT6015HS5 follower and 1.00-kOhm ADC isolation into a shared ADS7953 channel.

This is a strong lesson because several kinds of “equivalence” coexist.

### 5.1 Historical raw-LVDT assumption -> powered 0..12-V transducer

This is **NOT_EQUIVALENT_REVALIDATE/SUPERSEDED** for the field-interface claim. A raw-LVDT excitation/demodulation topology and a powered DC transducer do not share the same electrical contract merely because both measure valve position.

The legacy block name is not evidence of equivalence.

### 5.2 Historical Rev-2 simulation -> current Rev-7 topology

The authoritative checklist explicitly retains prior bounded ngspice evidence only for the Rev-2 circuit it actually exercised. Current Rev-7 connectivity changed the buffer/protection/acquisition details. Therefore that historical simulation is **HISTORICAL_ONLY** for the changed Rev-7 topology; it cannot be promoted by relabeling it.

This is exactly why evidence identity must include topology/input authority.

### 5.3 Rev-7 primitive -> Rev-1 board-integration handoff

The current handoff states that it creates no new electrical topology. It consumes the already-engineered primitive, allocates one shared ADS7953 channel per instance, keeps common MXO/OPA192/AINP acquisition circuitry in `shared_adc_dac`, and leaves sensor-power sizing and installed endpoint facts unresolved.

For a claim such as `VPOS.DIVIDER.NOMINAL_12V_MAPPING`, existing primitive calculation evidence can be **PROVEN_EQUIVALENT_FOR_CLAIM** across this topology-neutral board handoff if the exact divider, ADC range/reference assumptions, and relevant load/source premises are unchanged.

That preservation does **not** extend to:

- sensor branch fuse/current limit;
- installed maximum valid output;
- source impedance;
- calibration/linearity;
- hydraulic-loop bandwidth;
- cable/shield/grounding;
- PCB analog-return/noise behavior;
- surge/EFT qualification;
- board connector mapping; or
- personnel-safety authority.

Those remain separate claims or `VERIFY_AT_MACHINE` facts.

### 5.4 49.9-ohm -> 1.00-kOhm ADC isolation

This is not equivalent for partial-power input-current or acquisition-source-impedance claims. The current checklist records a new calculation and TI-characterization basis. Old evidence cannot be preserved for those claims simply because the nominal DC signal remains near the same value.

### 5.5 OPA192 -> LT6015HS5

This is not equivalent for the declared positive field-fault/powered-down buffer claim. The part change was made precisely because the prior premise was inadequate. A preservation assertion would erase the engineering reason for the revision.

## 6. A stale source can corrupt an equivalence proof

The current `REFERENCE_REBASE.md` contains a stale statement saying `manifest.yaml` is still Rev-2-era and must be reconciled. Current `manifest.yaml` and the authoritative status checklist instead record Rev-9 reconciliation.

This is a catalog stress-test defect.

Classification: **ENGINEERING_REVIEW_NEEDED** for `REFERENCE_REBASE.md` as a complete current-status source until that stale reconciliation paragraph/gate is corrected against current authority.

The lesson is broader than this one file:

**A PRESERVATION PROOF MUST PIN CURRENT AUTHORITY BEFORE COMPARING OLD AND NEW STATES.**

If an engineer compares against a stale intermediate description, the proof may demonstrate equivalence to a state that is no longer authoritative.

Because current OpenPressBrake main is actively changing this block/integration area, BD57 records the defect but does not overwrite the engineering source of truth in this run.

## 7. Preservation-proof record

A durable record should include at least:

```yaml
preservation_id: PRES-ENC-OR-ANALOG-001
claim_id: stable.semantic.claim.id
old_evidence_id: exact_prior_result
old_authority: exact_revision_or_digest
new_authority: exact_revision_or_digest
changed_dependencies:
  - stable.semantic.facet.id
equivalence_dimensions:
  topology: SAME
  electrical_envelope: SAME
  timing: NOT_RELEVANT_TO_THIS_CLAIM
counterexamples_checked:
  - named_failure_or_hidden_premise
result: PROVEN_EQUIVALENT_FOR_CLAIM
negative_scope:
  - claims_not_preserved
reviewer_authority: engineering_review_required
future_invalidation_triggers:
  - exact_semantic_change_that_reopens_this_decision
```

This is a methodology pattern, not a claim that OpenPressBrake already implements this schema.

## 8. Reviewer authority matters

Automation may detect candidate equivalence, compare semantic digests, and produce a proof packet. It should not silently promote evidence when the preservation decision requires engineering judgment.

Require human/authorized engineering review when equivalence depends on:

- interpretation of a datasheet boundary;
- whether a changed physical implementation preserves a modeled assumption;
- whether omitted failure modes are truly irrelevant;
- whether a machine measurement applies to the exact installed configuration;
- whether a board-layout change preserves analog, thermal, EMC, creepage, or current-return assumptions; or
- whether evidence class is adequate for the release claim.

Mechanical canonicalization and exact semantic identity can often be automated. Engineering equivalence is a stronger claim.

## 9. When rerun is mandatory

Do not preserve evidence merely to save compute when any claim-relevant premise changed and equivalence is not proved.

Typical mandatory revalidation triggers include:

- topology/component/value change relevant to the claim;
- operating envelope expansion;
- protection/fault-path change;
- supply/return-domain change;
- FPGA bank/pin/timing change affecting the claim;
- shared-resource loading crossing or approaching a characterized limit;
- model/tool change that affects interpretation;
- physical-machine fact contradicting an assumption;
- board-layout/parasitic change for layout-sensitive evidence;
- unresolved counterexample; or
- stale/contradictory authority that prevents a trustworthy comparison.

Use the correct evidence class. Static source review cannot replace a required physical measurement, and simulation cannot replace routed timing or machine verification.

## 10. Reusable block versus board integration

A board-specific change does not justify editing a reusable block merely to make preservation easier.

If a connector pin changes while the primitive electrical contract is unchanged, preserve primitive evidence where claim-specific equivalence is proved and revalidate the board mapping. If the board needs an electrical transformation, use the block/adapter/integration decision rule. If the primitive contract itself changes, reopen the primitive and every dependent consumer claim.

This is how evidence preservation reinforces modular architecture rather than weakening it.

## 11. Lab — preservation or rerun?

Using the audited valve-position example, classify each change and produce a bounded preservation proof or rerun plan:

1. Board integration instantiates a second identical primitive while the per-channel topology is unchanged.
2. The field connector changes to another family with adequate but different pin numbering.
3. Installed sensor documentation proves a 13.0-V valid maximum instead of nominal 12.0 V.
4. The ADS7953 scan schedule is increased beyond the current <=20-kSPS-per-channel contract.
5. The 1.00-kOhm isolation resistor changes tolerance but not nominal value.
6. The shared ADS7953 MXO driver topology changes.
7. PCB placement moves the analog front end next to proportional-valve switching loops.
8. A repository prose file changes, but its semantic facts are shown identical to current authority.

For each submit:

- exact claim IDs or proposed stable IDs;
- changed semantic dependencies;
- equivalence criteria;
- counterexamples checked;
- preserved evidence;
- stale evidence;
- negative scope;
- required reviewer authority;
- minimum-safe rerun/measurement set; and
- future invalidation triggers.

## 12. Catalog stress-test finding

OpenPressBrake already contains careful manual evidence-preservation reasoning: the valve-position checklist explicitly bounds historical Rev-2 simulation to Rev-2, preserves unchanged divider/reference facts where justified, and separates unresolved machine facts from board electronics.

But the reasoning is distributed across checklist, manifest, reference rebase, design records, and integration handoff. The stale `REFERENCE_REBASE.md` manifest-reconciliation paragraph demonstrates how easily a preservation decision could compare against the wrong authority.

Classification: **ENGINEERING_REVIEW_NEEDED** for a machine-readable preservation-proof layer supporting:

- stable claim/facet IDs;
- old/new authority digests;
- claim-specific equivalence dimensions;
- counterexample checklist/results;
- negative scope;
- reviewer authority;
- future invalidation triggers;
- links to dependency-graph nodes from BD56; and
- fail-closed refusal when current authority is contradictory.

Do not solve this by declaring whole files equivalent, deleting historical evidence, or copying board-specific facts into reusable primitives.

## 13. Completion standard

A student passes BD57 only if they can defend both sides:

- preserve evidence when every relevant premise is demonstrably equivalent; and
- demand revalidation when even a small change alters a claim-relevant premise or leaves a plausible counterexample unresolved.

The desired behavior is neither maximal rerunning nor maximal reuse. It is bounded, reviewable engineering proof.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification is required to establish the methodology or the audited stale-source defect in this lesson. No GitHub-hosted compute is authorized. If a later preservation question genuinely requires executable verification, use only `[self-hosted, openpressbrake]`.

## Safety boundary

BD57 concerns evidence preservation for ordinary board-design/controller authority. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation, or personnel-safety authority. An equivalence proof for an ordinary LinuxCNC/FPGA/control claim receives zero personnel-safety credit unless a separate safety-rated design and validation explicitly supports that safety claim.
