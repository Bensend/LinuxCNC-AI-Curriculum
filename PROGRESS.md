# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through S03 are **GRADUATED** at 1000 level. **S04 — stale/frozen feedback** remains **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

S04 source work has a complete representative production path in `call-flows/S04-frozen-feedback-to-following-error.md`: `joint.N.motor-pos-fb` is sampled by `process_inputs()`, corrected into `pos_fb`, compared against moving `pos_cmd`, tested against the velocity-dependent following-error limit, converted by `check_for_faults()` into joint error plus cleared enabling intent, disabled by `set_operating_mode()`, and published through `output_to_hal()` as `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored`, `joint.N.error`, `joint.N.amp-enable-out`, and `motion.motion-enabled`.

The trace preserves two exceptions: homing index-search wait may substitute command for feedback around the encoder index step, and homed extra joints force following error to zero. Following error is therefore a command/feedback mismatch detector, not a generic sample-age detector.

Experiment S04-014 remains governed by the immutable gates in `experiments/S04-014-feedback-freeze-plan.md`: `MIN_FERROR=0.010`, `FERROR=0.100`, velocity limit 1.0 unit/s, about 0.5 unit/s commanded velocity, runtime `joint.0.f-error-lim` as the threshold oracle, a move with at least 0.20 units of requested travel remaining at freeze, and a clean stationary-frozen control for at least 250 servo cycles.

Run `34110388709` from commit `6d94fd3...` is **NOT ACCEPTED**: the rounded sampler text never displayed a strict `abs(f-error) > f-error-lim` inequality even though the production following-error transition occurred. The instrumentation was materially redesigned to use stock pinned realtime `abs` + `comp` components after `motion-controller`.

Run `34115377323` from commit `a3258c9...` returned lab exit code 22 and is **HARNESS INVALID / NOT ACCEPTED**. It established Gate A, held feedback constant, had zero sampler overruns, independently observed the realtime strict-crossing predicate (`rt_crossed=1`), observed `f-errored`, the exact following-error diagnostic, joint error, motion disable, and amp-disable. The wrapper nevertheless retained the obsolete rounded-text `crossed < 1` exit gate, so it failed after the new realtime oracle had succeeded. `experiments/S04-014-run-34115377323-analysis.md` records the evidence and correction rationale.

Commit `df51c09cfc7f3265d595380ef3ec6140e716d1e1` removes only that obsolete decimal-text exit gate; it does not weaken the immutable experiment criteria. Corrected workflow `34122070072` is the authoritative current attempt.

Official current LinuxCNC documentation continues to describe `MIN_FERROR`/`FERROR` as a velocity-dependent following-error tolerance and says exceeding the allowable command-versus-sensed position difference disables servo calculations/amplifiers. Recent community guidance likewise points troubleshooting at `joint.N.motor-pos-cmd` versus `joint.N.motor-pos-fb` and thread/scaling placement. These are corroboration only; the pinned source and bounded experiment remain the course's version-specific evidence.

## Promotion / uncertainty queue — active additions

- S04 generic frozen-sensor detection thresholds and false-positive tradeoffs under true zero velocity: **current / HIGH** — the stationary-frozen adversarial control is required before graduation.
- S04 diagnostic freshness/disagreement patterns versus safety-rated diagnostic coverage: **S05/S06 + safety engineering / CRITICAL** — does not block S04 if ordinary diagnostic boundaries remain explicit; no PL/SIL/category claim is made.
- S04 device-specific heartbeat/timestamp/encoder diagnostic mechanisms: **2000 / HIGH** — useful stronger freshness evidence but not required to establish the 1000-level identifiability and following-error mechanisms.

All previously recorded promotion items remain active; consult module handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Continue **S04** from EXPERIMENT. Inspect workflow `34122070072` / source commit `df51c09cfc7f3265d595380ef3ec6140e716d1e1` and use the lab artifact's own exit code as oracle. Require Gate A healthy enabled moving loopback; >=0.20 requested move remaining at freeze; constant held feedback; realtime `comp.out` strict-crossing bit observed at least once; `f-errored`; exact following-error diagnostic; joint error with motion and amp-enable deasserted; zero sampler overruns; then fresh-runtime Gate D with >=250 stationary frozen cycles, no over-limit/comparator crossing, no `f-errored`/joint error, and retained motion/amp enable. If it passes, commit accepted result, adversarial exam/corrections, fresh-AI handoff, promotion/counterfactual audit, graduate S04, and activate S05. If it fails, classify the exact failed gate before any rerun and apply the three-attempt safeguard to the realtime-comparator harness family.
