# 3600 tandem cascade ordering — next checkpoint

Date: 2026-09-12

## Current state

F02 remains PREPARED / UNSCORED and is still the sole known 2000-series graduation gate. Do not self-score it.

The Ursviken/Pullmax field chronology now has a source-grounded execution-order interpretation:

- February field report: per-side position PID output fed a per-side velocity PID command and velocity PID output drove each servo valve.
- July field report: successful 90-degree bend with two per-side position PIDs plus a differential sync PID (`command=0`, feedback `Y1-Y2`) that slows the leading side.
- LinuxCNC `pid.c` at `f325d51f52da7d5e0e227ac35e3672ee6f873b4f`: each PID instance exports an independent realtime function.
- HAL scheduling: functions run in `addf` order; therefore same-cycle cascade/sync behavior depends on explicit function order.

Durable research: `research/3600-tandem-cascade-ordering-source-reconciliation-2026-09-12.md`.

## Exact next work

1. Re-check F02 first. Preserve a correctly routed evaluator identity/header and full response before changing F02 status.
2. If F02 PASS/no corrections appears, graduate F02 and close the 2000 series unless the evaluation identifies a material defect.
3. If F02 remains blocked, do **not** run another synthetic tandem/cascade fixture merely to demonstrate `addf` ordering; that behavior is already source/documentation-confirmed and the missing information is machine implementation evidence.
4. Reopen the tandem branch only when the promised final Ursviken config or equivalent inspectable HAL/component source appears.
5. Required source evidence must be sufficient to reconstruct:
   `hardware read -> Y1/Y2 feedback -> differential -> outer PIDs -> sync PID -> correction insertion -> optional inner velocity PIDs -> downstream limiting/mapping -> hardware write`.
6. Specifically capture exact `addf` order, velocity feedback producer/units, correction sign/selection, saturation/limit stages, valve dither/deadband handling, process-state gating, feedback freshness/disagreement, faults and recovery.
7. Preserve the distinction between controller-local saturation and downstream physical authority.
8. PB-PREP-001 remains **INCONCLUSIVE / NO ARCHITECTURE RECOMMENDATION** until the missing implementation evidence exists.
