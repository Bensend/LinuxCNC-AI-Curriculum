# Modern press-brake valve-monitoring and final-element trace — 2026-09-16

## Purpose

Extend the professional-machine safety study from legacy complete-machine drawings into a current press-brake safety-controller architecture. This artifact deliberately separates **safety command**, **final-element feedback**, **ordinary proportional control**, and the still-machine-specific **physical hydraulic energy boundary**.

## Evidence scope

Primary manufacturer source: Lazer Safe `PCSS-A Series Technical Manual`, LS-CS-M-046, version 1.25, released 2024-09-12. Public manufacturer support material identifies PCSS-A as an embedded OEM press-brake safety/control integration product.

Evidence class in this artifact is `DOC-CONFIRMED` unless explicitly marked `INFERENCE` or `UNKNOWN`.

## 1. Emergency-stop final-element monitoring

The PCSS-A manual documents an emergency-stop option using an external E-stop contactor. A normally-closed auxiliary contact from that contactor returns to a PCSS safety input. The controller monitors contactor changeover after an emergency-stop condition and treats confirmation of the contactor transition as necessary to establish that press-brake operation has been disabled.

This is an important professional pattern:

`dual safety demand / E-stop logic -> safety output -> external contactor coil -> physical contactor -> NC auxiliary feedback -> safety input`

The output command alone is therefore not accepted as proof of final-element state.

**Boundary:** the PCSS manual establishes monitoring of the contactor but does not, by itself, identify what a particular OEM wires through the contactor's power poles. Whether those poles remove pump-motor power, valve/control power, drive power, or another machine-specific circuit is `UNKNOWN` until the OEM electrical drawing is available.

## 2. Hydraulic final-element monitoring

PCSS-A valve-monitoring options expose per-axis feedback for hydraulic valves rather than merely observing CNC commands. Documented options include monitoring combinations of Y1/Y2 unload, prefill/low-speed/high-speed and safety valves.

One documented valve-zero pattern requires commanded outputs OFF while the corresponding normally-closed monitor contacts indicate the valves are in their off state. Other documented states require the monitor contact to disagree appropriately with an energized solenoid command. This creates a command-versus-final-element-state diagnostic rather than assuming coil command equals spool/valve state.

Representative architecture:

`PCSS safety output -> Y1/Y2 hydraulic solenoid -> valve mechanism -> NC position/monitor contact -> PCSS input`

The manual also documents fault handling for disagreement between commanded and monitored valve states.

## 3. Safety outputs versus ordinary proportional outputs

The PCSS-A manual explicitly distinguishes several hydraulic outputs connected to **safety outputs** from proportional functions connected to **standard outputs**. Examples in supported configurations include high-speed, prefill and safety-solenoid functions on safety outputs, while proportional enable and proportional pressure are standard outputs.

This is strong architecture evidence against treating ordinary proportional command removal as the sole personnel-safety function.

For the LinuxCNC/OpenPressBrake boundary:

- LinuxCNC/FPGA may own normal proportional/current command and ordinary diagnostics.
- A stale-command watchdog may remove normal actuator authority as fault containment.
- Neither action is automatically a personnel-safety function.
- Independent safety logic must reach physical final elements selected from the actual machine hazard analysis and validated architecture.

## 4. Pump-running state is distinct from ram safety permission

Some PCSS-A output logic explicitly includes `hydraulic pump is running` as a prerequisite while independently enabling hydraulic safety outputs. Therefore, professional press-brake architecture can distinguish:

1. hydraulic power generation available;
2. ordinary proportional command available;
3. safety-valve path permitted;
4. ram movement permitted.

It is invalid to collapse these into one boolean called `machine enabled`.

This does **not** prove that an E-stop leaves the pump running on every PCSS-equipped machine. The OEM electrical design determines the E-stop contactor load and pump-starter behavior.

## 5. Level-limit recovery demonstrates restricted recovery motion

The manual documents an out-of-level emergency-stop condition in which down movement is prohibited but reset-held upward movement can be allowed to re-level the beam. This is useful evidence that professional safety implementations can define a restricted recovery state rather than treating every safety demand as an undifferentiated all-power-off state.

