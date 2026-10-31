# 4000 practical acceptance — LinuxCNC live INI HAL limits and dynamic planner

**2026-10-31 | LinuxCNC v2.9.10 and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` | DISCONNECTED, REVIEW-ONLY, NOT RUN.** Read [INIHAL-46](../research/4400_LINUXCNC_INIHAL_46_TASK_DELTA_SHADOW_OFFSET_SPLIT_SOURCE_AUDIT_2026-10-31.md) and [TP-47](../research/4400_LINUXCNC_TP_47_DYNAMIC_JERK_PLANNER_FALLBACK_NO_AUTO_RESTORE_SOURCE_AUDIT_2026-10-31.md) before use.

## Configuration freeze
Record exact LinuxCNC revision, Task executable, `[HAL]HALFILE` and `[HAL]POSTGUI_HALFILE`, `[APPLICATION]APP`, `[TRAJ]PLANNER_TYPE` and `MAX_LINEAR_JERK` (development only), `[AXIS_X]MAX_VELOCITY`, `OFFSET_AV_RATIO`, `[JOINT_0]MAX_VELOCITY`, active axis mask, and all `ini.*` pins. Make a disposable **simulation copy** of the INI; never edit a live machine configuration for this exercise. The upstream `milltask(1)` manual says the `ini.*` pins appear after Task starts, not during ordinary HALFILE loading.

## Read-only baseline (after Task initialization)
```sh
halcmd show pin 'ini.*'
halcmd getp ini.x.max_velocity
halcmd getp ini.0.max_velocity
# development only, after verifying pin existence:
halcmd getp ini.traj_max_jerk
halcmd getp ini.traj_planner_type
```
Do not assume a `motion.planner-type` pin exists. Record available status/diagnostics before selecting an oracle.

## Controlled software-only test matrix (no execution claimed)
| ID | Version | Input sequence | Required oracle |
|---|---|---|---|
| L1 | stable + development | inspect `ini.x.max_velocity` and `ini.x.min_velocity` names | pin inventory, M128 Tcl error, Task config, not GUI appearance |
| L2 | stable + development | unequal joint/axis limits, correct pin write | Task sampler dispatch and **actual** active axis limits after propagation |
| L3 | stable + development | `OFFSET_AV_RATIO=0.2`, axis velocity 60 | motion command normal=48, external=12; compare against no-offset baseline |
| L4 | stable + development | change by 0.000005 then by another 0.000010 | `EPSILON` crossing and shadow update; do not assume every small write dispatches |
| L5 | stable + development | injected nonzero `usrmotWriteEmcmotCommand` in isolated harness | failed dispatch, unchanged pin, shadow state, whether next Task cycle retries |
| P1 | development only | jerk=2/type=1 → jerk=0.5/type=1 → jerk=2/type=1 | fallback to type 0, no automatic type-1 reissue; record active type after queue idle |
| P2 | development only | jerk=0.5/type=0 → type=1 → jerk=2/type=1 | rejected/clamped type-1 request, shadow type=1, no automatic recovery |
| P3 | development only | after P1, type=0 then type=1 at jerk=2 | explicit type transition should reissue; verify actual planner after idle |
| P4 | development only | valid planner change during nonempty trajectory queue | requested versus pending versus active; no exact activation time assumed |

**L4 arithmetic:** if shadow begins at 60, first 60.000005 is below the 1e-5 threshold. A later 60.000015 exceeds the threshold relative to the **original** shadow and should dispatch. This is a delta filter, not a time debounce.

## Minimal proposed correction review
For the Puma/millturn M128 helper, replace `ini.$l.min_velocity` with `ini.$l.max_velocity`, surface failed required `halcmd setp` calls instead of hiding them in a broad Tcl `catch`, and wait for verified motion-side application before allowing a subsequent command to rely on the new limit. Preserve the configured `OFFSET_AV_RATIO` budget split. For planner recovery, track desired type independently of the last pin value and reconcile actual planner state after jerk recovers; do not modify the production motion controller based only on this static audit.

## Evidence retention and boundaries
Save versioned INI/HAL/Tcl copies, source SHAs, full test command sequence, before/after pin values, Task debug log, motion command/actual status trace, queue-idle timestamps, expected-versus-observed results and authoritative isolated job timestamps. **No test is passed merely because a pin changed, an NML command was acknowledged, or a GUI reported success.** Runtime evidence requires a positively isolated `[self-hosted, openpressbrake]` runner with hardware outputs disabled. Never use GitHub-hosted runners; no physical motion, no independent safety bypass, no blind-evaluator contamination. Keep 1000/2000/F02/3000 graduated and closed.
