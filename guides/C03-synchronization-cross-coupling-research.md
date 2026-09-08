# C03 — synchronization / cross-coupling research

Status: **RESEARCH -> SOURCE**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Prerequisite: C02 graduated at 1000 level. C02 established that a shared motion command plus two stock PID/plant/feedback paths leaves the loop states independent; no implicit peer-feedback synchronization appears.

## 1000-level objective

Build, trace, and experimentally verify one explicit realtime cross-coupling architecture in a generic dual-actuator simulation. The learner must be able to distinguish:

- base coordinated command;
- side-specific feedback;
- relative-position disagreement;
- bounded/configured cross-coupling correction;
- per-side corrected commands;
- each side's local PID/plant loop;
- diagnostic/safety authority, which is **not** created by the cross-coupler.

C03 does not attempt to identify a universally correct physical-machine control law.

## Official documentation pass

Current LinuxCNC documentation inventories realtime arithmetic components including `sum2`, `scale`, `limit1`, `near`, and related HAL primitives. `sum2` is documented as a sum of two inputs with per-input gains and offset; `scale` applies gain/offset. These primitives can form an explicit relative-feedback correction path, but the documentation does not claim that such a path is automatically safe or suitable for a tandem machine.

LinuxCNC's repository/user documentation also carries the broader machinery warning that software alone must not be relied upon for safety. C03 retains that boundary.

Documentation reviewed 2026-09-08:

- <https://linuxcnc.org/docs/stable/html/>
- <https://linuxcnc.org/docs/html/hal/components.html>

## Community pass

Community material is **COMMUNITY-REPORTED** and used as architecture/tuning leads, not normative proof.

- LinuxCNC users have combined two control contributions with `sum2` in dual-feedback/servo configurations. Example: <https://www.forum.linuxcnc.org/10-advanced-configuration/52300-dual-pid-loops-with-motor-encoder-scale-encoder-per-axis>
- Another dual-encoder discussion explicitly compares offset correction versus summing control loops, illustrating that adding a second feedback influence is a topology/tuning choice rather than automatic PID behavior: <https://forum.linuxcnc.org/49-basic-configuration/35768-homing-two-encoders-on-one-axis>
- Real configurations show `sum2`/command functions deliberately scheduled before PID functions, reinforcing that HAL function order is part of the control law: <https://forum.linuxcnc.org/38-general-linuxcnc-questions/36225-solving-some-lingering-f-error-problems?start=10>

These reports involve different plants and objectives from C03. They support only the field reality that multi-feedback corrections are wired explicitly and must be tuned/reasoned about explicitly.

## Pinned source inventory

### `src/hal/components/sum2.comp`

Pinned source exports `in0`, `in1`, `gain0`, `gain1`, `offset`, and `out`. One realtime invocation computes exactly:

```text
out = in0 * gain0 + in1 * gain1 + offset
```

No state, peer lookup, filtering, saturation, or safety decision is hidden inside the component.

### `src/hal/components/scale.comp`

Pinned source exports `in`, `gain`, `offset`, and `out`; one realtime invocation computes:

```text
out = in * gain + offset
```

Again, there is no hidden state or protection behavior.

### Reused C02 source

`pid.c` and `integ.comp` retain the C02 per-instance semantics. C03 changes the command topology feeding those same independent local loops; it does not change their internal PID/plant ownership.

## Candidate explicit cross-coupling law

Define:

```text
base = duplicated coordinated Y command
D    = feedback_B - feedback_A
C    = Kc * D
cmd_A = base + C
cmd_B = base - C
```

If A is ahead (`feedback_A > feedback_B`), then `D < 0`: command A is reduced and command B is increased. The correction therefore opposes measured relative-position disagreement.

For C03's first bounded software experiment, `Kc` is a dimensionless position-correction gain. It is not presented as a physically validated gain.

### HAL construction

A minimal implementation uses:

1. `sum2` with gains `-1,+1` to compute `feedback_B - feedback_A`;
2. `scale` to apply `Kc`;
3. `sum2` A to calculate `base + correction`;
4. `sum2` B with correction gain `-1` to calculate `base - correction`;
5. existing PID A/B and plant A/B from C02.

## Function / call flow

Proposed servo order:

```text
motion-command-handler
motion-controller
cross-difference       # reads prior plant feedback A/B
cross-scale            # applies Kc
command-A-sum          # base + correction
command-B-sum          # base - correction
PID A
PID B
plant A
plant B
sampler
```

At this order, one servo invocation's cross-coupler reads the feedback state available before the plant updates, creates corrected commands, then the local PIDs calculate. The plant functions advance afterward and `sampler` observes the post-plant state plus the correction/commands used during that invocation.

A sampled post-plant feedback difference therefore should not be confused with the exact disagreement value that generated the same row's correction unless the stage relationship is accounted for.

## Analytic prediction for the first fixture

Reuse C02's simple proportional loops (`P=4`) and integrator plants under a 1 in/s ramp. Let plant A gain = 1 and plant B gain = 0.25. Ignoring transients, the local tracking lags are approximately:

```text
A lag = 1 / (4*1)    = 0.25 in
B lag = 1 / (4*0.25) = 1.00 in
```

Without cross-coupling the expected relative lag is about `0.75 in`.

With the symmetric command correction above, steady relative disagreement approximately satisfies:

```text
d = 0.75 / (1 + 2*Kc)
```

For `Kc=0.5`, this simple fixture predicts about `0.375 in`, roughly half the uncoupled disagreement. Runtime transients and sampled staging mean the experiment should test a robust reduction ratio, not demand this exact analytical number.

## Failure/adversarial boundaries

1. **Wrong sign:** reversing one sign makes the correction reinforce disagreement; C03 must include a sign/direction oracle.
2. **Sensor fault:** a frozen/scaled/jumping encoder can cause cross-coupling to command the healthy side incorrectly. C05 owns deeper sensor-fault injection.
3. **Gain/stability:** a gain that reduces disagreement in this toy plant is not a validated physical-machine tuning rule.
4. **Saturation/authority:** an unbounded arithmetic correction can exceed reasonable command authority. A production architecture needs explicit limits and failure policy; 1000-level C03 may keep a bounded fixture range while documenting this promotion.
5. **Safety:** reduced software disagreement is not a safety-rated anti-racking function, proof of physical alignment, or permission for hazardous motion.

## Claims ledger

| Claim | Classification | Evidence | Scope |
|---|---|---|---|
| `sum2` computes a linear two-input combination each invocation | SOURCE-CONFIRMED | pinned `sum2.comp` | pinned SHA |
| `scale` applies configured gain/offset each invocation | SOURCE-CONFIRMED | pinned `scale.comp` | pinned SHA |
| C02 local PID/plant instances remain independent internally | SOURCE + TEST-CONFIRMED | C02 source + C02-024 | pinned SHA / fixture |
| Symmetric feedback-difference correction can reduce relative error in the proposed toy plant | PREDICTION | analytic model above | must be tested by C03-025 |
| The proposed law is correct/safe for a real dual hydraulic machine | NOT CLAIMED | no physical/safety evidence | out of scope |

## Exact next checkpoint

Freeze C03-025 before implementation. Compare the **same B-only plant disturbance** first with `Kc=0`, then with `Kc=0.5`, using realtime same-cycle sampling of base command, feedback A/B, disagreement used by the coupler, correction, corrected commands A/B, PID outputs, plant gains/mode, and phase. Require the coupled steady-window disagreement to decrease materially without changing the disturbance or local PID gains, and require correction direction to oppose the observed A-ahead/B-behind condition. Preserve full raw evidence. Do not make a safety claim from the reduction.
