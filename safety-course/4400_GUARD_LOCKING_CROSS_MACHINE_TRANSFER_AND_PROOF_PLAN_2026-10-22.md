# 4400 transfer — One guard-lock output is not one machine safe state

**Scope:** documentary/adversarial design exercise, not a machine test or ready-to-install circuit. Sources: EUCHNER CTP-I.-AP 2126290-08-07/24 and CTP-L.-AP 2124217-08-06/21, with machine-specific behavior retained as `UNKNOWN`.

## Freeze the signal meaning before applying a machine label

A normal closed/unlocked I1 FO pair can be ON; a normal closed/unlocked L1 FO pair is OFF. Both can mechanically lock with spring force and both can show OL OFF when unlocked. A downstream safety controller cannot deduce from the generic signal name `FO1A` whether its target is guard position or safety-rated guard-lock engagement. `AUTH` must record exact selected device/revision and receiver configuration.

| Machine and exposure | Hazard that can remain after ordinary stop | Distinct physical proposition before access | What guard FO/OL cannot establish | Evidence needed to requalify |
|---|---|---|---|---|
| Mill / VMC | Spindle/tool coast, ATC stored motion, pneumatic clamp | Relevant tool/axis has stopped or is held; automatic toolchanger motion inhibited/controlled; guarded access and release are physically possible | Spindle standstill, pneumatic isolation, toolchanger restraint | Selected spindle/ATC stop and energy path; guard geometry; receiver/lock function; controlled restart |
| Lathe | Rotating chuck/workpiece, hydraulic chuck/tailstock energy | Dangerous rotation ended; clamping/part retention risks addressed | Chuck stopped, clamping pressure safe, workpiece secure | Selected drive stop/standstill and hydraulic/mechanical witnesses |
| Press brake | Gravity-loaded ram/beam, hydraulic accumulator/trapped volume, sheet sweep | Actual ram/beam stop/hold and relevant pressure/energy control; access/escape path; maintenance restraint separately | Ram held, all pressure exhausted, sheet sweep eliminated | Hydraulic connectivity map, independent holding/pressure witnesses, guard geometry and physical validation |
| Robot / automated cell | Stored axis/robot motion, suspended payload, another actuator/cell segment | All accessible hazardous axes/loads controlled; no trapped occupant; rearm occupancy strategy | Cell empty, payload secure, all drives stopped | Cell zoning, all final elements, independent safe-state/occupancy and egress validation |
| Plasma / laser | Torch process power, high voltage, fume/fire/hot material | Process energy controlled and delayed access hazards addressed | High voltage isolated, fumes/fire absent, hot material safe | Process source isolation, ventilation/fire state and access validation |

## Adversarial acceptance exercise

For each row, assume `FO1A/FO1B = ON` and `OL = OFF` with the door closed. The learner must:

1. Name the exact device state and **what the output can legitimately prove**, not just call it “guard OK.”
2. State whether the SRS requires only door-position interlocking or safety-rated lock retention until the hazard ends.
3. Identify the independent final element that can stop/hold the actual machine hazard. Normal LinuxCNC/HAL/FPGA commands and display status are **not** personnel-safety authority.
4. Identify the retained hazard after output withdrawal, including gravity, stored pressure, coast, electrical/process energy and trapped persons.
5. Name the necessary selected-machine physical witness and a safe, bounded commissioning validation; leave thresholds/PL/SIL/response times UNKNOWN.
6. If a replacement changes the proposition, open `CHG`, mark dependent evidence STALE, and block exposed-person operation until resolved.

**Common wrong answers:** “Both have PL e”; “both are power-to-unlock”; “OL reports lock status”; “the guard is closed”; “the safety relay sees both channels”; “LinuxCNC E-stop is active”; “the pump is off.” None proves all required physical safe-state propositions.

## Practical design correction

Provide a documented, exact approved spare part and mounting kit; label the actual safety function at the connector and inside the cabinet, not only the SKU; make a guard-release/egress function check easy to perform with appropriate isolation; and provide good diagnostic visibility that cannot be mistaken for safety authorization. A guard that technicians routinely defeat to clear chips or adjust a tool is a design problem requiring safe-access redesign.

**Minimum threshold:** If independent stop/hold, safe access, inside escape and required residual-energy controls are not established, do not expose people to the hazard. Restrict experiments to isolated/remote conditions with everyone outside the danger zone; record residual risk.
