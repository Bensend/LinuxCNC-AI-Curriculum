# C08 — Diagnostics and Trace Capture — 1000-level Research Guide

Status: **RESEARCH / INITIAL DOCS-COMMUNITY-SOURCE PASS**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective

Build a practical evidence-selection model for debugging LinuxCNC: choose an observation surface appropriate to the question, preserve provenance and ordering, recognize realtime-vs-userspace boundaries, detect dropped/ambiguous evidence, and avoid treating one convenient GUI/HAL value as proof of a deeper causal or physical fact.

C08 is not a catalog of every debugging command. The important skill is **choosing evidence whose execution context and timing can actually discriminate competing fault hypotheses**.

## Initial official-documentation pass

### `halcmd`

Current official man page: https://www.linuxcnc.org/docs/devel/html/en/man/man1/halcmd.1.html

`halcmd` manipulates and inspects HAL from userspace. It is excellent for topology/object presence and point-in-time values, but a sequence of separate `getp`/`show` calls is not an atomic servo-cycle snapshot. Earlier curriculum experiments already demonstrated why sequential userspace reads can produce a one-cycle temporal tear.

C08 consequence: use `halcmd` for **structure and bounded spot checks**, not for claiming simultaneous fast-state relationships unless a specific synchronization mechanism is proven.

### HAL tools / Halscope

Current official HAL tools guide: https://www.linuxcnc.org/docs/stable/html/hal/tools.html

The guide describes Halscope as a HAL oscilloscope that captures pins/signals/parameters as a function of time. The HAL tutorial clarifies that Halscope has a realtime acquisition part and a non-realtime display part, and that its sampling function is attached to a selected realtime thread.

C08 consequence: Halscope can answer fast timing/order questions that a userspace meter cannot, but the engineer still needs to record the selected thread/sample rate, trigger semantics, channels, and configuration. A screenshot without that provenance can be misleading.

### `sampler` / `halsampler`

Current sampler man page: https://linuxcnc.org/docs/master/html/man/man9/sampler.9.html (localized mirrors may surface first)

The documented architecture is intentionally split:

```text
realtime sampler component
  -> samples HAL pins in its attached realtime function
  -> shared-memory FIFO
  -> userspace halsampler
  -> stdout/file
```

The FIFO depth is explicitly configurable because realtime production and userspace draining are separate activities. `halsampler -t` can emit sample numbers.

C08 consequence: this is a strong reproducible trace surface when the target quantities are HAL-visible and same-thread/same-function ordering is controlled. But FIFO state/overrun evidence is part of the trace's validity, not an optional detail.

## Initial community pass — hypotheses / field failure modes

Community reports are diagnostic leads, not normative implementation truth.

### Asynchronous userspace drain can look like bad sampling

Forum case: https://forum.linuxcnc.org/24-hal-components/46426-problems-with-sampler-halsampler-solved

A user reported apparently unreliable sampler behavior when launching/killing `halsampler` asynchronously. Their eventual diagnosis was userspace `subprocess.Popen` / FIFO-drain handling: they killed the reader before it completed, then fixed the workflow by collecting a bounded sample count and waiting for reader completion.

Transferable diagnostic lesson: **collector lifecycle can corrupt or truncate evidence even when realtime acquisition is correct**. Separate “sampler did not capture” from “userspace did not fully drain/retain the capture.”

### Automated trace retention needs provenance

Forum case: https://forum.linuxcnc.org/24-hal-components/42901-halsampler-tools

A community toolset paired `halcmd` configuration changes and parameter logs with the corresponding `halsampler` data. This is useful field evidence for a C08 principle: waveform data alone is much less useful if the configuration/state changes that produced it are not retained alongside it.

### Display/interpretation mistakes are real diagnostic faults

Forum case: https://forum.linuxcnc.org/38-general-linuxcnc-questions/39126-halscope-scaling-axis-acceleration-behaviour

A user misread Halscope time/division by an order of magnitude until the major/minor division convention was clarified. This is not an implementation defect; it is an **evidence-interpretation defect**. C08 must teach that trace scaling, sample period, units and trigger location are part of the evidence.

### Realtime debugging can perturb timing

Forum case: https://www.forum.linuxcnc.org/10-advanced-configuration/36786-how-to-debug-a-real-time-component

Community advice includes slowing a realtime thread dramatically or conditionally single-stepping a custom component for debugging. This can be useful, but it also changes the timing regime being investigated.

C08 rule: distinguish a **logic-debug fixture** from a **timing-valid reproduction**. If the act of debugging changes thread period/execution behavior, do not reuse the result as proof of original realtime timing.

### Field example of selecting discriminating HAL evidence

Forum case: https://forum.linuxcnc.org/38-general-linuxcnc-questions/39375-read-error-and-following-error-mesa-7i96

A developer response recommends observing both the hm2 Ethernet `io_error` and read execution time in Halscope to distinguish communication-timeout behavior from a generic following-error symptom. This is a good example of choosing evidence near the suspected cause rather than diagnosing from the final machine symptom alone.

## Pinned-source pass — realtime sampler path

### `src/hal/components/sampler.c`

At the pinned revision, `sampler_t` contains the shared-memory stream handle plus `curr_depth`, `full`, `enable`, `overruns`, `sample_num`, and configured sample pins.

`rtapi_app_main()`:

1. initializes the `sampler` HAL component;
2. allocates sampler state in HAL shared memory;
3. calls `hal_stream_create()` for each configured channel;
4. exports the channel pins/function;
5. marks the component ready.

