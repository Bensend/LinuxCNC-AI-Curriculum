# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through S03 are **GRADUATED** at 1000 level. **S04 — stale/frozen feedback** remains **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

S04 source work has a complete representative production path in `call-flows/S04-frozen-feedback-to-following-error.md`: `joint.N.motor-pos-fb` is sampled by `process_inputs()`, corrected into `pos_fb`, compared against moving `pos_cmd`, tested against the velocity-dependent following-error limit, converted by `check_for_faults()` into joint error plus cleared enabling intent, disabled by `set_operating_mode()`, and published through `output_to_hal()` as `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored`, `joint.N.error`, `joint.N.amp-enable-out`, and `motion.motion-enabled`.

The trace preserves two exceptions: homing index-search wait may substitute command for feedback around the encoder index step, and homed extra joints force following error to zero. Following error is therefore a command/feedback mismatch detector, not a generic sample-age detector.

Experiment S04-014 remains governed by the immutable gates in `experiments/S04-014-feedback-freeze-plan.md`: `MIN_FERROR=0.010`, `FERROR=0.100`, velocity limit 1.0 unit/s, about 0.5 unit/s commanded velocity, runtime `joint.0.f-error-lim` as the threshold oracle, a move with at least 0.20 units of requested travel remaining at freeze, and a clean stationary-frozen control for at least 250 servo cycles.

Run `34110388709` from commit `6d94fd3...` is **NOT ACCEPTED**: rounded sampler text could not establish the strict crossing although the production following-error transition occurred. Run `34115377323` from `a3258c9...` is **HARNESS INVALID / NOT ACCEPTED** because the realtime comparator succeeded but an obsolete decimal-text exit gate remained.

Run `34122070072` from `df51c09c...` is also **HARNESS INVALID / NOT ACCEPTED**, but materially strengthens the moving-case evidence: healthy moving baseline, explicit held feedback, zero sampler overruns, realtime strict-crossing `rt_crossed=1`, `f-errored`, exact following-error diagnostic, joint error, motion disable, and amp-disable all passed. Gate D was not tested because the fresh stationary runtime lost `joint.0.motor-pos-cmd` immediately after reporting ready/enabled.

Run `34123752488` from `e3d6ada...` is the **third and final materially similar realtime-comparator + teardown/restart attempt**. It again passed moving Gates A/B/C, including `rt_crossed=1` and zero sampler overruns, but failed before Gate D because the prior LinuxCNC/HAL runtime did not fully disappear. `experiments/S04-014-run-34123752488-analysis.md` applies the mandatory three-attempt safeguard and classifies the experiment **ESSENTIAL NOW** rather than allowing a fourth teardown/restart variation.

The material redesign is `lab-jobs/014-s04-feedback-freeze-single-runtime.sh`: execute the stationary-frozen adversarial control first, unfreeze feedback, prove the same runtime remains healthy, then perform the moving frozen-feedback fault test in that same LinuxCNC/HAL process. This removes cross-runtime teardown from the evidence path while preserving all immutable S04 numerical and behavioral gates. The first redesigned run `34127066178` / `02903f0...` failed before LinuxCNC execution due a wrapper-generator Python quoting error and is **HARNESS INVALID**. Commit `bb0b6ce8e7a630a837079aadb39964d04ea66e66` fixes and locally parse-checks that generator; workflow `34127182365` is the authoritative current redesigned attempt and is in progress.

Current official LinuxCNC documentation continues to describe `MIN_FERROR`/`FERROR` as a velocity-dependent command-versus-sensed-position tolerance and explicitly notes the nonzero stationary allowance; a recent LinuxCNC forum response likewise points integrators to `joint.N.motor-pos-cmd` versus `joint.N.motor-pos-fb` and servo-thread placement/scaling when diagnosing following error. These corroborate, but do not replace, the pinned-source and experiment evidence.

An adversarial exam/fresh-AI reasoning test already exists in `exams/S04-adversarial-exam-and-answer-key.md`; do not treat its existence as graduation evidence until the required independent experiment completes.

## Promotion / uncertainty queue — active additions

- S04 generic frozen-sensor detection thresholds and false-positive tradeoffs under true zero velocity: **current / HIGH** — the stationary-frozen adversarial control is required before graduation.
- S04 diagnostic freshness/disagreement patterns versus safety-rated diagnostic coverage: **S05/S06 + safety engineering / CRITICAL** — does not block S04 if ordinary diagnostic boundaries remain explicit; no PL/SIL/category claim is made.
- S04 device-specific heartbeat/timestamp/encoder diagnostic mechanisms: **2000 / HIGH** — useful stronger freshness evidence but not required to establish the 1000-level identifiability and following-error mechanisms.

All previously recorded promotion items remain active; consult module handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Continue **S04** from EXPERIMENT. Inspect workflow `34127182365` / source commit `bb0b6ce8e7a630a837079aadb39964d04ea66e66` and use the lab artifact's own exit code as oracle. This is attempt 2 of the materially redesigned single-runtime family (attempt 1 failed at wrapper generation before substantive lab execution). Require Gate D-first evidence of >=250 stationary frozen cycles, no realtime comparator crossing/over-limit condition, no `f-errored` or joint error, retained motion/amp enable, and zero sampler overruns; then require post-control live-loopback health and the existing moving Gate A/B/C strict-crossing/fault/disable evidence with zero overruns. If it passes, commit accepted result, audit/correct the adversarial exam and fresh-AI handoff, run the counterfactual promotion test, graduate S04, and activate S05. If it fails, diagnose the preserved artifact; one further materially similar single-runtime attempt remains before the safeguard must be applied again.
