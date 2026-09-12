# 3600 next-work checkpoint — tooling/gauge workflow boundary

Date: 2026-09-12

## Critical gate

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. No correctly routed information-separated evaluator result was found this session. Re-check F02 first next session and preserve the evaluator identity/header and full response before changing F02 status.

## New durable result

See `research/3600-commercial-tooling-gauge-workflow-boundary-2026-09-12.md`.

Official LVD and Delem documentation confirms a production workflow in which product geometry, machine/tools, bend preparation, bend sequencing, automatically computed axis/gauge positions, and collision/feasibility simulation are related planning stages. LVD explicitly distinguishes tooling-aware bend preparation from generic material/thickness-only unfolding.

This is **commercial documentation evidence, not implementation source**. It does not disclose the gauging-surface -> X/R/Z solver, target equations, collision kernel, sensor-bending correction loop, tandem synchronization, realtime order, recovery, or safety behavior.

## Next allowed work

If F02 remains blocked:

1. Do not guess a backgauge formula from commercial capability descriptions.
2. Resume the backgauge calculation branch only if inspectable implementation source exposes an actual gauging-surface/tooling -> target transformation or a reproducible implementation with explicit datums can be verified.
3. Resume tandem Y1/Y2 only if implementation source exposes correction insertion, downstream limits/saturation, realtime order, ferror/fault/disable ownership.
4. Resume active sensor bending only if implementation source exposes measurement freshness/generation, cycle phase, correction authority/insertion, saturation and recovery.
5. Do not create another generic calculator, interpolation fixture, or ownership-only synthetic lab merely to consume a lesson.

PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**. Existing PB-DXF/PB-BG test-confirmed artifacts remain authoritative within their frozen scopes.
