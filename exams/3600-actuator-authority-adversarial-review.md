# 3600 Actuator-Authority / Extra-Joint Adversarial Review

Date frozen: 2026-09-12
Status: **FROZEN BEFORE ANSWERS**
Scope: source-grounded ordinary-control review; not a module graduation exam and not functional-safety validation.

Use only the public/pinned-source claims established in this session. Do not assume target-machine timings or thresholds.

## Questions

1. A stock LinuxCNC PID has `pid.N.saturated = FALSE`. An axis is not moving even though position error persists. Does the false saturation pin rule out a mechanically locked brake or downstream drive inhibit? Explain the exact source boundary.

2. A homed extra joint has a changing `joint.N.posthome-cmd`, `joint.N.motor-pos-cmd` reflects it, but `joint.N.amp-enable-out = FALSE`. Is the nonzero/changing motor command sufficient ordinary-control authorization for the physical actuator to move? Why or why not?

3. A homed extra joint's encoder feedback stops changing while its external planner continues commanding motion. Will ordinary MOTMOD following-error supervision necessarily trip? Cite the relevant source behavior and name the kind of witness that must exist instead.

4. Trace an asserted `joint.N.amp-fault-in` through pinned motion source to the eventual `joint.N.amp-enable-out` state. Preserve diagnostic cause instead of saying only "LinuxCNC faults."

5. The `motion(9)` documentation says motor feedback is ignored after an extra joint is homed. Does that forbid machine-specific external HAL/controller logic from consuming the encoder signal? Explain the ownership distinction.

6. Version trap: could the PID and extra-joint conclusions be dismissed as behavior unique to the pinned 2026 curriculum commit? State the evidence available as of this review and its limits.

7. Small architecture task: sketch the minimum ordinary-control signal separation for a braked press-brake backgauge axis using an extra joint. Include command, LinuxCNC enable request, observed downstream readiness where available, feedback/tracking, drive fault, and completion. Do not invent timing values.

8. Counterfactual: a drive remains "ready" and does not assert amplifier fault, but a brake remains mechanically engaged. Which stock witnesses can remain apparently healthy, and what conclusion follows for stall/authority supervision?

## Scoring rule

Eight points total, one per question. Full credit requires preserving command/authority/feedback/fault distinctions and rejecting any functional-safety claim not supported by the evidence.
