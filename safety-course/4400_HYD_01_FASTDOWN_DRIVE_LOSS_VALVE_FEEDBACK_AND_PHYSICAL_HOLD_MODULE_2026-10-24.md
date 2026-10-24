# 4400-HYD-01 — Fast-down drive loss, hydraulic valve feedback and physical ram holding
**4000 safety curriculum | 2026-10-24 | SOURCE-READING / NOT GRADUATED / PHYSICAL TEST NOT RUN**

## Prerequisites and learning objective
Read 2520 hazard/SRS, 2540 final elements, 2580 hydraulic/gravity, 25E0 power recovery, 4400-BLK-01 mechanical restraint and 4400-RST-01 reset/EDM. Then read [direct original HAWE ePRAX audit](../research/4400_HAWE_EPRAX_FASTDOWN_DRIVE_ACTIVE_VALVE_HOLD_ORIFICE_SOURCE_AUDIT_2026-10-24.md) and [SVNE position-switch audit](../research/4400_HAWE_SVNE_VALVE_POSITION_SWITCH_OVERLAP_AND_MAINTENANCE_SOURCE_AUDIT_2026-10-24.md).

A fresh AI engineer must explain why **servo drive active**, **valve coil command**, **valve-position sensor**, **pressure indication**, **actual Y1/Y2 stopped/held**, **stored energy isolated** and **new deliberate start** are distinct propositions. The engineer must identify credible loss-of-speed-control failure paths and design a non-invented selected-machine evidence plan.

## Real industrial example and strict applicability
The HAWE B 6340 04-2026 rev 1.5 original ePRAX modular manual explicitly documents two hydraulic Y1/Y2 drive assemblies, safety-related monitored valves, and a **FAST DOWN** hazard when electric-drive speed control becomes inactive. It assigns the machine integrator responsibility for independent safety controls. The HAWE D 6354/1 06-2026 rev 1.1 component manual depicts monitored idle-position switch travel separately from zero-leakage seating. **Neither manual proves ePRAX/SVNE installation, hydraulic schematic, response, performance level, or stopping distance for OpenPressBrake.**

## Four independent evidence layers
| Layer | Normal role | Evidence | What it cannot establish alone |
|---|---|---|---|
| 1. LinuxCNC/ordinary FPGA/servo | Requested Y1/Y2 position, velocity, torque, drive enable and status | CNC logs, drive-active outputs, encoder trace | Personnel-safety stop, gravity hold or safe restart |
| 2. Independent safety control | Guard/E-stop/overspeed and fault inputs; monitored safety logic; output command | Qualified safety-controller configuration and event record | Actual coil voltage, valve travel, pressure isolation, ram arrest |
| 3. Final hydraulic/energy elements | Selected valves, actuator supply, mechanical/pressure load path, isolators | Exact as-built parts and hydraulic/electrical drawings, valve/switch state, qualified instrumentation | Absence of retained energy or movement under every fault |
| 4. Physical machine | Both Y1/Y2 ram positions/velocities, held load, accessible hazards and recovery | Independent time-correlated physical measurements and qualified inspection | May not be replaced by an HMI green lamp |

## Hazard-to-authority example (conceptual, NOT a selected valve truth table)
- **HAZ-HYD-A:** gravity-assisted descent continues or accelerates after ordinary servo-speed authority is lost.
- **SF-HYD-A candidate:** independently detect the relevant failure and bring both Y1/Y2 to a validated safe state with suitable monitored final elements, regardless of ordinary controller/drive status. Exact required safe state, fault tolerance and response time require machine-specific hazard/SRS work.
- **SF-HYD-B candidate:** maintain required load holding after stop/power loss; separately address accumulator and trapped fluid.
- **SF-HYD-C candidate:** inhibit unexpected rearm/restart until fault, physical hazard and occupancy are resolved and a new intentional start is made.
- **AUTH:** normal CNC and proportional drive command are **not** independent safety; safety-related controller and final elements require selected design verification. Mechanical support and energy isolation remain physical measures for maintenance.

