# S05 adversarial exam and answer key

- Module: S05 — disagreement/redundancy monitoring patterns
- Course level: 1000
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Required artifacts: `guides/S05-disagreement-redundancy-monitoring-research.md`, `call-flows/S05-disagreement-voting-persistence.md`, `source-analysis/S05-component-semantics-and-boundaries.md`, `experiments/S05-015-accepted-result.md`

## Exam

### Q1 — misleading premise

Two independent-looking position values in HAL agree to within 0.01 units for ten seconds. The machine is stationary. An engineer concludes: "The feedback is fresh and correct because both channels agree." Is that conclusion justified? State exactly what the comparison proves and what it does not.

### Q2 — threshold boundary

A monitor uses `sum2` with gains `+1/-1`, then `wcomp.min=-0.125`, `wcomp.max=+0.125`, and `or2(wcomp.under,wcomp.over)` as raw fault. What happens at `A-B=-0.125`, `-0.124`, `+0.125`, and `+0.126` at the pinned revision?

### Q3 — persistence path

The raw fault becomes true for 40 ms, healthy for 10 ms, true again for 20 ms. `timedelay.on-delay=50 ms`, `off-delay=30 ms`. May the engineer add those separated true intervals together and claim a persisted fault must assert? Explain from the source-level timing model.

### Q4 — one-cycle timing skew

Two sensors are individually exact, but A publishes the current sample and B publishes a sample one servo period old. Servo period is 10 ms and the measured quantity changes at 20 units/s. The disagreement threshold is 0.125 units. What does the monitor see, and what engineering assumption is missing if this is classified as a sensor fault?

### Q5 — majority-voter trap

A `maj3` input state is `(TRUE, TRUE, FALSE)` and output is TRUE. What can be inferred about which leg is correct? What evidence is lost if only the voted output is retained? What changes for `(FALSE, FALSE, TRUE)`?

### Q6 — common-cause voter failure

Three boolean channels represent the same physical condition. Two channels share a common upstream cause and fail to TRUE while the third correctly remains FALSE. What does `maj3` output, and why does this not contradict its source semantics?

### Q7 — call-flow and ordering

For same-cycle comparison intent, order these functions and explain the consequence of moving the second sensor-publication function after the comparator:

- `timedelay`
- sensor A publication
- `wcomp`
- sensor B publication
- `sum2`
- ordinary response/latch
- `or2`

### Q8 — bounded HAL modification task

A configuration currently keeps only `maj3.0.out` and discards the raw inputs. Design a bounded modification that preserves the functional vote but also makes one-leg dissent observable. Do not claim safety certification.

### Q9 — version-sensitive reasoning

A future LinuxCNC revision changes `wcomp` boundary semantics. Can the S05 exact-threshold conclusion be silently applied to that revision? What must be rechecked?

### Q10 — failure-domain design

For a two-channel position monitor, list at least four distinct failure/invalid-input modes that should not be collapsed into the single phrase "redundant feedback failed." For each, state whether plain numerical disagreement can necessarily detect it.

## Answer key / grading

### A1

No. Agreement proves only that the two published numerical values satisfy the configured comparison at the observed instants. It does not prove freshness, correctness, physical independence, independent references, independent wiring/power, or safety integrity. S04 established the freshness distinction; S05 adds common-mode and timing-alignment limits.

### A2

Pinned `wcomp` uses `under=(in<=min)` and `over=(in>=max)`, so the healthy `out` is strictly inside the window. Therefore:

- `-0.125`: `under=TRUE`, raw fault TRUE;
- `-0.124`: inside, raw fault FALSE;
- `+0.125`: `over=TRUE`, raw fault TRUE;
- `+0.126`: `over=TRUE`, raw fault TRUE.

### A3

No. `timedelay` accumulates while its input differs from its current output and resets the internal timer when input equals output. A healthy interval that returns input to the current false output resets the pending on-delay accumulation. Separated fault intervals are not automatically additive. `timedelay.out`, not a casually interpreted `elapsed` value, is the state oracle used by S05.

### A4

Apparent disagreement is `v*Ts = 20 * 0.010 = 0.200 units`, which exceeds 0.125. Neither sensor has to be numerically wrong. The missing assumption is acquisition/publication time alignment (and, more generally, freshness/provenance). A comparison threshold alone cannot distinguish skew from physical disagreement.

### A5

`(T,T,F)` produces TRUE; `(F,F,T)` produces FALSE. In neither case does the voter identify which leg is correct. If raw inputs are discarded, dissent identity and maintenance/diagnostic evidence are lost. The vote expresses arithmetic majority, not truth provenance.

### A6

`maj3` outputs TRUE because at least two inputs are TRUE. This exactly matches source semantics. Majority voting cannot defeat a common-cause failure that corrupts two legs in the same direction.

### A7

For same-cycle intent: sensor A publication → sensor B publication → `sum2` → `wcomp` → `or2` → `timedelay` → response/latch. If B publication executes after comparison, the comparator can use A(k) with B(k-1), creating deterministic age skew and possible false disagreement during motion.

### A8

Keep the raw three input signals named and observable, keep `maj3.0.out` as the functional vote, and add separate pairwise dissent diagnostics such as XOR/comparison signals (`in1!=in2`, `in1!=in3`, `in2!=in3`) or an equivalent explicit logic network. Feed diagnostics to status/maintenance logic in parallel with the vote. Do not replace all raw evidence with one voted bit and do not label this ordinary HAL arrangement safety-rated.

### A9

No. S05 is version-scoped to the pinned commit. Reinspect the new `wcomp` source and documentation, then rerun or adapt the boundary experiment. Exact threshold membership is an implementation behavior that can change.

### A10

Acceptable examples include:

1. single-channel drift/jump — often detectable once threshold/persistence criteria are exceeded;
2. one channel frozen while the other changes — detectable once disagreement grows enough;
3. both channels frozen at the same value — not necessarily detectable by disagreement;
4. common-mode equal bias/drift — not necessarily detectable;
5. one-cycle or variable timing skew — can create apparent disagreement even with correct values;
6. scale/sign/offset configuration mismatch — detectable as disagreement but not distinguishable from sensor failure by comparison alone;
7. stale publication in a shared software path — may affect both and remain mutually consistent;
8. out-of-range/invalid metadata not represented in the float value — not necessarily detectable unless validity is carried separately.

## Exam result

**PASS.** The answer key is consistent with pinned source and the accepted S05-015 runtime evidence. No central teaching required correction after adversarial review.

## Correction generated by the exam

The bounded modification task makes one design rule more explicit: a functional vote and diagnostic disagreement logic should be treated as parallel outputs of the raw channels. A design that retains only the vote destroys information that later troubleshooting, fault isolation, or maintenance logic may need. This clarification is incorporated into the graduation handoff.