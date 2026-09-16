# 4000 Safety Lane B Checkpoint — 2026-09-16

## Durable state

Independent lane added `safety-course/SAFETY_SANDBOX_EVALUATOR_RUBRIC_SCORECARD.md` at commit `44d3c3a`.

The rubric grades seven dimensions: hazard/task boundary, authority separation, independent evidence, recovery semantics, UNKNOWN/provenance discipline, human factors/defeat resistance, and validation/change control. It includes automatic-fail gates so verbosity or standards terminology cannot compensate for unsafe overclaims.

## Parallel-work reconciliation

Before selection, current `main` showed the primary safety lane's newest durable work as `research/4000-safety-reset-restart-rearm-contract-2026-09-16.md` plus `checkpoints/4000-safety-next-2026-09-16b.md`. Its next branch is a cross-machine reset/restart/rearm failure-path matrix.

Lane B therefore did not modify that research artifact, checkpoint, reset/restart matrix, or executable Safety Sandbox fixture. This lane worked only on evaluator scoring/human-factors calibration. `main` was re-read immediately before the Lane B commit and again afterward; no overlapping file changed.

## Evidence added/frozen

- OSHA 1910.212: point-of-operation guarding prevents body entry into the danger zone during the operating cycle.
- OSHA machine-guarding guidance: safeguards should resist easy removal/tampering; safeguards that interfere with doing the job may be overridden/disregarded.
- OSHA interlocked-guard guidance: opening/removal stops/disengages and prevents start; replacing the guard should not automatically restart.
- OSHA interpretation: interlocked access is inadequate if a person can enter the danger zone before inertia-driven hazardous motion stops.
- Rockwell Logix SIS documentation: overriding a safety fault does not clear the fault and continued-safe-operation proof remains the implementer's responsibility.

Evidence classes remain `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`. Test count or rubric score must never be converted to diagnostic coverage, PL, SIL, Category, PFHd, stopping performance, or machine suitability.

## Next independent work

Build `safety-course/SAFETY_SANDBOX_EVALUATOR_CALIBRATION_PACK.md` with paired learner answers that exercise the rubric without duplicating the primary lane's reset/restart matrix:

1. concise evidence-bounded answer vs verbose standards-heavy overclaim;
2. conservative-but-wrong blanket shutdown answer vs task/hazard-specific safe architecture;
3. command/status evidence vs independent physical witness;
4. practical defeat-resistant safeguard vs nuisance safeguard likely to be bypassed;
5. correct `UNKNOWN` plus verification request vs invented machine-specific number;
6. prior PASS after configuration change vs dependency-based evidence invalidation.

Include expected dimension scores and automatic-fail gates, but do not create hidden answers that would contaminate any active blind evaluation. If the calibration pack would overlap an active primary evaluator artifact at the next run, switch to an independent source-tracing topic instead.

No compute was consumed. No executable question justified use of the self-hosted runner.
