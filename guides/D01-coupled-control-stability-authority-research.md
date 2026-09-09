# D01 — coupled-control stability and tandem-joint authority

Status: **EXPERIMENT FROZEN / PREFLIGHT ACTIVE**

Pinned LinuxCNC revision for source-grounded 1000→2000 continuity: `8bf4605ae81042248add031e94c77300406e0413`.

## Question

When one Cartesian coordinate is mapped to multiple LinuxCNC joints, what is actually guaranteed by kinematics, homing, joint following-error checks and reported Cartesian feedback—and what remains an unproven property of the mechanics, sensors and actuator authority?

## Documentation findings

Current LinuxCNC `kins(9)` explicitly supports duplicated coordinate letters in `trivkins`; e.g. `coordinates=xyyzw kinstype=B` maps one Y coordinate to two joints. The documentation identifies this as a gantry pattern and warns that moving one joint alone can rack the mechanism. `KINEMATICS_BOTH` is recommended where independent joint-mode operation is needed.

Current homing documentation says a negative `HOME_SEQUENCE` synchronizes the *final homing move* of the joints in that sequence and disallows individual joint jogging for synchronized groups because doing so can cause gantry racking. This is initialization/squaring behavior. It is not documentation of continuous cross-joint geometry authentication during later coordinated motion.

Current INI documentation defines `FERROR`/`MIN_FERROR` around the difference between each joint's commanded and sensed position. It is therefore a joint tracking constraint inside the configured measurement chain, not a direct measurement of gantry squareness or another external mechanical degree of freedom.

The pinned upstream sample `configs/sim/axis/gantry/gantry_mm.ini` is a useful minimal fixture: it uses `trivkins coordinates=xyyz kinstype=BOTH`, four joints, and negative synchronized `HOME_SEQUENCE` values for the duplicated Y joints. Its HAL file loops each motor command directly to its corresponding motor feedback, so replacing only the duplicate-Y loopback with an offsettable realtime path preserves the real motion/kinematics stack while creating a controlled asymmetric observation.

## Pinned-source findings

### 1. Inverse kinematics duplicates one coordinate command to every mapped joint

At the pinned revision, `trivkins.c` enables duplicate coordinate mappings (`allow_duplicates = 1`) and delegates to `identityKinematicsInverse()`/`identityKinematicsForward()`.

`kins_util.c::position_to_mapped_joints()` writes the same Cartesian coordinate value to every joint bit mapped to that axis. For a duplicated Y mapping, both Y joints therefore receive the same kinematic joint target before their independent downstream tracking/drive paths.

### 2. Forward kinematics does not average or cross-check duplicated joint feedback

This is the critical 2000-level observation. `map_coordinates_to_jnumbers()` records the **first mapped joint** as the principal joint for each coordinate. `mapped_joints_to_position()` then writes the Cartesian coordinate from that principal joint (`joints[JY]`, etc.). It does not average duplicate joint feedback and does not reject disagreement between the duplicate joints.

Therefore, for ordinary duplicated-coordinate `trivkins` at this pinned revision:

```text
Cartesian Y feedback == principal Y joint's mapped feedback
```

is compatible with a second Y joint disagreeing. A plausible Cartesian display is not, by itself, evidence that the two-joint mechanism is square or mutually aligned.

### 3. Motion retains separate per-joint command and feedback states

Pinned `control.c` documents the motion data chain separately: Cartesian command -> inverse kinematics -> per-joint command -> motor command; encoder/feedback -> per-joint feedback -> forward kinematics -> Cartesian feedback. Per-joint following error is checked as a joint fault and can disable motion.

This means the evidence surfaces must not be collapsed:

- one coordinate command can intentionally fan out to several joints;
- each joint still has its own command, feedback, fault and following-error state;
- Cartesian feedback is a kinematics result, not an independent geometry sensor.

### 4. Servo-cycle update order is now pinned

The D01 call-flow trace now establishes the relevant `control.c` sequence:

1. `process_inputs()` reads joint feedback and calculates each joint's following error and velocity-dependent limit;
2. `do_forward_kins()` publishes Cartesian feedback from the current joint feedback set;
3. `process_probe_inputs()` runs;
4. `check_for_faults()` evaluates per-joint fault flags and may clear the internal enabling state;
5. `set_operating_mode()` and later controller work follow.

The following-error comparison is strict (`abs(ferror) > ferror_limit`). This ordering makes a same-cycle hidden-divergence observation technically meaningful: Cartesian feedback may already have been projected from the principal joint before the duplicate-joint following-error consequence revokes global motion.

