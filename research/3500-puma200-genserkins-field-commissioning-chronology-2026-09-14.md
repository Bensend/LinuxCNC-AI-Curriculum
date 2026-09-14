# 3500 — PUMA 200 genserkins field commissioning chronology

Date: 2026-09-14
Status: COMMUNITY / real-hardware field chronology

## Why this case matters

A July–August 2026 LinuxCNC forum thread documents a real Unimation PUMA 200 conversion progressing from working joints/brakes/encoders through failed world-coordinate motion to a substantially corrected genserkins configuration. It is useful because the failures were not one abstract "IK problem": several independent model, homing, gearing, coupling, and singularity assumptions were discovered in sequence.

Source: LinuxCNC Forum, `PUMA 200 Robotarm and some Hal/INI issues`, created 2026-07-30 and continued through at least 2026-08-14.

## Preserved chronology

### 1. Joint layer initially looked healthy

The owner reported all joints, brakes and encoders working and had checked gear/encoder ratios and physical angles. Joint mode appeared usable. After switching to genserkins, however, world-mode X/Y motion curved unexpectedly, the wrist could move violently, limits/kinematic errors appeared, and the TCP orientation looked wrong.

This is the first curriculum lesson from the case:

> correct-looking individual joint motion does not validate the robot's Cartesian model.

### 2. Singularity and model errors were initially entangled

Community review identified a wrist singularity risk when wrist axes became collinear. The important field warning was that a simulation can rapidly change wrist orientation near a singular pose, while doing the same on real hardware can trigger following errors before inverse kinematics fails.

The operator also learned that the post-home pose itself could be singular. The recommended practice was to use HOME/HOME_OFFSET to move away from a singular configuration before switching to world/genserkins mode.

But singularity was not the only issue. Curved Cartesian paths remained evidence that the DH model/home reference was still wrong.

### 3. Home pose is part of the kinematic contract

The strongest troubleshooting method in the thread was deliberately simple:

1. establish a chosen physical zero/home pose;
2. remove coordinate offsets;
3. verify simple joint poses in identity/joint mode;
4. derive/check modified DH parameters against that exact physical pose;
5. calculate expected XYZ for simple 0/90/180-degree poses on paper;
6. compare those expected positions to LinuxCNC world-coordinate results before running arbitrary programs.

The reviewer emphasized that the physical robot at all-zero joint coordinates must match the pose assumed when deriving the DH parameter chain. A correct-looking GUI or Vismach picture is not a substitute for that geometry check.

### 4. Rotation sign is model-relative, not a generic motor convention

The thread explicitly corrected the idea that every PUMA has one universal list of positive motor directions. Positive joint rotation must agree with the coordinate-frame/DH model used for that machine. Motor/encoder scale signs can be negative if that is what makes the physical joint's positive rotation agree with the modeled positive rotation.

Therefore commissioning must validate the complete relationship:

`physical joint positive direction <-> encoder sign <-> actuator sign <-> DH frame convention`

rather than enforcing arbitrary sign uniformity.

### 5. Mechanical coupling was a separate layer

The owner reported wrist-axis mechanical cross-coupling and later stated that A->B, A->C and B->C coupling had been compensated/eliminated. That work was distinct from correcting genserkins geometry.

This supports a reusable robot commissioning separation:

`motor/encoder transmission mapping -> independent logical joint coordinates -> forward/inverse kinematics`

If mechanical coupling is left in the joint coordinates, a mathematically correct Cartesian model can still receive the wrong logical joint state.

### 6. Documentation provenance failed

A major later discovery was that provided gear-ratio information corresponded to a different PUMA 2xx variant. The owner physically opened gear trains and counted teeth, discovering that the machine had different gearing. He then refined ratios by direct physical measurement, encoder index observations, inclinometers and additional output-shaft measurement.

This is high-value field evidence for legacy-robot retrofits:

> model/serial-family documentation is hypothesis input, not physical-machine truth. Verify transmission ratios on the actual mechanism before trusting Cartesian calibration.

### 7. Corrected modified-DH reasoning materially fixed motion

The community eventually rebuilt the modified-DH chain from the physical drawings and identified incorrect rotations/signs/offset interpretation. On 2026-08-09 the owner reported, for the first time, that the moves were correct and explicitly attributed the earlier failure to incorrect X-axis frame rotations and associated D/sign choices.

By 2026-08-14 the owner reported adjusted backlash, corrected joint scales, world-mode X/Y/Z motion looking good and planned dial-indicator and drawing tests.

This is not a formal accuracy qualification; the thread had not yet demonstrated a metrology-grade Cartesian error map or production acceptance. It is nevertheless a real commissioning progression from broken world mode to apparently correct world-coordinate motion.

## Architecture / playbook promotion

For 6-axis serial robot commissioning, teach the following validation order:

1. **Actuator/feedback identity** — each motor and encoder channel is correct.
2. **Transmission truth** — verify actual ratio, sign, backlash and any coupled wrist transmission on the physical machine.
3. **Logical joint coordinates** — compensate transmission coupling before kinematics.
4. **Physical zero/home reference** — make the zero pose explicit and reproducible.
5. **Kinematic model** — derive DH/modified-DH parameters from that exact zero pose.
6. **Simple-pose forward checks** — hand-calculate easy poses and compare to world DRO.
7. **Singularity-aware inverse checks** — validate Cartesian jogging away from known singular poses before arbitrary programs.
8. **Only then** proceed to path accuracy, load/tool calibration, repeatability and production testing.

A Vismach model is a visualization/verifier, not an independent truth source; a wrong model can reinforce a wrong kinematic assumption.

## Adversarial boundary review

1. Does a working joint mode prove correct Cartesian kinematics? **No; the case directly disproves it.**
2. Was singularity the sole failure? **No; wrong DH frame choices, home geometry, coupling and gearing also mattered.**
3. Can generic PUMA-family gear ratios be trusted? **No; this physical machine differed from supplied family data.**
4. Does a negative encoder/PWM scale automatically mean an error? **No; sign must agree with the chosen modeled positive joint direction.**
5. Can HOME/HOME_OFFSET be treated as cosmetic? **No; the home pose must agree with the kinematic model and may need to avoid singularity before world mode.**
6. Does the final forum state prove production accuracy? **No; planned dial/drawing checks were still forthcoming.**
7. Does this case establish generic genserkins singularity-avoidance algorithms? **No; it provides field commissioning evidence and failure modes, not a new solver algorithm.**

Adversarial result: **7/7 bounded claims survive.**

## Next evidence target

The field case makes further toy IK experiments low value. Higher-value 3500 work is now:

- inspect a second real robot conversion with available HAL/INI/source to compare brake, home, coupled-joint and fault authority;
- preserve exact genserkins failure/iteration semantics from source separately from field symptoms;
- later build a commissioning playbook that separates geometry validation, singularity handling, transmission calibration and functional-safety authority.
