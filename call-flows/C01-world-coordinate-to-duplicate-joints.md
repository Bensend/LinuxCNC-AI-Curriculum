# C01 call flow — world coordinate to duplicated joints

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Trace the behavior C01 relies on: one coordinated world-axis position is transformed into two distinct joint positions when `trivkins` is configured with a duplicated coordinate letter.

Representative mapping:

```text
coordinates=XYZY
joint 0 -> X
joint 1 -> Y
joint 2 -> Z
joint 3 -> Y
```

## Setup path

```text
trivkins rtapi_app_main()
  -> ksetup.allow_duplicates = 1
  -> identityKinematicsSetup(..., coordinates, ...)
      -> map_coordinates_to_jnumbers()
          -> axis_idx_for_jno[joint] assignment
          -> coordinate-specific joint bitmaps
          -> principal/first joint selection for forward kinematics
```

For `XYZY`, `Y_joints_bitmap` contains joint 1 and joint 3 while `JY` is joint 1, the first Y-mapped joint.

## Coordinated world-to-joint path

The motion/kinematics layer calls the configured inverse-kinematics function with a requested `EmcPose`.

```text
trivkins::kinematicsInverse(pos, joints, ...)
  -> identityKinematicsInverse(pos, joints, ...)
      -> position_to_mapped_joints(identity_max_joints, pos, joints)
          -> for each mapped joint number
              if joint bit is in Y_joints_bitmap:
                  joints[jno] = pos->tran.y
```

Therefore one Y world-coordinate value is copied into both `joints[1]` and `joints[3]` for `XYZY`.

The corresponding motion subsystem then exposes each joint through its own joint HAL interface, including separate `joint.1.motor-pos-cmd` and `joint.3.motor-pos-cmd` endpoints.

## Upstream simulation boundary

Pinned `lib/hallib/gantrysim.hal` connects each joint command to its own feedback endpoint:

```text
joint.1.motor-pos-cmd -> joint.1.motor-pos-fb
joint.3.motor-pos-cmd -> joint.3.motor-pos-fb
```

This makes the topology executable and independently observable per joint, but each plant is a zero-dynamics loopback. Equal feedback in this fixture is a property of the fixture wiring, not evidence that two real actuators would remain aligned.

## Forward/world-position path and important asymmetry

```text
trivkins::kinematicsForward(joints, pos, ...)
  -> identityKinematicsForward(...)
      -> mapped_joints_to_position(...)
```

For duplicated coordinates, the mapping retains a principal/first joint. `mapped_joints_to_position()` assigns the world coordinate from that principal joint rather than averaging or checking all duplicated joints. With `XYZY`, Y world position is sourced from `joints[JY]`, where `JY` is joint 1.

Consequences:

- duplicate-coordinate inverse kinematics provides command fan-out;
- duplicate-coordinate forward kinematics is **not** a disagreement detector;
- a world-coordinate display can therefore be insufficient evidence about the second joint's physical position;
- explicit per-joint feedback/disagreement logic belongs in later capstone modules.

## Failure branches

`map_coordinates_to_jnumbers()` can reject:

- an invalid coordinate character;
- too many coordinate characters for the supported joint count;
- duplicate coordinates when `allow_duplicates == 0`;
- a changed coordinate string when shared mapping state has already been initialized incompatibly.

`identityKinematicsInverse()` / `Forward()` reject use before successful identity-kinematics initialization.

## Evidence boundary

SOURCE-CONFIRMED at the pinned revision:

```text
world Y command -> inverse kinematics -> joint 1 Y command + joint 3 Y command
```

Not established by this call flow:

```text
joint 1 physical position == joint 3 physical position
closed-loop synchronization
fault tolerance
functional safety
```

C01-023 will independently verify the command fan-out and separate joint observability at runtime before this call flow is treated as TEST-CONFIRMED.
