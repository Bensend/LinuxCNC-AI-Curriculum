# C03 — adversarial exam draft

Status: **QUESTIONS FROZEN BEFORE C03-025 RESULT RECONCILIATION; NOT YET SCORED**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

These questions are frozen before inspecting the C03-025 runtime result so the final evaluation cannot be tailored to the observed outcome.

## Q1 — misleading premise

The C02 loops already share one coordinated command, so adding `sum2`/`scale` components cannot change synchronization; they merely reformat signals. Identify exactly where the proposed C03 topology changes the commands seen by PID A and PID B.

## Q2 — source navigation

Trace pinned `sum2.comp` and `scale.comp` for the C03 law `D = feedback_B - feedback_A`, `C = Kc*D`, `cmd_A = base+C`, `cmd_B = base-C`. What hidden state, filtering, saturation, peer lookup, or safety behavior do these components add?

## Q3 — wrong-sign failure

Suppose A is physically/simulated ahead of B, but the disagreement is accidentally defined as `feedback_A - feedback_B` while the rest of the signs remain unchanged. Predict the correction direction and explain how the frozen experiment should distinguish negative feedback from disagreement-reinforcing positive feedback.

## Q4 — servo-stage observation trap

The coupler runs before the PID and plant functions, while sampler runs after the plants. Why is it unsafe to recompute the correction oracle from same-row post-plant feedback values alone? What signals or residuals should be sampled instead?

## Q5 — version-sensitive question

Can a passing C03-025 result be claimed for every LinuxCNC revision or for arbitrary `sum2`, `scale`, PID, and plant implementations? State the verified version scope and what must be rechecked if any component semantics or defaults change.

## Q6 — small configuration change

Add an explicit bounded correction authority of ±0.20 inch-equivalent to the proposed command correction without changing the local PIDs. Describe where the limiter belongs in the function order, which signals must be sampled, and what new saturation/failure questions appear.

## Q7 — sensor-fault adversarial scenario

Encoder/feedback B freezes while plant B continues moving. The cross-coupler sees growing disagreement and changes both corrected commands. Explain why reduced measured disagreement in a nominal C03 test does not establish safe behavior under this fault, and identify which later capstone work owns the fault experiment.

## Q8 — reduction-versus-safety confusion

A test shows mean simulated A/B disagreement falls by 50% when `Kc=0.5`. Which conclusions are justified, and which conclusions are forbidden about physical alignment, hydraulic/mechanical suitability, closed-loop stability margins, and safety-rated anti-racking?

## Q9 — topology integrity

A harness accidentally feeds `feedback_A` to both inputs of the disagreement `sum2`, but still reports nonzero PID A/B output differences from the asymmetric plants. Which C03 claim becomes unproven? What topology/runtime evidence is required before accepting the cross-coupling experiment?

## Q10 — transfer scenario

A dual-side machine has a valid explicit relative-position coupler that reduces disagreement in normal motion. During a rapid load transfer, side B lags transiently, the correction saturates, and both local PIDs also approach output saturation. Using C02/C03 boundaries, state what can be inferred, what cannot be inferred, and what additional mechanisms/tests are required before choosing whether to continue, slow, stop, or fault.

## Scoring requirements

A passing 1000-level answer set must identify the explicit topology change, trace the arithmetic components, reason correctly about sign and servo-stage timing, reject nominal disagreement reduction as a safety proof, recognize topology/sensor/saturation failure cases, preserve pinned-version scope, and distinguish C03 cross-coupling from downstream fault policy and physical validation.
