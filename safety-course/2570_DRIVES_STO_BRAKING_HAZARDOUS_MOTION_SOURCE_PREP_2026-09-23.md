# 2570 — Drives, STO, braking, and hazardous motion — source preparation

## Purpose

Teach drive safety functions from the hazardous-motion proposition outward. Do not reduce the subject to “STO terminals make a drive safe.”

## First boundary: torque is not motion and STO is not isolation

**DOC-CONFIRMED:** Rockwell Automation's January 2025 PowerFlex 755 Integrated Safety STO manual states that STO disables power transistors so torque-producing switching probability is sufficiently low for the stated integrity capability and that the motor then coasts. It also explicitly states that STO does not provide electrical safety/isolation and is not to be used as ordinary start/stop control.

Rockwell additionally warns that stored energy under specified output-IGBT failure conditions can permit limited motor rotation after STO is commanded, and its current PowerFlex safety documentation warns that suspended loads, pump/fan back-pressure or other mechanical forces can rotate the motor with STO active.

Sources:
- Rockwell Automation, PowerFlex 755 Integrated Safety — Safe Torque Off Option Module User Manual, publication 750-UM004I-EN-P, January 2025.
- Rockwell Automation PowerFlex 755T Safe Stop Functional Safety documentation.

**Freeze:** STO ACTIVE != SHAFT STANDSTILL.

**Freeze:** STO ACTIVE != ELECTRICAL ISOLATION.

**Freeze:** TORQUE REMOVED != GRAVITY OR EXTERNAL FORCE CONTROLLED.

## STO versus safe stopping functions

**DOC-CONFIRMED:** Siemens SINAMICS safety documentation distinguishes:

- STO — safe torque off;
- SS1 — safe stopping process associated with Stop Category 1;
- SS2 — safe stopping process associated with Stop Category 2;
- SOS — safe monitoring of standstill position;
- SBC — safe brake control;
- SLS/SSM/SDI and other monitored-motion functions.

Current SINAMICS G220 product information likewise lists integrated STO and SS1-t separately from extended SS1, SS2, SLS, SSM, SDI and SOS functions. This separation is evidence that “drive safety” is a family of functions selected from the machine hazard/SRS, not a synonym for STO.

Sources:
- Siemens SINAMICS Safety Integrated documentation and current SINAMICS G220 product documentation.

**Freeze:** STO != SS1 != SS2 != SOS.

## Gravity and suspended loads

A vertical or gravity-loaded axis exposes the weakness in treating loss of motor torque as a complete safe state. If gravity can move the load, the SRS may require a holding/braking/restraint proposition in addition to torque removal. The actual brake architecture, brake-test interval, stopping distance, load behavior and safe-state timing are machine-specific and remain `UNKNOWN` until measured or documented.

Safe Brake Control (SBC) is evidence of a safe command path for a brake only under the manufacturer's stated conditions; it does not by itself prove brake mechanical capacity, brake engagement, stopping distance, wear state, or that a suspended load is physically restrained.

**Freeze:** SAFE BRAKE COMMAND != LOAD PHYSICALLY RESTRAINED.

## Coast stop versus controlled stop

If the hazard permits coasting after torque removal, STO may be part of the required architecture. If access can occur before coast-down reaches the required safe condition, the machine needs another safety measure: for example a controlled safe stop before torque removal, guard locking until the hazard has ceased, or another validated architecture.

Do not choose stop behavior from convenience. Derive it from the hazard and safe-state proposition.

**Freeze:** FASTEST POWER REMOVAL != SHORTEST OR SAFEST MACHINE STOP IN EVERY MECHANISM.

## Contactors and ordinary-drive fallback

Where a drive lacks certified STO, removing motor/drive power with appropriately selected and monitored final elements can be part of a safety architecture, but it is not automatically equivalent to integrated STO. The design must address actual switching duty, stored DC-bus energy, restart behavior, contact welding/feedback, stop behavior, isolation requirements and the integrity evidence available for the complete function.

A contactor ahead of a drive may remove source power while the DC bus remains energized for a discharge interval. A contactor between drive and motor introduces its own switching/application constraints and must not be assumed safe for arbitrary opening under load. These are design-specific questions, not universal recipes.

## LinuxCNC boundary

LinuxCNC may request normal deceleration, remove normal enable, observe drive safety status, inhibit commands and display diagnostics. Those functions are useful integration behavior. Unless separately justified as part of a safety-rated architecture, ordinary LinuxCNC/HAL/normal FPGA control does not own STO, safe-stop timing, safe brake authority or personnel-safety validation.

A robust architecture can let normal control cooperate with a safety demand while the independent safety path remains able to force the required safe state if normal control fails.

## Evidence ledger

- PowerFlex STO disables torque-producing switching and produces coast behavior under the documented architecture: `DOC-CONFIRMED`.
- PowerFlex STO does not provide electrical isolation and can leave motion possible from external mechanical forces: `DOC-CONFIRMED`.
- SINAMICS distinguishes STO, SS1, SS2, SOS, SBC and monitored-motion functions: `DOC-CONFIRMED`.
- A particular machine requires STO, SS1, SS2, SOS, SBC, guard locking or contactor isolation: `UNKNOWN` until its hazard/SRS and physical evidence establish the requirement.
- Any machine-specific stopping time, brake capacity, brake engagement time, coast time, gravity-load behavior, safe distance or residual DC-bus discharge time: `UNKNOWN` unless measured/documented for that design.

## Next evidence-gain work

Map one current servo/VFD manual's safety functions into a machine-level architecture and trace each function to the physical proposition it does and does not establish. Then build the syllabus-required low-cost ordinary-drive fallback architecture with explicit limitations, without claiming certification or inventing stopping/brake data.

No executable compute is justified for this source-tracing step.
