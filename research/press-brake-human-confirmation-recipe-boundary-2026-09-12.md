# Press-brake 3600 — human-confirmation and recipe boundary

Date: 2026-09-12
Status: RESEARCH CONTRACT
Scope: staged operator confirmation between imported bend candidates and any downstream gauge planning; no automatic machine motion.

## Why this layer exists

PB-DXF-001 established that import provenance, ambiguity, UNKNOWN metadata and reimport invalidation can be preserved deterministically. The next useful layer is not more geometric simulation. It is the ownership boundary where an operator turns imported candidates into accepted bend features and an ordered recipe without silently converting uncertain CAD evidence into machine authority.

The existing normalized model remains:

`ImportedPart -> BendFeature -> BendStep -> GaugePlan -> TargetSet`

This artifact narrows the first two transitions.

## Community workflow evidence

A public LinuxCNC press-brake GUI discussion separates the operator-facing program-bend table from a later richer editor. The proposed first version explicitly enters go-to positions per bend; the proposed later editor would add dies, flange/tab lengths and bend angles. That field discussion is useful architectural evidence that recipe authoring and runtime execution are separable surfaces and that a staged/manual first implementation is credible. It is COMMUNITY-REPORTED design discussion, not source-confirmed LinuxCNC behavior and not a safety claim.

Source: LinuxCNC forum thread `For a full-fledged Press Brake GUI` (retrieved 2026-09-12).

## Ownership rules

### BendFeature review state

Each current-revision candidate has one review state:

- `UNREVIEWED` — imported candidate has not been accepted or rejected;
- `CONFIRMED` — operator explicitly accepts this candidate as a physical bend feature for the current source revision;
- `REJECTED` — operator explicitly rejects it as a bend feature;
- `AMBIGUOUS` — unresolved import conflict/insufficient evidence prevents confirmation;
- `STALE` — prior review belongs to an older/incompatible source revision and cannot authorize a current recipe.

A candidate with UNKNOWN angle, direction or radius may still be a confirmed bend feature if the operator is only confirming **bend identity**. Confirmation must not silently fill unknown semantic values. Later operations that require those values must remain blocked until those specific fields are resolved by an evidence-bearing confirmation step.

### BendStep ownership

A BendStep is recipe/order state, not geometry identity. It must:

- reference a current, non-stale `bend_id`;
- preserve that bend identity when the recipe is reordered;
- carry a stable application-owned `step_id` independent of ordinal position;
- preserve source revision/provenance used when the step was accepted;
- have an explicit validation state (`DRAFT`, `ACCEPTED`, `REVIEW_REQUIRED`, `INVALID`).

Changing ordinal position must not mutate `bend_id` or `step_id`.

### Reimport rule

A new source revision never silently carries old recipe authority merely because geometry looks unchanged.

- no trusted stable-ID remap -> old confirmation/steps become `STALE` / `REVIEW_REQUIRED`;
- trusted stable-ID remap with unchanged required semantics may propose a remap, but recipe authority still records the new source revision and must pass the current validation policy;
- changed required semantics or geometry -> explicit review is mandatory;
- rejected/ambiguous old candidates do not become confirmed merely because a new candidate is nearby.

## Explicit separation from GaugePlan

Human confirmation of a bend feature and recipe order does **not** choose a gauging datum, finger contact, machine target, tooling, collision-free sequence, bend allowance, springback compensation or hydraulic command.

Only an accepted BendStep may be offered to the separately defined GaugePlan surface. This protects the runtime boundary from accidental authority leakage out of CAD import/UI state.

## First-stage HMI behavior

A useful minimal UI should let the operator:

1. inspect each candidate with source locator/provenance and any known angle/radius/direction;
2. see UNKNOWN and ambiguity explicitly;
3. confirm, reject or defer a candidate;
4. create BendSteps only from current confirmed candidates;
5. reorder steps without changing feature identity;
6. see stale/review-required states immediately after reimport;
7. explicitly accept a reconciled recipe before it may proceed to gauge planning.

There is no automatic machine resume or automatic TargetSet creation in this layer.

## Failure modes

- **stale recipe after reimport:** detected by revision/provenance mismatch; result is REVIEW_REQUIRED/INVALID, not silent reuse.
- **ambiguous candidate:** cannot create an accepted BendStep until ambiguity is resolved.
- **unknown required semantic field:** feature identity may remain confirmed, but any downstream operation requiring that field remains blocked.
- **step reorder:** only ordinal changes; identity/provenance remain invariant.
- **candidate rejection:** existing draft steps referencing that candidate become INVALID rather than disappearing.

## Prediction before PB-DXF-002

A deterministic state-model fixture should show that recipe authority survives harmless ordering changes but is revoked by source-revision invalidation, rejection/ambiguity, and missing required semantics. It should also show that no action in this layer can emit a gauge target or machine command.

## Evidence boundary

This contract is ordinary application/data-flow design. It does not prove geometric bend truth, tooling suitability, physical gauge contact, collision freedom, machine motion, stopping performance, or functional safety.
