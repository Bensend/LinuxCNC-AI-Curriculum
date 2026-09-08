# C02 — community findings on dual feedback / tandem mechanisms

Status: **COMMUNITY-REPORTED investigation leads**, not architectural authority.

## Findings

LinuxCNC community discussions repeatedly expose a distinction that matters to C02/C03: two motors or joints associated with one machine axis can still require deliberately separate wiring, homing, feedback, and synchronization behavior. Reports about tandem gantries describe cases where only one joint moves during unhomed joint-mode jogging unless both joint jog interfaces are deliberately driven, and cases where separate home-switch geometry can rack a rigid gantry. These are useful field examples of why a shared axis concept must not be mistaken for identical independent-side state.

A separate dual-feedback discussion describes architectures using more than one PID/feedback source and explicitly treats the choice of which feedback drives which controller term as an engineering decision. That supports the curriculum boundary that merely having two feedback devices or two PID instances does not define the synchronization/control architecture.

Representative threads reviewed 2026-09-08:

- LinuxCNC Forum, “Gantry with 2 Synced Y Axis motors, X axis jogging not possible when not homed” (2023): experienced contributors discuss explicitly connecting both joints when synchronous unhomed jogging is desired.
- LinuxCNC Forum, “Dual gantry stepper homing with uneven switches” (2020): reports mechanically consequential racking behavior around separate gantry-side homing switches.
- LinuxCNC Forum, “Dual PID loops and appropriate pins for feedback to the Trajectory Planner et al” (2019): discussion distinguishes possible dual/cascaded PID and separate feedback arrangements rather than implying one canonical dual-feedback topology.

## C02 use

These reports do **not** prove stock PID internals; pinned source does that. They justify adversarial questions and the experiment's insistence on proving actual HAL topology instead of inferring independence from naming. They also reinforce the safety boundary: a software fixture that permits one side's controller output to differ from the other is not evidence that doing so is mechanically safe on a coupled gantry or hydraulic beam.

## Promotion relevance

Detailed tandem homing/squaring belongs downstream. Explicit cross-loop comparison/correction belongs C03. Physical coupled-plant behavior and anti-racking safety remain higher-level/hardware-dependent work.
