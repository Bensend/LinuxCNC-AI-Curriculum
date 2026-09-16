# Professional safety pattern — reset, restart interlock, EDM and rearm

Date: 2026-09-16
Status: DURABLE SAFETY-COURSE REFERENCE

## Purpose

This note separates four concepts that are often incorrectly collapsed into one: removal of the safety demand, reset of the protective device/safety function, proof that downstream final elements actually reached their expected state, and the later command that starts machine motion. The distinction matters directly to LinuxCNC/OpenPressBrake because an ordinary CNC `machine on`, FPGA watchdog recovery, or proportional-valve re-enable must not silently become the personnel-safety reset/restart authority.

## Evidence

### SICK — reset is not start

**DOC-CONFIRMED.** SICK's Safeguard Detector / Flexi Soft documentation defines reset as returning the protective device to its monitoring state after a stop command. The stopped state is maintained until reset, and machine restart occurs only in a second step. SICK explicitly states that reset itself must not introduce movement or a dangerous situation; a separate start command is required. Automatic reset is restricted to cases where presence in the hazardous area without detection is not possible, or where absence of people can otherwise be assured.

Source: SICK `Safeguard Detector, Flexi Soft variant`, operating instructions 8019465/178R/2021-05-26, glossary entries Reset / Restart interlock / External device monitoring.

### SICK — EDM proves downstream contactor state

**DOC-CONFIRMED.** SICK UE440/UE470 documentation says EDM cyclically checks the contactors connected to an OSSD after each switch-off and before restart. A fused contact can therefore prevent restart. With the internal restart interlock active, an EDM fault leaves the assigned OSSD off and indicates reset required; inability to reach a safe state can produce complete lock-out.

**DOC-CONFIRMED.** SICK M4000 documentation gives the physical implementation: positively guided N/C auxiliary contacts of K1/K2 return to the EDM input. If the expected feedback does not appear after the protective device response, EDM prevents machine restart. The same manual instructs that a reset button be outside the hazardous area, not operable from inside, and positioned so the operator has full visual command of the hazardous area.

Sources: SICK UE440/UE470 operating instructions; SICK M4000 operating instructions 8011195/WP69/2012-11-28.

### Siemens — safety-fault acknowledgment is another distinct state transition

**DOC-CONFIRMED.** SINAMICS S120 Safety Integrated documentation describes acknowledgment of Safety faults separately from the STO/SS1 safety function itself. The cause is removed, STO/SS1 is deselected as applicable, and the fault is acknowledged; a higher-level safety communication path or power cycle can also be used for defined acknowledgments. If the fault cause remains, it reappears. This is evidence that fault acknowledgment/rearm is not equivalent to merely restoring the safety input.

Source: Siemens `SINAMICS S120 Function Manual Safety Integrated`, 12/2018, section 4.1 Safety Integrated basic functions / acknowledging Safety faults.

## State model for curriculum use

Do not teach a single generic `RESET` bit. Trace these states separately:

1. **Safety demand active** — E-stop operated, guard/light curtain demand present, safety fault present, etc.
2. **Safety demand cleared** — physical demand is no longer active. This alone does not imply restart permission.
3. **Final elements proven safe/ready** — EDM or equivalent diagnostics prove monitored contactors/valves/drives reached the expected state. A welded/fused/stuck final element must not be hidden by a cleared sensor.
4. **Safety reset / restart-interlock release** — deliberate safety-system action restoring readiness after conditions are valid.
5. **Fault acknowledgment / rearm** — where the safety subsystem requires a separate acknowledgment after a diagnosed fault, the fault cause must first be removed.
6. **Normal machine start command** — separate operator/process command that may permit motion only after the safety system is ready.
7. **Normal controller actuator authority** — LinuxCNC/FPGA/PLC commands are accepted only after the independent safety chain permits the physical final elements.

The exact ordering and terminology are implementation-specific; this is a tracing framework, not a machine truth table.

## OpenPressBrake architectural consequence

**INFERENCE, strongly supported by the professional patterns above:** the normal LinuxCNC/FPGA controller should be allowed to observe safety-ready/fault state and should default to no actuator command when safety is unavailable, but ordinary software recovery must not automatically reset a personnel-safety restart interlock. A practical architecture should make safety reset a deliberate, physically appropriate action with good visibility of the hazard zone, then still require a separate normal start/motion command.

For a press brake this is particularly important because clearing a light curtain, releasing an E-stop, restoring an FPGA link, or commanding proportional current to zero says nothing by itself about whether monitored hydraulic final elements are healthy or whether the ram is physically restrained.

## Human-factors rule

A correct reset arrangement should be easy to use correctly. Put the reset/rearm device where the operator can verify the protected area rather than creating a workflow that encourages bypassing the safeguard. Diagnostics should identify which condition is preventing reset (protective device, EDM/final-element mismatch, safety fault, guard state, etc.) without allowing the ordinary HMI to override it.

## Failure-path checks for future complete-machine traces

For every OEM implementation, answer all of the following without assumption:

- Does clearing the E-stop/guard/light curtain automatically restore safety outputs?
- Is a manual reset/restart interlock required, and where is its physical button located?
- Can the reset device be reached from inside the hazardous area?
- Does reset itself cause motion, energize a valve, release a brake, or close a power contactor?
- What separate command actually initiates motion?
- Which final elements have EDM/feedback, and what happens if one is welded/stuck?
- Is feedback checked only before restart, continuously, or both?
- What faults require acknowledgment beyond ordinary reset?
- Does loss/restoration of 24 V, mains, network, LinuxCNC, FPGA, or safety-controller power create an automatic restart path?
- What state is retained after a safety fault and after ordinary-controller reboot?

## Safety boundary

This note does not assign a PL/SIL/category to OpenPressBrake and does not claim that a generic reset/EDM arrangement is sufficient for any particular machine. Performance level, architecture category, stopping time/distance, valve diagnostics and hydraulic behavior require the actual risk assessment, selected safety components, circuit and validation evidence.

No simulation was used or needed for this source/documentation conclusion.
