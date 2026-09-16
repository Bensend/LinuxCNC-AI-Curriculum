# Professional Press-Brake Safety Trace 02 — Lazer Safe PCSS-F/L

Date: 2026-09-16
Status: DURABLE REFERENCE / DOCUMENTATION STUDY
Evidence class: primarily `DOC-CONFIRMED`; machine-specific hydraulic mapping remains `UNKNOWN` until paired with an OEM hydraulic drawing.

## Why this reference matters

Lazer Safe's PCSS-F/L technical manual is unusually valuable because it exposes a professional press-brake safety controller at the wiring/function level rather than only describing a guarding product. It includes dual emergency-stop channels, door inputs, monitored emergency-stop/auxiliary contactor outputs, direct safety outputs for press-brake hydraulic solenoids, valve-position monitoring options, reset behavior, and multiple hydraulic-output personalities.

Source: Lazer Safe, *PCSS-F and L Series Technical Manual*, LS-CS-M007, rev 1.66, released 2013-12-03. Public manual: https://support.lazersafe.com/assets/files/Manuals-and-Guides/Registered-users/ls-cs-m-007-pcss-f-and-l-series-technical-manual-1-66.pdf

## End-to-end professional pattern

The manual supports the following generic trace. This is a system pattern, not a claim that every PCSS-equipped brake uses the same option set:

`E-stop / side-rear guard channels -> PCSS safety logic -> emergency-stop/auxiliary contactor + hydraulic safety outputs -> monitored contactor/valve state -> press hydraulic final elements -> ram motion boundary`

The ordinary CNC supplies normal process requests such as up/down/decompression. The PCSS independently decides whether required safety conditions permit the safety outputs. This is a useful model for LinuxCNC integration: LinuxCNC may provide ordinary motion/process requests and consume status, but personnel-safety permission belongs in the independent safety layer.

## 1. E-stop input architecture

`DOC-CONFIRMED`: PCSS emergency-stop options use two safety input channels. The manual's state table treats both channels closed as normal, both open as a valid E-stop, and either disagreement state (closed/open or open/closed) as a fault that also produces an E-stop condition (manual p. 12-4 / PDF p.147).

This is more than a series string that merely removes a PLC input. Channel disagreement is itself a detected safety fault.

## 2. E-stop final electrical element

`DOC-CONFIRMED`: the PCSS drives an auxiliary-axis / emergency-stop contactor from a safety output. The manual says this contactor is used to control the press brake's emergency-stop circuit requirements so associated operation is disabled and pressing-beam control/movement is prevented. A normally-closed contact from the contactor returns to a PCSS safety input; the controller monitors that the contactor changes state within an acceptable time (sections 12.1.4 / 12.8.4).

This is the professional EDM pattern we were looking for:

`PCSS safety output -> contactor coil -> machine operational power/enable circuit`

plus

`contactor NC feedback -> PCSS safety input`

Important boundary: the Lazer Safe manual defines the safety-controller/contact interface but does **not** define which physical conductors the OEM routes through that contactor. Therefore `what electrical power is physically removed by that contactor` is `UNKNOWN` until the machine's OEM electrical schematic is inspected. Do not infer that it necessarily removes main incoming power, pump motor power, all control power, or drive DC-bus power.

## 3. Hydraulic safety outputs are first-class final elements

`DOC-CONFIRMED`: multiple PCSS down-enable personalities directly provide safety outputs for hydraulic functions. Depending on option, named outputs include high-speed, prefill/filler, safety Y1/Y2, holding, decompression and up solenoids. Some proportional enable/pressure signals are explicitly standard outputs rather than safety outputs.

A particularly informative example is Down Enable Option 19 (manual pp. 11-23 to 11-24):

- high-speed solenoid: safety output;
- filler solenoid: safety output;
- decompression and holding solenoids: safety outputs;
- safety solenoid: safety output;
- proportional-pressure command: standard output;
- proportional-enable command: standard output.

The safety outputs are conditional on PCSS down-enable/up state, while the proportional signals remain ordinary control outputs. This is a concrete professional example of **separating normal proportional control from the hydraulic safety permission path**.

Another option provides separate safety-solenoid outputs for Y1 and Y2. This reinforces that a dual-cylinder brake can have safety authority reaching the hydraulic final elements independently of the normal proportional command.

## 4. Valve monitoring / proof of final-element state

`DOC-CONFIRMED`: Valve Monitoring Option 1 monitors normally-closed contacts associated with high-speed, prefill and safety valves. Separate safety-valve monitoring is provided for Y1 and Y2. The PCSS compares commanded solenoid state with monitor state and flags switch-on or switch-off faults when they disagree.

Other valve-monitoring personalities cover proportional Y1/Y2, safety Y1/Y2, high-speed and prefill combinations. This means the professional architecture does not stop at `we de-energized the coil`; it can obtain an independent valve-state indication and compare command with physical/auxiliary feedback.

`IMPORTANT LIMIT`: a valve monitor contact proves only what the installed monitored valve/sensor architecture is designed to prove. It is not automatically proof of zero cylinder pressure, zero stored hydraulic energy, zero ram force or mechanical restraint.

## 5. Pump-running state is not synonymous with safety permission

`DOC-CONFIRMED`: several down-enable options explicitly require `hydraulic pump is running` as one prerequisite for particular outputs. Therefore the architecture supports a machine where the pump can remain running while safety logic independently denies hazardous ram movement by removing hydraulic safety permissions.

This is a key curriculum correction to simplistic `E-stop = switch pump off` reasoning. A professional brake can separate:

