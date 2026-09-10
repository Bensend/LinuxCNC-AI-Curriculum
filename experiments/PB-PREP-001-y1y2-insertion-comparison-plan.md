# PB-PREP-001 — Y1/Y2 differential-control insertion comparison

Status: **FROZEN DESIGN / NOT YET EXECUTED**

Date frozen: 2026-09-10

Purpose: dependency-safe specialization preparation. This experiment does **not** activate F02, satisfy any pending fresh-AI handoff, or prescribe physical press-brake hydraulics.

Pinned LinuxCNC target revision: `8bf4605ae81042248add031e94c77300406e0413`.

## Question

Under one identical software-only two-side plant and identical disturbances, how do three explicit synchronization insertion architectures differ in:

- differential tracking;
- motion-level per-joint following error;
- controller/final-command saturation visibility;
- recovery after asymmetry;
- behavior when differential authority is insufficient?

Architectures:

- **A — pre-PID reference bias:** a bounded equal/opposite position correction is added to each side's PID reference while LinuxCNC motion's nominal duplicated joint commands remain unchanged.
- **B — post-PID effort correction:** stock independent PIDs use unmodified motion references; a bounded equal/opposite effort correction is added after PID output and then passes through an explicit final per-side limiter.
- **C — explicit two-channel controller:** one custom realtime controller consumes both nominal targets and both feedbacks and owns common/differential control plus the final per-side output limiter.

## Predeclared hypotheses

H1. All three architectures can reduce Y1-Y2 differential error under a moderate one-side plant asymmetry when sufficient correction authority remains.

H2. Architecture A will make intentional differential reference bias visible to LinuxCNC motion as part of the affected joint's absolute following error because motion compares its unmodified joint target with returned joint feedback.

H3. Architecture B can have final hardware-command saturation while the stock PID's own `saturated` witness remains false because the extra correction and final clip occur downstream of the PID.

H4. Architecture C can expose final side saturation and common/differential authority consistently because the same controller owns the allocation and final limits, but this is an observability/control-structure advantage only if its behavior is otherwise equivalent or better under the frozen plant.

H5. No architecture should be declared physically suitable or safety-rated from this experiment.

These hypotheses are frozen before implementation/result inspection.

## Evidence prerequisites

The implementation must preserve and cite:

- duplicate-coordinate command fanout source at pinned `trivkins`/`kins_util.c`;
- per-joint `motor-pos-fb` and motion following-error source in `control.c`;
- per-instance stock PID state/saturation behavior in `pid.c`;
- an explicit servo-thread order;
- X01 recorder-health rule: producer overrun/full evidence plus deterministic payload-cycle continuity; consumer sequence continuity alone is insufficient.

If any prerequisite cannot be established in the actual fixture, classify the run **HARNESS INVALID** and take no architecture verdict.

## Software plant

Use a deterministic realtime synthetic plant for each side. Both sides receive final command `uN` and publish position feedback `yN` in the same servo thread.

The plant must expose at minimum:

- command gain;
- first-order response/lag parameter;
- position state;
- optional bounded velocity state if needed by the chosen implementation;
- a deterministic reset input.

The exact discrete update equation must be written into the retained source before execution. The two sides must be mathematically identical in baseline phases. Disturbances may alter only the explicitly named B-side parameter(s).

The plant is intentionally dimensionless/generic. Do not label its constants as real hydraulic valve/cylinder values.

## Common controller quantities

Let the duplicated motion targets be `r1` and `r2`; under coordinated Y motion they should be equal within the frozen numerical tolerance. Let feedback be `y1`, `y2`.

Define retained witnesses:

```text
r_common = (r1 + r2)/2
y_common = (y1 + y2)/2
e_common = r_common - y_common

e_diff = y1 - y2
```

For architectures using symmetric differential correction, positive correction convention must be fixed in retained source and validated with one sign-test phase before behavioral scoring.

## Final command limits

All architectures must use the same final per-side absolute command limit `U_MAX`.

Retain separately for every side:

- pre-limit effort;
- final limited effort;
- final saturation boolean;
- stock PID output and stock PID `saturated` when stock PID is used;
- differential correction requested;
- differential correction actually applied.

Do not infer final actuator saturation from stock PID saturation alone.

## Motion following-error policy

Use the same `[JOINT_N]` `FERROR`, `MIN_FERROR`, velocity limit and motion trajectory across A/B/C. Retain:

- `joint.Y1.f-error`;
- `joint.Y2.f-error`;
- corresponding ferror limits;
- per-joint ferror flags if exposed;
- global motion-enabled state.