## Failure-path review (paper, not executable commands)
| Initiating event | Dangerous assumption | Required independent discriminator |
|---|---|---|
| Drive-active drops during FAST DOWN | 'Set speed to zero and the beam will stop' | Independent valve stop path and actual Y1/Y2 deceleration/hold |
| Drive-active high but throttle ineffective | 'Drive ready proves braking' | Physical motion and hydraulic final-element response |
| Valve-position PNP NO/NC inputs appear complementary | 'Two outputs = redundant hydraulic proof' | Exact part code, common sensor, switching range, hydraulic sealing witness |
| One valve sticks or leaks | 'Safety PLC commanded OFF' | Actual final-element position, fluid path, ram response and latched fault |
| Safety 24 V/0 V shared with normal drive | 'Independent software logic means independent power' | Power/return/fuse/connector/driver/feedback common-cause map |
| Safety scale fails after physical restrictor removed | 'Linear scale option is always enough' | Product-specific risk assessment, diagnostic response, physical safe-state proof |
| FAST DOWN to pressing transition | 'Normal phase timing guarantees no drop' | Independent Y1/Y2 motion evidence, selected valve closure/hold qualification |
| Valve service after LOTO | 'One gauge reads zero' | Mechanical support plus every relevant isolated pressure volume verified |
| Reset/power return with held pedal | 'Safety rearm starts the next cycle' | Clear area, independent safety rearm, fresh normal start |

## Practical human factors
Make **Stop not proven** the default UI state until actual evidence exists. Provide easy access to labeled, guarded service witness points and unambiguous separate indicators for ordinary drive, safety logic, hydraulic final elements and ram physical state. A guard or pressure test point requiring awkward access encourages bypass; redesign the service path rather than normalizing defeat. Never make an HMI 'Clear faults' also launch a retained CNC cycle.

## Learning route and assessment
1. Identify which claims are DOC-CONFIRMED for ePRAX/SVNE and which are only INFERENCE or UNKNOWN for a different machine.
2. Trace loss of drive-speed control across normal control, safety controller, hydraulic elements and physical ram; do not fabricate exact valve energization states.
3. Complete [16 learner-visible paper scenarios](4400_HYDRAULIC_FASTDOWN_AND_VALVE_FEEDBACK_TECHNICIAN_CARD_2026-10-24.md). These are **not** a blind score.
4. Use [blank qualified as-built witness](4400_HYDRAULIC_STOP_HOLD_AND_ENERGY_BLANK_WITNESS_2026-10-24.md) only after selected-machine engineering review. Do not perform hazardous fault injection with exposed people.
5. [Independent evaluator handoff](../evaluation/4400_HYD_01_FRESH_VALVE_FEEDBACK_TRANSFER_HANDOFF_2026-10-24.md) remains **PREPARED / NOT EXECUTED / NOT SCORED**.

## Evidence ledger and graduation blockers
- **DOC-CONFIRMED:** OEM fast-down failure mechanism, selected HAWE valve/switch/pressure roles, OEM physical-service restrictions, component switching-band distinction.
- **INFERENCE:** common power/feedback fault coupling, mismatch between switch state and effective sealing in a damaged or wrongly integrated valve, predictable guard bypass due to poor access.
- **UNKNOWN:** selected OpenPressBrake actual topology, all Y1/Y2 physical stop/hold responses, gravity and accumulator isolation, safety controller, achieved PL/SIL, stop times, valve diagnostic coverage, guard/rearm and fresh start.
- **TEST-CONFIRMED:** none. **SOURCE-CONFIRMED LinuxCNC:** no new LinuxCNC source trace in this module; prior RST-01 pinned normal-control reset trace remains applicable only at its recorded revision.

**Counterfactual gate:** if the selected valve/switch behaves differently than HAWE, the selected-machine stop/hold claim could be invalid. Thus the module is **NOT GRADUATED** and selected-machine physical evidence cannot be promoted away. G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. No personnel-exposed hazardous operation.

## Next justified work
Exact selected-machine safety PLC, valves, line-scale and drive-status ownership, Y1/Y2 stop/hold, residual-pressure and service support; independent fresh evaluator. If unavailable, rotate to another open 4400 safety branch. No source question here currently justifies a synthetic lab or hosted compute.
