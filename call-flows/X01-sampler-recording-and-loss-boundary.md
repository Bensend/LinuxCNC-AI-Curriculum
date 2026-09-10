# X01 call flow — realtime sampler to userspace evidence

Status: **SOURCE + AUTHORITATIVE-EXPERIMENT CONFIRMED**  
Course level: 2000  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

This flow documents exactly where an X01 record is created, where it can be lost, what `halsampler -t` actually labels at the pinned revision, and which conclusions are safe when producer and consumer evidence disagree.

## End-to-end execution flow

```text
LinuxCNC realtime thread (1 ms in X01 fixture)
  |
  +--> x01-source.0.update
  |      increments deterministic cycle payload
  |      (test witness; deliberately scheduled before sampler.0)
  |
  +--> sampler.0 -> sampler.c::sample(void *arg, long period)
         |
         +-- enable == FALSE
         |     -> no record emitted
         |     -> refresh curr-depth/full only
         |
         +-- enable == TRUE
               -> snapshot all configured sampler input pins
               -> hal_stream_write(&fifo, data)
                    |
                    +-- SUCCESS
                    |     -> one record retained in shared FIFO
                    |     -> sampler.0.full = FALSE
                    |     -> sampler.0.curr-depth refreshed
                    |
                    +-- FAILURE / FIFO not writable
                          -> this recorder record is lost
                          -> sampler.0.overruns += 1
                          -> sampler.0.full = TRUE
                          -> curr-depth = max depth
                          -> realtime source/thread continues unless
                             some separate evidence proves otherwise

shared HAL stream / FIFO
  |
  +--> userspace halsampler -> sampler_usr.c::main()
         -> hal_stream_attach(...)
         -> hal_stream_wait_readable(...)
         -> hal_stream_read(&stream, buf, &this_sample)
         -> compare returned this_sample with local last_sample + 1
         -> print `overrun` if that returned sequence is discontinuous
         -> with -t, print (this_sample - 1), then payload fields
```

## Source-owned state and evidence surfaces

### Realtime producer: `sampler.c::sample()`

Source path: `src/hal/components/sampler.c`.

Inputs/state read:

- `sampler.N.enable`;
- configured `sampler.N.pin.M` values;
- FIFO writeability/depth through HAL stream operations.

State mutated on failed stream write:

- `sampler.N.overruns` increments;
- `sampler.N.full` becomes true;
- `sampler.N.curr-depth` reports max FIFO depth.

Critical source fact: the failed write branch explicitly describes the FIFO as full and the **data as lost**. It does not stop the realtime thread or prove a machine/control cycle was skipped.

### Userspace consumer: `sampler_usr.c::main()`

Source path: `src/hal/components/sampler_usr.c`.

The reader gets `this_sample` from `hal_stream_read()`. Its local continuity check compares that returned value to the expected successor. With `-t`, the displayed prefix is `this_sample - 1`.

At this pinned revision, this path does **not** read the exported HAL pin `sampler.N.sample-num` to construct `-t` output.

### Version trap: exported `sampler.N.sample-num`

`sampler.c::init_sampler()` exports `sampler.N.sample-num`, but the inspected `sample()` function does not read, increment, or pass that exported pin into the stream write. Therefore the curriculum must not equate that pin with the `-t` prefix without independent version-specific evidence.

## Authoritative X01-002 failure-path observation

Workflow `34436256547`, retained artifact `10136342576`, forced a depth-64 FIFO to fill while the userspace drain was withheld.

Observed before bounded drain:

- `full=TRUE`;
- `curr-depth=64`;
- producer `overruns=192`;
- deterministic source counter `282`.

Observed after the bounded read:

- producer overruns increased to `206`;
- deterministic source counter advanced to `473`;
- retained `-t` tags contained **zero gaps**;
- userspace printed **zero `overrun` markers**;
- sampled deterministic payload contained one gap: **79 -> 286**.

So, for this tested loss mode:

```text
clean retained -t ordering
        !=
proof that sampler producer lost no records
```

The correct X01-002 loss conclusion is obtained by combining:

```text
producer recorder-health evidence (overruns/full/depth)
        +
independent payload-cycle witness inside sampled records
        +
known realtime function order
```

The `-t` sequence remains useful for ordering successfully returned stream records, but this experiment falsifies treating it as a complete oracle for producer-side loss.

## Stop/drain flow

When terminal evidence matters, X01 uses this lifecycle:

```text
sampler enabled + producer running
  -> disable sampler production
  -> capture stopped source counter + remaining FIFO depth
  -> invoke bounded halsampler -n <remaining depth>
  -> wait for reader completion
  -> verify FIFO depth == 0 and no producer overruns
  -> compare terminal retained payload to stopped source boundary
```

This prevents “killed the userspace reader before it drained” from being confused with realtime recording failure. The authoritative run drained 354 residual records and ended within the frozen three-cycle observation tolerance.

## Sustained healthy path

The predeclared P5 proof retained exactly 10,000 narrow-configuration rows:

- tags `0..9999` contiguous;
- deterministic payload unit-contiguous throughout;
- producer overruns `0`;
- `full=FALSE`.

That proves the bounded tested capture. It does not prove indefinite logging, filesystem durability under power loss, physical timestamp simultaneity, or safety-rated event retention.

## Failure classification table

| Observation | Safe conclusion | Unsafe conclusion |
|---|---|---|
| producer `overruns>0` / full FIFO | recorder producer failed to retain one or more attempted records | realtime control loop necessarily skipped cycles |
| deterministic sampled payload gap + producer overrun | records covering some source cycles were lost from retained recorder evidence | machine motion itself jumped |
| `-t` tags contiguous | successfully returned stream records are ordered contiguously by the stream sequence observed here | no producer-side recording loss occurred |
| killed/terminated userspace reader with FIFO remaining | retained file may be truncated by reader lifecycle | realtime sampler malfunctioned |
| 10,000 rows contiguous, overruns 0 | bounded sustained capture passed this fixture | logging is indefinitely lossless or power-fail durable |
| wider capture has higher observed thread `time/tmax` | measurable environment-specific timing observation | guaranteed causal production deadline impact |

## Downstream rule for X02

Any synchronized multi-surface diagnostic built on X01 must retain enough provenance to answer all of these separately:

1. Did the realtime recorder attempt fail (`overruns/full/depth`)?
2. Did the retained payload itself reveal skipped source cycles or stale witness values?
3. What ordering/sequence did the userspace stream reader return?
4. Was the userspace drain allowed to complete correctly?
5. What thread order made the sampled relationship meaningful?

If those cannot be distinguished, X02 must label the correlation uncertain rather than infer a machine/control timing relationship from a plausible-looking trace.
