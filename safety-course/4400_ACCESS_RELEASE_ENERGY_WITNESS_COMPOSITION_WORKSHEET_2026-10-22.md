# 4400 — Access-release and energy-witness composition worksheet

Status: learner-facing cross-domain engineering exercise. **All machines and IDs below are hypothetical.** This is not a machine acceptance certificate, physical test, or external blind-evaluation key.

## One coherent failure to catch

A guarded vertical-load machine has an independent safety controller, a locking guard, a hydraulically actuated beam, an accumulator, and ordinary LinuxCNC position/control telemetry. After a protective demand, the switch's electrical output and the valve's position feedback look healthy. The operator requests unlock. A physical motion witness shows continued beam drift, and the accumulator's fluid-side gauge at one tap reads zero. A technician proposes using LinuxCNC's `machine-is-on=false` and the gauge reading to approve access.

**Task:** trace what each observation actually proves, identify missing energy paths and who owns the release decision. No numbers, machine hydraulic truth table, or final safety function may be invented.

## Separate eight-field records per final element

Use the canonical `hardware/SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md` eight-field contract; do not make one combined pseudo-witness.

| Required field | Guard-lock final element | Hydraulic monitored valve | Accumulator/isolation or restraint path |
|---|---|---|---|
| Commanded safety action | Guard locking/retention and qualified unlock as specified by SRS; exact external authority UNKNOWN | Withdraw/alter valve enable as selected SRS specifies; exact function UNKNOWN | Controlled stop energy reserve, discharge, isolate or physically restrain **separately**; exact function UNKNOWN |
| Physical final element | Exact EUCHNER variant/actuator/mounting UNKNOWN | Exact valve/spool/sensor target UNKNOWN | Exact accumulator block, gas/fluid volumes, shutoff/bleed and load restraint UNKNOWN |
| Feedback target | FO may observe guard position **or** locking depending on variant; OL diagnostic is not safe output | Position transducer may observe a valve element, not pressure/ram | Fluid gauge observes its tap and connected volume only |
| Legitimate proposition | Only the selected switch's documented output state; physical escape still unproved | Narrow target position when qualified; not physical stop/hold | Pressure at a verified tap at an instant; not all trapped volumes or gas precharge |
| Shared dependencies | Actuator, mounting, receiver, solenoid supply, reset/configuration, escape hardware | Pilot supply, mechanical link, feedback supply, shared controller I/O | Check/isolating valves, accumulator gas charge, alternate flow paths, gauge location, gravity |
| Residual hazardous energy | Hazardous machine motion may persist behind/after barrier; person may be trapped | Gravity and trapped pressure can sustain motion despite indicated valve state | Gas precharge, trapped fluid, gravity load and reaccumulation may remain |
| Machine-level physical witness | Installed door/retention/inside-escape demonstration plus SRS-required physical safe state | Independent beam-motion and pressure/holding evidence | Correct zone-specific pressure and physical load restraint evidence |
| Maintenance isolation/blocking | Guard release not LOTO | Production valve not automatically lockable isolator | Verify actual lockable isolation, residual-energy disposal and mechanical restraint before servicing |

## Source boundaries and discrepancy handling

- **DOC-CONFIRMED:** EUCHNER CTP-I.-AP 2126290-08-07/24 §6.8: FO remains ON when guard closed/unlocked; CTP-L.-AP 2124217-08-06/21 §§6.1, 6.8: FO OFF when closed/unlocked, monitoring outputs not safety outputs (§10.1). In the L.-AP manual §10.10, the receiving safe input must tolerate the switch's OSSD pulses; a separate up-to-5-ms tolerance applies to pulses on the *solenoid control*, not universally to the OSSD receiver.
- **DOC-CONFIRMED:** HYDAC accumulator operating instructions PN#02068196 (09.11) §3.2 describe a fluid-side gauge dropping to zero during gas-precharge determination. This does not establish gas energy absence. Manufacturer document: https://betterfit-us.hydac.com/wp-content/uploads/Operating%20and%20Installation%20Instructions%20for%20HYDAC%20Accumulators.pdf .
- **INFERENCE:** healthy electrical statuses plus a zero reading at one hydraulic tap cannot override an independent physical witness contradicting the required safe-state proposition.
- **UNKNOWN:** installed topology, valve fail positions, load holding, gas/fluid connectivity, guard mechanics, access reachability, exact safe-state acceptance criteria, PL/SIL and stopping distances.
- **TEST-CONFIRMED:** none. Do not claim that this worksheet proves any physical stop or hold.

## Adversarial prompts and required evidence disposition

1. **Variant substitution:** L1 replaced with I1, closed but unlocked, FO high. What did the electrical evidence cease to prove? Create `CHG`, mark affected `SRS/ARC/DEP/VAL/PT` stale and do not promote OL diagnostic to safety authority.
2. **Lock healthy, egress jammed:** FO state correct, but inside escape cannot physically open the gate. What independent mechanical/ergonomic witness is required? Guard mechanism and human-factor redesign remain open.
3. **Valve healthy, ram drifts:** which narrow proposition survives? Valve-position only; machine `PHY` **NOT ESTABLISHED**; block access/rearm until qualified physical evidence reconciles the contradiction.
4. **Gauge zero, gas precharge remains:** identify the tap's connection to the accumulator and downstream trapped zones for each relevant valve state. Zero on one gauge is not global zero energy.
5. **Power loss with a person inside:** identify how a spring-locked guard can retain a person, and whether inside escape and restart prevention have been physically validated. A power cycle must not automatically authorize start.
6. **Servicing after a powered diagnostic window:** do the earlier lockout and pressure verification still count? No; re-establish the required energy-control sequence and verification before servicing resumes.

## Traceability and commissioning gate

Use distinct `SF/PHY/SRS` records for *guard retention*, *physical machine safe state*, *escape*, *qualified unlock*, and *maintenance isolation*. Link `AUTH/ARC` to independent safety-related control and real final elements; `DEP` to pilot/supply/receiver/actuator/gauge dependencies; `HF` to bypass/escape incentives; `VAL/PT` to independent physical witnesses and contradictory-state tests; `CHG/UNK/RR` to unresolved substitution and operational restrictions. Do not credit `VAL=PASS` from a simulated controller output when the required physical witness has not been obtained.

**Stop rule:** if the minimum safe-to-operate proposition is not established, no personnel-exposed hazardous operation. Isolated/remote experiments only with people outside the danger zone, and with residual risk stated. No lab is justified solely to replay documented switch output semantics; physical proof requires the selected installed machine and controlled validation plan.
