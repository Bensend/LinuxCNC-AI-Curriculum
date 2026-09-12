# 3600 Press-Brake Checkpoint — Real Backgauge Runtime Source

Date: 2026-09-12

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED** and requires a genuinely information-separated evaluator. It remains the sole known 2000-series graduation gate. Do not self-score or expose learner-side answer/audit artifacts to that evaluator.

## New evidence this session

A previously unexamined public implementation was source-traced:

- `aleadvea/press-brake-cnc-upgrade`
- pinned commit `95cf12f639b036f80541b00128e0a31c5dcc9050`
- durable audit: `research/press-brake-backgauge-field-runtime-source-audit-2026-09-12.md`

The implementation is a dual-ESP32 backgauge controller whose README reports a working real-hardware prototype. Its source exposes recipe rows, AUTO row advance, bend-sensor-driven retract, homing, alarm recovery, software Stop, command/status transport and pulse-generation position.

## What changed

The broad operator-program/runtime source gap is now partially closed with a real inspectable field-oriented implementation. It is **not LinuxCNC**, so LinuxCNC-specific Task/UI integration remains separate.

The source independently reinforces the existing PB-BG ownership contracts:

- MOVE packets have no command/generation/episode identity;
- after motion has started, HMI AUTO treats later IDLE as arrival without a final target-error check;
- reported position is generated-step count rather than independent physical feedback;
- status transport has no explicit freshness/sequence/boot-generation witness in the inspected path;
- bend end advances retract state without an independent retract-completion predicate;
- explicit HMI alarm gating is not uniform across every AUTO state;
- fault cause changes re-homing behavior;
- UI/software STOP is separate from the hardware emergency-stop path.

Refined runtime rule:

> Keep controller command completion, target-error qualification, physical feedback validity/freshness, process-phase events and external safety authority as separate witnesses. A generated position estimate must not silently substitute for physical feedback.

## Information-gain stop

Do not turn these findings into another synthetic fixture merely to reproduce already-visible source behavior. The useful discriminator was the real implementation itself.

## Exact next-work checkpoint

1. **Re-check F02 first every session.** Preserve the full identity/response of any correctly routed information-separated evaluator result before changing status.
2. Correctly routed F02 PASS/no corrections => graduate F02 and close the 2000 series unless that evaluation discovers a new material defect.
3. If F02 remains blocked, retain the current 3600 information-gain stop unless genuinely new public source appears.
4. Highest-value remaining implementation evidence is still one of:
   - tandem Y1/Y2 source exposing command producer, differential sign, correction insertion, downstream saturation/limits, realtime order and per-side fault/ferror ownership;
   - active sensor-bending source exposing measurement freshness/generation, phase qualification, correction authority, saturation and recovery;
   - a real flange/gauging-surface-to-backgauge target solver with explicit datums/tool geometry, or measured-coupon fitting/table-generation source.
5. Preserve PB-PREP-001 as **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**; do not retune its frozen discriminator.
6. Preserve `TargetSet -> fresh ExecutionEpisode` semantics and explicit freshness/completion witnesses even when field prototypes use simpler protocols.
7. Do not invent target-machine hydraulic, tooling, material, pressure, springback, sensor-dynamics, stopping-performance, safety or acceptance-tolerance values.

No laboratory compute was consumed in this source-audit pass.
