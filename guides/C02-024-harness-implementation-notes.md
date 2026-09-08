# C02-024 harness implementation notes

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

These notes translate the frozen experiment into an implementation checkpoint without changing its gates.

## HAL construction

Use the C01 `XYZY` motion fixture and preserve its homing/ESTOP/tool loopbacks. Replace the two ideal Y command→feedback loopbacks with a test-only motion feedback arrangement that keeps LinuxCNC motion itself operational while separately feeding the duplicated Y command premise to the C02 controller/plant fixture. The C02 plant is an observational/control subfixture; do not feed its deliberately disturbed position back into `joint.N.motor-pos-fb` if that would cause motion following-error shutdown and obscure the PID-independence question. The experiment must label that separation explicitly.

Load:

```hal
loadrt pid names=c02-pid-a,c02-pid-b
loadrt integ names=c02-plant-a,c02-plant-b
loadrt sampler depth=30000 cfg=ffffffff
```

Before runtime behavior, explicitly configure:

```hal
setp c02-pid-a.Pgain 4
setp c02-pid-b.Pgain 4
setp c02-pid-a.Igain 0
setp c02-pid-b.Igain 0
setp c02-pid-a.Dgain 0
setp c02-pid-b.Dgain 0
setp c02-pid-a.error-previous-target false
setp c02-pid-b.error-previous-target false
setp c02-pid-a.enable true
setp c02-pid-b.enable true
setp c02-plant-a.gain 1
setp c02-plant-b.gain 1
```

The exact P gain is a fixture parameter, not a claim about machine tuning. Keep both channels identical.

Thread order:

```hal
addf motion-command-handler servo-thread
addf motion-controller servo-thread
addf c02-pid-a.do-pid-calcs servo-thread
addf c02-pid-b.do-pid-calcs servo-thread
addf c02-plant-a servo-thread
addf c02-plant-b servo-thread
addf sampler.0 servo-thread
```

Signal discipline:

```text
joint.1.motor-pos-cmd -- c02-shared-command --> both PID command pins
c02-pid-a.output ---- c02-effort-a ---------> c02-plant-a.in
c02-plant-a.out ----- c02-feedback-a -------> c02-pid-a.feedback
c02-pid-b.output ---- c02-effort-b ---------> c02-plant-b.in
c02-plant-b.out ----- c02-feedback-b -------> c02-pid-b.feedback
```

Using one named HAL signal for both PID command pins is stronger topology evidence than comparing two userspace reads. The duplicated Y joint remains separately observable to retain the C01 prerequisite, but the C02 claim only needs one duplicated-side command signal fanned into both PID command pins.

## Sampler channel proposal

Capture at minimum:

1. shared command;
2. feedback A;
3. feedback B;
4. PID A error;
5. PID B error;
6. PID A output;
7. PID B output;
8. a realtime-visible disturbance marker if practical.

Because `sampler` has only sampled HAL pins, plant gains changed by userspace should be accompanied by explicit before/after `halcmd getp` evidence and a marker boundary in the raw output. If a realtime marker is added, it must not alter either control path.

## Disturbance value

After a stable moving baseline, set only `c02-plant-b.gain` from `1.0` to `0.25`. Preserve the exact command and PID topology. Hold long enough to obtain a sustained interval well above Gate F's `1e-4` separation, then restore gain to `1.0`.

## Disabled-loop phase

After the primary disturbance/recovery evidence has been preserved, deassert only `c02-pid-b.enable`. Capture same-cycle PID outputs and enable state. Gate H is satisfied only if B output becomes zero while A remains enabled and its path continues. Do not describe this as an acceptable machine operating mode.

## Analysis algorithm

Parse raw sampler rows into a dataframe-like sequence keyed by sample number. Reject the decisive interval if sampler overruns are nonzero or sample numbers are non-monotonic. For baseline/disturbance windows compute:

- command span;
- max and sustained A/B feedback separation;
- max A/B error separation;
- max A/B output separation;
- sign consistency between `command-feedback` and each sampled PID error, allowing only a documented one-servo staging relationship where plant output was updated after PID calculation.

Important staging caveat: sampler executes after the plant, while PID error was calculated before the plant in that servo cycle. Therefore `pid.error` corresponds to the feedback value at PID invocation, not necessarily the post-plant `integ.out` sampled later in the same cycle. The harness must not demand exact `sampled command - post-plant feedback == sampled pid.error` at the same row. If exact causal arithmetic is checked, compare against the prior sampled plant state consistent with the declared function order.

This staging rule is an important adversarial observation boundary and must survive into the accepted-result reconciliation.
