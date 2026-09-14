# Start Here — LinuxCNC AI Curriculum

This is the entry point for every new AI work session.

## Required Action

1. Read `MASTER_MISSION.md` completely and treat it as the standing mission contract.
2. Read `LEVEL_ORDER.md` and `WORK_SELECTION_POLICY.md`, then read `CURRICULUM.md`, `SOURCE_POLICY.md`, `MODULE_TEMPLATE.md`, and `PROGRESS.md`. `LEVEL_ORDER.md` and `CURRICULUM.md` are authoritative for active course numbering if older level-numbering prose elsewhere conflicts. `WORK_SELECTION_POLICY.md` is authoritative for selecting the next branch when one module, specialization, evaluator, or source path is blocked.
3. Read `evaluation/BLIND_FEEDBACK_PROTOCOL.md`, inspect `evaluation/FEEDBACK_SCORE_LOG.md`, and determine whether a blind evaluation, transfer retest, or retention retest is due. Never inspect or create learner-readable hidden answers before a blind commitment.
4. Inspect `LAB_COMPUTE_LOG.md`, the latest laboratory results, and existing artifacts relevant to the current/next module. When an authoritative lab job has completed, record its actual job runtime rather than estimating from lesson time.
5. Recover any unfinished checkpoint or newly spawned prerequisite from repository state.
6. Execute the highest-priority unblocked curriculum work according to `MASTER_MISSION.md` and `WORK_SELECTION_POLICY.md`, using the active level numbering defined by `LEVEL_ORDER.md` and `CURRICULUM.md`.
7. Treat information-gain stops and unavailable evidence as branch-local. If the current branch cannot gain useful evidence, checkpoint it and move to another open 3000-series track or other justified unblocked curriculum branch. Do not let a blocked press-brake branch, F02 external handoff, or other single dependency idle the whole course.
8. Perform substantive work now. Do not respond with only a plan, summary, or request for permission to continue.
9. **Short-session continuation check:** before ending a session with less than about 15 minutes of substantive work, explicitly determine whether another useful unblocked task or specialization exists. Launching an experiment, finishing a subtask, graduating a module, waiting on an external result, or reaching an information-gain stop in one branch is not by itself a stopping reason. Continue into the next coherent source trace, evaluation, evidence reconciliation, next-module preparation, promotion review, experiment design, or another 3000-series specialization unless a documented exception in `MASTER_MISSION.md` or `WORK_SELECTION_POLICY.md` applies.
10. Commit durable results, update progress, update laboratory compute records when new authoritative runtime is known, and preserve an unambiguous next-work checkpoint before ending the session.
11. Follow the perpetual lesson scheduling rules in `MASTER_MISSION.md` and `WORK_SELECTION_POLICY.md`. The recurring curriculum task must not be disabled merely because one branch is blocked or source-limited. If scheduling requires an owner action that the current environment cannot perform, ask only for that minimum action.

## Minimal Human Launch Prompt

The owner should be able to start or resume the course with:

> Go work on the LinuxCNC curriculum. Read `START_HERE.md` in `Bensend/LinuxCNC-AI-Curriculum` and follow it.

Repository state, not chat history, determines what lesson comes next.
