# HAWE ePRAX Modular — Safety-Valve / Hydraulic-Path State Trace

Date: 2026-09-18

## Purpose

Push the professional press-brake hydraulic trace one layer deeper than `command -> monitored valve`. The question is what the manufacturer actually establishes about the hydraulic objective in each documented state, and what remains unproved even when command and valve-position feedback agree.

This is a **professional reference trace**, not an OpenPressBrake hydraulic truth table. HAWE timing, pressure, valve identities, architecture and certification claims remain specific to ePRAX modular.

## Source package

Primary authority: HAWE Hydraulik SE, **B 6340 - 04-2026 - 1.5 en**, *Control system for CNC press brakes of type ePRAX modular*.

Relevant manufacturer evidence:

- B 6340 pp. 18–19: operating-mode definition; QM2/QM3/QM4/QM5 are SRP/CS actuators and BG2/BG3/BG4/BG5 are monitored position switches.
- p. 19: IDLE hydraulic objective.
- pp. 20–21: PRECLOSING and FAST DOWN paths.
- pp. 22–24: WORKING SPEED and DECOMPRESSION.
- pp. 24–26: SLOW UP, WAIT, PREOPENING and FAST SPEED UP.
- pp. 84–87: manufacturer hydraulic circuit diagrams.
- pp. 89–90: circuit legend identifying QM2/QM3 as 2/2 seated valves, QM4/QM5 as 4/2 spool valves, BG2–BG5 as their position switches, and BP1 as piston-side pressure sensing.

Evidence labels follow `SOURCE_POLICY.md`.

## 1. Physical architecture established by HAWE

**DOC-CONFIRMED**

Each press-beam Y axis has a cylinder module. The documented safety-related valve set is:

| Element | Manufacturer type | Direct feedback |
|---|---|---|
| QM2 | 2/2 directional seated valve | BG2 position switch |
| QM3 | 2/2 directional seated valve | BG3 position switch |
| QM4 | 4/2 directional spool valve | BG4 position switch |
| QM5 | 4/2 directional spool valve | BG5 position switch |

BP1 measures piston-side pressure. With Slow Up, the optional module includes a diaphragm accumulator and its own valve/check/relief/orifice network.

**Engineering significance:** the safety controller is not merely inferring valve state from coil current. HAWE provides final-element position witnesses on the four SRP/CS valves, while pressure is a different witness at a different physical layer.

## 2. IDLE is an intentionally de-energized hydraulic safe state

**DOC-CONFIRMED**

At the upper turning point HAWE defines IDLE with **all valve coils de-energized**. It explicitly assigns different safety objectives to the valve pairs:

- QM2/QM3: **hold the beam in position**;
- QM4/QM5: **prevent unintentional system pressurization**.

HAWE calls the Y axis safe in this state.

### Freeze

`HOLD THE GRAVITY LOAD` and `PREVENT UNINTENTIONAL PRESSURIZATION` are distinct hydraulic objectives even though both are obtained in the same de-energized state in this design.

This is stronger than the generic statement "valves drop out safe": HAWE identifies what the de-energized groups are physically intended to accomplish.

## 3. FAST DOWN proves why the gravity path matters

**DOC-CONFIRMED**

In FAST DOWN HAWE states that the Y axis is accelerated by the **weight of the beam**. Valve positions plus motor/pump speed create a variable output throttle on the **rod side** to control descent speed. QM2/QM3/QM4 are energized in this phase; QM5 is de-energized. The four SRP/CS valves QM2/QM3/QM4/QM5 drop out when the safety controller initiates a stop.

HAWE also warns that if drive speed control is inactive, beam speed cannot be controlled through the intended output-throttle behavior and the slide can accelerate without braking; machine control must monitor the drive-active outputs and stop motion through the valves if necessary.

### Freeze

`DRIVE SPEED CONTROL HEALTHY` is part of ordinary controlled descent, but the documented stop path reaches the safety-related hydraulic valves.

Therefore:

`SERVO COMMAND = 0 != GRAVITY PATH BLOCKED`

and

`DRIVE INACTIVE != BEAM HELD`.

For a gravity-loaded vertical axis, loss of active drive control can make the hydraulic final elements *more*, not less, important.

## 4. WORKING SPEED changes both pressure path and safety monitoring

**DOC-CONFIRMED**

During WORKING SPEED the valve state and motor/pump speed control beam speed through the **piston side**. With the Slow Up option, rod-side displaced oil charges the optional diaphragm accumulators before excess oil passes toward tank through the documented pressure-limiting path. HAWE states that the safety-related control monitors beam speed using the linear measurement systems and, on excessive speed, commands a stop that drops out specified safety valves.

### Freeze

The professional architecture combines different witnesses for different physical claims:

- valve-position switches: actual monitored switching-element state;
- linear measurement: actual beam-motion/speed evidence;
- BP1: piston-side pressure evidence;
- accumulator hardware: a known possible store of hydraulic energy.

No single one substitutes for the others.

## 5. DECOMPRESSION is pressure-witnessed, not inferred from valve command

**DOC-CONFIRMED**

HAWE's DECOMPRESSION sequence reverses the electric drive to relieve the system. The sequence is not declared complete merely because valves were commanded or the pump changed direction. Each axis is considered relieved only after its BP1 pressure sensor reports the documented piston-side pressure criterion; the state ends only after both axes satisfy the criterion.

