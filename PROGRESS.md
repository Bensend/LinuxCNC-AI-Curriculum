# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through S03 are **GRADUATED** at 1000 level. **S04 — stale/frozen feedback** is now **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

S04 source work has a complete representative production path in `call-flows/S04-frozen-feedback-to-following-error.md`: `joint.N.motor-pos-fb` is sampled by `process_inputs()`, corrected into `pos_fb`, compared against moving `pos_cmd`, tested against the velocity-dependent following-error limit, converted by `check_for_faults()` into joint error plus cleared enabling intent, disabled by `set_operating_mode()`, and published through `output_to_hal()` as `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored`, `joint.N.error`, `joint.N.amp-enable-out`, and `motion.motion-enabled`.

The trace preserves two exceptions: homing index-search wait may substitute command for feedback around the encoder index step, and homed extra joints force following error to zero. Following error is therefore a command/feedback mismatch detector, not a generic sample-age detector.

Experiment S04-014 remains governed by the immutable gates in `experiments/S04-014-feedback-freeze-plan.md`: `MIN_FERROR=0.010`, `FERROR=0.100`, velocity limit 1.0 unit/s, about 0.5 unit/s commanded velocity, runtime `joint.0.f-error-lim` as the threshold oracle, a move with at least 0.20 units of requested travel remaining at freeze, and a clean stationary-frozen control for at least 250 servo cycles.

The production harness now derives from the pinned `tests/linuxcncrsh` simulation. It replaces only the joint-0 command→feedback loopback with a realtime `mux2` pass-through/explicit-hold path and samples motor command, motor feedback, following error, runtime following-error limit, f-errored, joint error, amp enable, and motion enabled after the controller/mux in servo-thread order. Production motion source is not modified.

A pre-run audit caught an implementation mistake in the first committed job: it required actual post-freeze `motor-pos-cmd` motion of 0.20 units before accepting Gate B. That is incompatible with the expected earlier disable at the runtime following-error limit. Run `34110287441` from commit `d8e0467...` is therefore **HARNESS INVALID BY PRE-RUN REVIEW** for acceptance purposes even if it completes. The corrected wrapper `lab-jobs/014-s04-feedback-freeze-corrected.sh` preserves the immutable plan by requiring >=0.20 requested move remaining at freeze while requiring observed command/feedback mismatch to exceed the actual runtime limit. Corrected workflow `34110388709` from commit `6d94fd3...` is the authoritative S04-014 run to inspect.

## Promotion / uncertainty queue — active additions

- S04 generic frozen-sensor detection thresholds and false-positive tradeoffs under true zero velocity: **current / HIGH** — core limitation is being tested now.
- S04 diagnostic freshness/disagreement patterns versus safety-rated diagnostic coverage: **S05/S06 + safety engineering / CRITICAL** — does not block S04 if ordinary diagnostic boundaries remain explicit; no PL/SIL/category claim is made.
- S04 device-specific heartbeat/timestamp/encoder diagnostic mechanisms: **2000 / HIGH** — useful stronger freshness evidence but not required to establish the 1000-level identifiability and following-error mechanisms.

All previously recorded promotion items remain active; consult module handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Continue **S04** from EXPERIMENT. Inspect corrected workflow `34110388709` / source commit `6d94fd397c33380ff887f442dcb457fa163f546a` and use the lab's own artifact and exit code as the oracle. Ignore workflow `34110287441` for acceptance because its impossible 0.20-actual-travel gate was rejected before results. For the corrected run require: Gate A enabled moving healthy loopback; freeze changes only feedback selection; requested move has >=0.20 units remaining; sampled frozen feedback remains constant; sampled `abs(f-error)` exceeds sampled runtime `f-error-lim`; `f-errored` asserts; a following-error diagnostic is captured; the transition includes joint error with motion and amp-enable deasserted; zero sampler overruns; then a fresh runtime Gate D captures >=250 stationary frozen cycles with command/feedback unchanged, no over-limit sample, no f-errored/error, and motion/amp enable retained. If the corrected harness cannot establish baseline or isolation, classify HARNESS INVALID rather than interpreting it. If PASS, commit accepted result, adversarial exam/corrections, fresh-AI handoff, promotion/counterfactual audit, and graduate S04 before activating S05.