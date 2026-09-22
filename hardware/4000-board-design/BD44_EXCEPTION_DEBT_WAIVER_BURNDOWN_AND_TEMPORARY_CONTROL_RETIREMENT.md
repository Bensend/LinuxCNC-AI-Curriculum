# BD44 — Exception Debt, Waiver Burn-Down, and Temporary-Control Retirement

## Purpose

Exceptions are engineering debt, not alternate permanent requirements. This lesson teaches how to keep temporary release authority visible, prioritize its removal, prove a permanent correction, retire compensating controls without creating a new hazard, and preserve the evidence trail.

Design flow:

`active exceptions -> risk/expiry queue -> dependency/population reach -> compensating controls -> permanent correction -> targeted regression -> exception closure -> temporary-control removal -> evidence preservation`

This is primarily a board-integration/release lesson, but it deliberately stresses reusable-block boundaries: a board-specific waiver must not silently become a generic block contract.

## Student-material readiness audit

The following current repository files were opened and inspected before this lesson was written:

- Curriculum `hardware/4000-board-design/BD43_RELEASE_TRAIN_OBSERVABILITY_GATE_DASHBOARDS_AND_EXCEPTION_AUTHORITY.md` — **VERIFIED_FOR_LESSON** for gate-state, exception-authority, evidence-freshness, promotion, and audit semantics.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — **VERIFIED_FOR_LESSON** for the BD44 handoff.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for truthful evidence/status, maintenance, and baseline-versus-qualification semantics.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for reusable-block, adapter, and board-integration ownership.

No moving OpenPressBrake implementation file is assigned as finished student material. Current OpenPressBrake main is actively changing Rev1 integration and low-voltage allocation, so the lesson uses inspected stable governance rather than freezing a moving implementation as authority.

## Learning objectives

The student must be able to:

1. treat every active exception as bounded debt with an owner and retirement path;
2. prioritize debt using consequence, uncertainty, expiry, dependency reach, and installed-population reach rather than age alone;
3. distinguish an exception from its compensating control;
4. keep service-only, new-build, bench-only, and population-specific authority separate;
5. prove a permanent correction with semantic impact analysis and targeted regression;
6. close an exception only after affected claims are current;
7. remove temporary controls only after proving they are no longer required;
8. preserve the original exception, negative evidence, correction, and closure history; and
9. preserve the independent personnel-safety boundary.

## 1. Exception debt is real configuration debt

An exception changes what a specific candidate or population is permitted to do without changing the normal engineering rule. It therefore creates debt that must remain visible until it is closed or superseded by a new bounded decision.

**EXCEPTION APPROVED ≠ DEFECT RESOLVED.**

Every active exception needs at least:

- stable exception ID;
- affected semantic gate/claim;
- exact candidate/configuration scope;
- applicability: new-build, service-only, bench-only, or explicit population;
- risk/uncertainty statement;
- compensating controls;
- owner and authority scope;
- approval evidence;
- expiry date or objective expiry event;
- revalidation triggers;
- permanent-correction plan or explicit disposition;
- dependencies/populations reached by the exception.

## 2. Burn-down priority is not FIFO

Do not work exceptions merely oldest-first. Rank them by engineering consequence and reach.

A practical queue considers:

`priority = consequence + uncertainty + expiry urgency + dependency reach + population reach + control fragility`

The formula need not be numeric, but the rationale must be explicit. A recent exception affecting every new board may deserve action before an older bench-only documentation waiver.

**OLDEST EXCEPTION ≠ HIGHEST ENGINEERING PRIORITY.**

## 3. Expiry is a gate, not a reminder

An expiry date is not an email reminder. When the bounded authority expires, promotion/use must become blocked unless normal evidence has closed the gate or a newly authorized exception has been created.

Do not silently extend the old record. Renewal is a new decision with current evidence, current authority, current scope, and retained history.

**EXPIRED EXCEPTION ≠ STILL VALID BECAUSE NOTHING FAILED.**

## 4. Compensating controls are temporary configuration

A compensating control can be procedural, software/configuration, hardware, manufacturing, inspection, or population restriction. It must be explicit and verifiable.

Examples include a reduced operating envelope, additional inspection, a service-only restriction, a temporary adapter, a configuration inhibit, or an extra verification step.

A temporary control that remains for months without review has not become a requirement merely through neglect.

**TEMPORARY CONTROL USED FOR A LONG TIME ≠ PERMANENT DESIGN REQUIREMENT.**

If the control contains meaningful reusable electrical transformation/protection, classify it using the OpenPressBrake block/adapter/integration decision test. Do not hide real circuitry in a waiver note.

## 5. Scope containment

Exception authority must not leak between populations.

A `SERVICE_ONLY` exception cannot authorize new production. A bench exception cannot authorize field installation. A first-board harness deviation cannot redefine a reusable block's connector contract. A board-specific exception cannot become an approved generic adapter by repetition.

**SERVICE-ONLY EXCEPTION ≠ NEW-BUILD AUTHORITY.**

**REPEATED BOARD DEVIATION ≠ REUSABLE BLOCK QUALIFICATION.**

Repeated deviations may reveal a catalog defect. If so, open generic block/adapter engineering work and qualify the changed generic claim separately.

## 6. Permanent correction and semantic impact

A permanent correction must identify what changed and what evidence it invalidates.

Use the semantic dependency model:

