# HAWE ePRAX Monitored Press-Beam Holding Trace — 2026-09-18

Session start: 2026-09-18T01:36:01Z

## Purpose

Close the current hydraulic evidence gap with a professional press-brake implementation that exposes the gravity-loaded Y-axis, safety-related hydraulic final elements, valve-position feedback, piston-side pressure sensing, stored hydraulic energy, and maintenance isolation boundaries in one manufacturer package.

## Evidence labels

- **DOC-CONFIRMED** — directly stated in HAWE B 6340 operating instructions / HAWE product documentation.
- **INFERENCE** — engineering conclusion bounded by the documented facts.
- **UNKNOWN** — not established for OpenPressBrake or not established by this source.

## Professional implementation trace

### 1. Physical hazard and normal motion

**DOC-CONFIRMED:** HAWE B 6340 defines the ePRAX modular press drive for each press-brake cylinder. During FAST DOWN the Y-axis is accelerated by the weight of the beam. Speed is controlled by the valve positions together with motor-pump speed and the resulting rod-side output throttling.

This is valuable because the hazardous motion source is explicit: gravity participates directly in downward ram acceleration. `pump command = 0` therefore cannot, by itself, mean `beam cannot descend`.

### 2. Safety-related hydraulic final elements

**DOC-CONFIRMED:** B 6340 identifies valves 1/2-QM2, QM3, QM4 and QM5 as safety-related parts of the control system (SRP/CS), controlled by a programmable electronic controller. Their associated BG2/BG3/BG4/BG5 position switches are monitored according to the function diagram.

**DOC-CONFIRMED:** When the safety controller initiates a stop during FAST DOWN, those safety-related valves drop out.

This is stronger evidence than a generic hydraulic safety statement: the source identifies actual final hydraulic elements and actual feedback sensors in the press-beam path.

### 3. Documented safe holding state

**DOC-CONFIRMED:** In IDLE at the top turning point, all valve coils are de-energised. QM2 and QM3 hold the beam in position; QM4 and QM5 prevent unintentional system pressurisation. HAWE states that in this state the beam maintains its position and the Y-axis is in a safe status.

**INFERENCE, bounded:** For this documented HAWE architecture, safe beam holding is not merely `servo torque = 0`; it is a hydraulic final-element state involving multiple valves, with position monitoring on the safety-related set.

Do not generalize the exact valve truth table to another press.

### 4. Position proof is distinct from pressure proof

**DOC-CONFIRMED:** The cylinder module contains directional spool valves, some with position monitoring, directional seated valves with position monitoring, and piston-side pressure sensor BP1. The valve-position switches provide NO and NC outputs; the pressure sensor is a separate analogue measurement.

Therefore freeze:

**VALVE COMMAND -> VALVE POSITION FEEDBACK -> HYDRAULIC PATH STATE -> LOCAL PRESSURE STATE -> BEAM/LOAD STATE**

These are distinct claims. A BG position switch can support a claim about its associated valve element; it does not directly measure piston-side pressure or beam position. BP1 measures piston-side pressure; it does not prove all parallel paths are blocked or that a maintenance restraint is installed.

### 5. Stored energy remains real

**DOC-CONFIRMED:** The optional Slow Up module contains a diaphragm accumulator, and HAWE states that return motion can use temporarily stored hydraulic energy.

Consequently, `drive disabled`, `pump stopped`, or `safety valves dropped out` must not be silently upgraded to `hydraulic stored energy absent`.

### 6. Maintenance boundary is stronger than functional safe holding

**DOC-CONFIRMED:** HAWE warns to secure raised loads before work. For maintenance/disassembly it requires depressurizing the hydraulic system including the pressure tank, securing against unintended restart, and checking that the system is depressurized. The instructions explicitly call for pressure relief on piston/rod-side and, when fitted, Slow Up measurement points.

Freeze:

**FUNCTIONAL SAFE HOLDING != ZERO STORED HYDRAULIC ENERGY != MAINTENANCE-SAFE MECHANICAL CONDITION.**

A press beam may be safely held for an operating safety function while pressure/accumulator energy remains. Maintenance requires a different proof contract.

## Failure-path / proof matrix

| Observation | Supports | Does not by itself prove |
|---|---|---|
| Safety controller commands stop | demand exists | any valve moved |
| QM2-QM5 coils de-energised | electrical actuator command removed | spool/poppet reached intended state |
| BG2-BG5 feedback matches expected state | monitored valve elements reached documented switch state | every hydraulic path blocked; pressure absent |
| BP1 pressure reading | pressure at documented piston-side witness | rod-side/accumulator pressure absent; beam mechanically restrained |
| Beam stationary | no observed motion during observation | valves healthy; future descent impossible |
| Servo drive inactive | active servo regulation absent | gravity descent impossible |
| Accumulator isolated/discharged and relevant pressure witnesses verified | bounded stored-fluid-energy evidence | gravity load physically restrained |
| Approved physical restraint supporting the beam | bounded mechanical load-retention evidence | hydraulic system depressurized |

## Adversarial commissioning questions

A commissioning exercise for a derived press architecture should separately challenge:

1. safety demand while FAST DOWN is active;
2. each monitored valve failing to achieve its demanded state;
3. disagreement between command and BG feedback;
4. loss/staleness of one feedback channel;
5. drive-control loss while the gravity-loaded beam is moving;
6. residual piston-side, rod-side, and accumulator pressure after functional stop;
7. leakage-induced beam creep after the apparently safe state is reached;
8. restart/reset with a stale ordinary LinuxCNC/HAL motion command still asserted;
9. maintenance entry with functional safe holding but without verified depressurization/restraint.

No timing, pressure threshold, stopping distance, PL/SIL/category, leakage allowance, or diagnostic coverage is assigned here for OpenPressBrake. Those require its actual machine architecture and validation basis.

## OpenPressBrake boundary

**UNKNOWN:** exact cylinder interfaces; installed valve topology; which valves, if any, are safety-rated/position-monitored; pressure witness locations; accumulator/precharge topology; safety-controller mapping; beam-restraint provisions; restart logic; achieved PL/SIL/category; stopping distance/time; and acceptable leakage/creep.

The HAWE circuit is professional reference evidence, not an OpenPressBrake schematic to copy blindly.

## Curriculum freeze

For a gravity-loaded hydraulic vertical axis, the minimum proof chain is:

**SAFETY DEMAND -> SAFETY OUTPUT -> FINAL VALVE ACTUATION -> ACTUAL VALVE POSITION -> HYDRAULIC PATH -> RELEVANT PRESSURE/ENERGY WITNESSES -> LOAD STATE -> RESET/RE-ENABLE -> FRESH ORDINARY START.**

For maintenance, append:

**-> STORED-ENERGY RELEASE/ISOLATION -> PHYSICAL LOAD RESTRAINT WHERE REQUIRED.**

LinuxCNC and the ordinary FPGA may request normal motion, display these states, and perform diagnostics. They do not become the sole personnel-safety authority merely because the same signals are convenient to expose there.

## Sources

- HAWE Hydraulik, B 6340 ePRAX modular operating instructions, edition 04-2026 / 1.5: operating modes and SRP/CS valve monitoring; cylinder-module valve/pressure-sensor inventory; maintenance/depressurization requirements.
- HAWE press-brake product/application documentation: press-beam holding and monitored safety functions; ePRAX stored-energy return behavior.

No compute was required or used for this source trace.