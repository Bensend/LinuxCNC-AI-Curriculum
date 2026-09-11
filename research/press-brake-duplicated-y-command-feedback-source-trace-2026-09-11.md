# Press-brake duplicated-Y command/feedback source trace

Date: 2026-09-11

Status: **SOURCE-CONFIRMED at pinned LinuxCNC revision; 4600 preparation**

LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Purpose: close the source-level question of exactly what `trivkins coordinates=...YY...` duplicates in the command direction, and what Cartesian feedback means when two joints share one coordinate. This is a generic LinuxCNC software result, not a physical press-brake safety or tuning prescription.

## Source inventory

| Path | Symbol | Role |
|---|---|---|
| `src/emc/kinematics/trivkins.c` | `rtapi_app_main()` | Enables coordinate duplicates (`allow_duplicates=1`) and initializes identity mapping. |
| `src/emc/kinematics/trivkins.c` | `kinematicsInverse()` | Delegates Cartesian-to-joint conversion to `identityKinematicsInverse()`. |
| `src/emc/kinematics/trivkins.c` | `kinematicsForward()` | Delegates joint-to-Cartesian conversion to `identityKinematicsForward()`. |
| `src/emc/kinematics/kins_util.c` | `map_coordinates_to_jnumbers()` | Builds one principal joint number and a bitmap of all joints for each coordinate letter. |
| `src/emc/kinematics/kins_util.c` | `position_to_mapped_joints()` | Fans each Cartesian coordinate into every joint in that coordinate's bitmap. |
| `src/emc/kinematics/kins_util.c` | `mapped_joints_to_position()` | Maps joint feedback back to Cartesian using the principal joint for a coordinate. |
| `src/emc/motion/control.c` | coordinated-mode `kinematicsInverse()` path | Copies inverse-kinematic joint positions into each kinematic joint's commanded trajectory. |
| `src/emc/motion/control.c` | `process_inputs()` | Reads each joint's independent `motor-pos-fb`, derives `pos_fb`, and normally computes per-joint following error. |
| `src/emc/motion/control.c` | `do_forward_kins()` | Supplies kinematic-joint `pos_fb` values to forward kinematics for Cartesian feedback. |

## Mapping construction

`trivkins.c` explicitly sets:

```text
ksetup.allow_duplicates = 1
```

and calls `identityKinematicsSetup()`.

`map_coordinates_to_jnumbers()` walks the coordinate string sequentially. For each axis it records:

- a **principal joint**: the first joint listed for that coordinate letter;
- an axis-specific **joint bitmap** containing every joint mapped to that coordinate.

The source's own example for a duplicate coordinate is conceptually:

```text
coordinates=...Y....Y
principal JY = first Y joint
Y_joints_bitmap = first Y joint | second Y joint
```

Classification: **SOURCE-CONFIRMED**.

## Inverse path: common Cartesian Y fans out to both joints

`trivkins::kinematicsInverse()` delegates to `identityKinematicsInverse()`, which calls:

```text
position_to_mapped_joints(identity_max_joints, pos, joints)
```

Inside `position_to_mapped_joints()` the code loops over every mapped joint and, when that joint's bit is present in `Y_joints_bitmap`, assigns:

```text
joints[jno] = pos->tran.y
```

Therefore every duplicated Y joint receives the same nominal Cartesian Y value from inverse kinematics.

In coordinated mode, `control.c` then loops through `joint_num < NO_OF_KINS_JOINTS`, copies every resulting `positions[joint_num]` into that joint's cubic interpolation path, and ultimately produces a per-joint `joint->pos_cmd` / `motor-pos-cmd`.

### Call flow

```text
trajectory planner
  -> emcmotStatus->carte_pos_cmd
  -> kinematicsInverse()
  -> identityKinematicsInverse()
  -> position_to_mapped_joints()
  -> all bits in Y_joints_bitmap receive pos->tran.y
  -> control.c copies each positions[joint_num]
  -> per-joint cubic interpolation
  -> per-joint joint->pos_cmd
  -> per-joint joint.N.motor-pos-cmd
```

Classification: **SOURCE-CONFIRMED**.

## Feedback path: independent joint truth exists before forward kinematics

`control.c::process_inputs()` loops across active joints and independently reads:

```text
joint->motor_pos_fb = joint.N.motor-pos-fb
joint->pos_fb = motor_pos_fb - compensation/offset
```

For an ordinary kinematic joint (not a homed extra joint), it then computes:

```text
joint->ferror = joint->pos_cmd - joint->pos_fb
```

and compares absolute following error against the velocity-scaled/floored per-joint following-error limit.

Thus duplicated Y joints retain separate feedback and following-error state even though their nominal inverse-kinematic command is common.

Classification: **SOURCE-CONFIRMED**.

## Forward path: Cartesian Y uses the principal Y joint

This is the critical non-obvious result.

`do_forward_kins()` copies each kinematic joint's independent `pos_fb` into the local joint array, then `trivkins::kinematicsForward()` calls `identityKinematicsForward()`, which invokes `mapped_joints_to_position()`.

For each coordinate bitmap, `mapped_joints_to_position()` writes the Cartesian position from the coordinate's **principal joint**. For Y the assignment is effectively:

