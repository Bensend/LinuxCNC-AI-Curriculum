# Professional Press-Brake Hydraulic Schematic Trace — MVD iBend / HB5529-001A

Session start (UTC): 2026-09-17T19:33:33Z

## Purpose

Continue the safety-course physical-energy trace from generic hydraulic safety principles into an inspectable press-brake hydraulic drawing without inventing OpenPressBrake machine facts.

## Source and provenance

Primary machine evidence: MVD iBend hydraulic press-brake user guide, Figure 62, **Hydraulic chart and valve block**, drawing `HB5529-001A`. The public manual exposes a two-cylinder press-brake hydraulic schematic with two suction-valve assemblies, central valve block, solenoid/control elements Y01/Y02/Y03, pressure/measurement ports and working ports A1/A2/B1/B2.

Supporting manufacturer evidence: Bosch Rexroth press-module documentation for hydraulic presses distinguishes safety-related press functions, pressure holding on the piston chamber side, rapid traverse/prefill arrangements, accumulator operation, safe reduced velocity and fall-protection/braking-force checks. Rexroth accumulator safety-block documentation separately identifies relief, unloading, isolation and pressure-measurement access as distinct accumulator functions.

Evidence labels in this artifact use the curriculum convention: DOC-CONFIRMED, INFERENCE, UNKNOWN.

## What the MVD drawing establishes

- **DOC-CONFIRMED:** the press has two hydraulic cylinder branches represented separately.
- **DOC-CONFIRMED:** each side has a suction-valve assembly rather than relying only on the central proportional/directional control block.
- **DOC-CONFIRMED:** the central block exposes distinct A1/A2 and B1/B2 working connections plus P/T and measurement/test points.
- **DOC-CONFIRMED:** Y01/Y02/Y03 are electrically actuated hydraulic-control elements shown in the machine circuit.
- **DOC-CONFIRMED:** the hydraulic drawing is sufficiently complete to prove that a press-brake ram state is a consequence of multiple fluid paths and valve states, not one proportional command.

## What it does NOT establish

The public drawing alone does not establish the personnel-safety performance of the installed machine.

- **UNKNOWN:** exact safety-PLC/relay logic commanding Y01/Y02/Y03.
- **UNKNOWN:** which valve elements, if any, are credited safety final elements for downward-motion prevention.
- **UNKNOWN:** whether individual spool/seat positions are monitored and how that feedback is evaluated.
- **UNKNOWN:** installed pressure-sensor locations used for safety validation versus ordinary process control.
- **UNKNOWN:** actual ram mass, cylinder areas, trapped volumes, leakage limits, stopping distance, response time, required PL/SIL/category, or diagnostic coverage.
- **UNKNOWN:** whether the machine has an accumulator elsewhere in the installed system and the exact discharge/isolation procedure.
- **UNKNOWN:** the maintenance blocking/restraint hardware and its rated load path.

These items must remain UNKNOWN until machine-specific electrical, hydraulic and maintenance evidence closes them.

## Four physical objectives remain separate

### 1. Remove or control pressure

Stopping the pump or commanding a proportional valve to zero can stop generation of new commanded flow. It does not prove every cylinder volume is depressurized. Closed seats, checks, suction/prefill devices or other restrictions can preserve trapped pressure.

### 2. Prevent unintended flow

A closed blocking/load-holding path can prevent cylinder movement even while pressure remains present. Therefore `pressure present` is not synonymous with `motion possible`, and `pressure zero at one witness` is not proof that every relevant chamber is unpressurized.

### 3. Hold the gravity load

A vertical press member requires a defined load path. Hydraulic holding may intentionally retain pressure. The safe state for a suspended load can therefore require **retaining** hydraulic pressure/closed flow paths rather than simply dumping every line to tank.

### 4. Physically restrain for maintenance

Hydraulic load holding is not automatically equivalent to a maintenance restraint. Work beneath or within a gravity/crush hazard requires the machine-specific approved restraint/isolation method. The public MVD hydraulic drawing does not establish that method.

## End-to-end proof chain for curriculum use

For any claimed safety stop on a hydraulic press, require evidence across all of these layers:

1. protective demand physically changes state;
2. independent safety logic recognizes the demand;
3. safety output changes state;
4. electrically commanded hydraulic final element changes state;
5. valve/seat state is proved where the architecture relies on it;
6. actual fluid path reaches the intended condition;
7. relevant cylinder chambers/load path produce the intended physical ram behavior;
8. diagnostics do not falsely collapse multiple final elements into one common proof path;
9. reset/rearm cannot itself restart hazardous motion;
10. maintenance isolation/restraint is separately verified when personnel enter the hazard.

A LinuxCNC bit, FPGA watchdog, `PWM=0`, `coil current=0`, safety-PLC output bit, or HMI `SAFE` indication can support only the layer it actually observes.

## Failure-path challenge set

### F1 — proportional command is zero but a load path remains

Ordinary control commands zero current. A cylinder-side hydraulic path remains capable of load-driven motion.

**Required conclusion:** command proof is not fluid-state or load-state proof.

### F2 — one valve de-energizes but another path remains open

One electrically commanded element reaches its safe state while a suction/prefill or parallel path does not.

**Required conclusion:** trace the complete path from each cylinder chamber; do not infer system safety from one coil.

### F3 — pressure witness reads zero at the wrong node

A gauge/test point upstream of a closed element reads zero while a trapped cylinder volume remains pressurized.

**Required conclusion:** every credited pressure witness needs a documented relationship to the hazard volume it is claimed to prove.

### F4 — hydraulic holding works but maintenance restraint is absent

The ram remains stationary through hydraulic load holding. A technician enters beneath it.

**Required conclusion:** production load holding is not automatically an approved maintenance blocking system.

### F5 — feedback proves command hardware, not ram physics

EDM/valve feedback indicates a final element changed state, but leakage, a parallel flow path or gravity behavior is not observed.

**Required conclusion:** final-element feedback closes only its documented part of the proof chain.

## OpenPressBrake transfer

Do not copy the MVD valve truth table into OpenPressBrake. Instead require an installed-machine trace containing:

- both cylinder chamber connections;
- suction/prefill paths;
- every check/blocking/load-holding/dump path capable of affecting gravity motion;
- pump and accumulator sources;
- pressure-witness/test points;
- electrical coils and safe-state definitions;
- valve-position/final-element feedback where present;
- safety-controller I/O mapping;
- approved maintenance blocking/restraint;
- physical challenge/validation procedure.

Until those are captured, OpenPressBrake hydraulic safety truth-table values remain **UNKNOWN**.

## Curriculum freeze

A press hydraulic schematic can establish physical connectivity, but it cannot by itself establish the complete personnel-safety architecture. Conversely, an electrical safety diagram cannot prove the hydraulic/gravity result unless its final elements are traced through the actual fluid and load paths.

The required professional-machine review therefore joins **electrical safety logic + hydraulic schematic + physical load path + maintenance restraint + validation procedure** before declaring a hydraulic press hazard controlled.

## Next work

Trace a manufacturer press safety module that explicitly exposes monitored hydraulic safety valves/fall-protection behavior, then build a bounded table of `electrical demand -> valve state/feedback -> hydraulic objective -> physical result -> remaining energy`. Prefer Bosch Rexroth press-module documentation or equivalent authoritative manufacturer evidence. Do not assign those manufacturer states to OpenPressBrake without installed-machine evidence.
