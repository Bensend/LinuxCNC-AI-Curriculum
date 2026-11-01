# 2026-11-01 01:36Z — LinuxCNC bounded homing and joint-command boundary checkpoint

**Active:** 4000 LinuxCNC implementation; NON-GRADUATED. Mandatory START_HERE/governance/evaluation/compute read. Predecessor [COMP-88/89](20261101T004500Z-4000-linuxcnc-leadscrew-compensation-next.md). Previously graduated 1000/2000/F02/3000 remain CLOSED. Personnel-safety independent authority, G0/G1 machine HOLD, and sealed evaluator boundaries unchanged.

## New source-grounded findings

1. [HOMING-90](../research/4400_LINUXCNC_HOMING_90_BOUNDED_MOVE_ABORT_FANOUT_SOURCE_AUDIT_2026-11-01.md): development `HOME_SEARCH_DIST` exhaustion stops at search endpoint; `HOME_LATCH_DIST` exhaustion commands a return for participating/synchronized joints. Development `HOME_ABORT` clears **all configured joints**; stable v2.9.10 clears only failing joint. SOURCE/DOC-CONFIRMED; no physical return or machine behavior verified.
2. [HOMING-91](../research/4400_LINUXCNC_HOMING_91_CONFIGURED_JOINT_BOUNDARY_G282_SOURCE_AUDIT_2026-11-01.md): development Task rejects invalid configured joint indices with operator error and immediate queued G28.2 mode restore, consistent with upstream PR #4172 merged 2026-09-17 and its **unexecuted** regression. Stable generic Task checked compile-time max. Both motion implementations retain `jno > all_joints` off-by-one; development public Task guards ordinary path. Stable does **not** support G28.2.
3. [12-case disconnected differential guide](../guides/4000-linuxcnc-homing-bounded-search-global-abort-disconnected-acceptance-2026-11-01.md): H90-01..09/H91-10..12 ALL NOT RUN; real upstream `gantry_jjog.ini` simulation used as an inspectable fixture, not a machine test. Prior [GCODE-28](../research/4400_LINUXCNC_GCODE_28_G282_HOME_CYCLE_TASK_MOTION_MODE_AND_RESULT_SOURCE_AUDIT_2026-10-31.md) not duplicated.

## Same-session distinct trajectory-planner continuation

[TP-92 Ruckig pool source audit](../research/4400_LINUXCNC_TP_92_RUCKIG_POOL_REALTIME_FALLBACK_SOURCE_AUDIT_2026-11-01.md) traces development's 16-slot eager pool, partial-init success propagation, lazy init and exhausted-pool live allocation inside the servo cycle, per-cycle trapezoidal fallback, and queue-cleanup release. Seven disconnected cases TP92-01..07 are **NOT RUN**. This is a separate LinuxCNC realtime planner topic, not another homing test plan. No jitter or installed-machine outcome claimed.

## Next precise action

- If qualified isolated runner with **both** `self-hosted` and `openpressbrake` labels is independently established, execute H90-07/08 first (highest version-discriminating evidence), then H90-01/02/05 and existing upstream H91-10; retain all traces and actual job times. No GitHub-hosted Actions fallback, no hardware I/O.
- After reproducing, assess whether global abort invalidation is intentional and whether the residual motion `jno >= all_joints` guard merits a small independent upstream correction. Avoid duplicating already merged PR #4172.
- If qualified compute is unavailable, rotate to a distinct LinuxCNC machine-specific or interpreter topic; avoid repeating HOMING-90/91 or TP-92. For TP-92, only attempt allocator-instrumented software tests when runner qualification is positive.
- Continue hourly. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged: no new authoritative job runtime, blind evaluator score, or tested verdict. Hosted/self-hosted Actions 0/0 minutes in this session.
