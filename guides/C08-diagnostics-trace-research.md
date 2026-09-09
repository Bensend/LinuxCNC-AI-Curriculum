# C08 — Diagnostics and Trace Capture — 1000-level Research Guide

Status: **SOURCE / EVIDENCE-MATRIX PASS**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective

Build a practical evidence-selection model for debugging LinuxCNC: choose an observation surface appropriate to the question, preserve provenance and ordering, recognize realtime-vs-userspace boundaries, detect dropped/ambiguous evidence, and avoid treating one convenient GUI/HAL value as proof of a deeper causal or physical fact.

## Observation surfaces established

### `halcmd`

`halcmd` is a userspace topology/spot-check surface. Separate `getp`/`show` invocations are not an atomic servo-cycle snapshot. Use it to prove object presence, connection, and slow point state; do not infer simultaneous fast-state relationships from sequential reads.

### Halscope

Halscope combines realtime acquisition with non-realtime display. A useful retained capture therefore needs thread/sample period, function order, trigger, channel identity, scaling and units. A screenshot without those is weak evidence.

### `sampler` / `halsampler`

Pinned `src/hal/components/sampler.c` creates a shared-memory HAL stream and its realtime `sample()` reads all configured HAL values during one function invocation before calling `hal_stream_write()`. Its relationship to other producers is determined by HAL thread function order.

Pinned `src/hal/components/sampler_usr.c` is a separate userspace consumer: it attaches to the pre-existing stream, waits for data, reads records, checks sample-number continuity, optionally prints sample tags, and drains to stdout/file.

## Resolved pinned `hal_stream` semantics

Implementation: `src/hal/hal_lib.c`.

### Creation / attachment

`hal_stream_create()` parses the type string, allocates shared memory sized for `depth * (1 + pin_count)` data elements plus metadata, zeroes the metadata, records depth/types/pin count, writes the FIFO magic, then publishes with a release fence.

`hal_stream_attach()` first maps enough shared memory to inspect the header. It rejects a missing/invalid stream when the magic is wrong and rejects an explicitly supplied incompatible type string. It then reopens the shared-memory segment at the full size derived from the creator's depth and pin count.

Diagnostic consequence: **object-looking HAL readiness is not sufficient proof that the userspace collector can attach to the stream**. A valid automated harness should prove actual collector attachment/readiness, not merely that sampler pins exist.

### Ring capacity

The FIFO advances `in` and `out` modulo `depth`; writable requires `advance(in) != out`. One slot is reserved to distinguish full from empty, so usable queued-record capacity is **depth - 1**, not depth.

### Write / sample numbering

On a successful `hal_stream_write()`:

1. writer confirms space exists;
2. copies all configured values into the current input slot;
3. increments shared `this_sample` and stores that sample number in the extra record element;
4. release-stores the new input index.

If no slot is available, it increments stream `num_overruns` and returns `-ENOSPC`. Crucially, `this_sample` is incremented only on successful enqueue. Therefore a producer-side rejected write does **not by itself create a gap in the successfully enqueued sample-number sequence**.

This corrects an overly broad preliminary interpretation: userspace sample-number continuity is useful for detecting records absent from the sequence it receives, but it is not a substitute for producer-side overrun evidence. A valid trace must retain `sampler.N.overruns/full/curr-depth` (or equivalent producer evidence) as well as consumer completion/continuity.

### Read

`hal_stream_read()` returns `-ENOSPC` and increments `num_underruns` if empty. Otherwise it copies the complete record, returns the stored sample number when requested, and release-stores the advanced output index.

### Atomicity boundary

The ring uses acquire/release atomic indexes so a consumer sees a completed record after the producer publishes the input index. This provides FIFO record publication/ordering, **not** a universal timestamp or simultaneity guarantee across unrelated LinuxCNC subsystems. Values sampled in one `sampler.N` invocation are coherent to that invocation, but causal ordering relative to other realtime functions still depends on function placement, and ordering against Task/NML/userspace logs requires additional evidence.

