# 25F0 — Mill/VMC machine-safety capstone baseline

Session start UTC: 2026-09-23T22:35:00Z

## Purpose and evidence boundary

This is a transferable baseline, not a universal mill circuit. Machine-specific stopping time/distance, PL/SIL target, pneumatic/hydraulic pressure, proof-test interval, tool-retention behavior, brake performance and access timing remain **UNKNOWN** until established for the actual machine.

Evidence classes used here: DOC-CONFIRMED, INFERENCE, UNKNOWN.

## Machine and lifecycle boundary

Representative enclosed CNC mill/VMC boundary: enclosure and access doors; spindle/motor/drive/tool; X/Y/Z axes and drives; table/workholding; automatic tool changer (ATC) where fitted; coolant/chip equipment; pneumatic/hydraulic auxiliaries where fitted; control cabinet and stored electrical energy; workpiece/tool ejection containment; operator loading/unloading, production, setup/jog, clearing chips/jams, tool/workholding change, cleaning, maintenance, commissioning and recovery.

The enclosure is not merely a switch carrier: it also addresses exposure to rotating/moving parts and ejection. OSHA explicitly lists milling machines among machines normally requiring point-of-operation guarding. Haas' current VR safety material warns that the table/head may move rapidly, rotating tools can cause severe injury, improperly clamped parts may be ejected, and operation requires functioning door interlocks. **DOC-CONFIRMED.**

## Hazardous-energy inventory

| Energy/hazard | Representative dangerous event | Safety proposition that may be required | Boundary |
|---|---|---|---|
| spindle rotational kinetic energy | access reaches rotating tool/spindle | access is prevented until dangerous spindle motion has ceased, or an independently justified alternate safe mode applies | spindle command-off alone is insufficient |
| axis electrical/mechanical energy | crush/shear/impact from X/Y/Z motion | hazardous axis motion is prevented/ceased while exposure exists, except under a separately justified bounded setup mode | ordinary LinuxCNC motion state is diagnostic/control evidence, not personnel-safety authority |
| vertical/gravity axis where applicable | Z/head drops or backdrives after torque removal | gravity-driven hazardous motion is prevented by the actual machine architecture | **UNKNOWN** until mechanics/brake/counterbalance are known |
| ATC stored/moving energy | carousel/arm/tool pot motion traps or strikes person | hazardous ATC motion/energy cannot act during protected access/maintenance | exact ATC mechanism is machine-specific |
| pneumatic/hydraulic auxiliary energy | clamp/tool-release/counterbalance/actuator moves unexpectedly | relevant hazardous fluid energy is isolated, exhausted or restrained as required by the physical hazard | pump/solenoid off does not itself prove safe pressure |
| electrical stored/live energy | shock/arc or unexpected energization during service | servicing isolation removes/controls hazardous electrical energy and residual energy is addressed | interlocked guard is not maintenance isolation |
| tool/workpiece kinetic/ejection energy | tool/workpiece/projectile exits work zone | enclosure/guarding and process limits provide the required containment for the intended operating envelope | safety interlock alone does not prove containment |

## Authoritative physical-proposition anchors

1. OSHA's machine-guarding eTool states that opening an interlocked guard shuts off/disengages power, stops moving parts and prevents cycling/start until the guard is restored; replacing the guard should not automatically restart the machine. **DOC-CONFIRMED.**
2. OSHA has separately stated that an interlocked gate is inadequate where a person can enter the danger zone before inertia-driven motion stops; access must remain prevented until the moving parts have stopped. **DOC-CONFIRMED.** This is directly relevant to spindle coast.
3. Haas' current VR-series safety material says to verify that the spindle has stopped before opening doors and notes that after loss of power the spindle may take longer to coast to a stop. **DOC-CONFIRMED.** Therefore `spindle command = off`, `drive disabled`, and even power loss are not physical standstill proof.
4. OSHA's hazardous-energy guidance separates stopping from isolation, lock/tag, relief of stored/residual energy and verification of isolation. It also requires restoration checks before return to service. **DOC-CONFIRMED.** Therefore production guard interlocking is not a substitute for maintenance energy control.
5. Siemens currently documents machine-drive safety functions including STO, SS1, SLS and others on SINAMICS S120. **DOC-CONFIRMED for that product family only.** Their existence demonstrates distinct safety-function concepts; it does not prove that any arbitrary VMC has them or that selecting one validates the machine.

## SRS skeleton

These are requirement *shapes*; integrity targets and numerical timing remain UNKNOWN.

### M-SF-01 — production enclosure access
When production hazardous spindle/axis/ATC motion is enabled, opening a protected access point shall cause the safety-related control system to achieve the defined safe state and prevent hazardous restart. Where a person could reach the hazard before cessation, access shall remain prevented until the relevant dangerous state is physically ended. Guard restoration alone shall not initiate cycle motion.

### M-SF-02 — spindle hazardous motion/coast
A demand requiring protected access shall remove/prevent hazardous spindle torque as required and account for coast. If access timing depends on standstill, the design shall use a validated physical proposition appropriate to the machine rather than ordinary CNC `spindle-off` status alone. Loss of power shall not be assumed to shorten stopping time.

### M-SF-03 — axis hazardous motion
Protected access shall prevent/cease hazardous axis motion except under a separately specified setup/recovery mode with bounded motion/performance and alternate protection. Any gravity/backdrive hazard requires a machine-specific holding/restraint proposition in addition to torque removal.

