# 25E0 — Corrective-Action Handoff Persistence and Mechanical/Installation Common Cause

Date: 2026-09-22
Status: learner-facing safety method

## Objective

Prevent an open safety finding from disappearing merely because a shift changes, a maintenance work order closes, LinuxCNC is restarted, alarms clear, or the machine HMI returns to a visually normal state. Extend the `FIND-*` method into corrective/preventive-action ownership and trace a professional non-electrical common cause: guard/sensor mounting, alignment, stops and shared structure.

## Evidence discipline

Claims below retain `SOURCE-CONFIRMED`, `DOC-CONFIRMED`, `TEST-CONFIRMED`, `COMMUNITY-REPORTED`, `INFERENCE`, and `UNKNOWN`. Device manuals are authoritative only for their documented devices/application conditions. No device-specific tolerance is generalized into a machine acceptance criterion.

## 1. Open safety obligations must survive organizational handoff

An adverse `FIND-*` record is durable state, not an operator-session alarm.

Required separation:

`finding observed -> containment -> owner assigned -> affected PROP/SF traced -> correction -> physical re-proof -> acceptance -> reset/rearm -> fresh ordinary demand`

A shift handoff, maintenance ticket closure, controller reboot, HMI acknowledgement, production schedule change, or personnel change may occur inside that chain. None is itself an acceptance event.

### Minimum handoff payload

For every open safety-relevant finding, the next responsible person/system must be able to recover:

- immutable `FIND-ID` and original adverse `EVID-*`;
- current finding state;
- containment currently relied upon and who owns it;
- affected or potentially affected `PROP-*` and `SF-*`;
- unresolved `UNKNOWN` items;
- correction/CAPA owner and due/review state without inventing a universal due interval;
- required `VAL-*` physical re-proof obligations;
- explicit acceptance authority;
- whether reset/rearm and a fresh ordinary demand remain pending.

The machine's ordinary green/ready indication must not erase or semantically close these obligations. If ordinary control is allowed to display status, it is a mirror/diagnostic surface; it does not acquire personnel-safety acceptance authority.

### Persistence rule

A durable finding may transition only because new evidence justifies the transition. Session lifecycle is not evidence.

Freeze:

- **WORK ORDER CLOSED != SAFETY FINDING CLOSED.**
- **SHIFT HANDOFF COMPLETE != CONTAINMENT REMOVED.**
- **HMI GREEN != OPEN SAFETY OBLIGATIONS CLEARED.**
- **CONTROLLER REBOOT != SAFETY BASELINE RESTORED.**
- **CORRECTIVE ACTION IMPLEMENTED != PHYSICAL RE-PROOF ACCEPTED.**

### CAPA ownership without pretending root cause is known

Recurrence can justify escalation into corrective/preventive-action review while cause remains `UNKNOWN`. The owner must distinguish:

1. containment — limits exposure now;
2. correction — restores the immediate defect;
3. cause investigation — tests why it occurred;
4. corrective action — addresses demonstrated cause;
5. preventive/design action — changes architecture, installation, maintenance/proof or workflow where evidence supports doing so;
6. re-proof — demonstrates the affected physical proposition again;
7. acceptance — named authority accepts the evidence.

Repeated repair is not a substitute for items 3–7.

## 2. Professional mechanical/mounting common-cause trace

### Rockwell guard-locking installation

`DOC-CONFIRMED` — Rockwell Guardmaster 440G documentation states that a flexible actuator accommodates guard-door misalignment, but the locking bolt still must enter/withdraw without binding and recommends a separately mounted door latch to avoid door misalignment. The same manual warns that inadequate separation between electromagnetic switches can create crosstalk, nuisance faults and false operation.

`DOC-CONFIRMED` — Rockwell TLSZ documentation states that an incorrectly mounted target can still appear to operate correctly while having reduced misalignment tolerance and intermittent fault behavior. Correction requires proper remounting rather than treating intermittent healthy indication as proof of correct installation.

Engineering consequence: the sensor's electrical diagnostics are not the whole proposition. Guard geometry, latch/stop behavior, actuator mounting and the supporting structure can be dependencies of the safety function.

### SICK guard-position installation

`DOC-CONFIRMED` — SICK STR1 instructions define assured switch-on/switch-off distances and warn that an inappropriate parallel approach can cause OSSD ON before the intended correct position is reached if required spacing is not maintained. The manual recommends avoiding that approach when the minimum distance cannot be maintained.

`DOC-CONFIRMED` — SICK T4000 instructions require positive actuator mounting, specified relative positioning, an additional guard stop when necessary, and explicitly say the actuator/safety switch must not be used as a mechanical stop.

Engineering consequence: a common guard frame, hinge, latch, stop, bracket or mounting surface can influence more than one nominally separate sensor. Separate OSSD channels do not establish physical independence if their geometry is moved by the same sagging door, loose structure, impact or maladjusted stop.

