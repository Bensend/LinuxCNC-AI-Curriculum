# C04 — 1000-level adversarial exam draft

Status: **FROZEN BEFORE C04-026 RESULT REVIEW**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Score only after the authoritative C04-026 result is reconciled. Passing floor is 10/10 before 1000-level graduation.

1. **Misleading premise:** Both sides receive the same base trajectory and the cross-coupler remains active. Why does that not imply equal available response authority or equal achieved position?
2. **Pinned-source path:** Trace the `pid.c` path from raw PID effort through `maxoutput`, `limit_state`, final `output`, `saturated`, and saturation-duration telemetry. What happens to same-direction integral accumulation while limited?
3. **Observation trap:** Why is a userspace read of `pid.saturated` after the fact weaker evidence than same-cycle realtime sampling during the decisive phase?
4. **Cause ambiguity:** The A/B disagreement grows while PID B is saturated. Name at least four physical or configuration causes that this ordinary software observation cannot distinguish.
5. **Wrong inference:** A drive's current limit is configured to the same numeric value as `pid.maxoutput`. Why is `pid.saturated=true` still not proof that the drive current limit was reached?
6. **Recovery case:** After restoring plant symmetry and unlimited B output, disagreement falls and saturation clears. What does that prove in the deterministic fixture, and what physical-machine claims remain forbidden?
7. **Controller-design transfer:** If a correction limiter saturates before either local PID saturates, how do the meaning and evidence requirements differ from local PID `maxoutput` saturation?
8. **Sensor adversary:** A frozen B encoder causes apparent persistent B lag and B PID saturation. Why can C04 not decide whether to increase authority, stop, or fault? What later evidence is required?
9. **Anti-windup edge:** With `Igain > 0`, explain the pinned PID rule for holding integral update while limited in the same error direction and identify at least one recovery behavior that still needs separate testing.
10. **Novel tandem scenario:** Side B's true plant becomes load-limited, PID B saturates for 800 ms, A remains unsaturated, and measured disagreement crosses a software threshold. State the strongest justified conclusion, the evidence needed before assigning cause, and which part belongs to ordinary control versus safety/state policy.

## Handoff requirement

After scoring, construct a fresh scenario that combines at least two of: asymmetric plant response, PID output saturation, correction saturation, sensor scale/freeze fault, or delayed recovery. A valid fresh-AI handoff must preserve the distinction between software authority telemetry, measured feedback, physical plant truth, fault diagnosis, and safety authority.