## Task/NML error and status evidence path

Pinned Task provides a distinct diagnostic surface from HAL traces.

### Command completion/status

Userspace `shcom.cc::emcCommandWaitDone()` repeatedly calls `updateStatus()` and compares `emcStatus->echo_serial_number` with the sent command serial. For the matching command, `RCS_STATUS::EXEC` means still executing, `DONE` returns success, and `ERROR` returns failure. This is command/status evidence, not physical-state evidence.

### Operator-error publication

Pinned `emctaskmain.cc::emcOperatorError()`:

1. checks that the error channel has room;
2. formats an `EMC_OPERATOR_ERROR` message;
3. emits the text through `rcs_print()`;
4. writes the typed message to `emcErrorBuffer`.

A userspace consumer such as `shcom.cc::updateError()` independently calls `emcErrorBuffer->read()`. On `EMC_OPERATOR_ERROR_TYPE`, it copies the NML message into its local `error_string`.

This yields two observable descendants of one Task report:

```text
Task detects/rejects condition
  -> emcOperatorError(...)
      -> rcs_print(text)                    [process/log surface]
      -> emcErrorBuffer->write(error_msg)   [NML error-channel surface]
           -> userspace updateError()/error_channel consumer
                -> GUI/script retained text if that consumer records it
```

The process print and NML consumer are **not an atomic paired trace**. Their wall-clock appearance can differ because they travel through different mechanisms. Message presence proves Task published that diagnostic; it does not establish servo-cycle timing or physical machine truth.

### Example fault-to-retained-artifact flow

A source-grounded representative path is a Task command rejected because machine state is unsuitable. `emctaskmain.cc` calls `emcOperatorError("command ... cannot be executed until ...")`; `emcOperatorError()` prints and writes `EMC_OPERATOR_ERROR`; a userspace NML consumer reads that typed message. For a reproducible lab artifact, retain both the originating command/result/status and the error-channel text with explicit collector timestamps/provenance. Do not use the error text alone to infer the exact realtime transition that preceded it.

## Community failure modes retained

- Prematurely killing an asynchronous `halsampler` reader can truncate evidence even when realtime acquisition was correct.
- Automated trace data is substantially more useful when configuration/state changes are retained with it.
- Halscope scaling/time-division interpretation errors can create false diagnoses.
- Slowing/single-stepping realtime code may be valid for logic debugging but invalidates claims about the original timing regime.
- Field debugging of Mesa read/following-error symptoms benefits from observing cause-near evidence such as `io_error` and read execution timing rather than only the final following-error symptom.

These remain COMMUNITY-REPORTED leads unless separately source/test confirmed.

## Diagnostic evidence matrix

| Observation question | Preferred surface | Execution context | Ordering/timing guarantee | Failure/validity evidence to retain | What it cannot prove |
|---|---|---|---|---|---|
| Does a HAL object/signal exist and how is it connected? | `halcmd show` / topology dump | userspace | structural snapshot | stderr + exact object match | fast ordering or simultaneity |
| What is one slow HAL value now? | `halcmd getp`, halmeter | userspace | point observation | read failure/object missing | same-cycle relation to another separate read |
| Did multiple HAL-visible states change in a realtime sequence? | `sampler`/`halsampler` or Halscope | RT acquisition + userspace drain/display | same sampler invocation; relative producer order only if function order known | producer overruns/full/depth, consumer exit/stderr, sample tags, thread order | Task-internal state, universal timestamps, physical truth |
| Was every attempted realtime sample retained? | sampler producer validity + consumer trace | mixed RT/userspace | FIFO publication ordering | **producer overrun count is mandatory**; consumer continuity alone is insufficient | that no sample attempt was rejected if producer overrun evidence is absent |
| Can collector attach to intended stream? | actual `halsampler` attach/read readiness | userspace + shmem | proves stream header/key/type compatibility at attach time | attach stderr/exit and first valid read | correct function order or semantic correctness of pins |
| Did a command complete or fail? | NML status (`echo_serial_number`, `RCS_STATUS`) | userspace reading Task status | command-serial/status ordering | command serial, status polls, timeout/result | physical achievement beyond reported controller state |
| Did Task publish an operator error? | NML error channel; corroborating process log | Task -> NML/userspace | typed message ordering within channel; process-print order is separate | message type/text, collector lifecycle, timestamps | servo-cycle timing or physical root cause by itself |
| Did a transient exist around a trigger? | Halscope | RT acquisition | bounded by selected thread/sample period and function order | trigger, sample period, channels, scaling | causality by itself |
| Did software state differ from plant behavior? | synchronized controller evidence + independent device/plant measurement | mixed | only as strong as explicit synchronization | timestamps/clocks/provenance for each surface | physical truth from software-only observation |

