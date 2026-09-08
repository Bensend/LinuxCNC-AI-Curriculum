# C03-025 accepted result — explicit relative-feedback cross-coupling

Status: **PASS / TEST-CONFIRMED, frozen Gates A–H**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`.

Authoritative accepted run:

- workflow: `34228231147`
- job: `102067547546`
- artifact: `10056799485`
- source curriculum commit: `99f7c35ce3cfd23aa96c11f0168c798ff8607c7c`
- inner lab exit: `0`

Attempts 1 and 2 remain preserved as HARNESS INVALID in their reconciliation files. No frozen behavioral threshold or control parameter was weakened. Attempt 3 changed only test phase publication: configuration mutations occur under unscored phase 0, with 20 ms pre/post settling before a decisive phase label is published.

## Decisive evidence

```text
sampler-overruns=0
realtime-samples=11199
phase-2-samples=3013
phase-3-samples=3013
phase-4-samples=3012
command-span=9.133

U = phase-2 last500 mean abs separation = 0.703374228 in
X = phase-3 last500 mean abs separation = 0.377045040 in
R = phase-4 last500 mean abs separation = 0.738476396 in

X/U = 0.536051827023
R/X = 1.95858933988

phase-3 A-ahead qualified rows=3013
direction-correct rows=3013
max abs realtime residual C - 0.5D = 0
max abs realtime residual cmdA - base - C = 0
max abs realtime residual cmdB - base + C = 0
phase-4 max abs correction last500 = 0

gate-B=PASS
gate-C=PASS
gate-D=PASS
gate-E=PASS
gate-F=PASS
gate-G=PASS
gate-H=PASS
C03-025 overall=PASS
```

The coupled phase reduced sustained simulated A/B disagreement by about **46.4%** relative to the uncoupled disturbed phase (`X/U ~= 0.536`), exceeding frozen Gate F's required 25% reduction. Removing the coupler caused disagreement to rebound to about **1.96x** the coupled value, satisfying Gate G. All 3013 phase-3 rows in which A was ahead by >0.05 in had the required correction direction, and the realtime arithmetic residuals were exactly zero at the sampled precision.

Retained raw realtime evidence was reported as 11,199 lines / 1,695,584 bytes with SHA-256 `ed3f43ba6fb9803a9b491900aab836948e91477cf306070e1106f998fd68075d`.

## Source reconciliation

Pinned `sum2.comp` has no hidden state: it evaluates `in0*gain0 + in1*gain1 + offset`. Pinned `scale.comp` evaluates `in*gain + offset`. In the accepted topology that means:

```text
D = feedback_B - feedback_A
C = 0.5 * D
command_A = base + C
command_B = base - C
```

The runtime sign and exact-arithmetic evidence matches those source equations. The experiment therefore confirms the behavior of this explicit topology in the pinned deterministic simulation; it does not imply hidden LinuxCNC synchronization behavior.

## Safety / transfer boundary

Accepted conclusion:

```text
in this pinned toy two-loop simulation,
explicit symmetric relative-feedback cross-coupling at Kc=0.5
materially reduced sustained feedback disagreement under the frozen B-only slowdown
and the effect reversed when the coupler was removed.
```

Forbidden promotion:

```text
reduced simulated disagreement
!= proven physical alignment
!= proven stability across gains, delays, saturation, loads or faults
!= validated hydraulic/mechanical press-brake synchronization law
!= safety-rated anti-racking protection
```

A real press brake still requires independent treatment of encoder plausibility, asymmetric hydraulic dynamics, pressure/load transfer, correction/output saturation, stopping/fault policy, homing/squaring, mechanical compliance and safety-rated architecture.

## State transition

C03 may advance from EXPERIMENT/CORRECTIONS to **EXAM**. Graduation still requires scoring the already-frozen adversarial exam, a fresh-AI novel-scenario handoff, and the promotion/counterfactual audit required by `START_HERE.md`.
