# 3500 Robots / Custom Kinematics — breadth and source foundation

Date: 2026-09-14
Pinned LinuxCNC source revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: **FOUNDATION / SOURCE + COMMUNITY**

## Scope

This first 3500 pass establishes the LinuxCNC kinematics authority boundary for serial robots and SCARA-class mechanisms before studying machine-specific robot I/O, brakes, homing and cell sequencing. The immediate goal is to prevent a common category error: treating Cartesian trajectory intent, inverse-kinematics solvability, joint limits and physical robot safety as if they were the same state.

## Core architecture

For a nontrivial robot the important directionality is:

`joint feedback/command <-> kinematics module <-> Cartesian pose/path`

LinuxCNC asks the selected kinematics module to provide forward and inverse mappings. Those functions are not merely display helpers; inverse kinematics participates in validating candidate Cartesian moves and in converting the realtime Cartesian command back into joint targets.

The practical state separation is:

1. **Cartesian path intent** — XYZABC... requested by interpreter/trajectory planning;
2. **kinematic branch / type** — which mapping is active and, for multi-solution mechanisms, which solution family is selected;
3. **inverse-solver success** — whether a usable joint solution is found from the current seed/state;
4. **joint target** — resulting individual joint positions;
5. **joint limits / feedback / following error** — whether the physical axes can follow those targets;
6. **collision / guarding / safety** — separate machine/cell responsibilities unless independently implemented and validated.

Do not collapse these layers.

## Switchable kinematics authority

Pinned `docs/src/motion/switchkins.adoc` establishes that switchable modules commonly provide a primary machine kinematics type plus identity kinematics for setup/joint control. `genserkins`, `pumakins`, `scarakins`, `genhexkins` and several five-axis modules support this model.

The preferred change path is `G12.1 Pn` / `G13.1`. These commands synchronize interpreter and Motion when the type changes. The older `motion.switchkins-type` HAL input remains supported for compatibility but is explicitly deprecated because the interpreter cannot see a raw HAL-side change: program lookahead and limit checks may continue using the kinematics type the interpreter last knew about.

That yields a strong authority rule:

`Motion kinstype != sufficient proof that interpreter lookahead used the same kinstype`

unless switching occurred through the synchronized G-code contract.

A second important behavior is persistence: switchkins selection is not automatically canceled by program end or Abort. A program that must leave the machine in identity kinematics must explicitly select it. Therefore kinstype is persistent machine state, not a transient per-program modifier.

## `genserkins`: generalized serial manipulator

Pinned `src/emc/kinematics/genserkins.c` defines the switchable wrapper:

- primary type 0: generalized serial kinematics;
- identity type 1;
- optional user type 2;
- primary implementation expects six robot joints;
- duplicate coordinate identities are not allowed for the serial mapping.

Pinned `genserfuncs.c` exposes the deeper mechanism. The robot is modeled with Denavit-Hartenberg link data. HAL-backed values include link `a`, `alpha`, `d` and `unrotate` parameters. The current implementation initializes six links as angular joints and explicitly notes remaining generalization work.

### Inverse call flow

The inverse path is iterative rather than a closed-form PUMA solution:

`requested EmcPose -> quaternion pose -> current joint estimate -> forward Jacobian -> inverse/pseudoinverse Jacobian -> pose error -> incremental joint update -> convergence test -> joint solution`

`compute_jinv()` directly attempts a matrix inverse for square Jacobians and a pseudo-inverse construction for non-square cases. A failed matrix inversion returns an error. `genserKinematicsInverse()` also fails when it exhausts `max_iterations` without convergence. The solver records iteration count through `last_iterations`.

The starting value in `joints[]` is therefore semantically important: it is the initial estimate, not just an output buffer. Different seeds can affect convergence and which local solution is reached.

### Singularity consequence

Near a singular configuration, the Jacobian becomes poorly conditioned or non-invertible. The mathematical consequence is not simply an inaccurate display position: modest Cartesian velocity can imply very large joint velocity, or inverse calculation can fail. A simulator can visually perform a rapid wrist rearrangement that real hardware cannot follow; the physical machine may instead accumulate following error or hit joint/drive constraints.

The shipped PUMA560 simulation itself contains a useful clue: JOINT_4 is homed to `0.1` rather than exactly zero with the comment `avoid kinematisInverse fail`. This is executable-reference evidence that seed/reference pose matters around problematic geometry. The simulator is a reference fixture, not proof of production robot robustness.

## Inverse failure propagation

There are at least two important failure surfaces in pinned Motion source.

### Command admission

`command.c::inRange()` calls `kinematicsInverse()` on a candidate Cartesian endpoint. A nonzero return reports that the move fails inverse kinematics and rejects the range check. Thus endpoint solvability is part of command admission.

### Realtime Cartesian-to-joint conversion

`control.c` calls `kinematicsInverse()` on the commanded Cartesian pose during coordinated execution before copying positions into joint structures. The copy/update path is conditional on successful inverse return. This makes inverse-solver reliability part of realtime joint-target generation, not merely an interpreter concern.

A later pass should trace the exact externally visible status/error propagation for a realtime inverse failure and preserve the difference between pre-admission rejection and a failure encountered while executing an already-planned path.

## SCARA: explicit branch state and boundary behavior

Pinned `scarakins.c` is analytically very different from `genserkins`.

Forward kinematics computes XY from two planar rotary joints plus an optional tool offset; Z comes from the prismatic joint. It sets `iflags` according to a joint-angle condition, carrying solution-branch information forward.

Inverse kinematics reconstructs the elbow angle with `acos(cc)` and changes its sign according to `iflags`. Therefore elbow-up/elbow-down selection is explicit state. A Cartesian point alone does not uniquely identify a continuous robot configuration.

