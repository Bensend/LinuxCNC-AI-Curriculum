# C03 — 1000-level adversarial, handoff, and graduation evaluation

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Course-level objective: understand and verify an explicit relative-feedback cross-coupling topology layered on two independent loops, including sign, realtime staging, topology integrity, saturation/sensor-fault boundaries, and the distinction between nominal disagreement reduction and physical/safety proof.

The ten prompts were frozen before C03-025 result reconciliation in `evaluation/C03-adversarial-exam-draft.md`.

## Adversarial exam

### Q1 — misleading premise

The topology changes the actual local setpoints. With `D = feedback_B-feedback_A`, `C=Kc*D`, PID A receives `base+C` and PID B receives `base-C`; the common base command is no longer the complete command seen by either PID.

**Score: PASS.**

### Q2 — source navigation

Pinned `sum2.comp` adds gained inputs plus offset; pinned `scale.comp` multiplies input by gain plus offset. They add no hidden filtering, peer lookup, saturation, state estimator, fault policy, or safety behavior. C03 synchronization behavior comes from explicit HAL topology and scheduling.

**Score: PASS.**

### Q3 — wrong-sign failure

If A is ahead but disagreement is accidentally defined `feedback_A-feedback_B`, D becomes positive. With the unchanged command signs, A is commanded still higher and B lower, reinforcing disagreement: positive feedback. A valid experiment must sample sign-qualified rows and require correction direction to oppose measured disagreement. C03-025 did this for all 3013 qualified coupled rows.

**Score: PASS.**

### Q4 — servo-stage observation trap

The coupler executes before PID/plant functions while sampler observes after plant advancement. Same-row post-plant feedback is therefore not necessarily the exact feedback used to compute that row's C. The correct oracle samples internal D/C and corrected-command signals or realtime residuals at the relevant stage. Accepted C03-025 reported zero arithmetic residuals.

**Score: PASS.**

### Q5 — version-sensitive question

