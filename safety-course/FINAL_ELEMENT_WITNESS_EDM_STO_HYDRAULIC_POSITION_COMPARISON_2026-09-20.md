# Final-element witness comparison — EDM, drive STO status, hydraulic position monitoring

Date: 2026-09-20

## Purpose

Continue the 4000 safety course from the current final-element checkpoint. The central question is not whether a controller has a status bit; it is **what physical fact the witness actually establishes, and what hazardous state remains unproved**.

## Evidence classes

### 1. Electrical contactor EDM — existing course baseline

Existing Rockwell/Pilz course evidence establishes that positively guided external-device feedback can inhibit restart when monitored contactors do not return to the expected de-energized state.

**DOC-CONFIRMED:** EDM is downstream feedback about the monitored switching element rather than proof that the safety controller merely issued an OFF command.

Freeze already preserved:

`SAFETY OUTPUT COMMANDED OFF != CONTACTOR COIL DE-ENERGIZED != POWER CONTACTS PHYSICALLY OPEN`

and

`EDM FEEDBACK CLOSED != ALL HAZARDOUS ENERGY REMOVED`.

### 2. Drive STO/status feedback

Siemens SINAMICS Safety Integrated commissioning documentation states that STO safely suppresses torque-generating energy in the drive, but explicitly states that the power unit and motor are **not electrically isolated**. It also warns that a motor may still coast/move after STO and calls for suitable measures such as a safety-monitored brake where undesirable movement remains hazardous. STO status is exposed through safety status parameters.

Rockwell ArmorKinetix documentation similarly separates the safety request/output from `STO Active` and the later physical-control state `Torque Disabled`. Rockwell's current Safety Device Library even exposes a `Waiting on Torque Off Status` condition when STO Active is asserted but Torque Disabled is not yet true. PowerFlex 755 documentation exposes `SI.TorqueDisabled`, `SI.SafetyFault`, `SI.ResetRequired`, drive start inhibit, and STO-active state separately.

**DOC-CONFIRMED:** a drive can provide a witness stronger than "STO was requested": safety function active and/or torque-disabled status.

**DOC-CONFIRMED:** STO is not an electrical isolator and does not prove shaft standstill, gravity-axis retention, brake engagement, absence of stored energy, or that the machine cannot move from external/mechanical forces.

Freeze:

`STO REQUESTED != STO ACTIVE != TORQUE DISABLED != AXIS STATIONARY != LOAD RETAINED != ELECTRICAL ENERGY ISOLATED`.

A LinuxCNC or ordinary FPGA status bit mirroring a drive's status is useful for diagnostics/orchestration, but must not be promoted into independent personnel-safety authority unless the complete safety architecture and communication path are designed and validated for that role.

### 3. Brake feedback shows why one witness is not enough

Rockwell's safety brake-control documentation distinguishes brake output commands from Brake Feedback 1/2 and a derived Brake Engaged state. After outputs change, feedback is checked after a defined delay and must be in the expected opposite state.

**DOC-CONFIRMED:** safety architectures may independently monitor the mechanical brake path instead of treating torque-off as proof of load retention.

Freeze:

`TORQUE DISABLED != BRAKE COMMANDED ENGAGED != BRAKE FEEDBACK VALID != BRAKE HELD REQUIRED LOAD`.

The last step remains a physical-performance question. Feedback contacts or status do not by themselves prove holding torque under the actual load.

### 4. Hydraulic spool/neutral-position monitoring

HAWE documents directional spool valves with inductive neutral-position monitoring and, in its EMMA architecture, a digital neutral-position signal transmitted to a higher-level controller. Bosch Rexroth likewise describes hydraulic safety architectures using valves with integrated spool-position monitoring and/or pressure sensors.

**DOC-CONFIRMED:** hydraulic architectures can provide a physical-position witness downstream of an electrical valve command.

**INFERENCE, bounded:** a correctly engineered independent position sensor can detect some command-versus-spool discrepancies that coil-current or command-state monitoring cannot.

