# 4000-LC-TP-31 — development G64 R planner intent, idle deferral and nonfatal rejection

**Date:** 2026-10-31. **Status:** SOURCE-CONFIRMED development-only conditional behavior / DOC-CONFIRMED; **TEST-CONFIRMED none**. NON-GRADUATED. Not a claim about installed LinuxCNC.

## New version-sensitive question

Does a `G64 R` command select a planner immediately and reliably, or can program execution continue while the active realtime planner is unchanged? This matters when accepting generated G-code across stable v2.9 and development machines.

**Pins:** stable LinuxCNC [v2.9.10](https://github.com/LinuxCNC/linuxcnc/tree/v2.9.10) versus development [`24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), inspected 2026-10-31. Development source blobs:
- [`interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc#L2231-L2290) `379b21eaba65840ce4160e7ea70df60c12fad9ff`;
- [`emccanon.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emccanon.cc#L1346-L1384) `5ad736c59e85495aa06573ebcad2d49d59145583`;
- [`emctaskmain.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/task/emctaskmain.cc#L1953-L1978) `049c640f1af1b21c18161d6c065ff6f3e35fd83b`;
- [`initraj.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/ini/initraj.cc#L143-L197) `36537e70bdc465824a9278a938d81d1d5adf09ab`;
- [`command.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/command.c#L90-L120) and [`EMCMOT_SET_PLANNER_TYPE`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/command.c#L1254-L1307) `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`;
- [`inihal.cc`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/ini/inihal.cc#L307-L340) `e6a7d2ab1756bd9e81fd3ce894fb76a0ad23b046`;
- [development G64 R docs](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/gcode/g-code.adoc#L1934-L1978) and [INI planner docs](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/config/ini-config.adoc#L953-L981).
Stable v2.9.10 `Interp::convert_control_mode` accepts P/Q but **does not implement this R planner-selection path**. Do not label a program using development G64 R as stable-compatible without an actual stable interpreter test.

## Cross-layer control flow

1. In development `Interp::convert_control_mode`, **R omitted** sets `planner_type=-1` and `peak_scale=-1` (leave unchanged). `R<=0` requests trapezoidal type 0, leaving peak scale unchanged. `0<R<0.1` requests smooth with peak scale 0.1; `0.1..1` uses R; `R>1` clamps to 1.0. **R0 → R0.1 is a regime change**, not a continuous gradient. `G64 P/Q` remains a separate tolerance choice.
2. Canonical `SET_MOTION_CONTROL_MODE` flushes pending line segments and attaches planner intent and scale to the same queued `EMC_TRAJ_SET_TERM_COND` message as G64's path-control change.
3. Task executes `emcTrajSetTermCond` first. On success and an explicit planner request, type 0 calls `emcTrajPlannerType(0)`; smooth intent resolves through `[TRAJ]SMOOTH_PLANNER`. The startup default for that mapping is 1 when usable, even when `[TRAJ]PLANNER_TYPE=0`; `MAX_LINEAR_JERK<1` forces the mapping to 0. Thus **trapezoidal startup does not necessarily prohibit later G64 R>0**.
4. **Important failure-status boundary:** if Task sees `smooth<1`, it calls `emcOperatorError(...)` but does **not** assign a nonzero `retval` or raise an interpreter error in the inspected case. The G64 term-condition command can therefore complete with the previous planner still active and an operator error displayed. This is source-confirmed control flow, not proof of a particular GUI's response. The `emcTrajPlannerType(...)` return value is also not used to change `retval` in this branch.
5. In realtime motion, a type change is applied immediately **only if** `tpIsDone(coord_tp)` and `tpQueueDepth(coord_tp)==0`. Otherwise the requested type is stored as a **pending** value and an operator-facing message is issued; `emcmotApplyPendingPlannerType` applies it once the coordinated queue becomes idle. A later request matching the currently active type can cancel a pending switch. Task's queued command completion is therefore **not a proof of planner activation**.
6. `scurve_peak_scale` is a **separate motion command** with immediate 0.1..1.0 clamping. It is not held behind the planner-type idle barrier. A G64 R>0 while an S-curve planner is already active can alter peak scale during motion; while switching from trapezoidal, the scale may be updated before the pending planner switch activates. This is a source-derived ordering consequence, **not a measured velocity/jerk waveform**.
7. Development `ini.traj-planner-type` and `ini.traj-scurve-peak-scale` are writable machine-side HAL/INI controls. `inihal.cc` sends new values on pin changes, so a machine-side update can independently request a planner change or scale update after a G64 R command. Program intent, pending switch and actual realtime state must be observed separately.

## Acceptance matrix for a disconnected development simulation (not executed)

Record the pinned executable SHA, INI `PLANNER_TYPE`, `SMOOTH_PLANNER`, `MAX_LINEAR_JERK`, per-axis `MAX_JERK`, and the two `ini.traj-*` pin values. Observe Task messages, operator errors, realtime `planner_type` and `scurve_peak_scale`, TP queue depth, and whether a pending switch is later applied.

| Case | Setup / G-code | Source-derived expectation |
|---|---|---|
| A | Startup type 0, usable jerk, smooth mapping 1; `G64 P0.02 Q0.01 R0.5` while idle | Task requests type 1, peak scale 0.5; motion can apply type immediately if queue idle. |
| B | Type 0 with a busy coordinated queue; `G64 R0.5` | Type switch deferred until `tpIsDone && depth==0`; peak scale command is not similarly deferred. |
| C | Smooth mapping 0; `G64 R0.5` | Operator error; inspected Task branch does not automatically turn the term-condition command into `RCS_ERROR`. |
| D | Active type 1, busy queue; `G64 R0` | Type 0 requested and deferred; peak scale unchanged. |
| E | Pending type 1, then type 0 request while still type 0 | Source cancels pending switch; do not assume the first command will eventually activate. |
| F | G64 without R | Path tolerance may change; planner type and scale are left unchanged by sentinels. |

**Test-design caveat:** normal interpreter look-ahead and Task queue barriers may prevent a specific G64 command from arriving while the TP queue is busy. A valid busy-queue discriminator must prove that the motion command was actually received while `tpQueueDepth>0`, e.g. via an isolated motion-command test harness or appropriately synchronized HAL command, not merely place G64 mid-file and assume overlap.

## Engineering consequences and limits

For postprocessor portability, declare stable-v2.9 vs development support explicitly. A program's successful G64 interpretation or an operator message is **not** proof of an active S-curve planner. Do not conflate `[TRAJ]PLANNER_TYPE`, `[TRAJ]SMOOTH_PLANNER`, a queued G64 R intent, a pending switch, and the active realtime planner. Preserve independent machine limits and personnel-safety authority. **No source patch, upstream submission, simulation, build, test suite, physical operation or Actions compute.** The missing evidence is a pinned development runtime with actual queue/command timing and status traces.