```text
pos->tran.y = joints[JY]
```

where `JY` was frozen during mapping as the **first Y joint listed**.

The loop encounters both Y bits, but each assignment still reads `joints[JY]`; it does not average the duplicate joints, compare them, select the worst case, or expose their difference through Cartesian Y.

### Consequence

For a duplicated-Y pair:

- inverse kinematics: **one Cartesian Y request -> both Y joint commands**;
- joint layer: **two independent feedback/ferror states remain available**;
- forward kinematics: **Cartesian Y -> principal/first Y joint feedback**.

Therefore Cartesian Y is not a beam-level/squareness witness. A second Y joint may disagree while Cartesian Y still follows the principal joint normally.

Classification: **SOURCE-CONFIRMED for the mapping behavior; INFERENCE for machine-domain consequence**.

## Adversarial implications for a tandem press

### Misleading premise 1

> “If the GUI's Y DRO matches the programmed Y, both rams must be synchronized.”

**Rejected.** With duplicate `trivkins` coordinates, the forward Cartesian Y result is sourced from the principal Y joint. The other duplicate joint's independent feedback must be observed separately to establish agreement.

### Misleading premise 2

> “Because both joints receive the same Y command, LinuxCNC automatically cross-couples them.”

**Rejected.** The source proves nominal command fanout, not differential correction. Each joint still has its own feedback/ferror state. Any active Y1/Y2 synchronization law must exist elsewhere and its authority/interaction with per-joint motion supervision must be explicit.

### Failure scenario

If Y1 remains on trajectory while Y2 develops a bounded but growing lag:

- Cartesian Y may remain apparently correct if Y1 is the principal mapped joint;
- `joint.Y2.f-error` and direct Y2 feedback still expose the disagreement;
- a dedicated `Y1-Y2` differential witness exposes squareness directly;
- if a controller hides or bypasses those independent witnesses, Cartesian correctness cannot recover the missing evidence.

This is why PB-PREP-001 samples `r1/r2`, independent `y1/y2`, both joint ferrors and both effective ferror limits in the same realtime record.

## Relationship to extra joints

The companion artifact `research/press-brake-motion-ownership-extra-joints-vs-duplicated-y-2026-09-11.md` establishes a separate distinction: after homing, an extra joint is outside coordinated kinematics, receives `motor-pos-cmd` from `posthome-cmd`, and ordinary motion following error is explicitly made irrelevant.

Together the source traces establish three different concepts that a 4600 press-brake design must not conflate:

1. **common command generation** — duplicate inverse kinematics can provide this;
2. **independent side truth/fault monitoring** — ordinary duplicated kinematic joints retain per-joint feedback/ferror;
3. **differential synchronization control** — neither common command fanout nor Cartesian feedback automatically supplies this.

## Claims ledger

| Claim | Classification | Source | Confidence |
|---|---|---|---|
| `trivkins` permits duplicate coordinate letters | SOURCE-CONFIRMED | `trivkins.c::rtapi_app_main`, `allow_duplicates=1` | High |
| All duplicated Y joints receive the same inverse-kinematic Cartesian Y command | SOURCE-CONFIRMED | `kins_util.c::position_to_mapped_joints` | High |
| Duplicate Y joints retain independent HAL feedback and ordinary per-joint ferror state | SOURCE-CONFIRMED | `control.c::process_inputs` | High |
| Cartesian Y feedback represents the principal/first Y joint rather than an average of all duplicate Y joints | SOURCE-CONFIRMED | `kins_util.c::map_coordinates_to_jnumbers`, `mapped_joints_to_position` | High |
| Cartesian Y alone proves Y1/Y2 beam squareness | FALSE / source-disproved | principal-joint forward mapping | High |
| Duplicate command fanout itself performs cross-coupled synchronization | FALSE / source-disproved | no differential law in mapping path | High |
| Duplicated Y is physically preferable for every press brake | UNKNOWN / not claimed | software source cannot decide hydraulic/safety architecture | — |

## Verification already available

PB-PREP-001's four-joint synthetic fixture uses `trivkins coordinates=XYZY kinstype=BOTH` and independently samples both Y joint command and feedback paths. Its P0/P1 work already demonstrated distinct Y-side feedback topology. The still-running 077 behavioral candidate is a separate architecture-comparison experiment and must be scored only under its frozen raw-evidence audit.

No new laboratory execution is required merely to prove the static fanout/principal-joint mechanism above; it is directly established by pinned source and already has independent duplicated-joint runtime context from earlier curriculum work.

## Next-work checkpoint

- Complete the independent 077 raw-artifact audit when that existing job finishes; do not launch a duplicate while it is running.
- Add the principal-joint Cartesian-feedback caveat to the eventual 4600 beam-control playbook and require direct Y1/Y2 witnesses for any synchronization claim.
- Continue community/config mining to compare designs that leave ram motion in motmod against designs that move one or both ram sides behind external `posthome-cmd`/custom-controller ownership.
- Before adopting either topology for a real press, separately establish hydraulic sequencing, valve failure behavior, machine-specific feedback validity, and the functional-safety boundary.
