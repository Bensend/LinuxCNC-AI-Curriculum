# S02 2000-level adversarial exam — immutable learner answer

Date: 2026-09-09
Exam: `evaluation/S02-2000-adversarial-exam-frozen.md`
Pinned LinuxCNC revision for source-sensitive claims: `8bf4605ae81042248add031e94c77300406e0413`
Status: **ANSWER FROZEN / not yet graded**

## Q1 — agreement is not truth

`DOC/SOURCE-CONFIRMED` only at the transport boundary: a clean checked hm2_eth transaction supports the narrow claim that the board response satisfied the driver's current transaction/protocol checks. It does not promote every value in that response to physically fresh or truthful sensor information.

Two equal encoder values for 500 cycles establish only numerical agreement for those observations. `INFERENCE`: if the axis is legitimately stationary, a healthy incremental encoder and a frozen incremental encoder can produce the same unchanged position sequence. Therefore sensor freshness is `UNKNOWN` from equality + clean transport alone.

Independence/diversity is also `UNKNOWN`: two channels may share mechanics, power, connector/cable, input conditioning, multiplexing, FPGA/board acquisition, scaling/configuration, reference assumptions or another common cause. A second software variable derived from the same acquisition path is not an independent witness.

Physical truth is `UNKNOWN` without a justified discriminator. Additional evidence depends on the claim:

- freshness: an independent stimulus/age/freshness witness able to distinguish legitimate no-motion from stale acquisition, or a sensor/interface that provides independently justified freshness semantics;
- independence/diversity: architectural/common-cause analysis plus evidence that relevant failure paths are genuinely separated, not merely two HAL names;
- physical truth: an independently justified physical reference/measurement or diverse sensing/commissioning evidence capable of detecting the common-mode failure of interest.

## Q2 — version-pinned source path

At `8bf4605ae81042248add031e94c77300406e0413`, the S02 source trace is:

1. hm2_eth constructs the queued board read and advances `read_cnt`, including confirmed board transaction-counter information in the checked transaction;
2. the Ethernet request/response is performed;
3. `hm2_eth_receive_queued_reads()` receives the aggregate response, rejects a short/missing response instead of publishing it as a good current read, and only after a satisfactory response copies queued board data to driver buffers;
4. confirmation/count mismatches go through `record_soft_error()`; that path drives `packet-error`, cumulative/error-level state, `needs_soft_reset`, and at the configured escalation point low-level `io_error` / `packet-error-exceeded`;
5. successful checked cycles call `decrement_soft_error()`;
6. HostMot2 module processing subsequently publishes encoder count/position/velocity/diagnostic HAL values from the acquired board state.

`SOURCE-CONFIRMED` boundary: this chain can support board-transaction currency/protocol-health claims within the checked semantics. It does **not** establish that a particular encoder received a new edge this servo cycle, is mechanically coupled, correctly scaled, electrically intact, independent of another channel, or physically truthful. Those properties remain separate evidence questions.

## Q3 — stale during motion vs stationary ambiguity

**Case A.** If an *independent, justified* modeled/physical-motion reference says B's physical state continues changing while reported B is bit-for-bit frozen, then the strongest diagnosis is that reported B is stale/frozen relative to that reference. `TEST-CONFIRMED` in S02's synthetic fixture: transport remains healthy while the stale-vs-oracle discriminator asserts. Pairwise disagreement may be a symptom, but clean transport does not clear the stale diagnosis. Without the independent motion/truth reference, the cause would be weaker—one could prove disagreement but not necessarily identify which channel is truthful.

**Case B.** With intended stationarity, equal constant reports and healthy transport do not distinguish a legitimately stationary incremental encoder from stale acquisition. Sensor freshness is therefore `UNKNOWN` from the stated value-only evidence. The difference is observability: Case A supplies an independent changing reference that makes stale B distinguishable; Case B supplies no such discriminator.

## Q4 — common-mode adversary

Construct two physical positions at 4.0 while a shared acquisition/configuration fault causes both `reported_A` and `reported_B` to remain 3.5; transport health stays true. A healthy-but-actually-at-3.5 state produces the same three detector inputs: `(3.5, 3.5, transport=true)`.

For any deterministic detector restricted to only those inputs, the faulty and healthy states are observationally indistinguishable. It therefore cannot guarantee detection without either also rejecting the indistinguishable healthy state. `TEST-CONFIRMED`: the S02 P4 authoritative trace retained 200 rows with equal reports, healthy transport, 0.5 synthetic physical mismatch and no restricted-detector assertion.

Breaking the ambiguity requires evidence outside that equivalence class: for example a genuinely independent physical reference/diverse sensor, a justified mechanical-reference check, or an independent stimulus/commissioning test that observes the relevant common-mode failure. The S02 `physical_*` signals are laboratory-only oracle values and are not a production LinuxCNC truth source.

