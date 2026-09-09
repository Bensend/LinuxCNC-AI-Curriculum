# C06-039 Sampler/Stream Attach Diagnostic Reconciliation

## Classification

**NON-AUTHORITATIVE DIAGNOSTIC PASS.** This run does not score or modify frozen C06-030 Gates A–H.

- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Curriculum source commit: `554dcd79bec5eaeb42a13a454a6e7efb27f5a695`
- Workflow: `34310141125`
- Job: `102334943692`
- Artifact: `10088152204`
- Job start/end: `2026-09-09T04:13:51Z` / `2026-09-09T04:18:21Z`
- Exact job compute: 4.5 min
- Inner lab exit: 0

## Predeclared discriminator

The diagnostic removed HostMot2, `hm2_test`, all C06 fault phases, and C06 signal topology while retaining the exact observation stream configuration from C06-037/038:

```text
depth=30000
cfg=uubbbuuuub
halsampler -c 0 -n 10 -t
```

Prediction before execution:

1. If this exact stream reproduced `hal_stream_attach: Invalid argument`, the problem would belong to stream configuration/environment rather than HostMot2/C06 phase logic.
2. If exact failed but documented-small `depth=100 cfg=uffb` succeeded, size/type-layout would be the leading discriminator.
3. If exact succeeded, C06-037/038 required an interaction introduced by the HostMot2 fixture or fuller harness.

## Observed result

`lab-results/run-34310141125-1/summary.txt` records:

```text
CASE exact depth=30000 cfg=uubbbuuuub: halsampler_rc=0 parseable_rows=10
DIAGNOSTIC VERDICT: exact C06 sampler stream attaches successfully in isolation.
```

The fallback small-control case was therefore correctly not needed.

## Source reconciliation

Pinned `src/hal/components/sampler.c` creates the realtime stream before exporting the sampler function and calling `hal_ready()`. Pinned `src/hal/components/sampler_usr.c` performs `hal_init()`, `hal_ready()`, then attaches to `SAMPLER_SHMEM_KEY + channel` with `typestring=NULL`.

Pinned `hal_stream_attach()` first opens/maps the stream header, requires `HAL_STREAM_MAGIC_NUM`, optionally validates a caller-provided type string, calculates the full size from the retained FIFO header, then reopens/maps that full size. Because `halsampler` supplies `typestring=NULL`, explicit attach-time type-string mismatch is not a candidate for the C06-037/038 error.

C06-039 proves the exact depth/type string itself creates a compatible stream and userspace reader on the same pinned build/runner class. Therefore the prior `-EINVAL` is **not explained by `depth=30000`, `cfg=uubbbuuuub`, or generic sampler/userspace attachment in isolation**.

## Community/documentation check

Current LinuxCNC sampler/halsampler manuals describe the same contract: realtime `sampler` creates a FIFO in shared memory and `halsampler` reads that FIFO; FIFO depth is intended to absorb non-realtime stalls. No credible community report was found that specifically explains this pinned `hal_stream_attach: Invalid argument`, so community search does not override the source/runtime discriminator.

## Correction / next discriminator

Do not modify frozen C06 behavioral gates and do not launch another authoritative run yet.

The next non-authoritative diagnostic is `lab-jobs/041-c06-fixture-sampler-interaction-diagnostic.sh`, frozen/committed after this result. It adds the accepted C06-036 HostMot2/pattern-15 fixture in two stages:

1. fixture + exact sampler, without C06 signal wiring;
2. if stage 1 attaches, the full static P0 signal/sampler topology, still without P1–P6 fault phases.

This separates fixture/HAL interaction from net/pin/startup-topology interaction. Only after the failing precondition is localized and a combined attach preflight passes may an authoritative C06-030 behavioral retry be justified.
