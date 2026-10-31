# 2026-10-31T123219Z — LinuxCNC-first live INI HAL and planner reconciliation checkpoint

**Active:** 4000 implementation NON-GRADUATED; 1000/2000/F02/3000 CLOSED. Owner's 2026-10-30 LinuxCNC-first override applies; independent personnel-safety and blind evaluation gates remain unchanged. Source-only work; no qualified isolated runner established.

## What was established
1. [INIHAL-46](../research/4400_LINUXCNC_INIHAL_46_TASK_DELTA_SHADOW_OFFSET_SPLIT_SOURCE_AUDIT_2026-10-31.md) traces stable v2.9.10 and pinned development Task `check_ini_hal_items`: `ini.*` HAL pins created after HALFILE, sampled once per Task loop, threshold 1e-5, shadow updated **before** motion dispatch, no automatic retry for unchanged input on failed send, and `OFFSET_AV_RATIO` normal/external velocity split. Confirms why prior Puma/millturn `ini.L.min_velocity` typo cannot reach the actual `max_velocity` pin.
2. [TP-47](../research/4400_LINUXCNC_TP_47_DYNAMIC_JERK_PLANNER_FALLBACK_NO_AUTO_RESTORE_SOURCE_AUDIT_2026-10-31.md) finds development-only dynamic jerk fallback leaves requested planner shadow=1 while active type can fall to 0. Restoring jerk without changing the type pin does not reissue type=1. Explicit planner changes may be deferred until queue idle. This is distinct from earlier G64 R investigation.
3. [Disconnected acceptance guide](../guides/4000-linuxcnc-inihal-live-limit-and-planner-acceptance-2026-10-31.md) defines L1–L5 and P1–P4, expected command/actual-state oracles and review-only corrections. **NOT RUN.**

## Source and evidence boundaries
LinuxCNC stable v2.9.10, development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`, exact source blob SHAs in both investigations. SOURCE/DOC-CONFIRMED mechanisms; runtime outcomes conditional INFERENCE; TEST-CONFIRMED none. No builds, simulations, physical operation, independent evaluation, Actions dispatch or authoritative job runtime; hosted/self-hosted Actions compute **0/0 minutes**. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged; runner isolation UNKNOWN. No new course graduation.

## Highest-value next
1. If a positively isolated `[self-hosted, openpressbrake]` LinuxCNC simulation is available, prioritize **P1/P2/P3** planner fallback/recovery and **L1/L2** Puma max-velocity pin tests; preserve actual planner and motion status, not just HAL pin state. Keep hardware disconnected and record job runtime.
2. If still source-only, trace **`EMCMOT_SET_AXIS_VEL_LIMIT`** and **`EMCMOT_SET_PLANNER_TYPE`** through realtime status and test harnesses, to identify an independently checkable actual-state oracle and potential error acknowledgement gap; avoid rehashing TP-31 or KINS-43.
3. If that path saturates, rotate to another distinct 3000/4000 LinuxCNC implementation (router spindle/tooling, EtherCAT timing, Mesa FPGA configuration, or DXF/CAM post contract). No compulsory ROS or CAM product build.
4. Read back new files and exact `PROGRESS.md`/`LESSON_LOG.md`, verify internal links, and keep the existing hourly task enabled. Do not alter safety-course evidence, evaluation separation, or G0/G1 hold.
