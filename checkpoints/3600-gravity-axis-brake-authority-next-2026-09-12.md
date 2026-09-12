# 3600 next-work checkpoint — gravity-loaded axis brake / PID authority

Date: 2026-09-12

## Critical gate

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. No correctly routed information-separated evaluator result was found this session. Re-check F02 first next session and preserve the evaluator identity/header and full response before changing F02 status.

## New durable result

See `research/3600-gravity-axis-brake-pid-authority-field-failure-2026-09-12.md`.

A public Ursviken/Pullmax press-brake retrofit diary reports a gravity-loaded R-axis field failure in which the mechanical brake prevented expected motion while an enabled position loop retained authority; persistent error drove the DC servo hard enough to overheat and destroy it. The same chronology later reports brake logic briefly re-applying during sufficiently slow commanded motion. These are **COMMUNITY-REPORTED FIELD FAILURES**; the exact attached machine configuration is not publicly inspectable from the anonymous source used here.

Pinned stock LinuxCNC `pid.c` at `f325d51f52da7d5e0e227ac35e3672ee6f873b4f` confirms the relevant controller boundary: when enabled, PID integrates/acts from command and feedback and only knows its own configured `maxoutput`/`maxerrorI` limits. `pid.N.saturated` witnesses the component's own output clipping, not physical brake release, amplifier readiness, external current limiting, hard-stop contact, encoder validity, or actual motion. When PID enable is false, its integral state is reset and output forced to zero, but that does not by itself validate external brake/drive/reference state.

Therefore **mechanical holding-brake state/authority must remain distinct from motion command, PID output, LinuxCNC enable, amplifier readiness/fault, feedback freshness/tracking, and completion**.

The 5/5 adversarial boundary check passed. No synthetic lab was launched because software-only simulation would not validate mechanical brake or motor thermal behavior, while the software mechanism is already source-visible and the physical consequence is represented by field evidence.

## Next allowed work

If F02 remains blocked:

1. Do not invent universal brake release/engage delays, stall thresholds, current limits, or safety logic.
2. Reopen this brake/auxiliary-axis branch only if a complete public config/component exposes the actual brake-release/engage, drive-enable/readiness, stall/tracking, homing, and recovery state machine, or another inspectable implementation supplies equivalent evidence.
3. Keep PID saturation classified as an internal controller witness unless downstream actuator evidence explicitly establishes more.
4. Keep the existing 3600 source gates: tandem Y1/Y2 requires inspectable correction insertion/saturation/order/fault ownership; active sensor bending requires freshness/phase/correction/saturation/recovery source; backgauge calculation requires an explicit-datum tooling/gauging-surface-to-target implementation.
5. Preserve PB-PREP-001 as **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION** and do not create another generic ownership fixture merely to consume a lesson.
