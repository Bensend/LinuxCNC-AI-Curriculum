# 3500 — kinematics failure propagation in Motion

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: **SOURCE-CONFIRMED**

## Question

When a nontrivial robot/custom kinematics module cannot produce a valid inverse solution, where does failure become machine-visible? Is inverse failure only a preview/interpreter issue, or can it disable Motion during realtime execution?

## Command-admission path

`src/emc/motion/command.c::inRange()` builds a candidate joint-position array from the current joint commands and calls:

`kinematicsInverse(candidate Cartesian endpoint, joint_pos, iflags, fflags)`.

A nonzero return reports `<move> move on line <id> fails kinematicsInverse` and returns false. Callers reject the candidate move. This is an upstream endpoint-admission guard.

The resulting contract is:

`Cartesian endpoint -> IK trial -> joint-limit trial -> motion command accepted/rejected`.

It is useful, but it cannot prove the whole interpolated path is kinematically benign.

## Realtime coordinated/teleop path

Pinned `control.c::get_pos_cmds()` provides the stronger failure boundary.

During coordinated motion, LinuxCNC obtains Cartesian trajectory samples and repeatedly applies inverse kinematics before inserting resulting joint coordinates into the cubic joint interpolators. If inverse returns zero, the resulting joint positions are checked for finiteness and added to the joint interpolation path.

If inverse returns nonzero, Motion:

1. reports `kinematicsInverse failed`;
2. sets the Motion error flag;
3. sets `emcmotInternal->enabling = 0`;
4. breaks out of the coordinated position-generation loop.

The same essential handling exists in teleop Cartesian motion. A non-finite joint value from a nominally successful inverse is also treated as a Motion error and requests disable.

On the next operating-state transition the normal Motion-disable path clears coordinated trajectory/interpolator state and makes commanded positions track feedback while disabled.

Therefore a real inverse failure is **not merely a GUI warning**. It is an ordinary Motion fault that requests machine-control disable.

## Joint soft-limit backstop

After position generation, Motion checks each homed joint command against joint soft limits. The source comments explicitly list `kins module misbehavior` as one possible reason this backup check could trip.

For non-identity kinematics, the emitted recovery hint is to switch to joint mode to jog off the soft limit. That is a recovery affordance, not proof that changing kinematics is mechanically safe in every robot pose.

This yields three distinct failure surfaces:

1. **IK endpoint rejection before a move is admitted**;
2. **IK/non-finite failure while coordinated or Cartesian teleop targets are being generated**, which sets Motion error and requests disable;
3. **resulting joint target exceeds a joint soft limit**, which independently sets Motion error.

## Singularity implication

For iterative Jacobian-based `genserkins`, singular/ill-conditioned geometry can therefore surface in several different ways:

- direct Jacobian inversion failure -> IK nonzero -> Motion error/disable request;
- inability to converge before `max_iterations` -> IK nonzero -> same Motion path;
- a numerically converged solution with extreme joint displacement may remain mathematically valid but later violate joint limits or physical tracking capability;
- an extreme but finite joint-velocity demand can produce drive/following-error behavior without necessarily causing IK to return an error first.

`IK success != dynamic feasibility`.

## Branch/state consequence

Switchable identity kinematics can provide a recovery/setup route for some nontrivial machines, but kinstype persists through Abort and switching changes the mapping between pose and joints. Recovery must therefore preserve the actual machine posture and chosen transformation; it cannot be taught as a universal emergency escape command.

## Adversarial checks

1. A Cartesian endpoint passed `inRange()`. Does that guarantee every interpolated pose will have valid IK? **No.**
2. If IK fails during coordinated execution, does LinuxCNC simply hold the previous joint target and continue enabled? **No; source sets Motion error and requests disable.**
3. If IK returns success with NaN/Inf joint data, is it accepted? **No; non-finite joint values also fault and request disable.**
4. If IK succeeds, are joint limits automatically satisfied? **No; a separate soft-limit backstop checks resulting joint commands.**
5. Does joint-mode recovery prove the pose is collision-free? **No.**
6. Does inverse failure establish the exact physical singularity cause? **No; solver implementation, calibration/geometry, seed, branch and invalid request can all contribute.**

Result: **6/6 boundaries preserved.**

## Promotion / next work

The generic inverse-failure path is now source-closed. The higher-value 3500 work is machine evidence: real robot homing/brake/reference architecture, actual DH/calibration workflow, singularity/branch commissioning chronology, and custom kinematics maintenance. A bounded lab should target a specific remaining claim (for example seed/convergence and SCARA reach/branch behavior), not re-demonstrate the already source-visible Motion disable path.
