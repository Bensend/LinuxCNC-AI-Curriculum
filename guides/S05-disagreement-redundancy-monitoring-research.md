# S05 — disagreement/redundancy monitoring patterns: initial research and source guide

- Module: S05
- Course level: 1000
- Status: RESEARCH → SOURCE started
- Prerequisite: S04 graduated
- Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Learning objective

A fresh AI engineer should be able to design and audit ordinary LinuxCNC diagnostic logic that compares two or more observations, distinguishes agreement from freshness, uses bounded tolerance/persistence rather than naive equality where appropriate, understands what a majority voter can and cannot diagnose, and keeps ordinary HAL redundancy logic separate from safety-rated redundancy claims.

This module is about **monitoring patterns**, not certification of a machine safety function.

## Official documentation pass

Current LinuxCNC HAL documentation lists several stock realtime building blocks directly relevant to disagreement monitoring:

- `near` — determine whether two values are roughly equal;
- `wcomp` — window comparator;
- `maj3` — majority of three boolean inputs;
- `sum2` — weighted sum/difference building block;
- `timedelay` — time-delay behavior useful for persistence qualification.

The current HAL component documentation also reinforces the execution model inherited from H-series prerequisites: realtime components are loaded and their functions are explicitly added to a realtime thread. Therefore ordering between acquisition, comparison, persistence and fault-latch/response logic is an engineering choice visible in HAL thread order, not an implicit guarantee.

## Community research pass

Community material provides useful but non-authoritative boundaries:

1. Discussions of linear scales plus rotary encoders show that LinuxCNC users routinely combine multiple position observations for different control/accuracy purposes. That is not automatically a redundant-diagnostic architecture; control feedback and diagnostic comparison must be distinguished.
2. LinuxCNC safety discussions repeatedly separate ordinary controller logic from dedicated safety relay/contactors/STO architecture. A redundant value comparison implemented in HAL therefore must not be described as safety-rated simply because it uses two channels.
3. EtherCAT/controller redundancy discussions show that the word “redundancy” is overloaded: cable redundancy, controller redundancy, sensor redundancy and functional-safety redundancy solve different failure domains. S05 must state the protected failure domain explicitly.

These community findings are investigation leads and terminology warnings, not proof of a particular diagnostic coverage level.

## Source inventory and exact semantics

### `src/hal/components/near.comp`

Purpose: two-value approximate-agreement predicate.

Inputs: `in1`, `in2`; parameters `scale` and `difference`; output `out`.

Pinned behavior:

- If `in1` is negative, both inputs are sign-flipped before comparison.
- `out` becomes true if either a multiplicative tolerance test succeeds when `scale > 1`, **or** `fabs(in1-in2) <= difference`.
- Otherwise `out` is false.

Engineering consequence: `near` implements an **OR** between relative and absolute tolerance mechanisms. Setting both without understanding that OR can make agreement looser than intended. Exact equality is obtained only by an appropriately strict configuration, and exact equality is usually a poor noisy-sensor diagnostic.

### `src/hal/components/wcomp.comp`

Purpose: classify one value against a lower and upper boundary.

Pinned behavior:

- `under = (in <= min)`
- `over = (in >= max)`
- `out = !(under || over)`, therefore `out` means **strictly** inside the window.
- If `max <= min`, behavior is documented in the source as undefined.

Engineering consequence: after forming a channel difference, `wcomp` can express a symmetric or asymmetric acceptable disagreement band, but boundary inclusivity matters. A design that expects “equal to threshold is healthy” will be wrong if it uses `out` directly at that boundary.

### `src/hal/components/sum2.comp`

Purpose: affine combination `out = in0*gain0 + in1*gain1 + offset`.

Representative disagreement use: set `gain0=1`, `gain1=-1`, `offset=0` to produce signed channel error `A-B`, then feed that error to a tolerance component. This preserves sign for diagnostic direction if needed; absolute disagreement requires an additional `abs` stage or symmetric window logic.

### `src/hal/components/maj3.comp`

Purpose: majority vote among three boolean inputs.

Pinned behavior: count true inputs; normal output is true when `sum >= 2`; optional `invert` returns true when fewer than two inputs are true.

Critical limitation: a majority output by itself does **not** tell which channel disagreed, whether the agreeing pair share a common-cause fault, or whether any input is fresh. It can mask one boolean disagreement in the voted output while simultaneously destroying diagnostic information unless separate per-channel comparison/status signals are retained.

### `src/hal/components/timedelay.comp`

Purpose: require an input state to persist for configurable time before the output follows it.

Pinned behavior:

