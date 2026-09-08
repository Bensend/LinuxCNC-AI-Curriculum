# C04-026 attempt 2 — valid behavioral reconciliation

Status: **BEHAVIORAL FAIL OF FROZEN GATE G / NEW PINNED-SOURCE FINDING**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Authoritative execution:

- source commit: `5f42434b2a67d79d8ea2ccaa9f17e902df8423e5`
- workflow: `34243768815`
- job: `102120345513`
- artifact: `10063237523`
- artifact digest: `sha256:1df44a9fcf6f5b7cb8fd08c21c512596b4d71eb213f62723b42c1d675496b578`
- retained raw trace SHA-256: `450f39fb8789cfcf371d2bc5d06d580d5dd4b33a33baa872d822dfe876b395e0`
- retained raw trace bytes/rows: `2426218 / 14262`
- inner experiment exit: `41`

The workflow itself completed successfully because the redesigned outer harness deliberately retained evidence and then exposed the inner status. The inner C04 analyzer correctly returned nonzero because frozen Gate G failed. This run is observation-valid and must not be relabeled HARNESS INVALID.

## Frozen gates

- Gate A — PASS
- Gate B — PASS
- Gate C — PASS
- Gate D — PASS
- Gate E — PASS
- Gate F — PASS after the predeclared observation-only tuple correction (`pidB.output` is tuple index 9, not index 8)
- Gate G — **FAIL**
- Gate H — PASS for the originally documented source boundary, but the result adds a source-semantic correction below

Key metrics:

- realtime samples: `14262`
- phase 1/2/3/4 rows: `1010 / 3011 / 3011 / 6014`
- `S1=0`
- `S2=0.230802668 in`
- `S3=1.473858666 in`
- `S4=0 in`
- cross-coupling arithmetic residuals: exactly zero
- phase-3 longest B-saturated-at-`+1.0` interval: `3011` consecutive rows
- phase-3 PID-A unsaturated fraction across that interval: `1.0`
- phase-3 PID-B saturated-count span: `3010`
- phase-4 PID-B unsaturated fraction over final 500 rows: `0.0`

The raw trace independently confirms Gate F. Early decisive phase-3 records show, in the same realtime sample, plant B gain `0.35`, `pidB.output=1.000000`, `pidB.saturated=1`, increasing `saturated-count`, and `maxoutput=1.000000`. By the end of phase 3 the count has risen above 3000 while B remains at `+1.0` and A remains unsaturated.

The raw trace also independently confirms the surprising Gate-G result. In the final phase-4 records, feedback A and B have converged exactly, both PID outputs are `1.000000`, plant gains are both `1.0`, and sampled PID-B `maxoutput=0.000000`; nevertheless `pidB.saturated` remains `1` and `saturated-count` continues increasing above 9000.

## Why Gate G legitimately fails

Pinned `pid.c::calc_pid()` updates `pid->limit_state` inside the `if (maxoutput != 0.0)` block. If `maxoutput` is nonzero and the computed output is inside the limit, `limit_state` is cleared. If the PID is disabled, `limit_state` is also cleared. But when the PID remains enabled and `maxoutput` is changed from a binding nonzero value to exactly zero, the entire output-limit block is skipped and **no assignment clears the previous `limit_state`**.

Immediately afterward, `saturated`, `saturated-s`, and `saturated-count` are driven solely from the retained `limit_state`. Therefore a loop that was saturated immediately before `maxoutput -> 0` can continue reporting saturation even though zero is documented to mean 'no limit' and the current output is no longer being clipped.

This behavior is still present in current LinuxCNC `master` as inspected during this reconciliation.

Current LinuxCNC PID documentation states both that `maxoutput=0` means no output limit and that `pid.N.saturated` means the **current** PID output is saturated (`output = +/- maxoutput`). The tested source/runtime behavior therefore exposes a documentation/telemetry-semantic mismatch for this dynamic transition.

## Teaching correction

Do not teach:

```text
pid.saturated == true
=> current output is necessarily being clipped by current maxoutput
```

Teach the stronger revision-aware rule:

```text
pid.saturated / saturated-count
must be interpreted with current maxoutput, enable state, transition history,
and pinned pid.c semantics.
```

At the tested revision, dynamically changing an enabled PID from a binding nonzero `maxoutput` directly to `0` can leave saturation telemetry stale because `limit_state` is not cleared on that path.

The physical/safety boundary remains unchanged:

```text
PID software saturation
!= physical actuator stall
!= drive current limit
!= hydraulic pressure/flow limit
!= sensor fault diagnosis
!= safety-rated fault decision
```

## Attempt-discipline decision

The frozen prediction that phase 4 would clear `pidB.saturated` merely by restoring plant gain and setting `maxoutput=0` is falsified. Do not alter C04-026 or silently retune Gate G.

Classification after the investigation-control boundary: **ESSENTIAL NOW, REDESIGN**. C04 still needs a valid recovery demonstration, but the redesign must explicitly account for the newly proven `limit_state` transition semantics. A new experiment ID is required; C04-026 remains permanently preserved as a useful behavioral failure.
