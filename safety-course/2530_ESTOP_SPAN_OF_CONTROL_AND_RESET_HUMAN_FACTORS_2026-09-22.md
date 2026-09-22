# 2530 — E-stop span of control and reset human factors

Status: source/professional architecture continuation. This lesson deliberately treats segmentation and reset location as safety-design decisions, not labeling afterthoughts.

## Core question

For each emergency-stop device:

> Which hazards and machine sections must this device command to the emergency safe reaction, how will a person under stress know that span, and what must be observed/proved before reset/restart is allowed?

## Whole-machine default; segmentation is a designed exception

**DOC-CONFIRMED:** IDEC's ISO 13850 guidance states that the span of control of an E-stop should in principle cover the whole machine. Multiple spans may be used when one span is inappropriate, such as where stopping all linked machinery could create additional hazards or unnecessarily affect production. When multiple spans exist, they must be clearly defined/identifiable, the device must be readily associated with the hazard it controls, its span must be identifiable at the operating position, actuation must not create/increase hazards in another span, and one span must not prevent initiation of E-stop in another span.

Source: IDEC, `ISO 13850`, accessed 2026-09-22: https://www.idec.com/en-eu/solutions/safety/law/iso-iec/iso13850

**DOC-CONFIRMED:** The same guidance says E-stop devices should be located at operator control stations unless the risk assessment says otherwise, and at other risk-assessment-determined interaction points such as entrances/exits, intervention positions and loading/unloading zones. This reinforces that device placement follows foreseeable human interaction, not merely cabinet convenience.

### Engineering consequence

A segmented line/cell requires an explicit map:

`E-stop device -> visible/identified span -> hazards within span -> adjacent hazards -> final elements affected -> downstream/upstream consequences -> reset/restart authority`

If the map cannot be explained quickly to an operator at the device, the design has a human-factors defect even if the wiring diagram is technically correct.

## Overlap and adjacent-hazard analysis

For each pair of spans A/B ask:

1. Can a hazard physically cross the boundary (stock, robot reach, conveyor transfer, pressure, gravity load, fire/process energy)?
2. Can stopping A while B continues create a new pinch, accumulation, dropped load, trapped person, loss of cooling/braking/holding or process hazard?
3. Does stopping A remove a protective function needed by B?
4. Can a person standing at A reasonably mistake the nearest B device as covering A?
5. Can E-stop actuation in A prevent B's E-stop path from functioning?
6. Do shared final elements or shared energy sources make the supposed spans electrically different but physically coupled?

If any answer is unresolved, span adequacy remains `UNKNOWN`.

## Portable/detachable controls

**DOC-CONFIRMED:** IDEC's ISO 13850 summary says a detachable/cableless operator station with an E-stop requires at least one permanently available E-stop on the machine and measures to avoid confusion between active and inactive E-stop devices, such as status indication, covering inactive devices, or defined storage.

This yields a human-factors rule:

**AN E-STOP THAT LOOKS AVAILABLE BUT IS INACTIVE IS A HAZARDOUS INTERFACE STATE.**

Normal LinuxCNC UI focus, pendant selection or software mode must not silently redefine the physical E-stop span unless the safety architecture and human interface explicitly establish that behavior.

## Reset location is an evidence problem

Reset is not proof by itself. A reset action can only be meaningful when the design establishes what the operator is expected to know/observe at that location.

For each reset location record:

- which span(s) it rearms;
- what hazardous area can be directly observed;
- what area is hidden;
- whether a person can reach the reset from inside the safeguarded space;
- what additional occupancy/presence safeguards cover hidden areas;
- whether resetting one span can make another span newly hazardous;
- whether a retained production command exists;
- whether final-element feedback and required physical propositions are fresh.

**INFERENCE:** Poor reset placement predictably encourages unsafe shortcuts. If the operator must walk to an awkward hidden reset and cannot see the hazard zone anyway, the inconvenience adds no useful proof and may encourage defeat. The design should make the correct reset sequence both informative and convenient.

## Linked-machine example without invented physics

Consider a generic three-section line: feeder A -> process B -> discharge C.

Do not assume one E-stop should stop only the nearest section or all three. Derive it:

- A stop may allow upstream material to accumulate: `UNKNOWN` until process behavior is known.
- B may require auxiliary cooling/braking/holding to remain active during the emergency reaction: `UNKNOWN` until machine physics is known.
- C may safely continue clearing material or may expose a person entering from B: `UNKNOWN` until layout/task analysis is known.

The learner must therefore produce a span table before a wiring diagram. Production inconvenience alone does not justify segmentation, and 'stop everything' is not automatically safe if stopping supporting functions creates another hazard.

## Validation additions specific to span/human factors

For every installed E-stop device validate, on the actual machine/cell:

1. device identity and its indicated span are unambiguous from the actuation position;
2. actuation produces the required reaction in every hazard allocated to that span;
3. hazards outside the span do not create a new/increased risk because this span stopped;
4. another span's E-stop remains independently initiable;
5. overlapping/shared hazards receive the intended combined reaction;
6. release of the device does not restart production;
7. reset/rearm does not consume a pre-existing held Cycle Start as a fresh demand;
8. reset location/visibility and any occupancy safeguards support the required personnel-clear proposition;
9. power-cycle/recovery does not silently alter span identity or restore hazardous operation;
10. detachable/cableless stations cannot leave a credible-looking inactive E-stop without an explicit anti-confusion measure.

This list supplements rather than replaces the 2520 verification/validation matrix.

## Adversarial prompts

- Two adjacent E-stops are physically identical; one stops only a robot and the other stops the entire cell. No span marking exists. Wiring is perfect. Is the design acceptable? **No conclusion from wiring alone; human identification is a required design surface.**
- Stopping an entire line removes power from a magnetic/gravity holding function. Is 'whole line' automatically safer? **No. The emergency reaction must not create an additional hazard; the required supporting energy/function must be derived from machine physics.**
- A reset station sees 80% of a cell but a fixture hides a person-sized region. Can the operator's button press prove personnel clear? **No. Hidden occupancy remains unresolved without another valid safeguarding/proof method.**
- A wireless pendant is disconnected but its red E-stop remains visible on a bench. Is a fixed machine E-stop elsewhere sufficient to make the interface unambiguous? **Not by itself; inactive-device confusion must be addressed.**

## Freezes

- **SPAN OF CONTROL IS A HAZARD/PHYSICAL-LAYOUT PROPERTY, NOT A SOFTWARE ZONE NAME.**
- **MORE SEGMENTATION != MORE SAFETY; LESS SEGMENTATION != MORE SAFETY.**
- **E-STOP DEVICE NEARBY != THAT DEVICE COVERS THIS HAZARD.**
- **RESET LOCATION CONVENIENT != PERSONNEL CLEAR PROVED; RESET LOCATION INCONVENIENT != SAFER.**
- **WHOLE-MACHINE POWER REMOVAL != UNIVERSALLY SAFE EMERGENCY REACTION.**
- **INACTIVE PORTABLE E-STOP THAT APPEARS ACTIVE IS A HUMAN-FACTORS HAZARD.**

## Next 2530 work

Build the adversarial assessment around stop-strategy selection and machine physics. The learner must decide what evidence is missing rather than guess Category 0/1, stopping time/distance, brake behavior, pressure state or integrity target. Then reconcile E-stop-specific validation with the existing 2520 validation matrix without duplicating it.