- if input differs from output, an internal timer accumulates `fperiod`;
- a true input must persist for `on-delay` before `out` becomes true;
- a false input must persist for `off-delay` before `out` becomes false;
- when input equals output, timer resets to zero.

Engineering consequence: persistence qualification is based on realtime function execution period and ordering. It can reject short disagreement spikes, but it also intentionally delays detection and recovery; that tradeoff must be explicit rather than hidden under a generic “debounce” label.

## Representative ordinary diagnostic call flow

A two-channel position disagreement monitor can be constructed as:

`sensor A publication` + `sensor B publication`
→ `sum2` configured as `A-B`
→ `abs` or signed bounds
→ `wcomp` / `near` tolerance predicate
→ optional `timedelay` persistence qualifier
→ diagnostic latch/status/ordinary machine-control response.

For source-level reasoning, each arrow is a realtime scheduling boundary determined by `addf` order. Acquisition must execute before comparison if the design intends same-cycle samples; comparison must execute before persistence; persistence/fault logic must execute before a response component if same-cycle response is expected.

## Failure-domain taxonomy

S05 must distinguish at least:

1. **Single-channel numerical drift/jump** — disagreement can expose it if another sufficiently independent channel remains trustworthy.
2. **Single-channel freeze during actual motion** — disagreement can expose it when the other channel changes and the tolerance is exceeded.
3. **Common frozen value while stationary** — agreement alone does not establish freshness; S04 boundary remains.
4. **Common-mode bias/drift** — two channels can agree and still be wrong if they share the same cause/reference/mechanics/data path.
5. **Timing skew** — individually correct channels sampled at meaningfully different times can create apparent disagreement during motion.
6. **Scaling/sign/offset mismatch** — systematic configuration errors can look like sensor disagreement.
7. **One bad input in a 2-of-3 boolean voter** — voted function may remain correct, but the voter output alone does not identify the failed leg.
8. **Two bad/common-cause inputs in a 2-of-3 voter** — majority can confidently produce the wrong result.

## Design rules emerging from source

- Preserve raw per-channel values and per-channel health/freshness information; do not keep only a voted result.
- Separate **agreement tolerance**, **freshness**, and **validity**. They are different predicates.
- Define whether tolerance is absolute, relative, speed-dependent, state-dependent or asymmetric.
- Define threshold boundary semantics (`<`, `<=`, `>`, `>=`) from the actual component used.
- Define persistence as a time/cycle budget and account for the resulting diagnostic latency.
- Audit realtime function order when comparing supposedly same-cycle data.
- State the independence/common-cause assumptions required for any redundancy claim.
- Do not infer safety integrity from channel count or majority voting alone.

## Candidate S05 experiment

A bounded software experiment can verify the stock building-block semantics without pretending to validate a physical redundant sensor architecture.

Proposed fixture: two synthetic float channels A/B plus `sum2` difference, `abs`, `wcomp` or `comp`, and `timedelay`; optionally a three-boolean `maj3` branch.

Predeclare cases before implementation:

1. Equal channels → healthy agreement.
2. Sub-threshold disagreement → healthy.
3. Exact-threshold boundary → classify according to the chosen component's actual strict/inclusive semantics.
4. Sustained over-threshold disagreement shorter than persistence time → no persisted fault.
5. Sustained over-threshold disagreement longer than persistence time → persisted fault.
6. Recovery shorter/longer than off-delay → verify recovery semantics.
7. Three-channel boolean voter with one dissenting input → majority output remains with the pair, while separate disagreement indicator must expose dissent.
8. Common-mode identical wrong value → comparator reports agreement, proving agreement is not correctness/freshness.

The experiment must not claim physical channel independence or safety diagnostic coverage.

## Open questions before experiment freeze

- Use `wcomp` on signed difference or `abs + comp` as the primary numeric oracle? The choice should maximize boundary clarity and observability.
- Should persistence be implemented with stock `timedelay` or a small test-only cycle counter? Prefer stock production component if its semantics match the lesson objective.
- What ordinary response should be demonstrated: diagnostic-only latch, ordinary machine-disable input, or both? A diagnostic-first design may isolate S05 from repeating S04/S01 disable proofs.
- How should sampling skew be represented in one adversarial case without creating an oversized motion simulation? A deterministic one-cycle delayed synthetic channel may be sufficient.

## Safety boundary

This module may demonstrate ordinary LinuxCNC comparisons, voting, persistence and diagnostic responses. It does not establish independence, diagnostic coverage, fault exclusion, safe failure fraction, category, PL, SIL, STO integrity, or validation of any complete safety function. Those claims require architecture- and hardware-specific evidence outside ordinary HAL logic.
