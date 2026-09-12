# PB-DXF-002 human-confirmation / recipe-identity fixture — independent audit

Date: 2026-09-12
Status: TEST-CONFIRMED / frozen Gates A–J 10/10

## Provenance

- research contract: `research/press-brake-human-confirmation-recipe-boundary-2026-09-12.md`
- frozen experiment: `experiments/PB-DXF-002-human-confirmation-recipe-plan.md`
- implementation: `lab-jobs/086-pb-dxf-002-human-confirmation-recipe.sh`
- workflow: `34669718957`
- job: `103488664098`
- source commit: `38a5a0775539b65f6d7c3abf7627fd5174e8bc25`
- artifact: `10290232492`
- exact Actions job interval: `2026-09-12T03:12:08Z` to `2026-09-12T03:12:16Z` = 8 s = 0.13 min

## Independent retained-state review

The retained `lab-results/pb-dxf-002/records.json` contains 10 explicit phase/action snapshots. Direct inspection supports the frozen gates:

- **A PASS** — P0 has B1/B2 CONFIRMED at R1 and S1/S2 ACCEPTED with matching bend IDs, current revision and required angle/direction semantics present.
- **B PASS** — P1 changes ordinals from `(1,2)` to `(2,1)` while step IDs S1/S2 and bend IDs B1/B2 remain unchanged.
- **C PASS** — P2 retains `direction: UNKNOWN`; S3 is `REVIEW_REQUIRED` with reason `UNKNOWN_REQUIRED:direction` rather than defaulting a direction.
- **D PASS** — P3 retains B4 as AMBIGUOUS and S4 cannot become ACCEPTED; it is `REVIEW_REQUIRED` with `FEATURE_AMBIGUOUS`.
- **E PASS** — P4 shows S5 first as DRAFT while B5 is confirmed, then explicitly INVALID with reason `FEATURE_REJECTED` after B5 is rejected.
- **F PASS** — P5 imports R2 without a trusted remap while old S1 remains bound to R1 and becomes `REVIEW_REQUIRED` with `SOURCE_REVISION_CHANGED_NO_TRUSTED_REMAP`.
- **G PASS** — P6 first records `TRUSTED_REMAP_REBIND_REQUIRED`; only after explicit rebinding to R2/current validation does S1 become ACCEPTED.
- **H PASS** — P7 preserves the trusted B1 identity but a changed required direction forces `REVIEW_REQUIRED` with `REQUIRED_SEMANTIC_CHANGED:direction`.
- **I PASS** — every retained INVALID/REVIEW_REQUIRED step carries an explicit reason and source revision; no silent invalidation is used.
- **J PASS** — the retained schema contains only candidate/review/recipe-step state. No GaugePlan, target value, TargetSet, joint/motion command, tooling/collision choice, hydraulic command or safety assertion is emitted.

Frozen Gates A–J: **10/10 PASS**.

The predeclared prediction matched observation: harmless recipe reordering preserved identity, while revision changes, ambiguity, rejection and missing required semantics revoked or withheld recipe authority.

## Adversarial interpretation

This result must not be read as saying `CONFIRMED` means geometrically or physically correct. It means only that the application has recorded an explicit operator decision for a particular imported candidate/revision. Likewise, a trusted stable bend ID across revisions is not sufficient by itself for recipe acceptance when a required semantic value changed.

A draft step may exist for an unresolved candidate in the fixture, but the important authority rule is that it cannot become ACCEPTED until current validation succeeds. The production HMI may choose to prevent draft creation earlier; that UX choice does not weaken the evidence boundary.

## Sufficiency / next-work decision

PB-DXF-002 closes the first-stage human-confirmation and recipe-identity semantics question. Do not add more synthetic state cases merely for volume. The next useful 3600 DXF/backgauge work is the boundary from an **accepted BendStep to a human-selected GaugePlan datum**, including provenance and invalidation, while still stopping before automatic target computation or machine commands unless source evidence justifies that next step.

The global 2000-series critical path remains unchanged: the current learner must not self-score `handoffs/F02-fresh-ai-compound-fault-transfer.md`.