### M-SF-04 — ATC/toolchanger
Protected access, clearing and maintenance states shall prevent hazardous ATC actuation or stored-energy release. The machine-specific ATC energy sources, gravity paths, springs, pneumatic/hydraulic actuators and tool-retention hazards must be inventoried before validation.

### M-SF-05 — auxiliary fluid power
Where pneumatic/hydraulic energy can create hazardous motion or release, the safe state shall separately address supply isolation, trapped/residual energy and load holding/restraint as applicable. Pressure thresholds and valve truth tables remain UNKNOWN absent the actual circuit and hazard analysis.

### M-SF-06 — reset/restart
Restoring a door/interlock or safety input shall not itself restart hazardous motion. Reset/rearm shall establish eligibility only; ordinary cycle start remains a separate deliberate action. Blind zones or whole-body access require additional occupancy/egress reasoning rather than assuming `door closed = space empty`.

### M-SF-07 — servicing/maintenance isolation
Tasks outside protected normal-production exceptions shall use an energy-control method appropriate to the hazardous sources, including isolation, stored-energy relief/restraint and verification. A production interlock or LinuxCNC E-stop state is not maintenance isolation.

## Authority allocation

| Layer | May own | Must not be credited with |
|---|---|---|
| ordinary LinuxCNC/HAL/FPGA | cycle logic, motion commands, spindle commands, setup UI, status display, non-safety diagnostics | personnel-safety authority merely because it reacts quickly or reports `off` |
| monitoring/diagnostics | door status display, drive/axis status, fault logging, maintenance guidance, discrepancy reporting | physical standstill, isolation, pressure-safe or load-held proof unless the complete safety function is designed/validated for that proposition |
| independent safety-related control | safety-input evaluation, safety logic, reset/rearm gating, safety-drive/final-element commands, diagnostic tests appropriate to its architecture | facts beyond what its sensors/final elements actually establish |
| physical final elements | STO/safety drive function, contactors, brakes, guard locks, dump/isolation/load-holding devices as actually designed | universal safety merely from component presence |
| physical machine/guarding | enclosure, access geometry, mechanical restraint, containment | automatic correctness without inspection and validation |

**Freeze:** ordinary LinuxCNC/FPGA may request, observe and diagnose a safety state, but the personnel-safety function must not depend on ordinary LinuxCNC/FPGA software behaving correctly unless an actual safety-rated architecture and evidence establish otherwise.

## Foreseeable defeat and recovery pass

- Production: nuisance door trips or long coast can motivate interlock defeat. Corrective direction is to reduce nuisance causes and engineer access/recovery workflow, not widen a safety limit without revalidation.
- Setup/jog: if every useful setup task requires bypassing the enclosure, the architecture invites defeat. Provide a deliberately bounded setup mode/alternate protection where justified; do not let setup become normal production.
- Chip/jam clearing: controls, lighting, access and recovery should make the safe clearing path faster/easier than bridging a switch or reaching through a partially open door.
- Tool/workholding change: provide clear state indication and a deliberate restart boundary; guard restoration must not surprise-start motion.
- Maintenance: guards/interlocks should be easy to restore correctly. Service access must not turn a production interlock into a substitute for hazardous-energy isolation.

## Validation skeleton

| SRS | Stimulus/fault | Physical evidence required | Revalidation trigger examples |
|---|---|---|---|
| M-SF-01 | open guard during each relevant hazardous state | guard response plus measured/observed cessation/access prevention appropriate to hazard | guard/interlock/logic/drive change; geometry or stopping behavior change |
| M-SF-02 | access demand at representative spindle states; relevant power-loss case | physical spindle cessation/access timing, not status bit only | spindle/drive/brake/tooling/inertia/control parameter change; wear affecting stop |
| M-SF-03 | access demand during representative axis motion and setup states | physical axis response; gravity/backdrive restraint where relevant | drive/brake/counterbalance/mechanics/control change |
| M-SF-04 | guard demand/fault during ATC states | physical ATC non-hazardous state and stored-energy behavior | ATC mechanism/valve/logic/energy-source change |
| M-SF-05 | safety demand and credible fluid-power faults | pressure/motion/restraint evidence appropriate to the actual circuit | valve/plumbing/pressure/load change |
| M-SF-06 | restore guard, reset, power restore, fault recovery | no hazardous automatic restart; deliberate start remains necessary | reset/UI/control/safety logic change |
| M-SF-07 | maintenance isolation exercise | hazardous sources isolated, residual energy addressed and isolation verified | energy-source/service-procedure/mechanical change |

## Residual UNKNOWN register

- required PLr/SIL/architecture for any function;
- actual VMC stopping times, access distances and guard-lock timing;
- whether a chosen machine uses STO, SS1, SLS, safety encoders or external contactors;
- Z-axis gravity/counterbalance/brake behavior;
- ATC mechanism and stored-energy truth table;
- pneumatic/hydraulic safe-state pressures and valve arrangements;
- enclosure containment rating/process envelope;
- proof-test intervals and quantitative diagnostic coverage.

These are deliberately not filled with generic values.

## Next transfer step

Use this baseline to build the lathe/turning-center delta, specifically chuck/workholding release, spindle/workpiece ejection, turret motion and bar-stock/bar-feeder hazards. Preserve the common SRS structure but do not copy mill assumptions where the physical hazard differs.
