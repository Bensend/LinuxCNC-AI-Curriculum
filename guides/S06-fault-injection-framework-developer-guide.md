# S06 — fault injection framework developer guide

- Course level: 1000
- Status: EXPERIMENT pending S06-016 result
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Prerequisites: S01–S05 graduated

## What S06 teaches

A fault-injection experiment is useful only if a fresh engineer can answer four separate questions:

1. **Where was the fault injected?**
2. **How do we independently know the intended fault actually occurred?**
3. **How do we independently know the mechanism under test responded?**
4. **How do we know the evidence capture was healthy enough to support those claims?**

The framework deliberately treats these as separate evidence channels.

## Choose the layer first

Name the injection layer before implementation:

- HAL value;
- publication/freshness;
- realtime function order/timing;
- motion feedback interface;
- HostMot2 LLIO;
- transport;
- lifecycle/state.

The strongest claim an experiment can normally make is bounded by the layer it actually preserves. A constant substituted at a HAL pin can test the effects of a stale value at that pin; it cannot by itself establish Ethernet packet-loss or physical encoder-failure semantics.

## Preserve the mechanism under test

Inject at a boundary around the production mechanism rather than rewriting the production mechanism to manufacture the expected result.

Examples already accepted by the curriculum:

- S03 modified a HostMot2 **test double** beneath production HostMot2 host code;
- S04 switched live/held feedback at a HAL boundary while production motion following-error code remained untouched;
- S05 drove stock comparison/persistence/voter components with synthetic inputs and independently checked ordering/output.

S06 generalizes those lessons.

## Separate injection evidence from response evidence

### Bad circular oracle

`fault_mode == FREEZE`, therefore the feedback froze and the detector handled it.

This establishes neither proposition. It only proves the fixture reports that it selected a mode.

### Better evidence

Injection evidence:

- healthy/reference sequence advances;
- published sequence remains fixed;
- raw published value remains fixed despite the healthy source advancing.

Response evidence:

- a downstream stock observer output changes according to its documented/source semantics;
- the observer does not depend on the fixture's mode declaration.

Capture-health evidence:

- realtime sampler executes after source and observer;
- sampler overruns are zero;
- all required cycle rows are present.

## Realtime ordering is part of the fixture

HAL functions execute in configured thread order. When exact-cycle behavior is part of the claim, treat the actual `halcmd show thread` order as an acceptance gate, not a setup detail.

Recommended order:

`stimulus/fault scheduler -> mechanism/observer -> realtime sampler`

This makes one sampled row a same-thread-position view of both the injected inputs and downstream effects.

## `streamer` boundary

Pinned `streamer.c::update()` provides useful deterministic realtime consumption from a FIFO, but a userspace feeder is asynchronous. If the FIFO is empty on an eligible clock, streamer records starvation and retains its existing output pins.

Therefore:

- prefilled streamer data can replay deterministic prerecorded patterns;
- userspace refill arrival should not be used as the exact one-cycle timing oracle unless that asynchronous interaction is itself the mechanism under test;
- `empty`, `curr-depth`, and `underruns` are harness/stream evidence, not proof of a physical fault.

## `sampler` boundary

Pinned `sampler.c::sample()` reads its configured HAL input pins in realtime and writes one FIFO record. A full FIFO loses the sample and increments overrun state.

Consequences:

- sampler is appropriate for exact-cycle evidence when ordered after the relevant functions;
- any overrun can invalidate an exact-window claim unless the lost samples are outside all relevant windows and the frozen plan explicitly allows that (S06-016 does not);
- the non-realtime drain does not determine the realtime sample point.

### `sample-num` caution

Current documentation says the exported `sampler.N.sample-num` automatically increments. At the pinned revision, the inspected realtime `sample()` body does not update that exported field. S06 therefore does not use it as the authoritative cycle oracle. An explicit realtime cycle/sequence is sampled instead.

This is a version/documentation conflict to preserve, not silently normalize.

## Deterministic fixture design

S06-016 chooses a tiny test-only realtime scheduler instead of userspace-fed streamer for stimulus because the test requires exact single-cycle and one-cycle-age windows.

The test scheduler may self-report a mode for debugging, but acceptance relies on raw reference-vs-published values and sequences.

Stock observer logic then supplies an independent response:

- absolute numeric mismatch > 0.05;
- absolute age mismatch > 0.5 cycle.

This produces three deliberately distinguishable cases:

- freeze: age mismatch and eventually value mismatch;
- one-cycle +5 jump: value mismatch without age mismatch;
- one-cycle old ramp sample: age mismatch without value mismatch because 0.01 < 0.05.

## Classification

### PASS

The intended injection is independently demonstrated, the downstream prediction and recovery match, function order is verified, and capture health passes.

### BEHAVIOR_FAIL

The injection and capture are valid, but the mechanism under test does not match a predeclared response/recovery prediction.

### HARNESS_INVALID

The experiment did not validly exercise or observe the claim—for example wrong topology/order, missing injection, fixture load failure, sampler overrun/missing required rows, or result parser failure.

Do not convert harness failures into product failures.

## Recovery is a separate claim

Ending a fault command is not recovery. Recovery must be observable at the tested layer: fresh publication resumes, a diagnostic clears, writes resume, sequence becomes current, or the architecture explicitly requires reinitialization/rehome.

## Machine-readable evidence

S06 defines `linuxcnc-ai-fi-v1` so later AI agents can distinguish:

- experiment/version/attempt identity;
- overall classification;
- capture health;
- per-case injection evidence;
- per-case response evidence;
- recovery evidence;
- invalid-oracle example;
- explicit non-claims.

The schema is intentionally job-produced first. General lab-runner integration is deferred until repeated use shows which fields are stable.

## Failure/safety boundary

This framework increases experimental rigor; it does **not** convert LinuxCNC HAL logic into a safety-rated diagnostic architecture. Software fault injection cannot by itself establish physical independence, diagnostic coverage, safe stopping, PL/SIL/category, common-cause resistance, or hardware fault coverage.

## Fresh-AI decision checklist

Before accepting any new fault experiment, ask:

1. What production mechanism remains untouched?
2. What exact boundary is injected?
3. What raw observation proves the injection happened independently of the injector's own mode bit?
4. What independent state proves subsystem response?
5. What function/thread ordering makes those observations comparable?
6. What proves capture health?
7. What is the adversarial/healthy control?
8. What counts as recovery?
9. What makes the harness invalid?
10. What claims are outside the injection layer and therefore prohibited?

If those answers are not durable before interpreting the result, the experiment is not yet suitable as curriculum evidence.