Freeze:

- **TWO SAFETY SENSORS != TWO INDEPENDENT PHYSICAL WITNESSES when both depend on the same moving structure or alignment.**
- **OSSD HEALTHY != GUARD GEOMETRY/INSTALLATION PROVED.**
- **INTERMITTENT NUISANCE FAULT != PERMISSION TO WIDEN, DEFEAT OR SOFTWARE-SUPPRESS THE SAFETY FUNCTION.**
- **SENSOR/ACTUATOR != MECHANICAL DOOR STOP unless the manufacturer/application explicitly establishes that function.**

## 3. Show-where-used example

Assume two coded guard sensors are mounted at different points on one large access door. They feed independent safety inputs. Both rely on `DEP-GUARD-STRUCTURE-01`: hinge/frame/latch/stop geometry.

Finding: periodic inspection discovers one actuator intermittently near its switching boundary and visible door sag.

Correct reasoning:

1. preserve the adverse observation as `FIND-GUARD-ALIGN-01`;
2. contain exposed operation according to the machine-specific hazard assessment;
3. trace `DEP-GUARD-STRUCTURE-01` into **both** sensor propositions rather than replacing only the faulting sensor;
4. inspect mounting, hinge/frame/latch/stop and both actuator/sensor relationships against their actual device instructions;
5. keep root cause `UNKNOWN` until evidence distinguishes loose mounting, wear, impact, structural deflection, bad original geometry or another cause;
6. implement supported correction;
7. physically re-prove each affected proposition under its own acceptance criterion;
8. only then perform acceptance, reset/rearm and fresh ordinary demand.

The second sensor's lack of an alarm is evidence about its diagnostics, not proof that the shared mechanical dependency remained valid.

## 4. Shift-handoff adversarial exercise

At 14:45, maintenance finds recurring guard-switch nuisance trips. Production ends at 15:00. The technician adjusts the actuator until the switch is green, closes the CMMS work order as “adjusted,” and tells second shift to watch it. LinuxCNC shows READY after restart. No one has inspected the door hinge/stop, traced the other sensor on the same door, or executed the required physical re-proof.

### Learner task

Classify each statement and decide whether production authority may be restored:

- “The work order is closed.”
- “The safety input is green.”
- “The nuisance trip is gone.”
- “The second sensor never faulted.”
- “Second shift was verbally told.”
- “The original finding has a durable ID, containment state, dependency trace, named owner, required re-proof and acceptance state.”

Expected reasoning: the first five are not acceptance evidence. The sixth is necessary lifecycle control but still does not itself prove the physical proposition. Production return requires the actual affected proposition(s) to be re-proved and accepted, followed by reset/rearm and fresh ordinary demand as applicable.

## 5. Human-factors rule

A system that makes a recurring alignment problem easiest to solve by loosening tolerances, suppressing alarms in LinuxCNC/HAL, taping an actuator, or repeatedly “adjusting until green” is badly engineered even if the original safety device was correctly selected. Corrective/preventive action should consider robust mounting, independent door support/latching/stops, maintainability, inspection access and an operating workflow that makes the supported safe condition easier than defeat.

Do not transfer safety authority to ordinary LinuxCNC/FPGA logic to hide nuisance trips.

## 6. Evidence ledger

- `DOC-CONFIRMED` — Rockwell 440G-UM004H-EN-P (Feb 2026): flexible actuator/misalignment; verify locking bolt motion without binding; separate latch recommended; electromagnetic switch spacing/crosstalk warning.
- `DOC-CONFIRMED` — Rockwell 440G-UM002 TLSZ: incorrectly mounted target may operate but with reduced misalignment tolerance and intermittent fault; correct mounting is required.
- `DOC-CONFIRMED` — SICK STR1 8018754/1RU3/2025-04-04: assured sensing distances; parallel approach spacing; possible premature OSSD ON if spacing is violated.
- `DOC-CONFIRMED` — SICK T4000 operating instructions 8012206/UC32: positive actuator mounting, relative-position requirements, additional stop when necessary, switch/actuator not to be used as mechanical stop.
- `INFERENCE` — shared guard/frame/hinge/latch geometry can be a common physical dependency across multiple safety sensors. This is a system-level inference to be checked against the actual machine construction.
- `UNKNOWN` — actual OpenPressBrake guard geometry, mounting stiffness, alignment tolerances and acceptance criteria; do not infer them from these examples.

## 7. Next information-gain branch

Build a durable open-safety-obligation/containment handoff record that interoperates with `FIND-*` and the accepted-baseline ledger, then stress-test restart/power-loss/shift-change semantics. Trace one authoritative example where maintenance/diagnostics can report healthy while the process/final-element physical proposition remains stale. Preserve the ordinary-control versus safety-authority boundary.
