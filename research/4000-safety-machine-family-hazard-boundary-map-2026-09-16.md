# 4000 Safety — machine-family hazard-boundary map for Safety Sandbox

Session start UTC: 2026-09-16T00:36:00Z

Status: CURRICULUM / ARCHITECTURE — no compute used

## Purpose

Map the generic SIM-REUSE-01 interruption + EDM lesson onto real machine families without pretending the two-contactor electrical fixture is itself a complete machine safety architecture.

## Four-layer teaching model

Every machine exercise SHALL separate:

1. **Normal control** — LinuxCNC, ordinary PLC logic, OpenPressBrake FPGA, trajectory/program state, operator commands.
2. **Monitoring/diagnostics** — state reporting, ordinary sensors, LinuxCNC/HAL indications, FPGA telemetry, fault history. Monitoring may inform the operator without becoming personnel-safety authority.
3. **Safety-related control** — independently justified safety relay/controller, safety-rated drive functions where applicable, dual-channel protective-device evaluation, EDM/feedback and deliberate reset/rearm.
4. **Physical energy control/removal** — contactors, STO where justified, hydraulic dump/blocking architecture, pneumatic isolation, mechanical restraint, gravity support, discharge/dissipation, guarding and physical separation.

The simulator must display these layers separately. A green normal-control bit is never shorthand for a safe physical machine.

## Machine-family mappings

### Mill / machining center
Hazard boundary examples: spindle/tool, moving axes/table, automatic tool changer, stored electrical/pneumatic energy, chips/coolant/projectiles.

SIM-REUSE-01 can teach electrical interruption/EDM for an appropriate actuator power path, but it does not prove spindle standstill, axis stop, enclosure containment, pneumatic energy removal, or absence of stored energy. Guard/interlock behavior and restart prevention remain separate functions.

### Lathe
Hazard boundary examples: rotating chuck/workpiece/spindle, axes/turret, bar feeder and ancillary pneumatic/hydraulic mechanisms.

Electrical contactor state does not equal spindle standstill. The curriculum must keep rotational kinetic energy and chuck/workholding hazards visible after power removal. Guard defeat is especially consequential because residual rotation may persist after a stop demand.

### Plasma table
Hazard boundary examples: axis motion, torch high voltage/arc energy, gas supply, fumes/fire, stored electrical energy and automatic restart.

The two-contactor fixture may represent one motion or source-enable interruption concept, but the sandbox must not collapse torch-energy isolation, motion inhibition, gas control and fume/fire controls into one `safe` state.

### Press brake
Hazard boundary examples: closing ram/beam and tooling pinch/crush zone, gravity/stored hydraulic energy, hydraulic pressure/flow paths, backgauge/auxiliary motion.

Do not infer a hydraulic safe state from electrical contactor opening or LinuxCNC/FPGA output state. Machine-specific valve truth tables, pressure thresholds, stopping distances and performance requirements remain UNKNOWN until supported by the actual machine/design evidence. Personnel-safety authority remains independent from ordinary LinuxCNC/FPGA control.

### Robot
Hazard boundary examples: multi-axis arm motion, payload/tool, stored mechanical/pneumatic energy, large reachable envelope and unexpected automatic motion.

The lesson must distinguish ordinary servo enable from justified safety-related drive functions and physical hazard cessation. A stopped command is not proof of safe standstill. Cell access/interlocks and restart policy are part of the architecture.

### Automated cell
Hazard boundary is the union of interacting machines plus transfer equipment, conveyors, pneumatics/hydraulics, stored workpieces and cross-machine restart paths.

A local device reporting safe must not automatically authorize the whole cell. The exercise should require explicit zone boundaries, ownership of reset/rearm, and prevention of one subsystem restarting another while personnel may still be exposed.

## Human-factors rules

- Make the protective-device path easier to use correctly than to bypass.
- If a guard or interlock routinely obstructs legitimate work, treat that inconvenience as a design defect to solve rather than relying on warnings.
- Show bypass/defeat as a first-class fault injection with its consequence visible at the physical hazard layer.
- Restoration of power, communications, LinuxCNC state or FPGA heartbeat must never silently imply personnel-safety rearm.
- Where the modeled architecture cannot establish a basic minimum safe-to-operate condition, the lesson shall say not to operate with people exposed; experimental operation must be isolated/remote with people outside the danger zone and residual risk stated.

## Reusable exercise contract

For each machine-family scenario require the learner to identify:

- hazard zone and exposed person;
- hazardous energy/source and stored-energy path;
- normal command path;
- independent safety-related demand path;
- physical interruption/removal mechanism(s);
- feedback evidence and exactly what it proves;
- latent single-fault behavior;
- reset/rearm owner and restart inhibition;
- remaining hazards after the represented interruption succeeds;
- claims that remain UNKNOWN pending machine-specific evidence.

## Result

SIM-REUSE-01 is retained as a component/architecture reasoning exercise, not a machine safety certification model. Its highest-value teaching function is to force separation between commanded state, observed state, justified diagnostic evidence, physical energy-path state and complete machine hazard state.

## Next work

Create the Safety Sandbox learner/evaluator contract around these machine-family mappings: what the learner sees, what faults may be injected, which conclusions are acceptable, and which overclaims must fail evaluation. Then continue to reset/restart/rearm and bypass/maintenance failure-path lessons. Prototype execution remains unnecessary unless source reasoning exposes a concrete engine question.
