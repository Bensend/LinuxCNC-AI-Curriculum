# 3100 / 3400 / 4000 — G81 plane-transition CAM preflight and disconnected canonical verification

**Status:** source-grounded implementation walkthrough; **NOT RUN**, not a physical machine program. Read [CYCLE-119](../research/4400_LINUXCNC_CYCLE_119_G17_G18_G98_INITIAL_LEVEL_STICKY_AXIS_SOURCE_AUDIT_2026-11-01.md) and the prior [CYCLE-115 G73/G83 clearance investigation](../research/4400_LINUXCNC_CYCLE_115_G73_G83_PECK_CLEARANCE_VERSION_AND_R_OVERSHOOT_SOURCE_AUDIT_2026-11-01.md). The present problem is **plane-dependent state reuse**, not peck clearance.

## Why a mill/router post needs this rule

A drilling cycle is modal group 1; plane selection G17/G18/G19 is modal group 2. G18 changes the interpretation of the drill axis from Z to Y **without canceling an active G81**. LinuxCNC's G98 initial level and sticky cycle depth/R are stored as scalar numbers, not tagged with the plane or axis that supplied them. Stable v2.9.10 and pinned development share this source behavior. The ordinary controller, not the CAM preview, expands a native G81 into canonical rapid/feed segments.

| Item | G17 XY drilling | G18 XZ drilling |
| --- | --- | --- |
| In-plane location | X/Y | X/Z |
| Perpendicular drill/feed axis | Z | Y |
| G98 initial level | initial Z | initial Y **if freshly captured** |
| R | Z clearance | Y clearance |
| G81 bottom | Z | Y |
| Native canonical output | X/Y/Z feed/traverse | X/Y/Z feed/traverse with Y as third-axis input |

## Source-derived A/B test files

Two deliberately minimal, **disconnected-only** G-code fixtures are in [without_g80.ngc](../examples/4000_cycle_plane_transition/without_g80.ngc) and [with_g80.ngc](../examples/4000_cycle_plane_transition/with_g80.ngc). Both assume a clean interpreter initialized with XYZ axes and G21 metric units. Both first execute G17/G98/G81 with starting Z20, R5, bottom Z-2; then switch to G18 and explicitly request an XZ-plane G81 with Y bottom -2.

| Expected discriminator | A: no G80 | B: G80 before G18 |
| --- | --- | --- |
| Initial level retained/captured for second cycle | **20**, inherited from prior Z | **0**, freshly captured from current Y |
| First new-cycle approach | X10 Y20 Z10, then X10 Y5 Z10 | Y5 at previous X/Z, then X10 Y5 Z10 |
| Feed | X10 Y-2 Z10 | X10 Y-2 Z10 |
| Final G98 retract | **X10 Y20 Z10** | **X10 Y5 Z10** |

The predicted **Y20 versus Y5** is the sole essential oracle. Source-derived canonical requests are not measured machine motion; limit rejection or planner behavior remains untested.

## CAM postprocessor handoff rule

A postprocessor should maintain a tracked active `plane` and `canned_cycle` state. Before changing the plane when any G73/G81/G82/G83/G84/G85/G86/G87/G88/G89 remains active, emit **G80 on its own line**. Then select G17/G18/G19, establish a verified starting position along the *new* perpendicular axis, and issue a new cycle with explicit R, bottom-axis word, feed and retract mode. Keep units and distance mode explicit. Do not rely on a previous Z-depth or R being meaningful after G18. G99 changes the return plane but **does not** cure inherited bottom-axis values.

Minimal conceptual post logic (not controller code):

```text
if new_plane != active_plane:
    if active_cycle:
        emit("G80")
        active_cycle = false
    emit(new_plane)                 # G17 / G18 / G19
    active_plane = new_plane

verify_perpendicular_axis_position_and_fixture_clearance()
emit_explicit_retract_mode()        # G98 or G99
emit_explicit_cycle_R_depth_feed()
```

