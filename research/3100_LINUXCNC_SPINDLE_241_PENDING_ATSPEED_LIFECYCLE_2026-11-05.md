# SPINDLE-241 — pending spindle-at-speed flag lifecycle in LinuxCNC v2.9.10 (2026-11-05)

**Track:** 3100 mills, transferable to 3200 turning. **Status:** SOURCE-CONFIRMED for enumerated source paths; potential M3→M5→feed wait remains an **UNTESTED INFERENCE**. NON-GRADUATED.

## Provenance

Read immutable tagged LinuxCNC `v2.9.10` with GitHub repository connector. `src/emc/motion/command.c` blob **0b79061d39be915bbea548b2c33bb794d31ab302**, `src/emc/motion/control.c` **b6e45d590c7d11030654d8f7d13d118f581b6439**, `src/emc/motion/motion.c` **febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841**, `src/emc/motion/motion.h` **f789f59cda93502e35e5ee156e6254d1d6591629**. Full-file exact-string enumeration of `atspeed_next_feed` in these four files was performed; it does not prove absence in every file in the repository or in compiled alternate versions.

## Mechanism and evidence

1. [command.c L1577–1628](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1577-L1628): `EMCMOT_SPINDLE_ON` assigns the **global**, not per-spindle, `atspeed_next_feed = wait_for_spindle_at_speed` after updating the selected spindle. A later spindle-on with wait=0 overwrites the flag.
2. [command.c L1630–1659](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1630-L1659): `EMCMOT_SPINDLE_OFF` resets selected spindle's command state, speed, direction, brake and orientation, **but does not assign this flag**. M5's absence of assignment alone does not prove a real stall.
3. [command.c L493–531](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L493-L531): `EMCMOT_ABORT` stops motion according to active mode, clears motion/joint errors and pause, **but has no direct assignment to the pending flag**. Indirect initialization, Task ordering and TP state transitions remain to be checked.
4. [command.c L1016–1051](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1016-L1051): an eligible feed-type linear move consumes the pending flag and passes `issue_atspeed` into `tpAddLine`; non-feed linear movement with nonzero spindle CSS factor re-arms it. A nonfatal add failure restores the flag. The flag is cleared **before** the add attempt, and the negative-error path does not restore it.
5. [command.c L1082–1108](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1082-L1108): circular motion consumes the flag **without the explicit `is_feed_type` test used for linear motion**, passes it to `tpAddCircle`, and restores it on a nonfatal add result. This is a source-level asymmetry worth verifying with an interpreter-generated command sequence; ordinary G2/G3 are feeds.
6. [command.c L1507–1522](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1507-L1522): the negative-error path for rigid tapping explicitly clears the pending flag; its comment says rigid tap always waits for spindle at speed. Do not infer from this comment alone how the successful tap TP path gates speed.
7. [motion.h L651](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.h#L651) declares the status field as `int`. Neither inspected `control.c` nor `motion.c` contains the literal field name. This is **not** a proof about initialization by zeroing a whole structure.

## Diagnostic implications and bounded predictions (NOT EXECUTED)

**P1:** In a disconnected simulation, M3 (default wait=1) → M5 → eligible G1 without intervening spindle-on should hand a waiting requirement to the TP if no intervening indirect reset occurs. With `spindle.0.at-speed=0`, a queued segment may remain blocked; with at-speed=1 it should proceed. This is conditional on actual Task/interpreter command ordering and TP behavior; **not a reproduced bug**.

**P2:** M3 → M5 → M3 with wait=0 should replace pending=1 with 0 if the two ON commands reach motion in that order. A normal G-code M3 defaults to wait=1, so an explicit canonical/API fixture is needed to exercise wait=0.

**P3:** An eligible linear feed consumes pending=1 once. Subsequent feed without CSS re-arm should not inherit it; an intervening CSS traverse may re-arm it.

**P4:** An `EMCMOT_ABORT` after M3 does not directly clear pending. Whether higher-level reset or machine-mode transitions prevent a later wait is still unknown.

**P5:** For zero-length or otherwise nonfatally rejected feed insertion, pending is restored; for a negative TP add result it is not. Different error categories should not be conflated.

## Reproducible inspection and safe test design

```sh
git checkout v2.9.10
git grep -n 'atspeed_next_feed' -- src/emc
sed -n '493,531p;1016,1051p;1082,1108p;1507,1522p;1577,1659p' src/emc/motion/command.c
```

Before creating any new job, search `LAB_COMPUTE_LOG.md`, `lab-jobs/`, `lab-results/`, prior research and upstream tests for spindle-at-speed / M3-M5 / next-feed equivalents. For a new test, use **only** an isolated disconnected simulation on a justified runner labelled both `self-hosted` and `openpressbrake`; never hosted Actions or real hardware. Freeze a predeclared oracle comparing first-feed TP activation with at-speed held low/high and a control sequence without M5. Capture interpreter/Task command ordering and realtime HAL states, not just GUI motion appearance. A hanging wait requires a bounded timeout and recorded abort behavior.

## Evidence ledger / unresolved

**SOURCE-CONFIRMED:** exact assignments and missing direct assignments within inspected cases, line/circle differences, negative vs nonfatal add paths, global field. **INFERENCE:** M3→M5 may leave a pending wait, depending on command and TP lifecycle. **UNKNOWN:** complete repository-wide initialization/reset paths, actual M3/M5 ordering and runtime stall, real Mesa ATC configuration, physical feedback integrity. No build, test, simulation, compute, Actions, or machine operation performed.

**Next:** inspect status structure initialization and motion reset paths, then trace Task/TP behavior for M3→M5→G1. Prefer an independently inspectable Mesa ATC HAL/INI for the tool-change handshake; otherwise rotate to 3200 G33/G76 index/phase rather than extending speculation. Keep blind/graduation/personnel-safety gates intact.
