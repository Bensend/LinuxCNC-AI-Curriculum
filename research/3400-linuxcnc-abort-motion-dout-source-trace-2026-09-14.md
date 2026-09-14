# 3400 — LinuxCNC abort behavior for custom ATC motion digital outputs

Date: 2026-09-14
Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Status: **SOURCE-CONFIRMED authority boundary + upstream toolchanger regression comparator**

## Purpose

The FENJA/Groot router ATC drives its pneumatic drawbar through `motion.digital-out-01` using immediate M64/M65 commands. Its machine-specific ON_ABORT hook is commented out. The important generic question is therefore: **what does LinuxCNC itself clear on Task/motion abort, and can a custom M6 remap assume its arbitrary motion digital output is reconciled?**

This trace deliberately separates LinuxCNC's built-in `iocontrol.0.tool-change/tool-prepare` handshake from user-selected `motion.digital-out-NN` process outputs.

## 1. Immediate M64/M65 path

The motion command API defines `EMCMOT_SET_DOUT` as a digital-I/O command that may be immediate or synchronized with motion.

`taskintf.cc` constructs the `EMCMOT_SET_DOUT` command and passes the `now` flag. In realtime motion command handling, the immediate branch calls:

`emcmotDioWrite(emcmotCommand->out, emcmotCommand->start)`

Thus an M64-style command is not merely interpreter-local state; it becomes a current Motion digital-output value.

The same output facility is also handed to the trajectory planner for synchronized M62/M63 events, which is why immediate-current-state and queued-future events must be reasoned about separately.

## 2. `emcTaskAbort()` clears execution state and asks Motion to abort

At the pinned revision, `emcTaskAbort()`:

1. calls `emcMotionAbort()`;
2. clears the pending Task command and interpreter queue;
3. marks interpreter execution idle/done;
4. clears pause/line/call-level state;
5. queues interpreter resynchronization;
6. closes/resets the task plan.

This is broad execution-state cleanup, but this function itself contains no loop that writes all `motion.digital-out-NN` pins low.

## 3. Motion `EMCMOT_ABORT` stops motion; its inspected case does not clear current DOUT values

`emcMotionAbort()` ultimately issues `EMCMOT_ABORT` to realtime Motion.

The `EMCMOT_ABORT` case in `src/emc/motion/command.c`:

- aborts teleop jogging, coordinated trajectory planning, or free/joint planners according to active mode;
- cancels homing where relevant;
- clears motion/joint fault/error state;
- clears paused and pending at-speed-barrier state;
- clears a set of interpreter-geometry diagnostic HAL pins.

In the inspected case there is **no call to `emcmotDioWrite()` and no loop resetting the current Motion digital outputs**.

This source result is narrower than saying “a DOUT always survives every imaginable reset.” Other state changes such as E-stop, motion module initialization, machine restart, HAL component teardown, or explicit application logic can impose different output states. But a plain `EMCMOT_ABORT` does not itself provide the custom ATC with an explicit all-DOUT-low cleanup contract.

## 4. `emcIoAbort()` clears the built-in toolchanger handshake, not arbitrary Motion DOUT

Task's in-process I/O layer has separate abort handling in `Task::emcIoAbort()`.

On Task abort it explicitly:

- turns coolant mist/flood off;
- sets `iocontrol.0.tool-change` false;
- sets `iocontrol.0.tool-prepare` false;
- releases the pending I/O status to DONE.

An upstream regression test, `tests/toolchanger/abort-during-change/test-ui.py`, exists specifically because aborting during tool prepare/change used to leave I/O status stuck. Its comments state that `emcIoAbort()` now drops the **tool-prepare/tool-change output pins** so the state can return to `RCS_DONE`.

This is strong independent upstream-test evidence for the built-in iocontrol handshake cleanup.

It is **not** evidence that `motion.digital-out-01` used by a custom remap is cleared. `Task::emcIoAbort()` does not write arbitrary Motion DOUT pins in the inspected implementation.

## 5. Why this matters for router ATC design

There are two different output namespaces/ownership models:

### Built-in toolchanger handshake

`Task/iocontrol -> iocontrol.0.tool-prepare / tool-change -> external changer acknowledgement`

LinuxCNC has explicit abort cleanup and regression coverage for those handshake outputs.

### Custom process output in G-code/remap

