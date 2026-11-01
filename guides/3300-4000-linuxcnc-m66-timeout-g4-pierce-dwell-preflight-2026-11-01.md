# 3300/4000 implementation walkthrough — M66 timeout followed by G4 pierce delay

**Scope:** LinuxCNC Task interpreter → canonical M66/G4 → Task `WAITING_FOR_DELAY` → `#5399`; transfer to plasma torch Arc OK and other process sequencing. **Evidence:** source-grounded only, **all runtime cases NOT RUN**. Do not deploy the fixtures to a machine.

## Learning objective

A fresh LinuxCNC implementer should be able to explain why **G4 is not guaranteed independent of a preceding timed-out M66** in the inspected revisions, locate the Task state responsible, construct a discriminating disconnected test, and specify what an upstream correction must preserve. The lesson is about LinuxCNC normal program sequencing, not the safety course.

## Read the pinned sources in order

1. Interpreter [M66 `Interp::convert_m`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L3317-L3384) validates digital P, wait L and Q, calls canonical WAIT, and sets `input_flag`.
2. Canonical [`WAIT`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L3277-L3306) queues `EMC_AUX_INPUT_WAIT`; canonical [`DWELL`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1849-L1857) queues `EMC_TRAJ_DELAY`.
3. Task [M66 initialization](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L1923-L1938) arms static input index; [G4 initialization](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L1872-L1878) only resets deadline; [postcondition](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2492-L2498) maps **both** to the same wait state.
4. Task [`WAITING_FOR_DELAY`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2737-L2792) completes a timeout without clearing the input index, then continues checking the index even during G4.
5. Interpreter [`#5399` read](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/rs274ngc_pre.cc#L1459-L1472) consumes timeout state but does not clear the Task static index.

Read the detailed [M66-138 stale-state investigation](../research/4400_LINUXCNC_M66_138_TIMEOUT_STALE_WAIT_TRUNCATES_G4_DWELL_SOURCE_AUDIT_2026-11-01.md) and [M66-139 deadline precedence](../research/4400_LINUXCNC_M66_139_TIMEOUT_BOUNDARY_LAST_WRITER_TASK_POLL_SOURCE_AUDIT_2026-11-01.md) before interpreting any trace. Earlier [M66-01](../research/4400_LINUXCNC_M66_WAIT_TIMEOUT_AND_NONSAFETY_INPUT_AUTHORITY_AUDIT_2026-10-27.md) already teaches timeout handling; this exercise is specifically the **cross-command state leak**.

## Real source integration: plasma

The upstream [`nc_files/touchoff.ngc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/nc_files/touchoff.ngc#L1-L19) contains `M66 P0 L1 Q5` immediately followed by `G4 P#2` and a cut-height move. A controller reading this sequence should not assume that the pierce delay remains independent of an Arc OK signal arriving **after the M66 timeout**. The source alone does not prove the program is installed, used unmodified, or has ever exhibited this behavior. Modern QtPlasmaC uses a different process state machine; do **not** transfer the finding to all QtPlasmaC installations without tracing the selected config.

## Bounded disconnected experiment contract

Use a **positively qualified, physically disconnected** `[self-hosted, openpressbrake]` environment, pinned stable v2.9.10 and (separately) development `06864e23559e70463fc7112d5ce77138bcbc288c`. Do not use GitHub-hosted runners, live torch, stepgens, physical spindle, real Mesa output, or production machine. The fixture requires an actual simulated HAL signal feeding `motion.digital-in-00`; simply leaving a pin disconnected cannot demonstrate the delayed transition. Capture binary/build SHA, exact INI/HAL, simulated signal timestamps, Task state transitions, program `(DEBUG,...)` output, interpreter `#5399`, process exit and authoritative job start/end.

**Frozen comparison:**

| Case | Input timing | G-code | Expected discriminator |
|---|---|---|---|
| A | LOW through Q0.5; HIGH ~1 s into G4 | [M66→G4](../examples/4000_m66_dwell/m66_timeout_then_g4.ngc) | Saved `#5399=-1`; G4 may return before P4 |
| B | LOW through Q0.5; remains LOW through P4 | same | G4 should consume its P4 deadline |
| C | LOW through Q0.5; HIGH ~1 s into G4 | [M66→L0 reset→G4](../examples/4000_m66_dwell/m66_timeout_clear_then_g4.ngc) | Saved original `#5399=-1`; L0 clears stale Task index; G4 should consume P4 |
| D | HIGH from start | A fixture | M66 L3 success clears index; G4 should consume P4 |
| E | No M66 | simple `G4 P4\nM2` | Baseline Task dwell |

The `M66 P0 L0` in C is a **diagnostic control only**, not a suggested production workaround: it overwrites `#5399` and relies on current implementation details. For normal production logic, explicitly check the result of each M66 and **abort or handle timeout before continuing a process that requires a successful wait**. If a dwell must execute after a timeout as part of a recovery routine, independently validate its timing rather than assuming the old input watcher has been disarmed.

**Instrumentation:** record each Task pass with monotonic time, active command type, `emcAuxInputWaitIndex`, `emcAuxInputWaitType`, `taskExecDelayTimeout`, `input_timeout`, `execState`, `synch_di[0]`, and interpreter read of `#5399`. Distinguish actual Task completion time from delayed GUI/terminal display. For deadline tie [M66-139](../research/4400_LINUXCNC_M66_139_TIMEOUT_BOUNDARY_LAST_WRITER_TASK_POLL_SOURCE_AUDIT_2026-11-01.md), separately inject input changes on either side of the Q boundary; do not infer physical edge time from Task's last-writer flag.

## Failure diagnosis and correction review

If A returns early and B/C/D/E do not, the strongest causal explanation is the stale `emcAuxInputWaitIndex` surviving M66 timeout. If A does **not** return early, inspect whether the chosen HAL signal was actually sampled, whether a remap or Task initialization cleared the index, whether the test hit the intended wait mode, and whether the trace observed the correct command. A green workflow exit alone is insufficient. A patch candidate must clear M66 ownership on timeout **without losing the `#5399=-1` result**, and must avoid reusing an old input watcher for G4. Add a Task-level regression before considering a source change.

## Adversarial transfer questions (not scored as a blind evaluation)

- A plasma CAM post adds a four-second pierce dwell after an M66 timeout, but it does not check `#5399`. Which **Task static field**, not which G-code parameter, can shorten the dwell?
- An M66 L1 wait times out while input is LOW. Why may a later LOW→HIGH transition shorten a subsequent G4, even though the M66 already reported -1?
- A proposed fix clears `input_timeout` when the M66 Q deadline expires. Why would that corrupt the interpreter's required timeout result?
- A fixture with no simulated HAL input transition reports a full G4. Does that falsify M66-138? **No**: it did not exercise the stale input success path.

## Evidence and authority

Source/doco: stable v2.9.10 and pinned development. **TEST-CONFIRMED none**; fixture and simulated HAL experiment **NOT RUN**; no physical machine, safety circuit, independent evaluator, or Actions compute. Independent personnel safety remains outside M66/G4; existing OpenPressBrake G0/G1 HOLD and graduated levels unchanged. Next [checkpoint](../checkpoints/20261101T223600Z-4000-linuxcnc-m66-dwell-next.md).
