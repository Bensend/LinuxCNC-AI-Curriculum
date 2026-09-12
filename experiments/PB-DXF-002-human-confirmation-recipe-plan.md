# PB-DXF-002 — human-confirmation and recipe-identity fixture

Date frozen: 2026-09-12
Status: FROZEN BEFORE IMPLEMENTATION
Scope: deterministic application-state fixture only; no gauge calculation, tooling, collision solving, motion, hydraulic behavior, or functional-safety claim.

## Question

Can a staged operator-confirmation workflow convert current imported bend candidates into an ordered recipe while preserving feature/step identity, explicit UNKNOWN/ambiguity, and revision invalidation without leaking CAD/UI state directly into machine authority?

## Frozen model

Each candidate has:
- `bend_id`
- `source_revision`
- review state: `UNREVIEWED|CONFIRMED|REJECTED|AMBIGUOUS|STALE`
- semantic fields `angle`, `radius`, `direction`, each either a value or `UNKNOWN`

Each recipe step has:
- stable application-owned `step_id`
- referenced `bend_id`
- ordinal
- bound `source_revision`
- validation state: `DRAFT|ACCEPTED|REVIEW_REQUIRED|INVALID`

The fixture may require named semantic fields for a specific downstream recipe acceptance check, but it must never invent missing values.

## Frozen cases

P0 — normal confirmation and recipe creation
- import B1/B2 at revision R1;
- operator confirms both bend identities;
- create S1->B1 and S2->B2;
- accept recipe only after required semantics are present.

P1 — reorder
- swap recipe ordinals;
- expect `step_id` and `bend_id` unchanged; only ordinals change.

P2 — UNKNOWN semantic field
- B3 is a confirmed bend identity but direction is UNKNOWN;
- creating a draft step is allowed;
- accepting a recipe that requires direction must fail with explicit review-required reason; UNKNOWN never becomes a default.

P3 — ambiguous candidate
- B4 is AMBIGUOUS;
- an accepted BendStep may not be created from it.

P4 — rejected candidate invalidates dependent draft
- create a draft step from a confirmed B5, then operator rejects B5 before recipe acceptance;
- dependent step becomes INVALID rather than disappearing or remaining accepted.

P5 — source revision changes without trusted stable remap
- R1 recipe exists; import R2 with geometrically similar candidates but no trusted stable-ID remap;
- old features/steps become STALE/REVIEW_REQUIRED and may not proceed as current recipe authority.

P6 — trusted stable-ID remap, unchanged required semantics
- new R2 candidate has a trusted stable identity remap to old bend identity and identical required semantic values;
- remap may preserve bend identity as a proposal, but step binding must be updated to R2 and pass explicit current validation before ACCEPTED.

P7 — trusted remap with changed required semantic
- trusted bend identity survives but direction changes;
- old accepted step becomes REVIEW_REQUIRED until operator reaccepts the changed semantic state.

P8 — authority boundary
- inspect all retained outputs;
- no GaugePlan, target value, target-set generation, joint command, machine enable, tooling choice, collision result, or hydraulic command may be emitted.

## Frozen Gates A–J

A. P0 creates two accepted steps only from confirmed current-revision bend features with required semantics present.
B. P1 changes only ordinals; step IDs and bend IDs remain invariant.
C. P2 preserves UNKNOWN and blocks acceptance when that semantic is required.
D. P3 refuses accepted-step creation from an AMBIGUOUS feature.
E. P4 marks the dependent step INVALID after feature rejection.
F. P5 invalidates old-revision recipe authority without silently accepting geometry similarity.
G. P6 requires explicit R2 rebinding/current validation even with trusted stable identity.
H. P7 requires review after a required semantic value changes across a trusted remap.
I. Every invalidation/review decision retains a machine-readable reason and source revision evidence.
J. Output contains no gauge target, TargetSet, joint/motion command, tooling/collision decision, hydraulic command, or functional-safety assertion.

All gates must pass unchanged. Implementation defects may be corrected, but no gate may be weakened after observing results.

## Evidence boundary

PASS would validate only deterministic human-confirmation/recipe state and provenance semantics in this synthetic fixture. It would not validate CAD geometry, actual bend truth, gauge planning, machine setup, physical motion, or safety.
