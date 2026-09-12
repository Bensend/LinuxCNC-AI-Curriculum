# Active Curriculum Session State

Session start UTC: `2026-09-12T18:10:53Z`
Session end UTC: `2026-09-12T18:12:53Z`
Actual elapsed: **2.0 minutes**
Status: **CLOSED — F02 external gate preserved; 3600 Ursviken final-config source-availability boundary verified.**

## Critical path

`handoffs/F02-fresh-ai-compound-fault-transfer.md` remains **PREPARED / UNSCORED**. No correctly routed information-separated evaluator result was found, so F02 remains the sole known 2000-series graduation gate and was not self-scored.

## Work completed

New durable artifacts:

- `research/3600-ursviken-final-config-availability-audit-2026-09-12.md`
- `checkpoints/3600-ursviken-final-config-availability-next-2026-09-12.md`

A fresh inspection of all four currently exposed LinuxCNC forum pages for the Ursviken/Pullmax retrofit verified the exact source-availability boundary rather than relying on generic search failure.

The public chronology still ends on 2026-07-22, where NWE reports a successful 90-degree bend using two per-side position PIDs plus a differential sync PID (`command=0`, feedback from `Y1-Y2`, slowing the leading side), then states that the configuration will be shared after remaining loose ends are completed. The first post remains last edited 2025-12-18; it does not contain the later tandem configuration.

The older 2025-12-09 “complete config” is explicitly an early snapshot centered on joint 6 and predates the later Y1/Y2 tandem implementation. It must not be treated as final tandem source.

The February design posts also show an evolving split between a generic press-state component and a machine-specific `pullmax-optima` interface, but the final implementation remains unavailable. Therefore exact addf order, feedback producers/units/freshness, sync correction insertion/sign/selection, final presence/absence of inner velocity loops, downstream limiting/saturation, dither/deadband behavior, process gating, ferror/disagreement ownership, and fault/recovery semantics remain SOURCE UNAVAILABLE / UNKNOWN.

Adversarial boundary review passed **6/6**. A direct public/GitHub search for `pullmax_optima.comp` found no inspectable source outside the forum discussion. No synthetic lab was run because another PID/addf fixture would not resolve the absent machine implementation; laboratory compute is unchanged.

## Next checkpoint

1. Re-check F02 first and preserve evaluator identity/header plus full response before changing status.
2. Correctly routed F02 PASS/no corrections closes F02 and the 2000 series unless a material defect is identified.
3. If F02 remains blocked, keep the tandem branch at the current source-availability stop.
4. Reopen only if the promised final Ursviken config/component becomes public, a forum attachment becomes directly inspectable, or equivalent real source exposes the complete read -> feedback/differential -> PID/sync -> correction/limits -> hardware-write graph and recovery semantics.
5. Do not substitute the December early config or another synthetic ordering fixture for the missing final source.
6. PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**.

Overlap: **No overlap.** Previous completed canonical lesson ended `2026-09-12T17:18:07Z`; this session began `2026-09-12T18:10:53Z`, **52m46s later**.

Short-session continuation check: the useful unblocked task was to verify whether the promised final config had actually become public and search for `pullmax_optima.comp` elsewhere. Both paths were exhausted without new inspectable implementation source. Further progress on this branch now depends on new external source rather than additional synthetic work.
