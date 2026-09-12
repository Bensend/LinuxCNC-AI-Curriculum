# 3600 Ursviken final-config availability — next checkpoint

Date: 2026-09-12

## Current state

F02 remains PREPARED / UNSCORED and the sole known 2000-series graduation gate. Do not self-score it.

A fresh inspection of all four currently exposed Ursviken/Pullmax forum pages confirms that the public thread still ends at the 2026-07-22 report of a successful 90-degree bend using two position PIDs plus a differential sync PID, followed by the statement that the config would be shared after loose ends were completed. No later final tandem config is exposed, and the first post remains last edited 2025-12-18.

Durable research: `research/3600-ursviken-final-config-availability-audit-2026-09-12.md`.

## Exact next work

1. Re-check F02 first. Preserve evaluator identity/header and full information-separated response before changing status.
2. If F02 PASS/no corrections appears, graduate F02 and close the 2000 series unless the evaluator identifies a material defect.
3. If F02 remains blocked, keep the tandem branch at the source-availability stop.
4. Do not substitute the 2025-12-09 early config snapshot for the final tandem implementation; it predates the later Y1/Y2 architecture and was explicitly incomplete for that purpose.
5. Reopen tandem source work only if the promised final config/component becomes public, a forum attachment becomes directly inspectable, or an equivalent real implementation exposes the complete execution graph.
6. Required evidence remains: exact feedback producers/units/freshness, `addf` order, differential producer, sync correction sign/selection and insertion, any inner velocity loops, downstream limiting/saturation, dither/deadband handling, process gating, ferror/disagreement ownership, and fault/disable/recovery behavior.
7. Do not run another synthetic PID/addf fixture merely to compensate for missing machine implementation source.
8. PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION**.
