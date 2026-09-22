# BD43 — Release-Train Observability, Gate Dashboards, and Exception Authority

## Purpose

A release train is not controlled merely because it has a dashboard. This lesson teaches how to make release state observable without allowing a summary view, stale evidence, or an informal waiver to become release authority.

Design flow for this lesson:

`change waves -> gate graph -> machine-readable status -> evidence freshness -> blocked/waived/failed states -> exception authority -> expiry/revalidation -> promotion visibility -> audit reconstruction`

This is a board-integration and release-governance lesson. It complements block engineering by forcing every reusable-block claim consumed by a board release to remain traceable to current evidence.

## Student-material readiness audit

The following current repository files were opened and inspected before this lesson was written:

- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for formal status, evidence truthfulness, baseline-vs-qualification separation, and maintenance semantics.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — **VERIFIED_FOR_LESSON** for the BD42 handoff and the exact BD43 scope.

No OpenPressBrake block implementation is assigned as a finished example in this lesson. Current OpenPressBrake main is undergoing active Rev1 whole-board work; this lesson therefore uses bounded governance semantics rather than freezing a moving block as student authority.

## Learning objectives

By the end of BD43, the student must be able to:

1. derive a release gate graph from semantic dependencies rather than from a hand-maintained checklist;
2. distinguish gate result, evidence freshness, gate authority, and promotion authority;
3. represent `PASS`, `FAIL`, `BLOCKED`, `WAIVED`, `STALE`, `NOT_APPLICABLE`, and `NOT_RUN` without collapsing them into green/red;
4. prove that a dashboard is a projection of authoritative records rather than an authority itself;
5. define a bounded exception with scope, rationale, issuer authority, compensating controls, expiry, revalidation trigger, and affected population;
6. keep reusable-block status separate from board-specific exceptions;
7. reconstruct why an exact release candidate was or was not promotable at a historical point in time; and
8. preserve the independent personnel-safety boundary.

## 1. The dashboard is a view, not the source of truth

A useful dashboard answers: what candidate is being evaluated, which semantic claims it consumes, which gates apply, what evidence supports each gate, how fresh that evidence is, and who has authority to accept an exception.

It must not answer those questions by storing a second manually maintained truth table.

**DASHBOARD GREEN ≠ RELEASE AUTHORIZED.**

The dashboard should be reproducible from authoritative machine-readable records: candidate identity, dependency graph, evidence records, gate definitions, exception records, and promotion records. If rebuilding the dashboard from those records changes its answer, the dashboard was hiding state.

## 2. Gate state has multiple dimensions

A single boolean is insufficient. At minimum record:

- `gate_id`
- `candidate_id`
- `required_by` semantic claim or release rule
- `result`: `PASS | FAIL | BLOCKED | NOT_RUN | NOT_APPLICABLE`
- `evidence_ids`
- `evidence_revision_or_digest`
- `evaluated_against_dependency_snapshot`
- `freshness`: `CURRENT | STALE | UNKNOWN`
- `exception_id`, if any
- `effective_release_state`: `SATISFIED | UNSATISFIED | EXCEPTION_BOUNDED`
- `last_evaluated_at`

A test that passed against an older dependency snapshot is not current merely because its last result is PASS.

**LAST RESULT PASS ≠ CURRENT GATE PASS.**

## 3. Evidence freshness must be semantic

Do not expire evidence merely because it is old, and do not preserve it merely because the file containing it did not change.

Evidence becomes stale when a dependency it proves changes in a way that can affect the claim. BD41's semantic invalidation model and BD42's change-wave lineage are the basis for this decision.

A useful freshness calculation asks:

`evidence -> proved claim -> consumed semantic facets -> current facet revisions`

If the dependency graph cannot answer that question, display `UNKNOWN`, not green.

**UNKNOWN FRESHNESS ≠ CURRENT.**

## 4. Gate graph, not gate list

Some gates depend on others. For example, a whole-board executable test should not be interpreted as qualifying an upstream electrical contract that is itself unresolved. Model prerequisites explicitly.

Typical ordering is:

`generic block claim -> adapter/shared-resource claim -> board composition -> structural/ERC checks -> executable FPGA/software checks -> whole-board behavior -> HAL mapping -> physical-machine evidence -> promotion`

A downstream pass can add evidence, but it does not erase an upstream failure.

**DOWNSTREAM PASS ≠ UPSTREAM FAILURE CLOSED.**

## 5. Exception authority

An exception is a controlled engineering decision, not a status edit.

Every exception must bind:

- exact exception ID;
- exact candidate/release scope;
- exact gate or semantic claim affected;
- reason the normal gate cannot be satisfied now;
- known risk and uncertainty;
- compensating controls, if any;
- issuer identity and authority scope;
- new-build/service/bench-only applicability;
- affected population or configuration envelope;
- expiry date or objective expiry event;
- mandatory revalidation triggers;
- evidence required for closure;
- disposition after expiry: block, renew under new authority, or replace with normal evidence.

A waiver with no expiry or revalidation trigger is an uncontrolled alternate release rule.

**WAIVED ≠ PASSED.**

**EXCEPTION APPROVED ≠ REUSABLE BLOCK QUALIFIED.**

A board-specific exception must not mutate a reusable block's generic status unless new generic engineering evidence actually justifies that change.

## 6. Authority is scoped

