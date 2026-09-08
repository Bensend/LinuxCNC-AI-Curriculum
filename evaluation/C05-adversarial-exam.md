# C05 adversarial exam — feedback sensor failure modes

Status: **FROZEN BEFORE C05-028 RESULT REVIEW**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

This exam tests source-level reasoning and must not be rewritten around the C05-028 result after it is known.

## Questions

1. The C05 fixture samples `true_B=4.2`, `measured_B=4.2` for hundreds of rows. Explain exactly what this proves and what it does **not** prove about a physical actuator, encoder, or external metrology reference.

2. In the frozen C05 order, the plant `integ` functions execute before the sensor transform and PID functions. A sample row contains `PID_B.output=2.0`. Which plant update consumes that value: the plant update already represented in the same row, or the next servo-cycle plant update? Ground the answer in `integ.comp` execution semantics and HAL function order.

3. **Misleading premise:** “If `measured_B` freezes while the controller's command continues moving, the actuator has stalled.” Refute or qualify the premise. Give at least three distinct fault classes that can produce superficially similar command/feedback symptoms and identify evidence that discriminates them.

4. Pinned `mux4.comp` selects an input but provides no diagnostic output saying whether that input is physically plausible. If a designer uses `mux4` to inject a frozen value for testing, where does fault knowledge exist, and where does it not exist?

5. Design a scale-fault extension without destroying the C05 independent-truth oracle. Show the exact mathematical relation among `true_B`, scale gain/offset, and `measured_B`, and list the same-cycle fields that must be retained to distinguish measurement scaling from plant response.

6. Design a jump/offset fault that changes measured position discontinuously while the toy plant state remains continuous. What pre/post observations are necessary to prove that the discontinuity arose in the measurement transformation rather than the plant state itself?

7. Suppose the realtime residual `disagreement - (measured_B - true_A)` is exactly zero, but a user claims this proves the cross-coupler is responding to physical A/B misalignment. What is wrong with that conclusion? What additional evidence would be needed on a real machine?

8. A future LinuxCNC revision changes an encoder component's interpolation/filtering semantics, but the C05 toy `mux4/scale/integ` fixture still passes unchanged. Which C05 conclusions remain version-independent abstractions, and which encoder-specific conclusions must be reverified against the new revision?

9. **Bounded configuration task:** starting with normal B measurement `true_B -> mux4.in0`, add a wrong-scale path using stock `scale` and select it as another mux input. Write the necessary HAL-level signal/function-order relationships so `true_B` remains independently sampled and the transformed value is what PID-B receives. Do not add final stop logic.

10. A machine engineer proposes: “When A/B measured feedback differs by 0.25 in, LinuxCNC should immediately disable hydraulics; this makes the architecture safe.” Separate the ordinary diagnostic/control decision from a safety-rated function. List the unanswered assumptions that prevent C05 evidence alone from justifying that policy.

## Scoring rule

Score each answer 0 or 1. A 1000-level pass requires 10/10 after corrections because these questions target core causal and safety boundaries rather than optional implementation trivia. Any miss that confuses measured feedback with physical truth blocks C05 graduation until corrected.
