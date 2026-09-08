# C05 adversarial exam — scored answers

Frozen exam: `evaluation/C05-adversarial-exam.md`

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Scoring: **10/10 — PASS**

The questions were frozen before C05-028 result review. Answers below are checked against the pinned C05 source model and accepted C05-028 evidence; no question was rewritten around the result.

## 1 — equal `true_B` and `measured_B`

**Answer:** In this fixture it proves only that the selected measurement path equals the independent toy `integ` state for those sampled rows. It does not prove that a physical actuator is at that coordinate, that an encoder is accurate, that the toy state corresponds to mechanics, or that an external metrology reference agrees. Both values can be wrong with respect to a real machine.

**Score: 1/1.** Preserves the fixture-truth/physical-truth boundary.

## 2 — which plant update consumes sampled PID output?

**Answer:** The **next** servo-cycle plant update. The frozen function order runs the plant `integ` functions before the PID functions. `integ` therefore advances with the PID output left from the prior cycle. The same row then contains the updated plant state and the newly calculated PID output; that new output is not consumed until the following plant invocation.

**Score: 1/1.** Correct discrete-time staging.

## 3 — misleading stalled-actuator premise

**Answer:** A frozen measured feedback value does not identify actuator stall. Similar command/feedback symptoms can arise from at least: (a) sensor/encoder freeze or stale transport data while the plant moves; (b) physical actuator stall or loss of hydraulic/drive authority while the sensor remains truthful; (c) scaling/sign/counting/configuration faults that make feedback diverge despite motion; and (d) wiring/communication faults that present a stale or substituted value. Discriminating evidence includes independent raw counts, separate command and control-output signals, drive/hydraulic current/pressure/valve evidence, communication freshness/error state, and external/independent position metrology.

**Score: 1/1.** Rejects single-symptom diagnosis and names discriminating evidence.

## 4 — what `mux4` knows

**Answer:** `mux4` knows only selector bits and input values; it chooses an input according to the selectors. It contains no physical-plausibility or fault semantics. In the lab, fault knowledge exists in the experiment configuration/oracle that deliberately drives the selector and in the analyst's interpretation of the separately sampled toy truth. It does not exist intrinsically in the mux output, PID, or plant.

**Score: 1/1.** Correct source boundary.

## 5 — scale-fault extension

**Answer:** Preserve `true_B` as an independently sampled signal and calculate a candidate measurement with stock `scale`:

```text
scaled_B = true_B * gain + offset
```

For the frozen follow-on, `gain=1.20`, `offset=0`. Feed `scaled_B` into another mux input and select it only for the scale-fault phase; PID-B and disagreement logic receive mux output, not `true_B`. Same-cycle evidence must retain at least sample number, `true_B`, transformed candidate, selected `measured_B`, selector/mode, command-B, PID-B error/output, disagreement/correction, transform configuration evidence, phase, and arithmetic residuals.

**Score: 1/1.** This matches the independently frozen C05-029 design.

## 6 — jump/offset proof

**Answer:** Continuously compute a candidate `jumped_B = true_B + offset`, then switch the mux from normal to jumped while retaining raw same-cycle `true_B`, both candidate values, measured output, and selector state. Around the actual selector edge compare consecutive realtime rows. A measurement discontinuity is attributable to the transform when:

```text
(measured_edge - measured_prev) - (trueB_edge - trueB_prev) = offset
```

while the sample numbers are consecutive and the transform/mux configuration is known. Merely comparing userspace phase labels before/after a sleep would not prove the edge.

**Score: 1/1.** Explicitly avoids userspace timing contamination.

## 7 — zero disagreement residual

**Answer:** A zero residual proves only that the HAL arithmetic is internally consistent with its **measured** inputs. It does not authenticate either measurement as physical position. Real-machine misalignment claims require independent evidence that the sensors represent the relevant mechanical coordinates, appropriate scaling/sign/calibration, freshness/health, and ideally independent metrology or other diagnostic evidence sufficient for the consequence of the decision.

**Score: 1/1.** Correct causal boundary.

## 8 — future encoder semantic change

**Answer:** The abstract C05 conclusions that downstream control consumes the values wired to it, and that measurement can differ from independently modeled/observed state, remain valid for the toy `integ/scale/mux4` fixture as long as those pinned components retain their semantics. Encoder-specific statements about interpolation, filtering, position derivation, raw counts, timing, or fault behavior must be reverified against the changed encoder implementation/documentation. Passing the toy fixture cannot validate changed encoder internals.

**Score: 1/1.** Correct version discipline.

## 9 — bounded HAL configuration task

**Answer:** One valid relationship is:

```text
addf plant-b servo-thread
addf wrong-scale servo-thread
addf sensor-b-mux servo-thread
addf disagreement/cross-correction ...
addf pid-b.do-pid-calcs servo-thread
addf sampler.0 servo-thread

net true-b plant-b.out => wrong-scale.in sampler.true-b
setp wrong-scale.gain 1.20
setp wrong-scale.offset 0
net scaled-b wrong-scale.out => sensor-b-mux.in1 sampler.scaled-b
net true-b => sensor-b-mux.in0
net measured-b sensor-b-mux.out => pid-b.feedback disagreement-input sampler.measured-b
net fault-selector => sensor-b-mux.sel0 sampler.selector
```

The important ordering is plant -> transform -> mux -> controller -> sampler, with `true_B` sampled independently rather than overwritten by the transformed path.

**Score: 1/1.** Correct bounded modification.

## 10 — immediate hydraulic-disable proposal

**Answer:** A `0.25 in` measured disagreement can be an ordinary diagnostic/control threshold, but C05 does not establish a safety-rated function. The proposal leaves unanswered: sensor independence/common-cause failure, calibration and accuracy, stale-data detection, fault-detection coverage, threshold justification versus dynamics/compliance, stop latency and stopping distance, output de-energization architecture, hydraulic stored energy, safe-state definition, single-fault behavior, diagnostic coverage, restart/reset policy, external safety hardware, applicable standards/risk assessment, and validation/verification of the complete safety function. Ordinary HAL/PID logic alone is not evidence of safety integrity.

**Score: 1/1.** Preserves the machine-control versus functional-safety boundary.

## Result

**10/10 — PASS.**

No correction to the C05 source/call-flow teaching was required by this exam. The strongest recurring competency demonstrated is causal separation among toy/physical state, sensor transformation, selected measurement, controller reaction, and safety policy.
