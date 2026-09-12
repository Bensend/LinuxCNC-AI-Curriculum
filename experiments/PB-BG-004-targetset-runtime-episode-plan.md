# PB-BG-004 — TargetSet generation to runtime episode bridge

Date frozen: 2026-09-12
Status: FROZEN BEFORE IMPLEMENTATION
Scope: application/control ownership only; no motor physics, target-accuracy, hydraulic behavior, collision/tooling analysis, stopping-performance or functional-safety claim.

## Question

Can an accepted current TargetSet generation be bound to exactly one current runtime target episode so that any upstream provenance/authorization/reference invalidation revokes runtime authority, and recovery cannot silently resurrect an old generation or episode?

## Frozen model

Inputs:
- `targetset_valid`
- monotonically advancing `targetset_generation`
- `ordinary_authorized`
- `reference_valid`
- `drive_valid`
- `feedback_valid`
- `controller_fault_clear`
- explicit `arm_request`
- current feedback/at-position witness

State/output:
- application-owned `runtime_episode`
- `bound_targetset_generation`
- `episode_authorized`
- `completion_current`
- machine-readable invalidation reason

`limit3` is downstream numeric shaping only and is not modeled as an authority source.

## Frozen cases

P0 — accept generation 10 and explicit arm -> new episode E1 bound to generation 10; completion may become current only for E1.
P1 — targetset invalidates while E1 active -> episode authority and completion clear immediately; E1 remains historical only.
P2 — targetset recovers with the same generation 10 -> cannot reauthorize; a new accepted TargetSet generation is required after invalidation.
P3 — generation 11 becomes valid but no arm request -> no runtime episode authority yet.
P4 — explicit arm of generation 11 -> new episode E2; E1 is never resurrected.
P5 — ordinary authorization loss during E2 -> revoke E2 and completion.
P6 — authorization recovers while generation remains 11 -> old E2 cannot silently resume; new accepted generation/rearm policy is required.
P7 — reference or feedback validity loss independently revokes current episode.
P8 — same numeric target across generation 12 and prior generations has no special authority; identity is generation/episode, not numeric equality.
P9 — boundary: no `limit3`/posthome/motor/hydraulic command is emitted by this fixture.

## Frozen Gates A–J

A. P0 creates a fresh episode only from a current valid TargetSet generation plus explicit arm.
B. P1 upstream TargetSet invalidation revokes episode authority/completion immediately.
C. P2 same stale generation cannot regain authority after invalidation.
D. P3 a newer generation alone does not arm runtime authority.
E. P4 explicit arm of the newer generation creates a distinct new episode and never resurrects E1.
F. P5 ordinary authorization loss revokes current episode and completion.
G. P6 recovery alone cannot resume the invalidated episode.
H. P7 reference/feedback validity losses independently revoke current episode authority.
I. P8 numeric equality across generations never substitutes for generation/episode identity.
J. No downstream numeric planner, `limit3`, posthome, motor, hydraulic or safety-authority command is emitted.

All gates are frozen before implementation and may not be weakened after observation.

## Evidence boundary

PASS would validate only generation/episode ownership and fail-closed invalidation semantics in a deterministic software fixture. It would not validate numeric target correctness, physical machine motion, stopping behavior or functional safety.
