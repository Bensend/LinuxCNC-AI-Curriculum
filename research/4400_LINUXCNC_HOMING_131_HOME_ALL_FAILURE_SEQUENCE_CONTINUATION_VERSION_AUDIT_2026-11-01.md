# 4000-LC-HOMING-131 — Home All failure is not necessarily a sequence-wide stop (stable vs development)

**Audited:** 2026-11-01 UTC. **Scope:** LinuxCNC realtime homing coordinator, 3100 mills/routers/gantries and 3500 multi-joint transfer. **Status:** SOURCE-CONFIRMED control flow; conditional runtime predictions **NOT RUN**; NON-GRADUATED.

## Why this is incremental

[HOMING-90](4400_LINUXCNC_HOMING_90_BOUNDED_MOVE_ABORT_FANOUT_SOURCE_AUDIT_2026-11-01.md) already establishes the development-wide `HOME_ABORT` invalidation and bounded search/latch return; [HOMING-27](4400_LINUXCNC_HOMING_27_HOME_ALL_JOINT0_NO_REHOME_AND_UNSEQUENCED_JOINT_SOURCE_AUDIT_2026-10-31.md) already establishes Home All's joint-0 special case. **Neither is being rediscovered.** This audit traces the *coordinator's next-sequence decision after a failed member*, and the distinct `HOME_IS_SHARED` precondition branch. The new implementation question is whether a failed earlier sequence prevents later joints from beginning homing.

## Pinned primary sources

