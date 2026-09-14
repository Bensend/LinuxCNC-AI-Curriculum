# 3500 — genserkins inverse-failure / PUMA field reconciliation

Date: 2026-09-14
Pinned LinuxCNC source: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: SOURCE + FIELD reconciliation

## Exact inverse algorithm

Pinned `src/emc/kinematics/genserfuncs.c` shows that `genserKinematicsInverse()` is an iterative local solver seeded from the incoming `joints[]` estimate.

For each iteration it:

1. builds link states from the current joint estimate `jest[]`;
2. computes the forward Jacobian;
3. computes an inverse/pseudoinverse Jacobian;
4. forward-solves the current estimate to `pest`;
5. computes the target pose delta;
6. converts the pose delta into translational/rotational incremental velocity form;
7. maps that Cartesian delta through the inverse Jacobian to joint increments `dj[]`;
8. declares convergence only when every joint increment is `GO_*_SMALL`;
9. otherwise adds `dj[]` to `jest[]` and repeats.

The default maximum iteration count is exposed through the HAL `max-iterations` pin; the solver also exposes the last iteration count.

## Distinct source-visible failures

### Jacobian construction/inversion failure

`compute_jfwd()` errors return immediately. `compute_jinv()` errors also return immediately. For a square six-axis serial case, `compute_jinv()` directly calls `go_matrix_inv()`; a singular/non-invertible Jacobian can therefore terminate the inverse solve before iteration exhaustion.

### Non-convergence / iteration exhaustion

If the increments never all become sufficiently small before `max-iterations`, the function prints `ERRkineInverse(...iterations=N)` and returns `GO_RESULT_ERROR`.

### Seed dependence

The input `joints[]` is copied into `jest[]` before iteration. Therefore inverse success/branch behavior is locally seed-dependent. A previously plausible joint estimate is part of the numerical contract.

## Reconciliation with the 2026 PUMA 200 field case

The field chronology must not be summarized as one generic "genserkins failed" problem. At least five independent failure classes were visible:

1. **mechanism/model mismatch** — incorrect PUMA-family gear-ratio data and unresolved wrist coupling meant logical joint coordinates could be wrong before kinematics;
2. **zero/home-model mismatch** — the physical all-zero pose did not initially agree with the pose assumed by the DH chain;
3. **wrong modified-DH frame rotations/signs/offsets** — produced curved or incorrect Cartesian paths even away from an immediate solver failure;
4. **wrist singularity / near-singularity** — could make the Jacobian ill-conditioned/non-invertible and produce very large wrist reorientation demands;
5. **downstream Motion limits/following errors** — soft-limit or following-error trips are not the same event as `genserKinematicsInverse()` returning failure.

The community warning that a simulation may rapidly flip wrist orientation near singularity while real hardware trips following error is therefore consistent with the source architecture: solver output and downstream joint tracking/limits are separate layers.

## Diagnostic playbook

When a serial robot reports a kinematics error or fails during world-mode motion, do not begin by tuning `max-iterations`.

Classify evidence in this order:

1. verify physical joint state and transmission mapping;
2. verify all-zero/home geometry against the kinematic model;
3. verify simple forward-kinematic poses;
4. inspect singularity proximity / Jacobian conditioning symptoms;
5. distinguish immediate Jacobian inversion failure from iteration exhaustion;
6. inspect downstream joint soft-limit and following-error state separately;
7. only consider iteration-limit changes after geometry/seed/singularity evidence justifies it.

Blindly increasing `max-iterations` cannot repair a wrong DH chain, wrong gear ratio, wrong home pose, or singular Jacobian.

## Adversarial review

1. Is every `ERRkineInverse` caused by max-iteration exhaustion? **No; Jacobian construction/inversion can return earlier.**
2. Does iteration exhaustion prove the target pose is globally unreachable? **No; this is a local iterative solver and can depend on seed/conditioning.**
3. Does solver success prove joint limits/following error will pass? **No.**
4. Can tuning max iterations repair bad machine geometry? **No.**
5. Does a singular physical pose necessarily show up only as a clean solver error? **No; near-singular solutions can demand severe joint motion and downstream tracking can fail first.**
6. Does the PUMA field case prove genserkins is incorrect? **No; corrected physical/model inputs substantially corrected world motion.**
7. Should inverse-error diagnostics preserve seed and iteration count? **Yes; both are source-relevant evidence.**

Adversarial result: **7/7 bounded claims survive.**

## Promotion decision

Promote to the 3500 playbook. The native serial-robot branch now has enough source + field evidence for a breadth stop unless a second inspectable real robot configuration with materially different architecture surfaces. Further generic genserkins experimentation is low value relative to rotating to an underdeveloped 3000 specialization.
