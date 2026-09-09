# D01 call flow — duplicated coordinate command versus joint feedback

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Coordinated command path

```text
trajectory / Cartesian pose command
        |
        v
motion Cartesian command (carte_pos_cmd)
        |
        v
kinematicsInverse()
        |
        v
trivkins -> identityKinematicsInverse()
        |
        v
position_to_mapped_joints()
        |
        +--> principal Y joint pos target
        |
        `--> duplicate Y joint pos target
                 (same Cartesian Y value is copied to every Y-mapped joint)
        |
        v
per-joint interpolation / compensation / motor position command
        |
        v
independent downstream plant/drive paths
```

A common coordinate target is therefore **command fan-out**, not measured agreement.

## Feedback path

```text
independent feedback devices / modeled feedback
        |
        v
per-joint motor_pos_fb
        |
        v
per-joint pos_fb
        |
        +--> per-joint ferror = pos_cmd - pos_fb
        |        |
        |        `--> excessive ferror -> joint error -> enabling revoked
        |
        v
kinematicsForward(joint pos_fb array)
        |
        v
trivkins -> identityKinematicsForward()
        |
        v
mapped_joints_to_position()
        |
        v
Cartesian feedback uses the principal (first-mapped) joint for each duplicated axis
```

At the pinned revision, `map_coordinates_to_jnumbers()` creates both a duplicate-joint bitmap and a principal joint number for each coordinate. `position_to_mapped_joints()` uses the bitmap so inverse kinematics writes the coordinate to every duplicate. `mapped_joints_to_position()` uses the principal joint number, so forward kinematics does **not** average or compare the duplicates.

## Diagnostic consequence

For a duplicated Y coordinate with joints J1 and J2, it is possible in principle for:

```text
J1 command = 10
J2 command = 10
J1 feedback = 10
J2 feedback = 9
reported Cartesian Y feedback = 10    # if J1 is principal
```

while J2's own following error exposes the disagreement. The numeric example is illustrative; D01 must reproduce the qualitative behavior using LinuxCNC's real pinned kinematics and motion objects before treating it as experiment-confirmed.

## Fault path

Pinned `control.c::check_for_faults()` checks each active/enabled joint. A following-error flag on a joint sets that joint's error flag and clears the motion enabling path. This is an important containment mechanism, but its evidence means **that joint exceeded its configured command-vs-feedback threshold**. It does not identify whether the physical cause was drive loss, mechanical binding, sensor error, structural deformation, or another failure.

## Homing boundary

Negative `HOME_SEQUENCE` synchronizes the final homing move for the configured joint group. Treat that as reference-establishment sequencing. Runtime feedback/fault monitoring remains a separate path; homed state alone is not a continuous relative-geometry measurement.

## Evidence required for D01

A valid D01 trace should retain, atomically where causal ordering matters:

- phase/event marker;
- Cartesian command and Cartesian feedback;
- both duplicated joints' `pos_cmd` and `pos_fb`;
- both joints' current ferror and ferror/error state;
- motion enable/achieved state;
- modeled plant authority/lag injection controls;
- explicit restart authorization state;
- sampler producer overrun/retention evidence.

The experiment must label Cartesian feedback as a kinematics-derived quantity, never as an independently measured crossbeam/squareness sensor.