# PSDI cycle-initiation / fresh-intent authority study — 2026-09-18

## Question

When a presence-sensing device is intentionally allowed to initiate a machine cycle, what separates a valid protective-field sequence from ordinary START intent, reset/restart, mode selection, and physical final-element authority?

This Lane-B study is intentionally independent of the primary lane's current accessible-cell safe-entry/guard-unlock work and gravity-axis brake-proof work.

## Authoritative implementation evidence

### SICK press-control architecture — DOC-CONFIRMED

SICK documents PSDI (Presence Sensing Device Initiation) as a mode in which a protective device can initiate/continue a machine function after a defined number of operator interventions. Single-break PSDI continues after one intervention; double-break PSDI waits for two interventions before release.

SICK's current PSDI application material states that Flexi Soft can use a safety light curtain to control the cycle of manually loaded presses and that, after the operator removes the hand from the hazardous point, the press can automatically restart. The same source explicitly says PSDI on mechanical power presses is not applicable in the U.S. market, while it may be applicable to pneumatic, hydraulic and servo presses. This jurisdiction/machine-class boundary must be preserved rather than generalized.

SICK's machine-tool industry guide shows PSDI inside a broader press safety controller, alongside operating-mode control, emergency stop, two-hand operation, foot switch, safety light curtain, safe outputs to valves/hydraulic pump, EDM, TDC/BDC/overrun monitoring, reset/restart interlock and muting. That is important evidence that PSDI is not an isolated ordinary-control convenience bit: it sits inside the safety architecture with the other press safety functions.

The older but detailed SICK UE440/UE470 application provides a concrete implementation pattern: a press hazardous point is protected by cascaded vertical/horizontal light curtains; the mode selector chooses single-break PSDI, double-break PSDI or Setup; Setup instead activates an enabling switch; a restart interlock is configured and a reset lamp/button are separate elements. This is useful architectural evidence even though its component generation is old.

Sources:
- SICK, "Safe Productivity – PSDI function in presses" (current web material).
- SICK, definition of PSDI mode.
- SICK, Machine Tool industry guide, complete safe-press-control example.
- SICK UE440/UE470 compact safety controller operating instructions, press application.

### Rockwell PSDI wiring example — DOC-CONFIRMED

Rockwell Automation's current Single and Special Function Safety Monitoring Relays wiring document includes an MSR22LM PSDI example using safety light curtains, pushbuttons, the safety relay and 100S safety contactors. It describes double-break PSDI as a sequence in which the operator first reaches through the light curtain to retrieve a part, reaches through again to place a new part, and clearing the curtain after the configured sequence permits automatic restart without an additional cycle-start button.

This independently confirms the core architectural fact: in PSDI, a validated presence-sensor sequence can intentionally become cycle-initiation authority. It also makes the sequence itself part of the safety-related behavior rather than something that LinuxCNC/HAL should reconstruct from ordinary I/O history.

Source:
- Rockwell Automation, `SAFETY-WD002-EN-P`, Single and Special Function Safety Monitoring Relays Wiring Diagram, MSR22LM Presence Sensing Device Initiation example.

## Frozen authority ladder — INFERENCE from documented implementations

**PROTECTIVE FIELD CLEAR != VALID PSDI MODE != REQUIRED BREAK/MAKE SEQUENCE COMPLETE != PSDI SAFETY RELEASE != FINAL ELEMENT ENABLED != PHYSICAL HAZARDOUS MOTION.**

And:

**RESET COMPLETE != PSDI SEQUENCE COMPLETE != ORDINARY START.**

PSDI is a deliberate exception to the usual teaching shorthand that a safeguard clearing must never initiate motion. The correct rule is narrower: automatic initiation from a protective-device sequence is permissible only where the machine/application/jurisdiction permits PSDI and the validated safety architecture owns the required sequence, mode, protective field, stopping/restart behavior and final-element authority.

## LinuxCNC / OpenPressBrake boundary — INFERENCE

For a future OpenPressBrake implementation, LinuxCNC/HAL or an ordinary FPGA may display PSDI mode/state, request a production mode, coordinate ordinary process sequencing after a safety release, and log the intervention sequence.

