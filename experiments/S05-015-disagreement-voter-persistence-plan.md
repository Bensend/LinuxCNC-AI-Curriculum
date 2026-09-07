# S05-015 — disagreement, persistence, and 2-of-3 voter experiment plan

- Module: S05
- Course level: 1000
- Status: PREDECLARED / immutable acceptance gates before implementation
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Environment: hosted userspace LinuxCNC/HAL software laboratory

## Objective

Independently verify the stock HAL semantics used by the S05 monitoring pattern without claiming physical sensor independence or safety diagnostic coverage.

Primary numeric path:

`sum2(A-B)` → `wcomp(min=-0.125,max=+0.125)` → `or2(under,over)` raw fault → `timedelay(on-delay=0.050,off-delay=0.030)` persisted fault.

Boolean path:

`maj3(in1,in2,in3)` plus direct observation of all raw inputs.

Thread period target: `10 ms` floating-point realtime thread. Function order shall be `sum2` → `wcomp` → `or2` → `timedelay` → `maj3`; observers run after the production components.

Binary-exact values are chosen for the threshold tests so the exact-boundary prediction is not contaminated by decimal floating-point representation ambiguity.

## Predeclared predictions and gates

### Gate A — equal values

Set `A=1.0`, `B=1.0`.

Prediction: difference `0`, `wcomp.out=TRUE`, `under=FALSE`, `over=FALSE`, raw fault `FALSE`, persisted fault `FALSE`.

### Gate B — sub-threshold disagreement

Set `A=1.0`, `B=1.0625` (`A-B=-0.0625`).

Prediction: still strictly inside `(-0.125,+0.125)`, so raw and persisted faults remain false.

### Gate C — exact-threshold boundary

Set `A=1.0`, `B=1.125` (`A-B=-0.125` exactly in binary arithmetic).

Prediction: `wcomp.under=TRUE`, `wcomp.out=FALSE`, raw fault `TRUE`. Because this gate is observed before the 50 ms on-delay expires, persisted fault must remain `FALSE`.

This gate verifies that the threshold boundary itself belongs to the fault region for this chosen `wcomp` construction.

### Gate D — short excursion rejected by persistence

Hold the exact-threshold/raw-fault state for less than `0.050 s` total and sample before the on-delay can expire.

Prediction: raw fault remains true; persisted fault remains false.

The implementation must leave adequate timing margin; it must not use a sleep duration close enough to 50 ms that scheduler phase can make the test ambiguous.

### Gate E — sustained excursion accepted

Continue the same raw fault long enough to exceed `0.050 s` total persistence.

Prediction: persisted fault becomes true.

### Gate F — short healthy recovery does not clear

Return to `A=B=1.0`, hold healthy state for less than `0.030 s` with adequate margin.

Prediction: raw fault false; persisted fault remains true.

### Gate G — sustained healthy recovery clears

Continue healthy state beyond `0.030 s` total.

Prediction: persisted fault becomes false.

### Gate H — one dissenting voter leg is masked by majority

Set `maj3 = (TRUE, TRUE, FALSE)`.

Prediction: voter output `TRUE` while raw input 3 remains visibly false. Then set `(FALSE, FALSE, TRUE)` and predict voter output `FALSE` while raw input 3 remains true.

This demonstrates that voter output alone neither identifies dissent nor establishes which leg is correct.

### Gate I — common-mode equal wrong value still reports agreement

Set numeric channels `A=42.0`, `B=42.0`.

Prediction: difference zero and comparator reports healthy agreement. The lab shall explicitly label `42.0` as an arbitrary designated-wrong synthetic value only for the logical demonstration; the comparator has no independent truth reference and therefore cannot know it is wrong.

### Gate J — scheduling/order evidence

Capture `halcmd show thread` / `show funct` and require the intended order to be visible. This is evidence of the fixture's comparison/persistence ordering, not a universal guarantee for user configurations.

## Timing-skew adversarial analysis (not a physical-sensor lab claim)

A deterministic analytical case accompanies the runtime experiment:

- servo period `Ts = 0.010 s`;
- two individually exact measurements of the same linearly moving quantity at velocity `v = 20 units/s`;
- channel A is current sample `x(k)` and channel B is one cycle old `x(k-1)`.

Then apparent disagreement is `v*Ts = 0.200 units`, which exceeds the experiment threshold `T=0.125` even though neither numerical measurement is inaccurate at its own sample instant.

This establishes why a redundancy monitor needs a time-alignment/freshness assumption. It does not establish any particular hardware's sampling skew.

## Acceptance

PASS requires Gates A–J to match the predeclared predictions and the runtime to exit 0. The timing-skew arithmetic must be preserved as an adversarial reasoning artifact regardless of runtime result.

Any HAL topology/startup failure is HARNESS INVALID, not evidence against S05. Do not change these behavioral gates after seeing the result. If a gate exposes an incorrect source interpretation, record the discrepancy and correct the teaching rather than editing the gate retroactively.

## Explicit non-claims

Even on PASS, this experiment does not validate sensor independence, cable independence, controller redundancy, diagnostic coverage, PL/SIL/category, fault exclusion, safe stopping performance, STO, or a complete safety function.
