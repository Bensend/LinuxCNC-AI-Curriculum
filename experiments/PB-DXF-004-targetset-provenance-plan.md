# PB-DXF-004 — TargetCalculation / TargetSet provenance fixture

Date frozen: 2026-09-12
Status: FROZEN BEFORE IMPLEMENTATION
Scope: application target ownership/provenance only. No validation of a bend formula, physical gauge contact, motor motion, collision/tooling suitability, hydraulics, or functional safety.

## Question

Can a TargetSet distinguish direct operator targets from calculated/imported targets, preserve calculation/dependency provenance, invalidate stale values when dependencies change, and issue a new runtime generation only after explicit current validation?

## Frozen model

A current accepted GaugePlan has `gauge_plan_id`, source revision, mechanism set and validation state.

A TargetSet has:
- stable `target_set_id`;
- bound `gauge_plan_id`;
- method kind: `DIRECT_MACHINE_COORDINATE|CALCULATED|IMPORTED_CAM`;
- method identifier/version;
- dependency revision map;
- per-mechanism target values (opaque numeric test values; no claim that they are physically correct);
- validation `DRAFT|ACCEPTED|REVIEW_REQUIRED|INVALID`;
- machine-readable reason;
- runtime `generation`, assigned only on explicit current acceptance.

## Frozen cases

P0 — direct operator coordinate
- accepted GP1 at R1 with mechanisms `{X}`;
- trained-operator direct target method `DIRECT_MACHINE_COORDINATE/manual-v1` supplies X=100.0 as an opaque test value;
- dependencies include machine calibration revision C1 and GP1 revision R1;
- explicit validation yields ACCEPTED and generation 1.

P1 — calculation method
- same current GaugePlan uses `CALCULATED/flange-x-demo-v1` with opaque X=95.0;
- dependencies additionally include method version M1, tooling revision T1 and bend-model revision B1;
- acceptance requires all declared dependencies current and produces a distinct generation.

P2 — dependency changes after acceptance
- calibration C1 -> C2;
- prior target becomes REVIEW_REQUIRED / `DEPENDENCY_CHANGED:calibration`; old generation cannot remain current authority.

P3 — numeric coincidence does not preserve authority
- recalculation under C2 happens to yield the same numeric X as before;
- target remains noncurrent until explicit revalidation; equality of numeric values is not provenance equality.

P4 — GaugePlan invalidated
- GP1 becomes REVIEW_REQUIRED;
- dependent TargetSet becomes REVIEW_REQUIRED or INVALID and cannot issue a generation.

P5 — mechanism coverage mismatch
- GaugePlan mechanisms change `{X}` -> `{X,R}` while target contains only X;
- acceptance fails with explicit mechanism-coverage reason.

P6 — imported CAM target
- `IMPORTED_CAM` target requires source package ID/version plus machine/calibration compatibility provenance;
- missing/changed package or machine compatibility blocks acceptance.

P7 — direct target is not exempt from provenance
- direct/operator X may bypass bend-model calculations but still depends on current GaugePlan, machine calibration, mechanism set and explicit validation.

P8 — runtime generation discipline
- each successful current acceptance increments application-owned generation;
- stale/review/invalid target carries no newly authorized generation;
- reacceptance after dependency change creates a new generation, never resurrects the old one.

P9 — boundary
- fixture emits no LinuxCNC command, `posthome-cmd`, `limit3` input, machine enable, tooling/collision decision, hydraulic command or functional-safety authorization.

## Frozen Gates A–J

A. P0 direct target accepts only with current GaugePlan, complete mechanism coverage, calibration provenance and explicit validation; generation is assigned.
B. P1 calculated target retains method/version plus declared dependency revisions and receives a generation distinct from P0.
C. P2 dependency change revokes current authority with explicit dependency-change reason.
D. P3 identical numeric output does not restore acceptance/current generation without explicit revalidation.
E. P4 GaugePlan loss of validity propagates to TargetSet authority.
F. P5 mechanism coverage mismatch blocks acceptance.
G. P6 imported CAM acceptance requires package/version and machine/calibration compatibility provenance.
H. P7 direct target remains subject to current GaugePlan/calibration/mechanism provenance despite bypassing bend-model inputs.
I. P8 generations advance on each explicit current acceptance and are never silently resurrected after invalidation.
J. No LinuxCNC/motion/posthome/limit3/tooling/collision/hydraulic/safety-authority output is emitted.

All gates are frozen before implementation and may not be weakened after results.

## Evidence boundary

PASS validates only TargetSet ownership/provenance/invalidation/generation semantics using opaque test numbers. It does not validate any target's physical correctness or any machine behavior.