## Q5 — quadrature diagnostic scope

At the pinned HostMot2 encoder path, the quadrature diagnostic is evidence about the signal/counting fault class the implementation actually checks (for example illegal quadrature transitions when the feature is enabled/configured). A clean result supports only absence of that detected condition over the observed interval.

It does not prove mechanical coupling, correct scale, channel freshness, independence/diversity, correct association with the intended physical member, or physical truth. A mechanically decoupled encoder can have electrically legal quadrature; a frozen/stationary channel can produce no illegal transition; a shared scaling/reference error can affect both channels without illegal quadrature. Thus those broader claims remain `UNKNOWN` unless separately evidenced.

## Q6 — watchdog/feedback misleading premise

Both clauses are rejected.

The HostMot2 watchdog is an I/O/output-authority mechanism, not an encoder-validity oracle. `DOC/SOURCE-CONFIRMED` S02 boundary: watchdog health does not authenticate an encoder's mechanical coupling, freshness or physical truth.

Likewise a watchdog bite does not imply internal feedback/module state has stopped updating. The documented architecture disconnects board I/O pins from module instances on a bite while internal modules can continue operating. Therefore internal encoder/module state and physical output authority can diverge. Watchdog state, transport state and sensor-integrity evidence must be diagnosed separately.

## Q7 — evidence integrity / recorder adversary

No. Producer overruns plus missing tags around the transition invalidate an exact one-servo-cycle latency claim because the unrecorded interval can contain the true transition/detection ordering. Treating retained adjacent rows as adjacent producer cycles would be false.

A weaker qualitative claim may remain supportable if the surviving rows independently demonstrate a state relation that does not depend on the missing interval, but its timing must be qualified. To recover the exact bound, rerun with an atomic same-thread record containing the relevant inputs/output/phase plus producer-side health evidence showing no loss, and verify contiguous sample tags across the scored transition. Userspace consumer success alone is not enough if the producer reports loss.

## Q8 — bounded HAL design task

Use one realtime monitor function in the same servo thread as the values it evaluates, ordered **after the current-cycle feedback/transport-status producers and before downstream consumers that act on its decision**. Do not make userspace polling part of the realtime decision.

Essential inputs:

- `feedback_a`, `feedback_b` current-cycle values;
- configured disagreement threshold and optional persistence/debounce bound;
- a separate transport-health/current-transaction signal with documented semantics;
- optional **independently justified** freshness witnesses for A and B, if the hardware/architecture actually provides them;
- optional channel-specific diagnostics such as quadrature error, kept separate from freshness/truth.

Essential outputs/state:

- `pair_disagreement` / bounded persistence state;
- `transport_ok` diagnostic dimension, not folded into sensor truth;
- `freshness_a_state` and `freshness_b_state` as at least `PROVEN-FRESH / NOT-PROVEN-OR-UNKNOWN / KNOWN-INVALID` semantics where justified, rather than defaulting equality to fresh;
- `integrity_unknown` when evidence is insufficient;
- diagnostic reason bits so pair disagreement, transport failure, channel diagnostic and unknown freshness are distinguishable;
- an ordinary motion-authority request/fault output only if the machine architecture deliberately consumes it, with separate documentation of that policy.

Ordering matters: if A is sampled from cycle N while B is still from N-1, the monitor can create a false one-cycle disagreement. The HAL thread order must therefore guarantee that both current-cycle producers execute before the monitor, and any realtime consumer of the monitor result executes after it. The authoritative evidence recorder, when validating the monitor, should be later in the same thread so one row captures a coherent producer->monitor state.

A realtime implementation improves deterministic timing; it does **not** make the monitor a functional-safety function. Safety integrity requires a separately justified architecture, failure coverage, independence, hardware behavior, standards/risk analysis and validation. LinuxCNC realtime execution alone supplies none of those certifications or guarantees.

## Explicit critical-trap disposition

1. Clean hm2_eth transaction = per-encoder physical freshness — **REJECTED**.
2. Equal values = both fresh — **REJECTED**.
3. Agreement = independence/diversity — **REJECTED**.
4. Pairwise agreement = physical truth under common-mode fault — **REJECTED**.
5. Clean quadrature diagnostic = universal validity/coupling — **REJECTED**.
6. Watchdog state = encoder-validity oracle — **REJECTED**.
7. Missing producer samples still prove exact latency — **REJECTED**.
8. Synthetic lab oracle exists in production — **REJECTED**.
9. Realtime monitor automatically qualifies as functional safety — **REJECTED**.
10. Userspace sequential reads are atomic servo evidence — **REJECTED**.