Realtime `sample(void *arg, long period)`:

1. returns early while disabled after updating FIFO depth/full state;
2. reads every configured HAL pin into one local stream-data array during that function invocation;
3. calls `hal_stream_write()` to enqueue the sample;
4. if the FIFO is full, records lost-data evidence by incrementing `overruns`, setting `full`, and reporting maximum depth;
5. otherwise updates full/depth status normally.

Important observation boundary: all configured pin reads occur within one invocation of `sampler.N`, but their exact relationship to other realtime functions depends on **where `sampler.N` is placed in the HAL thread function order**. “Realtime sampled” does not automatically mean “after all relevant producers.”

### `src/hal/components/sampler_usr.c`

Pinned `halsampler`:

1. initializes its own userspace HAL component;
2. calls `hal_stream_attach()` to the already-created sampler stream;
3. waits for readable FIFO data;
4. calls `hal_stream_read()`;
5. compares returned sample number with the expected sequence and prints `overrun` on discontinuity;
6. optionally prints the sample tag with `-t`;
7. formats the typed values to stdout;
8. detaches/exits on completion or signal.

This creates two distinct validity checks:

```text
realtime producer-side: sampler.N.overruns / full / curr-depth
userspace consumer-side: sample-number continuity / read errors / process completion
```

A valid retained trace should preserve enough of both sides to rule out dropped/truncated data.

## Initial diagnostic evidence matrix

| Observation question | Preferred surface | Execution context | Ordering / timing strength | Failure mode to retain | What it cannot prove |
|---|---|---|---|---|---|
| Does a HAL object/signal exist and how is it connected? | `halcmd show` / topology dump | userspace | structural snapshot | command stderr + exact object match | fast temporal ordering |
| What is one slow-changing HAL value now? | `halcmd getp`, halmeter | userspace | point-in-time only | read failure / object missing | simultaneity with separate reads |
| Did multiple HAL-visible states change in a realtime sequence? | `sampler`/`halsampler` or Halscope | realtime acquisition + userspace drain/display | strong if attached after relevant producers and sample continuity retained | FIFO overrun, stream attach/read error, wrong function order | non-HAL internal state or physical truth |
| Did a transient exist around a trigger? | Halscope | realtime acquisition | thread/sample-rate bounded | wrong trigger, sample rate, channel scaling/config | causal interpretation by itself |
| Was an automated capture complete? | `sampler` + bounded `halsampler -n` + retained exit/stderr/sample tags | RT producer + userspace consumer | strong only with continuity/overrun checks | premature reader kill, FIFO loss, attach failure | correct interpretation of each signal |
| Did LinuxCNC command/state differ from physical machine behavior? | combine Task/Motion/HAL status with device/plant evidence | mixed layers | depends on synchronized surfaces | stale userspace status, missing hardware measurement | physical truth from software state alone |

## Already-known curriculum diagnostic traps to carry forward

These are not new C08 experiments, but they are high-value regression lessons:

- A successful command exit is not proof that an expected HAL object existed; C06 found a `halcmd show pin <pattern>` readiness check that could return success even when the intended object was absent.
- Sequential userspace pin reads can straddle servo cycles; C01's first observation harness was invalid for same-cycle equality claims.
- A trace can be perfectly ordered yet semantically mislabeled if the phase marker is written **after** the fault mutation; C06 exposed this and required phase-first observation.
- Workflow success is not the oracle; inspect inner exit, raw data, analyzer output and retained evidence.
- A GUI/status cache may be stale while the underlying controller has changed; T04/T05 require status freshness/ownership reasoning.

## Preliminary claims ledger

| Claim | Evidence | Class | Confidence | Remaining verification |
|---|---|---|---|---|
| `sampler` acquires configured HAL values in realtime and transfers via shared-memory stream | pinned `sampler.c`, official docs | SOURCE + DOC | high | experiment should confirm thread-order consequence |
| FIFO overflow is explicitly observable through sampler overrun/full state | pinned `sampler.c` | SOURCE | high | test a forced small-depth overrun |
| `halsampler` is a userspace consumer, not the realtime sampler itself | pinned `sampler_usr.c`, official docs | SOURCE + DOC | high | none for 1000 concept |
| sample-number discontinuity is a consumer-visible lost-data signal | pinned `sampler_usr.c` | SOURCE | high | determine exact stream sample-number semantics in `hal_stream` implementation |
| userspace collector lifecycle can create apparent capture unreliability | community solved case | COMMUNITY | medium | reproduce only if it becomes central to C08 experiment |
| realtime trace validity depends on function order relative to signal producers | sampler source + HAL thread model from earlier modules | SOURCE-REASONED | high | build explicit call-flow / bounded experiment |

## Exact next source-work checkpoint

1. Trace pinned `hal_stream_create/write/read/attach` implementation enough to document sample numbering, FIFO full behavior and attach failure boundaries.
2. Inventory the pinned Task/NML error/status publication path and LinuxCNC stderr/error channel so C08 is not HAL-only.
3. Document at least one complete fault -> internal report/status -> retained user-observable artifact call flow.
4. Expand the evidence matrix with Task/NML/process-log surfaces and explicit timestamp/ordering guarantees.
5. Freeze a C08 experiment only after that pass. Highest-value candidate: construct two competing interpretations of one observed userspace symptom and prove that a properly ordered realtime trace plus retained collector-validity evidence distinguishes them, while a naive sequential `halcmd` trace does not.
