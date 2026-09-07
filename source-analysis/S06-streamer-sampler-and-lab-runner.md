# S06 source analysis — streamer, sampler, stream FIFO, and curriculum lab runner

- Module: S06 — fault injection framework
- Course level: 1000
- LinuxCNC source revision: `8bf4605ae81042248add031e94c77300406e0413`
- Curriculum lab runner inspected: `.github/workflows/lab-runner.yml` at blob `9ee21f372fcd5bbba687af97655bcfe8534a7e8b`

## Why this pass matters

S06 needs a reusable experiment method that separates three different facts:

1. the harness actually injected the intended fault;
2. the production/stock mechanism under test actually responded;
3. the evidence capture itself was healthy enough to support the conclusion.

`streamer` and `sampler` are useful stock primitives, but their source semantics impose boundaries that must be explicit before S06-016 is frozen.

## `src/hal/components/streamer.c`

### `rtapi_app_main()`

**SOURCE-CONFIRMED at the pinned revision.** `streamer` initializes a HAL component, allocates per-stream state with `hal_malloc()`, creates each FIFO with `hal_stream_create()`, exports the configured pins/functions, then calls `hal_ready()`.

A valid stream therefore has two layers:

- non-realtime data is placed into a shared FIFO by `halstreamer`/another stream writer;
- realtime function `streamer.N` consumes at most one FIFO record on an eligible realtime invocation and publishes the record to HAL output pins.

### `update(void *arg, long period)`

Execution context: realtime HAL function, invoked in whichever HAL thread the configuration adds `streamer.N` to.

Behaviorally significant path:

1. determine whether this invocation is eligible to clock based on `enable`, `clock`, and `clock-mode`;
2. publish FIFO `curr-depth` and `empty` status even if disabled;
3. if not clocking, return and **retain the existing output pin values**;
4. if clocking but FIFO depth is zero, increment `underruns` and return; output pins again retain their prior values;
5. otherwise read one FIFO element with `hal_stream_read()` and copy each typed field to its configured HAL output pin.

### Fault-injection implications

- A streamer underrun can produce a **stale retained output value** because the function returns without changing its data pins. This is a real source semantic, but an S06 experiment using it must not pretend that the cause is packet loss, device loss, or physical sensor freeze.
- `streamer.N.empty`, `curr-depth`, and `underruns` can independently show that the FIFO/input side was starved. They prove a streamer/FIFO condition, not a downstream subsystem response.
- `halstreamer` is a non-realtime feeder. Therefore an experiment whose core claim depends on *exactly which servo cycle* userspace happens to enqueue a record risks testing host scheduler timing rather than the intended LinuxCNC mechanism.
- A fully prefilled stream can still be useful for deterministic sequences. It is less attractive for the first S06 framework experiment because S06 also needs deterministic one-cycle corruption and age/skew cases whose schedule should not depend on userspace refill timing.

## `src/hal/components/sampler.c`

### `rtapi_app_main()`

**SOURCE-CONFIRMED at the pinned revision.** `sampler` creates realtime-to-userspace FIFO(s), exports typed input pins plus status pins, exports `sampler.N`, then calls `hal_ready()`.

### `sample(void *arg, long period)`

Execution context: realtime HAL function, at the point in the configured thread where `sampler.N` is placed.

Behaviorally significant path:

1. if disabled, update only FIFO depth/full status and return;
2. read all configured HAL input pins into one local record in that same function invocation;
3. call `hal_stream_write()` to enqueue the record;
4. on full FIFO, increment `overruns`, mark full, and lose that sample;
5. otherwise publish current depth/full status.

### Evidence implications

- If `sampler.N` is ordered **after** both the injection path and the downstream observer, one FIFO row can contain the injected values and the observer outputs from the same realtime invocation. This is materially stronger than unrelated userspace `getp` polling.
- `sampler.N.overruns == 0` is an evidence-health condition. If samples are lost, exact-duration or single-cycle claims may be invalid even when the target subsystem behaved correctly.
- `halsampler` is only the non-realtime drain. The realtime sampling point is `sampler.N` itself.
- The source exports `sample-num`, but the inspected realtime `sample()` body does not increment or otherwise use that field. S06-016 therefore must **not** rely on `sampler.N.sample-num` as its cycle/freshness oracle. The fixture will sample an explicit realtime sequence/cycle value instead.

