# BD46 — Corrective-Action Effectiveness, Leading Indicators, and Prevention Evidence

## Purpose

BD45 identifies systemic causes and selects corrective action. BD46 asks the harder question: **did the correction actually make the engineering system better?**

Design flow:

`systemic correction -> preventive/detective controls -> leading indicators -> exposure-normalized monitoring -> escape detection -> effectiveness review -> control tuning -> sustained closure or recurrence reopen`

This lesson links block engineering and board integration. A corrected primitive is not enough if stale consumers remain; a new validator is not enough if it cannot detect the defect it was created to prevent.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD45_EXCEPTION_RECURRENCE_SYSTEMIC_DEFECT_DETECTION_AND_CATALOG_PROCESS_FEEDBACK.md` — **VERIFIED_FOR_LESSON** for recurrence/systemic-cause and corrective-action semantics.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — **VERIFIED_FOR_LESSON** for the current board-design handoff.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for evidence truthfulness, same-change status maintenance, and integration-versus-qualification boundaries.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for block/adapter/integration ownership.
- OpenPressBrake `hardware/blocks/lvdt_input/integration/ANALOG_5V_CLAMP_RESOURCE_CONTRACT.md` — **VERIFIED_FOR_LESSON** specifically as a **DEPRECATED_OR_SUPERSEDED** worked example of explicit retirement and downstream board-budget consequences; it is not current design authority.
- OpenPressBrake `hardware/blocks/lvdt_input/manifest.yaml` — **VERIFIED_FOR_LESSON** only for the current lower-clamp/LT6015 architecture and declared unresolved machine/resource facts.
- OpenPressBrake `hardware/blocks/lvdt_input/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for current `SIMULATION-READY` status, shared-clamp cleanup, and remaining qualification/release gates.

The current `lvdt_input` is not represented as production-proven, schematic-ready, safety-rated, or REV 1 READY.

## Learning objectives

The student must be able to:

1. distinguish correction implementation from correction effectiveness;
2. separate preventive controls from detective controls;
3. define leading indicators tied to the semantic failure mode;
4. normalize recurrence and escape counts by meaningful exposure;
5. detect false-green validators and controls with incomplete coverage;
6. propagate reusable-block corrections into dependent board evidence;
7. preserve negative evidence and reopen systemic closure when recurrence occurs;
8. retire obsolete resources without allowing stale consumers to resurrect them; and
9. preserve the independent personnel-safety boundary.

## 1. Correction installed is not effectiveness proved

A corrective action can be technically correct and still fail systemically because it is not consumed, is bypassed, has incomplete coverage, or creates a different escape path.

**CORRECTION MERGED ≠ CORRECTION EFFECTIVE.**

Effectiveness evidence must answer both:

- did the changed artifact remove the intended cause? and
- did the engineering process/population actually consume the correction?

A block fix with stale board manifests is incomplete effectiveness. A validator that never sees the affected semantic field is incomplete effectiveness. A checklist rule that is routinely bypassed is incomplete effectiveness.

## 2. Prevention and detection are different controls

A **preventive control** makes the defect harder or impossible to introduce: schema constraints, generated connection contracts, immutable interface consumption, resource-budget enforcement, typed interface compatibility, or a required design gate.

A **detective control** finds a defect after it exists: validator, audit, ERC/DRC, stale-dependency report, checklist reconciliation, review, or bench test.

Both can be valuable. Do not call detection prevention.

**DETECTED EARLIER ≠ PREVENTED.**

For each systemic correction record:

- control type;
- semantic defect addressed;
- scope/population;
- trigger;
- expected failure signature;
- false-negative concern;
- false-positive concern;
- bypass/override path;
- evidence that the control itself was challenged.

## 3. Test the control against the escaped defect

A validator's green result proves only the rules it actually evaluates.

The minimum effectiveness challenge is to construct or retain a representative failing condition for the escaped semantic defect and show that the new control rejects or identifies it. Then show a valid case still passes.

Where destructive mutation of production artifacts would be inappropriate, use a fixture, test vector, schema sample, or isolated regression case.

**VALIDATOR PASSES CURRENT TREE ≠ VALIDATOR CAN DETECT THE DEFECT.**

Negative test evidence is first-class evidence. Preserve it.

## 4. Leading indicators precede field recurrence

Lagging indicators include field failures, service exceptions, failed boards, and discovered stale releases. They matter, but they arrive late.

