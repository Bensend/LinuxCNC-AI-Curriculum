# Rockwell Safe Brake Control — feedback timeout, latched fault, and manual reset

Date: 2026-09-21
Course context: 4000 safety / 25E0 professional final-element implementation

## Question

After the Siemens 3SK1 held-Start finding, trace a materially different final-element implementation and answer: when final-element feedback disagrees, is the mismatch time-bounded; does the fault latch; can mere recovery restore eligibility; and what does the feedback actually prove?

## Authoritative evidence

Rockwell Automation Studio 5000 Logix Designer Safe Brake Control (SBC) documentation describes a GuardLogix safety instruction controlling redundant brake outputs, coordinating them with a Torque Off Request, and monitoring two brake-feedback inputs plus I/O status.

DOC-CONFIRMED:

- Whenever BO1/BO2 change state, a configurable Brake Feedback Check Delay begins. After the delay, Brake Feedback 1/2 must be in the opposite state from the brake outputs and remain there; otherwise SBC faults.
- Any SBC fault clears BO1/BO2 OFF. The brake outputs remain OFF until the fault condition is corrected **and the SBC instruction is reset**.
- The documented fault example shows an attempted reset before correction failing, followed by a successful reset after correction.
- In MANUAL restart mode, an OFF->ON Reset transition is required after the request is removed; the instruction resets only when it is not faulted and the other stated reset conditions are satisfied.
- At controller cold start, SBC requires a successful manual reset before releasing the brake and allowing subsequent operation.
- Rockwell documents fault code 101 Brake Feedback Fault and instructs the user to correct brake power/wiring/safety-contactor/feedback inconsistencies, verify the feedback delay, and reset the fault.
- Rockwell explicitly warns that Automatic Restart should be used only where its use has been determined not to create an unsafe condition.

Primary sources:
- Rockwell Automation, Studio 5000 Logix Designer, `Safe Brake Control (SBC)`, v37/v38 online documentation.
- Rockwell Automation, `Logix 5000 Controller Safety Application Instruction Set`, publication 1756-RM095 (current documentation surfaced 2025/2026).
- Rockwell Automation, `Safe Brake Control (SBC) Safety Function Application Technique`, SAFETY-AT178C-EN-P, February 2021.

## Result

This implementation supplies the explicit mismatch semantics sought by the checkpoint:

1. **Command/feedback disagreement is time-bounded.** The brake output transition starts a feedback-check delay; disagreement after expiry becomes a fault.
2. **The fault is not cleared merely because the field signal later becomes plausible.** The documentation requires correction plus reset.
3. **Manual restart requires a new reset transition under valid conditions.** A repaired feedback circuit alone does not satisfy that manual-restart sequence.
4. **Cold start is deliberately conservative.** Entering controller RUN does not by itself release the brake; a successful reset is required.

Freeze:

**BRAKE FEEDBACK RECOVERED != BRAKE SAFETY FUNCTION RESET.**

**FEEDBACK MISMATCH TIMED OUT != TRANSIENT IGNORED FOREVER.**

**FAULT CAUSE CORRECTED != OUTPUTS AUTOMATICALLY RE-ENERGIZED (MANUAL RESTART).**

**CONTROLLER RUNNING != BRAKE RELEASE AUTHORIZED.**

This is importantly different from the Siemens 3SK1 case where a Start signal present during a feedback-circuit fault can, with the documented wiring, result in start after the feedback error is eliminated. The curriculum must therefore teach restart/recovery semantics as implementation-specific and verify them from the actual safety device/function rather than generalizing one vendor algorithm.

## Feedback witness authority

DOC-CONFIRMED: SBC evaluates the configured Brake Feedback inputs relative to its commanded brake outputs and monitors I/O status. It can therefore establish that the **feedback circuit changed to the state expected by this configured function within the configured time**.

INFERENCE, deliberately bounded: where the feedback inputs are wired to contacts/sensors that genuinely witness brake state, this gives useful diagnostic evidence about that represented state. The exact physical claim depends on the brake and feedback architecture.

UNKNOWN unless separately validated on the machine: actual brake torque, clamping force, stopping distance/time, absence of gravity-driven motion, wear margin, mechanical integrity, stored-energy condition, or whether a feedback switch/contact is mechanically truthful under every failure mode.

Freeze:

**BRAKE FEEDBACK VALID != BRAKE TORQUE PROVED.**

**SBC INTEGRITY TRUE != STOPPING PERFORMANCE VALIDATED.**

## Vertical-axis caution

Rockwell's documentation explicitly discusses applications in which gravity can cause motion and explains that motion control may need to retain control under certain brake-feedback fault conditions. This is a useful architecture lesson: a brake-feedback fault does not justify inventing a universal `drop torque immediately` response. The required sequence depends on the hazard analysis, load mechanics, brake behavior, drive safety function, and validated timing.

For OpenPressBrake teaching this remains generic. Do not copy the Rockwell delays, PL/SIL claims, or vertical-load sequencing into a hydraulic press brake. A press-brake hydraulic final element requires its own physical witnesses and validation.

## Curriculum consequence

Add the following 25E0 review questions to every monitored final-element path:

- What starts the mismatch timer?
- What exact feedback transition/state is expected?
- What happens when the timer expires?
- Does the fault latch?
- Can signal recovery alone restore eligibility?
- Is a new reset edge/transition required?
- Can a held Start/Reset/Jog/Cycle demand become effective on recovery?
- What physical fact does the feedback sensor/contact actually witness?
- What hazardous physical facts remain outside that witness and require separate validation?

No executable lab is justified for these vendor-defined semantics. A lab would only become useful for a concrete LinuxCNC/OpenPressBrake state-machine question not already answered by authoritative documentation; personnel-safety authority must remain outside ordinary LinuxCNC/FPGA logic.