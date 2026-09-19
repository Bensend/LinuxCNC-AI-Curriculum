# Two-hand control simultaneity, anti-repeat, and release-authority study

Date: 2026-09-19
Lane: independent safety curriculum Lane B

## Why this branch

The primary lane's newest durable work is reset/EDM plus physical standstill witnessing. This study deliberately avoids those files and instead closes a separate operator-presence/start-authority problem: what a professional two-hand control actually proves, what it does not prove, and how simultaneity, continuous actuation, release, anti-repeat, ordinary process control, and physical stopping remain distinct.

## Evidence labels

- **DOC-CONFIRMED** — directly stated by cited manufacturer documentation.
- **SOURCE-CONFIRMED** — directly established by inspectable source/configuration.
- **TEST-CONFIRMED** — established by an executed test with preserved results.
- **COMMUNITY-REPORTED** — reported by practitioners but not independently verified here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence and explicitly identified as such.
- **UNKNOWN** — not established by available evidence.

No executable verification was required for this documentation study.

## DOC-CONFIRMED — Rockwell professional implementation

Rockwell Machinery Safebook 5 describes two-hand controls as requiring concurrent operation of both controls, within 0.5 s of each other, with both controls continuously operated while the hazardous condition exists. Releasing either control requires both controls to be released before restart. Rockwell explicitly identifies this as anti-tie-down behavior intended to prevent the two-hand action from being reduced to one-hand action.

Source: Rockwell Automation, *Machinery Safebook 5*, `SAFEBOOK-RM002-EN-P`, retrieved 2026-09-19: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/safebk-rm002_-en-p.pdf

Rockwell application technique `SAFETY-AT071` gives a complete two-hand monitoring example. It requires both palm buttons within 0.5 s, continuous actuation during hazardous motion, removal of power when either/both hands are removed, fault detection for palm buttons/wiring/controller, and safe-distance placement so hazardous motion stops before the operator can reach the hazard. The example separately treats E-stop reset/restart behavior. Its stated PLe/Cat.4/SIL3 result belongs to that documented implementation and is not transferred to OpenPressBrake.

Source: Rockwell Automation, *Safety Function: Two Hand Control*, `SAFETY-AT071`, retrieved 2026-09-19: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at071_-en-e.pdf

Rockwell `SAFETY-AT161` adds an important process-control boundary: its zero-force-touch-button implementation confirms operator hand location through the two buttons; removing either hand de-energizes two contactors and interrupts the motor power circuit, while restoration of hazardous motion after both hands are again in place uses a separate external start circuit. It also monitors touch-button, output-device, wiring, and configurable-relay faults.

Source: Rockwell Automation, *Two-hand Control with Zero-force Touch Buttons and a Configurable Safety Relay Safety Function Application Technique*, `SAFETY-AT161A-EN-P`, retrieved 2026-09-19: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at161_-en-p.pdf

## DOC-CONFIRMED — Schneider independent implementation

Schneider Electric's `SF_TwoHandControlTypeIII` safety function block only produces its safe TRUE output when both button inputs transition from false to true within 500 ms after both were previously not actuated. Its standards-implementation documentation separately requires the output to drop when either button drops and requires both inputs to return false before the output can be reinitiated. If a button is already true when the block activates, that condition is detected as an error and both inputs must return false to clear it.

Sources: Schneider Electric Machine Expert, `SF_TwoHandControlTypeIII`, retrieved 2026-09-19: https://product-help.schneider-electric.com/Machine%20Expert/V2.0/fr/SF_TwoHandControlType3/SF_TwoHandControlType3/_modules/sftwohandcontroltype3.html ; Schneider safety-requirements documentation for two-hand control behavior, retrieved 2026-09-19.

## Frozen architecture boundaries

`BUTTON A ACTIVE + BUTTON B ACTIVE != VALID TWO-HAND DEMAND`

A valid demand additionally depends on the required transition history and, for the cited Type III implementations, the documented simultaneity window.

`VALID TWO-HAND DEMAND != OPERATOR CANNOT REACH HAZARD`

Control location/separation and actual machine stopping performance are separate physical claims. The two-hand logic cannot compensate for a station placed too close to the hazard or for a machine that does not stop within the validated reach-time boundary.

`ONE BUTTON RELEASED -> TWO-HAND SAFETY OUTPUT REMOVED`

