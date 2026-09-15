# Practical Machine Safety — First Safety-Function Contract

Status: first-pass teaching artifact. This is a reasoning framework, **not** a generic claim that any illustrated topology achieves a particular Category, PL or SIL.

## Learning objective

Given a machine hazard, a learner must be able to define a safety function without confusing normal LinuxCNC control with personnel-safety authority.

Use this chain every time:

**hazard -> hazardous event -> safety function -> safe state -> detection/feedback -> reset -> restart authorization -> validation -> residual risk**

A statement such as “E-stop goes into LinuxCNC” is incomplete because it names an input but does not establish the safe state, the independent energy-control path, failure detection, restart behavior or validation.

## Step 1 — Name the hazard physically

Describe the energy and injury mechanism, not the software signal.

Examples:
- rotating spindle can entangle/cut;
- servo axis can crush/shear;
- gravity axis can descend even after motor torque is removed;
- hydraulic accumulator or trapped pressure can move an actuator after electrical power is removed;
- plasma/laser process can expose thermal/radiation/electrical hazards even when coordinated motion has stopped.

Do not begin with “HAL pin X is false.”

## Step 2 — Define the hazardous event

State the circumstance in which exposure becomes unacceptable. Examples include guard opened during hazardous motion, person entering a cell, E-stop demand, loss of required pressure/position witness, or unexpected restart while someone remains exposed.

Machine-specific risk assessment determines which events require safety-related functions. This guide does not invent that assessment.

## Step 3 — State the safety function as an action

A useful safety-function sentence contains:

**trigger + required transition + allowed residual behavior + completion condition**.

Example form:

> When protective device P demands a stop, hazardous actuator A shall transition to safe state S; any permitted stopping motion shall be bounded by condition C; restart shall remain inhibited until prerequisites R are independently satisfied and a deliberate reset/restart sequence occurs.

This form forces the designer to distinguish “request a stop” from “prove the required safe state.”

## Step 4 — Define the safe state physically

“LinuxCNC in E-stop” is a controller state, not automatically the physical safe state.

Ask separately:
- Is torque removed?
- Is hazardous electrical energy isolated where required?
- Is a brake applied?
- Is hydraulic/pneumatic energy blocked, exhausted or mechanically restrained where required?
- Can gravity, back-pressure, stored energy or another axis still move the mechanism?
- Does the process source itself require a separate safe state?

Safe state is machine/hazard specific. STO, a contactor, a dump valve and a mechanical restraint solve different physical problems.

## Step 5 — Separate four authority layers

1. **Normal request** — LinuxCNC/HMI asks to enable, run, reset or stop.
2. **Ordinary permission/status** — normal controller logic reports readiness and coordinates sequencing.
3. **Safety authorization** — safety-rated/validated logic decides whether the hazardous function may be energized where the risk assessment requires it.
4. **Physical actuation/energy state** — contactors, STO channels, brakes, valves or other hardware actually establish the required physical condition.

A watchdog, Mesa/FPGA output, HAL latch or `iocontrol.0.emc-enable-in` can be useful fault containment/coordination without becoming layer 3.

## Step 6 — Define feedback and failed-device behavior

For every safety output element ask:
- How can it fail dangerously?
- Is the failure detected before the next hazardous restart?
- What independent feedback proves an external contactor/valve/drive reached the expected state?
- What happens if feedback is stuck healthy?
- What happens if one output contact welds?
- Does the design remain safe after a single relevant fault where the required architecture demands that behavior?

Manufacturer feedback-loop/EDM examples show why a reset circuit often includes normally-closed feedback contacts from downstream switching devices. The safety relay can then refuse rearm if an external device did not return to its de-energized state. Exact behavior must come from the selected device manual.

## Step 7 — Reset is not restart

A reset acknowledges/restores the safety function's ability to become ready. It should not silently create hazardous motion or energy simply because a guard was closed or an E-stop was released.

Human-factors rule: reset should be easy and deliberate. Diagnostics should identify the missing prerequisite. The operator should not be trained to hold, jumper or repeatedly hammer a reset because the machine gives no useful explanation.

A LinuxCNC/HMI button may generate a reset **request**. If personnel safety depends on the reset semantics, the external safety architecture must independently enforce the required channel state, feedback state and reset behavior.

## Step 8 — Define restart authorization separately

