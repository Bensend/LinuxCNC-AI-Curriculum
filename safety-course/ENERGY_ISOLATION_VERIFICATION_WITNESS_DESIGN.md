# Energy-Isolation Verification and Witness Design

Date: 2026-09-16
Status: SAFETY COURSE / 4000

## Purpose

Teach the learner to distinguish a command to remove energy from evidence that hazardous energy has actually been controlled for the task.

## Evidence discipline

- **DOC-CONFIRMED:** OSHA 29 CFR 1910.147(d)(3) requires needed energy-isolating devices to be physically located and operated to isolate the machine from its energy sources.
- **DOC-CONFIRMED:** 1910.147(d)(5) requires hazardous stored/residual energy to be relieved, disconnected, restrained, or otherwise rendered safe; if hazardous reaccumulation is possible, verification must continue until work is complete or the possibility ends.
- **DOC-CONFIRMED:** 1910.147(d)(6) requires the authorized employee to verify isolation and deenergization before work begins.
- **DOC-CONFIRMED:** OSHA Appendix A gives normal-control try-start/testing as an example verification method and requires controls to be returned to neutral/off afterward.
- **DOC-CONFIRMED:** OSHA guidance recognizes instruments such as voltmeters and analogous instruments for other energy types, and notes that multiple verification methods may be needed.
- **INFERENCE:** Therefore a PLC, LinuxCNC HAL bit, FPGA state, relay command, or HMI indication is not by itself proof that the physical hazardous-energy state required by the task has been achieved.

Primary authority: OSHA 29 CFR 1910.147 and OSHA lockout/tagout guidance.

## Five evidence layers

Do not collapse these layers:

1. **Command/request evidence** — software requested stop, disable, valve closure, STO, contactor drop, etc.
2. **Controller-state evidence** — PLC/FPGA/LinuxCNC believes the command was issued and accepted.
3. **Final-element feedback** — auxiliary contact, valve-position switch, drive status, brake feedback, etc.
4. **Independent physical witness** — appropriately selected measurement/observation of the hazardous physical state: voltage test, pressure indication/bleed evidence, mechanical blocking witness, motion observation, etc.
5. **Task-level verification** — evidence set is sufficient for every hazardous energy source and stored/reaccumulating energy relevant to the actual work.

Higher layer numbers are not automatically better sensors. The required evidence depends on the hazard and task.

## Common-cause trap

A particularly weak architecture is one in which the same ordinary controller:

- commands the energy-removal device;
- reads its own command or closely coupled feedback;
- declares the machine safe;
- displays the declaration to the worker.

A single controller fault, stale image, wiring error, mapping error, or mistaken assumption can then corrupt both command and supposed proof. Independence must be reasoned from the physical hazard backward, not inferred from having two software variables.

## Verification contract

Before personnel exposure, the learner must identify:

- every hazardous energy source relevant to the task;
- the physical isolating/control means for each source;
- stored/residual energy and possible reaccumulation;
- what observation or test demonstrates the required state;
- whether the witness is independent enough to reveal failure of the commanded path;
- how the test itself is proven usable where applicable;
- what must remain monitored during the work;
- what evidence is still `UNKNOWN` and therefore cannot support exposure.

If the evidence cannot establish the minimum safe-to-operate/service condition, people must remain outside the danger zone; experimental operation must be isolated/remote and residual risk stated.

## Cross-machine examples

### Press brake

Possible hazards include electrical supply, hydraulic pressure, trapped pressure, accumulator energy, gravity-supported ram/tooling, and motion. A pump-off bit is command evidence only. Exact hydraulic isolation topology, blocking requirements, pressure thresholds, and safe-state behavior are **UNKNOWN until machine-specific evidence exists**.

### Mill

Spindle-disabled or servo-disabled status does not prove main electrical isolation, DC-bus discharge, gravity-axis restraint, pneumatic/hydraulic release, or absence of stored mechanical energy. Exact discharge/coast times remain machine-specific UNKNOWNs.

### Lathe

A spindle-stop indication does not prove chuck/spindle energy is dissipated or electrical/pneumatic/hydraulic sources are controlled. Try-start may contribute to verification but cannot replace source-specific evidence for stored energy.

### Plasma table

CNC torch-off does not prove plasma power-source isolation, stored electrical energy control, gas/pneumatic isolation, or absence of other moving-axis hazards. Manufacturer-specific high-voltage discharge behavior is UNKNOWN unless sourced.

### Robot

Program stop, servo-off request, or controller safe-state display must not be promoted into proof of every task-specific hazardous-energy state. Gravity, pneumatic tooling, external axes, process equipment, and stored energy require separate consideration.

### Automated cell

The cell boundary may contain several independently supplied machines. A master PLC's `CELL_SAFE` bit is not proof that every energy source and stored-energy hazard has been physically controlled. Verification must cover the actual isolation boundary.

## Adversarial review cases

1. Contactor command is OFF but power contacts are welded.
2. Valve-close command is true but the valve is stuck or the wrong valve is mapped.
3. Auxiliary feedback changes while hazardous pressure remains trapped downstream.
4. Pressure initially falls but reaccumulates through leakage/cross-feed.
5. Drive reports disabled while DC bus remains energized.
6. HMI says `SAFE` using the same PLC tag that generated the command.
7. Voltage indicator lamp is dark because the lamp circuit failed.
8. Try-start fails because the ordinary control circuit is faulty, not because all energy is isolated.
9. Mechanical block is present but not rated/positioned for the actual load.
10. One supply is locked out while a secondary feed/backfeed remains.
11. Controller reboot defaults feedback tags to apparently safe values.
12. Maintenance procedure verifies only the easiest energy source and ignores stored/reaccumulating energy.

## Human-factors rule

Verification must be practical enough that workers will actually perform it. Put accessible test points, bleeds, gauges/indicators, lockable isolators, blocking provisions, and clear energy maps where they reduce temptation to infer safety from an HMI. A verification process so awkward that routine bypass is predictable is a design defect to correct.

## LinuxCNC / ordinary FPGA boundary

LinuxCNC and the normal FPGA may:

- request normal stop/disable;
- expose diagnostic state;
- inhibit ordinary commands after faults;
- record feedback and stale-data faults;
- require normal-control rearm.

They must not, merely for convenience, become the independent personnel-safety authority that certifies energy isolation or a task-safe physical state.

## Learner exercise

For one press brake, mill, lathe, plasma table, robot, and automated cell, build a table with columns:

`Hazard | Command | Controller state | Final-element feedback | Independent physical witness | Reaccumulation path | Required continued verification | UNKNOWN`

Reject any row whose only evidence is a software state derived from the same controller that issued the command.

## Exit criteria

The learner can:

- explain why command and proof are different;
- choose evidence appropriate to the physical hazard rather than the UI;
- identify common-cause command/proof failures;
- distinguish final-element feedback from independent physical witness;
- recognize when continued verification is required;
- preserve machine-specific unknowns rather than inventing thresholds/times;
- keep ordinary LinuxCNC/FPGA outside independent personnel-safety authority.
