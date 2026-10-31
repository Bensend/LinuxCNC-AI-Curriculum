# 2026-10-31 16:41Z — LinuxCNC-first G70/G71/G72 profile implementation continuation

**4000 ACTIVE / NON-GRADUATED.** 1000, 2000/F02 and 3000 graduated/closed. Blind independent evaluator remains OPEN. OpenPressBrake physical G0/G1 remains HOLD. Personnel safety independent. Hourly curriculum remains enabled.

## Predecessor and novelty reconciliation
Read START_HERE, master mission, level order, work-selection, curriculum, source/template, progress, blind protocol/score, and lab compute ledger. The preceding checkpoint SSERIAL-54/55/56/57 and CAM-58/59/60 has no qualified isolated test evidence; do **not** repeat source-only reviews. Initially inspected G38 probe source, then scanned full PROGRESS and found pre-existing PROBE-EDGE-01, PROBE-15/16, so **discarded the duplicate candidate** before publishing it. Checked G70/G71/G72/G7x/lathe roughing synonyms in PROGRESS: no prior source audit. This is a distinct 3200-to-4000 transfer question, not a reopening of 3200 graduation.

## Durable new work
- [LATHE-61](../research/4400_LINUXCNC_LATHE_61_G7X_PROFILE_R_ARC_SIGN_AND_RADIUS_VALIDATION_SOURCE_AUDIT_2026-10-31.md): stable v2.9.10/development `convert_g7x` profile R arc uses `r*r` and ignores R sign, unlike ordinary `arc_data_r`; an undersized R produces a negative square-root argument before any explicit profile-R validation. Development's new arc check is I/K-only. No interpreter execution.
- [LATHE-62](../research/4400_LINUXCNC_LATHE_62_G7X_PROFILE_SIDE_EFFECTS_PRELIMINARY_MOVE_AND_PASS_DRIFT_SOURCE_AUDIT_2026-10-31.md): Q profile scan is userspace geometry construction; preliminary G0 is constructed before Q validation, numbered/named parameter assignments are applied, and development avoids stable repeated-subtraction drift via `top-n*delta` while adding tolerance/recursion protections. Physical movement on error UNKNOWN.
- [LATHE-63](../research/4400_LINUXCNC_LATHE_63_G70_FINISH_PASS_COUNT_ZERO_AND_FRACTIONAL_P_SOURCE_AUDIT_2026-10-31.md): G70 P0/negative yields zero finishing-pass iterations if accepted; stable fractional P uses int loop count but double denominator, development truncates P first. Parser acceptance UNKNOWN.
- [11-case disconnected G7x acceptance guide](../guides/4000-linuxcnc-g7x-lathe-profile-cam-acceptance-2026-10-31.md): canonical geometry/Task/motion-separated oracle, pinned upstream G70/G71 fixtures and source-derived cases. All NOT RUN.

## Next highest-value unblocked work
1. **If and only if** an approved, positively isolated `[self-hosted, openpressbrake]` runner is available, execute a *single* bounded LinuxCNC interpreter comparison: first verify valid upstream `lathe_g70_71_demo.ngc`; then signed-R G7x vs ordinary G2, undersized-R, and G70 P0/P2.9. Freeze exact source tag, fixture hashes, interpreter/canonical output and errors. No GitHub-hosted Actions fallback, no physical I/O, no implicit machine safety proof.
2. If qualified compute unavailable, rotate to **distinct LinuxCNC internals** (e.g., a real router/laser HAL+INI spindle/PWM or machine-specific G-code pipeline) after full-PROGRESS novelty scan. Do not re-audit PROBE-15/16, SSERIAL-54/55 or LATHE-61/63 without new source, test, or external evidence.
3. When comparing development G7x, explicitly account for new I/K validation, pocket rounding/termination, and G70 P cast; do not attribute all differences to one change. Reconcile official G71 'fragile' warning with actual executable results, not speculation.

## Evidence and compute
SOURCE/DOC-CONFIRMED static; conditional INFERENCE; TEST-CONFIRMED none. No builds, simulation, hardware, independent evaluation, workflows or new authoritative job runtime. GitHub-hosted/self-hosted Actions **0/0 min**. LAB_COMPUTE_LOG and FEEDBACK_SCORE_LOG unchanged. Preserve prior graduated levels, evaluator gates, and physical HOLD. Keep hourly task enabled.
