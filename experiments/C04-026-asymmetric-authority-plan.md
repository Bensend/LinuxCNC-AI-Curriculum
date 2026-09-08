# C04-026 — asymmetric actuator response and bounded local authority

Status: **FROZEN BEFORE IMPLEMENTATION**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Prerequisite: accepted C03-025 and C03 1000-level graduation.

## Objective

Extend the accepted C03 deterministic two-loop fixture to test a different proposition: explicit cross-coupling can keep requesting correction while one local loop has insufficient configured output authority. Verify realtime PID saturation evidence, persistent response asymmetry, and recovery when the imposed authority/plant asymmetry is removed.

This tests ordinary control behavior only. It does not define a machine fault threshold or safety response.

## Frozen topology and local settings

Reuse C03's explicit law unchanged:

```text
D = feedback_B - feedback_A
C = 0.5 * D
command_A = base + C
command_B = base - C
```

Reuse separate PID A/B and `integ` plant A/B instances. Keep PID A/B base gains `P=4`, `I=0`, `D=0`, `error-previous-target=false` unless the accepted C03 harness proves a different already-frozen value; no tuning change is permitted after runtime inspection.

Plant A gain remains `1.0` throughout. Cross-coupler remains enabled at `Kc=0.5` throughout decisive phases.

## Frozen phase sequence

All decisive phases occur during the same long coordinated constant-velocity base move.

1. **Phase 1 — symmetric reference:** plant B gain `1.0`; PID A/B `maxoutput=0` (unlimited); >=1 s.
2. **Phase 2 — response asymmetry only:** plant B gain `0.35`; PID A/B `maxoutput=0`; >=3 s.
3. **Phase 3 — same asymmetry plus B authority bound:** plant B gain remains `0.35`; PID A `maxoutput=0`; PID B `maxoutput=1.0`; >=3 s.
4. **Phase 4 — recovery:** plant B gain restored to `1.0`; PID B `maxoutput=0`; >=3 s.

Configuration mutations must use the C03 validated phase-publication discipline: publish unscored phase 0, settle before/after each userspace write, then publish the decisive phase. Decisive phase labels may not coexist with a configuration transition.

## Realtime evidence fields

Each same-cycle sampler record must include at minimum:

- sample number / phase;
- base command;
- feedback A/B;
- D and C;
- corrected command A/B;
- PID output A/B;
- PID saturated A/B;
- PID saturated-count A/B or saturated-s A/B;
- plant gain A/B or phase provenance sufficient to prove it;
- PID B maxoutput or phase provenance sufficient to prove it.

Full raw sampler evidence must be retained under `lab-results/` and published even when analysis fails.

## Predeclared prediction

- Phase 1 should show small A/B disagreement and no sustained saturation.
- Phase 2 should show larger disagreement caused by truthful plant-response asymmetry, with the explicit coupler opposing the separation.
- Phase 3 should contain a sustained interval in which PID B is saturated at its configured output limit while PID A is not, and measured A/B disagreement should remain materially above the symmetric phase-1 reference.
- Phase 4 should clear B saturation and reduce disagreement materially relative to phase 3 after symmetry/authority are restored.

The important teaching result is not a specific optimal error magnitude; it is that bounded local authority is independently observable and can coexist with an active cross-coupler and persistent disagreement.

## Frozen Gates A–H

### Gate A — provenance/topology

PASS only if pinned LinuxCNC revision is proven, two distinct PID/plant paths exist, the C03 cross-coupler topology is intact, and realtime function order is preserved.

### Gate B — observation validity

PASS only if realtime sampler runs after both plants, sample numbers are strictly increasing, overruns are zero, >=500 valid rows exist in phases 2–4, and raw evidence/logs are durably retained. Observation tearing/missing raw trace is HARNESS INVALID.

### Gate C — controlled configuration

PASS only if runtime/config evidence proves:

- `Kc=0.5` in phases 1–4;
- plant A gain `1.0` throughout;
- plant B gains `1.0 -> 0.35 -> 0.35 -> 1.0`;
- PID B `maxoutput 0 -> 0 -> 1.0 -> 0`;
- no local PID tuning changes across decisive phases.

### Gate D — asymmetric-response effect

Let `S1` be mean absolute A/B feedback separation over the last 500 phase-1 rows and `S2` over the last 500 phase-2 rows.

PASS only if:

```text
S2 >= max(0.10 in, 2.0 * S1)
```

This proves the fixture actually produces meaningful response asymmetry before adding the output bound.

### Gate E — explicit correction remains directionally valid

For >=200 phase-2 or phase-3 rows where A is ahead of B by >0.05 in, the sampled D/C/command signs must still oppose disagreement exactly as in C03; same-stage arithmetic residuals must remain <=1e-9.

A saturation experiment is invalid if the cross-coupler itself is accidentally broken.

### Gate F — B-only sustained PID saturation

In phase 3, require at least 500 consecutive valid rows where:

- PID B `saturated=true`;
- `abs(pidB.output - 1.0) <= 1e-9` for positive-command motion, or the corresponding `-1.0` limit if motion direction is negative;
- PID A is not saturated in at least 90% of those same rows.

Also require phase-3 B `saturated-count` or `saturated-s` to demonstrate duration consistent with that interval.

If the selected frozen limit does not cause sustained saturation despite otherwise valid topology, that is a **behavioral FAIL of the prediction**, not permission to tune the threshold after seeing results; reconcile before any redesign.

### Gate G — persistent disagreement under bounded authority and recovery

Let `S3` be mean absolute A/B feedback separation over the final 500 phase-3 rows and `S4` the same over the final 500 phase-4 rows.

PASS only if:

- `S3 >= 0.10 in`;
- phase-4 PID B saturation is false in >=99% of evaluated rows;
- `S4 <= 0.60 * S3`.

This demonstrates that the bounded/asymmetric condition can sustain disagreement and that removing the imposed condition reversibly restores convergence in the deterministic fixture.

### Gate H — source reconciliation and safety boundary

PASS only if the result explicitly reconciles `maxoutput`, `limit_state`, `saturated`, `saturated-s/count`, anti-windup behavior, and `integ` gain semantics with pinned source and preserves:

```text
PID software saturation
!= physical actuator stall
!= drive current limit
!= hydraulic pressure/flow limit
!= sensor fault diagnosis
!= safety-rated fault decision
```

and:

```text
persistent disagreement under bounded authority
=> this tested control path lacks sufficient configured response for the imposed toy condition
!= proof of the physical cause
!= automatic instruction to continue/slow/stop/fault
```

## Attempt discipline

- Wrong sign, lack of predicted saturation, lack of response asymmetry, or lack of recovery with valid observation is behavioral evidence and must not be tuned away silently.
- Proven transition contamination, wrong topology/provenance, sampler tearing, or missing raw evidence is HARNESS INVALID.
- After three materially similar failed/stalled attempts, classify ESSENTIAL NOW / PROMOTE / DROP before another run.

## Exact next checkpoint

Implement C04-026 by modifying the accepted C03 attempt-3 harness only enough to add PID saturation fields and the frozen phase configuration above. Run one authoritative experiment, preserve raw evidence regardless of exit status, and reconcile Gates A–H before changing any control value or threshold.