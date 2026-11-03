# 4000-LC-MOTION-188 — Task → motion → TP → servo-cycle source navigation (2026-11-03)

**Status:** SOURCE (navigation and source-grounded interface contracts), NON-GRADUATED. No executable confirmation. **Scope:** LinuxCNC upstream tag `v2.9.10` (previously resolved by HM2-181 to commit `86cdca76`). Do not generalize to development without a fresh diff.

## Why this lesson
HM2-187 closed an Ethernet information-gain branch. Motion command ownership and servo-period interpolation transfer across mills, lathes, plasma, routers and press brakes. This is a **navigation and discriminating-experiment foundation**, not another claim to have executed MOTION-144.

## Directly inspected upstream entry points

1. [Task main](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc): the file's opening design contract says `emcTaskPlan()` interprets AUTO programs and appends NML commands to `interp_list`; `emcTaskExecute()` processes preconditions, dispatch and postconditions. **Consequence:** interpreter emission is not identical to motion execution, and Task may wait for completion.
2. [Motion command handler](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c): `emcmotCommandHandler()` receives userspace commands and implements the realtime command switch. The header documents the configuration propagation route through `taskintf.cc`, `iniaxis.cc`, shared command structures and the motion handler. **Consequence:** distinguish an INI value, a dispatched command, and its effective realtime state.
3. [Motion controller](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c): file identifies `emcmotController()` as servo-cycle loop, responsible for state logic and trajectory calculations. The declared processing stages include `process_inputs()`, `do_forward_kins()`, and `process_probe_inputs()`; probe capture is intentionally after forward kinematics to use current-cycle feedback.
4. [Trajectory planner](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c): the planner implements TC segments, exposes `tpMotFunctions` callbacks for synchronized I/O, rotary unlock and axis velocity/acceleration limits, and defines STOP, EXACT and BLEND termination codes locally. **Consequence:** G61/G64 path behavior is a planner/canonical interface question, not merely a GUI option.
5. [Upstream simulation INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/axis.ini): `[TASK] CYCLE_TIME=0.001`, `[EMCMOT] SERVO_PERIOD=1000000` ns, `BASE_PERIOD=0` in this simulation, `[DISPLAY] CYCLE_TIME=0.100`. **These are distinct clocks**; UI refresh does not prove the controller's interpolation cadence. This is a simulation config, not a commissioned physical mill.

### Source / inference boundary

**SOURCE-CONFIRMED:** The five files above expose the documented Task lifecycle, realtime motion command entry, servo-cycle controller, TC planner interface and distinct configured periods. **INFERENCE requiring a deeper call-site trace:** a particular G1 command's exact NML type, motion switch branch, TP enqueue call and cycle-by-cycle position command. Do not claim a complete end-to-end call chain from these file headers alone. **TEST-CONFIRMED:** none.

## Practical disconnected walkthrough: what to trace next

Use a disposable copy of the upstream simulation INI, not production HAL. Read the referenced HALFILE(s) and write a table of every `addf` in actual thread order. Prepare this **review-only** NGC sequence (do not run without an isolated test environment):

```ngc
G21 G17 G90 G40 G49 G80
G0 X0 Y0
G61
G1 X10 F600
G1 Y10
G64 P0.1
G1 X0
G1 Y0
M2
```

The intended discrimination is **not** whether the machine reaches (0,0): both termination modes can do so. Compare (a) interpreter/canonical termination mode at each block, (b) TP queued segment boundaries and any blending, (c) per-servo-cycle commanded Cartesian positions, and (d) following-error/actual position from a separately characterized feedback source. Record timestamps and units. Never infer physical contour accuracy from a simulation's commanded position or stepgen's self-feedback.

**Before execution:** verify simulation kinematics, soft limits, startup position, and whether the G64 P tolerance is valid for the chosen INI. `F600` in G21 is 600 mm/min = 10 mm/s; `SERVO_PERIOD=1000000` ns implies nominal 1 ms, **not** a guaranteed scheduling deadline. Avoid assuming exactly 1 mm of motion per 100 cycles: acceleration and planner cornering intervene.

## Source-navigation checklist for the next session

- Find the interpreter's canonical straight-feed emitter and the exact Task `EMC_TRAJ_LINEAR_MOVE` dispatch; capture line spans at the pinned revision.
- Find `EMCMOT_SET_LINE` in `command.c`, the specific `tpAddLine` call and the `tpRunCycle` call site in `control.c`. Confirm exact spelling and guard conditions from source rather than relying on this checklist.
- Inspect the complete sim HAL file(s) and one real machine configuration (Mesa mill or QtPlasmaC), explicitly separating planner command, HAL output and measured feedback.
- Compare the G61 and G64 transition in the existing `tests/interp/g6164` suite; check actual test oracle and revision before claiming coverage. Existing CYCLE-174 shows interpreter error/unwind can complicate mode persistence.
- Freeze a small source-to-observable prediction matrix, then execute **only** if independent isolation for `[self-hosted, openpressbrake]` is verified. MOTION-144 remains the first executable priority; do not launch GitHub-hosted Actions.

## Cross-machine transfer

Mill/router: segment blending can change corner path and time. Plasma: commanded XY trajectory and torch height/external-offset authority must be distinguished. Lathe: spindle synchronization and CSS are additional constraints. Press brake: motion planner is **not** a substitute for independent personnel-safety authority or OpenPressBrake G0/G1 acceptance. ROS 2 and CAD/CAM posts are upstream command producers; generated G-code still traverses the interpreter/Task/motion chain.

## Unresolved / next checkpoint

This lesson **does not** establish actual `tpRunCycle` ordering, segment queue consumption, jerk limits, exact interpolation equations, G64 blend outcomes, or real-machine latency. These are the highest-value next source questions. No new laboratory compute, workflow, physical operation, or blind-evaluator action. Preserve closed 1000–3000 levels and independent safety gates.