1. hydraulic power generation (pump running),
2. ordinary proportional command,
3. safety-rated permission to establish the hydraulic flow path,
4. monitored state of safety-relevant valves,
5. actual ram movement.

Whether a particular OEM also drops the pump contactor on E-stop is machine-specific and remains `UNKNOWN` until its electrical schematic is traced.

## 6. Reset/restart behavior is option-specific

`DOC-CONFIRMED`: PCSS emergency-stop personalities differ in re-enable behavior. For example, one documented option requires the error-reset switch before the auxiliary-axis contactor is reactivated, while another can reactivate the contactor once the E-stop condition is absent without that reset requirement. Therefore reset/restart behavior must be treated as part of the complete safety-function design, not assumed from the E-stop button alone.

For OpenPressBrake curriculum purposes, preserve the stronger generic rule: clearing the initiating device must not be confused with an ordinary machine-cycle start. Exact required reset/rearm behavior must come from the selected safety architecture and risk assessment.

## 7. What loses power, what may remain energized

| Element | What this reference establishes | Evidence |
|---|---|---|
| PCSS emergency-stop/auxiliary contactor coil | Safety output can de-energize it on E-stop/fault | DOC-CONFIRMED |
| OEM circuits switched by that contactor | Not defined by this manual | UNKNOWN |
| Main machine disconnect / incoming mains | Not claimed to open on E-stop | UNKNOWN / do not infer |
| Hydraulic pump motor | Manual supports logic where pump-running is a separate state; exact E-stop treatment is OEM-specific | DOC-CONFIRMED + UNKNOWN mapping |
| High-speed / filler / holding / decompression / safety valves | Certain PCSS personalities drive these from safety outputs | DOC-CONFIRMED |
| Y1/Y2 safety valve state | Certain personalities monitor separate Y1/Y2 valve feedback | DOC-CONFIRMED |
| Proportional enable/pressure | Some personalities use standard rather than safety outputs | DOC-CONFIRMED |
| Ram mechanically unable to move | Requires the actual hydraulic circuit, valve fail state, pressure sources, gravity/load analysis and validation | UNKNOWN from PCSS manual alone |

## 8. Failure-path lessons

### One E-stop channel changes, the other does not
PCSS classifies the channel disagreement as a fault/E-stop condition rather than accepting a single apparently healthy channel. `DOC-CONFIRMED`.

### Emergency-stop contactor commanded off but feedback does not change
The NC feedback path is monitored and expected to change within an acceptable time. This is a final-element failure detection path rather than command-only diagnostics. `DOC-CONFIRMED`.

### Hydraulic solenoid command and monitor disagree
Valve-monitoring options define switch-on and switch-off faults when command/monitor combinations disagree. `DOC-CONFIRMED`.

### Normal CNC requests motion while safety permission is absent
The down-enable condition is a prerequisite before safety outputs permitting down motion are asserted. The CNC request alone is therefore not sufficient authority. `DOC-CONFIRMED` at PCSS interface level.

### PCSS output is off, therefore cylinder is safe
Rejected. Without the OEM hydraulic drawing and validated valve fail-state behavior this conclusion is unsupported. `UNKNOWN`.

## 9. Translation to LinuxCNC/OpenPressBrake architecture

The transferable pattern is not `copy the PCSS wiring`. It is:

- ordinary LinuxCNC/FPGA control requests motion/process state;
- an independent safety system evaluates E-stops, guards/protective devices and required feedback;
- safety-rated outputs own the safety permission to the hazardous final elements;
- normal proportional/current commands do not bypass that permission;
- contactor/valve feedback returns to the safety system where required;
- LinuxCNC may monitor the resulting state for diagnostics but is not promoted to personnel-safety authority;
- electrical and hydraulic drawings must be traced together before claiming where hazardous energy is actually removed or contained.

## 10. Human-factors / maintenance implication

A machine can remain electrically and hydraulically energized in portions of the system even when ram motion is safety-inhibited. Therefore `E-stop pressed` is not a maintenance isolation statement. Before hands-on work, remove/control the hazards relevant to the task. If the machine is left unsafe/incomplete/bypassed, leave it unmistakably OUT OF SERVICE / DO NOT OPERATE; tag-out communicates state but does not replace physical hazard control.

## 11. Unresolved machine-level evidence

The next evidence target is still a complete OEM press-brake electrical + hydraulic drawing pair. Specifically we need to resolve:

1. exactly what circuits the auxiliary E-stop contactor interrupts;
2. whether the pump motor contactor is dropped for E-stop, guard opening, light-curtain demand, or only selected faults;
3. exact de-energized states of the Y1/Y2 safety/holding/prefill valves;
4. the physical hydraulic path that prevents gravity/pressure-driven ram motion;
5. what pressure can remain trapped after a protective stop/E-stop;
6. whether valve monitor contacts are spool-position switches, separate pressure/position sensing, or another OEM implementation;
7. how the OEM separates protective stop, E-stop, normal stop, maintenance isolation and main disconnect.

Do not invent these from the PCSS option names.

## Source provenance

- Lazer Safe, PCSS-F and L Series Technical Manual LS-CS-M007 rev 1.66: https://support.lazersafe.com/assets/files/Manuals-and-Guides/Registered-users/ls-cs-m-007-pcss-f-and-l-series-technical-manual-1-66.pdf
- Lazer Safe safety-controller overview (current product context): https://www.lazersafe.com/press-brakes/oem/safety-controllers
- Lazer Safe support explicitly notes OEM embedded systems are tailored/custom-integrated by manufacturer, reinforcing why controller documentation cannot substitute for the OEM machine schematic: https://support.lazersafe.com/products/oem

No simulation was required for this study; the open questions are documentary/machine-specific rather than computational.