## Claims ledger

| Claim | Evidence | Class | Confidence | Remaining verification |
|---|---|---|---|---|
| `sampler` acquires configured HAL values in realtime and transfers via shared-memory stream | pinned sampler + hal_stream source | SOURCE-CONFIRMED | high | experiment thread-order consequence |
| usable stream capacity is depth-1 | pinned `hal_stream_writable/advance` | SOURCE-CONFIRMED | high | optional bounded test |
| failed full-FIFO write increments producer overrun and does not increment successful-enqueue sample number | pinned `hal_stream_write` | SOURCE-CONFIRMED | high | force small-depth overrun in C08 experiment/preflight |
| consumer sample-number continuity alone cannot prove producer attempted no dropped writes | pinned `hal_stream_write/read` | SOURCE-CONFIRMED | high | adversarial exam target |
| Task operator error is both process-printed and written as typed NML error message | pinned `emcOperatorError` | SOURCE-CONFIRMED | high | bounded runtime capture desirable |
| command completion status is tracked separately from error text | pinned `emcCommandWaitDone/updateStatus` | SOURCE-CONFIRMED | high | experiment may use this as second surface |
| collector lifecycle can truncate otherwise-correct capture | solved community case | COMMUNITY-REPORTED | medium | reproduce only if central |

## Experiment-design consequence

The highest-value C08 experiment should discriminate two plausible interpretations of the same coarse symptom rather than merely prove tools execute. Freeze it before output inspection.

Preferred shape:

- one deterministic realtime producer exposes a short-lived fault/cause signal and a downstream symptom;
- construct two phases that produce the **same userspace coarse symptom** through different cause ordering;
- show that deliberately sequential userspace `halcmd` observations are insufficient/ambiguous for same-cycle attribution;
- place `sampler` after the relevant realtime producers and retain a monotonic phase/cause/symptom stream;
- force or separately preflight a small FIFO overrun to verify that producer `overruns` catches rejected writes even when successful sample tags remain contiguous;
- retain collector attach/exit/stderr, producer overrun/full/depth, exact function order, and raw trace;
- optionally pair one Task/NML error/status artifact to demonstrate why cross-surface timestamps are provenance, not atomic ordering.

Safety boundary: diagnostic visibility is evidence, not a safety function. A correct trace does not make a software path safety-rated and does not prove physical machine state.

## Exact next checkpoint

1. Create `guides/C08-function-symbol-guide.md` from the resolved symbols (`sample`, `hal_stream_create/attach/write/read`, `halsampler` consumer loop, `emcOperatorError`, `updateError`, `updateStatus`, `emcCommandWaitDone`).
2. Create `call-flows/C08-fault-to-retained-evidence.md` with the HAL-stream path and Task-error path, explicitly marking their ordering boundary.
3. Freeze a C08 experiment with predictions and gates **before implementation/output inspection**. The core gates must include: same coarse symptom from two causes; realtime trace discriminates them; producer-overrun evidence is required; consumer continuity alone is rejected as a sufficient validity oracle; sequential userspace reads are not promoted to atomic evidence.
4. Then implement a non-authoritative topology/ordering preflight before one authoritative run.
