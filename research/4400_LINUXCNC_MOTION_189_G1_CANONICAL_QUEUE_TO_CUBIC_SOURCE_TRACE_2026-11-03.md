# MOTION-189 — G1 canonical buffering to coordinated cubic joint interpolation (2026-11-03)

**Scope:** LinuxCNC v2.9.10, pinned commit `86cdca76`. 4000 SOURCE, NON-GRADUATED; no runtime verification. Continuation of MOTION-188. This trace uses upstream source at the exact pinned revision, not a GUI animation or a machine test.

## Crucial correction to the naïve G1 call chain

`STRAIGHT_FEED` does **not** immediately send an `EMC_TRAJ_LINEAR_MOVE`. In [emccanon.cc L1084–1095](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L1084-L1095), it transforms coordinates and calls `see_segment`. Canonical motion can accumulate in `chained_points`; [`flush_segments` L886–954](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emccanon.cc#L886-L954) constructs the actual `EMC_TRAJ_LINEAR_MOVE` using the last chained point, limits feed velocity, computes acceleration, and only calls `tag_and_send` if `(vel && acc) || spindle.synched`. The intermediate `see_segment` joining rules and flush triggers need a separate audit before asserting one NML move per G1 block. **A line in G-code is not necessarily a one-to-one queued TP segment.**

## Confirmed downstream path

1. [Task `emctaskmain.cc` L1514–1524](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emctaskmain.cc#L1514-L1524): linear moves have `WAITING_FOR_IO` precondition classification; [L1836–1843](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/emctaskmain.cc#L1836-L1843) calls `emcTrajLinearMove`. This is dispatch, **not** proof of trajectory completion.
2. [`taskintf.cc` L1429–1441](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/task/taskintf.cc#L1429-L1441) fills `EMCMOT_SET_LINE` with end, tag, motion type, velocity, acceleration, ID and indexer number; `usrmotWriteEmcmotCommand` submits it.
3. [`command.c` L993–1055](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/motion/command.c#L993-L1055): coordinated mode **and** motion enabled are required; `inRange` and `limits_ok` can reject and abort TP. Successful admission calls `tpAddLine`; negative return reports bad execution and aborts. A nonzero positive return has separate nonfatal handling; do not collapse all nonzero results into failure.
4. [`tp.c` L2047–2105](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/tp/tp.c#L2047-L2105): `tpAddLine` checks planner state, initializes a linear TC, builds line geometry from `goalPos`, rejects a below-epsilon zero-length segment, handles termination/blending and adds the segment to the queue, then optimizes. `tpRunCycle` [L3401 onward](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/tp/tp.c#L3401) consumes queued TC; empty queue yields `TP_ERR_WAITING`.
5. [`control.c` L1329–1394](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/motion/control.c#L1329-L1394): coordinated mode refills joint cubic interpolators **while** `cubicNeedNextPoint(joint0.cubic)`; each refill runs `tpRunCycle`, obtains `tpGetPos`, applies bounded coordinated external offsets, calls `kinematicsInverse`, validates finite joint coordinates, and calls `cubicAddPoint`. Each controller iteration subsequently calls `cubicInterpolate` to obtain joint position, velocity and acceleration commands. This is **not** necessarily one TP cycle per servo iteration: the while-loop refills when the interpolator needs points. An inverse-kinematics failure sets motion error and disables enabling, rather than silently passing through an invalid joint target.

## Timing and machine implications

`emcmotController(void*, long period)` [control.c L197–237](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76/src/emc/motion/control.c#L197-L237) is called at the realtime control cadence; the `period` is converted from nanoseconds to seconds. Do not infer planner cadence from Task's `CYCLE_TIME`, AXIS display polling, or one G1 per source line. For a mill or router, record `joint.N.motor-pos-cmd` separately from `joint.N.motor-pos-fb` and characterize the feedback source. For a press brake, coordinated setpoints do not replace independent personnel safety, dual-channel axis monitoring, or physical acceptance gates.

## Disconnected prediction/verification matrix (not run)

| Case | Frozen prediction | Observable / discrimination |
|---|---|---|
| A: two collinear G1 blocks | canonical `see_segment` may defer emission; **number of emitted NML commands unknown** until joining rules inspected | count Task-dispatched `EMC_TRAJ_LINEAR_MOVE` vs source blocks |
| B: disabled motion | `EMCMOT_SET_LINE` rejected before TP add | command status INVALID_COMMAND, error flag, TP queue unchanged |
| C: out-of-range end | command rejected; TP abort requested | INVALID_PARAMS and error, not commanded contour |
| D: sub-epsilon length | TP can return nonfatal zero-length result | compare return value and command status; no inferred motion |
| E: inverse kinematics fails | error/disable path before cubic point publication | error and enabling state; no physical machine |
| F: G61 versus G64 P0.1 | potential planner termination/blend differences; **no numeric corner-deviation prediction yet** | TP segment/commanded Cartesian trace with matching units, no actual-position claim |
| G: delayed Task cycle | does not directly set servo period | timestamps for Task dispatch vs servo commanded-position stream |

## Remaining evidence gaps and precise next step

Trace `see_segment` joining and all `flush_segments` triggers, then inspect pinned `tests/interp/g6164` expected outputs and sim AXIS HAL wiring. Freeze a specific G61/G64 numerical/qualitative oracle only after those reads. Reconcile MOTION-144 prior lab evidence and CYCLE-174 error unwind before scheduling any experiment. No builds, tests, Actions, physical machine, or compute this session. MOTION-144 remains blocked by independently verified isolated `[self-hosted, openpressbrake]` runner; no hosted fallback. Closed levels and blind/safety gates unchanged.
