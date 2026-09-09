# X01 — Recorder perturbation and long-duration retention

Status: **RESEARCH / SOURCE / EXPERIMENT-FROZEN**  
Course level: **2000**  
Pinned LinuxCNC source: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective

A fresh AI engineer must be able to design LinuxCNC diagnostic recording that distinguishes machine/control behavior from recorder behavior. It must explain where `sampler` runs, where `halsampler` runs, how the shared HAL stream crosses realtime/userspace, how lost samples are detected, which recorder-health indicators are authoritative for which failure, and why a plausible retained trace is not sufficient evidence unless provenance and recorder integrity are also retained.

X01 exists because later X02 synchronized diagnostics and F02 compound-fault analysis need evidence that a recorder did not manufacture or hide the apparent timing relationship.

## Official documentation pass

Current LinuxCNC documentation describes `sampler` as the realtime producer and `halsampler` as the non-realtime consumer. `depth=` sizes the realtime-to-userspace FIFO. The realtime component exports FIFO depth/full/overrun state, while `halsampler -t` prints implicit sample sequence numbers; gaps in that sequence identify lost samples. `halsampler -n COUNT` exits successfully after COUNT retained samples, whereas an indefinite sampler normally exits failure when externally terminated.

Relevant official pages:

- https://www.linuxcnc.org/docs/master/html/en/man/man9/sampler.9.html
- https://www.linuxcnc.org/docs/master/html/en/man/man1/halsampler.1.html
- https://www.linuxcnc.org/docs/master/html/en/man/man3/hal_stream.3.html

The `hal_stream(3)` interface states that the stream carries an implicit sample number and that gaps returned by `hal_stream_read()` indicate an overrun between reads. It also exposes stream depth/max-depth and overrun counters. This is an important distinction: the retained record sequence belongs to the stream transport itself, not merely to a user-added timestamp pin.

## Community pass

Two field reports are especially useful investigation leads:

1. A 2022 forum report initially blamed unreliable capture timing on `sampler`; the eventual cause was userspace orchestration: asynchronous `subprocess.Popen`, an indefinite `halsampler`, and killing the reader before it had drained the FIFO. The corrected workflow stopped production, read the known FIFO depth with `-n`, and waited for the consumer to finish. This is a direct example of recorder lifecycle creating apparent missing data without proving a realtime sampling defect.
   - https://forum.linuxcnc.org/24-hal-components/46426-problems-with-sampler-halsampler-solved
2. A 2024 logging discussion recommends `sampler` for continuous HAL capture and `halscope` for trigger-oriented intermittent diagnostics. This reinforces that capture architecture should match the evidence question rather than treating every diagnostic surface as interchangeable.
   - https://forum.linuxcnc.org/24-hal-components/51202-live-logging-recording-of-hal-pin-states-possible

Community statements remain `COMMUNITY-REPORTED` until reconciled with source/experiment.

## Source inventory

| Path / symbol | Purpose | X01 significance | Evidence |
|---|---|---|---|
| `src/hal/components/sampler.c::sample()` | Realtime snapshot producer | Copies configured HAL inputs into one stream record and attempts `hal_stream_write()` | SOURCE-CONFIRMED |
| `src/hal/components/sampler.c::init_sampler()` | Exports sampler pins/function | Establishes `full`, `curr-depth`, `overruns`, `enable`, sample inputs and realtime function | SOURCE-CONFIRMED |
| `src/hal/components/sampler_usr.c::main()` | Userspace reader | Attaches to stream, waits readable, reads implicit sample number, prints `overrun` on discontinuity and optionally prints tags | SOURCE-CONFIRMED |
| `src/hal/hal_lib.c::hal_stream_write()` / `hal_stream_read()` | Shared stream transport | Underlies FIFO availability and implicit sample-number continuity | SOURCE-CONFIRMED from symbol/source search; deeper ring-buffer memory-order proof deferred |
| `docs/src/man/man3/hal_stream.3.adoc` | Stream API contract | Documents sample-number gap semantics and overrun accounting | DOC-CONFIRMED |

## Source-level function guide

### `sample(void *arg, long period)`

Execution context: realtime HAL function, scheduled only when the configuration adds `sampler.N` to a realtime thread.

Flow:

1. If `enable` is false, it does not emit a sample; it only refreshes `curr-depth` and `full`.
2. It snapshots every configured input into a local `hal_stream_data` array.
3. It calls `hal_stream_write()` once for the whole record.
4. On failure, the sample is discarded, `sampler.N.overruns` increments, `full=1`, and `curr-depth` is reported at max depth.
5. On success, `full=0` and current FIFO depth is refreshed.

Important implication: the configured values in one successful record are collected by one invocation of the realtime function, so they form a much stronger same-invocation observation than independent userspace `halcmd getp` calls. This does not make them simultaneous at analog/electrical level, and function order within the realtime thread still matters.

### `sampler_usr.c::main()`

Execution context: ordinary userspace.

