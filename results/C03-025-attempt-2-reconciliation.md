# C03-025 attempt 2 reconciliation

## Classification

**HARNESS INVALID — transition-settle interval was attached to the old phase label.** No C03 behavioral claim is accepted from attempt 2.

Authoritative run: workflow `34227719033`, job `102065844076`, artifact `10056559295`, source commit `5056e1d858129eb9a946a300feb58e7a77c9d2b4`, inner exit `31`.

Attempt 2 again had valid provenance/topology, `0` sampler overruns, `11125` parsed realtime rows, and well over 500 rows in phases 2–4, but Gate C correctly rejected phase 2.

## Why the first correction was incomplete

Attempt 2 changed the sequence from:

```text
set next configuration
set next phase
```

to:

```text
set next configuration
wait 20 ms
set next phase
```

That prevents the *new* phase from being published before its configuration, but it creates the opposite problem at the *end* of the old phase. Example: while phase 2 is still published, attempt 2 sets `Kc=0.5` and waits 20 ms before publishing phase 3. Those 20 ms are correctly sampled as phase 2 with phase-3 configuration, violating frozen Gate C. The same issue can occur at the phase-3 -> phase-4 boundary.

So attempt 2 provides an adversarially useful result: a phase label must be withdrawn before configuration mutation, not merely delayed after mutation.

## Frozen attempt-3 correction

Gates A–H, control parameters, thresholds, decisive phase durations, and raw evidence requirements remain unchanged. Introduce an **unscored transition phase 0** around each configuration mutation:

```text
publish phase 0
wait 20 ms
write next configuration
wait 20 ms
publish next decisive phase
retain the original decisive dwell
```

Phase 0 is instrumentation only and is excluded by the already-frozen analyzer, which evaluates phases 2, 3, and 4 by explicit phase value. The pre-write settle prevents a new configuration from being observed under the previous decisive phase; the post-write settle prevents the next decisive phase from being observed with the old configuration.

This is not post-result row deletion. Transition cycles are labeled non-decisive before their configuration is changed.

If attempt 3 is also harness-invalid or behaviorally fails for a materially similar reason, apply the experiment plan's three-attempt rule before any fourth run.
