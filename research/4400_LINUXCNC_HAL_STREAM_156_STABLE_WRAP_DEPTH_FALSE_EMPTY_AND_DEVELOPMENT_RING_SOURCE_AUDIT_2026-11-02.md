# HAL-STREAM-156 — stable v2.9.10 FIFO wrap can report false empty and strand a streamer sample
**2026-11-02 | LinuxCNC-first 4000 implementation; 3100/3300/3400/3800 transfer | NON-GRADUATED**

## Provenance and novelty
- Stable LinuxCNC **v2.9.10**, commit [86cdca76fa2a36274c432caa21952b23c267989a](https://github.com/LinuxCNC/linuxcnc/commit/86cdca76fa2a36274c432caa21952b23c267989a): [`src/hal/hal_lib.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/hal_lib.c) blob `0ed9b444f96fea3dc88d54016a8d51c20ff8f1a2`; [`src/hal/components/streamer.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/streamer.c) blob `1cef07eb6fea4347c5feccf0b026160ea07edc32`; [`streamer_usr.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/streamer_usr.c) blob `c307c8e1a4e5c0cb979f31bb1b894e0743520865`; [`sampler.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/sampler.c) blob `e9ea741f7b8c69af82faef3be7598af9a953294f`.
- Development **master**, commit [67437d8865e431a9a33f74cee912dbf891d3b4c5](https://github.com/LinuxCNC/linuxcnc/commit/67437d8865e431a9a33f74cee912dbf891d3b4c5): `hal_lib.c` blob `d5d84107e8cfbaf970d91030b66f0753695f150e`; `streamer.c` blob `737492575425e019076dd5c4411f451a75d13e90`.
- Official [streamer(9)](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/man/man9/streamer.9.adoc), blob `a343e7c72c8c4d41f17e3276fed83722205251be`; [halstreamer(1)](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/man/man1/halstreamer.1.adoc), blob `df947fa05103cf45c55eed131d97f40a172e9c61`; actual upstream [`tests/mux/test.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/tests/mux/test.hal), blob `ee1c4e18b938144f63a91045b394e254cd065939`, demonstrates `streamer` → realtime function → `sampler` ordering and `loadusr -w halsampler`.
- Predecessor search: complete `PROGRESS.md`, `LESSON_LOG.md` and `LAB_COMPUTE_LOG.md` text checked for `halstreamer`, `streamer.0.empty`, `streamer.c`, FIFO drain/wrap. No prior canonical treatment or matching runtime lab was found. This is not the earlier HALCMD-149 `loadusr -W` readiness question. Search negatives are not proof that no other archived source exists.

## End-to-end execution path
1. Userspace `halstreamer` (`streamer_usr.c::main`) parses one input row per configured HAL pin, attaches to shared-memory stream, waits for writable space, calls `hal_stream_write`, and exits successfully at EOF. **Process exit means submitted to FIFO, not consumed by realtime.**
2. `hal_lib.c::hal_stream_create` sets the shared ring's `depth`; stable allocates **depth slots**, reserves one slot to distinguish full/empty, and therefore permits **depth − 1 queued samples**. `hal_stream_advance` wraps at `n >= depth`; `hal_stream_writable` compares the next input index with output index; `hal_stream_readable` compares `in != out`.
3. `hal_lib.c::hal_stream_write` copies data and advances `in`; `hal_stream_read` copies data and advances `out` using release-store. This is a single-reader/single-writer queue, not a motor/physical-output acknowledgment.
4. Realtime `streamer.c::update` (called once per scheduled `addf streamer.0 <thread>`) samples clock and enable, calls **`hal_stream_depth`**, publishes `streamer.0.curr-depth` and `streamer.0.empty` **before dequeue**, then if clocked and `depth == 0` increments `streamer.0.underruns` and returns **without invoking `hal_stream_read`**. If read succeeds, the last HAL output pin value remains until a later successful read.
5. `sampler.c::sample` writes a separate FIFO and publishes depth after writing; `halsampler` reads it in userspace. This is a suitable software-only witness of streamer output/status on the same servo callback when `addf sampler.0` follows `addf streamer.0`.

## Finding A — stable wrapped depth is off by one (SOURCE-CONFIRMED)
In stable `hal_stream_depth`:
```c
int result = in - out;
if(result < 0) result += stream->fifo->depth - 1;
```
The ring's wrap modulus is **depth**, not depth − 1. Therefore whenever `in < out`, the reported depth is **one less than actual unread entries**. For a ring with `depth=4`, `out=3`, `in=0`, one entry is readable (`in != out`), but `hal_stream_depth` reports `-3 + 3 = 0`. This is not merely a stale GUI value: `streamer::update` tests the incorrect depth and skips the read. With no further producer write, the last queued value is **stranded indefinitely** while `empty=TRUE` and `underruns` increments on each enabled clock event. **SOURCE-CONFIRMED control flow; runtime stall is a conditional INFERENCE pending execution.**

### Frozen four-sample oracle (no concurrent writer during the decisive callback)
Stable `depth=4`:
| Step | in | out | True unread | Reported depth | Realtime effect |
|---|---:|---:|---:|---:|---|
| enqueue 11,22,33 before start | 3 | 0 | 3 | 3 | no realtime callbacks yet |
| consume 11,22,33 | 3 | 3 | 0 | 0 | output 33 |
| enqueue 44 | 0 | 3 | 1 | **0** | queue readable but `streamer` declares empty |
| subsequent enabled callback | 0 | 3 | 1 | **0** | output stays 33; underrun increments; 44 not delivered |

A later producer write changes `in` and can make the stalled value readable again. Therefore the conclusion is **not** permanent corruption of the FIFO and does **not** imply an always-stalled streamer. It is a specific wrap/last-item state.

## Finding B — development ring layout fixes this arithmetic (SOURCE-CONFIRMED)
At inspected development commit, `hal_stream_create` allocates **depth + 1 slots**, `hal_stream_advance` wraps when `n > depth`, and `hal_stream_depth` uses `depth + 1 + in - out` when `out > in`. The intended capacity is now **depth**, rather than stable's depth − 1. With `depth=4`, after consuming 11,22,33, the next enqueue moves `in=4`, `out=3`, and the fourth item is read. This is a **versioned source difference**, not a claim that all downstream distro builds use this implementation. No separate patch is proposed without confirming the desired stable backport and tests.

## Finding C — pre-dequeue status and output hold remain in both revisions (SOURCE-CONFIRMED)
Both inspected `streamer::update` versions publish `curr-depth` and `empty` **before** consuming the current item. On a callback consuming the last item, status still says `curr-depth=1` and `empty=FALSE`; the following callback reflects zero if no writer has added data. The last output value persists on empty/disabled/nonclocked callbacks. In edge-clock modes, `underruns` increments **only on an eligible clock**, not every callback with `empty=TRUE`; official streamer(9) prose saying it increments whenever empty is true is too broad. Asynchronous producer writes mean status is a sampled queue observation, not a globally atomic completion barrier.

## Engineering consequence and boundary
This affects replayed non-motion test waveforms, diagnostic fixtures, and any ordinary HAL sequence that mistakes `empty` or `halstreamer` EOF for delivery/consumption. The HAL streamer is **not** a safety-rated motion sequencer. Never use its final retained output or its empty bit alone as proof that a physical axis, spindle, torch or actuator stopped. For a genuine machine sequence, require separately designed command/feedback/completion authority and independent personnel safety.

## Verification and counterexamples
[Disconnected fixture and run card](../guides/3100-3300-3400-3800-4000-linuxcnc-streamer-fifo-wrap-commissioning-2026-11-02.md) uses the upstream pattern and a deliberately staged `depth=4` wrap. **ALL CASES NOT RUN**; no LinuxCNC binary, compiler, HAL, simulation, FPGA, machine, evaluator or Actions compute used in this lesson. A stable trace delivering 44 despite the frozen `out=3,in=0` state would falsify the predicted stall and require reinspection of the actual binary, ring indices, source revision and scheduling. An inspected development build still exhibiting stable's ring formula would invalidate the claimed version boundary for that build.

## Next source symbols / uncertainty
Inspect `hal_stream_depth` callers beyond `streamer` and `sampler`; identify whether stable patch/backport exists on another maintained branch; execute A–F only on positively qualified disconnected `[self-hosted, openpressbrake]` compute if evidence gain justifies it. **Do not conflate SOURCE with TEST.** No 1000/2000/3000 graduation change or safety-course/evaluator change.
