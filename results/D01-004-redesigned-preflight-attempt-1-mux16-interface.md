# D01-004 — Redesigned preflight attempt 1: mux16 interface failure

## Classification

**HARNESS INVALID before P0 / redesigned-cycle attempt 1.** Frozen D01-002 P0–P8 behavioral semantics and Gates A–J remain **UNSCORED**.

## Run identity

- Workflow: `34347323567`
- Job: `102451918581`
- Repository commit: `8afb5c9c17fcf7b5343e30ff018573be1cfbe6a5`
- Lab job: `lab-jobs/015-d01-redesigned-observer-preflight.sh`
- Artifact: `10102345581`
- Artifact digest: `sha256:260208fade1d26cf1859941168648bef4d6e1f1a4e28be6ef25e3a1c1e8fe3d6`
- Inner lab UTC: `2026-09-09T11:46:48Z`–`2026-09-09T11:50:09Z`
- Inner exit code: `1`

## What was successfully established

The redesigned fixture compiled the pinned LinuxCNC revision with the minimal test-only Cartesian-Y observer and reached a real `motmod + trivkins` runtime. Readiness found `motion.d01-cart-y-observer` plus sampler pins. Retained topology showed both duplicated Y joints, both independent feedback/error surfaces, `motion.motion-enabled`, and the observer. Retained servo-thread order was:

```text
motion-command-handler
motion-controller
mux16.0
mux2.0
sum2.0
sampler.0
```

Thus the observer build/load portion and the intended realtime ordering survived the redesign.

## Actual failure

The run terminated on:

```text
<commandline>:0: parameter or pin 'mux16.0.sel': not found
```

This is a test-harness interface error, not a coupled-control behavioral result. Pinned/current `mux16.comp` exposes four boolean selectors `mux16.N.sel0` through `sel3` and a floating output `mux16.N.out-f`; it does not expose an aggregate `mux16.N.sel` or `mux16.N.out`.

The original D01-015 harness therefore contained two related invalid names:

```text
mux16.0.sel
mux16.0.out
```

Neither changes the experiment hypothesis; both are phase-marker wiring defects.

## Correction boundary

Redesigned attempt 2 may change only the phase-marker adapter:

- encode phase integer 0–8 onto `sel0..sel3` in binary;
- use `mux16.0.out-f` as the sampled phase signal;
- preserve D01-002 P0–P8 timing/meaning, numeric offsets and following-error thresholds;
- preserve observer placement immediately after `do_forward_kins()`;
- preserve realtime ordering and atomic sampler channels;
- do not score Gates A–J in a preflight.

`lab-jobs/016-d01-redesigned-observer-preflight-mux16-fix.sh` implements exactly that correction and records its generated diff before execution.

## Evidence-quality conclusion

This attempt is useful fixture evidence but **not authoritative behavior evidence**. It validates that the redesigned source observer can compile/load and that the target HAL objects/order exist; it does not validate MDI motion, duplicate divergence, hidden Cartesian disagreement, following-error trip, or machine-wide motion revocation because the phase control failed before those phases ran.
