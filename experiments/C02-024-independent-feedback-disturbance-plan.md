# C02-024 — independent feedback disturbance experiment plan

Status: **FROZEN BEFORE IMPLEMENTATION**

Pinned LinuxCNC: `8bf4605ae81042248add031e94c77300406e0413`

## Prediction

With two stock PID instances receiving the same changing position-command signal, each driving a separate `integ` plant whose output returns only to that PID's feedback, reducing only plant B's integrator gain will make feedback B diverge from feedback A and produce a correspondingly different PID-B error/control response. PID A will retain its own feedback/error/output path. Stock PID will not automatically compare the two feedback positions or generate a cross-loop disagreement trip.

## Fixture

Build a headless uspace LinuxCNC fixture at the pinned revision. Reuse the C01 duplicated-Y command premise (`XYZY`) but route the duplicated Y command into two separate PID command inputs. Each PID output drives its own `integ` instance; each `integ.out` returns only to its matching PID feedback. Use conservative P-only tuning initially so the causal result is easy to inspect and integral windup is not needed for the primary claim.

Realtime order must be:

```text
motion-command-handler
motion-controller
pid.0.do-pid-calcs
pid.1.do-pid-calcs
integ.0
integ.1
sampler.0
```

`sampler.0` is the equality/divergence oracle; sequential userspace reads may configure the disturbance but may not establish same-cycle equality or disagreement.

## Phases

1. **Topology/baseline:** both plant gains equal; establish a meaningful changing command and separately observable A/B feedback paths.
2. **Asymmetric plant disturbance:** change only `integ.1.gain` to a frozen slower value while leaving command wiring and plant A unchanged.
3. **Recovery:** restore plant-B gain and retain evidence that topology did not silently rejoin the feedback paths.
4. **Disabled-loop failure probe:** deassert only PID B enable for a bounded interval and verify its output-zero behavior while PID A remains enabled/independent. This phase is not safety evidence.

## Frozen gates

**Gate A — provenance/topology.** Runtime binaries/modules come from the pinned checkout. Two PID and two integrator instances exist. HAL declarations/raw pin inventory prove distinct A/B feedback and plant signals; no shared feedback signal is accepted as a substitute.

**Gate B — realtime observation validity.** Sampler executes after both PID and both plant functions in the same servo thread, captures the required channels, has zero overruns for the decisive interval, and preserves monotonic sample numbering. If this fails, classify HARNESS INVALID rather than weakening comparison thresholds.

**Gate C — shared command premise.** During the decisive moving interval, both PID command inputs are demonstrably driven from the same named duplicated-command signal and that command spans at least 1.0 machine unit. A userspace coincidence of separately read values is insufficient.

**Gate D — independent baseline paths.** Before disturbance, both feedback channels move meaningfully and remain separately sampled. The fixture must prove each PID feedback is connected only to its matching plant output.

**Gate E — asymmetric disturbance takes effect only on B.** Raw evidence must show plant A gain remains at the frozen baseline while only plant B gain changes to the frozen disturbed value; command topology is unchanged.

**Gate F — disturbed feedback/control response separates.** During the disturbance there must be a sustained same-cycle interval where `abs(feedback_A-feedback_B) > 1e-4`, and PID-B error/output differs correspondingly from PID A. The result must not be explained by sampler tear or a command difference.

**Gate G — no implicit cross-loop synchronization credited.** The harness/source reconciliation must show no stock PID peer-feedback read or automatic A-vs-B disagreement trip. If an unrelated LinuxCNC following-error mechanism stops motion, preserve it separately and do not relabel it as PID cross-coupling.

**Gate H — disabled-loop failure behavior and safety boundary.** With only PID B disabled, observe PID-B output forced to zero while PID A remains enabled and retains its own state path. Explicitly record that this software behavior does not establish that asymmetric physical actuation is safe, permissible, or safety-rated.

## Invalidating conditions

- A/B values used for a simultaneity claim are sequential userspace reads.
- The two feedback pins are accidentally tied to one HAL signal.
- The disturbance changes the shared command or both plants.
- A following-error stop, motion abort, or unrelated state transition is silently treated as PID cross-coupling.
- The harness changes gates or thresholds after seeing runtime behavior without first classifying/reconciling the attempt.

## Interpretation boundary

A PASS establishes only that two stock feedback/control paths can retain independent state and respond differently to an asymmetric simulated plant while sharing a command premise. C03 must add and test explicit synchronization/cross-coupling. No C02 result is evidence of a physical hydraulic model or safety-rated anti-racking.
