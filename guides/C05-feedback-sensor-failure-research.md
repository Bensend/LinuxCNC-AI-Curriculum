# C05 — feedback sensor failure modes: research and source analysis

Status: **SOURCE / EXPERIMENT**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Lesson question

How can the curriculum make a controller observe a false feedback value while preserving an independently sampled toy 'true plant state', so the learner cannot confuse measured disagreement with known physical disagreement?

C05 owns sensor freeze/scale/jump behavior. It does **not** own final machine stop/fault policy.

## Documentation findings

Current LinuxCNC encoder documentation makes the measurement chain explicit: encoder position is a scaled output, `position-scale` defines counts per length unit, `rawcounts` is the underlying count state, and position/velocity are derived observations. The docs warn that even `position-interpolated` is not universally valid for position control at low speed, reversal or speed changes. This reinforces that a named feedback pin is an estimator/measurement product, not physical truth by definition.

The realtime component catalog provides stock arithmetic and selection components suitable for a deterministic fault-injection fixture: `scale`, `sum2`, `mux4`, plus realtime `sampler`. `sample_hold` exists but at the pinned source revision it is `s32` only, so it is a natural count-domain hold primitive rather than a direct float-position hold for the existing C04 `integ` toy plant.

## Pinned-source findings

### `integ.comp`

Pinned source advances each instance when its realtime function executes:

```text
out <- out + gain * in * fperiod
```

subject to reset and min/max clamps. This makes each `integ` instance an independently observable deterministic toy plant state. Function placement in the servo thread determines whether a sample represents pre- or post-update plant state.

### `scale.comp`

Pinned source is exactly:

```text
out = in * gain + offset
```

There is no plausibility check, fault classification or history. This is ideal for later C05 scale and jump/offset fault fixtures because the false measurement remains analytically reconstructable.

### `mux4.comp`

Pinned source selects exactly one of four float inputs according to two selector bits. It adds no plausibility checking, latching or diagnosis. This makes it useful as an explicit **fault-mode selector**, not a fault detector.

### `sample_hold.comp`

Pinned source exposes `s32 in`, `bool hold`, and `s32 out`. When `hold=false`, output follows input; when `hold=true`, output simply retains the previous integer value. Because C04's independent toy plant state is float, using this component directly would silently change the sensor model to a count-domain model. That may become useful in a later encoder-specific lab, but the first C05 test avoids adding quantization unless quantization is itself under test.

## Minimum deterministic sensor path

Preserve C04's independent true plant A/B states but make **B measured feedback** an explicit transformation:

```text
true_B ----+-------------------------------> normal_B
           +--> scale(gain=wrong) ----------> scaled_B
           +--> scale/sum(offset=jump) ------> jumped_B
           +--> transition-captured constant -> frozen_B

normal/scaled/jumped/frozen
             -> mux4 fault-mode selector
             -> measured_feedback_B
             -> cross-coupler + PID-B feedback

true_B + measured_feedback_B + mode + control outputs
             -> same-cycle realtime sampler
```

For freeze mode, capture the current true-B value only while the experiment is in an **unscored transition phase**, place it on a float signal, select that mux input, wait several servo periods, then publish the decisive freeze phase. The decisive phase proves that the held measurement remains constant while independently sampled true-B continues changing. The userspace capture instant is not itself scored as same-cycle evidence.

## Function/thread-order decision

The accepted C03/C04 fixture calculated PID before advancing its toy plants, then sampled the post-plant state. C05 deliberately changes the local control fixture order because it needs one row to bind plant truth, sensor transform and controller reaction unambiguously:

```text
motion command/controller
-> plant A/B update from prior-cycle effort
-> sensor transform / mux
-> measured disagreement + cross-correction
-> local PID A/B
-> realtime residual checks
-> sampler
```

Pinned `integ` and `mux4` implementations make this discrete-time interpretation source-auditable. The newly computed PID output drives the next plant update, while the current sample row contains the newly updated toy state, the measurement derived/selected from it, and the controller state calculated from that measurement.

The full cycle contract is durable in `call-flows/C05-true-state-to-faulted-feedback.md`.

## Community research