## Stream FIFO API boundary

Pinned HAL declares `hal_stream_create/read/write` with the explicit invariant that only one reader and one writer are allowed per stream. Current official documentation likewise describes streamer/sampler as shared-memory FIFO bridges between realtime and non-realtime contexts.

For S06 this means:

- FIFO depth/overrun/underrun data is valid evidence about the stream transport inside the HAL test harness;
- it does not establish device, network, FPGA, or physical I/O semantics;
- a stream writer or reader is part of the harness and must be included in harness-invalid criteria when the experiment depends on it.

## Curriculum `.github/workflows/lab-runner.yml`

The runner already provides a durable outer envelope:

- explicit job-file identity;
- repository source commit / workflow run / attempt;
- UTC runner start and finish;
- runner identity;
- 70-minute inner timeout inside a 75-minute workflow ceiling;
- complete stdout/stderr capture;
- raw lab-job exit code;
- per-run directory plus `LATEST.*` convenience files;
- uploaded workflow artifact retained for 30 days;
- readable result committed back to the curriculum repository;
- workflow failure if the lab job's own exit code is nonzero.

### Limitation

The runner currently treats stdout/stderr and exit code as opaque. It has no standard machine-readable distinction among:

- PASS gate;
- product/behavioral FAIL gate;
- HARNESS INVALID;
- injected-fault evidence;
- subsystem-response evidence;
- recovery evidence;
- evidence-health conditions such as sampler overrun;
- non-claims.

S06 therefore defines a **job-produced result JSON** rather than changing the general runner immediately. If the schema proves useful across later modules, runner-level automatic collection can be promoted as tooling work.

## Decision: S06-016 source mechanism

Use one **tiny test-only realtime source/fault-scheduler component** plus stock HAL observer/capture components, rather than `streamer` as the stimulus source.

Rationale:

1. the experiment needs deterministic cycle-numbered healthy, freeze, single-cycle jump, and one-cycle age/skew windows;
2. userspace `setp`/FIFO refill timing would make a one-cycle claim scheduler-dependent;
3. the test component is not the subsystem oracle — it only emits stimulus and explicit sequence values;
4. downstream response is independently computed by stock HAL components and captured by stock `sampler` after both source and observer execute;
5. raw sampled values themselves prove whether the intended injection happened, avoiding reliance on a self-declared `fault-active` bit.

This is a **materially bounded test double**, not a claim about physical hardware, HostMot2, Ethernet, or safety-rated fault coverage.

## Reusable ordering rule

For deterministic value-path experiments, prefer this thread order:

`test stimulus/fault source -> production/stock observer path -> sampler`

Then verify the actual function order from `halcmd show thread` before accepting behavioral evidence.

## Claims ledger additions

| Claim | Classification | Evidence / scope |
|---|---|---|
| Streamer retains output values when disabled or when a clocked read finds no FIFO data | SOURCE-CONFIRMED | pinned `streamer.c::update()` |
| Streamer userspace feed is asynchronous to the realtime consumer | SOURCE-CONFIRMED + DOC-CONFIRMED | pinned source architecture and current manpage |
| Sampler captures configured HAL pins in its realtime function before enqueuing one record | SOURCE-CONFIRMED | pinned `sampler.c::sample()` |
| Sampler FIFO overrun loses a sample | SOURCE-CONFIRMED + DOC-CONFIRMED | pinned `sampler.c`; current sampler docs |
| `sampler.N.sample-num` is unsuitable as the S06 cycle oracle at the pinned revision because inspected `sample()` does not update it | SOURCE-CONFIRMED | pinned `sampler.c` |
| A tiny realtime scheduler is preferable to `streamer` for the first S06 exact-cycle injection fixture | INFERENCE / DESIGN DECISION | avoids userspace scheduler dependence while preserving independent downstream oracle |

## Promotion note

Changing the generic lab runner to ingest/result-index the machine-readable schema is useful but does not block S06. The framework can prove the schema first as a job artifact/stdout section; runner integration can be promoted after at least one accepted experiment demonstrates which fields are actually stable and useful.
