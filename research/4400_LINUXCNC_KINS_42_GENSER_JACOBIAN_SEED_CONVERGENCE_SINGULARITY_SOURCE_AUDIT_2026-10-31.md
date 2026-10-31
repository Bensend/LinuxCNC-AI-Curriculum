# 4000-LC-KINS-42 — Genserkins numerical inverse: seed, Jacobian, singularity, and convergence contract

**2026-10-31 | 4000 implementation / 3500 robotics transfer | NON-GRADUATED | SOURCE-CONFIRMED static, not executed.**

## New question and predecessor boundary
What does LinuxCNC actually call a successful serial-robot inverse-kinematics solve, and what is the failure contract at a singular pose? This is **new numerical-solver depth**, not a repeat of [KINS-10](4400_LINUXCNC_KINS_10_FAILED_SWITCH_TASK_STATUS_AND_STABLE_DEVEL_SOURCE_AUDIT_2026-10-30.md), which already covered Task acknowledgement, forward-solve rollback and stable/development switch status. A G-code or HAL switch acknowledgement is not a proof that a subsequent inverse solve is accurate.

## Pinned sources
- Stable [v2.9.10 genserfuncs.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/kinematics/genserfuncs.c), blob `3b1bc5a7f2e56062bf199b25a19fb4f34c51dacb`: `genserKinematicsInverse`, `compute_jfwd`, `compute_jinv`, `genser_kin_fwd`, `genserKinematicsSetup`. [Stable genserkins.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/kinematics/genserkins.c), blob `62f811dee8a5e281c61de35f623bb180a3c7d09e`.
- Development commit [`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`](https://github.com/LinuxCNC/linuxcnc/commit/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1): [genserfuncs.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/kinematics/genserfuncs.c), blob `b4f4d59fd14220f5a3fd06b10b1ef0211e0b61b7`, `genser_inverse` ~680–824, `ludcmp` ~195–260; [genserkins.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/kinematics/genserkins.c), blob `7d8caeaaa3d7bcb11b5e8a23a6b5cadf6f78931b`.
- Real upstream [Puma560 simulation INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/puma/puma560.ini), blob `c2bfc1c2a122f55b24bf3897e41e54e16dc44179`, and [DH HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/puma/puma560_dh.hal), blob `39d851fe9059592c332a721d83e6a0ed293b8b70`.
- Official [switchkins documentation](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/motion/switchkins.adoc) describes identity switching for joint-level recovery near singularities.

## Execution trace
1. The upstream `puma560.ini` selects **`genserkins`**, not the separate analytic `pumakins` module. The six `[JOINT_N]` entries are angular; `puma560_dh.hal` supplies six A/ALPHA/D link descriptions. `genser_kin_init` hardcodes six revolute links; extra U/V/W slots, when present, are pass-through rather than additional Jacobian-controlled serial links.
2. `genserKinematicsInverse` copies the **incoming joint array as its starting estimate** (`jest`, degrees→radians). It builds a 6×6 Jacobian at that estimate, inverts it, forward-evaluates the estimate, computes the target-minus-estimated pose transform, rotates the translation/rotation error into the base frame, and multiplies the error by inverse Jacobian to obtain `dj`. The next estimate is `jest += dj`.
3. Stable `compute_jinv` uses direct matrix inversion for square Jacobians (with pseudoinverse branches for non-square matrices). Development `compute_jinv` similarly uses direct inversion; development's local LU pivot test returns `GENSER_SINGULAR` below `GENSER_SINGULAR_EPSILON = 1e-15`. **No damped least-squares singularity avoidance is present in the inspected path.** This is an algorithm characterization, not a prediction of a specific robot's reachable envelope.
4. **The successful-exit predicate tests joint update size, not an independently bounded Cartesian pose residual.** Stable checks `GO_TRAN_SMALL`/`GO_ROT_SMALL` on `dj` according to link quantity; development tests `fabs(dj[i]) < GENSER_SMALL` for all six links, with `GENSER_SMALL=1e-7` radians. In development that is ~0.00000573 degrees of proposed joint update, **not a guarantee of any fixed XYZ or orientation error**. A poor-conditioned Jacobian or geometry error needs independent forward-reprojection evidence; a small update alone is insufficient as a metrology acceptance oracle.
5. The default maximum is **100 iterations** (both `genserkins.h` versions). Stable exposes `genserkins.max-iterations` and `last-iterations` HAL pins; development declares these through the kinematics parameter table and publishes the last count. An inverse/Jacobian failure or exhausted iteration budget returns an error. Neither return code nor the iteration counter by itself quantifies how far a requested pose lies outside reach.
6. The stock `puma560.ini` deliberately sets `[JOINT_4] HOME=0.1` with comment `avoid kinematisInverse fail`, unlike its other zero home angles. This is **SOURCE-CONFIRMED configuration evidence of a singularity workaround**, not a measured singular pose, proof of solver correctness, or safe real-machine homing recipe.

## Failure paths and observability
- A singular Jacobian can fail during inversion; a reachable target can also fail to converge within the iteration cap if the seed/geometry is unsuitable. The inverse uses a local branch seeded by joint position; no global branch enumeration or collision checking is established.
- Raising `max-iterations` may change convergence/failure behavior, but is not a singularity cure. `last-iterations` is useful for diagnostics but is not a residual or success flag.
- To distinguish solver failure from configuration error, record exact DH values and units, initial joint seed, target pose, solver return, iteration count, and independent forward transform of any returned joint solution. Never assume the DH table uses millimeters merely because the numbers resemble dimensions; the Puma INI declares **inch** linear units.

## Claims and evidence
| Claim | Class | Verification still needed |
|---|---|---|
| Six revolute DH links, seed from current joints, Jacobian iterative inverse | SOURCE-CONFIRMED stable/development | No fresh execution |
| Direct inverse without damping; singular/iteration error returns | SOURCE-CONFIRMED selected code | Failure threshold and machine behavior in isolated simulation |
| Small joint update is the success predicate, not explicit Cartesian residual | SOURCE-CONFIRMED | Quantify residual in forward round-trip fixture |
| HOME joint 4 = 0.1 is an upstream workaround | SOURCE-CONFIRMED configuration | Cause and runtime necessity UNKNOWN |
| Any particular real robot could jump, collide, or exceed a limit | UNKNOWN | Requires separate physical/model evidence; not asserted |

## Reproducible software-only acceptance design (NOT RUN)
Freeze two seeds for the same target pose (one near a known nonsingular pose, one near a wrist singularity) and one unreachable target. Use the **pinned** Puma INI/HAL in a disconnected simulation on qualified `[self-hosted, openpressbrake]` only. Capture `genserkins.last-iterations`, status/errors, joint commands, and pose feedback; compute forward-reprojection translation and orientation residual independently from the returned joint vector. Gate success on **both** no solver error and bounded reprojection residual, not on iteration count. Change only one variable at a time (seed, target, or iteration cap); never run on a physical robot.

**Next:** source-trace the motion caller's handling of inverse failures if a runtime oracle reveals ambiguity; otherwise validate the configuration-switch interface in KINS-43. Independent personnel safety and joint-limit authority are separate from this numerical demonstration.
