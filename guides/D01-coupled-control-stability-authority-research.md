# D01 — coupled-control stability and tandem-joint authority

Status: **RESEARCH / SOURCE**

Pinned LinuxCNC revision for source-grounded 1000→2000 continuity: `8bf4605ae81042248add031e94c77300406e0413`.

## Question

When one Cartesian coordinate is mapped to multiple LinuxCNC joints, what is actually guaranteed by kinematics, homing, joint following-error checks and reported Cartesian feedback—and what remains an unproven property of the mechanics, sensors and actuator authority?

## Documentation findings

Current LinuxCNC `kins(9)` explicitly supports duplicated coordinate letters in `trivkins`; e.g. `coordinates=xyyzw kinstype=B` maps one Y coordinate to two joints. The documentation identifies this as a gantry pattern and warns that moving one joint alone can rack the mechanism. `KINEMATICS_BOTH` is recommended where independent joint-mode operation is needed.

Current homing documentation says a negative `HOME_SEQUENCE` synchronizes the *final homing move* of the joints in that sequence and disallows individual joint jogging for synchronized groups because doing so can cause gantry racking. This is initialization/squaring behavior. It is not documentation of continuous cross-joint geometry authentication during later coordinated motion.

Current INI documentation defines `FERROR`/`MIN_FERROR` around the difference between each joint's commanded and sensed position. It is therefore a joint tracking constraint inside the configured measurement chain, not a direct measurement of gantry squareness or another external mechanical degree of freedom.

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

## Community evidence boundary

LinuxCNC community gantry guidance consistently uses duplicated joints plus synchronized homing and warns about racking/independent jogging. Treat this as practitioner evidence about configuration hazards and useful tests, not as proof of a universal physical-machine recovery rule.

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

## Required experiment shape — not yet frozen

A bounded software plant should expose at least:

- one Cartesian coordinate mapped to two joints;
- independent per-joint feedback paths;
- asymmetric lag/authority/saturation controls;
- per-joint following error and fault state;
- Cartesian feedback from the real kinematics path;
- explicit authorization/restart state;
- one atomic realtime trace with recorder-validity evidence.

The experiment must include a case where the principal joint tracks while the duplicate joint is deliberately made to lag or lose authority. The decisive question is whether a coarse Cartesian observation could look acceptable while per-joint evidence reveals disagreement.

## Adversarial claims the module must reject

1. `same Cartesian command -> same actual joint position`.
2. `Cartesian feedback looks right -> duplicate joints agree`.
3. `both encoders agree -> physical geometry is independently authenticated`.
4. `synchronized homing -> continuous squareness guarantee`.
5. `fault cleared -> coupled mechanism may automatically resume`.
6. `following-error trip -> complete diagnosis of the physical cause`.
7. `simulation passed -> physical actuator authority/stopping/safety proven`.

## Open questions before experiment freeze

- Exact pinned-source update order from kinematic joint command generation through per-joint ferror calculation and motion disable.
- Whether the existing simulated dual-actuator fixture can use real `trivkins coordinates=XYY...` without obscuring the deliberately asymmetric plant.
- How to expose a principal-joint-versus-duplicate-joint disagreement without fabricating a Cartesian measurement unavailable in production LinuxCNC.
- Minimum extra diagnostic quantity needed to express measured cross-joint disagreement without incorrectly calling it independent physical squareness.
- Which fault/recovery behaviors belong to D01 versus later F02 compound-fault sequencing.

## Promotion boundary

D01 may graduate in software only for LinuxCNC/control-model semantics demonstrated by the pinned source and reproducible simulated plant. Real coupled mechanics, structural compliance, hydraulic/servo authority, sensor mounting integrity, stopping performance and functional-safety conclusions require separate physical/human evidence.