# X01-001 preflight attempt 3 — three-attempt reconciliation

Session start: 2026-09-10T01:14:17Z

## Scope and provenance

- Workflow: `34420657736`
- Head commit: `45cb4c16b717d85889326467433e115096df4358`
- Retained artifact: `10130835265`
- Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`
- This was clean-lineage preflight attempt **3/3**. Frozen P0–P5 and Gates A–J were not scored.

## Artifact-level result

Attempt 3 fixed the zero-padded indexed-pin harness defect and, unlike attempts 1–2, executed the behavioral cases. Retained evidence shows:

- baseline producer overruns `0`;
- stop/drain producer overruns `0` and FIFO drained to depth `0`;
- forced-loss FIFO reached `full=TRUE` with producer overruns already `191`, later `202`;
- the deterministic source counter advanced from `275` before drain to `458` afterward despite recorder loss;
- narrow timing retained `servo-thread.time=173`, `tmax=2214`, producer overruns `0`;
- wide timing retained `servo-thread.time=859`, `tmax=2546`, producer overruns `0`.

The final preflight predicate failed with `(0, 0)` because the forced-loss trace contained neither literal `overrun` lines nor discontinuities in the `halsampler -t` sequence tag. Direct inspection of the retained trace shows its tags remained contiguous `0..219` while the sampled deterministic source counter jumped across producer-loss intervals.

## Mechanism correction

This is **not another pin-name/harness typo** and must not be repaired by a fourth materially similar run.

The previous X01 source trace correctly established that `halsampler -t` prints the HAL stream's implicit sample sequence, not `sampler.N.sample-num`. Attempt 3 now provides independent runtime evidence that this stream sequence numbers **successful stream records**: producer-side `hal_stream_write()` failures caused by FIFO saturation increment `sampler.0.overruns`, but do not necessarily create a discontinuity in the sequence of later successfully written records. Therefore the frozen predicate

> forced recorder loss must appear as either a userspace `overrun` marker or a numerical `-t` tag gap

is contradicted by the pinned implementation/runtime behavior.

The deterministic payload counter is the stronger oracle for missing producer records in this fixture: it advances every source invocation before `sampler.0` runs, while only successfully enqueued records are retained. A payload-counter discontinuity together with producer `sampler.0.overruns > 0` distinguishes recorder loss from a claim that the source/control function stopped executing.

## Three-attempt decision

Classification: **ESSENTIAL NOW — materially redesign the experiment before another attempt.**

Reason: X01 exists to establish a trustworthy recorder-integrity contract for downstream X02. Promoting or ignoring an incorrect loss oracle would make later evidence unsound. The next experiment cycle must be a documented redesign, not clean-lineage attempt 4.

Required redesign:

1. Preserve producer-side `sampler.0.overruns`, FIFO depth/full, process status and raw trace.
2. For forced FIFO loss, use discontinuity in the deterministic payload cycle counter as the retained missing-record oracle; do **not** require a `halsampler -t` tag gap.
3. Treat `-t` tag continuity as successful-stream-record ordering evidence only at this pinned revision.
4. Preserve the recorder/control distinction: payload source counter must continue advancing while recorder overruns accumulate.
5. Re-freeze revised predicates/Gates before executing a redesigned preflight. Do not tune thresholds from a new run.
6. Keep narrow/wide timing evidence quantitative and bounded; do not infer hard realtime deadline safety from one cloud runner.

## Learning-method note

The three-attempt ceiling worked as intended: attempts 1–2 exposed syntactic harness defects; attempt 3 reached the intended behavior and exposed a **model/oracle error**. A fourth patch-and-rerun would have hidden that distinction. Future preflights should distinguish implementation failures from oracle falsification explicitly.

## Exact next checkpoint

Create a materially redesigned X01-002 (or explicitly revised X01-001 with a new frozen lineage) whose forced-loss oracle is payload-counter discontinuity + producer overrun evidence. Reconcile the original Gates A–J text before execution, then launch a new preflight cycle. X02 remains blocked until the redesigned X01 recorder-integrity contract is accepted.
