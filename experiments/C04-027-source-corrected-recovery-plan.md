# C04-027 — source-corrected saturation recovery

Status: **FROZEN BEFORE IMPLEMENTATION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Prerequisite: C04-026 valid behavioral failure and `results/C04-026-attempt-2-behavioral-reconciliation.md`.

## Reason for redesign

C04-026 proved the intended B-only saturation and persistent disagreement, but falsified its phase-4 telemetry prediction. Pinned `pid.c::calc_pid()` does not clear `limit_state` when an enabled PID transitions directly from a binding nonzero `maxoutput` to `maxoutput=0`; zero skips the entire output-limit block. Therefore `saturated`/`saturated-count` can remain stale even though output clipping is no longer active.

C04-027 changes only the recovery representation. It does **not** retune the phase-3 authority bound, cross-coupling gain, PID gains, plant asymmetry, duration, or pass thresholds.

## Frozen topology and phases

Retain C04-026 topology and values exactly through phase 3:

1. Phase 1: plant A/B `1.0/1.0`, `Kc=0.5`, B `maxoutput=0`.
2. Phase 2: plant A/B `1.0/0.35`, `Kc=0.5`, B `maxoutput=0`.
3. Phase 3: plant A/B `1.0/0.35`, `Kc=0.5`, B `maxoutput=1.0`.
4. Phase 4 recovery: plant A/B `1.0/1.0`, `Kc=0.5`, B `maxoutput=1000.0` for >=3 s.

`1000.0` is a deliberately nonbinding **finite** recovery sentinel, not a tuned machine limit. Its purpose is to force execution through the pinned source branch that explicitly assigns `limit_state=0` when the computed output is inside a nonzero bound. It is intentionally orders of magnitude above the toy fixture's nominal ~1 unit/s drive demand. It must never bind in decisive phase-4 rows.

Use the validated phase-publication discipline and same-cycle realtime sampler. Preserve raw evidence regardless of analyzer result.

## Frozen Gates A–H

Gates A–F and H retain C04-026 definitions and thresholds, with the already-corrected Gate-F field mapping to `pidB.output`.

Gate C recovery provenance changes only as required by this redesign: phase-4 B `maxoutput` must be exactly `1000.0` rather than `0`.

### Gate G — source-corrected reversible recovery

Let `S3` and `S4` be the same final-500-row mean absolute A/B feedback separations used by C04-026.

PASS only if all hold:

- `S3 >= 0.10 in`;
- phase-4 PID-B `saturated=false` in >=99% of the final 500 rows;
- phase-4 `abs(pidB.output) < 1000.0` in 100% of evaluated phase-4 rows, proving the sentinel is nonbinding;
- phase-4 B `saturated-count` returns to zero in >=99% of the final 500 rows;
- `S4 <= 0.60 * S3`.

This gate tests recovery while explicitly traversing the source path that clears `limit_state`; it does not erase the C04-026 finding that direct `maxoutput -> 0` may leave stale telemetry.

## Predeclared interpretation

If C04-027 passes, the durable lesson is two-part:

1. bounded local PID authority can coexist with active cross-coupling and sustained A/B disagreement;
2. at the pinned revision, saturation telemetry has transition-history semantics when `maxoutput` is dynamically changed to zero, so a source-aware clearing transition is required before treating the telemetry as current-state evidence.

No result may promote PID saturation to physical-cause or safety authority.

## Exact checkpoint

Implement C04-027 from the corrected C04 fixture. Change only phase-4 B `maxoutput 0 -> 1000.0`, Gate-C expected provenance, Gate-G nonbinding/reset checks, experiment identifiers, and the already-established Gate-F output index correction. Execute one authoritative run and reconcile raw phase-3 and phase-4 records against this frozen plan.
