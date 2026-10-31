# 4000-LC-MILLTURN-44 — Real upstream mill/turn switch: coordinate permutation, sign, limits, and fixture offsets

**2026-10-31 | 4000 LinuxCNC implementation / 3100 mill + 3200 lathe transfer | NON-GRADUATED | static source inspection only.**

## Distinct question
How can a single set of four joint positions represent different XYZ machine coordinates when a mill/turn switches modes, and how do its remapped M-codes preserve the correct limit and work-offset context? This goes beyond [KINS-43](4400_LINUXCNC_KINS_43_PUMA560_M128_LIMIT_AND_DEVELOPMENT_PANEL_ROUTE_SOURCE_AUDIT_2026-10-31.md)'s Puma panel defect: the **millturn** example has a properly integrated G12.1 remap with a distinct limit/fixture sequence, but inherits a related velocity-pin typo.

## Immutable upstream provenance
Development commit [`537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`](https://github.com/LinuxCNC/linuxcnc/commit/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1):
- [`src/hal/components/millturn.comp`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/hal/components/millturn.comp), blob `aeee6b3b76f7b0935e3b165f80aea97820876db2`: `turn_forward`, `turn_inverse`, `turn_jacobian`, `switchkinsSetup`.
- [`millturn.ini`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/millturn/millturn.ini), blob `575947d9dcef47c673c17b5c080e1edea70fb945`: [KINS], [TRAJ], [AXIS], [JOINT], remaps and HALUI.
- [`428remap.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/millturn/remap_subs/428remap.ngc), blob `63a2d118a6d1d78be69c4f2b0f5ad1efe84f3090`; [`429remap.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/millturn/remap_subs/429remap.ngc), blob `7be809a0d3e38b475387ac24681caaf7732dce6f`.
- [M128](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/millturn/mcodes/M128), blob `539c00672b55692a3db982afe9c94cde73d5ee88`; [M129](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/millturn/mcodes/M129), blob `58d82707963188adb65e748a3b20df8d92389492`; [post-GUI HAL](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/millturn/millturn-postgui.hal), blob `359c33666d43bb7212de34530238c0452f6360d9`.
- Stable comparison: [v2.9.10 millturn.comp](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/millturn.comp), blob `55f51996c78de66bc39673b11ad2c8fd89692f48`; [stable INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/millturn/millturn.ini), blob `9a9bb5f7f0bb346fbe74bb6cb15535a1e9f0fecb`; [stable M428](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/vismach/millturn/remap_subs/428remap.ngc), blob `ca6225fb42155ac75d385d276c8fd3cd777f02f3`.
- Upstream [millturn.txt](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/vismach/millturn/millturn.txt), blob `29b9960d6e46b7944ab143c274ad646bd68f76c5`, documents intended mode mapping.

## Source-confirmed kinematic mapping
The four joints are three linear positions and one angular position. Type 0 is identity mill mode; type 1 is the turn transform. The transform and inverse are exact sign/permutation operations, not an iterative IK solver:

| Quantity | Type 0 mill | Type 1 turn |
|---|---|---|
| machine X | joint 0 | joint 2 |
| machine Y | joint 1 | **negative** joint 1 |
| machine Z | joint 2 | joint 0 |
| machine A | joint 3 | joint 3 |

The development `turn_jacobian` explicitly maps inverse X→joint2 +1, Y→joint1 -1, Z→joint0 +1, A→joint3 +1. A concrete **calculated discriminator, not a runtime observation**: for joint vector (100, 20, -30, 10), the mill machine pose is (100, 20, -30, 10), while turn machine pose is (-30, -20, 100, 10). A correct mode switch need not move any joint, but its **machine-coordinate readout changes**. This is not evidence that work coordinates, tool offsets, or fixtures are continuous.

## Remap / limit / offset transaction
- The development panel connects `pyvcp.mill-button`→`halui.mdi-command-00` (M428) and `turn-button`→`mdi-command-01` (M429). Unlike the Puma560 panel in KINS-43, these buttons call the **new remaps**, not the limits-only scripts.
- M428 does `G12.1 P0` → external M128 → `G10 L2 P7 X-290 Y0 Z-160 A0` → `G59.1` → `M66 E0 L0` → `#<_kins_type>` check. M429 does `G12.1 P1` → M129 → `G10 L2 P8 X-160 Y0 Z-290 A0` → `G59.2` → M66 → check. Thus the intended transaction is **select transform, change axis limits, select the corresponding fixture offset, synchronize, verify**. G12.1 and M66 are separate synchronization boundaries; G10/G59 changes are not an automatic physical calibration.
- M128/M129 explicitly check `kinstype.is-0/1` and write `ini.x/y/z.min_limit/max_limit` from the mode-specific INI values. In the example, mill X limits [-300,300], Z [-240,0]; turn X [-240,0], Z [-300,300]. The Y limits remain [-100,100]. All axis MAX_VELOCITY and joint MAX_VELOCITY values are 60 in this stock INI.
- Both scripts **also** attempt `ini.$l.min_velocity` with a `MAX_VELOCITY` value under Tcl `catch`, even though the actual INI-HAL pin is `ini.$l.max_velocity` (KINS-43, corroborated against both stable/development `inihal.cc`). This is a source-confirmed pin-name error but the equal stock maxima prevent a demonstrated numeric mismatch in this example. The valid min/max-limit writes can still work independently; a silent failure of one command must not be generalized to all writes.
- Stable v2.9.10 uses `M68 E3` plus a `motion.analog-out-03`→`motion.switchkins-type` net; development removes that net and uses G12.1 directly. The source-supported **development millturn** migration is more internally coherent than the Puma560 panel migration, despite sharing the M128 typo.

## Failure/acceptance boundaries
1. A change in displayed X/Z/Y sign at fixed joint feedback is **expected** under this transform. Do not diagnose a mechanical jump solely from a coordinate change.
2. A toolpath generated for mill mode must not be executed in turn mode, even when the XYZ words appear in range; joint assignments differ. A postprocessor or ROS bridge must carry an explicit active-kinematics mode and fixture/tool-offset contract.
3. The module description calls A a spindle in turn mode, but the inspected kinematics code merely maps A to joint3; it does **not** establish spindle-drive, encoder synchronization, tool turret, or safe machine switching hardware. Those require separate HAL/Task/physical evidence.
4. M128/M129 have mode checks and Tcl `catch` around individual writes. Their printed success/exit does not by itself prove all limits were accepted. Verify `ini.L.min_limit/max_limit/max_velocity` and the actual active type, not just the remap's final `#<_kins_type>` comparison.
5. The remaps set fixed G59.1/G59.2 offsets; their numbers are **example fixtures**, not proof that the two coordinate systems coincide at the current tool tip.

## Frozen disconnected acceptance (NOT EXECUTED)
Use the pinned development `millturn.ini` with no real I/O. At a fixed joint vector (100,20,-30,10), compare joint feedback, machine-coordinate pose, active type, axis soft limits, selected G59.1/G59.2, and Task errors across M428/M429. The expected raw machine poses are above; **do not** compare work-coordinate display to raw machine pose without first subtracting the appropriate fixture/tool offsets. Repeat at a second vector with nonzero Y to expose the sign reversal. For a separate simulation-only variant, set different mill/turn axis MAX_VELOCITY values and verify that the Tcl `min_velocity` typo prevents their intended restoration. Preserve exact INI/HAL/NGC/Tcl, status, pin snapshots and timestamps. Only qualified `[self-hosted, openpressbrake]` isolated execution; no hosted runner or physical machine.

## Evidence
SOURCE-CONFIRMED transformations, remap order, mode-specific limits and wrong pin name; DOC-CONFIRMED intended upstream mapping; INFERENCE for runtime failure effects; TEST-CONFIRMED none. Existing 3000 levels stay graduated; this is a 4000 implementation transfer, not a reopening of the lathe/mill course. Independent personnel-safety authority unchanged.
