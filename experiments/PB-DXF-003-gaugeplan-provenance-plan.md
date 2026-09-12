# PB-DXF-003 — GaugePlan provenance/invalidation fixture

Date frozen: 2026-09-12
Status: FROZEN BEFORE IMPLEMENTATION
Scope: application ownership/provenance only. No numeric target calculation, LinuxCNC command, motor model, tooling/collision solution, hydraulic behavior, or functional-safety claim.

## Question

Can a human-selected GaugePlan remain bound to stable BendStep identity instead of recipe ordinal, reject unresolved/stale datum evidence, and require explicit revalidation across source/mechanism changes before any later target calculation is allowed?

## Frozen model

A current BendStep has `step_id`, `bend_id`, ordinal, source revision and validation state.

A GaugePlan has:
- stable `gauge_plan_id`;
- bound `step_id` / `bend_id`;
- bound source revision;
- selected `datum_id` plus datum provenance;
- participating mechanism set;
- validation `DRAFT|ACCEPTED|REVIEW_REQUIRED|INVALID`;
- machine-readable reason.

No numeric target field exists in this fixture.

## Frozen cases

P0 — normal accepted plan
- accepted S1/B1 at R1;
- operator selects current datum D1 with provenance;
- mechanism set `{X}`;
- explicit validation yields ACCEPTED.

P1 — recipe reorder
- S1 ordinal changes;
- plan remains bound to S1/B1 and remains eligible because identity/provenance did not change.

P2 — no datum selected
- plan with datum `UNASSIGNED` cannot become ACCEPTED.

P3 — BendStep loses validity
- S1 becomes REVIEW_REQUIRED;
- dependent GaugePlan becomes REVIEW_REQUIRED and cannot remain accepted.

P4 — reimport without trusted datum remap
- bend identity may survive separately, but selected R1 datum D1 lacks trusted R2 remap;
- plan becomes REVIEW_REQUIRED with source/datum reason.

P5 — trusted datum remap
- D1 has a trusted R2 remap with unchanged datum semantics;
- plan must be rebound to R2 and explicitly revalidated before ACCEPTED.

P6 — participating mechanism set changes
- accepted `{X}` plan is changed to `{X,R}`;
- plan becomes REVIEW_REQUIRED until explicitly revalidated for the new set.

P7 — authority boundary
- retained output must not contain a numeric gauge target, TargetSet generation, joint command, `posthome-cmd`, tooling choice, collision result, hydraulic command, or safety authorization.

## Frozen Gates A–J

A. P0 accepts only a current accepted step plus assigned/provenanced datum and nonempty mechanism set.
B. P1 recipe ordinal changes do not change GaugePlan `step_id`/`bend_id` binding or plan identity.
C. P2 refuses acceptance with explicit `DATUM_UNASSIGNED` reason.
D. P3 propagates BendStep loss of validity into GaugePlan REVIEW_REQUIRED/INVALID.
E. P4 refuses silent reuse of an old-revision datum without trusted remap.
F. P5 requires explicit R2 rebind/current validation even with trusted datum identity.
G. P6 mechanism-set change revokes prior acceptance until explicit revalidation.
H. Every nonaccepted current plan state carries a machine-readable reason and source revision.
I. No plan state uses recipe ordinal as its identity/binding key.
J. No numeric target/TargetSet/motion/tooling/collision/hydraulic/safety-authority field is emitted.

All gates are frozen before implementation and may not be weakened after observation.

## Evidence boundary

PASS validates only deterministic application GaugePlan provenance/invalidation semantics. It does not establish how a real gauging datum should be chosen, how numeric targets are calculated, reachability, physical finger contact, collision freedom, machine motion, or functional safety.
