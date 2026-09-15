# 3900 — native genhexkins convergence/failure authority trace — 2026-09-15

## Scope

Bounded unusual-machine source trace focused only on the authority questions that are not duplicates of 3500 serial-robot IK work: forward-solution convergence, invalid geometry, failure observability and switchable-kinematics implications.

Pinned upstream LinuxCNC revision: `6c207a9f01dfbab656ab25a0b47995802b6e1f38`.

Primary source: `src/emc/kinematics/genhexkins.c`.

## Forward versus inverse asymmetry

`genhexkins` has an important asymmetry:

- inverse kinematics (platform pose -> six strut lengths) is closed form and described by source as having one solution for the requested pose;
- forward kinematics (six strut lengths -> platform pose) is iterative Newton-Raphson, begins from an initial pose estimate and converges to the nearby solution.

The forward problem can have multiple mathematical solutions. The returned solution is therefore branch/seed dependent: it is the solution nearest the supplied initial estimate, if a suitable solution exists and convergence succeeds.

This is materially different from treating “the joint lengths” as automatically defining one globally unique Cartesian pose.

## Explicit failure boundaries

The inspected source contains several visible failure paths:

1. any strut length <= 0 returns an error immediately;
2. excessive convergence error sets `genhexkins.fwd-kins-fail` and returns failure;
3. exceeding the configurable iteration limit also terminates without convergence;
4. source comments explicitly note that stronger geometry checks such as triangle-inequality constraints are still a FIXME;
5. the 6x6 matrix inversion routine contains a FIXME noting that zero divisors are not comprehensively checked.

The component exposes convergence observability through HAL, including:

- `genhexkins.fwd-kins-fail`;
- `last-iterations`;
- `max-iterations`;
- configurable convergence criterion;
- iteration limit;
- maximum-error threshold.

The shipped hexapod simulation wires the failure and iteration pins to GUI diagnostics. That proves the failure state is intentionally observable, but GUI visibility is not itself a machine permissive or safety response.

## Authority lesson

For a Stewart platform, several states must remain distinct:

`positive/credible strut lengths`

`!= forward solver converged`

`!= selected Cartesian assembly branch is the physically intended branch`

`!= requested pose is inside safe mechanical workspace`

`!= collision/singularity/load limits are satisfied`.

A successful numerical forward solution is therefore necessary state reconstruction, not a complete machine-readiness witness.

## Tool-offset warning

The source explicitly warns that tool offset changes (G43/G49) should occur only with platform tilt A=B=0 to avoid joint jumps. This is a valuable unusual-machine process rule: a conventional-looking coordinate/tool-offset operation can imply immediate multi-strut geometry changes on a parallel machine.

Preserve:

**coordinate-system convenience operations can become physical joint-transition operations under nontrivial kinematics.**

## Switchable kinematics boundary

The shipped hexapod configuration is part of LinuxCNC's switchkins examples. Switching kinematics can provide identity/joint-oriented setup modes, but changing representation does not erase the physical assembly branch, workspace or convergence problem. Transitioning between kinematic modes therefore needs deliberate synchronization and pose consistency; it is not a recovery mechanism for an unknown physical platform state.

## Lab decision

No lab is required for the basic convergence boundary because source explicitly exposes the iteration/error/failure behavior and the shipped simulation already surfaces it. A future adversarial lab would only add value if a specific claim remains about branch selection after mode switching or recovery from an intentionally bad forward seed.

## Promotion decision

3900 now has useful evidence from three genuinely different unusual-machine authority classes:

- additive: thermal/material authority layered on coordinated motion;
- winding: rotary/traverse geometry with source-thin material-process authority;
- parallel kinematics: numerical convergence/assembly-branch authority.

The breadth objective is better served by checkpointing 3900 here and rotating back to another open 3000 branch rather than extending generic unusual-machine searches.
