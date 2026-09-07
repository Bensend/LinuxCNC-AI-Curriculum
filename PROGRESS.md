# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through S03 are **GRADUATED** at 1000 level. **S04 — stale/frozen feedback** is now **SOURCE** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

S04 source work now has a complete representative production path in `call-flows/S04-frozen-feedback-to-following-error.md`: `joint.N.motor-pos-fb` is sampled by `process_inputs()`, corrected into `pos_fb`, compared against moving `pos_cmd`, tested against the velocity-dependent following-error limit, converted by `check_for_faults()` into joint error plus cleared enabling intent, disabled by `set_operating_mode()`, and published through `output_to_hal()` as `joint.N.f-error`, `joint.N.f-error-lim`, `joint.N.f-errored`, `joint.N.error`, `joint.N.amp-enable-out`, and `motion.motion-enabled`.

The trace also preserves two exceptions: homing index-search wait may substitute command for feedback around the encoder index step, and homed extra joints force following error to zero. Following error is therefore a command/feedback mismatch detector, not a generic sample-age detector.

Current official LinuxCNC documentation independently describes `MIN_FERROR`/`FERROR` as a velocity-dependent allowable command-versus-sensed-position deviation and explicitly explains why a nonzero stationary tolerance is needed. Community reports are retained only as field evidence that scaling/configuration mistakes can cause apparent following errors; they are not used to establish the implementation.

Experiment S04-014 is predeclared in `experiments/S04-014-feedback-freeze-plan.md`. Numerical targets are `MIN_FERROR=0.010`, `FERROR=0.100`, velocity limit 1.0 unit/s, test velocity about 0.5 unit/s, and at least 0.20 units commanded after moving freeze. Runtime `joint.0.f-error-lim` is the acceptance oracle. Gate D requires a separate stationary-frozen case for at least 250 servo cycles and predicts no following-error trip when command and feedback remain equal.

## Promotion / uncertainty queue — active additions

- S04 generic frozen-sensor detection thresholds and false-positive tradeoffs under true zero velocity: **current / HIGH** — core limitation is being tested now.
- S04 diagnostic freshness/disagreement patterns versus safety-rated diagnostic coverage: **S05/S06 + safety engineering / CRITICAL** — does not block S04 if ordinary diagnostic boundaries remain explicit; no PL/SIL/category claim is made.
- S04 device-specific heartbeat/timestamp/encoder diagnostic mechanisms: **2000 / HIGH** — useful stronger freshness evidence but not required to establish the 1000-level identifiability and following-error mechanisms.

All previously recorded promotion items remain active; consult module handoffs and prior history for their full rationale.

## Current checkpoint / exact resume point

Continue **S04** from SOURCE. Implement `lab-jobs/014-s04-feedback-freeze.sh` from the immutable predeclared plan. Reuse the smallest known-good headless one-joint simulation/harness from prior motion labs where possible. Insert a controllable feedback pass-through/hold between `joint.0.motor-pos-cmd` and `joint.0.motor-pos-fb` without modifying production motion source. Before launch, verify the harness can capture `motor-pos-cmd`, `motor-pos-fb`, `f-error`, `f-error-lim`, `f-errored`, `error`, `amp-enable-out`, and `motion.motion-enabled` at servo-cycle or sufficiently high rate. Run Gate A healthy baseline, Gates B/C moving freeze and following-error disable, then a clean Gate D stationary-frozen control for >=250 servo cycles. Preserve raw logs and the lab's own exit code. Do not infer physical encoder failure coverage, stop time, STO, or functional safety from a pass.