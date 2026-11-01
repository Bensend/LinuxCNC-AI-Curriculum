# CYCLE-119 — G17→G18 canned-cycle plane switch retains G98 initial level and sticky drilling axis

**Status:** 4000 LinuxCNC implementation / 3100 mill and 3400 router CAM-post transfer; **NON-GRADUATED**. Audit 2026-11-01. **Evidence:** SOURCE-CONFIRMED conditional path in two pinned revisions; DOC-CONFIRMED modal/retract descriptions; numerical canonical predictions are INFERENCE; **TEST-CONFIRMED none**. No connected machine use authorized.

## New question, scope and predecessor check

Does changing the selected machining plane while a canned drilling cycle is modal establish a new G98 initial level and a new perpendicular drilling axis, or can it reuse state captured in the previous plane? This is **not** the earlier CYCLE-115/116/117/118 peck-clearance problem (G73/G83 rapid delta, signed D, unit conversion, FreeCAD expansion). A full PROGRESS text scan found G98/G99 only in those peck investigations; no prior G17→G18 *while a cycle remains active* state-lifetime trace. The existing upstream G81 G17 and G18 tests each select one plane before the cycle, not this transition.

## Pinned sources (read directly, not inferred from filenames)

Stable LinuxCNC **v2.9.10** at commit `86cdca76fa2a36274c432caa21952b23c267989a`; development at `06864e23559e70463fc7112d5ce77138bcbc288c`. Relevant inspected Git blobs: stable `interp_convert.cc` `f01a359652d588d59c9e210fa441a99d2ee19598`, `interp_cycles.cc` `3d3fd818ac1f36fd7a36620c654ad6b3677295be`, `interp_internal.cc` `829591161dfd9bf444cce5ef9d2b9a0a903dedff`, `interp_internal.hh` `c400d66eb6e332b03caf700b4238e9fa91fc0799`; development `interp_convert.cc` `379b21eaba65840ce4160e7ea70df60c12fad9ff`, `interp_cycles.cc` `bbebc0d6ed872688c701a12f5a1467bff5f4fd94`, `interp_internal.cc` `bcccebe27c2a1ee55073bf734b1a68d64e4bbf80`, `interp_internal.hh` `ebe9d0d0d49b558192ebbb2a840dba15a167acf1`.

