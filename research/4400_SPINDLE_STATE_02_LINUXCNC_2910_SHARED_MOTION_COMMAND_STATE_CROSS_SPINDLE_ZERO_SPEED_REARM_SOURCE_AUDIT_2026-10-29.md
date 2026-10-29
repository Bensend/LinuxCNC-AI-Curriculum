# 4400-SPINDLE-STATE-02 — Shared motion-command state can reassert another spindle's ON flag at zero speed
**2026-10-29 | exact LinuxCNC v2.9.10 source composition | NON-GRADUATED | proposed bounded offline verification NOT RUN**

## Narrow question
Can a speed update for spindle 0 inherit the **ON state last written by a command for spindle 1**, even when spindle 0 was explicitly stopped? The pinned code shows a **source-level possible path**: `taskintf.cc` uses a single static `emcmotCommand`; `emcSpindleOn()` sets its `state=1`, `emcSpindleOff()` sets `state=0`, but `emcSpindleSpeed()` reuses the same `EMCMOT_SPINDLE_ON` command type **without setting state**. Motion's `EMCMOT_SPINDLE_ON` handler copies the inherited state to whichever spindle index the command names. This is a distinct, version-pinned **command-object state aliasing** mechanism beyond the companion [M3 S0 source audit](4400_SPINDLE_ZERO_01_LINUXCNC_2910_M3_S0_ON_BRAKE_RELEASE_AND_LATER_SPEED_REARM_SOURCE_AUDIT_2026-10-29.md).

**Important correction to an overbroad hazard inference:** The canonical `STOP_SPINDLE_TURNING(s)` also sets `canon.spindle[s].dir=0`, so a later standalone S word for a stopped spindle ordinarily emits **zero commanded speed**, not automatically nonzero RPM. The source comment explicitly describes this mitigation. Thus the predicted effect below is a potentially reasserted **ordinary ON/brake-release state at zero speed**, **not proven physical rotation**. The machine-specific electrical and mechanical consequences remain UNKNOWN.

## Source evidence
- **SOURCE-CONFIRMED** [`taskintf.cc` line 80](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/taskintf.cc#L80): `static emcmot_command_t emcmotCommand;` is shared by motion-command writers.
- **SOURCE-CONFIRMED** [`taskintf.cc` lines 1904–1941](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/taskintf.cc#L1904-L1941): `emcSpindleSpeed(s,...)` assigns `command=EMCMOT_SPINDLE_ON`, spindle and velocity, but **not** `state`; `emcSpindleOn(s,...)` assigns `state=1`; `emcSpindleOff(s)` assigns `state=0`. Full-file scan found these as the only explicit `emcmotCommand.state` assignments in this file.
- **SOURCE-CONFIRMED** [`emccanon.cc` lines 1920–1955](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emccanon.cc#L1920-L1955): `SET_SPINDLE_SPEED(s,...)` uses the saved direction to form its signed speed; `STOP_SPINDLE_TURNING(s)` emits `EMC_SPINDLE_OFF` and resets `canon.spindle[s].dir=0`. Its source comment notes a prior second-S-word spindle-start concern.
- **SOURCE-CONFIRMED** [`emctaskmain.cc` lines 1992–2013](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctaskmain.cc#L1992-L2013): `EMC_SPINDLE_SPEED` and `EMC_SPINDLE_ON` dispatch to distinct Task interface functions.
- **SOURCE-CONFIRMED** [`command.c` lines 1576–1622](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/motion/command.c#L1576-L1622): `EMCMOT_SPINDLE_ON` copies the supplied state and velocity to the addressed spindle; if state is nonzero it requests brake release. [`control.c` lines 1927–1936](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/motion/control.c#L1927-L1936) publishes `spindle.N.on` from state independently of speed.
- **SOURCE-CONFIRMED** newer development snapshot `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7`: [`taskintf.cc` around lines 1983–2021](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/task/taskintf.cc#L1983-L2021) retains shared state assignment pattern; [`command.c` lines 1790–1800](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/motion/command.c#L1790-L1800) still copies state and releases brake on ON.
- **DOC-CONFIRMED** [LinuxCNC 2.9 M-code manual](https://linuxcnc.org/docs/2.9/html/gcode/m-code.html) distinguishes M3/M4 and M5 and warns that speed/override changes can later start a spindle. It does not document this internal shared-command-state detail.
- **TEST-CONFIRMED none; COMMUNITY-REPORTED none; INFERENCE** exact multi-spindle command ordering produces an ON-state reassertion; **UNKNOWN** actual runtime, HAL/drive wiring, mechanical brake, physical rotation and independent safety performance.

## Source-derived counterexample to investigate, not a machine instruction
This is a **paper-only** sequence for an isolated simulator or source review; do not issue it to a physical machine:

1. `M5 $0`: spindle 0 is stopped; Task sends state 0; canonical spindle 0 direction becomes 0.
2. `M3 $1`: spindle 1 ON; shared Task command object's state becomes 1.
3. `S500 $0`: canonical spindle 0 speed message uses its zero direction, so expected signed velocity is **0**; Task `emcSpindleSpeed(0,...)` sends `EMCMOT_SPINDLE_ON` without overwriting shared state **1**.
4. Motion handler's source path would set spindle 0 `state=1`, `speed=0`, `brake=0` (release requested); `control.c` would publish `spindle.0.on=1`, `spindle.0.speed-out=0`.

This **source-composed prediction** assumes the stated Task command order and ordinary unremapped M/S handling. It is **not** TEST-CONFIRMED, and it is not a claim that spindle 0 rotates or that any particular VFD/physical brake is unsafe. A single-spindle variant with unrelated commands does not automatically have the same cross-spindle history.

## Why this matters to safety engineering
A machine integrator could wire `spindle.on` as a VFD run/enable signal or `spindle.brake` to a mechanical release circuit. The source-derived state mismatch would then have different consequences depending on the selected wiring, drives and guards. The **safer architecture** is not to patch a normal HAL bit into a safety claim: use independent safety-related stop/restart and physical load retention appropriate to the hazard; in the normal HMI, display requested speed, run state, brake request, actual feedback and safety permit as separate fields. Review multiple-spindle interleaving and command history in addition to a single happy-path M3/M5 sequence.

## Frozen bounded offline question (do NOT dispatch hosted compute)
**Question:** Under pinned v2.9.10 with two simulated spindles and the exact source-derived sequence, does `spindle.0.on` return HIGH with `spindle.0.speed-out=0` after the S word, while `spindle.1.on` remains HIGH? Record Task command sequence and motion HAL state before/after each block. Include a single-spindle M5→S control. This answers a real source-to-runtime uncertainty, not a generic exercise.

**Execution gate:** no workflow unless the repository can dispatch a local self-hosted runner labeled `[self-hosted, openpressbrake]` **and** the panel PC is verified physically isolated from any connected hazardous machine I/O. Do not use GitHub-hosted runners, do not operate a machine, and do not mark TEST-CONFIRMED from a paper trace. If blocked, leave this as a precise checkpoint and continue source/documentary safety work. Do not add LAB_COMPUTE_LOG runtime without actual job timestamps.

## Gate status
No independent 2520–25F0 evaluator or qualified OpenPressBrake Stage A A–G physical evidence. G0/G1 HOLD; no personnel-exposed hazardous operation authorized. No new graded competency.
