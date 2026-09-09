# C08 — `hal_stream` Documentation / Source Conflict

Pinned curriculum revision: `8bf4605ae81042248add031e94c77300406e0413`

Current development source observed during this session: LinuxCNC `master` search result at commit `64efb28cd77a16b45ade81e576c784cdc574f40e`.

Status: **CONFLICT RECORDED; SOURCE-CONFIRMED and bounded PREFLIGHT TEST-CONFIRMED at pinned revision**

## Conflict

Current LinuxCNC development documentation for `hal_stream(3)` states that `hal_stream_write()` increments the internal sample-number value whether or not the write succeeds. The same documentation says gaps in consumer sample numbers indicate an overrun.

Current documentation URL inspected 2026-09-09:

- `https://www.linuxcnc.org/docs/devel/html/nb/man/man3/hal_stream.3.html`

However, the actual implementation inspected at both the curriculum's pinned revision and current development source does something narrower.

In `src/hal/hal_lib.c`, `hal_stream_write()` first checks whether the FIFO is writable. If it is full it increments `num_overruns` and returns `-ENOSPC` before reaching the record-copy/sample-number increment. On successful enqueue only, it copies the record and executes the equivalent of:

```c
dptr[num_pins].s = ++stream->fifo->this_sample;
```

before publishing the new input index.

Pinned source evidence:

- LinuxCNC commit `8bf4605ae81042248add031e94c77300406e0413`
- path `src/hal/hal_lib.c`
- symbol `hal_stream_write`

Current-development source evidence:

- LinuxCNC commit exposed by GitHub code search: `64efb28cd77a16b45ade81e576c784cdc574f40e`
- path `src/hal/hal_lib.c`
- search excerpt still shows `dptr[num_pins].s = ++stream->fifo->this_sample;` on the successful-write path.

## Teaching decision

For the pinned C08 module, teach the source behavior, not the contradictory manual statement:

> A rejected producer write is proven by producer-side overrun state. The successfully enqueued record-number sequence can remain contiguous despite rejected realtime sample attempts.

Therefore consumer tag continuity alone is not sufficient evidence that every attempted realtime sample was retained.

This conflict is important because blindly trusting the manual's stated sample-number behavior could make a diagnostic harness falsely claim that consumer tags are a complete loss detector.

## Independent bounded verification

The experiment and discriminator were frozen before implementation in `experiments/C08-050-diagnostic-discrimination-trace-plan.md`.

C08-051 then executed the required **non-authoritative** depth-4 FIFO preflight at the pinned revision:

- workflow `34327928519`, job `102389431379`, artifact `10093374756`;
- producer reached `full=TRUE`, `curr_depth=3` and accumulated **31 overruns** while no consumer was attached;
- after production was disabled, the three successfully queued records drained with tags `[0, 1, 2]`;
- those tags were contiguous despite 31 proven rejected producer writes.

This independently confirms the pinned-source mechanism at smoke/preflight scale. Because C08-051 was explicitly non-authoritative for the full C08-050 experiment, this does **not** score the frozen C08 Gates A–J. A separate authoritative C08-052 execution is required for the full module claim.

## Version boundary

Do not generalize this conflict beyond inspected revisions. If `hal_stream_write()` changes later, re-check source and executable behavior rather than carrying this conclusion forward from prose.