That behavior must not be copied generically: the allowable direction, enabling device/reset behavior, hydraulic architecture, speed and risk controls are machine-specific and require validation.

## 6. Final-element proof hierarchy

The combined professional references now support this teaching hierarchy:

| Evidence | What it proves | What it does NOT prove |
|---|---|---|
| CNC command = zero | ordinary controller requested zero | valve moved, energy removed, ram held |
| FPGA output disabled | normal electronic authority removed | safety-rated state |
| Safety output OFF | safety controller commanded safe state | contactor/valve physically changed state |
| Contactor auxiliary feedback | monitored contactor mechanism changed state | exact downstream energy removed without wiring trace |
| Valve monitor contact | monitored valve reached expected monitored state | complete ram safety without hydraulic schematic/validation |
| Main disconnect open/locked | defined electrical isolation boundary | gravity/stored hydraulic/mechanical energy controlled |
| Ram physically blocked | mechanical descent path restrained for the stated task | electrical/hydraulic isolation by itself |

## 7. Failure paths to teach

### Welded/stuck external contactor
Safety logic commands the contactor off; NC feedback does not transition as expected. Professional pattern: detect disagreement and inhibit/reject normal operation/rearm. Exact PCSS timing and OEM response remain configuration-specific.

### Hydraulic solenoid command changes but monitored valve does not
Command and monitor state disagree. Professional pattern: valve-monitoring logic detects the mismatch rather than trusting the electrical command. The actual hydraulic consequence must be determined from the machine circuit.

### Ordinary proportional output stuck or stale
This can create hazardous normal-control behavior, but a professional architecture should not make the ordinary proportional path the only independent means of preventing hazardous movement. Safety authority and final elements remain separate.

### Monitor contact falsely indicates state
A single monitor contact is evidence, not magical proof of all hydraulic behavior. Required diagnostic coverage/redundancy/performance level cannot be inferred from this manual excerpt alone and must be established by the actual safety design and validation.

## 8. Practical human-factors lesson

A safe architecture should provide intentional reset/recovery/service states so operators and maintainers are not pushed toward defeating guards or jumpering safety inputs simply to recover a machine. Recovery authority must be narrower than production authority and must not automatically restart hazardous motion.

For maintenance, E-stop and monitored valve states are not substitutes for task-specific isolation, stored-energy control and ram blocking where gravity/mechanical descent remains a hazard.

## Claims ledger

| Claim | Class | Confidence |
|---|---|---:|
| PCSS-A can monitor an external E-stop contactor through NC auxiliary feedback | DOC-CONFIRMED | High |
| PCSS-A supports monitoring Y1/Y2 hydraulic valve final elements | DOC-CONFIRMED | High |
| Supported PCSS-A configurations separate safety hydraulic outputs from standard proportional outputs | DOC-CONFIRMED | High |
| Pump-running state can coexist with independently controlled hydraulic safety permission | DOC-CONFIRMED | High |
| Therefore every PCSS machine leaves its pump running during E-stop | REJECTED GENERALIZATION | High |
| Exact physical energy removed by an OEM E-stop contactor | UNKNOWN without OEM drawing | High |
| Exact safe hydraulic truth table for OpenPressBrake | UNKNOWN; machine-specific | High |
| PL/SIL/category/stopping distance implied by these snippets | UNKNOWN / must not infer | High |

## Next evidence target

1. Obtain a modern OEM electrical drawing showing the PCSS E-stop contactor's actual power poles and pump/valve/drive loads.
2. Pair it with that exact machine's hydraulic schematic and mark every Y1/Y2 safety/holding/prefill element.
3. Perform the two independent traces from `COMPLETE_MACHINE_SAFETY_TRACE_WORKSHEET.md` and overlay them.
4. Separately trace one modern servo machine tool from guard/E-stop through SS1/STO/contactors/brake to motor and DC-bus/mains state.

No simulation is justified by the remaining questions; they are documentary and machine-specific.