`correction -> changed facets -> direct consumers -> dependent claims -> stale evidence -> required regression`

Do not rerun everything blindly, but do not assume local success closes downstream evidence.

**LOCAL FIX PASS ≠ DEPENDENT EVIDENCE CURRENT.**

For example, correcting a power-domain allocation may require recalculation of aggregate rail loading and board thermal margin even if the corrected primitive itself passes its local check.

## 7. Targeted regression before closure

Exception closure requires evidence for the normal rule, not merely evidence that the workaround is no longer being discussed.

Closure record should bind:

- permanent correction revision;
- semantic facets changed;
- affected-consumer analysis;
- regression gates required;
- exact evidence/results;
- unresolved/stale evidence, if any;
- population applicability;
- closure authority;
- effective closure date.

If executable verification is genuinely required, run only on `[self-hosted, openpressbrake]`. If unavailable, the applicable gate remains `BLOCKED/NOT_RUN`; do not use hosted compute to burn down the exception cosmetically.

## 8. Closing the exception is not removing the control

Exception closure and temporary-control retirement are two gates.

First prove the permanent correction and close the exception. Then prove the temporary control is no longer required and that removing it does not change another relied-upon behavior.

This matters when a workaround has acquired accidental dependencies. A software inhibit, extra inspection, temporary adapter, or reduced limit may now be referenced by service instructions or installed configurations.

**EXCEPTION CLOSED ≠ TEMPORARY CONTROL SAFE TO REMOVE.**

Retirement needs its own affected-consumer check and, where applicable, regression.

## 9. Evidence preservation

Never delete the old exception because the design is fixed. Preserve:

- original defect/failure evidence;
- original exception and authority;
- compensating-control identity;
- renewals or scope changes;
- permanent correction;
- regression evidence;
- closure decision;
- temporary-control retirement;
- populations that still carry the old control or exception.

**CORRECTED ≠ HISTORICALLY NEVER FAILED.**

This history is necessary for later `SHOW WHERE USED`, `SHOW WHAT IS INSTALLED`, field action, rollback, and audit reconstruction.

## 10. Adversarial lab

### Case A — expiry approaching

An electrical-envelope exception expires in ten days. The permanent fix exists in source but affected board regression has not run.

Expected reasoning: the exception remains active only within its existing authority until expiry. Source existence is not closure. Prioritize regression/closure; after expiry the affected release/use becomes blocked unless new authority is explicitly granted.

### Case B — temporary control became folklore

A technician inspection added as a compensating control has been performed for a year. Nobody can identify the original exception.

Expected reasoning: this is uncontrolled debt, not a permanent requirement. Recover provenance before deleting or institutionalizing the step; classify unknown dependencies and establish disposition.

### Case C — local fix, stale dependents

A block's local defect is corrected and its local test passes. Board power-budget evidence consumed the old block envelope.

Expected reasoning: the block evidence may be current while board evidence remains stale. Close neither the board gate nor the exception until semantic impact/regression is resolved.

### Case D — service exception leaks into production

A substitution was approved only to repair an installed legacy controller. Purchasing begins using it for new boards.

Expected reasoning: stop the scope leak. Service-only authority does not qualify new-build use. Either restore the normal new-build part or perform generic/new-build qualification under a separate engineering decision.

### Case E — safety-status monitor

An ordinary controller input monitoring an independent safety system has an exception. Someone proposes accepting the safety function because the monitor has operated reliably under the exception.

Expected reasoning: reject the claim. This curriculum can govern the ordinary monitor's board release, but cannot convert that evidence into PL/SIL/category, stopping-performance, final-element, or independent personnel-safety validation.

## 11. Machine-readable exception-debt contract

A future release layer should support records conceptually like:

```yaml
exception_id: EX-<stable-id>
state: ACTIVE
scope:
  candidates: []
  applicability: SERVICE_ONLY
affected_semantic_ids: []
risk:
  consequence: <classified>
  uncertainty: <classified>
compensating_controls: []
owner: <authority-record>
expiry: <date-or-event>
revalidation_triggers: []
permanent_correction:
  revision: null
  changed_facets: []
regression:
  required_gate_ids: []
  current_evidence_ids: []
closure:
  state: OPEN
  authority_record: null
temporary_control_retirement:
  state: NOT_ELIGIBLE
population_reach: []
```

This is schema direction, not a claim that OpenPressBrake currently has this release record.

## Catalog stress-test result

BD44 exposes a missing exception-debt/temporary-control lifecycle above the reusable catalog. The release layer should be able to derive active debt, expiry risk, semantic/population reach, compensating controls, correction/regression state, closure, and control retirement without contaminating generic block manifests with board/fleet-specific waivers.

Internal readiness of that proposed infrastructure: **ENGINEERING_REVIEW_NEEDED**.

## Completion criteria

The student passes BD44 when they can take a mixed set of exceptions and produce a defensible burn-down plan in which scope cannot leak, expiry blocks unauthorized use, compensating controls remain traceable, permanent fixes trigger semantic impact analysis, dependent stale evidence stays visible, closure and control retirement are separate gates, and historical negative evidence is preserved.

## Next lesson

BD45 should cover **exception recurrence, systemic defect detection, and catalog/process feedback**:

`closed/current exceptions -> recurrence clustering -> common semantic cause -> board-only pattern vs reusable defect vs process defect -> corrective action -> cross-population impact -> catalog/process update -> regression -> recurrence monitoring`