Community reports are retained as **COMMUNITY-REPORTED**, not proof of LinuxCNC source behavior.

### Encoder scale presenting as following error

2021 Mesa/linear-encoder thread:

https://forum.linuxcnc.org/10-advanced-configuration/41246-mesa-7i76e-7i85s-encoder-feedback-problem

The user reported a suspicious encoder scale chosen to avoid following error and failures occurring when stopping. This is useful evidence that measurement/configuration faults can present as servo/following-error symptoms rather than as a neatly identified sensor fault.

### Independent command/feedback observation as discriminator

2021 step/encoder scaling thread:

https://forum.linuxcnc.org/38-general-linuxcnc-questions/43995-stepconf-stepscale-and-encoder-scaling-not-right-following-error

PCW explicitly recommends comparing `joint.2.motor-pos-cmd` with `joint.2.motor-pos-fb` and using HAL tools to inspect them. The larger transferable lesson is to observe separate causal variables instead of inferring the fault from a single following-error symptom.

### Wrong sign / changed scale can mimic control instability

2023 closed-loop encoder thread:

https://forum.linuxcnc.org/38-general-linuxcnc-questions/48772-closed-loop-operation-following-error

The reported resolution included a wrong encoder-scale sign; the thread also notes that changing scale can require PID/feed-forward retuning. This is a strong adversarial reminder that a changed measurement can alter control-loop behavior even if the actuator hardware itself is unchanged.

### Physical measurement remains a separate evidence source

Older encoder troubleshooting:

https://forum.linuxcnc.org/38-general-linuxcnc-questions/30143-encoder-issues-help

The report described severe scale error plus repeatability/drift. It reinforces why a position signal should not be treated as self-authenticating physical truth; independent measurement is needed when distinguishing scaling/counting faults from mechanics.

The transferable lesson is **not** that every following error is an encoder-scale fault. Measured disagreement is symptom evidence. Independent command, feedback, raw count, external metrology, wiring/electrical evidence, and plant-response evidence may be needed to discriminate the actual cause.

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
fixture true_B
!= real secondary encoder
!= external metrology truth
```

```text
sensor-fault evidence
!= automatic stop/continue/fault policy
!= safety-rated sensor architecture
```

## Resolved experiment-design questions

1. **One fault or three in the first lab?** Freeze one fault first. It creates the clearest causal separation and allows the thread-order/observation contract to be validated before reusing it for scale and jump/offset.
2. **Userspace float capture or new realtime hold component?** For the first 1000-level lesson, a userspace capture is sufficient only because phase 0 is unscored and decisive phase rows verify the already-published constant and selector in realtime. A custom realtime float hold may be promoted if exact capture-instant behavior later matters.
3. **What qualifies as true state?** Only the deterministic `integ` state of the fixture. Call it **toy/fixture truth**, never physical truth.
4. **Include motion following-error policy now?** No. First isolate measurement/control semantics. C05 should not conflate sensor transformation with downstream machine fault policy.

## Frozen first experiment

`experiments/C05-028-feedback-freeze-plan.md` was committed before implementation. Its Gates A-H require same-cycle true-B, measured-B, selector, freeze constant, controller arithmetic and raw trace evidence. The implementation is `lab-jobs/028-c05-feedback-freeze.sh`.

## Remaining C05 work after C05-028

C05 still requires at least:

- a deterministic **scale** fault where measured B tracks true B with a wrong multiplicative gain;
- a deterministic **jump/offset** fault where measurement discontinuously changes while toy true B does not make the same discontinuity;
- adversarial exam and fresh-AI scenario distinguishing sensor fault evidence from actuator/plant fault evidence;
- promotion audit for physical independent-sensor/metrology architecture and any safety-rated implications.

The same true-state/measurement separation should be reused so later tests do not introduce a new observation model unnecessarily.

## Exact next checkpoint

Inspect and reconcile the single authoritative C05-028 workflow launched by implementation commit `5f4f0a765f577921e4c338953e016213a3b59f25`. Preserve raw realtime trace, stdout/stderr, actual job runtime and Gates A-H. Do not launch a duplicate while that workflow is active. If valid, freeze the scale/jump follow-on before implementation using the now-verified observation contract.
