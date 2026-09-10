# PB-PREP-001 — behavioral execution freeze

Status: **FROZEN BEFORE P2-P7 EXECUTION**

Date frozen: 2026-09-10

Parent contract: `experiments/PB-PREP-001-y1y2-insertion-comparison-plan.md`

This document fills the parent contract's intentionally deferred software-fixture constants after P0/P1 preflight validation and before any P2-P7 comparative result is observed. It does not change the parent hypotheses, Gates A-J, outcome classifications, or physical-machine limitations.

## Inherited validated construction

- LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`
- servo period: 1 ms
- accepted P0/P1 construction: revision 1 (`SYNC_GAIN=1.0`), post-home sign seed, causal `e_diff_used` witness
- baseline plant update: `y_next = y + alpha * ((gain * u_final) - y)`
- baseline `alpha=0.05`
- baseline side gains: `gain1=gain2=1.0`
- `U_MAX=2.0`
- `DIFF_MAX=0.25`
- A/B stock P-only controller: `Pgain=6.0`, I/D/FF=0
- C baseline common P gain: 6.0
- common duplicated-Y motion: absolute move from Y=0 to Y=0.5 at F30, preserving the preflight's nontrivial command profile
- X/Z remain ideal loopback support joints
- Y1/Y2 remain independent synthetic feedback inputs to joints 1 and 3

The +0.02 post-home seed is a P1 sign-test device only. P2 begins from a clean reset with equal baseline side states.

## Phase schedule and disturbances

Each architecture starts from a clean process/realtime reset and executes the same phase schedule. Phase changes must be retained atomically in the realtime stream. No controller gain, command limit, differential-authority limit, trajectory, recorder configuration, or A-side plant parameter may change between architectures.

### P2 — identical-plant common move

- `gainA=1.0`, `gainB=1.0`
- `alphaA=0.05`, `alphaB=0.05`
- command Y: 0 -> 0.5 at F30
- retain at least 1.0 s after reaching the target before entering P3

### P3 — moderate B-side gain reduction

Freeze `G_B_MODERATE=0.75`.

- `gainA=1.0`, `gainB=0.75`
- both alphas 0.05
- hold the common Y=0.5 target for at least 1.5 s after the parameter transition

This 25% software gain asymmetry is intentionally moderate: it is large enough to create a differential-control demand while remaining well inside the dimensionless baseline model's gross authority envelope. It is not claimed to model any particular hydraulic mismatch.

### P4 — moderate B-side added lag

Restore B gain to 1.0. Freeze `LAG_B_MODERATE` as `alphaB=0.025` while `alphaA=0.05`.

Because the retained plant is a first-order discrete response, smaller alpha is the fixture's explicit lag/response-time parameter. Halving alpha changes only B-side response rate; it does not change controller constants or final limits. Hold the common target/profile for at least 1.5 s after the transition.

### P5 — recovery

Restore `gainB=1.0`, `alphaB=0.05`. Retain at least 2.0 s of recovery evidence before P6. Recovery metrics use this phase boundary; no state may be silently reinitialized at P5.

### P6 — authority exhaustion discriminator

Freeze the strong B-side disturbance as `gainB=0.20`, with `gainA=1.0`, both alphas 0.05, common target Y=0.5, `DIFF_MAX=0.25`, and `U_MAX=2.0`. Retain at least 2.0 s unless LinuxCNC motion disables earlier.

The intended discriminator is **not** 'must pass'. It is: exercise differential authority strongly enough that clipping/final saturation has a realistic opportunity to occur under the already frozen limits. In particular, architecture B must show an interval where downstream correction causes final saturation to differ from stock PID saturation for Gate H, otherwise the behavioral comparison is classified **INCONCLUSIVE** rather than retuned after inspection.

If this frozen P6 disturbance does not exercise the discriminator, do not increase it in the same experiment ID after seeing results.

### P7 — disable/reset

Command ordinary controller/fixture run enable false without changing plant state first. Required invariant: both final commands become exactly 0.0 on the first completed realtime cycle after disable (within numeric representation tolerance of `1e-12`), final-saturation flags clear, and architecture-specific correction/integrator state either resets to its declared disabled state or is explicitly retained as a witnessed implementation property. No re-enable is required for acceptance.

## Recorder and evidence freeze

The behavioral stream must extend the accepted atomic sampler rather than substitute userspace polling. At minimum retain, same cycle:

- phase and deterministic payload cycle;
- r1/r2 and independent y1/y2;
- `e_diff_used`, requested and applied differential correction;
- A/B stock PID references, outputs and PID saturation witnesses;
- pre-limit side efforts;
- final side efforts and final saturation flags;
- joint 1/3 motion following error and effective limits / exposed flags;
- global motion enabled state;
- current B-side gain and alpha, so disturbance isolation is directly witnessed.

Producer overruns must be zero and deterministic payload-cycle continuity gap-free. A recorder failure invalidates behavioral interpretation.

## Metric windows

To prevent favorable post-hoc window selection:

- transient/peak metrics: all retained samples in each phase after its phase-transition row;
- steady metrics: final 500 ms of P2, P3, and P4, provided the phase contains at least 750 ms; otherwise mark the metric unavailable and the relevant comparison incomplete;
- P5 recovery bands: return to `abs(e_diff) <= 0.005` and `abs(e_common) <= 0.01`, continuously for 100 ms. If never achieved, report `NOT OBSERVED` rather than changing bands;
- saturation/clipping durations: exact count of 1 ms samples and converted milliseconds;
- event timing: payload-cycle differences only; report `NOT OBSERVED` if an event never occurs.

These bands are software-fixture analysis thresholds only and are not press-brake tolerances.

## Adversarial execution rules

1. A common-axis trajectory that appears correct cannot substitute for independent Y1/Y2 evidence.
2. A/B stock PID `saturated` cannot substitute for final-command saturation.
3. P6 not exercising architecture B's downstream-only saturation discriminator yields INCONCLUSIVE, not a weaker threshold or stronger rerun under this experiment ID.
4. Motion ferror/disable is an observed LinuxCNC software response, not a functional-safety proof.
5. No result can be translated into valve current, cylinder velocity, tonnage, stopping distance, or real hydraulic tuning without separate machine-specific evidence.

## Next implementation checkpoint

Create a **new** P2-P7 runner rather than modifying the accepted preflight result in place. The runner must preserve the validated P0/P1 construction and execute the constants above from clean resets for A/B/C. Run it once as the frozen behavioral experiment, retain all raw traces/analyzer code/provenance, score Gates A-J without threshold edits, and only then decide whether PB-PREP-001 is VALID COMPARISON, PARTIAL VALID, INCONCLUSIVE, HARNESS INVALID, or BEHAVIORAL FAILURE.
