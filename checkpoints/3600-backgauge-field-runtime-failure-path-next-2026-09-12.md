# 3600 Press-Brake Checkpoint — Backgauge Field Runtime + Failure Paths

Date: 2026-09-12

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. No correctly routed, genuinely information-separated evaluator result was present when this session checked repository state. It remains the sole known 2000-series graduation gate.

## New durable evidence

Two companion source audits now pin and trace the public field-oriented backgauge controller `aleadvea/press-brake-cnc-upgrade@95cf12f639b036f80541b00128e0a31c5dcc9050`:

- `research/press-brake-backgauge-field-runtime-source-audit-2026-09-12.md`
- `research/press-brake-backgauge-field-runtime-failure-path-addendum-2026-09-12.md`

The source exposes an actual recipe/AUTO runtime, bend-triggered retract, homing/alarm handling, HMI↔motor transport and pulse-generator position state. The repository README reports real-hardware prototype use; that claim remains project-reported, not independent physical verification.

## Refined ownership model

The source supports retaining the existing curriculum chain but adding one explicit distributed-command distinction:

`BendStep / TargetSet intent -> fresh local ExecutionEpisode -> local transport acceptance -> remote semantic acceptance -> fresh matching motion/feedback observation -> target qualification -> process-phase qualification`

Do not infer later stages from earlier ones.

Concrete source reasons:

- AUTO ignores the Boolean result of the MOVE send helper before entering local `AS_MOVING`.
- packets/status carry no command or generation ID and no remote semantic ACK.
- after movement has once been observed, later IDLE is treated as arrival without a final target-error check.
- HMI position is generated-step position, not an independent physical encoder witness.
- status has no explicit freshness/boot-generation witness in the inspected path.
- bend-end advances retract state without a separate retract-complete predicate.
- reset-alarm clears local HMI alarm state even though the send result is ignored.
- paired restart schedules the HMI restart without first proving the motor restart request was accepted.
- software STOP is separate from the project's hardware-wired emergency-stop boundary.

No existing PB-BG test result is invalidated. Instead, the real implementation gives field-source motivation for the already-frozen episode/freshness/completion ownership rules.

## Latest retained lab state checked this session

- PB-DXF-004: **TEST-CONFIRMED / Gates A–J 10/10**; accepted TargetSet provenance/generation discipline.
- PB-BG-004: **TEST-CONFIRMED / Gates A–J 10/10**; accepted TargetSet-generation -> fresh runtime-episode bridge.
- No new laboratory run was justified by this source audit. Exact cumulative lab compute therefore remains unchanged from repository state.

## Exact next-work checkpoint

1. **Re-check F02 first.** Preserve evaluator identity and response before changing its state.
2. Correctly routed F02 PASS/no corrections => graduate F02 and close the 2000 series unless the evaluator exposes a material defect.
3. If F02 is still blocked, do not create another synthetic backgauge protocol/ownership fixture merely to reproduce these source-visible failure surfaces.
4. Resume 3600 only when genuinely new implementation evidence can address one of the highest-value remaining gaps:
   - tandem Y1/Y2 command/correction/saturation/realtime-order/per-side fault ownership;
   - active sensor-bending measurement freshness/correction/saturation/recovery;
   - real tooling/datum-aware flange-to-backgauge target solver;
   - measured-coupon fitting/table-generation implementation.
5. Preserve PB-PREP-001 as **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION** unless new evidence actually resolves its discriminator.
6. Preserve explicit distinctions among command episode, transport/remote acceptance, controller enable, downstream readiness, fresh physical feedback, target completion, process phase and external safety authority.
7. Do not invent machine-specific hydraulic, pressure, tooling, material, springback, sensor-dynamics, stopping-performance, safety, or acceptance-tolerance values.

No laboratory compute was consumed in this source/failure-path pass.