The implementation also clamps `cc` into `[-1,1]` before `acos`. That prevents a numeric domain error but means an out-of-workspace radial request can be numerically projected to the geometric boundary instead of necessarily returning an inverse-kinematics error. This is a source-visible behavior that deserves a bounded round-trip/reachability test before being turned into stronger operational guidance.

## Custom kinematics extension contract

Pinned `src/hal/components/userkins.comp` is the supported template for user-built kinematics compiled with `halcompile`. It explicitly requires the developer to implement `kinematicsForward()` and `kinematicsInverse()` and to declare the appropriate kinematics type.

An important implementation detail is that ordinary component pins are not automatically available to the kinematics functions. Kinematics-related HAL pins/parameters must be created during the kinematics setup path. The template also distinguishes ordinary realtime component functions from the kinematics callbacks.

This reinforces the design rule that a custom robot kinematics module is part of Motion's coordinate transformation contract, not an arbitrary threaded HAL calculator.

## Real-field/community chronology

Community reports are leads and failure evidence, not automatic source truth.

### PUMA 200 — July/August 2026

A current LinuxCNC forum build reports a physical Unimation PUMA 200 with all joints, brakes and encoders operating and gear/encoder ratios checked before changing to `genserkins`. Joint mode works, while world mode exposes TCP orientation, small-radius XY behavior, limits and kinematics errors. The builder adapted PUMA560 DH data to the PUMA200 geometry and also has sign/home differences.

Forum diagnosis points toward wrist singularity and frame/DH interpretation as major issues. The key transferable lesson is chronological: electrical/joint correctness did **not** establish Cartesian-kinematics correctness. The builder reached a second commissioning layer only after joint hardware was already functional.

### SCARA compatibility dispute — 2025

A user reported following errors, motor jolts, joint-value shifts after homing and negative-space problems with `scarakins`, proposing changed inverse equations. LinuxCNC developer response emphasized backward compatibility: if revised behavior changes existing valid configurations, it should become a distinct kinematics module rather than silently replacing the old mapping.

This is important for custom-machine engineering: a mathematically 'better' inverse is not automatically a compatible machine-coordinate contract.

### Custom SCARA maintenance — 2024/2025

Other community threads show users carrying modified SCARA kinematics across LinuxCNC version changes and being steered toward `userkins.comp`. This is evidence that custom kinematics has a lifecycle/maintenance cost and should be kept explicit, version-pinned and testable.

## Machine-architecture playbook foundation

For robots/custom kinematics preserve at least these separate contracts:

`homed joint reference`
`+ calibrated mechanism parameters`
`+ selected kinematics type`
`+ selected inverse branch/seed`
`+ Cartesian path validity`
`+ joint target validity`
`+ joint velocity/acceleration/limit feasibility`
`+ feedback/following-error health`
`+ brake/drive authority`
`+ cell safeguarding/collision policy`

None of the earlier layers proves the later ones.

Commissioning should therefore advance in layers: verify individual joint sign/scaling/reference first; verify forward pose against physically measured landmarks; test inverse round trips at safe static points; map branch changes and singular neighborhoods; only then permit broader coordinated Cartesian motion. A visual Vismach match is useful evidence but not a substitute for joint-limit, velocity and physical-clearance validation.

## Safety boundary

LinuxCNC kinematics can calculate robot motion but the inspected sources do not establish safety-rated singularity avoidance, collision avoidance, human detection, safe speed monitoring or safe torque/off functions. Near-singularity joint-speed amplification and branch changes are ordinary control hazards that require machine-specific limits and commissioning. Industrial robot safeguarding remains a separate system/design obligation.

## Adversarial review

1. **If Cartesian XYZABC is within axis limits, is the robot move necessarily valid?** No. Inverse kinematics may fail or yield joint targets outside joint limits/feasible speed.
2. **If `motion.kins-type` reports the desired value, did interpreter lookahead necessarily use it?** No, not for a raw deprecated HAL-side switch; use synchronized G12.1/G13.1.
3. **Does Abort automatically restore identity kinematics?** No. Kinstype persists.
4. **Does a converged `genserkins` inverse prove the solution is far from singularity?** No. Convergence and conditioning are separate questions.
5. **Is the PUMA560 simulator's successful movement proof a real robot can follow it?** No. Real joint velocity/drive/following-error limits remain.
6. **Can SCARA Cartesian pose alone specify elbow configuration?** No. Branch state matters.
7. **Does clamping the SCARA cosine argument prove an out-of-workspace request is rejected?** No; source suggests boundary projection is possible and must be tested.
8. **May a custom kinematics module be treated as a safety collision controller?** No evidence.

Result: **8/8 boundaries preserved.**

## Lab decision

No lab is launched in this pass. Source and real commissioning evidence still have high information gain. A later bounded kinematics lab is justified only after the remaining source path is traced; useful candidate cases are:

- `genserkins` inverse convergence/iteration count versus seed near a wrist singularity;
- SCARA forward->inverse round trip across both elbow branches and just beyond nominal reach;
- kinstype persistence through Abort and synchronized versus deprecated HAL switching.

These experiments would test specific source-visible uncertainties rather than simulate a generic robot for its own sake.

## Next evidence path

1. Trace realtime inverse failure propagation from `control.c` through Motion status/error/following behavior.
2. Inspect at least one genuinely real robot config/build diary with downloadable HAL/INI/kinematics—not a cloned upstream simulation—preserving brake, homing, drive and recovery chronology.
3. Inspect custom/user kinematics deployment patterns and version maintenance.
4. Then freeze only the smallest singularity/branch lab that adds independent evidence.
