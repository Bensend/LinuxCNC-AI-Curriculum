# 4000-LC-TWP-112 — Effective G68 status, G52 folding and abort/read-ahead recovery
**2026-11-01 | Status SOURCE / NON-GRADUATED | development 06864e23559e70463fc7112d5ce77138bcbc288c only; stable v2.9.10 lacks native G68.2.**

## Distinct question
What exactly does a status client (Axis/halui/ROS/MTConnect adapter) learn from `g68_offset`, and which plane is authoritative after read-ahead, M2/M30, abort, G54/G55 switch, or controller restart? This is distinct from TWP-111's geometry and prior ROS-45/TELEM-87's generic freshness issue.

## Source chain and critical distinctions
- [`work_plane_local` lines 310–333](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_workplane.cc#L310-L333) accepts only XYZ on G52 in a plane; writes `g68_local` and adjusts current program coordinates to preserve physical position. [`work_plane_send` lines 197–212](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_workplane.cc#L197-L212) sends `O_effective = O_original + R·L` to canon. **The exported `g68_offset` is the effective shifted origin**, not a separately reversible record of the original G68.2 origin and G52. Two pairs `(O,L)` can yield the same status frame; a remote consumer cannot infer the original G52 solely from `g68_offset`.
- [`SET_G68_FRAME` lines 554–574](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emccanon.cc#L554-L574) enqueues `EMC_TRAJ_SET_G68`; [`emctaskmain.cc` lines 1584 and 1999](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emctaskmain.cc#L1995-L2006) treats it as a motion-ordered status change and copies origin, 3×3 rotation and active flag into Task status. This is not independent physical pose feedback.
- [`halui.cc` lines 2010–2050](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/usr_intf/halui.cc#L2010-L2050) computes relative XYZ by subtracting tool/G5x, undoing XY rotation/G92, and applying `Rᵀ(p−O_effective)`. Its `axis.N.pos-relative` therefore depends on current Task plane state. Status polling and HAL publishing have their own age/ordering; a read-only bridge must not treat a single `g68_active` value as synchronized to an independently polled position sample.
- [`work_plane_restore` lines 255–310](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_workplane.cc#L255-L310) asks `GET_EXTERNAL_G68_FRAME` for **machine-executed** plane after abort. [`emccanon.cc` lines 4006–4033](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/task/emccanon.cc#L4006-L4033) refuses restoration (returns inactive) if read-ahead canon G5x/G92/XY rotation differ from Task's executed values; otherwise it returns Task plane. Hence `RETAIN_WORK_PLANE=1` does **not** guarantee a plane is retained across all abort cases. A coordinate-system mismatch can cancel it.
- [`rs274ngc_pre.cc` lines 2744–2759](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/rs274ngc_pre.cc#L2744-L2759) chooses restore vs cancel on abort. [`interp_convert.cc` M2/M30 region lines 5498–5635](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/interp_convert.cc#L5498-L5635) retains or cancels at program end, with G54/G92 reset interactions. [`rs274ngc_pre.cc` reset lines 1226–1230](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/rs274ngc/rs274ngc_pre.cc#L1226-L1230) cancels at program start/restart; the docs say no plane is persisted in the parameter file.
- [Official INI docs](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/config/ini-config.adoc#L630-L642) set `[RS274NGC] RETAIN_WORK_PLANE = 0` by default. [Official G68.2 docs](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gcode/g-code.adoc#L2100-L2168) specify G52/G69 and coordinate-system behavior.

## Independent upstream test *artifact*, not a test run here
[Upstream `tests/workplane-retain/test-ui.py`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/workplane-retain/test-ui.py) drives MDI, M2, read-ahead abort and G52 cases; [its `expected` file](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/tests/workplane-retain/expected) contains **expected** outcomes:
- With retain=1, M2 and abort-before-next-plane preserve the executed plane.
- With retain=1, abort after read-ahead into a plane on G55 but restoration on G54 **cancels** it.
- With retain=0, M2 and abort cancel.
These are **upstream TEST-FIXTURE-CONFIRMED expectations**, not local TEST-CONFIRMED observations. Test runner, exact binary and execution outcome not inspected.

## Numerical status provenance discriminator
For P1 X90 frame `O=(10,20,30)`, `L=(2,3,4)`, `R·L=(2,-4,3)`. Task status `g68_offset` is expected to be `(12,16,33)` after the G52. An API that displays it as “G68.2 origin entered by operator” would be misleading; label it **effective plane origin**. Do not claim status alone can recover `L`. Source-derived arithmetic only.

## Evidence ledger
| Finding | Class | Unverified |
|---|---|---|
| Task status receives effective origin + rotation | SOURCE-CONFIRMED | actual runtime timestamp/order |
| G52 local is folded into origin | SOURCE-CONFIRMED | local/remote sampling |
| Retain on abort is conditional on executed-vs-read-ahead coordinate frame | SOURCE-CONFIRMED; upstream fixture supports intent | runtime transition |
| G69 cancels and drops plane-local G52 | SOURCE/DOC-CONFIRMED | machine position following cancellation |
| Restart clears plane | SOURCE/DOC-CONFIRMED | controller restart test |
| Freshness of a particular ROS/MTConnect bridge | UNKNOWN | installed bridge source/config |

## Practical interface contract
A read-only telemetry consumer should publish: `g68_active`, effective origin (unit-tagged), nine rotation elements (row-major), active G5x/G92/XY rotation, position sample and its own receipt time, and an explicit *not-atomic* qualifier unless the data came from a common snapshot. Never derive tool orientation or safety permission from G68 status. Before commanding a continuation after abort, re-read Task status and kinematics, do not blindly replay a cached G68.4 incremental plane.

## Next and novelty
Use the [3100/4000 walkthrough](../guides/3100-4000-linuxcnc-g682-tilted-work-plane-cam-and-status-2026-11-01.md). A qualified isolated runner can execute the **existing upstream** `workplane-retain` test, capturing actual outputs and exit status; avoid duplicating it with a fresh 20-case unrun bank. No build or test was run in this research session.
