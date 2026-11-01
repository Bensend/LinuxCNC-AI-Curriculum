# JOG-137 — Axis MPG limit uses `break`: cross-axis wheel-jog processing and unhomed-mode inconsistency
**2026-11-01 ~21:44Z UTC | 4000 LinuxCNC motion/HAL / 3100–3500 transfer | NON-GRADUATED | SOURCE-CONFIRMED, runtime NOT RUN**

## Why this is a separate causal mechanism
Prior FEED-JOG-01 and USB-PENDANT-JOG-03 discuss keyboard versus wheel jog inhibition and pendant count backlog. [JOG-135](4400_LINUXCNC_JOG_135_UNHOMED_AXIS_JOG_LIMIT_VERSION_AND_RECENTER_SOURCE_AUDIT_2026-11-01.md) traces keyboard axis-jog moving limits. **New question:** what happens to a *second axis's MPG counts* when the first axis reaches its jog target limit in the same servo callback?

## Pinned source
- Stable LinuxCNC v2.9.10 [`src/emc/motion/axis.c`, blob `c5dbdf908c2b9b46e49601700bcee0a4d692721f`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/axis.c), `axis_handle_jogwheels` lines 361–428.
- Development `06864e23559e70463fc7112d5ce77138bcbc288c` [`axis.c`, blob `f6dd8d4aef0622c17f1f9dc9041ff5e3db7640e8`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/axis.c), `axis_handle_jogwheels` lines 427–497. Same `break` control-flow pattern in both.

## Exact execution path
The function iterates `for (axis_num=0; axis_num<EMCMOT_MAX_AXIS; axis_num++)`. It reads each axis's `jog-counts`, calculates `delta = new_counts - old_counts`, **updates `old_ajog_counts` immediately**, checks enable/mode/homing/keyboard-jog gates, computes `distance=delta*jog_scale` and `pos=teleop_tp.pos_cmd+distance`. Velocity-mode wheel jogging can clamp the target to a stopping-distance lead first. Then the limit checks use:

```c
if (pos > axis->max_pos_limit) { break; }
if (pos < axis->min_pos_limit) { break; }
```

Because this is a `break` in the **outer axis loop**, not `continue`, an out-of-limit axis terminates the *entire function*'s per-axis iteration for that servo callback. Later-numbered axes are not read, and their `old_ajog_counts` remain unchanged for that callback. This is a source-confirmed cross-axis processing dependency, **not** proof of an observed hardware stall.

### Frozen conditional prediction
In a disconnected simulation with both X and Y wheel jog enabled and motion in TELEOP, set X target at its max and send positive X and Y count increments during the same callback:
- X (axis index 0) computes an out-of-limit target; its old count is updated, then `break`.
- Y (index 1) is not visited in that callback; its old count is not updated and its jog target remains unchanged.
- If X counts stop changing, the next callback can process the retained Y delta (a one-cycle delay). If X keeps receiving out-of-limit increments **on every callback**, Y may be repeatedly starved. These are conditional source-derived predictions; HAL timing and actual scheduler behavior are NOT RUN.
- If Y is the first offending axis, X has already been processed, while Z and later axes are skipped. The effect is ordering-dependent.

## Separate unhomed-axis inconsistency in development
Development `axis_jog_cont/incr/abs` calls `axis_jog_limits`, which selects `teleop_tp.curr_pos ± configured span` when unhomed; `update_teleop_with_check` skips the fixed INI axis-limit check for an unhomed axis (see JOG-135). **But** development `axis_handle_jogwheels` still checks literal `axis->min_pos_limit/max_pos_limit` (lines 488–489), rather than `axis_jog_limits`. Thus the keyboard and wheel jog target-admission paths differ for an unhomed identity-kinematics axis. Stable both use fixed axis limits. Do not generalize this to FREE joint MPG without inspecting its separate implementation.

## Practical implications and boundaries
- A pendant's single per-axis count change is not necessarily acted on during that servo cycle; another axis's out-of-limit count can defer it.
- A stale count delta can be applied on a later callback after the first axis stops changing. This is not a guaranteed dropped command.
- It would be premature to change `break` to `continue` without reviewing startup/first-pass logic, axis-index bounds, and existing tests; any patch must be regression-tested against both axes and both wheel velocity modes.
- This is normal machine-control behavior, **not** a personnel-safety mechanism. No physical movement or motor timing has been verified.

## Precise disconnected verification (NOT RUN)
On qualified physically disconnected `[self-hosted, openpressbrake]`, instrument `axis_handle_jogwheels` at entry and per-axis visits. Freeze axis0 and axis1 `jog-counts`, old counts, `jog-enable`, velocity mode, position, INI limits, `teleop_tp.pos_cmd`, and callback timestamps. Cases: (1) both within limits, (2) X out-of-limit + Y in-limit same tick, (3) continuous out-of-limit X counts across ticks, (4) Y out-of-limit + Z in-limit, (5) unhomed identity keyboard versus wheel axis jog on development. Record exact version, raw logs, exit status and job runtime; do not dispatch on machine-connected hardware. A fake-loop test can establish source control flow but not HAL realtime timing.

## Open
Is this behavior covered by an upstream regression test or deliberate historical design choice? Does any GUI/pendant mask it by serializing MPG axes? Those require additional source or execution evidence.
