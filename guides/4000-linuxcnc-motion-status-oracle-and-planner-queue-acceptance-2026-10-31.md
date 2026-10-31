# 4000 practical acceptance — realtime planner state, command acknowledgments and axis velocity ceilings

**2026-10-31 | REVIEW ONLY / NOT RUN | development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` for planner tests; stable v2.9.10 and development for axis-limit path.** Read [TP-48](../research/4400_LINUXCNC_TP_48_COMMAND_ACK_EFFECTIVE_STATUS_ORACLE_SOURCE_AUDIT_2026-10-31.md), [TP-49](../research/4400_LINUXCNC_TP_49_DEFERRED_JERK_FALLBACK_QUEUED_SEGMENT_SOURCE_AUDIT_2026-10-31.md) and [INIHAL-46](../research/4400_LINUXCNC_INIHAL_46_TASK_DELTA_SHADOW_OFFSET_SPLIT_SOURCE_AUDIT_2026-10-31.md).

## Preflight / readiness

Freeze LinuxCNC commit, exact Task and motion binaries, a disposable simulated INI/HAL, active axis mask, `OFFSET_AV_RATIO`, `ini.traj_max_jerk`, `ini.traj_planner_type`, `ini.x.max_velocity`, and all G64 R commands. The qualified runtime must be **physically disconnected** from actuators and external machine I/O, on an independently verified isolated `[self-hosted, openpressbrake]` runner. An Actions label or attestation is **not** proof of isolation. Do not dispatch without this evidence; do not use GitHub-hosted runners or modify a production configuration.

## Existing read-only probes (limited)

```sh
halcmd show pin 'ini.*'
halcmd getp ini.traj_max_jerk       # development only, if present
halcmd getp ini.traj_planner_type   # development only, if present
halcmd getp ini.x.max_velocity      # if X exists
halcmd show pin 'axis.x.*'
```

The first three are **requests**. `axis.x.teleop-vel-lim` is a teleop TP value, not the private configured axis limit. NML `stat.motion.traj.maxVelocity` is a global trajectory ceiling. The ordinary NML trajectory/axis classes do not expose effective planner type, pending switch, or private normal/external axis ceilings in the inspected revision.

## Minimum instrumentation contract (proposed, not deployed)

Instrument a **disconnected simulation copy** of the realtime controller with a read-only, bounded trace:
```text
servo_seq monotonic_ns cmd_num cmd_kind requested_type requested_jerk
queue_depth tp_is_done active_type pending_flag pending_type
axis_index normal_axis_vel_limit external_offset_vel_limit
segment_scurve_error_or_fallback
```
Sample after the command handler and after `emcmotApplyPendingPlannerType`; record their order and whether sampling occurs in the same servo tick. The pending fields are static to `command.c`; expose them only via a deliberately reviewed test-only hook, not an invented stock HAL pin. For axis ceilings, observe the `axis_set_vel_limit` and `axis_set_ext_offset_vel_limit` inputs or private state in a reviewed test build. A seqlock-consistent motion-status reader can observe `emcmotStatus->planner_type` but **not** the private pending fields. Retain raw traces and exact source/patch SHA.

## Frozen discriminating matrix

| ID | Stimulus | Required observation | Invalid shortcut |
|---|---|---|---|
| O1 | jerk<1, send type-1 request directly in development | handler reports operator error but commandStatus remains OK; selector unchanged | Task command OK as success |
| O2 | jerk≥1, request type change while coordinated TP busy | request acknowledged; pending differs from active until queue idle | motion-logger request line |
| O3 | X limit=60, OFFSET_AV_RATIO=.2 | realtime normal ceiling=48, external-offset ceiling=12 | logger only prints normal vel |
| O4 | absent axis or invalid axis index | separate no-dispatch and ignored-command cases | `ini.*` pin alone |
| Q1 | active1/jerk2/busy → jerk.5 → jerk2 before idle | pending type0 persists, type0 applies after idle | HAL requested type=1 |
| Q2 | active1/jerk2/busy → jerk.5 → idle → jerk2 | type0 remains without explicit reissue | jerk recovery implies planner recovery |
| Q3 | Q1, insert a type1 request while active still 1 | pending type0 canceled, if order holds | ignoring G64 R/other writers |
| Q4 | observe segment at jerk.5 while selector=1 | distinguish per-segment fallback from global selector | selector alone proves jerk-limited motion |
| Q5 | explicit type 0→1 after recovery, queue idle | type1 becomes active only when accepted and applied | NML ack alone |

## Source-only diagnostic exercise

A trainee is given `ini.traj_planner_type=1`, `ini.traj_max_jerk=2`, and a motion-logger line `SET_PLANNER_TYPE planner_type=1`. Can they conclude the controller uses S-curve planning? **No**: the logger has no controller and the request may be deferred or rejected in real motion. To establish the claim, identify a live motion-status selector and separately examine segment-level fallback. For a 60-unit axis limit with 20% external-offset budget, the stock logger cannot prove the 12-unit external limit because it does not print that command field.

## Result recording

Retain exact simulator binary/source revision, isolation witness, INI/HAL diff, test-only instrumentation diff, command and realtime traces, expected/observed state transition table, any rejected command/error text, and authoritative Actions **job** start/end timestamps. Mark PASS/FAIL/HARNESS INVALID explicitly; no simulated behavior is TEST-CONFIRMED in this guide. Independent personnel safety, existing graduation/evaluation gates and OpenPressBrake G0/G1 HOLD remain unchanged.
