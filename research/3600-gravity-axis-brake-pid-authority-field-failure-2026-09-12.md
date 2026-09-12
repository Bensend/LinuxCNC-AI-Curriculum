# 3600 press-brake preparation — gravity-loaded auxiliary axis, holding brake, and PID authority

Date: 2026-09-12
Status: dependency-safe 3600 preparation; F02 remains the external 2000-series gate

## Question

What concrete control failure can occur when a gravity-loaded press-brake auxiliary axis retains closed-loop actuator authority while a mechanical holding brake prevents motion, and what does stock LinuxCNC `pid` actually guarantee in that condition?

This pass is intentionally narrow. It does **not** define a safety-rated brake sequence, target-machine delay, acceptable stall current, or universal servo architecture.

## Community / field evidence

The ongoing Ursviken Pullmax Optima retrofit thread provides a useful real-machine failure chronology.

- The R backgauge axis is a vertical, gravity-loaded DC servo with a mechanical brake.
- The builder reports manually commanding that axis closed-loop while working on brake logic.
- After the axis had drifted roughly seven encoder counts while the brake was locked, the PID drove harder against the immobilized axis until the DC servo overheated and was destroyed.
- The same build later exposed a second brake-logic defect: during sufficiently slow motion, the logic could momentarily re-apply the brake and then release it again.
- The builder consequently proposed using more than commanded PWM alone to infer motion/holding state, including velocity feedback and distance-to-go, and considered a reusable custom axis component.

Evidence class: **COMMUNITY-REPORTED FIELD FAILURE**. The public forum page exposes the chronology and the author's diagnosis, but the attachment containing the complete configuration is not publicly inspectable from the anonymous page used here. Therefore the exact HAL wiring that produced the failure remains **SOURCE UNAVAILABLE / UNKNOWN**.

Relevant forum evidence:

- 9 Dec 2025: brake drift, PID windup, overheated/burned Baldor DC servo; brake-release delay also interfered with homing.
- 11 Dec 2025: encoder error drove the axis against a hard stop at high power; slow-motion brake logic could briefly re-lock; builder proposed independent stall/velocity logic.

Source: LinuxCNC Forum, “Ursviken Pullmax Optima 130 press brake retrofit with 4 axis backgage,” posts #339924/#339978.

## Stock LinuxCNC PID source trace

Pinned implementation inspected for this pass:

- repository: `LinuxCNC/linuxcnc`
- revision: `f325d51f52da7d5e0e227ac35e3672ee6f873b4f`
- path: `src/hal/components/pid.c`
- realtime update function: the main PID calculation path around the integrator/output-limit logic

### Enable false

When `pid.N.enable` is false:

1. the integral accumulator `error_i` is reset to zero;
2. final output is forced to zero;
3. `limit_state` is cleared;
4. the exported saturation outputs therefore clear.

Evidence: **SOURCE-CONFIRMED** at the pinned revision.

### Enable true, actuator physically blocked

When `enable` is true, the component does not know whether a brake is released, a drive is enabled, hydraulic/electrical power is actually available, or the plant can move. It only sees command, feedback, gains, and its configured numeric limits.

The integral path accumulates position error while enabled, except when the component's own `limit_state` indicates that its output has already reached the configured `maxoutput` in the same direction as the error. `maxerrorI`, when nonzero, separately clamps the integral accumulator.

Therefore:

- a physically blocked actuator can still be commanded by an enabled PID;
- the PID has no native “brake engaged” or “actuator unavailable” semantic;
- anti-windup reacts to **the PID component's own output limit state**, not to an external brake, stalled motor, drive current limit, contactor state, or hardware saturation;
- if `maxoutput == 0`, that component-level output limit is disabled; if `maxerrorI == 0`, that integral clamp is disabled as well.

Evidence: **SOURCE-CONFIRMED** at the pinned revision.

### Saturation witness boundary

`pid.N.saturated`, `saturated-s`, and `saturated-count` are derived from `limit_state`, which is set when the computed PID output is clipped by `pid.N.maxoutput`.

They do **not** establish any of the following:

- physical brake released;
- servo amplifier enabled/healthy;
- actuator current below a hardware limit;
- commanded axis is moving;
- encoder feedback is physically valid;
- mechanism is not against a hard stop;
- external actuator/drive saturation has occurred.

This reinforces the earlier curriculum rule that PID saturation is an internal controller witness, not an actuator-authority witness.

## Function / state flow

For the failure class considered here:

`position command`
→ `pid.command`
→ `command - feedback`
→ enabled error integration
→ P/I/D + feed-forward calculation
→ optional `maxoutput` clipping / internal saturation witness
→ `pid.output`
→ downstream drive command
→ **physical authority boundary** (drive enable, brake state, current/torque capability, mechanism freedom)
→ actuator motion
→ encoder / position feedback

The critical observation is that the physical-authority boundary is downstream of the PID calculation. A valid PID output does not prove that the mechanism can or should respond.

## Failure analysis

### Failure A — brake engaged while PID retains authority

If the brake prevents movement but command and feedback differ, the PID can continue producing corrective demand. With nonzero I gain, integral demand may grow until an explicit PID clamp is reached; even without I gain, proportional demand can remain continuously applied. The stock component cannot distinguish this from an ordinary position error.

### Failure B — brake re-applies during slow commanded motion

A rule such as “engage brake after command/output has been small for N seconds” can be invalid if the axis is intentionally moving slowly or a nonlinear plant requires small command while still moving. The field report demonstrates this class directly. Whether a particular alternative predicate is sufficient remains machine-specific.

### Failure C — bad feedback / hard stop

The same thread reports incorrect encoder state with the axis mechanically against a positive stop and the motor holding at high power. Position error alone cannot distinguish “needs more effort” from “feedback invalid / mechanism blocked.”

## Derived ordinary-control contract

The following are architecture requirements, not a target-machine implementation:

1. **Separate motion demand from actuator authority.** A position command/PID request must not be treated as proof that brake/drive/mechanism authority exists.
2. **Represent brake state explicitly.** Do not infer brake release merely from PID output or command magnitude.
3. **Represent drive readiness/fault separately from brake state.** A released brake does not prove the amplifier can create motion.
4. **Use independent feedback plausibility/tracking witnesses.** A large persistent command with inadequate measured motion is a distinct fault class, not merely more position error.
5. **Bind completion to fresh feedback.** “Command became small” is not equivalent to “axis reached target and is stationary.”
6. **Treat brake sequencing as a state transition, not a scalar threshold.** Release/engage sequencing must account for homing, manual jog, commanded moves, gravity loading, drive authority, and stopped/held state.
7. **Do not claim software brake logic is safety-rated.** Hardware safety functions and hazardous-motion prevention require the machine's separate safety design.

Evidence class for these requirements: **INFERENCE grounded in SOURCE-CONFIRMED PID semantics plus COMMUNITY-REPORTED field failure**.

## Adversarial checks

1. **Misleading premise:** “If `pid.N.saturated` is false, the servo cannot be stalled.” — **FALSE**. The pin only witnesses PID `maxoutput` clipping.
2. **Misleading premise:** “A brake can safely engage whenever PID output is near zero.” — **FALSE as a general rule**. Near-zero controller output does not prove stopped motion, correct feedback, or valid holding state; the field build observed brake re-engagement during slow motion.
3. **Failure trace:** brake blocks a gravity-loaded axis while PID remains enabled — position error persists; enabled PID continues correction; any internal anti-windup is tied to configured PID limits, not brake state.
4. **Recovery boundary:** toggling PID enable false resets its integrator/output, but that alone does not prove the brake, drive, feedback, axis reference, or mechanism is safe/valid for a new command.
5. **Version boundary:** all stock-PID implementation claims above are scoped to `f325d51f52da7d5e0e227ac35e3672ee6f873b4f`; they are not silently generalized to every LinuxCNC release.

Result: **5/5 boundary checks PASS**.

## Corrections / what this changes

The existing curriculum already separated controller command, LinuxCNC enable, downstream readiness, tracking/freshness, drive fault, limits, and completion. This pass adds a concrete press-brake auxiliary-axis failure motivating one additional explicit state: **mechanical holding-brake authority/state must not be collapsed into PID output or amplifier enable**.

No existing test result is invalidated. No new synthetic lab is justified: the mechanism needed here is directly visible in stock PID source, while the physical consequence is represented by a real-machine field failure. A software-only fixture would not verify the mechanical brake or motor thermal behavior.

## Uncertainty / next evidence

Still UNKNOWN:

- the exact Ursviken HAL configuration that caused the burned motor (attachment unavailable anonymously);
- target-machine brake release/engage delays;
- safe gravity-hold strategy;
- motor/drive thermal/current limits;
- whether a given drive exposes a trustworthy external saturation/current/stall witness;
- safety-rated brake monitoring requirements for any specific machine.

Resume this branch only if the complete public config/component or another inspectable implementation exposes its brake/drive/stall state machine. Do not invent timing constants or promote a generic delay sequence to a safety rule.
