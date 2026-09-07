# S05 — disagreement, persistence, and 2-of-3 voting call flows

- Module: S05
- Course level: 1000
- LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`
- Evidence class: SOURCE-CONFIRMED unless otherwise marked

## Representative two-channel numeric monitor

Primary 1000-level pattern:

`sensor/publication A` + `sensor/publication B`
→ `sum2` configured `gain0=+1`, `gain1=-1`, `offset=0`
→ signed disagreement `d=A-B`
→ `wcomp` with `min=-T`, `max=+T`
→ `or2(wcomp.under,wcomp.over)` to produce raw disagreement fault
→ `timedelay` to qualify persistence
→ diagnostic/status or ordinary control response.

### Boundary semantics

At the pinned revision, `wcomp` computes:

- `under = (d <= min)`
- `over = (d >= max)`
- `out = !(under || over)`

Therefore with symmetric bounds `[-T,+T]`, `out` means strictly `-T < d < +T`. Exact `d=-T` or `d=+T` is outside/at-boundary and asserts `under` or `over` respectively. For this lesson, raw fault is `under OR over`, i.e. `|d| >= T` for symmetric valid bounds.

This is clearer than `abs + comp` for S05 because it preserves disagreement sign (`under` versus `over`) while making exact-threshold behavior observable without a second numerical transformation.

### Persistence path

`timedelay` compares its boolean input with its current output. While they differ, it adds the realtime function's `fperiod` to an internal timer. It changes output when the relevant delay is reached or exceeded; when input equals output the timer is reset.

For raw disagreement fault input:

- `on-delay` is the minimum persistence needed before the persisted diagnostic asserts;
- `off-delay` is the minimum healthy persistence needed before the persisted diagnostic clears.

This intentionally adds both detection and recovery latency. `elapsed` is observable but must not be mistaken for an independent wall-clock safety timer.

### Realtime ordering

For same-cycle intent, function order is part of the design:

1. acquisition/publication functions;
2. `sum2` difference;
3. `wcomp` threshold classification;
4. `or2` raw fault construction;
5. `timedelay` persistence;
6. any diagnostic latch/ordinary response;
7. sampler/observer last when same-cycle visibility is required.

If channel B is published one servo cycle later than channel A, the comparison can legitimately see A(k) against B(k-1). During motion with slope `v`, a one-period skew `Ts` produces an apparent disagreement approximately `v*Ts` even when both sensors are individually accurate. The monitor therefore needs a timing/alignment assumption in addition to a numerical tolerance.

## Three-channel boolean voter

Pinned `maj3` call flow is deliberately small:

`in1,in2,in3` → count true inputs → normal `out=(sum>=2)`; with `invert`, `out=(sum<2)`.

Consequences:

- one dissenting input can be masked in the voted output;
- the voter itself exposes no dissent identity;
- two equal/common-cause bad inputs can outvote one correct input;
- voter agreement says nothing about freshness;
- retaining raw inputs and separate pairwise/disagreement diagnostics is required if dissent information matters.

Representative diagnostics should therefore be conceptually parallel to voting, not replaced by it:

`raw in1,in2,in3` → `maj3` functional vote

and separately

`raw inputs` → pairwise/dissent diagnostics → status/maintenance evidence.

## Representative failure paths

### Single numerical drift

One channel moves outside `[-T,+T]` relative to the other → `wcomp.under/over` asserts → raw fault asserts → if sustained for `on-delay`, persisted diagnostic asserts. This detects disagreement only under the assumption that the other channel is sufficiently trustworthy for the intended diagnostic purpose.

### Common-mode wrong agreement

A and B move together to the same wrong value → `d=0` → `wcomp.out=TRUE` → raw disagreement fault remains false. This is expected behavior, not a comparator defect. Agreement is not correctness, freshness, or independence.

### Timing skew

Correct channels sampled at different instants can exceed the numeric threshold during sufficiently fast motion. The comparator cannot distinguish skew from physical disagreement because it receives values, not provenance/time alignment.

### Voter common cause

Two wrong boolean channels agree against one correct channel → `maj3` returns the wrong majority with no intrinsic warning. A 2-of-3 vote is therefore not proof of fault tolerance unless independence, failure modes, diagnostics, and architecture are established separately.

## Safety boundary

These are ordinary realtime HAL signal-processing patterns. They do not establish PL/SIL/category, diagnostic coverage, channel independence, fault exclusion, safe stopping performance, or any complete safety function.
