# Piranha 200 Ton Press Brake — complete electrical/hydraulic energy-boundary trace

Date: 2026-09-16
Status: RESEARCH / DOCUMENT-CONFIRMED reference implementation
Scope: historical OEM implementation study, **not** a template for a new safety design.

## Why this reference matters

The Piranha 200 Ton Press Brake Operator/Owners Manual is unusually valuable because one OEM document contains operating behavior, electrical drawings, electrical parts, a hydraulic valve-block drawing, and hydraulic schematics. It therefore permits the safety course to trace an E-stop from the operator device toward the physical energy source instead of stopping at a safety-controller symbol.

Primary source: Piranha 200 Ton Press Brake Operator / Owners Manual, Mega Manufacturing / Piranha, drawing set around 2003. Public PDF: https://piranhafab.com/pdf/manual/T2584-5_200-12PB_GenII-Garfil-Fluidtech_Manual.pdf

Important limitation: this is a legacy machine architecture. Its existence is evidence of how this machine was implemented, **not evidence that the architecture satisfies current press-brake safety requirements or should be copied into OpenPressBrake**.

## Evidence trace

### 1. Operator-described E-stop behavior

**DOC-CONFIRMED:** The manual states that pressing E-stop removes power from the hydraulic power unit, and more specifically says the maintained E-stop removes electrical power from the hydraulic power-unit drive motor and all base-machine control circuits, stopping machine movement. Releasing/resetting the mushroom alone does not constitute permission to move; machine movement cannot resume until the E-stop is reset.

The same manual distinguishes the main safety disconnect from the E-stop and instructs maintenance personnel to lock out main electrical power at the safety disconnect.

### 2. Electrical drawing — where pump power is physically interrupted

Electrical Diagram 1 of 4 shows:

- incoming three-phase L1/L2/L3;
- a three-pole disconnect;
- three motor short-circuit fuses;
- three M1 main contacts in series with the hydraulic motor phases;
- overload elements;
- hydraulic motor M1;
- a control transformer / 24-VDC supply;
- E-STOP and START in the low-voltage start/control chain;
- relay R1 and motor starter coil M1;
- an M1 auxiliary seal-in contact;
- an M1 overload contact in the control return.

**DOC-CONFIRMED:** The physical pump-motor energy boundary is therefore the M1 motor starter's three power contacts. When the M1 coil drops out, those contacts open the three-phase feed to the hydraulic pump motor. The E-stop itself is not carrying the 20-hp motor current; it acts in the low-voltage control path that causes the starter to release.

**DOC-CONFIRMED:** The main disconnect is a separate upstream device and is the manual's maintenance lockout point. Therefore `E-stop` and `maintenance electrical isolation` are distinct states even on this relatively simple machine.

### 3. Ordinary machine control and hydraulic outputs

Electrical Diagram 2 of 4 shows the Generation II control connected to ordinary outputs for DOWN, TONNAGE, SPEED, UP, REGEN, bypass and other solenoids. Optional light-curtain contacts enter the Generation II control. The drawing also exposes foot-switch and dual-palm inputs.

**DOC-CONFIRMED:** These ordinary control outputs energize hydraulic solenoids; the machine's normal ram sequencing is therefore electrically commanded through the Generation II controller.

**UNKNOWN / DO NOT INFER:** This legacy drawing does not by itself establish a modern redundant safety architecture, diagnostic coverage, PL/SIL, monitored hydraulic final elements, or current press-brake compliance. The optional light-curtain contacts entering the normal controller must not be generalized into a recommended modern architecture.

### 4. Hydraulic energy path

The same OEM manual includes the hydraulic valve block and hydraulic schematic. The schematic shows the electric motor/pump as the pressure source feeding the valve system and cylinder. Multiple electrically operated valves implement approach, pressing/tonnage, speed, return and related functions.

**DOC-CONFIRMED:** Dropping M1 removes continuing pump drive and therefore removes the active hydraulic power source supplied by the electric motor/pump.

