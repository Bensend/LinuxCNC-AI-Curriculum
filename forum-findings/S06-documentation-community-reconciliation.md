# S06 — documentation/community reconciliation

- Module: S06 — fault injection framework
- Pinned LinuxCNC source revision: `8bf4605ae81042248add031e94c77300406e0413`
- Research date: 2026-09-07

## Current official documentation

### `sampler(9)`

Current LinuxCNC master documentation describes `sampler` as the realtime side of a realtime-to-non-realtime shared-memory FIFO. It samples HAL pins in realtime and `halsampler` drains the FIFO in userspace. It documents FIFO depth/full state and an `overruns` counter when samples cannot be stored.

This supports the S06 evidence-health rule: a full FIFO/lost sample matters when exact-cycle behavior is being claimed.

URL: https://www.linuxcnc.org/docs/master/html/es/man/man9/sampler.9.html

### Documentation/source conflict: `sampler.N.sample-num`

The current manual says `sampler.N.sample-num` is automatically incremented for each sample and may be reset. At pinned source revision `8bf4605...`, however, `sampler.c::sample()` reads the configured pins and calls `hal_stream_write()` but does not update the exported `sample_num` field. The HAL stream itself maintains an internal sample number, and `halsampler -t` can use stream sample IDs, but that is not automatically proof that the exported HAL pin/parameter has the documented behavior at the pinned revision.

Classification: **CONFLICT / version-sensitive UNKNOWN for the exported `sampler.N.sample-num` field**. This does not block S06 because S06-016 explicitly samples its own realtime cycle counter and does not depend on that field.

Recommended destination: 2000 / LOW unless a later module materially needs the exported field.

### `streamer(9)` / `halstreamer(1)`

Current documentation confirms the split architecture found in source: realtime `streamer` consumes a FIFO and publishes HAL output pins, while non-realtime `halstreamer` copies stdin into that FIFO. `halstreamer` fills as fast as possible until the FIFO is full and retries while full.

This supports the S06 design decision not to make userspace record-arrival timing the mechanism for a one-cycle corruption experiment. A sufficiently prefilled FIFO is still useful for deterministic prerecorded sequences.

URLs:

- https://www.linuxcnc.org/docs/master/html/es/man/man9/streamer.9.html
- https://www.linuxcnc.org/docs/master/html/ru/man/man1/halstreamer.1.html

### HAL stream API

Current `hal_stream(3)` documentation states that stream read/write is a single-reader/single-writer model and that failed writes due to no room increment overrun state. This is consistent with the source-level evidence-health boundary used in S06.

URL: https://www.linuxcnc.org/docs/master/html/ru/man/man3/hal_stream.3.html

## Community pass

Targeted LinuxCNC forum searches did not reveal a canonical upstream "fault injection framework" with a stronger claim to authority than the source/test primitives themselves.

Useful community material discusses `sampler`/`halsampler` as a way to expose realtime HAL values and emphasizes that realtime component execution depends on thread `addf` ordering/periodicity. These are useful operational clues, but S06 does not elevate them above pinned source or official documentation.

The absence of a canonical framework means the curriculum should describe S06 as a **curriculum test methodology built from LinuxCNC primitives**, not as an upstream LinuxCNC standard.

## Reconciliation decision

S06-016 uses:

- a deterministic test-only realtime source/fault scheduler;
- stock LinuxCNC arithmetic/comparator observers;
- stock realtime `sampler` ordered after the source and observers;
- raw value/sequence comparisons as injection evidence;
- stock observer outputs as response evidence;
- sampler overrun/trace completeness as evidence-health gates;
- an explicit machine-readable PASS / BEHAVIOR_FAIL / HARNESS_INVALID schema.

No claim is made that this is an official LinuxCNC safety or fault-injection framework.