Useful leading indicators depend on the cause. Examples:

- percentage of block changes with same-change status reconciliation;
- number of unresolved `VERIFY_AT_MACHINE` facts at release gates;
- percentage of board consumers using current semantic-contract revisions;
- count of unbudgeted shared resources;
- stale reverse-dependency edges;
- validator negative-test coverage for known semantic cause classes;
- number of manual overrides/waivers;
- time from upstream semantic change to dependent evidence invalidation.

A metric is useful only if its relation to the failure mechanism can be explained.

**EASY TO COUNT ≠ LEADING INDICATOR.**

## 5. Normalize by exposure

Raw recurrence counts can improve while the process worsens.

Choose an exposure denominator that matches the defect mechanism: block instances, boards built, releases, integration changes, audits, service interventions, machine-hours, or other justified opportunity count.

Track both numerator and denominator. Preserve changes in detection effort because increased auditing can temporarily increase discovered defects without worsening underlying quality.

**FEWER REPORTS ≠ LOWER DEFECT RATE.**

## 6. Escape detection and layered controls

An escape is a targeted defect that passes the control boundary and is found downstream.

Record:

`cause ID -> control expected to catch it -> point it escaped -> downstream detection -> affected population -> why control missed -> control revision`

Do not silently classify every downstream defect as a new cause. First test whether it is recurrence of the known semantic cause through an ineffective control.

Layering can be justified when controls address different failure opportunities—for example schema prevention plus review plus generated board-resource reconciliation. Duplicate controls with identical blind spots do not create meaningful coverage.

## 7. Worked bounded example: retiring an obsolete shared resource

Current OpenPressBrake evidence gives a useful real change without claiming a field failure. The historical `ANALOG_5V_CLAMP` shared resource is now explicitly **SUPERSEDED / DO NOT POPULATE / DO NOT BUDGET**. Current `lvdt_input` authority uses a lower-clamp-only LT6015 front end and consumes no such shared sink.

The superseded resource document explicitly requires board integration to omit the historical TLV431 branch, its approximately 0.309 mA `5V_ANALOG` bias load, and its capacitance from current power/filter inventories. The current `lvdt_input` checklist separately records that the shared clamp was re-audited and removed from required Rev-1 population when no current primitive declares it.

This illustrates effectiveness beyond editing the source primitive:

1. **correction:** current primitive no longer consumes the resource;
2. **dependency reconciliation:** manifest/checklist agree with that architecture;
3. **integration consequence:** whole-board power/resource inventory must omit the retired load;
4. **negative control:** future integration must not resurrect the historical resource merely because its retained file exists;
5. **monitoring:** search/resource reconciliation should continue to detect active consumers of a superseded semantic resource.

The historical file remains valuable evidence. Deleting it would weaken provenance; treating it as current authority would corrupt the board.

**SUPERSEDED ARTIFACT RETAINED ≠ SUPERSEDED RESOURCE CONSUMED.**

## 8. Block correction does not refresh board consumers automatically

Suppose a reusable input block fixes a return-path contract. The block's local evidence can become current after appropriate requalification. Every board consuming the changed semantic facet must still be found through `SHOW WHERE USED`, marked stale as appropriate, and re-evaluated.

A board that never consumed the changed facet may retain bounded evidence with documented non-impact. A board that did consume it needs the applicable integration regression/re-promotion.

**BLOCK CORRECTION PASS ≠ BOARD CONSUMER CURRENT.**

This is why effectiveness needs both block-level and integration-level indicators.

## 9. Effectiveness review states

Use explicit states such as:

- `CORRECTION_IMPLEMENTED`
- `CONTROL_CHALLENGE_PENDING`
- `MONITORING`
- `EFFECTIVE_BOUNDED`
- `ESCAPE_DETECTED`
- `RECURRENCE_REOPENED`
- `CONTROL_TUNING_REQUIRED`
- `SUSTAINED_CLOSURE_SUPPORTED`

Do not move directly from implementation to sustained closure.

An effectiveness review should state observation window, exposure, leading indicators, recurrence/escape count, control challenge evidence, unresolved populations, and authority for closure.

## 10. When to tune rather than multiply controls

If a control produces frequent false positives, teams learn to ignore it. If it misses known negative cases, it is not adequate. If it requires unwritten expert interpretation, the contract or machine-readable data may be deficient.

Tune the narrowest correct layer:

