# C01 — Simulated dual-actuator machine research guide

## Identity

- Module: C01
- Course level: 1000
- Status: SOURCE / pre-experiment
- LinuxCNC source revision: `8bf4605ae81042248add031e94c77300406e0413`
- Objective: establish a reproducible LinuxCNC simulation topology in which one world coordinate commands two distinct joints while preserving separate joint command, feedback, enable, and fault interfaces for later independent-loop and synchronization experiments.

## Why duplicated-coordinate `trivkins` is the C01 baseline

LinuxCNC already contains the mechanism needed for a generic dual-actuator machine. Current official kinematics documentation allows a coordinate letter to appear more than once in `trivkins coordinates=...`; the duplicated coordinate maps one world coordinate to multiple joints. `kinstype=BOTH` is recommended where the duplicated joints must also be independently addressable in joint mode.

The older `gantry` HAL component is deprecated in favor of this generalized `trivkins` mechanism. C01 therefore does not invent a private machine model or use a legacy fan-out component.

Relevant current documentation:

- https://www.linuxcnc.org/docs/html/man/man9/kins.9.html
- https://www.linuxcnc.org/docs/html/motion/kinematics.html
- https://www.linuxcnc.org/docs/master/html/en/man/man9/gantry.9.html

## Community pass

LinuxCNC forum guidance from experienced contributors repeatedly points dual-motor gantries to duplicated-coordinate `trivkins` configurations and the upstream gantry simulation. Field discussions also reinforce an important later-capstone distinction: two joints sharing one coordinate can still require separate tuning, feedback, fault handling, and homing treatment. Community reports are leads; the C01 architecture below is established from pinned source and upstream examples rather than forum authority.

Examples retained for investigation context:

- https://forum.linuxcnc.org/49-basic-configuration/34259-command-to-home-y-axis
- practical dual-joint gantry discussions linked from current forum search results; use only as COMMUNITY-REPORTED evidence unless reconciled.

## Pinned source inventory

| Path | Symbols / data | C01 significance |
|---|---|---|
| `src/emc/kinematics/trivkins.c` | `rtapi_app_main`, `kinematicsInverse`, `kinematicsForward` | Enables duplicate coordinates with `ksetup.allow_duplicates = 1`; delegates to identity mapping utilities. |
| `src/emc/kinematics/kins_util.c` | `map_coordinates_to_jnumbers`, `position_to_mapped_joints`, `mapped_joints_to_position`, `identityKinematicsInverse`, `identityKinematicsForward` | Builds duplicate-joint bitmaps and fans a coordinate value to every mapped joint on inverse kinematics. |
| `configs/sim/axis/gantry/gantry.ini` | `[KINS]`, duplicated `Y`, four joints | Pinned upstream executable example: `trivkins coordinates=XYZY kinstype=BOTH`; Y is joint 1 and joint 3. |
| `lib/hallib/gantrysim.hal` | distinct `joint.N.motor-pos-cmd` / `motor-pos-fb` nets | Demonstrates that duplicated-coordinate joints retain distinct HAL interfaces even though the upstream simulation loops each command directly to its own feedback. |

## Source mechanism

### Configuration-to-mapping path

Pinned `trivkins.c` sets:

```text
ksetup.max_joints       = EMCMOT_MAX_JOINTS
ksetup.allow_duplicates = 1
identityKinematicsSetup(comp_id, coordinates, &ksetup)
```

`identityKinematicsSetup()` calls `map_coordinates_to_jnumbers()`. The mapper walks the coordinate string sequentially and records an axis index for each joint number. When duplicates are allowed it does not reject repeated letters; instead it builds a bitmap containing every joint assigned to each coordinate.

For an `XYZY` mapping the relevant logical result is:

```text
X -> joint 0
Y -> joint 1 and joint 3
Z -> joint 2
```

### World coordinate to duplicate joint commands

`trivkins::kinematicsInverse()` calls `identityKinematicsInverse()`, which calls `position_to_mapped_joints()`.

