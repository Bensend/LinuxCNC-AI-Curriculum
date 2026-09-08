# C05 — feedback sensor failure modes: research and source analysis

Status: **RESEARCH / SOURCE**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Lesson question

How can the curriculum make a controller observe a false feedback value while preserving an independently sampled toy 'true plant state', so the learner cannot confuse measured disagreement with known physical disagreement?

C05 owns sensor freeze/scale/jump behavior. It does **not** own final machine stop/fault policy.

## Documentation findings

Current LinuxCNC encoder documentation makes the measurement chain explicit: encoder position is a scaled output, `position-scale` defines counts per length unit, `rawcounts` is the underlying count state, and position/velocity are derived observations. The docs warn that even `position-interpolated` is not universally valid for position control at low speed, reversal or speed changes. This reinforces that a named feedback pin is an estimator/measurement product, not physical truth by definition.

The realtime component catalog provides stock arithmetic and selection components suitable for a deterministic fault-injection fixture: `scale`, `sum2`, `mux4`, plus realtime `sampler`. `sample_hold` exists but at the pinned source revision it is `s32` only, so it is a natural count-domain hold primitive rather than a direct float-position hold for the existing C04 `integ` toy plant.

## Pinned-source findings

### `scale.comp`

Pinned source is intentionally simple:

```text
out = in * gain + offset
```

Each invocation reads that instance's float input/gain/offset and writes a float output. Therefore a deliberately wrong scale or offset can be made fully auditable without pretending it models an encoder's electrical failure mechanism.

### `mux4.comp`

Pinned source selects exactly one of four float inputs according to two selector bits. It adds no plausibility checking, latching or diagnosis. This makes it useful as an explicit **fault-mode selector**, not a fault detector.

### `sample_hold.comp`

Pinned source exposes `s32 in`, `bool hold`, and `s32 out`. When `hold=false`, output follows input; when `hold=true`, output simply retains the previous integer value. Because C04's independent toy plant state is float, using this component directly would silently change the sensor model to a count-domain model. That may become useful in a later encoder-specific lab, but the first C05 test should avoid adding quantization unless quantization is itself under test.

## Proposed minimum deterministic sensor path

Preserve C04's independent true plant A/B states but make **B measured feedback** an explicit transformation:

```text
true_B ----+-------------------------------> normal_B
           +--> scale(gain=wrong) ----------> scaled_B
           +--> sum/scale(offset=jump) -----> jumped_B
           +--> transition-captured constant -> frozen_B

normal/scaled/jumped/frozen
             -> mux4 fault-mode selector
             -> measured_feedback_B
             -> cross-coupler + PID-B feedback

true_B + measured_feedback_B + mode + control outputs
             -> same-cycle realtime sampler
```

For the freeze mode, capture the current true-B value only while the experiment is in an **unscored transition phase**, place it on a float signal, then publish the decisive freeze phase. The decisive phase must prove that the held measurement remains constant while independently sampled true-B continues changing. This avoids claiming a torn userspace capture is itself same-cycle evidence; the capture instant is not scored.

## Function/thread-order issue to freeze before implementation

Do not inherit C04's sampling semantics mechanically. The first C05 experiment needs a documented discrete-time ordering that makes the distinction among:

- plant state used to construct the measurement;
- measured feedback consumed by the coupler/PID;
- newly computed control effort;
- next plant update;
- realtime sample.

A clean candidate is:

```text
plant update from previous-cycle effort
-> sensor transforms / fault selector
-> disagreement + cross-coupling
-> PID A/B
-> sampler
```

This means one sample row contains the newly updated true plant state, the measurement derived from it, and the controller state calculated from that measurement; the PID output then drives the next plant update. If this order is adopted, it must be frozen and source-verified before implementation.

## Community research

Community reports are retained as **COMMUNITY-REPORTED**, not proof of LinuxCNC source behavior:

- A 2021 Mesa/linear-encoder thread reported following errors around encoder feedback and a suspicious scale value, illustrating that encoder scale/wiring/measurement issues can present as servo error rather than as a neatly labeled 'sensor fault'.
- Another 2021 thread on step/encoder scaling reported closed-loop following errors until step and encoder scaling were reconciled; moderator advice was to independently verify encoder position against a dial indicator and compare commanded versus feedback HAL values.
- Older encoder troubleshooting reports describe large scale error and repeatability/drift symptoms without an automatically identified physical cause.

The transferable lesson is not that every following error is a scale fault. It is that measured feedback disagreement is symptom evidence; independent measurement is often needed to decide whether command generation, actuator response, scaling, wiring, counts or mechanics are wrong.

## Adversarial boundaries C05 must preserve

```text
measured feedback changes
!= proven physical motion
```

```text
measured feedback freezes
!= proven physical actuator freeze
```

```text
PID/cross-coupler reacts strongly to a bad measurement
!= evidence that the plant needed that correction
```

```text
sensor-fault evidence
!= automatic stop/continue/fault policy
!= safety-rated sensor architecture
```

## Open questions before experiment freeze

1. Should the first lab exercise three sensor transformations in one run or freeze only one fault at a time to keep causal attribution auditable?
2. Is a userspace-captured float freeze value during phase 0 sufficient for the first deterministic lesson, or should C05 immediately build a realtime float hold component so the freeze instant itself can be source-controlled?
3. Which independent evidence should qualify a 'true state' in this toy fixture without teaching that a simulation variable is equivalent to a real secondary encoder/reference?
4. Should C05 include LinuxCNC motion following-error behavior now, or first isolate the local feedback/control mechanism and add motion fault propagation only after sensor semantics are understood?

## Exact next checkpoint

Prefer the smallest causal lesson: freeze one B feedback value while true-B continues moving, preserve both values in the same realtime sample, and show the resulting cross-coupler/PID response without assigning physical cause. Before freezing that experiment, inspect the accepted C04 function order and decide whether to reorder the plant/sensor/controller functions as proposed above or add a one-cycle staging invariant explicitly.
