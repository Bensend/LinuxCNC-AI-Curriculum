# PB-PREP-001 P2–P7 runner implementation contract

Status: **IMPLEMENTATION CONTRACT — derived before behavioral execution**

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`
Accepted construction ancestor: `lab-jobs/066-pb-prep-001-rev1-oracle-corrected-preflight.sh`
Behavioral constants: `experiments/PB-PREP-001-behavioral-execution-freeze.md`

This file narrows the frozen behavioral plan into an executable data/control contract. It does not alter any frozen constant, gate, threshold, disturbance, or outcome rule.

## Construction rule

The behavioral runner must be a new job. It may reuse the accepted revision-1 fixture construction, but must not rewrite or relabel the accepted P0/P1 result. Each A/B/C architecture starts in a fresh LinuxCNC process with y1=y2=0 and no P1 seed. The architecture runs P2→P7 continuously; P5 is a parameter restoration, not a state reset.

## Realtime component state

Add explicit realtime-witness outputs to the fixture:

- `phase` s32, values 2..7;
- `e_diff_used` = y1-y2 captured in `prepare()` before the plant update;
- `corr_req`, `corr_applied`;
- `prelimit1`, `prelimit2` before the common final limiter;
- `final1`, `final2` after the common limiter;
- `final1_sat`, `final2_sat`, defined from `abs(prelimit)>U_MAX`;
- `plant_gain2`, `plant_alpha2` as sampled parameters (A-side parameters remain frozen 1.0/0.05);
- stock PID saturation witnesses for sides 1 and 2;
- joint-1 and joint-3 following-error values;
- motion enabled witness;
- deterministic component cycle.

The plant update is side-specific:

`y1_next = y1 + alpha1 * ((gain1 * final1) - y1)`

`y2_next = y2 + alpha2 * ((gain2 * final2) - y2)`

with alpha1=0.05 and gain1=1.0 throughout.

## Architecture equations

A — pre-PID reference bias:

- `pid1_ref = r1 - corr_applied`
- `pid2_ref = r2 + corr_applied`
- `prelimit1 = pid1_out`
- `prelimit2 = pid2_out`

B — post-PID effort correction:

- `pid1_ref=r1`, `pid2_ref=r2`
- `prelimit1 = pid1_out - corr_applied`
- `prelimit2 = pid2_out + corr_applied`

C — explicit common/differential P controller:

- stock PID outputs are retained only as witnesses and do not drive final effort;
- `common = 6 * (((r1-y1)+(r2-y2))/2)`
- `prelimit1 = common - corr_applied`
- `prelimit2 = common + corr_applied`

All use `corr_req = 1.0 * e_diff_used`, `corr_applied=clip(corr_req,0.25)`, and final `clip(prelimit,2.0)`.

## Phase controller

P2: equal plant, command Y 0→0.5 at F30, then retain >=1.0 s at target.

P3: set B gain exactly 0.75; hold >=1.5 s.

P4: restore B gain 1.0 and set B alpha exactly 0.025; hold >=1.5 s.

P5: restore B alpha 0.05; retain >=2.0 s. Do not reset y/controller state.

P6: set B gain exactly 0.20, alpha 0.05; retain >=2.0 s unless motion disables.

P7: set fixture/controller run false without first modifying plant state. Record at least two completed realtime rows after the transition if the process remains alive.

Phase transitions must occur through HAL parameters/pins whose values are recorded in the same realtime stream. Userspace wall-clock timestamps are not phase-boundary evidence.

## Atomic sampler schema

Every retained row must contain, in this logical order (exact HAL pin indices may differ but analyzer schema must be committed with the runner):

1. deterministic cycle
2. phase
3. r1
4. r2
5. y1
6. y2
7. e_diff_used
8. corr_req
9. corr_applied
10. pid1_ref
11. pid2_ref
12. pid1_out
13. pid2_out
14. pid1_saturated
15. pid2_saturated
16. prelimit1
17. prelimit2
18. final1
19. final2
20. final1_sat
21. final2_sat
22. joint1_ferror
23. joint3_ferror
24. motion_enabled
25. plant_gain2
26. plant_alpha2

The sampler producer must execute after the plant/controller finish function in the same servo thread. Producer overruns must be zero. Deterministic cycle must be contiguous over retained behavioral rows. Any schema mismatch, gap, or overrun is HARNESS INVALID.

## Analyzer invariants before metrics

Before computing architecture comparisons, reject the run unless all are true:

1. pinned LinuxCNC provenance matches exactly;
2. each architecture has phases P2..P7 in monotonic order;
3. P2 starts with equal clean y states (within numeric tolerance) and no +0.02 P1 seed;
4. only B-side gain/alpha change at P3/P4/P5/P6, exactly to frozen values;
5. A-side gain/alpha, U_MAX, DIFF_MAX and controller gains do not change;
6. independent joint-1/joint-3 feedback nets remain present;
7. `corr_req == e_diff_used` within 2e-6 and `abs(corr_applied)<=0.25+1e-12`;
8. final efforts equal `clip(prelimit,2.0)` within 1e-12;
9. final-saturation bits agree with `abs(prelimit)>2.0`;
10. zero sampler overruns and zero deterministic-cycle gaps.

## Required adversarial discriminator

For architecture B in P6, search for at least one retained row where downstream correction changes final saturation relative to the stock PID saturation witness. A useful witness is a row where a stock PID output itself is not saturated by its own stock limit state while the post-PID corrected `prelimit` exceeds U_MAX and the corresponding final-saturation bit is true. Preserve the exact row(s).

If no such B/P6 row exists, the frozen experiment is **INCONCLUSIVE**. Do not increase gain disturbance, correction gain, DIFF_MAX, U_MAX, P gain, phase duration, or trajectory under PB-PREP-001 after observing this result.

## P7 oracle

Identify the last cycle with run=true and the first completed realtime cycle with run=false. On that first disabled cycle require:

- final1 == final2 == 0 within 1e-12;
- final1_sat == final2_sat == false.

Also report correction/controller state rather than silently assuming reset semantics.

## Metrics

Apply the already-frozen windows only: all-sample transient/peak per phase; final 500 ms steady windows for eligible P2/P3/P4 phases; P5 100-ms continuous recovery bands (`abs(e_diff)<=0.005`, `abs(e_common)<=0.01`); exact 1-ms saturation durations; payload-cycle event deltas. Missing events are `NOT OBSERVED`.

## Evidence boundary

This is a dimensionless software comparison of insertion architectures. It cannot establish hydraulic stability, valve-current requirements, ram parallelism tolerance, stopping distance, pressure behavior, or functional-safety suitability. LinuxCNC motion disable/ferror is a software observation only.

## Next executable step

Implement `lab-jobs/067-pb-prep-001-p2-p7-behavioral.sh` against this contract and the frozen parent plan, then run it once. The first behavioral result is scored without parameter edits. Preserve raw A/B/C traces, analyzer source, HAL topology, component source, pinned-source provenance, and exact workflow/job runtime.
