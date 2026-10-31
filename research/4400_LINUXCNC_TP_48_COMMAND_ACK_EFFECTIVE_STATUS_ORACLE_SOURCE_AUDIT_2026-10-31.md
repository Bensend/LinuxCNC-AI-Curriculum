# 4000-LC-TP-48 — Motion-command acknowledgment is not a planner/axis-limit application oracle

**2026-10-31 | LinuxCNC-first 4000 implementation | NON-GRADUATED | SOURCE-CONFIRMED, NOT EXECUTED.** This resolves the oracle question left by [INIHAL-46](4400_LINUXCNC_INIHAL_46_TASK_DELTA_SHADOW_OFFSET_SPLIT_SOURCE_AUDIT_2026-10-31.md) and [TP-47](4400_LINUXCNC_TP_47_DYNAMIC_JERK_PLANNER_FALLBACK_NO_AUTO_RESTORE_SOURCE_AUDIT_2026-10-31.md), without claiming a physical or simulation failure.

## Immutable provenance and process boundary

LinuxCNC development commit `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`, inspected 2026-10-31 (source publication date not inferred from inspection date):
- [motion/command.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c), blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`: command acknowledgment ~424–449, planner case ~1250–1293, axis-limit case ~2043–2053, command-handler epilog ~2120.
- [motion/usrmotintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/usrmotintf.cc), blob `e314d97b7e9f4c757a6d31dbbf78c80aed0a0e91`: `usrmotWriteEmcmotCommand` ~78–123, shared-memory status copy ~125.
- [motion/motion.h](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/motion.h), blob `1a48aa02f5772b8fd5e50862e13b097f1b789cc4`: `emcmot_status_t` ~586–594, `planner_type` ~659–663.
- [task/taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/taskintf.cc), blob `2a429b0f66b2593cf669d6d25c5e54105390a696`: `emcAxisSetMaxVelocity` ~465–486, `emcAxisUpdate` ~589–605, `emcTrajPlannerType` ~1170, `emcTrajUpdate` ~1637–1760.
- [nml_intf/emc_nml.hh](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/nml_intf/emc_nml.hh), blob `f71030156bbc4ae1c0632008f2722988fb4fed43`: public `EMC_AXIS_STAT` ~161–173, `EMC_TRAJ_STAT` ~984–1050.
- [motion/axis.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/axis.c), blob `f6dd8d4aef0622c17f1f9dc9041ff5e3db7640e8`: private `axis_array` ~20–65, HAL exports ~105–170, limit setters ~196–214.
- [motion-logger/motion-logger.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion-logger/motion-logger.c), blob `28978ae80e8a8d2887330fd07fa037d1d84e4569`: command log ~547–573 and unconditional synthetic acknowledgment ~709–716.
- Stable [v2.9.10 motion/command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c), blob `0b79061d39be915bbea548b2c33bb794d31ab302`, retains the axis-limit setter; the development-only planner selector must **not** be ascribed to v2.9.10.

## End-to-end acknowledgment trace

1. Task's `emcTrajPlannerType(type)` sends `EMCMOT_SET_PLANNER_TYPE` using `usrmotWriteEmcmotCommand`; the axis setter sends `EMCMOT_SET_AXIS_VEL_LIMIT` with **two** velocities: `vel` and `ext_offset_vel`.
2. Userspace assigns a new `commandNum`, writes the command under a mutex, and polls a seqlock-consistent motion-status snapshot until `commandNumEcho` matches. It returns communication OK when `commandStatus == EMCMOT_COMMAND_OK`. This means the **command handler acknowledged the command**, not necessarily that a deferred effect has happened.
3. The realtime handler sets `commandStatus=EMCMOT_COMMAND_OK` before the switch. In the development planner case, a request for type 1 with `emcmotStatus->jerk<1` calls `reportError(...)` and `break` **without changing commandStatus**. A valid but busy-queue request is stored as pending and also leaves commandStatus OK. Thus both a refused and a deferred planner request can receive an OK motion-command acknowledgment. The error text is a separate operator-facing channel.
4. The realtime axis-limit handler calls `axis_set_vel_limit(axis, vel)` and `axis_set_ext_offset_vel_limit(axis, ext_offset_vel)`. These modify private `axis_array` state. Invalid axis indices break after `emcmot_config_change()` without marking `commandStatus` bad. The ordinary Task wrapper filters absent axes via `TrajConfig.AxisMask`, but this is another reason not to equate generic command OK with a validated configuration.
5. `emcmotStatus->planner_type` is an internal shared-memory **active selector**, and the deferred `planner_type_switch_pending` / `planner_type_pending_value` are file-static in `command.c`. The inspected `EMC_TRAJ_STAT` NML class and `emcTrajUpdate` do **not** copy planner type or pending state. `EMC_AXIS_STAT` exposes position limits and **current teleop velocity**, not the stored per-axis normal/external velocity ceilings. `EMC_TRAJ_STAT.maxVelocity` is the **global trajectory limit** (`emcmotConfig.limitVel`), not an axis's private limit.
6. `axis.x.teleop-vel-lim` is a HAL **teleop trajectory planner's current max velocity** (`teleop_tp.max_vel`), not a direct export of `axis_array[x].vel_limit`; reading it while idle cannot serve as a universal configured-axis-limit oracle.

## Why the stock motion-logger cannot prove application

`motion-logger` substitutes for the motion controller. Its `SET_AXIS_VEL_LIMIT` line prints axis and normal `vel` but **omits `ext_offset_vel`**, so it cannot prove the 48/12 split of a 60-unit limit with OFFSET_AV_RATIO=0.2. Its `SET_PLANNER_TYPE` line prints the **requested** type. It then sets `commandStatus=OK` and advances a synthetic heartbeat with an explicit comment that **there is no controller**. The logger can establish Task-issued command order; it cannot establish realtime acceptance, deferred activation, active planner, external-offset ceiling, or machine movement.

## Required oracle hierarchy (review only)

| Evidence | Proves | Does not prove |
|---|---|---|
| `ini.*` HAL pin | requested live value | Task dispatch or motion application |
| Task `motion-logger` trace | command and ordering (normal axis vel only) | full two-part axis limit, controller outcome |
| `usrmotWriteEmcmotCommand` OK | realtime handler echoed command with OK status | planner switched or limit used by actual motion |
| ordinary NML `stat.motion.traj` | queue/position/global trajectory state | active planner selector or private axis ceilings |
| qualified isolated realtime diagnostic reading `emcmotStatus->planner_type` + `axis_array` state | selector and installed limits at sample instant | physical dynamics or independent personnel safety |

For a future isolated test, add **temporary, explicitly reviewable instrumentation** at the actual realtime setter and at `emcmotApplyPendingPlannerType` (or a version-pinned seqlock-safe observer). Capture requested, pending, applied, jerk, queue-depth and normal/external limit values with monotonic timestamps. Do not assume a `motion.planner-type` HAL pin exists, do not patch a live machine, and do not interpret command OK as semantic success.

## Open evidence

No code built or run; exact queue and telemetry sampling timing, real-machine impact, and any custom Task/controller changes remain UNKNOWN. This is **source-confirmed interface/observability**, not TEST-CONFIRMED. [Acceptance guide](../guides/4000-linuxcnc-motion-status-oracle-and-planner-queue-acceptance-2026-10-31.md).