The verified result is scoped to LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`, the tested HAL topology, component semantics/defaults, function order, gains and deterministic plants. A different revision or implementation requires rechecking source semantics/defaults and rerunning the relevant experiment before transferring quantitative behavior.

**Score: PASS.**

### Q6 — bounded correction authority

Place a limiter after `C=Kc*D` and before the A/B command sums, producing `C_limited = clamp(C,-0.20,+0.20)`. Sample raw D, raw C, limited C, limiter/saturation state, corrected A/B commands, PID outputs and feedback. New questions include duration in saturation, whether disagreement continues increasing while authority is exhausted, interaction with PID saturation/integrator behavior, recovery when leaving saturation, and when fault/slow/stop policy must supersede correction.

**Score: PASS.**

### Q7 — frozen-feedback fault

A frozen B encoder can make the cross-coupler act on false relative-position evidence while the physical/simulated plant keeps moving. Nominal disagreement reduction therefore proves neither sensor plausibility nor safe fault behavior. Frozen/jumping feedback belongs to C05, with later state/fault policy and safety treatment required before machine decisions.

**Score: PASS.**

### Q8 — reduction-versus-safety confusion

Justified: in the pinned deterministic fixture, explicit symmetric relative-feedback coupling at `Kc=0.5` materially reduced sustained measured disagreement and the effect reversed when the coupler was removed. Forbidden: claims of physical alignment, arbitrary-gain/delay/load stability, hydraulic/mechanical suitability, fault tolerance, or safety-rated anti-racking.

**Score: PASS.**

### Q9 — topology integrity

If both disagreement inputs are actually feedback A, the explicit peer-disagreement path is absent and C03's cross-coupling claim is unproven even if local PID outputs differ. Acceptance requires topology evidence showing distinct A/B feedback signals enter the disagreement arithmetic, sampled D/C and corrected commands satisfy the declared realtime equations, and removal of the coupler removes correction.

**Score: PASS.**

### Q10 — transfer scenario

A lag plus correction saturation plus local PID saturation permits only the conclusion that the controller is reaching authority limits while disagreement remains dynamic. It does not establish which side/sensor is correct, whether the plant is mechanically safe, whether continued motion is stable, or which stop/fault action is appropriate. Before choosing continue/slow/stop/fault, add bounded-authority behavior, sensor plausibility/fault tests, output/plant saturation tests, disagreement thresholds/time policy, stopping behavior, and physical/safety validation.

**Score: PASS.**

**Adversarial result: 10/10.**

## Fresh-AI handoff — novel scenario

**Scenario:** A two-side simulator uses the validated C03 law, but correction authority is limited to ±0.20. Side B's plant gain drops to 0.35 while its encoder simultaneously develops a +3% scale error. During a fast command ramp, C remains at the positive limit for 1.2 s and both PID outputs approach their limits. The displayed A/B feedback disagreement then shrinks. Decide what a fresh engineer may conclude and what must be tested before continuing motion.

**Expected reasoning and result:** PASS.

1. The topology is still explicit negative-feedback cross-coupling only if the sampled sign convention and corrected commands oppose measured disagreement.
2. A saturated correction proves authority exhaustion, not successful synchronization; the bounded command can no longer increase its corrective effect.
3. Shrinking measured disagreement is ambiguous because B feedback is scaled incorrectly; measured convergence can coexist with worsening physical alignment.
4. Local PID output saturation adds another authority limit and may alter recovery/integrator behavior; C03 does not prove behavior in that combined regime.
5. The correct next evidence separates plant truth from sensor truth, records limiter/PID saturation duration, checks sensor plausibility, and tests the transition into and out of saturation.
6. Continue/slow/stop/fault is downstream state/fault policy and physical/safety validation, not a conclusion supplied by nominal C03 evidence.

This is a novel combination of saturation plus sensor/plant asymmetry and requires transfer of the C02/C03 boundaries rather than repetition of the accepted nominal experiment.

## Promotion / uncertainty queue

| Item | Destination | Priority | Blocks C03? | Why promotion is safe |
|---|---|---:|---|---|
| Quantitative tuning/stability across delays, gains, compliance and coupled physical plants | 2000 / advanced capstone | HIGH | No | C03 teaches only the verified explicit topology and bounded nominal result; it makes no arbitrary-stability claim. |
| Correction limiter and PID/output saturation interaction | C04 / C07 / 2000 | HIGH | No | Saturation can change downstream behavior but cannot overturn the source arithmetic or accepted nominal negative-feedback result. |
| Frozen, scaled, jumping or implausible feedback under cross-coupling | C05 | CRITICAL | No | C03 explicitly does not claim sensor-fault tolerance; C05 owns that evidence. |
| Physical hydraulic/mechanical synchronization and racking dynamics | hardware validation / advanced capstone | CRITICAL | No | No physical-machine claim is used for graduation. |
| Safety-rated disagreement detection, stop and energy isolation | safety architecture / advanced capstone | CRITICAL | No | C03 explicitly separates ordinary software control from safety authority. |
| Other LinuxCNC revisions/component semantics | 2000 version review | MEDIUM | No | All source/runtime claims are pinned to one revision. |

## Counterfactual promotion test

If every promoted item behaved differently from present expectation, would C03's central teaching become false, make C04/C05 prerequisites unreliable, invalidate C03-025, or weaken the safety boundary?

**No.** The central claim is narrow: explicit HAL arithmetic can create relative-feedback negative cross-coupling, and in the pinned deterministic nominal fixture it reduced measured disagreement under the frozen disturbance. Unexpected saturation dynamics, sensor-fault behavior, physical hydraulics, or safety architecture would change downstream design decisions but not that verified topology/result. The safety boundary remains conservative.

## Minimum graduation evidence floor

- [x] Pinned source arithmetic and execution path traced.
- [x] Independent frozen-gate runtime verification completed with retained raw evidence.
- [x] Representative failure paths understood: wrong sign, topology defect, phase-publication defects, saturation and sensor-fault boundaries.
- [x] Prediction checked against independent evidence.
- [x] Adversarial exam passed 10/10.
- [x] Fresh-AI novel-scenario handoff passed.
- [x] No critical uncertainty is hidden or promoted in a way that can overturn the current teaching.
- [x] Counterfactual promotion test passed.
- [x] Safety/reliability boundary remains explicit and conservative.

## Graduation sufficiency decision

**C03 GRADUATED at 1000 level.**

C03 is sufficient as a prerequisite for C04 and C05. It establishes explicit relative-feedback cross-coupling and a bounded nominal behavior result; it does not establish arbitrary stability, sensor-fault tolerance, physical hydraulic/mechanical synchronization, or safety-rated anti-racking.