Choose experiment magnitudes so the moderate-asymmetry comparison can complete below the motion trip threshold. A separate authority-exhaustion phase may intentionally approach or cross the threshold, but its intended outcome must be frozen before that run.

## Realtime ordering

Target one 1 ms servo thread. Required conceptual order:

1. synthetic hardware/read stage makes current `y1/y2` available;
2. `motion-command-handler`;
3. `motion-controller`;
4. architecture-specific correction/controller calculations;
5. final per-side plant command capture / plant update according to the frozen plant timing model;
6. atomic sampler last.

If the plant update is modeled as the hardware response for the *next* servo cycle, document that explicitly. Do not interpret one-row command/feedback relationships as simultaneous algebraic plant equations when state is updated sequentially.

The exact `addf` order must be retained as evidence and must not change between A/B/C except for the named architecture-specific function substitution.

## Fixture topology

Use a four-joint duplicated-Y LinuxCNC simulation analogous to accepted C01/C02 evidence:

`trivkins coordinates=XYZY kinstype=BOTH`

The two Y joints are the compared sides. X/Z may be ideal loopback support joints. Both Y `joint.N.motor-pos-fb` inputs must come from the corresponding synthetic plant feedback rather than ideal command loopback during scored phases.

A run is invalid if the two Y motion feedback inputs are accidentally tied together or if Cartesian Y is substituted for either side's independent feedback.

## Architecture definitions

### A — pre-PID reference bias

Frozen structural requirement:

```text
pid1_ref = r1 + d1
pid2_ref = r2 + d2
```

where the synchronization law produces equal/opposite bounded biases (`d1 = -d2` within numeric tolerance) from `e_diff`.

Final effort is stock PID output passed through the common final limiter. Stock PID and final limiter saturation must both be retained even if normally identical here.

### B — post-PID effort correction

Frozen structural requirement:

```text
pid1_ref = r1
pid2_ref = r2
prelimit_u1 = pid1_output + du1
prelimit_u2 = pid2_output + du2
```

with equal/opposite bounded synchronization effort (`du1 = -du2` within tolerance). Apply the common final limiter after summing.

### C — explicit two-channel controller

The custom realtime controller must calculate both outputs in one function invocation from a coherent same-cycle input snapshot. It must expose separate common and differential requested terms, final side commands, and side saturation state.

To keep the comparison bounded, its baseline common-mode control law should match the stock PID's selected P/I/D/FF behavior as closely as practical; any intentional difference must be documented before scoring. Do not give C an unbounded or materially stronger controller merely to make it win.

## Frozen phases

Each architecture must execute the same phases from a clean reset. The phase ID is sampled atomically with all behavioral signals.

### P0 — provenance/topology/preflight

Verify pinned checkout, binaries/modules from pinned tree, duplicate-Y topology, independent Y feedback nets, expected functions, exact thread order, sampler attachment, zero pre-existing FIFO depth, and deterministic plant/controller reset.

No behavioral gates score if P0 fails.

### P1 — sign and baseline sanity

Small common Y move with identical plants, synchronization gain active. Require correct response direction and low side-to-side separation. This validates correction sign; a sign failure is HARNESS/IMPLEMENTATION INVALID, not evidence that the architecture is unstable.

### P2 — common move, identical plants

Execute a nontrivial common Y move. Establish baseline common/differential error, final effort, and saturation state.

### P3 — moderate B-side gain reduction

Reduce only B-side plant gain to frozen value `G_B_MODERATE` while maintaining common target motion. Synchronization remains enabled.

Primary comparison phase.

### P4 — moderate B-side added lag

Restore gain, increase only B-side lag/response-time parameter to frozen `LAG_B_MODERATE`. Continue identical common-target profile.

### P5 — recovery

Restore identical plants and retain enough samples for settling/recovery metrics.

### P6 — authority exhaustion

Apply a stronger B-side disturbance selected before execution so required differential action approaches/exceeds the same frozen differential-authority bound. Observe final saturation allocation, motion ferror, and any fault/disable transition. Do not change controller gains or limits within the phase.

### P7 — disable/reset behavior

Remove ordinary controller enable, verify both final commands reach the frozen disabled value (normally zero in this synthetic fixture), and verify controller integrator/differential state reset semantics from retained state witnesses. Re-enable only if the frozen implementation explicitly defines safe test reset behavior.

## Frozen metrics

For P2–P6 calculate per architecture:

- peak `abs(e_diff)`;
- RMS `e_diff`;
- steady-window mean and max `abs(e_diff)`;
- peak `abs(e_common)`;
- steady-window mean and max `abs(e_common)`;
- peak absolute motion ferror for each Y joint;
- minimum margin from each motion ferror limit;
- count/duration of stock PID saturation per side where applicable;
- count/duration of **final-command** saturation per side;
- maximum difference between stock PID saturation and final saturation witnesses;
- requested vs applied differential correction and clipped duration;
- recovery time to frozen differential/common error bands after P5 begins;
- samples from first P6 final saturation to any per-joint ferror assertion and to global motion-disable observation, if those events occur.

