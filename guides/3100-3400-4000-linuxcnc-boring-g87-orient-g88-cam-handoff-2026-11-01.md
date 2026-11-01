# 3100/3400/4000 — LinuxCNC G86/G87/G88 boring and spindle-orient CAM handoff
**2026-11-01 | implementation walkthrough | SOURCE/DOC-CONFIRMED; NOT RUN**

## What this guide teaches
A fresh AI integrator must distinguish **interpreter acceptance**, **canonical commands**, **Task command completion**, **spindle orientation acknowledgement**, **physical spindle speed**, and **tool clearance**. None of those is interchangeable. The primary source traces are [BORING-122](../research/4400_LINUXCNC_BORING_122_G87_ORIENT_ENUM_MODE_AND_MISSING_WAIT_SOURCE_AUDIT_2026-11-01.md) and [BORING-123](../research/4400_LINUXCNC_BORING_123_G88_MANUAL_RETRACT_AND_G86_SPINDLE_STOP_SOURCE_AUDIT_2026-11-01.md).

## Practical CAM-post policy
| Cycle | Stable/development interpreter command behavior | Recommended generic post disposition |
|---|---|---|
| G85 | Feed to bottom, feed to R, rapid to clear | Allowed only with verified units, depth, feed, retract plane, workholding and tool geometry |
| G86 | Feed, dwell, STOP spindle, rapid retract, restart | **Review required**: no explicit shaft-zero witness before rapid |
| G87 | Offset rapid, STOP+ORIENT, rapid through hole, feed up/down, STOP+ORIENT, offset/clear rapid, restart | **Reject by default**: both official references call it undefined; no explicit orientation-complete wait; orientation enum/mode mismatch |
| G88 | Feed, dwell, STOP, PROGRAM_STOP, restart; **no automatic retract** | **Reject by default**: official reference says undefined; manual retraction not controller-verified |
| G89 | Feed, dwell, feed retract | Use only after feed-path/geometry verification |

A controller accepting G-code does not make a cycle suitable for a machine. For G87, do not merely replace an `ORIENT_SPINDLE` call with an M19 without checking the separate Q timeout and `spindle.N.is-oriented` feedback path.

## Minimal source-reproducible example (analysis only; NEVER send to a physical CNC)
For a G17 metric standalone interpreter with trusted simulated coordinates and no real HAL hardware, compare the conceptual input:

```ngc
G21 G17 G90 G94 G40 G49 G80
G0 X0 Y0 Z20
S500 M3
G87 X10 Y10 Z-5 R5 I1 J0 K-2 F100
G80
M5
M2
```

The source-derived **G87 internal order** (not an observed trace) is:
1. Move to lateral offset (X11,Y10) at R5; STOP spindle; ORIENT to 0° with raw enum mode 2 for M3.
2. Rapid at offset to Z-5; rapid laterally to X10,Y10; START spindle; feed to K-2; feed back to Z-5.
3. STOP; ORIENT again; rapid laterally to X11,Y10 at Z-5; rapid to clear plane; rapid laterally to X10,Y10; START.

The actual `clear_z` depends on G98/G99 and initial-level state. These coordinates presume G17/G90 and no existing offsets; `R5 > Z-5`. This is a **frozen analytical discriminator**, not validated G-code and not permission to machine a bore.

For G88, compare a separate standalone-only input `G88 X10 Y10 Z-5 R5 P0.1 F100` with G89. G88 emits PROGRAM_STOP after STOP and **does not command a retract**; the G89 counterpart commands a feed retract. A UI pause/resume does not independently prove manual withdrawal.

## Cross-layer review procedure
1. Pin controller version and [`interp_cycles.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_cycles.cc) before selecting any native cycle. Check the official G-code reference's G87/G88 undefined warning.
2. Record `convert_cycle_g87` calls, `CANON_DIRECTION` numeric values, `ORIENT_SPINDLE` and `WAIT_SPINDLE_ORIENT_COMPLETE` as separate canonical operations.
3. Inspect `emctaskmain.cc` ORIENT pre/postconditions and explicit WAIT completion state; never interpret a motion/IO drain as an orientation-ready signal.
4. Check actual HAL orientation implementation: stable stock `orient.comp` mode 3 is unhandled; development stock mode 3 initiates index search. A custom component may behave differently.
5. For a real machine configuration, inventory encoder index, spindle standstill feedback, `spindle.N.orient`, `spindle.N.is-oriented`, `spindle.N.orient-fault`, `spindle.N.orient-mode`, spindle brake, tool-clearance geometry and the independent protective system. Mark absent evidence UNKNOWN.
6. If isolated `[self-hosted, openpressbrake]` compute is qualified and physically disconnected, compare standalone canonical traces for M3 and M4 G87; run HAL-only mode 2/3 simulation; inspect Task state with delayed is-oriented/index. Capture actual output, exit status, exact binary SHA, configuration and authoritative job start/end.
7. Keep source predictions separate from observed tests and hardware acceptance; do not dispatch hosted Actions or run physical boring tests as part of this curriculum.

## Diagnostic questions for a fresh AI
- A post uses M4 before G87. Which integer reaches the stock orientation component? What does that mean on stable versus development?
- An operator sees `spindle.N.orient=1` after G87. Is that proof the spindle has reached its target? Identify the separate status/wait consumer.
- A post labels G88 as “stop, retract, resume.” Which of those verbs is **not** a commanded axis movement in the inspected interpreter?
- A G86 spindle command stops but a VFD takes 3 seconds to coast down. Which part of the canonical sequence verifies physical zero speed before rapid?
- If the official reference says G87 is undefined, why can a standalone interpreter still emit a deterministic canonical trace? Distinguish public support contract from implementation behavior.

**Scope:** source-grounded implementation learning only, not machine-safety authorization. Independently verified personnel protection remains separate. Graduated 3000 levels stay CLOSED.