After reset, normal control may still require a distinct enable/start action. Ask:
- Can restoring a guard or releasing E-stop itself restart motion?
- Can a stuck software bit cause restart when the safety device becomes healthy?
- Is the restart control located where the operator can verify the danger zone when required?
- If automatic restart is intended, has the risk assessment actually justified it for that safeguard/application?

Never normalize automatic restart merely because it is convenient for CNC workflow.

## Step 9 — Validation must test the physical claim

Validation is not “the GUI E-stop lamp changed.” A test plan should include, as applicable:
- each protective input/channel independently;
- simultaneous/channel-discrepancy faults where the selected architecture detects them;
- downstream contactor/EDM feedback mismatch;
- drive STO or energy-removal state;
- actual stop time/distance where separation distance or access depends on it;
- stored-energy/gravity behavior;
- power loss/restoration;
- controller crash/network loss/watchdog loss;
- reset held/stuck, reset spam and restart after safeguard restoration;
- bypass/removal/reinstallation errors likely during maintenance;
- diagnostics that direct repair without encouraging bypass.

Measurements needed for a real machine must be measured. Do not substitute generic response-time arithmetic for the machine's total stopping performance.

## Step 10 — State residual risk plainly

After the safety function is defined and validated, name what can still hurt someone and what physical/operational measures control that remaining risk.

If a basic minimum safe-to-operate threshold is not met, do not operate with people exposed to the hazard. Experimental operation must be isolated/remote with people outside the danger zone and residual risk stated explicitly.

## Worked reasoning example — generic servo axis with guard

This is intentionally non-quantitative.

**Hazard:** powered axis can crush a person in the guarded envelope.

**Hazardous event:** guard opens while hazardous automatic motion/torque is available.

**Safety function:** guard demand causes the independently designed safety system to remove hazardous drive authority using the selected safe-stop/STO/energy-control method appropriate to the machine; normal LinuxCNC motion permission is also removed for coordination.

**Safe state:** defined from the actual mechanics. If gravity can move the axis after STO, STO alone is explicitly insufficient; brake/restraint/hydraulic measures must be evaluated separately.

**Feedback:** safety system diagnostics plus any required external-device monitoring prove the selected energy-control devices returned to the required state before rearm.

**Reset:** closing the guard does not itself create hazardous restart. A deliberate reset request is accepted only when safety prerequisites are valid.

**Restart:** a separate normal start/enable action is required unless the application-specific risk assessment supports another behavior.

**Validation:** intentionally open each guard channel, test relevant detected wiring faults, test downstream feedback mismatch, verify the physical safe state, measure stopping performance where needed, test power/controller loss, and verify no unexpected restart.

**Residual risk:** machine-specific; e.g. stored mechanical/gravity energy may remain even with drive torque removed.

## Adversarial checks

A learner passes this first artifact only if it rejects all of these shortcuts:

1. “LinuxCNC E-stop is active, therefore the machine is physically safe.” — **Reject.** Controller state is not proof of physical safe state.
2. “The FPGA watchdog disables outputs, therefore it is a safety relay.” — **Reject.** Fault containment is not automatically safety-rated authority.
3. “The safety relay has two channels, therefore the machine is PL e.” — **Reject.** Performance claims require the complete architecture, device data, application assumptions and validation.
4. “STO guarantees a vertical axis cannot fall.” — **Reject.** Removing motor torque does not control gravity by itself.
5. “The guard is closed again, so automatic restart is fine.” — **Reject unless application-specific risk assessment and the selected safety architecture explicitly justify it.**
6. “LinuxCNC can pulse the reset output, so LinuxCNC decides safety is restored.” — **Reject.** A software pulse can be a request; the external safety system must enforce required safety prerequisites where personnel safety depends on them.
7. “A welded contactor is okay because LinuxCNC knows E-stop is active.” — **Reject.** Diagnostic knowledge does not remove hazardous energy; output redundancy/feedback/restart inhibition must be addressed by the safety design.

## Evidence relationship

This framework is grounded by the curriculum's source trace of LinuxCNC E-stop authority, real public LinuxCNC machines using external Pilz safety relays, public Maho safety-circuit drawings, and exact manufacturer reset/feedback-loop behavior. It deliberately leaves machine-specific PL/SIL/category, stop time, pressure, brake capacity and stored-energy conclusions unresolved until the necessary design-specific evidence exists.
