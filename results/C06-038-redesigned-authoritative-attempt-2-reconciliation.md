# C06-038 redesigned authoritative attempt 2 reconciliation

Status: **HARNESS INVALID before P0 / sampler-race hypothesis falsified**

Frozen C06-030 Gates A–H remain unscored.

## Metadata

- Curriculum source commit: `c291d7c41c63164506a515f68e813f56fc739996`
- Workflow run: `34306960420`
- Job: `102325539319`
- Artifact: `10087055819`
- Artifact digest: `sha256:4f373bf2c0c6d2f60bb04165c72b28a4caad8466179af5b9b28f85eb0bd486c0`
- Job start: `2026-09-09T03:23:55Z`
- Job end: `2026-09-09T03:27:30Z`
- Exact compute: 215 s = **3.6 min**
- Inner lab exit: `27`

## Correction tested

C06-038 strengthened the startup barrier from C06-037. It did not launch userspace `halsampler` until all four of these objects existed:

- `hm2_test.0.watchdog.has_bit`
- `hm2_test.0.io_error`
- `sampler.0.pin.9`
- `sampler.0.enable`

It also required the `halsampler` process to remain alive and produce at least 50 trace rows before P1.

## Result

Even after the realtime sampler-owned objects existed, userspace `halsampler` exited with:

```text
hal_stream_attach: Invalid argument
HARNESS_INVALID: halsampler exited before P0 observation
```

Therefore the C06-037 failure was **not merely an early-attach race with `loadrt sampler`**. This attempt again produced no authoritative P0–P6 observation. No LinuxCNC transport/watchdog behavior is scored.

## Source implications

Pinned source establishes the boundary to investigate next:

- realtime `sampler.c` creates the channel through `hal_stream_create(..., SAMPLER_SHMEM_KEY+n, depth, cfg)`;
- userspace `sampler_usr.c` initializes a HAL userspace component and calls `hal_stream_attach(..., SAMPLER_SHMEM_KEY+channel, NULL)`;
- `hal_stream_attach()` can return `-EINVAL` from stream/shared-memory validation even after sampler HAL pins exist.

Because the second run disproved the simple object-readiness race, another authoritative C06-030 retry would be unjustified harness tuning.

## Frozen diagnostic checkpoint

Before another behavioral run, execute a **non-authoritative minimal sampler/stream diagnostic** against the same pinned LinuxCNC build, without `hm2_test` or C06 phases:

1. load one realtime thread plus `sampler` with the exact C06 `depth=30000 cfg=uubbbuuuub`;
2. prove `sampler.0.pin.9`, `.enable`, `.sample-num`, `.curr-depth`, and `.overruns` exist;
3. record RTAPI/HAL stream/shared-memory state before userspace attach;
4. run `halsampler -c 0 -n 10 -t` and retain stderr/exit code;
5. if it fails, repeat only the diagnostic with a small known-good stream from pinned LinuxCNC documentation (for example `depth=100 cfg=uffb`) to distinguish C06 configuration/size from a general userspace-attach environment problem;
6. source-trace the exact `hal_stream_attach()` `-EINVAL` path supported by the observed diagnostic state.

Do not change frozen C06-030 phases, failure threshold, watchdog injection, or Gates A–H as part of this diagnostic. Only after the attach failure is understood and a minimal sampler preflight passes may C06-030 behavioral execution resume.
