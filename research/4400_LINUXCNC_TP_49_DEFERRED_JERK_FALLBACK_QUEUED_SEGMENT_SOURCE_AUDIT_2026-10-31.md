# 4000-LC-TP-49 — Deferred planner fallback can outlive jerk recovery during queued motion

**2026-10-31 | development-only | NON-GRADUATED | SOURCE-CONFIRMED conditional sequence; NOT RUN.** Extends [TP-47](4400_LINUXCNC_TP_47_DYNAMIC_JERK_PLANNER_FALLBACK_NO_AUTO_RESTORE_SOURCE_AUDIT_2026-10-31.md) with a distinct **queue-busy timing case** and the per-segment planner fallback. It does not claim that every moving segment violates jerk constraints.

## Immutable source provenance

Pinned LinuxCNC development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`:
- [ini/inihal.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/ini/inihal.cc), blob `e6a7d2ab1756bd9e81fd3ce894fb76a0ad23b046`, `check_ini_hal_items` ~295–340.
- [motion/command.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c), blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`, `planner_switch_motion_idle` ~100–105, `emcmotApplyPendingPlannerType` ~109–120, `EMCMOT_SET_JERK` ~1244, `EMCMOT_SET_PLANNER_TYPE` ~1250–1293.
- [motion/control.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/control.c), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`, `emcmotController` ~271–274 calls pending-apply once per servo cycle.
- [tp/tp.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tp.c), blob `2b4024c9ab131f708cc22760300231878c9b0fdc`, selector-dependent optimization ~1733/1768, `tpCalculateSCurveAccel` jerk guard ~2783–2802, fallback path ~3893–3911, blending ~4261.
- [motion/motion.h](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/motion.h), blob `1a48aa02f5772b8fd5e50862e13b097f1b789cc4`, status fields `jerk` and `planner_type` ~659–663.
- [task/taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/taskintf.cc), blob `2a429b0f66b2593cf669d6d25c5e54105390a696`, jerk and planner command dispatch ~1148–1179.

Stable v2.9.10 lacks this development planner-type/deferred-switch implementation. Do not infer its behavior from this note.

## Precise queue-busy sequence

Preconditions: motion enabled; a **nonempty coordinated TP queue** such that `planner_switch_motion_idle()==false`; current `emcmotStatus->planner_type=1`, jerk=2, `ini.traj_planner_type=1`, and no other G64 R or planner request. Choose a software-only long coordinated move in a disconnected simulator; **no physical test authorized**.

| Phase | Input/action | Realtime command effect | Active selector | Deferred state |
|---|---|---|---|---|
| A | busy queue, jerk=2, type=1 | already active | 1 | none |
| B | `ini.traj_max_jerk` becomes 0.5 | Task issues max jerk 0.5, current jerk 0.5, then type 0 fallback | **1 while busy** | pending=0 |
| C | restore jerk=2 **before queue drains**; type pin stays 1 | Task reissues max/current jerk=2; no type-1 command because shadow type remains 1 | **1 while busy** | pending=0 persists |
| D | queue becomes idle | `emcmotApplyPendingPlannerType` applies pending 0 | **0** | cleared |
| E | no further pin transition | no automatic restoration | **0** | none |
| F | type pin changes 1→0→1 with jerk valid | explicit type-1 request may apply when idle | **1** after application | none |

This extends the earlier non-recovery observation: **a temporary jerk reduction while moving can schedule a planner downgrade that takes effect only after jerk has already recovered**. Neither the HAL requested type nor command acknowledgment reveals that queued downgrade.

## Distinguish active selector from per-segment algorithm

During B/C, `emcmotStatus->planner_type` remains 1 until the queue is idle. That does **not** prove every segment continues to execute a successful jerk-limited S-curve at jerk=0.5. `tpCalculateSCurveAccel` calculates the minimum of segment jerk and global jerk, returns `TP_SCURVE_ACCEL_ERROR` when the value is ≤1, and the caller uses a trapezoidal fallback for such segments. Some other TP optimization/blending branches still inspect the global type-1 selector. Thus record **three different observables**: selected planner type, segment-level fallback, and actual motion profile. Source alone cannot establish resulting acceleration continuity or physical jerk.

The pending-apply routine itself checks queue idle but does **not re-evaluate current jerk or desired HAL planner type**. Conversely, a *new* planner request equal to the current selector can cancel a pending switch (the `else` branch ~1287–1289). This makes intervening G64 R or other requests an essential fixture-control variable.

## Counterexamples and acceptance criteria

- **Q1:** A→B→C→D without other planner commands: after queue idle, expect type 0 even though HAL type=1 and jerk=2.
- **Q2:** A→B, allow queue to drain, then restore jerk: still type 0 without explicit type transition.
- **Q3:** A→B→C, then issue a type-1 command **while current selector is still 1**: expect pending downgrade canceled (must verify command ordering and status).
- **Q4:** At B, capture segment-level fallback; do not infer an S-curve from selector=1.
- **Q5:** Distinguish Task-issued type-0 command from actual type-0 activation; a `motion-logger` trace is insufficient.
- **Q6:** With a valid type-1 request pending while current selector=0, reduce jerk through an alternate producer; pending apply does not itself validate jerk. This is a **separate conditional source path**, not established for the ordinary `inihal` fallback, which can issue a canceling type-0 command.

## Engineering direction and evidence limits

A correct future reconciliation should treat requested type, current jerk validity, pending request, actual selector and per-segment fallback as separate state. At queue idle, reconsider **current** desired policy rather than blindly applying stale pending intent. An independent runtime oracle is needed before proposing a production code change. No tests, builds, Actions, hardware operations or evaluator activity occurred. [Oracle audit](4400_LINUXCNC_TP_48_COMMAND_ACK_EFFECTIVE_STATUS_ORACLE_SOURCE_AUDIT_2026-10-31.md) · [acceptance guide](../guides/4000-linuxcnc-motion-status-oracle-and-planner-queue-acceptance-2026-10-31.md).