- schema/contract if data is missing;
- block if generic electrical semantics are wrong;
- adapter if transformation is missing;
- board integration if mapping/composition is wrong;
- validator/process if correct data is not being enforced.

Do not modify a reusable block solely to make a process checker easier to write.

## 11. Adversarial lab

### Case A — green validator, known escape

A validator passes the current tree, but its rules never inspect the return-domain field that caused the original escape.

Expected reasoning: the control is not effectiveness evidence for that cause. Add a targeted negative test and semantic coverage before claiming effectiveness.

### Case B — recurrence count falls with exposure

Events fall from four to one while board builds fall from 400 to 20.

Expected reasoning: raw count improved; exposure-normalized rate worsened. Do not support systemic closure from raw count.

### Case C — detection mistaken for prevention

A nightly audit reliably finds stale manifests one day after merge.

Expected reasoning: useful detective control, not prevention. Consider same-change validation/gating if prevention is justified.

### Case D — block fixed, boards stale

A primitive's resource contract is corrected and local tests pass, but two board manifests still use the old allocation.

Expected reasoning: block evidence may be current while board promotion remains stale. Use reverse dependencies and targeted integration regression.

### Case E — retired shared resource reappears

A board power spreadsheet includes a load from a superseded historical contract because a designer found the retained file by search.

Expected reasoning: provenance retention is correct; consumption is wrong. The integration control must distinguish current authority from superseded evidence.

### Case F — ordinary safety-status monitoring improves

A validator now catches every tested mapping error between an independent safety relay status output and an ordinary FPGA monitor.

Expected reasoning: monitoring quality improved. This does not establish PL/SIL/category, stopping performance, final-element validation, or personnel-safety authority.

## 12. Machine-readable effectiveness record

A future release/process layer should support records conceptually like:

```yaml
effectiveness_id: EFF-<stable-id>
recurrence_id: REC-<stable-id>
correction_revision: null
changed_semantic_ids: []
controls:
  - id: null
    type: PREVENTIVE # or DETECTIVE
    scope: null
    targeted_cause_ids: []
    negative_test_evidence: []
    bypass_authority: null
leading_indicators: []
monitoring:
  exposure_basis: null
  exposure_count: null
  recurrence_count: null
  escape_count: null
  observation_window: null
dependents:
  stale: []
  reconciled: []
effectiveness_state: CONTROL_CHALLENGE_PENDING
closure_authority: null
```

This is schema direction, not a claim that OpenPressBrake currently implements it.

## 13. Catalog stress-test result

BD46 exposes a missing **corrective-action effectiveness layer** above block qualification. It must join systemic-cause IDs, correction revisions, semantic dependency reach, preventive/detective controls, negative control tests, leading indicators, exposure denominators, escapes, board-population reconciliation, monitoring windows, and closure authority.

The `ANALOG_5V_CLAMP` retirement also exposes a reusable requirement for machine-readable **authority state** on retained artifacts/resources. Historical evidence must remain discoverable without being accidentally consumable by current board generation/resource budgeting.

Internal readiness of this proposed infrastructure: **ENGINEERING_REVIEW_NEEDED**.

## 14. Compute rule

No simulation, synthesis, place-and-route, timing/resource run, or executable regression is required merely to teach this lesson. When an effectiveness review genuinely requires executable engineering verification, it must run only on `[self-hosted, openpressbrake]`. If that authorized compute is unavailable, leave the gate `BLOCKED/NOT_RUN`; never substitute hosted compute.

## 15. Safety boundary

Corrective-action effectiveness for ordinary controller hardware can prove that an ordinary monitor, watchdog, output inhibit, or STO-request interface behaves according to its non-safety contract. It cannot confer independent personnel-safety authority.

**ORDINARY CONTROL EFFECTIVENESS ≠ SAFETY FUNCTION VALIDATION.**

## Completion criteria

The student passes BD46 when they can challenge a corrective action rather than merely observe that it was merged, classify controls as preventive or detective, define cause-linked leading indicators, normalize recurrence by exposure, identify escapes and stale consumers, preserve superseded evidence without consuming it as current authority, and support sustained closure only with bounded evidence.

## Next lesson

BD47 should cover **authority-state propagation, supersession-safe discovery, and configuration consumption**:

`current/superseded/deprecated artifacts -> machine-readable authority state -> search/discovery -> consumer eligibility -> stale-consumer detection -> board generation/resource budgeting -> audit -> safe historical retention`
