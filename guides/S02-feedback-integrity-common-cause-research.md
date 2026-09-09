# S02 — feedback integrity, diversity and common-cause research

Status: RESEARCH / pre-freeze
Date: 2026-09-09
Pinned source baseline inherited from D01: LinuxCNC `8bf4605ae81042248add031e94c77300406e0413` for source claims unless superseded by an explicit version matrix.

## Why S02 exists

D01 proved that per-joint software feedback is necessary evidence for duplicated-joint disagreement, but it did not prove that any feedback channel is physically truthful. S02 therefore treats **value**, **transport freshness**, **sensor freshness**, **validity**, **independence**, and **physical truth** as separate properties.

## Pinned HostMot2 encoder source findings

`src/hal/drivers/mesa-hostmot2/encoder.c` exposes optional quadrature-sequence error handling. When `quadrature_error_enable` is true, the driver reports the FPGA quadrature-error state; when disabled it reports the HAL error pin false. The source describes the encoder module as supporting index/index-mask and velocity estimation and separately publishes A/B/index input states.

Important boundary: quadrature-sequence checking is not a general encoder-health oracle. An illegal A/B transition can be evidence of a signal/counting problem, but absence of such an error does not establish that the encoder is connected, moving when the plant moves, mechanically coupled to the intended member, correctly scaled, fresh, or independent of another channel.

The current source review has not identified a generic per-incremental-encoder `fresh`/`valid` pin that proves new physical information arrived in the current servo cycle. A numerically unchanged position can mean legitimately stationary hardware or a frozen/stale/disconnected measurement; value equality alone cannot distinguish those cases.

## Pinned hm2_eth transport-freshness trace

Pinned `src/hal/drivers/mesa-hostmot2/hm2_eth.c` provides a stronger but narrower freshness surface at the **board transaction** boundary:

1. queued read construction increments `read_cnt`, writes that count into the board timer register, and queues a readback of the board's confirmed read/write counters;
2. `hm2_eth_receive_queued_reads()` receives the whole queued response and only then copies each queued field into its destination buffer;
3. a short/missing response records a soft communication error and returns `-EAGAIN` rather than treating the response as fresh;
4. after a full response, the driver rejects a mismatched confirmed write count via `record_soft_error()`; successful cycles call `decrement_soft_error()`;
5. `record_soft_error()` asserts `packet-error`, increments `packet-error-total` and `packet-error-level`, sets `needs_soft_reset`, and eventually asserts low-level `io_error` / `packet-error-exceeded` at the configured limit.

This means `packet-error == FALSE` after a successful current board transaction can support a claim that the driver received a transaction satisfying its protocol checks. It **cannot** establish that an individual encoder observed new physical motion, that its A/B wiring is intact, that its mechanical coupling is intact, or that two channels are independent. Board-transaction freshness and sensor/physical freshness are different claims.

The official `hm2_eth(9)` documentation makes the stale-data boundary unusually explicit: packet loss is detected by expected packet counts, and it describes transient loss as capable of leaving stale position feedback. It also warns that not all HostMot2 special functions recover equivalently. Therefore S02 must not convert a transport-health indication into a per-sensor physical-validity bit.

The HostMot2 watchdog is a different mechanism again. Documentation says a watchdog bite disconnects board I/O pins while internal encoder instances can continue counting. Therefore watchdog state is evidence about the board I/O/output-authority path, not proof that encoder feedback represents physical actuator motion.

### Function/call-flow summary

```text
servo-thread HostMot2 read
  -> hm2_eth queued read request
     -> increment/read_cnt + request confirmed board counters
  -> Ethernet transaction
  -> hm2_eth_receive_queued_reads()
     -> response size/timeout check
     -> copy queued board data to driver buffers
     -> confirmed write-count check
     -> record_soft_error() OR decrement_soft_error()
  -> HostMot2 module processing publishes encoder HAL values
  -> motion/controller consumes those values
```

Evidence boundary: success authenticates the checked transport transaction; it does not authenticate the physical source of every value inside that transaction.

## Community evidence to preserve as non-authoritative leads

LinuxCNC forum discussion with Mesa developer PCW characterizes HostMot2 quadrature error detection as intentionally limited: it checks illegal transitions, is disabled by default, and must be connected in HAL to affect machine behavior. Gross encoder errors are normally expected to become following errors, while quadrature checking is useful for noise/miscount problems. This reinforces—without elevating forum statements to source authority—that quadrature error and following error cover different symptom classes.

A historical hm2_eth discussion by LinuxCNC developer Jeff Epler gives a particularly useful adversarial example: after a watchdog bite, internal stepgen feedback can continue changing while physical step/direction pins are no longer driving the machine. This is strong community evidence for the general lesson that internally coherent software feedback is not automatically physical truth; current source/docs must remain the authority for current-version behavior.

A 2025 community failure report describes one encoder input influencing another even with an encoder disconnected; diagnosis focused on multiplexing/cable/card faults. This is a useful common-cause/adversarial pattern: two software channels can become correlated by shared acquisition infrastructure, so agreement/correlation does not prove independent physical sensing.

Other community reports show wiring, signal-level, filter and noise faults affecting encoder behavior. These are scenario-generation evidence, not proof of universal failure semantics.

## Authority model