## Community evidence boundary

Community reports reinforce two practical hazards without upgrading them to universal proof. Gantry troubleshooting repeatedly emphasizes independent home-switch/joint observations when racking occurs, and a reported XYYZ servo failure showed that the joint named by an amplifier/following problem need not be the root physical cause—the coupled partner can force the observed joint into trouble. Another tandem-Y report describes inability to reset cleanly while the two DRO/joint positions remain offset after a following-error halt.

These are practitioner observations that motivate independent per-joint diagnostics and skepticism about single-symptom root-cause claims. They are not safety-certification evidence and do not establish a universal recovery sequence.

## Four truth layers for D01

1. **Command-space intent:** requested Cartesian coordinate/trajectory.
2. **Per-joint control truth:** each joint's command, sensed feedback, following error, fault and enable state.
3. **Mechanical geometry truth:** actual relative pose/squareness/twist/load sharing of the coupled mechanism.
4. **Independent safety/physical truth:** separately engineered sensing, safety system, drive/actuator state and verified stopping/restart conditions.

Layer 1 cannot authenticate Layer 2. Agreement within Layer 2 does not automatically authenticate Layer 3 if the sensors/mechanical couplings share a common-mode failure. Layer 3 software estimation is not Layer 4 safety authority.

## Initial hypotheses

These remain hypotheses until the D01 experiment/evaluation chain is complete.

- **H1:** A duplicated-coordinate world command can remain internally coherent while one joint's measured response diverges.
- **H2:** The principal-joint forward-kinematics rule can keep reported Cartesian feedback plausible while a duplicate joint disagrees.
- **H3:** Per-joint following-error monitoring can detect sufficiently large modeled command-vs-feedback divergence, but it cannot prove unmeasured mechanical squareness.
- **H4:** Synchronized homing establishes a configured reference relationship at homing; it is not continuous proof that the relationship remains physically valid afterward.
- **H5:** Loss of one member's tracking/actuator authority should be treated as loss of authority for the coupled operation in the D01 control architecture; clearing the local fault must not silently confer fresh cycle authorization.

H5 is an architecture requirement to adversarially test, not a claim that LinuxCNC automatically implements every machine-specific coupled-fault policy.

## Experiment freeze

The runtime experiment is now frozen in `results/D01-002-frozen-runtime-experiment.md` before implementation. It uses P0–P8 and unchanged Gates A–J. The discriminating case is a duplicate-only feedback offset below the ferror threshold: both Y joint commands remain duplicated, Cartesian Y remains principal-looking, the duplicate feedback is measurably wrong, and motion remains enabled. A later above-threshold offset must produce duplicate-only ferror and bounded global disable.

A non-authoritative preflight is required before any authoritative scoring. `lab-jobs/012-d01-duplicated-feedback-preflight.sh` is the first such fixture-validation run; it intentionally does not score Gates A–J.

## Remaining instrumentation question

The principal unresolved implementation detail is how to retain **Cartesian feedback in the same realtime atomic stream** as joint command/feedback/ferror. The core `emcmotStatus->carte_pos_fb` value is not exposed as an ordinary realtime HAL pin in the same way as the joint quantities. Using asynchronous HALUI/NML display feedback would violate the frozen atomic-ordering requirement.

Therefore the authoritative harness must either:

1. add a minimal, retained, test-only observer export at the exact pinned forward-kinematics publication point, with source diff and perturbation limitations documented; or
2. identify an existing realtime production surface that exposes the same value without changing motion source.

The preflight may validate the real duplicated-joint plant and ferror thresholds before this observer is added, but the authoritative run is blocked until the atomic Cartesian observation problem is solved explicitly.

## Adversarial claims the module must reject

1. `same Cartesian command -> same actual joint position`.
2. `Cartesian feedback looks right -> duplicate joints agree`.
3. `both encoders agree -> physical geometry is independently authenticated`.
4. `synchronized homing -> continuous squareness guarantee`.
5. `fault cleared -> coupled mechanism may automatically resume`.
6. `following-error trip -> complete diagnosis of the physical cause`.
7. `simulation passed -> physical actuator authority/stopping/safety proven`.

## Promotion boundary

D01 may graduate in software only for LinuxCNC/control-model semantics demonstrated by the pinned source and reproducible simulated plant. Real coupled mechanics, structural compliance, hydraulic/servo authority, sensor mounting integrity, stopping performance and functional-safety conclusions require separate physical/human evidence.