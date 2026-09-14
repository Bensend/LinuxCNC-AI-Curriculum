# Active Curriculum Session State

Session start UTC: `2026-09-14T12:42:27Z`
Session end UTC: `2026-09-14T12:51:42Z`
Actual elapsed: **9.2 minutes**
Status: **CLOSED — F02 external gate preserved; rotated from source-exhausted 3600 to substantive 3200 lathe specialization.**

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. The evaluation directory and recent repository history were checked once at session start; no new correctly routed information-separated evaluator result was found. F02 was not self-scored or contaminated.

## Work completed

The 3600 information-gain stop was treated as branch-local under `WORK_SELECTION_POLICY.md`, and work rotated to the previously underdeveloped **3200 — Lathes / Turning Centers** track.

Pinned LinuxCNC revision: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`.

New durable artifacts:

- `research/3200-lathe-spindle-sync-foundation-2026-09-14.md`
- `research/3200-g76-pass-generation-source-trace-2026-09-14.md`
- `research/3200-spindle-index-readiness-config-comparison-2026-09-14.md`
- `research/3200-lathe-turret-toolchange-boundary-2026-09-14.md`
- `research/3200-css-x-origin-control-boundary-2026-09-14.md`
- `checkpoints/3200-lathe-next-2026-09-14.md`

Key source-grounded findings:

1. G76 pass geometry is expanded in the interpreter into multiple positioning/synchronized-cut/retract episodes; realtime TP/Motion owns spindle-synchronized segment execution.
2. The call path is `G33/G76 -> START_SPEED_FEED_SYNCH -> EMC_TRAJ_SET_SPINDLESYNC -> emcTrajSetSpindleSync -> EMCMOT_SET_SPINDLESYNC -> tpSetSpindleSync -> TP synchronized trajectory`.
3. TP maintains separate waiting-for-index and waiting-for-at-speed states, so phase acquisition and cutting readiness are not the same condition.
4. Two public lathe configurations demonstrated legitimate variation around the same contract: one mechanically synchronized spindle forces `at-speed` true while retaining encoder/index synchronization; another uses VFD readiness plus independent Mesa encoder phase/speed and machine-specific gear-command scaling.
5. `carousel.comp` is a reusable pocket-orientation state machine with homing, alignment, reverse-lock and multiple encoder schemes, but its `ready` output must not be generalized into proof that a multi-stage lathe turret is clamped/locked/down and safe for cutting.
6. Generic iocontrol tool preparation/change requires external acknowledgement; machine-specific physical witnesses remain outside the generic request.
7. G96 CSS couples spindle command to X centerline/tool geometry and requires finite limiting near zero radius; command calculation and `spindle.N.at-speed` authorization remain separate surfaces.

Five bounded adversarial reviews scored **7/7 PASS** each. No new laboratory compute was consumed; source/docs/community/config evidence had higher information gain than another synthetic fixture. The next possible lab remains conditional on source/test inspection exposing a non-duplicate fault claim.

## Next checkpoint

1. Re-check F02 once at the next session; if unchanged, continue 3200 without repeated polling.
2. Finish the iocontrol/tool-change source trace, especially abort/restart and stale acknowledgement semantics.
3. Inspect one complete public lathe turret implementation and map physical clamp/lift/lock witnesses to `tool-changed`.
4. Inspect TP spindle-sync pause/resume/index-failure behavior and upstream synchronized-motion/threading tests.
5. Only freeze a fault lab if that inspection leaves a real evidence gap.
6. Continue 3200 breadth afterward (tool-table/turret conventions, spindle orient/C-axis/live tooling, chuck/tailstock, probing/HMI) rather than over-investigating one subsystem.

Overlap: **No overlap.** Previous completed canonical lesson ended `2026-09-13T04:17:18Z`; this session began `2026-09-14T12:42:27Z`, **32h25m09s later**.

Short-session continuation check: the session did not stop at the first coherent spindle-sync pass. It continued through G76 internals, TP index/readiness semantics, two real public configurations, turret/carousel state-machine boundaries, and CSS/X-origin semantics. Additional work remains unblocked and is preserved in the 3200 checkpoint for the next heartbeat rather than manufacturing a redundant laboratory experiment.
