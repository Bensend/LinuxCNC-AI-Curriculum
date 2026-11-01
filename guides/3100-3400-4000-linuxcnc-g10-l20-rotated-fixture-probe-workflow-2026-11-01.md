# 3100/3400/4000 — G10 L20 rotated fixture and probing/CAM handoff
**Practical LinuxCNC implementation walkthrough | 2026-11-01 | NON-GRADUATED | source-grounded; runtime NOT RUN**

Read the [pinned source/expected-output investigation](../research/4400_LINUXCNC_G10_128_L20_ROTATED_XY_COUPLING_AND_TWP_VERSION_SOURCE_TEST_AUDIT_2026-11-01.md) before applying this to a real machine. This is a configuration and interpreter exercise, **not** a machine commissioning authorization.

## Which command owns which datum?
`G10 L2 P1 X10 Y20 R45` sets the **stored unrotated G54 fixture origin** X10/Y20 and the XY rotation to 45°. `G10 L20 P1 X0` instead solves for the fixture origin that makes the **current physical point** read X0 in G54; it does not mean "set stored G54 X offset to zero." `P0` targets the currently selected G5x; `P2` targets G55 without selecting it. G91 does not make L20 incremental. A probing macro that assumes L20 is a relative-offset increment is incorrect.

### Source-derived rotation calculation
For a target fixture with XY rotation R, old displayed fixture coordinates `C=(cx,cy)`, old unrotated fixture offset `O`, and desired displayed coordinates `D=(dx,dy)`, the inspected L20 XY branch computes:

`O_new = O + Rot(R) * (C - D)`.

If only X is programmed, `dy=cy`. If only Y is programmed, `dx=cx`. With R45°, C=(0,0), O=(0,0), `G10 L20 P1 X-1` yields stored `O_new=(0.70710678,0.70710678)` **inches**. Displayed Y remains 0. The upstream canonical expected file contains `SET_G5X_OFFSET(1,0.7071,0.7071,...)`. **Do not treat this as a spurious Y-axis move**: it is an update to two offset parameters, not a commanded trajectory.

## Minimal disconnected exercise using existing upstream fixtures
Use pinned stable [test.ngc](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g10/g10-l20-while-active/test.ngc) and [expected](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g10/g10-l20-while-active/expected) rather than creating a redundant full test harness. The upstream fixture deliberately starts with G54/G20/R45 and an explicit G53 reference point, then tests X-only, Y-only and XY L20. Inspect these expected canonical milestones: (a) `0.7071,0.7071` after X-1; (b) `0,1.4142` after Y-1; (c) `0,0` after X1 Y1. Expected files were **inspected, not executed**.

For a separate minimal new test, freeze two *isolated software-only* configurations differing only in G54 R0 versus R45, set the same known machine point, execute X-only L20, and compare stored offsets and current fixture-coordinate values. Do not run a G53 positioning move on a connected machine merely to create a test oracle. Capture the INI, parameter file, LinuxCNC revision, stdout/stderr, actual exit and job runtime.

## Real upstream probing example: why command ordering matters
Pinned [GladeVCP `probe.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/gladevcp/probe.ngc) performs `G91 G38.3`, checks `#5070`, sets `G10 L20 P#<_Probe_System> X#<_Probe_Diameter>` (or Y/Z), and then issues `G90 G0` to the requested retract coordinate. That **absolute retract is interpreted in the newly established fixture**, not the previous one. The example also explicitly warns it changes feed and absolute/relative mode. An application must check whether the requested retract is clear in the **post-touch-off** frame; a successful G38.3 probe result is not a verified safe clearance.

A production-facing CAM/probe postprocessor should retain: intended units G20/G21; active fixture/P number; R rotation; G52/G92 and tool-length compensation state; probe direction and trip success; expected contact geometry (ball radius, plate thickness, cutter radius); offset update; **new-frame** retract; and independent collision clearance. For an OpenPressBrake/plasma DXF import, do not insert L20 as an implicit geometric alignment operation without a human-confirmed datum and a clear coordinate-frame contract.

## Error and version gates
- L20 does **not** accept R; use L2 to set fixture rotation deliberately. Verify the target P range 0–9 and configured axes.
- Active G41/G42 cutter compensation blocks changing the active fixture. Cancel/restore compensation explicitly where appropriate rather than silently retrying.
- The inspected development LinuxCNC revision rejects G10 L20 during active G68.2; stable 2.9.10 has no native G68.2. A postprocessor must check controller version and tilted-work-plane state.
- For wrapped rotary axes, check configured axis type and the version-specific wrapped-axis validation; do not assume U/V/W are always linear on development builds.
- Save and compare fixture parameter values before/after; a changed stored Y offset after an X-only L20 under rotation is expected, whereas an unexpected **machine motion** is not.

## Acceptance and stop criteria
Software-only acceptance: observed canonical offsets match pinned upstream expected output within the test's stated precision, displayed untouched axis is preserved, active/inactive fixture ownership is correct, and rejection cases produce recorded interpreter errors. **No test was run this session.** Physical acceptance is a separate machine-specific process with qualified homing, probe hardware, clearance, fixturing and independent safety systems. Never infer physical trust or personnel safety from a G10 command or GUI DRO.

**Next:** [precise checkpoint](../checkpoints/20261101T174000Z-4000-linuxcnc-g10-l20-next.md).