Do not invent event timing when the event does not occur; report `NOT OBSERVED`.

## Frozen acceptance / interpretation gates

These gates test evidence quality and discriminating behavior, not which architecture is "best."

### Gate A — provenance

Pinned LinuxCNC SHA, fixture source SHAs, generated HAL/INI, architecture identifier, controller constants, plant constants, and final limits retained.

### Gate B — independent side truth

Sampler directly contains Y1 and Y2 plant feedback plus both motion `motor-pos-fb`/joint feedback witnesses needed to prove they are not silently aliased.

### Gate C — common nominal request

During scored coordinated-motion windows, duplicated motion Y targets match within frozen `1e-9` tolerance and span a nontrivial range.

### Gate D — recorder integrity

Atomic realtime record count meets the frozen minimum; producer overruns are zero for authoritative acceptance; deterministic payload-cycle sequence has no gaps. Stream tag continuity may be retained but cannot by itself prove no producer loss.

### Gate E — disturbance isolation

Only the intended B-side plant parameter changes in P3/P4/P6; all controller constants, A-side plant constants, trajectory and limits remain frozen.

### Gate F — saturation observability

Pre-limit and final command plus final saturation are retained for both sides. Architectures A/B additionally retain stock PID output/saturation. This gate fails if the experiment cannot distinguish PID saturation from downstream final saturation.

### Gate G — motion-ferror observability

Both Y motion ferrors and their effective limits are retained in the same atomic stream as correction/final command state.

### Gate H — architecture-specific discriminator

- A: demonstrate whether nonzero reference bias consumes motion ferror margin, with sign/magnitude relationship reported rather than assumed.
- B: deliberately include at least one P6 interval where downstream correction can make final saturation differ from stock PID saturation, or report that the frozen disturbance failed to exercise the discriminator and classify the comparison **INCONCLUSIVE**, not PASS.
- C: demonstrate that requested common/differential effort and final saturation allocation are simultaneously observable from the controller's own state.

### Gate I — recovery/disable

P5 recovery metrics and P7 disabled final-command/reset behavior are retained and meet the frozen implementation's predeclared invariants.

### Gate J — bounded conclusion

Result explicitly separates software-fixture conclusions from physical hydraulic suitability and functional safety. No architecture receives a physical-machine recommendation from this experiment alone.

## Outcome classifications

- **VALID COMPARISON:** A–J pass and all three architectures execute the identical frozen disturbance/measurement contract.
- **PARTIAL VALID:** evidence is valid for one or two architectures but cross-architecture comparison is incomplete; preserve useful evidence without ranking.
- **INCONCLUSIVE:** fixture valid but a frozen discriminator was not actually exercised (for example B never encounters downstream-only final saturation).
- **HARNESS INVALID:** provenance, topology, realtime observation, recorder integrity, or implementation contract invalidates behavioral interpretation.
- **BEHAVIORAL FAILURE:** only after harness validity is established; architecture violates a frozen behavioral invariant.

Do not weaken thresholds or change disturbances after seeing comparative results. A materially redesigned experiment starts a new experiment ID.

## Adversarial checks to score after execution

1. Can final actuator saturation occur while `pid.N.saturated` is false? Which architecture permits that and what retained signal proves it?
2. Can Y1/Y2 remain mutually aligned while both are wrong relative to the LinuxCNC nominal trajectory? Which witnesses catch this?
3. Can a reference-bias corrector reduce `e_diff` while increasing one joint's motion ferror? Prove from same-cycle rows.
4. If Cartesian Y looks correct while duplicate-side feedback is wrong, why is that not evidence of acceptable tandem state?
5. If one feedback freezes but remains numerically plausible, which validity/freshness mechanism is required beyond this experiment?
6. What state must be reset or bounded after output saturation before ordinary authority is restored?
7. Which findings are source/test-confirmed software behavior versus unverified hydraulic inference?

## Implementation checkpoint

Next work is to implement a **preflight-only PB-PREP-001 harness** from the accepted C02 four-joint/sampler fixture, preferably with a small custom realtime component owning the synthetic plants and architecture-specific synchronization paths so A/B/C share exactly one plant implementation and one final limiter. The first run should validate P0/P1 and retention only; it must not be called authoritative comparison evidence. Record actual GitHub Actions job runtime in `LAB_COMPUTE_LOG.md` after completion.
