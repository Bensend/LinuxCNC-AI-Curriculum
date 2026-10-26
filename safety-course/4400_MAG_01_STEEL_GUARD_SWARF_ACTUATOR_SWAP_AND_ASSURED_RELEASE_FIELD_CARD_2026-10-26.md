# 4400 MAG-01 — A cheap magnetic guard switch still needs a real installed gap

**2026-10-26 | Practical 4400 safety module | PAPER ONLY / NOT MACHINE APPROVAL**

## The shop-floor trap
A magnetic safety switch is installed on a wooden bench and operates normally. The same sensor is later bolted to a steel guard. The guard flexes, metal swarf accumulates, and a replacement actuator of similar appearance is fitted. An operator sees an intermittent fault and suggests fixing the actuator with tape.

**Do not solve this with tape, a spare magnet, or an ordinary LinuxCNC override.** The exact manufacturer's magnetic envelope and assured *release* distance can change with ferromagnetic mounting, actuator variant, alignment and contamination. A green signal is only the sensed state, not evidence that the physical guard is safely positioned or that dangerous motion has ended.

Read [direct Pilz/Schmersal OEM source audit](../research/4400_MAG_01_PILZ_SCHMERSAL_FERROMAGNETIC_GUARD_SENSOR_MOUNTING_DISTANCE_OEM_AUDIT_2026-10-26.md) and [25D0 low-cost architecture comparison](../research/25D0_GUARD_INTERLOCK_LOW_COST_COMPARISON_2026-09-23.md).

## Four independent propositions

| Proposition | Required owner | Invalid shortcut |
|---|---|---|
| Guard geometry and mechanical stability | Mechanical design, secure mounts, anti-defeat | 'Door looks closed' |
| Sensor + exact actuator detection | Manufacturer-qualified switch, gap, mounting, evaluator | 'Magnet sticks, therefore switch is safe' |
| Safety-related logic and stop demand | Independent safety controller with suitable fault/restart behavior | 'LinuxCNC reads guard-open pin' |
| Hazard physically ceased and remains safe | Independently witnessed final elements, Y1/Y2 stop/hold, isolation | 'Guard LED changed' |

Pilz PSEN ma1.4p-50 exact manual lists `Sao` 3/10 mm and `Sar` 12/22 mm for two different actuator variants. Schmersal BNS 33 OEM describes **approximate** 40%/80% switching-distance behavior at certain ferromagnetic spacings. These are **different products and different quantities**; do not combine them into an installed-machine gap or safety-performance claim.

## Eight PUBLIC PAPER cases — UNSCORED

For each case: name the **safety proposition**, the **manufacturer/physical evidence required**, the **non-energized next step**, the **safe HOLD/release decision**, and a **cheap usable anti-defeat redesign**. No hidden answer keys or self-scoring.

1. A guard sensor passes a bench test but is mounted directly to a ferrous door frame.
2. A maintenance technician substitutes the PSEN ma1.4-10 actuator for the visually similar -03 variant without updating records.
3. Metal grinding swarf builds up between sensor and actuator; the status intermittently changes.
4. A guard sags by a few millimeters after a new hinge is installed; no mechanical gap record exists.
5. A technician uses the Schmersal BNS 33 '40%' ferromagnetic figure to calculate a Pilz PSENmag acceptance gap.
6. The guard switch signals OPEN, but a heavy ram remains supported only by hydraulic pressure.
7. A bypass magnet is left near the door so the operator can change dies faster.
8. A qualified reviewer asks whether a sensor's green indicator plus one normal PLC input proves an independent guard safety function.

## Eight no-energy documentary gates — NOT RUN

| Gate | Required qualified review | Status |
|---|---|---|
| MAG-G01 | Exact switch and **actuator** variant, revision and compatible evaluator identified | NOT RUN |
| MAG-G02 | As-built guard/mount material, spacer, fasteners and geometry recorded | NOT RUN |
| MAG-G03 | OEM `Sao` / `Sar` meaning and selected-variant constraints kept separate | NOT RUN |
| MAG-G04 | Foreseeable swarf, magnetic fields, vibration, sag and maintenance conditions considered | NOT RUN |
| MAG-G05 | Anti-removal, tamper resistance and repeatable mount/hinge design reviewed | NOT RUN |
| MAG-G06 | Qualified function-check plan includes exact evaluation device; not claimed executed | NOT RUN |
| MAG-G07 | Independent physical stop/hold/energy/escape/restart witnesses separately planned | NOT RUN |
| MAG-G08 | Change control for actuator, bracket, spacer, door, sensor or maintenance records explicit | NOT RUN |

## Practical low-cost improvement
Use manufacturer-approved spacers and nonmagnetic fasteners where specified, fixed guard alignment features, captive/testable mounts, protected actuator screws and accessible swarf cleaning. Make it quicker to restore the correct guard than to improvise a bypass. If the safe design still requires routinely defeating a guard to do legitimate setup work, redesign access and setup modes with qualified safeguards rather than normalizing defeat.

## Transfer and release
A mill enclosure, lathe chuck guard, robot cell door, plasma hood or press-brake rear guard may have very different motion and stored-energy hazards. This card addresses only *guard sensing*; physical stopping, gravity holding, LOTO, trapped-person protection and deliberate restart must be validated independently. The exact installed equipment is **UNKNOWN**. OEM **DOC-CONFIRMED**, no new LinuxCNC SOURCE-CONFIRMED, TEST-CONFIRMED none, COMMUNITY-REPORTED none, engineering consequences INFERENCE. Eight paper cases UNSCORED, eight gates NOT RUN, external evaluator NOT RUN. **G0/G1 HOLD; no personnel-exposed hazardous operation.** No Actions, tests or compute.