`ONE BUTTON RELEASED THEN REPRESSED WHILE OTHER REMAINS HELD != VALID RESTART`

Both controls must return to the released state before a new valid two-hand actuation in the cited implementations. This is the anti-repeat/anti-tie-down boundary.

`TWO-HAND SAFETY OUTPUT TRUE != ORDINARY PROCESS COMMAND FRESH != FINAL ELEMENT RESPONDED != PHYSICAL MOTION SAFE`

The safety function can provide/withhold authority, but LinuxCNC/HAL/ordinary FPGA remains ordinary machine control. It must not be allowed to replace the independent two-hand safety evaluator when that function is credited for personnel protection.

## Failure-path / commissioning worksheet

A real machine implementation should deliberately challenge, as applicable:

1. Button A held before Button B is actuated; confirm the documented simultaneity requirement rather than merely checking both final logic levels.
2. Button B held before Button A is actuated.
3. Both controls actuated outside the allowed simultaneity interval; hazardous authority must not be granted in a Type III implementation.
4. Both controls validly actuated, then A released while B remains held; safety authority must be removed.
5. A re-pressed while B never returned released; anti-repeat must prevent a new valid two-hand demand.
6. Mirror the test with B released/re-pressed while A remains held.
7. One button tied down, jammed, shorted, or already active at safety-function activation; challenge the actual selected hardware/function-block diagnostics.
8. Safety power/controller restart with one or both controls held; do not infer a valid fresh demand merely from steady-state ON levels.
9. Valid two-hand demand with an external switching/final element fault; two-hand logic success is not physical energy-removal proof.
10. Release either control during hazardous motion and measure/verify the machine-specific stopping/reach condition required by the risk assessment. Do not import another machine's stop time or distance.
11. Hold ordinary LinuxCNC START/CYCLE/JOG state through loss and restoration of the two-hand safety authority; verify the application-specific command semantics cannot resurrect unintended motion.
12. Verify E-stop, guard/interlock, safe-motion, hydraulic/mechanical retaining functions, and other credited safeguards remain independent; two-hand control is not a universal substitute for them.

## Press-brake/OpenPressBrake transfer boundary

**INFERENCE:** two-hand control is highly relevant to press-style machinery because it can constrain the initiating operator's hands during the hazardous portion of a cycle, but it does not by itself establish protection for another person, bodily entry, rear access, gravity/load retention, hydraulic safe state, or stopping performance.

**UNKNOWN for OpenPressBrake:** whether a two-hand control will be credited at all; the applicable operating modes; control-device type; simultaneity timing; physical station location; safe-distance calculation; stopping time/distance; final-element architecture; reset/restart semantics; PL/SIL/category/DC/CCF; and whether another safeguarding technology is required. These require the actual machine risk assessment, architecture, measurements, and applicable documentation.

No numerical value from the cited example is assigned to OpenPressBrake.

## Practical curriculum lesson

Teach the learner to trace the complete chain rather than stopping at `both buttons ON`:

`BOTH RELEASED -> TWO DISTINCT FRESH ACTUATIONS -> REQUIRED SIMULTANEITY VALID -> TWO-HAND SAFETY AUTHORITY -> ORDINARY PROCESS REQUEST/CONTROL -> FINAL ELEMENT -> PHYSICAL HAZARD RESPONSE`

and on release:

`EITHER HAND RELEASED -> SAFETY AUTHORITY REMOVED -> FINAL ELEMENT SAFE REACTION -> PHYSICAL HAZARD STOPS/IS CONTROLLED AS REQUIRED -> BOTH BUTTONS RELEASED BEFORE NEW TWO-HAND DEMAND`.

The physical stop/reach proof is a commissioning/validation property, not a Boolean property of the two-hand relay or safety function block.

## Precise next Lane-B checkpoint

Find a complete professional press/press-brake or comparable hazardous-cycle implementation exposing:

`two-hand devices -> independent safety evaluator -> simultaneity/anti-repeat -> external final elements -> release during hazardous motion -> measured physical stopping/reach witness -> failed final-element or button diagnostic -> inhibited restart -> correction/re-proof -> machine-specific production reauthorization`.

Prefer OEM/manufacturer documentation with wiring plus validation procedure. If public evidence does not expose the physical stop/reach witness, preserve that as UNKNOWN and rotate to another independent safety evidence gap rather than synthesizing a value or test result.