The person or process allowed to accept a documentation exception is not automatically authorized to accept an electrical-envelope exception, skip FPGA fit/timing evidence, approve field retrofit applicability, or release a personnel-safety function.

Represent authority by claim type and scope rather than by a single `approved_by` field.

Examples of scopes include:

- documentation-only;
- board-integration;
- FPGA/resource-fit;
- electrical qualification;
- manufacturing deviation;
- service-only;
- release promotion.

Personnel-safety validation remains outside ordinary board-design release authority unless a separate safety-rated process explicitly establishes it.

## 7. Self-hosted executable gates

If a gate genuinely requires FPGA synthesis, place-and-route, timing, simulation, regression, or other executable verification, this curriculum's compute rule requires the OpenPressBrake local runner labeled `[self-hosted, openpressbrake]`.

A dashboard must distinguish:

- required and passed on the authorized runner;
- required but not run;
- required but runner unavailable (`BLOCKED`);
- explicitly not applicable with evidence;
- exception-bounded.

**CHECK SKIPPED ≠ CHECK PASSED.**

Do not fall back to hosted Actions minutes to make a dashboard green.

## 8. Promotion visibility

The release view should show at least four distinct layers:

1. **engineering state** — individual block/adapter/integration claims;
2. **candidate state** — exact candidate lineage and gate results;
3. **promotion state** — whether authorized release promotion occurred;
4. **population state** — where that promoted identity may be built, installed, serviced, or rolled back.

A candidate may be technically clean but not promoted. A promoted release may later become superseded or quarantined. A service-only exception may not authorize new builds.

## 9. Audit reconstruction

For any historical release decision, another engineer should be able to reconstruct:

- exact candidate identity;
- exact dependency snapshot;
- all required gates at that time;
- result and evidence for every gate;
- which evidence was stale or unknown;
- every exception then in force;
- authority and scope of each exception;
- expiry/revalidation state;
- promotion decision;
- population applicability;
- negative evidence and failed attempts retained in history.

Do not rewrite old dashboards after a later fix. Recompute current state while preserving the historical decision record.

## 10. Adversarial lab

For each case, classify the gate state, effective release state, required authority, and corrective action.

### Case A — green from stale evidence

A board candidate dashboard shows PASS because the last whole-board test passed. A consumed block's electrical envelope changed afterward and the test has not been rerun.

Expected reasoning: the old test result remains historical PASS, but freshness is STALE; the effective gate is UNSATISFIED until justified non-impact or regression closes it.

### Case B — waiver without expiry

A board-layout gate was waived because the preferred footprint was unavailable. The waiver has no expiry, population scope, or revalidation trigger.

Expected reasoning: the exception record is incomplete and cannot silently authorize indefinite promotion.

### Case C — skipped FPGA check

A candidate changes FPGA resource allocation. The local self-hosted runner is unavailable, so synthesis/timing was not run. All documentation checks pass.

Expected reasoning: the executable gate is BLOCKED/NOT_RUN, not PASS. Continue non-compute review; do not substitute hosted compute.

### Case D — board-only exception contaminates the catalog

A first-board connector placement requires a board-specific harness deviation. An engineer proposes marking the reusable electrical block `qualified with exception`.

Expected reasoning: reject the status mutation. Keep the deviation in board/connection/release scope unless it reveals a genuine reusable-contract defect.

### Case E — safety-status monitor

An ordinary FPGA input monitoring safety-system status has a board-level release exception. Someone argues that because the dashboard is green, the safety function is accepted.

Expected reasoning: reject the claim. Ordinary monitoring/control release authority does not establish PL/SIL/category, final-element behavior, stopping performance, or independent safety validation.

## 11. Machine-readable dashboard contract

A future implementation should derive a release-train projection from records similar to:

```yaml
candidate_id: board-rev1-candidate-X
change_wave_ids: []
dependency_snapshot: <immutable-id>
gates:
  - gate_id: <stable-id>
    result: NOT_RUN
    freshness: CURRENT
    evidence_ids: []
    prerequisite_gate_ids: []
    exception_id: null
    effective_release_state: UNSATISFIED
promotion:
  state: NOT_PROMOTED
  authority_record: null
population_applicability: []
```

This is a schema direction, not an assertion that OpenPressBrake currently has such a release record.

## Catalog stress-test result

BD43 exposes a release-observability layer that belongs above reusable blocks. The catalog needs stable semantic IDs and truthful block evidence; the release layer needs a gate graph, evidence-freshness projection, exception-authority records, promotion state, and audit snapshots.

Do **not** put board release waivers, fleet applicability, or dashboard state into generic block manifests merely because the dashboard consumes block data.

Internal readiness of this proposed infrastructure: **ENGINEERING_REVIEW_NEEDED**.

## Completion criteria

The student passes BD43 when they can take a mixed release train and produce a defensible gate graph in which stale evidence cannot appear green, skipped checks cannot appear passed, exceptions are bounded and expiring, reusable-block status is not contaminated by board-only deviations, promotion authority is separate from engineering status, and the historical decision can be reconstructed later.

## Next lesson

BD44 should cover **exception debt, waiver burn-down, and temporary-control retirement**:

`active exceptions -> risk/expiry queue -> dependency/population reach -> compensating controls -> permanent correction -> targeted regression -> exception closure -> temporary-control removal -> evidence preservation`
