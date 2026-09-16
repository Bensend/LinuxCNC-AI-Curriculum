# Stored Energy — Zero Energy vs Controlled Safe-Energy State

Date: 2026-09-16

## Purpose

Teach the learner not to collapse `machine stopped`, `control disabled`, `energy isolated`, and `hazardous stored energy rendered safe` into one state.

## Evidence labels

- **DOC-CONFIRMED — OSHA 29 CFR 1910.147:** servicing/maintenance hazardous energy includes electrical, mechanical, hydraulic, pneumatic, chemical, thermal, and other energy. Energy-isolating devices physically prevent transmission/release; pushbuttons, selector switches, and other control-circuit devices are not energy-isolating devices.
- **DOC-CONFIRMED — OSHA 1910.147(d)(5):** after lockout/tagout, potentially hazardous stored/residual energy must be relieved, disconnected, restrained, or otherwise rendered safe. If hazardous reaccumulation is possible, isolation verification continues until servicing is complete or reaccumulation is no longer possible.
- **DOC-CONFIRMED — OSHA 1910.147(d)(6):** isolation/deenergization must be verified before work begins.
- **DOC-CONFIRMED — OSHA Appendix A:** examples of stored/residual energy include capacitors, springs, elevated machine members, rotating flywheels, hydraulic systems, and pressure; example controls include grounding, repositioning, blocking, and bleeding down.
- **DOC-CONFIRMED — OSHA interpretation/eTool:** verification can require multiple methods appropriate to the energy, including operating controls, electrical test instruments, pressure checks/bleeders, and continued monitoring where reaccumulation is possible.
- **DOC-CONFIRMED — Pilz LoTo guidance:** machinery-specific LoTo addresses isolation of hazardous energy including electrical, mechanical, and hydraulic energy to prevent unintended restart.

## Core distinction

`zero energy` is not a universal synonym for `safe`.

For a specific task, the engineering objective is to identify every hazardous energy source and establish a verified condition in which that energy cannot injure the exposed person. Often this means isolation and dissipation toward a zero-energy state. In other cases a hazard is made safe by positive restraint or blocking: an elevated member may still possess gravitational potential energy, but an independently adequate mechanical support can prevent hazardous motion. The claim is then **controlled/rendered-safe energy for the defined task**, not that gravity disappeared.

Conversely, a gauge reading zero, a stopped motor, a disabled LinuxCNC output, an FPGA inhibit, a drive `ready=false`, or an E-stop state is not by itself proof that all relevant hazardous energy has been isolated and rendered safe.

## State model

Keep these claims separate:

1. `normal_motion_command = absent`
2. `ordinary_control_inhibited`
3. `safety_stop_demanded`
4. `energy_source_isolated`
5. `stored_energy_dissipated_or_restrained`
6. `reaccumulation_path_controlled`
7. `isolation_verified`
8. `task_specific_safe_energy_state_verified`
9. `personnel_work_authorized`

No earlier state silently implies a later one.

## Energy-family reasoning

### Electrical

Consider incoming supply, multiple feeds, capacitors/DC buses, generated/backfed energy, UPS/control supplies, and stored charge. A software disable or contactor command is not an energy-isolating device. The task-specific procedure must identify the applicable isolation and verification method. Exact discharge times and safe-voltage thresholds are **UNKNOWN** until established from the actual equipment/design and applicable requirements.

### Hydraulic / pneumatic

Closing supply is not proof that trapped pressure is gone. Accumulators, cylinder loads, check valves, trapped volumes, gravity acting on cylinders, and pressure reaccumulation must be considered. Bleeding, blocking, restraining, or other design-specific controls may be needed. A pressure transducer displayed through LinuxCNC can be useful diagnostic evidence but is not automatically the sole independent verification method.

### Gravity / elevated members

An elevated ram, spindle head, robot axis, gantry, workpiece, fixture, or other mass can retain hazardous potential energy after electrical/hydraulic power is removed. Where dissipation by lowering is not suitable, positive blocking/restraint may create the safe task state. The required block strength, placement, load, redundancy, and installation method are design-specific **UNKNOWNs** until engineered and validated.

### Springs / flywheels / rotating systems

Stopping the drive command does not prove stored mechanical energy is gone. Springs can remain compressed/tensioned and rotating systems can coast. The safe state may require dissipation, restraint, waiting plus verified standstill, or another engineered measure. Do not invent coast-down times.

### Thermal / process energy

Electrical isolation does not remove hot surfaces, molten material, stored heat, pressure caused by temperature, vacuum, chemical/process energy, or other process hazards. The task boundary must include these where applicable.

## Reaccumulation

A one-time observation is insufficient when energy can return to a hazardous level. Examples to investigate include leaking isolation valves, accumulators, gravity loading a hydraulic circuit, thermal pressure rise, interconnected process piping, or another source feeding the isolated section.

