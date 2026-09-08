# C04 — asymmetric actuator response: research and source boundary

Status: **RESEARCH/SOURCE**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Prerequisites: C02 and C03 graduated at 1000 level.

## Learning objective

A fresh AI engineer should be able to distinguish commanded symmetry from plant-response symmetry, trace where local PID output authority is bounded, identify saturation from realtime HAL evidence, and reason about what persistent disagreement means when one side cannot produce the response demanded by the cross-coupler/local loop.

C04 does not choose a production tandem-machine tuning law or safety trip policy. It establishes the observable control consequence of actuator/plant asymmetry and bounded authority so C05-C07 can test sensor faults and state/fault policy without assuming that every disagreement is a sensor problem.

## Official documentation pass

Current LinuxCNC `pid(9)` documentation describes `pid.N.maxoutput` as an absolute output limit. A zero value means no output limit; when the output is limited, the integrator is held rather than continuing to wind up. The component exposes `saturated`, `saturated-s`, and `saturated-count` outputs for limit-state observation.

Evidence: **DOC-CONFIRMED** from the stable LinuxCNC PID manual, checked 2026-09-08.

## Community pass

LinuxCNC gantry community reports reinforce two practical boundaries rather than supplying implementation truth:

- duplicated motors/joints must be configured deliberately; treating a dual-motor axis incorrectly can leave one side unmoved or out of sync;
- large gantries can have serious consequences at physical limits, so observed coordinated commands are not enough to infer safe physical behavior.

A separate developer discussion of servo reversal notes that a servo controller may deliberately command reverse effort to decelerate/reverse a plant; actuator/drive current limiting remains a hardware/drive concern. These reports motivate explicit authority/saturation observation rather than assuming software output equals physical response.

Evidence: **COMMUNITY-REPORTED**. Source/runtime evidence remains authoritative for C04 claims.

## Pinned source trace

### `src/hal/components/pid.c` — `calc_pid()`

Relevant path at the pinned revision:

1. PID computes its local error and terms from that instance's command/feedback.
2. If the previous output was limited in the same direction as the present error, the integral update is held: `(error * limit_state) > 0` suppresses further windup.
3. The raw PID/feedforward effort is calculated.
4. If `maxoutput != 0`, effort is clamped to `+maxoutput` or `-maxoutput`; `limit_state` becomes +1/-1 while clamped.
5. The final value is written to `pid.output`.
6. `pid.saturated` is asserted whenever `limit_state != 0`; `saturated-s` accumulates realtime seconds and `saturated-count` increments on each saturated invocation. When not limited, all three saturation indicators reset to false/zero.

This path is **SOURCE-CONFIRMED** at `8bf4605...`.

### `src/hal/components/integ.comp`

The C02/C03 deterministic toy plant remains suitable for C04 because each instance performs only:

```text
out += gain * in * fperiod
out = clamp(out, min_, max_)
```

Changing only plant-B gain therefore creates explicit actuator-response asymmetry without hidden cross-instance state. This is **SOURCE-CONFIRMED** at the pinned revision.

## End-to-end C04 call-flow premise

Reuse the accepted C03 topology:

```text
base command
  -> disagreement D = feedback_B-feedback_A
  -> correction C = Kc*D
  -> cmd_A = base+C -> PID A -> plant A -> feedback A
  -> cmd_B = base-C -> PID B -> plant B -> feedback B
```

with realtime ordering:

```text
motion
cross-difference
cross-scale
command sums
PID A
PID B
plant A
plant B
sampler
```

C04 adds explicit asymmetric response and bounded local effort. `pid.maxoutput` is local to each PID instance, so one side may be saturated while the other is not. The cross-coupler can continue requesting greater relative correction even when a local loop has no remaining output authority.

## Important evidence boundary

```text
corrected command separation
!= available actuator authority
!= achieved plant acceleration/velocity
!= feedback convergence
```

and:

```text
pid.saturated == true
=> pinned PID output has reached configured software maxoutput
!= drive current limit proven
!= hydraulic valve/pressure limit proven
!= physical stall proven
!= safety fault proven
```

Likewise, persistent A/B disagreement during valid saturation is evidence that this simulated control path lacks sufficient configured authority for the imposed condition; it does not by itself identify mechanical jam, pressure shortage, bad tuning, bad sensor, or the correct machine-level response.

## Predeclared C04 prediction

Before runtime evidence: with the validated C03 coupler active and plant B made slower than A, imposing a sufficiently low `pid.B.maxoutput` should produce a period where B reports realtime saturation while A does not, measured disagreement remains materially larger than the symmetric baseline, and restoring B authority/plant symmetry should clear saturation and reduce disagreement again. If the trace instead shows the same measured plant response with and without the bound, the topology/configuration or oracle is suspect.

## Open questions before experiment

1. What B `maxoutput` produces sustained but recoverable saturation under the existing ramp without immediately destroying the usefulness of the fixture?
2. Should C04 vary only `maxoutput`, only plant gain, or use both? For 1000-level discrimination, the frozen plan should retain plant asymmetry and add a bounded-effort phase so both cause and authority limit are visible.
3. Because `saturated-s/count` reset when output leaves its limit, same-row realtime sampling is required; userspace snapshots are not sufficient evidence of a sustained saturated interval.
4. C05 owns false/frozen/jumping feedback; C04 must use truthful toy feedback so actuator asymmetry is not confounded with sensor asymmetry.

## Promotion candidates

- Quantitative stability/tuning across arbitrary actuator lag, delay and compliance -> 2000, HIGH; does not block because C04's target is observation and bounded authority, not optimal tuning.
- Real hydraulic valve flow/pressure saturation and load transfer -> advanced/hardware capstone, CRITICAL; does not block because no physical hydraulic claim is made.
- Safety-rated reaction to persistent disagreement/saturation -> later safety architecture, CRITICAL; does not block because ordinary PID saturation is explicitly not safety authority.
