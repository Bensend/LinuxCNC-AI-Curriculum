# C06-037 redesigned authoritative attempt 1 reconciliation

Status: **HARNESS INVALID before authoritative observation**

Frozen C06-030 Gates A–H remain unscored. The analyzer's printed `Gate B: FAIL` and downstream FAIL lines are not behavioral evidence because the single realtime observation stream never attached and contained zero samples.

## Metadata

- Curriculum source commit: `506cd5b3e270964729dcd8f4132eb9385b0db68d`
- Workflow run: `34306570963`
- Job: `102324397610`
- Artifact: `10086921222`
- Artifact digest: `sha256:be8333f742b28fe042aed3c196fd09e82907ca685145fd636470493373316998`
- Job start: `2026-09-09T03:17:52Z`
- Job end: `2026-09-09T03:21:20Z`
- Exact compute: 208 s = **3.5 min**
- Inner lab exit: `41`

## Valid pre-observation evidence

Gate-A prerequisites were reached: the pinned LinuxCNC checkout matched, the exact C06-036 preflight-tested fixture patch applied cleanly, production HostMot2 source integrity remained unchanged, and the real watchdog topology registered.

## Harness defect

Immediately before the analyzer, `halsampler` reported:

```text
hal_stream_attach: Invalid argument
```

The trace therefore contained **0 parseable atomic rows**. No P0–P6 state transition can be scored from this run.

The readiness barrier in the job waited only for `hm2_test.0.watchdog.has_bit` and `hm2_test.0.io_error`. Those objects are created by `hm2_test`/generic HostMot2 before the later interactive-HAL commands necessarily finish loading/configuring `sampler`. The controller then launched userspace `halsampler` as soon as those two earlier objects appeared. This permits a race in which `halsampler` calls `hal_stream_attach()` before channel 0's realtime sampler stream exists.

Pinned source supports this classification:

- realtime `sampler.c` creates the stream with `hal_stream_create(... SAMPLER_SHMEM_KEY+n ...)` during `loadrt sampler`;
- userspace `sampler_usr.c` later calls `hal_stream_attach(... SAMPLER_SHMEM_KEY+channel, NULL)` and exits on a negative attach result;
- the failed run's readiness proof did not test any sampler-created object.

The fixture itself is not implicated: C06-036 already compiled/loaded it, and C06-037 again passed fixture/provenance setup before the stream-attach error.

## Correction classification

This is the **first attempt in the redesigned behavioral harness family** following the mandatory clean-fixture preflight. It is not a fourth incremental attempt in the retired `033 -> 034 -> 035` wrapper family.

The next attempt may make one observation-harness-only correction: require a sampler-owned object such as `sampler.0.pin.9` (and preferably `sampler.0.enable`) to exist before launching `halsampler`. Frozen P0–P6 phases, threshold 3, fake watchdog status register `0x2004:0`, production source, and Gates A–H must not change.

## Analyzer hardening

A zero-row / failed-attach condition must be classified HARNESS INVALID before behavioral gate scoring in future runs. The corrected job should explicitly test that the `halsampler` process remains alive and that initial rows appear before entering P1.
