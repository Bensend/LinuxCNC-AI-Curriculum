# Next checkpoint — 2026-11-03 13:38 UTC — MOTION-188

Start with START_HERE.md and required governance, evaluation and lab ledgers. Read [MOTION-188](../research/4400_LINUXCNC_MOTION_188_TASK_TP_SERVO_SOURCE_MAP_2026-11-03.md). The HM2 Ethernet branch remains at its HM2-187 information-gain stop.

**Highest-value unblocked work:** close the pinned v2.9.10 G1 call chain: canonical STRAIGHT_FEED -> Task EMC_TRAJ_LINEAR_MOVE -> motion EMCMOT_SET_LINE -> TP enqueue -> tpRunCycle -> Cartesian command -> kinematics/joint output. Cite exact function bodies and line ranges; identify which guards can reject a move. Then inspect upstream tests/interp/g6164 and the complete sim/axis HAL for a minimal G61/G64 commanded-position oracle. Distinguish Task cycle, servo cycle and display polling; never claim physical contour quality from command-only simulation. Reconcile with prior CYCLE-174 and MOTION-144 before proposing a test. If the chain is source-exhausted, rotate to a real Mesa mill/QtPlasmaC config or open-source DXF→G-code workflow.

No new compute without independently verified isolation of `[self-hosted, openpressbrake]`; no GitHub-hosted Actions. Keep graduated levels closed, evaluator separation and independent personnel-safety authority unchanged. Update PROGRESS.md and LESSON_LOG.md, checkpoint and commit; keep hourly enabled.