It must not be assumed to be the sole safety authority that decides:
- that PSDI is permitted for the actual machine/application/jurisdiction;
- that the protective field geometry is adequate or non-trespassable;
- that the required single/double-break sequence is valid;
- that a field interruption occurred in the correct machine state;
- that a reset/restart interlock has been satisfied;
- that a hazardous cycle may be released after the sequence;
- that safety final elements actually reached their required state.

No claim is made here that OpenPressBrake should use PSDI.

## Failure-path / commissioning questions

A question-driven validation plan should challenge at least:

1. Protective field clears without any valid prior intervention: does that incorrectly initiate a cycle?
2. Single-break mode is selected while the safety logic/configuration expects double-break, or vice versa: is the mismatch detected/inhibited rather than silently changing cycle authority?
3. First intervention of a double-break sequence occurs, then power/control communications cycle: can stale sequence memory incorrectly count toward a new cycle?
4. A field is interrupted while the machine is not in the documented PSDI waiting position/state: can that intervention be incorrectly credited later?
5. Field is continuously blocked, then clears: is that treated according to the validated PSDI sequence rather than as a generic rising-edge START?
6. An ordinary LinuxCNC START/CYCLE/JOG bit is already asserted when PSDI safety release returns: can stale ordinary intent create an extra or unintended cycle?
7. Mode selector changes into or out of PSDI with an incomplete sequence: is sequence state invalidated or otherwise handled by the safety design?
8. Reset is performed after a safety stop: does reset merely restore the safety function, or does it incorrectly satisfy/complete the PSDI intervention count?
9. One light curtain/channel or relevant diagnostic is faulted: is automatic cycle-initiation authority removed?
10. A person can stand/reach beyond the protective field without continued detection: PSDI must not be accepted merely because the beam is clear.
11. Safety output/EDM disagrees with the expected machine state: intervention counting must not hide the final-element fault.
12. Maintenance/configuration changes the PSDI count, mode, field geometry or sensor arrangement: revalidation scope must include the affected initiation and stopping assumptions.

## Practical curriculum lesson

PSDI is valuable precisely because it forces the curriculum to distinguish two very different concepts:

- ordinary stale START must not become fresh intent merely because safety permission returns; but
- a specifically validated safety function can intentionally define a fresh cycle-initiation event from a protective-device sequence.

Therefore the reusable design question is not simply "can clearing the light curtain start motion?" It is "what safety function owns the initiation authority, under which validated mode and sequence, and what independent evidence must be true before that authority reaches the physical final elements?"

## Evidence classification

- SOURCE-CONFIRMED: manufacturer documentation identifies PSDI as a defined protective-device initiation function and distinguishes single/double-break operation.
- DOC-CONFIRMED: SICK press examples integrate PSDI with safety-controller mode selection, restart interlock, protective fields and press safety outputs; Rockwell documents a double-break PSDI wiring/application sequence with safety contactors.
- TEST-CONFIRMED: none in this study.
- COMMUNITY-REPORTED: none used.
- INFERENCE: the authority ladder, LinuxCNC/OpenPressBrake allocation and adversarial commissioning questions above.
- UNKNOWN: whether PSDI is appropriate/permitted for the actual OpenPressBrake machine; actual machine class and applicable legal/standards determination; light-curtain model/resolution/geometry; safe distance; stopping/overrun performance; PSDI waiting position/state; intervention timing; safety-controller implementation; final-element topology; PL/SIL/category/DC; hydraulic behavior and any physical timing/pressure/force values.

## Compute

No simulation, synthesis, benchmark or executable verification was needed. No GitHub-hosted or self-hosted runner compute was used.

## Exact next independent work

Find a modern professional hydraulic/servo-press PSDI commissioning implementation that exposes `mode selection -> safe waiting position/state -> first/second protective-field intervention -> sequence validation -> safety output/final element -> automatic cycle initiation -> interruption during hazardous motion -> reset/restart recovery`, including at least one invalid-sequence or power-cycle case. Preserve the U.S. mechanical-power-press restriction and do not infer applicability to OpenPressBrake without machine-specific standards review.