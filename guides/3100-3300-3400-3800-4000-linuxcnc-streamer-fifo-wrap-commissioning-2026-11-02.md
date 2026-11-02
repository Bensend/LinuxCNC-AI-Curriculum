# HAL-STREAM-156 — disconnected streamer FIFO wrap and completion walkthrough
**2026-11-02 | 3100/3300/3400/3800/4000 | source-reviewed, NOT RUN**

This exercise tests a **LinuxCNC realtime HAL queue**, not an actuator. Use a physically disconnected simulation environment only. Read [source audit](../research/4400_LINUXCNC_HAL_STREAM_156_STABLE_WRAP_DEPTH_FALSE_EMPTY_AND_DEVELOPMENT_RING_SOURCE_AUDIT_2026-11-02.md) first. Pinned LinuxCNC v2.9.10 `86cdca76fa2a36274c432caa21952b23c267989a`, development `67437d8865e431a9a33f74cee912dbf891d3b4c5`.

## Reproducible minimal fixture
From the curriculum repository root on a **qualified, disconnected** LinuxCNC installation, review [`streamer_wrap.hal`](../examples/4000_hal_stream_156/streamer_wrap.hal), [`first3.txt`](../examples/4000_hal_stream_156/first3.txt), [`last1.txt`](../examples/4000_hal_stream_156/last1.txt). The fixture uses a 1 ms HAL thread, `streamer depth=4 cfg=s`, `sampler depth=512 cfg=sbs`, and the exact upstream `tests/mux/test.hal` ordering: streamer first, sampler second. No motion, `motmod`, hardware, GPIO or physical output is loaded.

The HAL file queues 11/22/33 with `loadusr -w halstreamer` **before** `start`; this avoids the producer racing the first three reads. It then starts the realtime thread and captures 20 sampler rows with `loadusr -w halsampler -n 20`, allowing all three entries to drain. Only then does it queue 44, followed by another 20-row capture. The source HAL file can be supplied to `halrun` (for example `halrun examples/4000_hal_stream_156/streamer_wrap.hal`, matching upstream `tests/loadrt.2/test.sh` and `tests/tp/circle-curvature/test.sh` usage); confirm command-line syntax locally before use. Preserve stdout, stderr, exit codes, `uname -a`, `linuxcnc -v`, source/tag identity, and a complete HAL pin listing. Do **not** dispatch a GitHub-hosted Actions job.

### Expected observations (freeze before executing)
| Case | Stable v2.9.10 predicted | Inspected development predicted | Discriminator |
|---|---|---|---|
| A. Initial three enqueues before `start` | producer exits success; FIFO has three entries | same | EOF is producer completion, not pin delivery |
| B. First three realtime callbacks | output 11,22,33; status pre-dequeue 3,2,1 and `empty=FALSE` | same | `sampler` after `streamer` captures same-callback status |
| C. Next idle callback | output holds 33; `curr-depth=0`, `empty=TRUE` | same | output retention, not forced zero |
| D. Enqueue fourth 44 after three drain | stable indices `in=0,out=3`, actual unread 1 but `curr-depth=0`, `empty=TRUE`; 44 not delivered | development `in=4,out=3`, reported 1 and output becomes 44 | **primary versioned wrap discriminator** |
| E. Additional idle callbacks | output remains 33, `underruns` increases once per callback (freerun clock) | output remains 44 after consumption; `underruns` increases after queue empties | distinguish queue status from physical output |
| F. Change `clock-mode=2` and hold clock LOW after draining | no new reads and no new underruns without a rising edge | same | doc's “whenever empty” claim is conditional on valid clock |

**Timing qualifications:** HAL pin observations and userspace stdout are not perfectly simultaneous. With `sampler` following `streamer` in the same thread, sampler captures the post-streamer pin/status snapshot, but the first `halsampler` process may attach after some rows have accumulated. A 512-slot capture FIFO and only 40 total 1-ms callbacks make overrun unlikely; inspect `sampler.0.overruns` rather than assuming no loss. On a busy system, check actual thread scheduling and whether any input file/relative path failed. Case D's index reasoning assumes no additional producer writes during the decisive callback.

## Mechanism and exact source navigation
1. `src/hal/components/streamer_usr.c::main`: `hal_stream_wait_writable` then `hal_stream_write`; EOF returns 0.
2. `src/hal/hal_lib.c::hal_stream_create, hal_stream_advance, hal_stream_writable, hal_stream_readable, hal_stream_depth, hal_stream_read`: compare stable modulus `depth` and wrong wrapped `+depth-1` against development modulus `depth+1` and correct wrapped `+depth+1`.
3. `src/hal/components/streamer.c::update`: observe pre-dequeue status, `depth==0` return, and last-value hold. `streamer.0.underruns` is not a count of physically missed machine events.
4. `src/hal/components/sampler.c::sample` and `sampler_usr.c::main`: record outputs after streamer executes, with independent FIFO-overrun check.
5. `docs/src/man/man9/streamer.9.adoc`: reconcile “current depth” and “empty” language with the callback's actual order. `tests/mux/test.hal` is a **source/example reference**, not test evidence for this new wrap oracle.

## Interpretation and implementation decision
A stable v2.9.10 positive reproduction would justify reviewing the [one-line stable-only candidate patch](../examples/4000_hal_stream_156/stable_2910_hal_stream_depth_wrap_one_line.patch) for `hal_stream_depth` wrapped arithmetic **with the existing depth-slot ring retained**; do **not** transplant development's `depth+1` formula without also changing allocation and wrap modulus. A production-quality change must test empty/full boundaries, wrap with one pending entry, multiple pending entries, sampler telemetry, `halstreamer` EOF and mode/enable transitions. Avoid using FIFO `empty` as a completion interlock or assuming final HAL pin zero. If a physical actuator is involved, stop this software-only exercise and use separate qualified commissioning/safety controls.

**Evidence:** source and documented examples inspected; fixture created; **no execution performed**. No hardware, independent evaluation, Actions job or compute minutes.

**Upstream-history qualifier:** development commit [5a1776f83214 (2026-10-13)](https://github.com/LinuxCNC/linuxcnc/commit/5a1776f832141dca919f8732ee052d315dbdb131) changes FIFO capacity N−1→N and adjusts tests. Its *parent* already used correct `+depth` wrapped arithmetic for the older ring. Do not transplant the development `+depth+1` expression alone into stable. Stable `sampler.N.curr-depth` can also underreport a wrapped FIFO by one; its write gate uses `hal_stream_writable` and does not share the streamer's false-empty read gate.
