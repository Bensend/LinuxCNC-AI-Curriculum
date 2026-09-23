# 25C0 — Reset/restart, visibility, and setup/recovery evidence

## Purpose

Close the remaining human-factors evidence gap without turning convenience into safety authority. This artifact distinguishes reset, restart, occupancy knowledge, mode selection, enabling, and maintenance isolation.

## Reset and restart are different propositions

Pilz's current movable-guard guidance states that after a safeguard has been triggered the machine must not automatically restart merely because the protected condition clears; restart is through a control outside the danger zone with visual contact. Pilz's ISO 13850 FAQ separately states that resetting an actuated emergency-stop device must not automatically restart the machine: reset prepares the machine for restart, and starting requires a deliberate control action.

SICK's current Guide for Safe Machinery gives the same boundary: emergency-stop reset is local/manual and only prepares the machine to be put back into operation; where the operating area is not fully visible, additional reset measures are needed to avoid unexpected startup.

Evidence class: **DOC-CONFIRMED**.

Freeze: **RESET COMPLETE != MOTION START AUTHORIZED.**

Freeze: **GUARD CLOSED / FIELD CLEAR != PROTECTED SPACE KNOWN EMPTY.**

Freeze: **REMOTE HMI CAN DISPLAY SAFETY STATE != REMOTE HMI IS AN ACCEPTABLE BLIND RESET LOCATION.** Reset placement and occupancy/visibility must be justified by the application.

### Large or blind cells

Pilz's current access-management example explicitly addresses danger zones that people enter. Its key-in-pocket pattern keeps each entrant represented in a safe list until that person exits/signs out; for large plants without an overall view it adds a blind-spot check before restart. This is useful architecture evidence, not a universal prescription.

Evidence class: **DOC-CONFIRMED** for the described architecture; **INFERENCE** that the broader lesson is to make occupancy knowledge/restart prevention explicit instead of assuming a closed gate proves an empty cell.

## Setup/recovery modes

Rockwell's enabling-switch guidance says the machine should be put into a reduced-performance mode where appropriate and that the control system must prevent return to normal performance during the enabling task. Its safe-speed reference architecture combines safe-limited-speed monitoring, door monitoring, an enabling switch, mode/restart sequencing, and a warning that the mode must not be changed while a person remains in the hazard area.

Evidence class: **DOC-CONFIRMED** for the documented architecture and warnings.

Freeze: **MODE SELECTED != RESTRICTED PERFORMANCE PHYSICALLY PROVED.**

Freeze: **ENABLING DEVICE HELD != NORMAL PRODUCTION AUTHORITY.**

Freeze: **SETUP MODE AVAILABLE != SETUP MODE ACCEPTABLE FOR ROUTINE PRODUCTION.** If production incentives make restricted/setup mode the easier production path, mode design, authorization, workflow, or production safeguarding needs redesign.

## Practical low-cost patterns

These patterns reduce foreseeable defeat pressure but do not substitute for the required safety integrity or physical safe-state proof:

- put reset where the required protected-space view is practical rather than merely where wiring/HMI layout is convenient;
- separate `safe condition restored`, `reset/rearm accepted`, and `motion start requested` in both control logic and operator indication;
- provide a clear reason for inhibited restart so technicians do not bridge inputs to discover the blocker;
- use hinged/captive/keyed guard hardware and locating features so restoration after maintenance is mechanically easier than leaving protection removed;
- improve viewing/lighting or move legitimate adjustment outside the hazard boundary when that removes repeated guard opening;
- provide a deliberately bounded setup/recovery mode where the task genuinely requires access, with independently justified restrictions and safety-related monitoring rather than ordinary LinuxCNC jog logic alone;
- where whole-cell visibility is impossible, explicitly design occupancy/restart-prevention measures instead of treating gate closure as occupancy proof;
- keep production interlocks separate from maintenance energy isolation/restraint.

Evidence class: **INFERENCE**, derived from the DOC-CONFIRMED reset/restart, enabling, and anti-defeat principles. Machine-specific validation remains required.

## Adversarial reasoning checks

1. A gate is closed and all interlocks are healthy, but a person can remain behind the gate. A correct design argument must not infer an empty cell from gate state.
2. An HMI across the aisle can reset every safety device but cannot see behind the machine. Convenience does not establish safe reset placement.
3. A reduced-speed setup mode is routinely used for production because normal guarding makes inspection costly. The response is not simply stronger authorization; remove the production incentive where practical and preserve setup as a bounded exceptional mode.
4. A three-position enabling switch is held in its enabling position while ordinary software silently restores normal speed. The enabling device has not established restricted performance; the architecture is unsafe until the restriction is independently enforced/monitored as required.
5. Maintenance finishes and a difficult bolted guard is left off. A procedural reminder alone misses the mechanical usability defect; redesign restoration while retaining proper maintenance isolation.

## Sources / provenance

- Pilz, current `Movable guards - EN ISO 14120` guidance: interlocking and unexpected-restart/reset placement.
- Pilz, current FAQ on emergency-stop reset: intentional local reset; reset must not itself restart machinery.
- SICK, `Guide for Safe Machinery`: reset/restart and additional reset where the operating area is not fully visible.
- Pilz, current `Access management for your plant and machinery`: key-in-pocket and blind-spot-check example.
- Rockwell Automation, `Emergency Stop Devices Technical Data`: enabling switch with reduced-performance mode.
- Rockwell Automation, `Kinetix 6200 and Kinetix 6500 Safe Speed Monitoring Safety Reference Manual`: SLS + door + enabling architecture and mode-change warning.

No stopping time, safe speed, PL/SIL, pressure threshold, or machine-specific physical parameter is inferred from these examples.