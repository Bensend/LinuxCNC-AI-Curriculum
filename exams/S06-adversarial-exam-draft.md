# S06 — adversarial exam draft

- Module: S06 — fault injection framework
- Course level: 1000
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Status: DRAFT pending experiment reconciliation; questions/expected reasoning frozen before seeing S06-016 outcome.

## Exam

### Q1 — misleading premise: fault selector as proof

A fixture exports `fault-active=TRUE` and its author says that proves a freeze was injected. The downstream detector also reads `TRUE`. Is this sufficient independent evidence that the production path encountered a freeze? Explain precisely what additional evidence is required and why.

### Q2 — source trace: streamer starvation

At the pinned revision, `streamer.0` is enabled and scheduled, but its FIFO is empty on an eligible clock. Trace `streamer.c::update()` from the FIFO-depth check to the externally visible data/status behavior. Which observation proves FIFO starvation and which observation merely shows the previously published data value?

### Q3 — sampler evidence-health failure

A one-cycle jump experiment produces exactly the expected detector assertion in a text trace, but `sampler.0.overruns` is 3 and three cycle numbers are absent around the injection window. The test author wants to accept it because the visible rows look right. Classify the experiment and justify the classification.

### Q4 — version-sensitive/source-specific claim

A learner assumes `sampler.N.sample-num` is an authoritative cycle counter because the pin exists. At pinned commit `8bf4605...`, what must be checked before using it as an oracle, and what did the source pass actually find?

### Q5 — injection-layer mismatch

A HAL `mux2` switches encoder feedback from live to a constant. The resulting LinuxCNC following-error path behaves as predicted. Which claims are supported, and which of the following are *not* established: physical encoder failure, EtherCAT packet loss, HostMot2 read failure, HAL-level stale-value effect, safety diagnostic coverage?

### Q6 — deterministic timing

Why can feeding `streamer` from a userspace process be a poor choice if the core hypothesis is "one and only one servo cycle contains this corruption"? Under what condition can streamer still provide useful deterministic sequence input?

### Q7 — recovery

A fault window ends and the fixture's `fault-active` bit clears. The downstream published value remains stuck for another 20 cycles. May the experiment claim recovery at the moment the bit cleared? Define the correct recovery evidence.

### Q8 — failure-path classification

The tiny test-only component fails to load because of a `halcompile` syntax error. The stock observer therefore never executes. Is that a `BEHAVIOR_FAIL`, `HARNESS_INVALID`, or evidence that the chosen LinuxCNC primitive is unsuitable? What should the attempt ledger record?

### Q9 — fresh scenario: stale but numerically plausible

A source publishes a ramp increasing by 0.01 per cycle. The observer's value-mismatch threshold is 0.05. Publication is exactly one cycle old for ten cycles, and a sequence channel independently exposes one-cycle age. Predict a value-only detector and an age detector configured for `>0.5 cycle`. Which detector should assert, and what does that teach about fault model observability?

### Q10 — bounded modification task

Modify the S06-016 design conceptually to test a two-cycle intermittent freeze every tenth cycle without altering production observer code. Specify:

1. the injection point;
2. the raw evidence that proves the injection really happened;
3. the stock/downstream response evidence;
4. a healthy/adversarial control;
5. recovery evidence;
6. one condition that would make the harness invalid;
7. one non-claim.

## Expected reasoning / answer key

### A1

No. `fault-active` is self-report from the injector and is a circular oracle if used alone. Require raw independent consequences of the injected fault, e.g. a healthy/reference sequence advances while the actually published sequence/value does not. Then require a separate downstream observer/status state to prove subsystem response. Reading the injector's own control bit twice does not establish either fact.

### A2

`update()` refreshes `curr-depth` and `empty`. If the invocation is eligible to clock and depth is zero, it increments `underruns` and returns without copying new FIFO data to output pins. The existing data pins retain their previous values. `empty`/`curr-depth`/`underruns` establish the streamer/FIFO starvation condition; the retained output alone does not identify why it stopped changing.

### A3

`HARNESS_INVALID` for an exact-cycle claim. Pinned `sampler.c::sample()` increments overruns when FIFO write fails and the sample is lost. Missing rows near the required window mean the evidence cannot establish exact duration/adjacency. The visible detector assertion may be suggestive but cannot satisfy the frozen acceptance gate.

### A4

Inspect the actual pinned implementation, not merely the exported pin declaration or a different version's documentation. The S06 source pass found that `sampler.c::sample()` at this revision does not increment/use the exported `sample-num` field. S06 therefore supplies and samples an explicit realtime cycle/sequence value instead.

### A5

The experiment supports behavior at the injection layer actually used: a HAL-level feedback freeze/stale-value effect and the downstream LinuxCNC response at that revision. It does not establish a physical encoder fault mechanism, transport packet-loss semantics, HostMot2 LLIO failure semantics, or safety diagnostic coverage unless those layers are independently preserved and tested.

### A6

The realtime streamer consumes FIFO entries deterministically when its realtime function runs *provided the data is already available*, but a non-realtime feeder is asynchronous. If userspace arrival determines whether a particular servo invocation has a record, scheduler timing can become an uncontrolled part of the fault. Streamer remains useful when the sequence is prefilled sufficiently ahead of consumption or when exact userspace-to-realtime arrival cycle is not itself the claim.

### A7

No. Clearing the scheduler's mode only proves the injector was told to stop. Recovery must be defined at the tested layer: raw publication resumes fresh/current values or sequence, and the downstream diagnostic/state returns to the predeclared recovered condition (or explicitly requires reinitialization if that is the expected behavior).

### A8

`HARNESS_INVALID`. The intended injection and stock response were never exercised. Count it in the experiment attempt ledger as a harness attempt in the current family, diagnose it, and apply the three-attempt safeguard if materially similar failures accumulate. It is not evidence against stock LinuxCNC behavior.

### A9

The value mismatch is 0.01, below 0.05, so the value-only detector should remain clear. The age difference is 1 cycle, greater than 0.5, so the age detector should assert. The lesson is that detectability depends on the observable selected for the fault model; numeric agreement within tolerance is not freshness proof.

### A10

A valid answer keeps the production observer intact and changes only the explicit test stimulus boundary. It must sample a healthy reference and published value/sequence so two-cycle retention can be recomputed independently, then sample downstream observer outputs after the observer executes. Include normal windows and preferably a condition that resembles the fault but should not trigger the chosen predicate. Require fresh publication and observer recovery afterward. Missing trace rows/overruns/wrong function order are valid harness-invalid criteria. State a non-claim such as no physical sensor/transport/safety-integrity validation.

## Pre-result grading rule

S06 cannot graduate from this draft alone. After S06-016 completes, reconcile any observed surprise into the answer key, then perform the fresh-AI novel-scenario handoff and counterfactual promotion audit.
