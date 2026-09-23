# 2590 — Adversarial assessment: access and presence safeguarding

This assessment is learner-facing. Do not include hidden expected answers here.

For every scenario, state: hazardous event; physical safe-state proposition; safeguard proposition actually evidenced; missing evidence; foreseeable defeat/fault; reset/restart behavior; LinuxCNC boundary; and exposed-operation release decision. Mark unsupported facts `UNKNOWN`.

## Scenario 1 — The spare tongue

A milling enclosure has a tongue interlock. Operators keep a spare actuator near the machine because door sag causes nuisance trips. The normal CNC program will run whenever the interlock input appears closed.

Analyze the engineering defect, defeat path, diagnostics/usability changes, and whether simply hiding the spare actuator is an adequate correction.

## Scenario 2 — High-coded but badly integrated

A robotic cell replaces the tongue switch with a high-coded RFID interlock. The target is mounted on a removable bracket; maintenance has a documented software force that can make the ordinary controller's `guard_closed` indication true. Management claims defeat is now impossible because the switch is high coded.

Separate device-level defeat resistance from system-level authority and physical access.

## Scenario 3 — Light curtain moved closer

A press-like machine has a light curtain. After a layout change it is moved 250 mm closer to the hazard. The sensor response time is unchanged, but no stopping-time measurement is repeated. The installer argues that the curtain is safety-rated and therefore its original placement remains valid.

Use symbolic ISO 13855-style reasoning. Do not invent the machine's stopping time or a safe distance.

## Scenario 4 — Walk-through and blind reset

A perimeter light curtain protects an automated cell. A person can cross the field completely and stand beside the machine without interrupting it. Reset is mounted outside the cell where a large cabinet blocks view of one corner. Field clearing permits immediate automatic restart.

Analyze occupancy, reset visibility, restart separation and practical architecture changes.

## Scenario 5 — Two buttons on ordinary PLC inputs

A single operator loads a small press manually. Two palm buttons are wired to ordinary PLC inputs and the program commands a stroke whenever both bits are true. One button can be taped down. A helper can stand at the side of the tooling.

Explain why boolean AND is not two-hand safety evidence and why even a correctly validated two-hand function for the operator does not automatically protect the helper.

## Scenario 6 — Enabling switch as bypass key

During robot teaching, a three-position enabling grip is clamped in its middle position. The normal HMI remains able to command full-speed motion because selecting Teach only suppresses a warning message. The team argues that the certified grip makes the activity safe.

Trace mode selection, enabling state, motion authority, defeat, restricted-mode requirements and the boundary between ordinary control and personnel-safety authority.

## Scenario 7 — Locked door, spinning spindle

A machining center has monitored guard locking. The safety controller releases the lock whenever a normal-controller `spindle_cmd=0` bit is true. A high-inertia spindle may still coast. No standstill monitor or validated release delay tied to actual stopping behavior is evidenced.

Separate command state, lock state, dangerous-state cessation and release authorization.

## Scenario 8 — Production safe, maintenance unsafe

A machine's guard and light curtain correctly demand a production safety stop. A technician then enters to work beneath a gravity-loaded mechanism while electrical control power remains on and stored fluid energy is present. The technician argues that opening the guard makes lockout unnecessary.

Separate production safeguarding from maintenance isolation, stored-energy control and mechanical restraint.

## Critical-failure conditions

Treat the assessment as failed if the learner:

- invents stopping time/distance, holding force, PL/SIL or setup-mode speed/force;
- treats guard-closed, lock-closed, field-clear or reset state as proof that the physical hazard is absent without evidence;
- claims high coding makes defeat impossible;
- treats two ordinary button bits as a validated two-hand function;
- treats a three-position enabling device as unrestricted bypass authority;
- allows automatic restart merely because a field/guard clears;
- substitutes production safeguarding for maintenance energy isolation;
- assigns sole personnel-safety authority to ordinary LinuxCNC/HAL/FPGA logic without safety-rated evidence.

## Competency target

A passing learner should select safeguards from the physical proposition and lifecycle task, expose defeat pressure and pass-through hazards, preserve stopping-time uncertainty until validated, separate reset/rearm from start, and keep normal machine control outside sole personnel-safety authority.