The exact HAWE pressure threshold is deliberately **not generalized** into an OpenPressBrake design requirement.

### Freeze

This is direct professional evidence for:

`DECOMPRESSION COMMAND != DECOMPRESSION PROVED`.

A pressure-dependent safety/sequence claim requires a pressure witness at a location that actually represents the volume being claimed relieved.

## 6. Stored-energy option makes "pressure" plural

**DOC-CONFIRMED**

With Slow Up, HAWE documents diaphragm accumulators. During SLOW UP the Y axis is accelerated upward by accumulator pressure acting on the rod side, while valve positions and pump speed throttle the piston side. The machine controller must monitor piston-side pressure during this mode.

Maintenance instructions separately require depressurizing the rod side and, when Slow Up is fitted, additionally relieving the Slow Up module at its own measurement point.

### Freeze

`PISTON-SIDE PRESSURE RELIEVED != ROD-SIDE PRESSURE RELIEVED != OPTIONAL ACCUMULATOR ENERGY ABSENT`.

A single pressure sensor cannot prove every hydraulic volume is de-energized unless the topology proves those volumes are connected in the relevant state.

## 7. FAST SPEED UP is another active hydraulic state, not release-to-IDLE

**DOC-CONFIRMED**

HAWE documents FAST SPEED UP with QM4 and QM6 energized while QM2/QM3/QM5/QM7 are de-energized. Beam speed is controlled through the **rod side** by valve positions and motor/pump speed. At the end of the upstroke another valve is briefly actuated to relieve system pressure before returning to IDLE.

### Freeze

Returning toward the nominal safe state is itself a sequence. The existence of an eventual de-energized IDLE state does not make every intermediate retraction/upstroke state safe-by-de-energization.

## 8. Evidence ladder for commissioning

The professional trace supports this ordered proof chain:

`SAFETY DEMAND`
`-> safety-controller output state`
`-> coil electrical state`
`-> BG actual valve-element state`
`-> topology-specific hydraulic path state`
`-> BP/other pressure witness for the claimed volume`
`-> linear-position/speed witness for beam behavior`
`-> load-retention observation/challenge`
`-> stored-energy inventory`

Do not collapse adjacent layers.

### Representative disagreements

| Observation | What it proves | What it does **not** prove |
|---|---|---|
| coil de-energized | electrical command/actuation state | valve physically reached safe position |
| BG indicates expected position | monitored switching element reached documented state | every parallel fluid path is blocked; pressure is absent |
| BP1 low | piston-side pressure at BP1 is low | rod side/accumulator is discharged; beam mechanically restrained |
| beam stationary | no observed motion at that moment | intended holding valves are healthy; stored energy absent |
| drive inactive | active motor torque/speed control unavailable | gravity descent path is blocked |
| all four SRP/CS valves in IDLE positions | HAWE final elements match its documented IDLE arrangement | OpenPressBrake has equivalent topology; maintenance isolation is complete |

## 9. Fault-injection implications

The next physical validation package for a HAWE-like architecture should deliberately challenge disagreement rather than only nominal operation:

1. commanded safe + one BG does not transition;
2. BG reports expected state but piston-side pressure evolves inconsistently;
3. piston-side pressure is low while rod-side/accumulator energy remains;
4. drive-active feedback disappears during gravity-driven FAST DOWN;
5. beam motion disagrees with the expected valve/pressure state;
6. one Y axis reaches the expected hydraulic state while the other does not;
7. stale ordinary motion command survives safety recovery;
8. maintenance preparation relieves one measured volume but leaves another known stored-energy volume charged.

These are **verification requirements**, not instructions to defeat safeguards on an energized machine. Physical fault injection must be performed only in a controlled commissioning environment with people outside the hazard zone and with an independent means to prevent hazardous motion/energy release.

## 10. OpenPressBrake boundary

**UNKNOWN — intentionally not inferred**

This HAWE trace does not establish for OpenPressBrake:

- which cylinder chamber is gravity-load holding;
- whether existing valves are seated/spool/poppet and their de-energized paths;
- whether redundant load-holding elements exist;
- whether valve-position feedback exists or can be added;
- whether a prefill/suction valve creates a parallel descent path;
- accumulator presence, volumes or stored-energy paths;
- pressure-witness locations or required thresholds;
- leakage/fall-rate limits;
- required safety performance level/category/diagnostic coverage;
- stopping time/distance;
- maintenance blocking/restraint design.

Those require the installed machine schematic, component identification and physical validation.

## 11. Curriculum conclusion

The ePRAX documentation closes an important conceptual gap. A professional press-brake design can assign **load holding** and **prevention of pressurization** to different final elements, monitor those final elements separately, use a pressure witness to prove a decompression state, use motion feedback for an overspeed safety function, and still retain hydraulic energy in another volume for later motion.

The durable teaching rule is therefore:

> **A safe hydraulic state is a set of topology-specific physical claims, each with an appropriate witness. It is not a Boolean copied from the controller.**

For LinuxCNC/OpenPressBrake, ordinary LinuxCNC/HAL/FPGA may command motion and consume diagnostics, but personnel-safety authority and the required final-element proof remain independent.