For every joint number present in a coordinate's bitmap, `position_to_mapped_joints()` copies that world coordinate into the joint array. Thus both Y-mapped joints receive the same inverse-kinematics Y value in the same call. This is SOURCE-CONFIRMED at the pinned revision.

### Duplicate joints back to world position

Forward kinematics is intentionally asymmetric for duplicate coordinates. `mapped_joints_to_position()` uses the principal/first joint for a coordinate when producing the world pose. Therefore a duplicated-coordinate mapping does **not** by itself average or cross-check the two joint feedback positions. C01 must not teach “duplicate `trivkins` automatically synchronizes or validates two actuators.”

That distinction is foundational for later C02/C03: the coordinate fan-out establishes common command intent, while independent loop behavior, disagreement measurement, cross-coupling, and fault policy must be constructed explicitly.

## Pinned upstream simulation baseline

`configs/sim/axis/gantry/gantry.ini` uses:

```ini
[KINS]
JOINTS = 4
KINEMATICS = trivkins coordinates=XYZY kinstype=BOTH
```

and identifies Y as joint 1 plus joint 3. Its duplicated joints use matching negative `HOME_SEQUENCE` values for synchronized final homing movement.

`lib/hallib/gantrysim.hal` then preserves each joint as a separate HAL interface:

```text
joint.1.motor-pos-cmd -> joint.1.motor-pos-fb
joint.3.motor-pos-cmd -> joint.3.motor-pos-fb
```

The direct loopback is useful as an executable topology baseline but is deliberately too idealized to demonstrate two physical plants. In particular, equal command and feedback in this fixture cannot prove actuator synchronization, plant symmetry, fault rejection, hydraulic behavior, or safety.

## C01 responsibility boundary

C01 proves only the machine-control topology needed for the capstone:

```text
one world coordinate
  -> duplicated-coordinate inverse kinematics
  -> two distinct joint command channels
  -> two distinct simulated feedback channels
```

C01 does **not** yet add independent dynamic plants/PIDs (C02), cross-coupling (C03), asymmetric response (C04), feedback faults (C05), communication/watchdog faults (C06), sequencing policy (C07), or final diagnostics/handoff (C08/C09).

## Failure / invalid-configuration behavior worth retaining

`map_coordinates_to_jnumbers()` rejects invalid coordinate characters, excessive coordinate counts, changed coordinate strings across incompatible repeated setup, and duplicate letters when the kinematics module does not permit duplicates. `trivkins` explicitly opts into duplicate support.

A more subtle architecture failure is semantically valid but wrong ordering/mapping: using a one-to-one coordinate set for a two-actuator axis would fail to create two joint command channels, while using duplicated coordinates but treating the resulting world pose as proof of both physical positions would create a false observation model.

## Claims ledger

| Claim | Evidence | Class |
|---|---|---|
| `trivkins` allows duplicate coordinate letters | pinned `trivkins.c`, current kins docs | SOURCE-CONFIRMED / DOC-CONFIRMED |
| Inverse kinematics copies one duplicated coordinate to every mapped joint | pinned `kins_util.c::position_to_mapped_joints()` | SOURCE-CONFIRMED |
| Upstream `XYZY` gantry maps Y to joints 1 and 3 | pinned `gantry.ini` | SOURCE-CONFIRMED / upstream example |
| Duplicate joints retain separate motor command/feedback HAL endpoints | pinned `gantrysim.hal` | SOURCE-CONFIRMED / upstream example |
| The simple upstream loopback proves physical synchronization | specifically rejected | NOT ESTABLISHED |
| Software duplicated-coordinate control is safety-rated | specifically rejected | NOT ESTABLISHED |

## First experiment target

C01-023 should execute the pinned upstream-style duplicated-Y topology and directly observe a coordinated Y move. It must prove that joint 1 and joint 3 receive matching motion commands while remaining separately observable as joint interfaces, and it must explicitly preserve the limitation that command-feedback loopback is an ideal simulation rather than a physical synchronization oracle.
