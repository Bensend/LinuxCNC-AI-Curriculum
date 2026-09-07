# S06 — adversarial exam and answer key

- Module: S06 — fault injection framework
- Course level: 1000
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Experiment reconciled: S06-016 run `34146966388`, PASS, exit `0`

The core questions were frozen before S06-016 completed. The accepted result was then used only to reconcile/correct the answer key, not to rewrite the questions around the outcome.

## Exam and graded answers

### 1. Misleading premise — selector as proof

**Question.** A fixture exports `fault-active=TRUE` and its author says that proves a freeze was injected. The downstream detector also reads `TRUE`. Is this sufficient independent evidence?

**Answer: PASS.** No. `fault-active` is injector self-report and circular if used alone. Injection must be established from independent raw consequences—for example healthy sequence advances while published sequence/value remain fixed. Downstream response must then be established from target/observer state that does not depend on the injector mode declaration.

S06-016 explicitly encoded this rejected proposition in its result JSON and used raw reference/published relationships plus stock comparator outputs instead.

### 2. Source trace — streamer starvation

**Question.** At the pinned revision, `streamer.0` is enabled/scheduled but its FIFO is empty on an eligible clock. What happens?

**Answer: PASS.** `streamer.c::update()` publishes FIFO depth/empty, then when clocking finds depth zero it increments `underruns` and returns without copying a new record to data pins. Existing output data therefore remains. `empty`/depth/underrun are evidence of FIFO starvation; an unchanged output value alone does not identify the cause.

### 3. Sampler evidence-health failure

**Question.** Expected detector output appears, but `sampler.0.overruns=3` and rows are missing around a one-cycle injection. Accept?

**Answer: PASS.** No. For the frozen exact-cycle claim this is `HARNESS_INVALID`. Pinned sampler loses a sample when its FIFO write fails. Missing rows around the critical window destroy the adjacency/duration evidence even if surviving rows look plausible.

### 4. Version-sensitive `sample-num`

**Question.** May the learner assume exported `sampler.N.sample-num` is an authoritative cycle counter because current docs say it auto-increments?

**Answer: PASS with conflict preserved.** No. Check the pinned implementation. The inspected pinned `sampler.c::sample()` does not update the exported `sample_num` field, even though current documentation describes an auto-incrementing field. The stream API itself has sample numbering, but S06 does not silently equate that with the exported HAL field. S06-016 samples its own realtime cycle value.

### 5. Injection-layer mismatch

**Question.** A HAL selector freezes encoder feedback and following-error behaves as predicted. What is supported?

**Answer: PASS.** HAL-level stale/frozen feedback effect and the downstream LinuxCNC behavior at the tested revision are supported. Physical encoder failure mechanism, EtherCAT loss, HostMot2 LLIO failure, and safety diagnostic coverage are not established unless those layers are actually preserved/tested.

### 6. Deterministic timing and streamer

**Question.** Why is a userspace-fed streamer risky for "exactly one servo cycle is corrupted"?

**Answer: PASS.** The realtime streamer consumes deterministically once data exists, but the non-realtime feeder's arrival is asynchronous. If arrival timing decides which servo cycle receives a record, the OS scheduler becomes an uncontrolled variable. A prefilled FIFO remains useful for deterministic prerecorded sequences.

### 7. Recovery

**Question.** Injector mode clears but publication remains stuck 20 more cycles. Recovered?

**Answer: PASS.** No. Ending the fault command is not recovery. Require fresh/current raw publication/sequence and the expected downstream recovered state, or an explicitly expected reinitialize/rehome state.

### 8. Failure classification

**Question.** Tiny test component fails to load; stock observer never runs. Classify.

**Answer: PASS.** `HARNESS_INVALID`. Record the attempt in its family, diagnose it, and apply the three-attempt safeguard if similar failures accumulate. It is not evidence against stock LinuxCNC behavior.

### 9. Numerically plausible stale data

**Question.** Ramp changes 0.01/cycle, numeric mismatch threshold is 0.05, publication is exactly one cycle old, age threshold is >0.5 cycle. Predict.

**Answer: PASS and independently TEST-CONFIRMED by S06-016.** Numeric detector stays clear because 0.01 < 0.05; age detector asserts because 1 > 0.5. S06-016 cycles 130–139 observed exactly that split.

### 10. Bounded modification task

**Question.** Adapt the fixture for a two-cycle intermittent freeze every tenth cycle without altering production observer code.

**Answer: PASS.** Keep injection at the test stimulus/publication boundary. Sample healthy and published value plus source-origin sequence so the two-cycle retention is independently recomputable. Sample stock observer outputs after observer execution. Include normal cycles and an adversarial condition that should not trigger. Require current publication and observer clear after each window. Wrong function order, missing rows, sampler overrun, or absent raw freeze makes the harness invalid. Explicitly decline physical/safety claims.

## Post-result adversarial correction

S06-016 exposed one subtle trace issue that did **not** invalidate a frozen gate: at cycle 54 the human-formatted absolute value mismatch prints `0.050000` while the strict stock comparator output is already true. The comparator source uses floating values at greater precision than the six-decimal trace display. Therefore formatted decimal equality is not an exact threshold oracle.

Correction incorporated into the developer guidance:

> If exact floating threshold behavior is itself the claim, capture enough precision or establish the comparison in the same realtime path. Do not infer bit-exact equality from rounded text.

No S06 gate depended on cycle 54 being exact equality; the frozen freeze gate required eventual assertion later in the window.

## Novel fresh-AI scenario — provenance trap

A device publishes a physical measurement to a gateway. The **device** stops producing new measurements, but the **gateway** keeps retransmitting the last value every servo cycle and generates a new local sequence number for every retransmission. The machine is stationary, so the repeated value is numerically plausible. A monitor sees:

- unchanged value equal to expected stationary position;
- gateway sequence advancing normally;
- no numeric mismatch.

**Question:** May an AI conclude the device measurement is fresh because the sequence is fresh?

### Fresh-AI reasoning result: PASS

No. The sequence proves freshness only at the point where that sequence originates. Here it proves the gateway is publishing fresh *messages*, not that the underlying device supplied a fresh *measurement*. The age/freshness observable must have provenance at or below the fault boundary whose freshness is being claimed. If the freshness token is regenerated downstream of a stalled source, it can mask the source freeze.

The correct experiment would preserve or synthesize a device-origin sample counter/timestamp/heartbeat, or inject beneath the gateway and observe a source-origin freshness token. Without that evidence, the result should remain bounded to gateway publication freshness.

This scenario is not answered by merely memorizing S06-016's numeric thresholds; it requires applying the layer/provenance rule to a new architecture. It also connects the S04 promotion item for device-specific sequence/timestamp semantics to S06's evidence framework.

## Exam conclusion

The adversarial exam passes at 1000 level. It confirms the learner can distinguish injector self-report from independent evidence, classify harness failure correctly, reason through FIFO/capture loss, respect layer boundaries and version conflicts, define recovery, and recognize that **freshness metadata itself has provenance**.