If reaccumulation is credible, define how continued verification or positive isolation/restraint maintains the safe state for the duration of exposure. Do not promote an ordinary controller trend display into independent safety authority without a justified architecture.

## Controlled-energy maintenance

Some troubleshooting, setup, adjustment, or diagnostic tasks may genuinely require energy to remain present. Do not falsely label these tasks `zero energy`.

Instead:

1. define why energy must remain;
2. identify exactly which hazards remain available;
3. minimize the exposed energy/motion to what the task needs where feasible;
4. provide task-specific engineered safeguarding/alternate protection;
5. prevent unexpected normal production behavior;
6. make the energized/maintenance state conspicuous;
7. define deliberate entry, exit, reset, and restoration behavior;
8. validate the complete physical protective function.

If adequate alternate protection cannot be established, the task must not be performed with personnel exposed to the hazard. Experimental operation must be isolated/remote with people outside the danger zone and residual risk stated plainly.

## LinuxCNC / FPGA boundary

LinuxCNC and the ordinary OpenPressBrake FPGA may:

- request orderly shutdown;
- inhibit normal commands;
- display energy/isolation sensors;
- alarm on contradictory state;
- discard stale motion commands after restoration;
- require ordinary rearm before production.

They must not be treated, merely for convenience, as the independent personnel-safety authority proving physical isolation, blocking, depressurization, discharge, standstill, or absence of hazardous stored energy.

## Cross-machine examples

- **Press brake:** electrical supply, hydraulic pressure/accumulators if present, gravity/elevated ram, tooling/workpiece. Exact hydraulic topology and safe support method are **UNKNOWN** until machine-specific evidence exists.
- **Mill:** spindle/axis electrical energy, vertical-axis gravity, spindle coast, pneumatic/hydraulic workholding where fitted. Coast time and holding behavior are **UNKNOWN** design facts.
- **Lathe:** spindle coast/chuck energy, axes, pneumatic/hydraulic chucking where fitted, workpiece energy. Do not infer chuck release behavior after isolation.
- **Plasma table:** axis motion, electrical supplies, process gas/air, torch/high-voltage ignition architecture where fitted, suspended/gantry loads where applicable. Machine-specific source behavior remains **UNKNOWN**.
- **Robot:** multiple axes, gravity-loaded joints, pneumatic tooling, payload, stored drive energy. Safe maintenance state depends on robot/tool/cell design.
- **Automated cell:** all constituent machines plus transfer systems, fixtures, utilities, neighboring energy sources, and shared services; local isolation of one controller does not establish cell-wide safe energy.

## Adversarial review cases

Reject or correct reasoning that says:

1. `E-stop is pressed, so maintenance is safe.`
2. `LinuxCNC is in machine-off, so the hydraulics are isolated.`
3. `The drive says disabled, therefore the DC bus is discharged.`
4. `The pressure gauge reached zero once, so reaccumulation cannot occur.`
5. `The hydraulic pump is off, so an elevated ram cannot descend.`
6. `The cylinder is blocked by hydraulics, so no mechanical restraint question exists.`
7. `The disconnect is open, therefore every secondary/backfeed/process energy source is absent.`
8. `We need live troubleshooting, so ordinary guards can simply be bypassed.`
9. `A software timer has expired, therefore stored energy is proven gone.`
10. `Zero energy` is claimed although a restrained gravity load or other stored energy intentionally remains.

## Human-factors rule

Provide obvious, accessible bleed points, isolation points, blocking locations, captive/proximate supports, clear status/verification access, and workable maintenance modes where the design permits. If the safe method is cumbersome enough that technicians predictably substitute a jumper, improvised prop, guessed wait time, or software disable, treat that inconvenience as an engineering defect to improve rather than relying on warnings alone.

## Learner evaluation

A passing learner must:

- enumerate energy sources by task rather than by controller;
- distinguish isolation from control-command inhibition;
- distinguish dissipation from restraint;
- address reaccumulation;
- identify an appropriate physical verification concept without inventing thresholds/times;
- preserve design-specific unknowns;
- explain when energized maintenance requires a separate engineered safeguarding argument;
- keep LinuxCNC/ordinary FPGA diagnostics outside independent safety authority.

## Sources

- OSHA, 29 CFR 1910.147, Control of Hazardous Energy (Lockout/Tagout), especially definitions and (d)(5)-(6): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147
- OSHA, 1910.147 Appendix A, Typical minimal lockout procedures: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147AppA
- OSHA Lockout/Tagout eTool, energy-control circuitry prohibition / stored-energy and verification guidance: https://www.osha.gov/etools/lockout-tagout/hot-topics/energy-control-program/energy-control-circuitry-prohibition
- OSHA interpretation, Applicability of OSHA's LOTO standards; isolation and verification procedures (2000-11-16): https://www.osha.gov/laws-regs/standardinterpretations/2000-11-16
- Pilz, Lockout/tagout system: https://www.pilz.com/en-US/services/workplace-safety/loto-lockout-tagout-system