Do not assume a generic three-axis mill can actually perform side drilling; the machine must have appropriate tool orientation and independently established clearances. These are interpreter semantics, not a recommendation to use G18 G81 on an ordinary vertical mill.

## FreeCAD-specific producer boundary — CYCLE-120

The [pinned FreeCAD producer audit](../research/4400_LINUXCNC_CYCLE_120_FREECAD_G80_TERMINATOR_OPAQUE_TEXT_BOUNDARY_SOURCE_AUDIT_2026-11-01.md) narrows this risk. At FreeCAD commit `24ea8589aa86`, ordinary drilling `Path.Command` sequences pass through `Processor._expand_canned_cycles` and `PostUtils.cannedCycleTerminator`, which **inserts G80 before a non-cycle command such as G18 and at cycle end**. Do **not** claim that stock FreeCAD's ordinary drill output necessarily reproduces the LinuxCNC cross-plane state issue.

The limitation is **opaque text**: FreeCAD also supports `item_type="str"` postables with `path=None`, which bypass that Path.Command terminator and are copied as raw G-code. Therefore final NC-file inspection remains necessary for custom text, manually concatenated G-code or external postprocessor rewrites. FreeCAD's `DrillCycleExpander` explicitly does not support modal axis-only repeats or L repeats, so translating cycles into explicit G0/G1 is not a generic equivalence for handwritten modal drilling. These are source inspections, **not** observed FreeCAD exports or executed tests.

## Exact source and existing upstream baseline

The stable [interpreter conversion order](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc#L2360-L2420) selects the plane before motion; [convert_motion](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc#L3812-L3838) clears `cycle_il_flag` only on non-cycle motion; [convert_cycle_zx](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc#L1774-L1836) maps the old scalar to Y. Development equivalents are pinned in CYCLE-119. The official [G98/G99 manual](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc#L2851-L2888) states that abandoning the cycle resets the initial plane.

Reuse upstream [G17/G98/G81](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g81/g17/g98/g17-g98-g81.ngc) and [G18/G98/G81](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g81/g18/g98/g18-g98-g81.ngc) as per-plane baselines. They do **not** test a mid-cycle plane switch. Avoid creating a broad new test suite: A/B plus a single modal/sticky variant suffices to discriminate the new source claim.

## Frozen software-only verification (not executed)

Only after an isolated, positively qualified `[self-hosted, openpressbrake]` runner is available, use the matching LinuxCNC revision's standalone interpreter and existing test conventions. For each fixture, record the binary identity, commit/tag, interpreter startup configuration, exact command, stdout, stderr, exit status, canonical traverse/feed lines, and actual job start/end UTC. Example invocation *pattern* (not an assertion of installed executable or completed run):

```sh
rs274 -g without_g80.ngc > without_g80.canon 2> without_g80.err
rs274 -g with_g80.ngc    > with_g80.canon    2> with_g80.err
```

Run from separate clean interpreter processes; compare the first XZ-plane cycle and **do not** mix persistent state from a previous file. A correct A/B result has a source-predicted G98 retract to Y20 without G80 and Y5 with G80. A third *minimal* discriminator can replace the second explicit G81 line in A with `X10 Z10` to test modal reuse of old R5 and old Z-2 as Y depth. Record any parser rejection rather than forcing the prediction to pass. Do not dispatch legacy hosted Actions, unreviewed scripts, or a physically connected panel PC.

**Evidence record:** All proposed interpreter executions are **NOT RUN**; no logs, timings, exit statuses, machine motion or independent evaluation exist for this guide. Source audit and numerical predictions are not runtime proof. Existing 1000/2000/3000 graduation, independent personnel safety authority, and selected OpenPressBrake G0/G1 HOLD remain unchanged.

## Fresh-engineer check (unscored)

Given a G17/G98/G81 cycle whose initial Z is 12, an active G81 and a later G19 plane change, identify the new perpendicular axis (X), determine which old scalar might be reused as OLD_X, and propose the smallest postprocessor fix. Then explain why G99 alone does not establish a new bottom-axis value. Check the answer against the pinned source, not against a preview. No blind score is claimed.