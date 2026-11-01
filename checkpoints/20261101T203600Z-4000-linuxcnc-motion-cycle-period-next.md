# 2026-11-01 ~20:36Z — LinuxCNC motion-cycle timing checkpoint
**LINUXCNC FIRST. NON-GRADUATED.** 4000-LC-RT-133/134 with 3100/3200/3400/3500 transfer.

## Completed
- [RT-133 source investigation](../research/4400_LINUXCNC_RT_133_TRAJ_SERVO_CYCLE_ASSIGNMENT_CUBIC_REAL_CONFIG_SOURCE_AUDIT_2026-11-01.md): pinned v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a` and development `06864e23559e70463fc7112d5ce77138bcbc288c` trace HAL callback → `emcmotSetCycleTime` → TP/cubic. **Known upstream issue #3268**, opened 2025-01-11, not new upstream discovery. 1:1, explicit 10:1, rounded-period source-derived cases; all runtime NOT RUN.
- [RT-134 real-config/diagnostics audit](../research/4400_LINUXCNC_RT_134_INI_HAL_PERIOD_PASS_THROUGH_ROUNDING_AND_DIAGNOSTIC_SOURCE_AUDIT_2026-11-01.md): shipped 1240rutex passes TRAJ=10 ms, 622gecko passes SERVO=1 ms in its place despite same INI TRAJ=10 ms, pentapod omits TRAJ. HAL passes nominal period, not measured jitter. [Practical walkthrough](../guides/3100-3400-4000-linuxcnc-motion-servo-traj-period-config-preflight-2026-11-01.md).
- Source-only, no LinuxCNC build, simulator, HAL execution, machine, independent evaluator or Actions; hosted/self-hosted 0/0 minutes, no authoritative runtime. LAB_COMPUTE_LOG and blind score unchanged. Graduated levels closed, independent personnel-safety authority and OpenPressBrake G0/G1 HOLD unchanged.

## Precise next action
1. First positively qualify **physically disconnected** `[self-hosted, openpressbrake]` compute; runner label, script SHA and job success do not establish isolation. Do **not** dispatch without it.
2. If qualified, freeze v2.9.10 and identical software-only configurations except `traj_period_nsec` omitted vs explicitly 10x servo. Record HAL nominal thread period, before/after first `emcmotController` config servo/traj/interpolationRate, TP cycle, cubic stored rate/segment/increment, commanded position/velocity, exit, source/binary revision and exact job start/end. Compare with RT-133 table; no connected outputs, no hosted Actions.
3. If still useful, test base=400 µs / servo=1 ms / traj omitted as **separate** zero-quotient case; do not infer physical speed error. A candidate patch needs both cases and upstream review; do not silently deploy.
4. If compute unavailable, rotate to distinct LinuxCNC motion/HAL/real-config topic. Preserve HOMING-131, HM2-GPIO-132, ARC, ABSENC, TAP and other runtime debt as NOT RUN; do not manufacture more redundant tests. Keep hourly automation enabled.
