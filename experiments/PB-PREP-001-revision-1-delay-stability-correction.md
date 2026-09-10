# PB-PREP-001 revision 1 — delay-stability correction

Status: **FROZEN BEFORE EXECUTION**

This is a material construction correction to the software-only PB-PREP-001 preflight. It does not rank A/B/C and makes no claim about physical hydraulic suitability, machine safety, or functional-safety integrity.

## Why the original frozen gain is invalid for the realized Architecture-A fixture

Run 063 (`34539150626`) finally established the intended topology cleanly: the synthetic Y sides remained equal through homing, `pb-prep.0.run` was asserted only after all four joints reported homed, the causal sign witness was present, the retained payload had 2,500 contiguous rows, and duplicated nominal Y requests were identical (`max-r1-r2=0`) over a 0.4495-unit common move. The run then failed the unchanged side-separation gate with `max-y1-y2=0.193938` (>0.08).

The retained realtime trace shows a repeating alternating differential response. At sample/cycle pairs around 390–395, the Architecture-A PID effort is consistent with the previous cycle's corrected reference and feedback rather than the same retained row's newly published correction. This means the realized loop contains a one-servo-period differential delay that the initial hand calculation omitted.

Let `x_n = y1-y2` after the plant update, `P=6`, `alpha=0.05`, and Architecture-A reference bias `c=K*x`. Ignoring clipping for the local linear analysis, the observed one-cycle delayed reference produces approximately:

`x_n = (1-alpha-alpha*P) x_(n-1) - 2*alpha*P*K x_(n-2)`

With the original `K=2` this becomes:

`x_n = 0.65 x_(n-1) - 1.20 x_(n-2)`

The characteristic-root product is `1.20`; its complex-conjugate root magnitude is therefore `sqrt(1.20) ~= 1.095`, so local differential growth is expected rather than surprising. The retained trace is consistent with that prediction: the sign alternates while magnitude grows until clipping participates.

This is a fixture/control-law timing discovery, not evidence about a real press-brake hydraulic plant.

## Frozen revision

For the next P0/P1-only preflight:

- retain pinned LinuxCNC `8bf4605ae81042248add031e94c77300406e0413`;
- retain servo period 1 ms;
- retain P gain 6.0 for A/B and common-controller P gain 6.0 for C;
- retain `PLANT_ALPHA=0.05`, equal plant gains 1.0, `U_MAX=2.0`, `DIFF_MAX=0.25`, and post-home `INITIAL_DELTA=0.02`;
- retain the post-home enable ordering proven by run 063;
- retain the causal `e_diff_used` witness and exact sampler/continuity checks;
- change **only `SYNC_GAIN` from 2.0 to 1.0**.

For Architecture A the same local delayed model then has characteristic-root product `0.60`, giving complex-root magnitude `sqrt(0.60) ~= 0.775`; it is therefore a deliberately conservative software-fixture gain expected to decay rather than grow. This is an analytical preflight choice only, not physical tuning guidance.

All existing P0/P1 validity gates remain unchanged, including:

- causal correction-sign test;
- duplicated common nominal requests `max-r1-r2 <= 1e-9`;
- common-request span >= 0.1;
- max synthetic side separation <= 0.08;
- 2,500 retained contiguous realtime rows per architecture;
- zero recorder overruns/gaps;
- independent side feedback wiring;
- no P2–P7 comparative scoring in preflight.

If revision 1 still fails a frozen gate, do not tune another parameter opportunistically. Preserve the failure and re-derive the mechanism from retained evidence.

## Adversarial checks before promotion

A passing workflow is insufficient by itself. Before calling the preflight valid, independently verify that (1) the retained predeclared model says `SYNC_GAIN=1.0`, (2) `max-r1-r2` remains zero/non-different during common motion, (3) the +0.02 seed is injected after homing rather than encoded into motor offsets, (4) the causal sign relationship is correct for A, B, and C, and (5) each architecture's recorder-health and payload-cycle continuity pass.

## Next checkpoint

Execute one clean-lineage revision-1 P0/P1 preflight. If and only if all unchanged gates pass for A/B/C, freeze a separate authoritative P2–P7 comparative job; do not reuse the preflight as comparative evidence.
