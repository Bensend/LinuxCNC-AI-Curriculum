# D01-005 — Redesigned preflight attempt 2: phase-helper definition order

## Classification

**HARNESS INVALID before behavioral phases / redesigned-cycle attempt 2.** Frozen D01-002 Gates A–J remain **UNSCORED**.

## Run identity

- Workflow: `34349942532`
- Job: `102460454507`
- Source commit: `5d6cc1c3d0163262d043f0ffafc1934f8b5e099a`
- Job: `lab-jobs/016-d01-redesigned-observer-preflight-mux16-fix.sh`
- Artifact: `10103396597`
- Digest: `sha256:e7cd694772b0dcb0812557ac2780f64782a1fdbf0e5e81bfb3622b85444820c0`
- Inner lab UTC: `2026-09-09T12:15:12Z`–`2026-09-09T12:19:04Z`
- Exit: `127`

## Progress established

The source-grounded mux16 correction was valid. Runtime topology now retained the expected D01 signals and the servo thread reached:

```text
motion-command-handler
motion-controller
mux16.0
mux2.0
sum2.0
sampler.0
```

The corrected fixture also showed the actual following-error limit output at startup and the observer loaded successfully. Thus attempt 1's invalid HAL object names are resolved.

## Actual failure

The generated corrected script called `set_phase 1` before the wrapper-inserted `set_phase()` shell function had been defined:

```text
.../d01-016-preflight.sh: line 171: set_phase: command not found
```

This is generator/helper ordering only. No LinuxCNC coupled-control hypothesis is contradicted and no behavioral gate is scored.

## Attempt-3 correction boundary

`lab-jobs/017-d01-redesigned-observer-preflight-phase-helper-fix.sh` regenerates from D01-015 but inserts the same four-bit phase helper immediately after cleanup/trap setup, before the atomic recorder and before P1. It keeps the validated `mux16.0.sel0..sel3` / `mux16.0.out-f` interface and changes no frozen phase meaning, offset, ferror threshold, observer placement, channel set, realtime order, or gate predicate.

If attempt 3 fails, apply the curriculum three-attempt rule to this redesigned preflight lineage rather than continuing incremental wrapper repairs blindly.