`M64/M65 -> EMCMOT_SET_DOUT -> motion.digital-out-NN -> custom HAL/actuator logic`

The current DOUT state is owned through Motion's digital-output path. A generic Task/motion abort stops execution and movement, but the inspected abort paths do not provide a matching explicit `motion.digital-out-NN = 0` reconciliation step.

Therefore a custom ATC that uses a motion DOUT for drawbar release must **design its own physical-output/recovery contract** instead of assuming built-in iocontrol abort semantics apply to that signal.

## 6. Upstream remap documentation independently points toward machine-specific abort cleanup

LinuxCNC remap documentation supports an `[RS274NGC] ON_ABORT_COMMAND` and describes the suggested abort procedure as something to **adapt to your needs**. The remap examples also stress resetting state after failed remaps.

This is consistent with the source result: a remap that changes machine-specific actuator state has machine-specific reconciliation work to perform.

The FENJA/Groot config contains an `on_abort.ngc` file, but its INI hook is commented out at the inspected revision, and the file itself only restores G90/G40/G49. It therefore does not provide such actuator reconciliation.

## 7. Correct bounded conclusion

### SOURCE-CONFIRMED

- `EMCMOT_ABORT` stops/cancels motion according to mode and resets motion execution/error state.
- `Task::emcIoAbort()` explicitly clears the built-in `iocontrol.0.tool-change` and `iocontrol.0.tool-prepare` outputs.
- upstream regression testing exists for that built-in toolchanger abort behavior.
- the inspected Motion-abort and Task-I/O-abort paths do not explicitly clear arbitrary current `motion.digital-out-NN` values.

### NOT YET CLAIMED

- that every M64-set DOUT necessarily stays high after every user-visible Abort button path;
- that machine OFF, E-stop, realtime module unload, startup or hardware watchdog behave identically;
- that queued M62/M63 events survive `tpAbort` in the same way as an already-applied immediate M64 state.

Those are separate questions and should be tested/traced only if they affect a concrete machine contract.

## 8. Implication for FENJA/Groot

A credible recovery design around the public config would need to decide, from actual physical state, whether to:

- command the drawbar closed or leave it open;
- inhibit further rack motion;
- clear/reassert the automatic ATC request;
- reconcile tool-present and drawbar sensors;
- reconcile LinuxCNC's logical tool number and pocket provenance;
- invalidate/re-run tool-length measurement.

Blindly forcing the drawbar closed on every abort can itself be wrong if the spindle is midway through depositing/picking a tool or if closure would collide with rack mechanics. Hence “reset all outputs” is not automatically the correct recovery state machine either. **Observation and state-specific reconciliation are required.**

## Adversarial review — 9/9

1. Does `emcTaskAbort()` directly clear all Motion DOUT pins? **No such loop exists in the inspected function.**
2. Does realtime `EMCMOT_ABORT` explicitly write all DOUTs low? **No in the inspected abort case.**
3. Does `emcIoAbort()` clear anything relevant to toolchange? **Yes: built-in iocontrol tool-change/tool-prepare handshake outputs.**
4. Is that enough to claim a custom M64 drawbar output is cleared? **No; it is a different output/ownership path.**
5. Is built-in toolchanger abort cleanup independently exercised upstream? **Yes; an upstream abort-during-change regression test exists.**
6. Does this prove an M64 output persists through E-stop or machine power-off? **No. Those are separate transitions.**
7. Does the absence of generic DOUT cleanup mean the correct fix is always `M65` in ON_ABORT? **No; physical intermediate state may make unconditional clamp/release unsafe or logically wrong.**
8. Should recovery reconcile logical tool identity and tool-length validity as well as the actuator? **Yes.**
9. Is a lab now justified? **A bounded abort/DOUT lab is now a legitimate candidate because source has isolated a concrete user-visible uncertainty, but comparison with another production ATC recovery design remains useful first.**

## Promotion / next work

1. Inspect a second router ATC with explicit interrupted-cycle recovery or actuator cleanup.
2. If that does not resolve the practical behavior, freeze a small LinuxCNC lab comparing an already-applied M64 DOUT across program Abort, machine OFF and E-stop, while separately observing iocontrol tool-change pins. This would add independent evidence rather than duplicate source inspection.
3. Continue 3400 breadth with vacuum/dust/workholding and gantry squaring rather than allowing ATC recovery to monopolize the track.