**UNKNOWN unless the specific valve/system safety manual establishes it:** diagnostic coverage, PL/SIL contribution, exact fault reaction, restart inhibition, sensor independence, and whether a particular OpenPressBrake valve is suitable for a safety-related control function.

Freeze:

`VALVE COMMAND OFF != SOLENOID DE-ENERGIZED != SPOOL/POPPET IN EXPECTED POSITION != HYDRAULIC FLOW BLOCKED != PRESSURE REMOVED != RAM PHYSICALLY STOPPED/RETAINED`.

Position feedback proves position only to the limits of the sensor/valve architecture. It does not prove a valve seat seals, an internal leakage path is absent, a companion path is closed, trapped pressure is discharged, or a load is retained.

## Cross-domain witness ladder

The reusable lesson is to keep each evidence layer explicit:

1. **Safety demand** — protective function requests safe state.
2. **Safety output/request** — controller commands final element.
3. **Actuator/function status** — contactor feedback, STO active/torque disabled, valve position, brake feedback.
4. **Energy-path state** — relevant electrical/hydraulic/mechanical energy path is actually interrupted/controlled.
5. **Physical machine response** — axis stopped, load retained, pressure relieved, hazardous motion prevented as required.
6. **Performance acceptance** — stopping time/distance, holding performance, pressure, timing, or other design-specific criterion is satisfied.
7. **Restart/rearm** — faults cleared, safeguards restored, personnel clear, safety reset/requalified, fresh ordinary start.

No upstream layer may be silently substituted for a downstream one.

## OpenPressBrake design implication

Do not build a single generic `SAFE=true` bit from heterogeneous status inputs. Preserve provenance in diagnostics and architecture: e.g. `STO requested`, `STO active`, `torque disabled`, `brake feedback`, `hydraulic valve position`, `pressure witness`, `ram motion witness`. The independent safety design decides which combination is authoritative for a specific safety function; LinuxCNC/normal FPGA may display/log the states without becoming the personnel-safety authority.

For a gravity/hydraulic press axis, STO alone is categorically insufficient evidence of safe physical retention. Hydraulic final-element position alone is also insufficient. Required proof must follow the actual hazard and energy paths.

## Source provenance

- Siemens, *Safety Integrated Commissioning Manual*, STO section: STO pulse suppression, status parameters, explicit statement that power unit/motor are not electrically isolated, and warnings about coast/unwanted motion. DOC-CONFIRMED.
- Rockwell Automation, *ArmorKinetix Safe Monitor Functions Safety Reference Manual*, June 2023: STO Output, STO Active and torque removal are separate states. DOC-CONFIRMED.
- Rockwell Automation, *Safety Device Library*, September 2025: `Waiting on Torque Off Status` when STO Active is true while Torque Disabled is false. DOC-CONFIRMED.
- Rockwell Automation, *PowerFlex 755 Integrated Safety — Safe Torque Off Option Module User Manual*, January 2025: separate TorqueDisabled, SafetyFault, ResetRequired, STO Active and Start Inhibit states. DOC-CONFIRMED.
- Rockwell Automation, *Logix 5000 Controller Safety Application Instruction Set*, September 2025: brake outputs, brake feedback and Brake Engaged state are separately evaluated. DOC-CONFIRMED.
- HAWE Hydraulik, EMMA / directional spool documentation: digital/inductive spool or neutral-position monitoring. DOC-CONFIRMED for product capability only.
- Bosch Rexroth, hydraulic manifold guidance: position-monitored shut-off/relief functions and integrated spool-position monitoring/pressure sensors can participate in machine-specific safety architectures. DOC-CONFIRMED at architecture level only.

## Information-gain boundary / next work

The comparison question is answered adequately from authoritative manufacturer documentation; no simulation is justified. Next high-value work should trace a complete **drive STO + mechanical brake/gravity axis** restart/fault sequence or a complete **hydraulic position-monitor + physical pressure/motion witness** sequence, emphasizing mismatch disposition and fresh restart authority. Do not search generic status-bit tables merely to accumulate examples.