Official stable [G80 description](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc#L2259-L2320) says G80 or another group-1 motion mode cancels a canned cycle. [G98/G99](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/g-code.adoc#L2851-L2888) says the initial plane is reset when cycle motion mode is abandoned; switching among canned-cycle types does not reset it. A G17/G18 *plane-selection* command belongs to a different modal group; the docs do not promise it cancels the active drilling cycle. The [development G98/G99 documentation](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gcode/g-code.adoc#L3251) retains the same principle.

## End-to-end source trace

1. **Interpreter parser, userspace:** [`Interp::enhance_block`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_internal.cc#L147-L217) sets `motion_to_be` to explicit group-1 G-code if present; otherwise an axis-bearing block inherits `settings->motion_mode`. A plane-only `G18` block has no axis words and need not generate a motion command; the following `X10 Z10` block can inherit modal G81.
2. **Interpreter conversion order:** [`Interp::convert_g`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc#L2360-L2420) executes `GM_SET_PLANE` before `GM_RETRACT_MODE` and `STEP_MOTION`. [`convert_set_plane`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc#L4435-L4468) updates `settings->plane` and emits `SELECT_PLANE`, but does **not** clear `cycle_il_flag`, `cycle_il`, `cycle_cc`, `cycle_r` or the active `motion_mode`. The [development implementation](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_convert.cc#L5230-L5266) has the same relevant omission.
3. **Reset is tied to motion conversion, not plane selection:** stable [`convert_motion`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc#L3789-L3840) clears `cycle_il_flag` only if `!is_a_cycle(motion)`. G80 is a group-1 non-cycle, so G80 clears the flag; merely changing G17→G18 does not call this reset. Development [same branch](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_convert.cc#L4576-L4621).
4. **Sticky parameters cross planes:** stable [`convert_cycle`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc#L718-L790) reuses `settings->cycle_r` if R omitted while the same motion cycle is active. [`convert_cycle_xy`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc#L898-L976) captures initial Z in `cycle_il` and stores the cycle's Z target in `cycle_cc`. After G18, [`convert_cycle_zx`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc#L1774-L1836) treats **Y** as the drilling axis, but reuses the **same** `cycle_il` as OLD_Y when its flag is already set; if Y is omitted it also reuses `cycle_cc` (which may be the preceding Z depth). Development [XZ path](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_cycles.cc#L1769-L1831) preserves the behavior.
5. **Canonical output, not physical feedback:** [`CYCLE_MACRO`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_internal.hh#L956-L989) commands a traverse to `clear_cc` and then R when needed. [`cycle_traverse` and `cycle_feed`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc#L2187-L2263) map XZ `(end1,end2,end3)` to physical-coordinate command `(X=end2,Y=end3,Z=end1)`. These are interpreter canonical requests. Task, trajectory planning, limits, actual axis motion and fixture interaction were **not** executed or measured.

## Frozen, source-derived discriminator (metric, absolute, G98)

Assume an otherwise valid disconnected interpreter, initial `(X,Y,Z)=(0,0,20)`, `F100`, G17, G21, G90, G94, G40:

`G98 G81 X0 Y0 Z-2 R5` → the first XY-plane cycle retracts to **Z20** and leaves modal G81, `cycle_il=20`, `cycle_cc=-2`, `cycle_r=5`.

**A — no cancellation:** `G18` followed by `G81 X10 Z10 Y-2 R5`. G18 changes the drilling axis to Y, but G98's old initial level is still numeric 20 from **Z**. At the next cycle `current_y=0`, `r=5`, `old_cc=20`, `clear_cc=20`. Source-derived canonical sequence: traverse **(X10,Y20,Z10)**, traverse **(X10,Y5,Z10)**, feed **(X10,Y-2,Z10)**, retract **(X10,Y20,Z10)**. The 20 mm Y traverse is *not* the actual pre-cycle Y0.

**B — cancellation control:** insert `G80` **before** `G18` and the same explicit G81. `cycle_il_flag` is cleared; the new G18 cycle captures `current_y=0`, first raises Y to R5, traverses in XZ at Y5, feeds Y-2 and retracts to **Y5**. No source path commands Y20 solely from the previous Z20.

**C — modal/sticky variant:** in A replace explicit `G81 X10 Z10 Y-2 R5` with only `X10 Z10`. The parser inherits modal G81; `convert_cycle` reuses R5 and the XZ helper reuses prior Z-depth -2 as **Y-depth -2**. This can command a Y-axis drilling cycle even though the new line contains neither G81, Y nor R. Under G99, the inherited Y-depth problem remains, although the G98 Y20 return is suppressed.

All coordinates are **predictions from inspected source**, not observed LinuxCNC canonical logs or machine trajectories. A machine may reject a requested move at a later limit stage; that is not proof the interpreter did not emit it.

## Existing upstream test boundary and practical mitigation

The upstream [G17/G98/G81 test](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g81/g17/g98/g17-g98-g81.ngc) and [G18/G98/G81 test](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g81/g18/g98/g18-g98-g81.ngc) independently document per-plane axis conventions; both select their plane **before** any canned cycle. Their [test.sh](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/interp/g81/g18/g98/test.sh) uses `rs274 -g`, but these files were **read, not executed**, and do not establish this transition case.

A CAM post changing G17/G18/G19 during drilling should **explicitly cancel with G80**, select the new plane, establish a valid independent initial position along its perpendicular axis, and emit the new cycle with explicit R and perpendicular-axis bottom. Do not treat G99 alone as a full cure for sticky depth. The [practical disconnected guide](../guides/3100-4000-linuxcnc-canned-cycle-plane-transition-cam-preflight-2026-11-01.md) freezes the minimal A/B canonical comparison. Do not use either fixture on a physical machine.

## Claims / uncertainties / promotion

| Claim | Classification | Scope / qualification |
| --- | --- | --- |
| Plane selection does not clear cycle initial-level or sticky R/axis state | SOURCE-CONFIRMED | Both pinned revisions, inspected converter paths |
| A G18 XZ canned cycle can inherit G17 initial Z as its OLD_Y | SOURCE-CONFIRMED conditional | Same active cycle; G98; no intervening group-1 non-cycle |
| A modal axis-only line can reuse prior R and Z-depth as G18 Y-depth | SOURCE-CONFIRMED conditional | Same G81 active, no G80, no new R/Y |
| Y20/Y5/Y-2 canonical targets in example | INFERENCE | Exact arithmetic from source; NOT RUN |
| Real physical axis travel, soft-limit handling, fixture clearance | UNKNOWN | Requires installed configuration and disconnected canonical verification first |
| G80/G98 intended modal semantics | DOC-CONFIRMED | Official stable/development manuals |
| Local interpreter test or independent evaluation | TEST-CONFIRMED **none** | No runner qualification / execution |

**Uncertainty queue:** P1 (HIGH): execute A/B and modal/sticky C only on positively qualified isolated `[self-hosted, openpressbrake]` compute, capture full `rs274 -g` canonical lines, exit status and version; this **blocks runtime confirmation**, not publication of a source audit. P2 (MEDIUM): inspect an upstream plane-change test or issue only if observed behavior differs; do not claim an upstream defect report exists. P3 (LOW): assess G20/G21 cycle-state rescaling separately only if novel beyond CYCLE-117. No graduation or personnel-safety gate changes.