- Stable LinuxCNC **v2.9.10** commit `86cdca76fa2a36274c432caa21952b23c267989a`: [`src/emc/motion/homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/motion/homing.c), blob `13f74f43a1169606e87c7bd8d48f44a2cad6fa74`, `do_homing_sequence` lines 329–488, `HOME_START` 754–792, `HOME_ABORT` 1354–1362, `base_do_homing` 1377–1400.
- Development commit `06864e23559e70463fc7112d5ce77138bcbc288c`: [`src/emc/motion/homing.c`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/homing.c), blob `adec003afe19a0ea0eae3c565c9d4bb708a0a5e6`, `do_homing_sequence` 413–571, `HOME_START` 864–904, `HOME_ABORT` 1520–1530, `base_do_homing` 1545–1570.
- [Stable official homing INI documentation](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/config/ini-homing.adoc), blob `1793d78d3f450c2a66bd96f54923a1be61b0a937`, `HOME_SEQUENCE` lines 247–318, `HOME_IS_SHARED` 222–226. Development [homing documentation](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/config/ini-homing.adoc), blob `623769ebf8532130bce5cf77cd60fc42bbcd9620`.
- Real **upstream simulator configuration**, not an installed machine: [`configs/sim/axis/gantry/gantry.ini`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/configs/sim/axis/gantry/gantry.ini), blob `ca49f1ce8ec381064dd6d38c364537914793369a`: joint 0 X sequence 0, joints 1 and 3 duplicated Y sequence -1, joint 2 Z sequence 2.

## End-to-end realtime state path

Task's accepted Home All command enters motion's `do_home_joint(-1)` / `do_home_all()`, setting `sequence_state=HOME_SEQUENCE_START`. In the servo controller `do_homing()` calls `do_homing_sequence()` **before** running participating joints' `base_1joint_state_machine()` for that period (development lines 1551–1557; stable analogous).

`HOME_SEQUENCE_START_JOINTS` selects joints with `ABS(home_sequence)==current_sequence` and `joint_in_sequence=true`, sets their state to `HOME_START`, then enters `HOME_SEQUENCE_WAIT_JOINTS`. On later cycles, WAIT considers a member unfinished **only if** `home_state != HOME_IDLE`. It does **not** require `homed=true`, inspect a per-sequence failure latch, or inspect the error log. When no included member remains busy, it increments `current_sequence` and schedules the next group.

**Stable failure path A — closed shared home switch:** `HOME_START` checks `HOME_IS_SHARED && home_sw_active`, logs `Cannot home while shared home switch is closed`, sets only that joint's `home_state=HOME_IDLE`, and breaks (stable lines 758–762). It does not invoke `HOME_ABORT`. At the next coordinator WAIT, this idle joint no longer blocks the sequence. With the upstream gantry ordering, the Y group (-1) can start despite X's failed precondition; Z (2) can follow after Y completes. `get_allhomed()` remains false because X is unhomed. **This is a conditional command-path prediction, not observed motion.**

**Stable failure path B — an actual HOME_ABORT:** `HOME_ABORT` clears `homing/homed/joint_in_sequence/index_enable` and disables `free_tp` for the failing joint **only** (lines 1354–1361). WAIT skips it (no longer in sequence), so other current-sequence members may finish and later sequence numbers may be started. This differs from the already-documented abort fanout, and specifically adds the *coordinator continuation* consequence.

**Development failure path A/B:** Development's closed shared-switch branch enters `HOME_ABORT` immediately (lines 869–874), unlike stable's direct IDLE. Development `HOME_ABORT` clears `joint_in_sequence` and `homed` for **all** joints and disables all their free planners (lines 1520–1528). The coordinator's `sequence_state` is not directly set to IDLE by this abort, but WAIT subsequently finds no participating members and START_JOINTS finds no later eligible `joint_in_sequence` members. Thus the existing Home All is predicted to drain to IDLE **without starting later sequence groups**. Do not mistake the incrementing sequence counter for evidence that a later joint actually starts.

## State transition oracle (source-derived, NOT RUN)

Assume an accepted `home(-1)` in a disconnected four-joint gantry, X sequence 0, Y1/Y2 -1, Z 2, X `HOME_IS_SHARED=1` and X home switch already active; all start unhomed. Other switches are normal.

| Stage | Stable 2.9.10 | Development 06864e |
|---|---|---|
| X HOME_START | Error; X -> IDLE directly; X not homed | Error; X -> HOME_ABORT -> IDLE; all joints unhomed and removed from active sequence |
| Subsequent WAIT for sequence 0 | Sees X IDLE; increments to 1 | Sees no included joints; increments to 1 |
| START_JOINTS at sequence 1 | Y1/Y2 remain included; **may start** synchronized homing | Y1/Y2 `joint_in_sequence=0`; **not started** |
| Later Z sequence 2 | May start if Y group finishes and no other fault | Coordinator reaches IDLE before starting Z |
| Final all-homed | **False** (X failed) | **False** (all flags cleared) |

The comparison is conditional on accepted Task command, joint activity, valid sequence numbers, and simulated switch signals. It does **not** assert physical motion, that all UIs present the same completion status, or that a later normal-control homing move is independently safe.

## Diagnostic and implementation lessons

- `homing_active=false` is not synonymous with `allhomed=true`, and `home_state=IDLE` is not synonymous with `homed=true`. The coordinator uses the first, not the second, to advance.
- A Task/NML command being accepted is not evidence that every group homed or that no subsequent group started after a fault.
- For any machine that requires *fail-stop Home All sequencing*, inspect and verify this behavior on the exact controller revision. A GUI-level assumption that an error message cancels all subsequent homing is not sufficient.
- HAL `joint.N.home-sw-in`, `joint.N.homing`, `joint.N.homed`, `joint.N.home-state`, and `motion.homing-inhibit` are normal control/diagnostic interfaces; independent machine/personnel safety authority remains separate.
- Negative `HOME_SEQUENCE` coordinates the final move of paired joints; it does not by itself add a fail-stop error latch to the whole sequence.

## Falsifiers and evidence debt

1. **TEST NOT RUN:** Clone the pinned upstream `gantry.ini` into a disconnected simulator, add X `HOME_IS_SHARED=1`, assert its home switch before `home(-1)`, and record the four joint state transitions, Task errors, and `homing_active`/all-homed status. Compare stable/development binaries with exact SHAs. If stable does not start Y under stated preconditions, inspect Task inhibit, simulation HAL input, and the actual per-cycle `joint_in_sequence` values before revising the source hypothesis.
2. **TEST NOT RUN:** Repeat with X failing after beginning search (e.g. controlled missing switch / bounded development search) to distinguish stable per-joint `HOME_ABORT` from development global `HOME_ABORT`. Do not call a harness that cannot expose coordinator state a negative result.
3. **UNKNOWN:** GUI-specific error/completion presentation and whether any machine integrator has an external fail-stop interlock. No such external behavior is inferred from the stock `homing.c`.
4. **NOT GRADUATED:** No build, simulator, HAL execution, machine operation, independent blind evaluation or Actions compute was performed. The [practical verification guide](../guides/3100-3500-4000-linuxcnc-home-all-failure-sequencing-disconnected-preflight-2026-11-01.md) is an unexecuted protocol.

**Provenance distinction:** SOURCE-CONFIRMED branches and state mutations; DOC-CONFIRMED HOME_SEQUENCE/IS_SHARED meaning; INFERENCE about the later servo-cycle sequence and resulting simulator trace; TEST-CONFIRMED none. This extends HOMING-90 rather than replacing its global-abort evidence.