```text
physical member pose
    -> mechanical coupling
    -> encoder transducer
    -> electrical A/B(/index) signals
    -> shared/independent input conditioning and acquisition
    -> HostMot2 count / error state
    -> board/host transport transaction
    -> LinuxCNC HAL position/velocity/error values
    -> motion joint feedback / ferror logic
    -> diagnostics and ordinary motion authority
```

A downstream value cannot authenticate all upstream arrows merely because it is plausible.

### Required distinctions

- **Value plausibility:** number lies in an expected range.
- **Transport freshness:** the host obtained a current transaction satisfying the transport protocol's checks within a defined bound.
- **Sensor freshness:** evidence establishes whether the sensor/acquisition path supplied new physical information within a defined bound. A stationary incremental encoder makes this intrinsically different from transport freshness.
- **Validity:** channel-specific diagnostics do not indicate a known-invalid condition; absence of a limited diagnostic is not universal validity.
- **Diversity/independence:** channels do not share every relevant failure cause.
- **Physical truth:** actual machine geometry/state; software-only evidence can bound claims about it but cannot silently substitute for independent physical evidence.

## Initial adversarial classes

1. **Differential disagreement:** one channel changes relative to another. Software comparison can detect this if both values are available and thresholds/time semantics are justified.
2. **Frozen/stale channel:** one channel holds a plausible old value. Differential monitoring may detect it only when the other side or commanded/plant state changes enough; at standstill, equality does not prove sensor freshness.
3. **Common-mode false agreement:** both software channels report mutually consistent but wrong values because of shared acquisition, scaling, mechanical reference, wiring/mux, or model faults. Pure comparison of those two channels cannot prove the fault absent.
4. **Illegal quadrature/noise:** quadrature-error evidence may detect a subset of signal faults, but absence of that flag is not a general validity/freshness proof.
5. **Mechanical decoupling:** encoder remains electrically healthy while losing truthful coupling to the controlled member. Electrical diagnostics alone cannot authenticate the physical geometry.
6. **Fresh transport carrying stale/wrong sensor truth:** a fully valid current board packet may faithfully contain an unchanged or wrong encoder count. Transport success must not clear a sensor-integrity alarm whose premise is independent.

## Pre-freeze conclusions and remaining questions

Resolved enough to freeze:
- hm2_eth packet/error surfaces bound board-transaction health, not per-encoder physical freshness.
- HostMot2 watchdog state is not a physical-feedback validity oracle.
- incremental encoder value equality at standstill cannot prove sensor freshness without an independent stimulus/oracle.
- common-mode false agreement is unobservable from the two agreeing channels alone by construction.

Still version/hardware-sensitive and therefore not to overclaim:
- exact quadrature-error behavior across Mesa firmware generations;
- minimum real-hardware diversity required for a particular machine risk reduction;
- physical stopping/geometry consequences of specific sensor failures.

## Frozen S02 adversarial model requirements

The implementation must use explicit synthetic ground truth so observability can be scored without pretending the software model is a physical sensor qualification. Freeze these phases before implementation:

- **P0 baseline:** physical_A = physical_B = reported_A = reported_B; transport healthy.
- **P1 differential fault:** reported_B diverges while reported_A tracks physical truth. Required observable: pairwise disagreement; classification must not require transport error.
- **P2 stale/frozen B during motion:** physical_B continues changing but reported_B freezes while transport remains healthy. Required observable with synthetic oracle: stale B. Pairwise disagreement may become a symptom, but the experiment must distinguish the cause from generic differential error using the injected truth/age state.
- **P3 stationary ambiguity:** physical and reported values stop changing with healthy transport. Required conclusion: unchanged value alone cannot distinguish legitimate standstill from a frozen incremental channel.
- **P4 common-mode false agreement:** reported_A == reported_B while both differ from synthetic physical truth; transport remains healthy. Required conclusion: pairwise comparison and clean transport cannot detect the physical error without the independent oracle.
- **P5 limited diagnostic:** assert a modeled quadrature diagnostic independently of transport and disagreement. Required conclusion: this is evidence for a covered signal-sequence fault class only, not universal channel invalidity semantics.

### Frozen acceptance gates

A. Atomic trace retains phase, synthetic physical truth, both reported channels, transport-health state, diagnostic state, detector outputs and recorder-health evidence.
B. Baseline has no false disagreement/stale/common-mode detector assertion.
C. P1 pairwise disagreement is detected within the declared monitor bound while transport remains healthy.
D. P2 demonstrates that transport can remain healthy while one reported channel is stale relative to the synthetic physical oracle.
E. P3 explicitly produces **UNKNOWN sensor freshness from value-only evidence** rather than declaring healthy.
F. P4 demonstrates false agreement: reported_A == reported_B and transport healthy while synthetic physical truth disagrees; a detector using only the two reported channels plus transport must not claim detection.
G. P5 diagnostic assertion is not promoted into proof of physical truth or independence.
H. The analysis labels synthetic ground truth as a laboratory oracle, not a LinuxCNC production signal.
I. Recorder evidence proves the retained trace itself is suitable for gate scoring.
J. No conclusion claims functional-safety coverage, real-machine sensor independence, or universal behavior beyond the pinned/version-qualified evidence.

The frozen model may now be implemented without changing P0–P5 or Gates A–J merely to make a run pass. Any necessary harness correction must be classified separately.