**IMPORTANT BOUNDARY:** Removing pump drive does **not** logically prove that every hydraulic line instantaneously becomes zero pressure or that gravity/stored hydraulic energy cannot move the ram. The manual itself tells service personnel to **block the ram and turn power off** before servicing the hydraulic system. That is direct OEM evidence that electrical power-off is not treated as sufficient maintenance protection against the ram hazard.

This is a high-value teaching point: `pump motor electrically disconnected` != `all hazardous mechanical/hydraulic energy physically absent`.

## End-to-end E-stop trace

For this specific historical machine, the supported trace is:

`E-stop operator`
→ low-voltage start/control chain opens
→ R1/M1 run authority drops
→ M1 starter coil de-energizes
→ M1 three-pole power contacts open
→ three-phase power to hydraulic pump motor is interrupted
→ pump ceases supplying driven hydraulic power
→ normal solenoid-controlled ram operation loses its active hydraulic source.

The OEM also describes base-machine controls as losing electrical power on E-stop, but the exact scope of every control branch should be read from the complete drawing rather than paraphrased as 'all electricity is gone.' Incoming mains remain present upstream of the contactor unless the separate main disconnect is opened.

## What remains after E-stop

| Item | Supported state after E-stop | Evidence status |
|---|---|---|
| Incoming machine mains upstream of M1 | May remain energized while main disconnect remains ON | DOC-CONFIRMED from topology |
| M1 hydraulic pump motor | Three-phase feed interrupted by released M1 starter | DOC-CONFIRMED |
| Continuing pump-generated hydraulic power | Removed when motor stops | DOC-CONFIRMED / physical consequence |
| Stored/trapped hydraulic pressure | Not proven absent | UNKNOWN; must not assume |
| Gravity / ram mechanical hazard | Not proven absent | DOC-CONFIRMED maintenance implication: block ram |
| Main electrical isolation for maintenance | Not achieved merely by E-stop; use safety disconnect/lockout | DOC-CONFIRMED |
| Normal valve command authority | Machine described as stopping base controls; exact branch-by-branch state requires drawing trace | DOC-CONFIRMED with bounded scope |

## Maintenance-state lesson

The manual's maintenance instructions are unusually aligned with the safety-course human-factors rule:

1. For hydraulic service, block the ram and turn power off.
2. For filter service, lock out main electric power at the safety disconnect.

This demonstrates two independent hazard controls:

- **electrical isolation** at a lockable upstream disconnect;
- **mechanical restraint** of the gravity-capable ram.

An E-stop is an operational protective function, not a substitute for either maintenance control.

## Comparison to newer professional architectures

This historical machine is useful precisely because it contrasts with the newer Lazer Safe / HAWE / safe-motion examples already studied.

- Piranha legacy architecture: E-stop drops the hydraulic pump motor starter and base controls; maintenance additionally requires main disconnect lockout + ram blocking.
- Modern safe-drive architecture: STO may remove torque-producing capability while leaving drive mains energized.
- Modern press-brake hydraulic safety architecture: safety controllers may independently command and monitor hydraulic safety/holding valves while the pump can remain running.

Therefore there is no universal rule that `E-stop = remove all machine power` or `E-stop = stop pump`. The correct question is always: **which final elements establish the validated safe state for this machine, and what energy remains?**

## Open questions / next evidence

1. Obtain a newer CNC press-brake OEM drawing pair where the safety controller, redundant hydraulic safety valves, valve monitoring and pump contactor are all visible in the same machine documentation.
2. Trace a modern servo machine tool with guard/E-stop → safety logic → SS1/STO/contactors/brake → motor and document what DC bus/mains remains energized.
3. Build the reusable course worksheet around two simultaneous traces: safety-control chain and physical-energy chain.
4. Do not assign a current safety category/PL/SIL to this Piranha architecture without a design-specific assessment and applicable-version evidence.

## Curriculum takeaway

A complete diagram pair changes the question from 'does E-stop turn the machine off?' to a precise engineering statement:

> On this machine, E-stop removes the low-voltage run chain that holds the M1 hydraulic-pump starter in; M1's three main contacts then interrupt pump-motor power. The main supply upstream of that starter can remain live, and the OEM still requires the ram to be mechanically blocked and the main disconnect locked out for hydraulic service.

That level of traceability is the target for every professional-machine reference in the safety course.
