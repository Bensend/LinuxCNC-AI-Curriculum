# C05-029 attempt 8 reconciliation — HARNESS INVALID

Date: 2026-09-08
Workflow: `34261998718`
Job: `102181993196`
Artifact: `10070374620`
Source commit: `6406794f52f7e299705595de8c1d859235bb2d09`
Inner exit: `1`
Classification: **HARNESS INVALID — no C05 behavioral verdict**

## What succeeded

The source-audited one-FIFO redesign reached the intended LinuxCNC fixture. Gate-A provenance/topology prechecks passed, the machine homed and entered MDI, the 20-field sampler ran with `sampler-overruns=0`, and the artifact retained a complete-looking 6,571-line raw realtime trace plus LinuxCNC stdout/stderr and an empty `halsampler` stderr file. This is the first C05-029 attempt that eliminated the split-FIFO alignment family and retained one sequential sample-number stream.

## Decisive invalidation

The frozen analyzer did not execute. The inherited C05-029 generator builds the analyzer replacement as a shell here-document but then splices the generated body with:

```python
src=src[:ana_start]+analyzer+src[ana_end+len("\nPY"):]
```

That removes the original closing `PY` delimiter even though the replacement string opens `python3 - <<'PY'` and does not contain its own closing delimiter. The generated shell therefore lets Python consume the subsequent cleanup shell code and terminates with:

```text
warning: here-document ... delimited by end-of-file (wanted `PY')
SyntaxError ... printf 'gate-H-cleanup=PASS\n'
```

Because the analyzer and Gate-H cleanup did not execute, attempt 8 cannot satisfy frozen Gates B-H even though the raw transport itself improved materially.

## Additional observation-fidelity finding

Offline inspection of the retained one-FIFO rows exposed a separate, source-confirmed precision limitation that must be corrected before another authoritative run. Pinned `src/hal/components/sampler_usr.c` prints every `HAL_REAL` with C `printf("%f")`, i.e. six digits after the decimal point. The retained trace consequently shows roughly `1e-6` quantization in transform and same-row arithmetic residuals. Frozen C05-029 requires residuals `<=1e-9`; weakening that threshold is prohibited.

This is an observation/export limitation, not evidence that the realtime HAL arithmetic violated the equations. The next harness therefore must preserve the realtime sampler and frozen gates while using a test-only userspace stream reader format with enough digits to round-trip HAL real values. The pinned realtime components and controller behavior remain unmodified.

## Correction constraints

1. Preserve C05-029 Gates A-H and every behavioral value unchanged.
2. Preserve the one 20-field realtime FIFO; do not restore split-FIFO joining.
3. Preserve the original analyzer closing here-document delimiter.
4. Change only userspace observation serialization from `%f` to a round-trip-safe real format (planned `%.17g`) and print/hash the observer-only source patch as evidence.
5. Preserve the complete raw trace before analyzer exit and require zero overruns/strictly increasing sample numbers.
6. No interpolation, row deletion, phase relabeling, tolerance relaxation, gain changes, or fault retuning.

## Boundary

A higher-precision userspace representation improves observability only. It does not change the simulated plant, the realtime controller, the synthetic sensor fault, or the safety status of ordinary HAL/PID logic.