Flow:

`hal_init -> hal_stream_attach -> wait_readable -> hal_stream_read(data,&this_sample) -> continuity check -> formatted write to stdout/file`.

The code maintains `last_sample`. If the next returned implicit sample number is not the expected successor, it emits an `overrun` line and updates its baseline. With `-t`, it prints `this_sample-1` before the sampled values.

The source therefore exposes two independent recorder-health evidence surfaces:

- producer-side write failures (`sampler.N.overruns`, `full`, FIFO depth);
- consumer-visible implicit sample-number discontinuities.

A trustworthy retained artifact should preserve both where practical.

## Source/documentation conflict discovered

At the pinned revision, `sampler.c` exports `sampler.N.sample-num`, but the inspected `sample()` implementation does not read or increment that exported pin. The actual sequence used by `halsampler -t` comes from the HAL stream's implicit sample number returned by `hal_stream_read()`.

Therefore X01 must **not** teach `sampler.N.sample-num` as the authoritative retained-record sequence without further version-specific verification. For X01 experiments, the oracle is the implicit stream tag plus producer overrun evidence. This is recorded as a version-sensitive documentation/source reconciliation item, not silently papered over.

## Call flow

```text
realtime thread
  -> sampler.N / sample()
     -> snapshot configured HAL pins
     -> hal_stream_write(record)
        -> success: record + implicit stream sequence retained in FIFO
        -> no space: record lost; producer overrun evidence increments

shared HAL stream / FIFO

userspace halsampler
  -> hal_stream_wait_readable()
  -> hal_stream_read(record, &implicit_sample_number)
  -> continuity check
     -> expected successor: ordinary row
     -> discontinuity: print `overrun`
  -> optional `-t` tag + values -> stdout/file
```

## Claims ledger

| Claim | Classification | Confidence | Verification needed |
|---|---|---:|---|
| `sampler` records in realtime; `halsampler` drains in userspace | SOURCE + DOC | high | bounded runtime proof |
| FIFO saturation loses new records rather than proving machine discontinuity | SOURCE + DOC | high | force saturation and inspect tags/counter |
| One retained sampler row is one invocation-level snapshot of configured HAL inputs | SOURCE | high | same-thread deterministic producer experiment |
| `halsampler -t` continuity comes from the HAL stream implicit sequence | SOURCE + DOC | high | execute forced-overrun fixture |
| Killing an indefinite reader can truncate undrained retained evidence | SOURCE + COMMUNITY | medium-high | controlled stop/drain experiment |
| Recorder load itself may perturb realtime timing at sufficiently high width/rate | INFERENCE | medium | X01-001 latency/servo-period comparison |
| A zero-gap retained file alone proves no producer-side recorder fault | false premise | high | X01-001 must retain producer counter independently |

## Failure modes

- **FIFO saturation:** realtime producer cannot write; data is lost and recorder-health evidence must show it.
- **Userspace drain termination:** capture can end with data still in FIFO; the resulting file can look clean but be incomplete.
- **Consumer/output backpressure:** slow filesystem/stdout processing can allow FIFO depth to rise until the realtime producer loses records.
- **Observation-order error:** independent recorders or userspace polling can tear cross-surface timing even if each individual value is valid.
- **Recorder perturbation:** adding a wide/high-rate realtime recorder consumes execution time and memory bandwidth; lack of sample loss does not by itself prove zero timing perturbation.
- **Evidence publication loss:** a technically correct run is unusable as durable evidence if raw trace, topology, thread order, health counters or provenance are not retained.

## Predeclared prediction for X01-001

Before the first laboratory run:

1. With a modest-width sampler in a 1 ms realtime thread and an adequately drained FIFO, retained implicit tags will be contiguous and producer overruns will remain zero.
2. If the userspace drain is intentionally withheld long enough to exceed FIFO capacity, `sampler.N.overruns` will become nonzero and later `halsampler -t` output will contain a tag discontinuity / `overrun` indication; the machine-side deterministic counter itself will continue advancing.
3. Stopping production first and then draining exactly the remaining FIFO depth will preserve the terminal retained samples more reliably than killing an indefinite reader while producer/consumer activity is still in flight.
4. Increasing recorder width/rate will measurably increase recorder execution cost, but X01 will not predeclare that it necessarily causes a servo deadline miss in the cloud environment. The experiment must measure rather than assume this.

## Higher-level boundary

X01 is about proving diagnostic evidence integrity in software. It does not prove filesystem durability under power loss, physical sensor simultaneity, safety-rated event logging, or deterministic Ethernet capture. Promote those only if later evidence shows they are prerequisites for a claimed capability.

## Exact checkpoint

Run frozen `experiments/X01-001-sampler-retention-perturbation.md`. Do not change the core gates after first execution merely to obtain a pass. First establish baseline/drain/forced-overrun behavior and recorder execution-cost evidence; only then decide whether a longer-duration retention phase is justified or needs a redesigned harness.
