# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through S03 are **GRADUATED** at 1000 level. **S04 — stale/frozen feedback** remains **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

S04 source work has a complete representative production path in `call-flows/S04-frozen-feedback-to-following-error.md`: `joint.N.motor-pos-fb` is sampled by `process_inputs()`, corrected into `pos_fb`, compared against moving `pos_cmd`, tested against the velocity-dependent following-error limit, converted by `check_for_faults()` into joint error plus cleared enabling intent, disabled by `set_operating_mode()`, and published through `output_to_hal()` as `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored`, `joint.N.error`, `joint.N.amp-enable-out`, and `motion.motion-enabled`.

The trace preserves two exceptions: homing index-search wait may substitute command for feedback around the encoder index step, and homed extra joints force following error to zero. Following error is therefore a command/feedback mismatch detector, not a generic sample-age detector.

Experiment S04-014 remains governed by the immutable gates in `experiments/S04-014-feedback-freeze-plan.md`: `MIN_FERROR=0.010`, `FERROR=0.100`, velocity limit 1.0 unit/s, about 0.5 unit/s commanded velocity, runtime `joint.0.f-error-lim` as the threshold oracle, a move with at least 0.20 units of requested travel remaining at freeze, and a clean stationary-frozen control for at least 250 servo cycles.

Run `34110388709` from commit `6d94fd3...` is **NOT ACCEPTED**: rounded sampler text could not establish the strict crossing although the production following-error transition occurred. Run `34115377323` from `a3258c9...` is **HARNESS INVALID / NOT ACCEPTED** because the realtime comparator succeeded but an obsolete decimal-text exit gate remained.

Run `34122070072` from `df51c09c...` is also **HARNESS INVALID / NOT ACCEPTED**, but it materially strengthens the moving-case evidence: healthy moving baseline, explicit held feedback, zero sampler overruns, realtime strict-crossing `rt_crossed=1`, `f-errored`, exact following-error diagnostic, joint error, motion disable, and amp-disable all passed. Gate D was not tested because the fresh stationary runtime lost `joint.0.motor-pos-cmd` immediately after reporting ready/enabled. `experiments/S04-014-run-34122070072-analysis.md` classifies this as a teardown/restart lifecycle race; stationary readiness succeeded on probe 1 immediately after cleanup, consistent with briefly observing the prior runtime before teardown completed.

Commit `e3d6adafc0e46917d896f89a941c911053f8cd06` changes lifecycle hygiene only: before Gate D restart, both linuxcncrsh TCP port 5007 and representative HAL motion pin `joint.0.motor-pos-cmd` must disappear. Immutable S04 acceptance criteria are unchanged. Workflow `34123752488` is the authoritative **third realtime-comparator-family attempt** and is currently running.

An adversarial exam/fresh-AI reasoning test already exists in `exams/S04-adversarial-exam-and-answer-key.md`; do not treat its existence as graduation evidence until the required independent experiment completes.

## Promotion / uncertainty queue — active additions

- S04 generic frozen-sensor detection thresholds and false-positive tradeoffs under true zero velocity: **current / HIGH** — the stationary-frozen adversarial control is required before graduation.
- S04 diagnostic freshness/disagreement patterns versus safety-rated diagnostic coverage: **S05/S06 + safety engineering / CRITICAL** — does not block S04 if ordinary diagnostic boundaries remain explicit; no PL/SIL/category claim is made.
- S04 device-specific heartbeat/timestamp/encoder diagnostic mechanisms: **2000 / HIGH** — useful stronger freshness evidence but not required to establish the 1000-level identifiability and following-error mechanisms.

All previously recorded promotion items remain active; consult module handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Continue **S04** from EXPERIMENT. Inspect workflow `34123752488` / source commit `e3d6adafc0e46917d896f89a941c911053f8cd06` and use the lab artifact's own exit code as oracle. Require moving Gate A/B/C evidence already specified plus fresh-runtime Gate D with confirmed prior-runtime teardown, >=250 stationary frozen cycles, no realtime comparator crossing/over-limit condition, no `f-errored` or joint error, retained motion/amp enable, and zero sampler overruns. If it passes, commit accepted result, audit/correct the existing adversarial exam and fresh-AI handoff, run the counterfactual promotion test, graduate S04, and activate S05. If it fails, do **not** launch a fourth materially similar comparator attempt: the three-attempt safeguard requires explicit classification as ESSENTIAL NOW (material redesign), PROMOTE, or DROP before further lab execution.
