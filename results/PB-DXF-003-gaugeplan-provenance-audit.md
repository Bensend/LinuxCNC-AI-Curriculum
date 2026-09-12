# PB-DXF-003 GaugePlan provenance/invalidation fixture — independent audit

Date: 2026-09-12
Status: TEST-CONFIRMED / frozen Gates A–J 10/10

## Provenance

- source/design note: `research/press-brake-gaugeplan-limit3-boundary-2026-09-12.md`
- frozen experiment: `experiments/PB-DXF-003-gaugeplan-provenance-plan.md`
- implementation: `lab-jobs/087-pb-dxf-003-gaugeplan-provenance.sh`
- workflow: `34669836019`
- job: `103488990203`
- source commit: `5b2fb70022b542c431e3e677a7ebd4690e0f8e98`
- retained artifact: `10289893020`
- exact Actions job interval: `2026-09-12T03:14:42Z` to `2026-09-12T03:14:51Z` = 9 s = 0.15 min

## Independent retained-state review

Direct inspection of `lab-results/pb-dxf-003/records.json` supports every frozen gate:

- **A PASS** — P0 accepts GP1 only with accepted S1/B1 at R1, assigned datum D1 with provenance `entity:E17`, and nonempty mechanism set `{X}`.
- **B PASS** — P1 changes S1 ordinal from 1 to 3 while GP1 remains bound to the same `gauge_plan_id`, `step_id` S1 and `bend_id` B1; ordinal is not used as identity.
- **C PASS** — P2 retains `datum_id=UNASSIGNED` and yields REVIEW_REQUIRED / `DATUM_UNASSIGNED`.
- **D PASS** — P3 changes the source step to REVIEW_REQUIRED and the dependent plan becomes REVIEW_REQUIRED / `STEP_REVIEW_REQUIRED`.
- **E PASS** — P4 has an accepted R2 step while GP1 remains bound to R1 datum provenance and is REVIEW_REQUIRED / `DATUM_REMAP_REQUIRED`; old datum authority is not silently reused.
- **F PASS** — P5 first records `TRUSTED_DATUM_REBIND_REQUIRED`; only after rebinding the plan to R2/new datum provenance and explicit current validation does GP1 become ACCEPTED.
- **G PASS** — P6 changes participating mechanisms from `{X}` to `{X,R}` and revokes prior acceptance to REVIEW_REQUIRED / `MECHANISM_SET_CHANGED`.
- **H PASS** — every retained nonaccepted plan carries an explicit machine-readable reason and source revision.
- **I PASS** — all plans bind to stable `step_id` / `bend_id`; recipe ordinal changes do not alter that binding.
- **J PASS** — no numeric target, TargetSet, joint/posthome command, tooling/collision choice, hydraulic command or safety authorization is emitted.

Frozen Gates A–J: **10/10 PASS**. The predeclared prediction matched observation.

## Adversarial interpretation

An ACCEPTED GaugePlan in this fixture means only that application-level provenance/selection checks passed. It does not prove the datum is physically reachable, that a gauge finger actually contacts it, or that any eventual numeric target is correct. Trusted datum identity across revisions is likewise insufficient until the plan is rebound to current provenance and explicitly revalidated.

The plan deliberately does not model numeric target calculation. Adding a coordinate merely to make the test look more machine-like would blur the boundary just established and would not increase evidence quality.

## Sufficiency / next-work decision

PB-DXF-003 closes the current GaugePlan provenance/invalidation semantics question. The next useful press-brake study is no longer another state fixture. Research should move to **target-calculation concepts**: how bend/flange geometry and a selected gauging surface are transformed into backgauge targets, what commercial/open-source tools assume, and which quantities remain machine/tooling-specific. Only after that evidence should a numeric TargetSet contract be frozen.

The sole 2000-series graduation gate remains the genuinely information-separated evaluation of `handoffs/F02-fresh-ai-compound-fault-transfer.md`; this learner must not self-score it.
