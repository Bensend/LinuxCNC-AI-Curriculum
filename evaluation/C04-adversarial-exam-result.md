# C04 — scored 1000-level adversarial exam

Frozen source: `evaluation/C04-adversarial-exam-draft.md`

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Score: **10/10 — PASS**

The exam was frozen before C04-026 result review. Scoring incorporates the valid C04-026 falsification and accepted C04-027 correction rather than rewriting the questions after seeing results.

1. **1/1.** Same base trajectory/cross-coupler inputs establish command relationships only. Each side retains independent PID state, output authority, plant dynamics and feedback. Equal desired motion therefore does not imply equal available effort or achieved position.

2. **1/1.** `calc_pid()` computes raw effort, reads `maxoutput`, clips to +/- the nonzero bound when required and sets `limit_state` to the clipping sign; inside a nonzero bound it clears `limit_state`. Final `output` is then written, and `saturated` plus duration counters are generated from `limit_state`. While limited, same-direction integral accumulation is held by the `tmp1 * limit_state <= 0` anti-windup condition. C04 adds the required edge: at the pinned revision, `maxoutput==0` skips the output-limit block and therefore does not itself clear a previously nonzero `limit_state`.

3. **1/1.** A later userspace read loses servo-cycle simultaneity and transition provenance. Same-cycle realtime sampling can prove which output, saturation bit/count, limit setting, corrected commands and feedback coexisted in the decisive control observation.

4. **1/1.** The observation cannot distinguish, for example: real mechanical/load limitation; drive/amplifier current or voltage limitation; hydraulic pressure/flow limitation; a changed plant gain/friction/compliance condition; actuator/valve fault; encoder scale/freeze/offset error; or an intentionally low software `maxoutput`. C04 establishes software authority state and measured disagreement, not physical cause.

5. **1/1.** Equal numeric configuration does not make two different limiting mechanisms the same measurement. `pid.saturated` reports the software PID component's state; it has no intrinsic observation of drive current. Proof of a drive current limit requires drive/current telemetry or other independent evidence from the physical drive path.

6. **1/1.** The question's simple 'maxoutput=0 then saturation clears' premise is not universally valid at the pinned revision. C04-026 proved stale saturation telemetry after that transition. Source-corrected C04-027 restored plant symmetry and used a finite nonbinding limit to traverse the explicit `limit_state=0` branch, after which disagreement converged and telemetry cleared. This proves reversibility in the deterministic fixture. It still does not prove physical stability margins, actuator health, cause, acceptable real-machine error, or safety adequacy.

7. **1/1.** Correction saturation is upstream/shared coordination-authority evidence; local PID saturation is downstream per-loop effort-authority evidence. Each needs same-cycle observation of the limiter's own input/output/bound/state. One limiter reaching its bound does not imply the other has reached its own bound or identify the physical cause.

8. **1/1.** A frozen/scaled B encoder can manufacture apparent lag, make the B PID request maximum software effort, and make the cross-coupler increase correction even if physical B motion is not actually lagging. C04 therefore cannot decide 'add authority', 'continue', 'stop' or 'fault'. C05 must add independent sensor-fault evidence and later safety/state-policy modules must define permitted machine reactions.

9. **1/1.** With `Igain>0`, while output is limited the pinned PID suppresses integral update that would push farther into the same saturation direction, but permits update that helps unwind the condition. Separate tests are still required for desaturation/recovery trajectory, residual integral state, sign reversal, limit-setting transitions, and the effect of disabling/re-enabling the PID.

10. **1/1.** Strongest conclusion: during the observed 800 ms, the tested software B loop lacked sufficient configured output authority to eliminate the measured disagreement while A remained unsaturated. Assigning physical cause requires independent evidence such as encoder plausibility/redundancy, drive current/voltage/status, pressure/flow/valve state, load/mechanical evidence and timing correlation. PID/cross-coupling response is ordinary control; thresholds, fault classification, stop/continue behavior, power removal and anti-racking safety authority belong to explicit supervisory/safety policy and validated hardware architecture.

## Promotion note

The exam explicitly rejects the attractive but false equivalences:

```text
shared command == shared authority
software saturation == physical saturation
measured disagreement == known physical cause
control response == safety decision
```

and adds the C04-026 revision-specific transition-history correction without weakening any safety boundary.
