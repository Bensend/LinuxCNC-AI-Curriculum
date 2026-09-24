# 25F0 — Robot / automated-cell safety capstone delta

## Scope and evidence discipline

This artifact transfers the 25F0 machine-safety capstone method to industrial robot and automated cells. It does not replace a machine-specific risk assessment. Numeric stop times/distances, separation distances, PL/SIL targets, safe-speed limits, proof-test intervals and physical thresholds remain `UNKNOWN` until justified for the actual application.

Evidence labels used here: `DOC-CONFIRMED`, `INFERENCE`, `UNKNOWN`.

## Machine and lifecycle boundary

The safety boundary is the **robot application/cell**, not merely the manipulator. Where present it includes robot(s), end effector/tooling, workpiece, positioner, conveyor, feeder, clamps/grippers, pneumatic/hydraulic/vacuum sources, welding/cutting/process equipment, upstream/downstream machines, guarding, access gates, presence sensing, safety-related controller(s), physical final elements and energy-isolation means.

OSHA's robot technical guidance explicitly treats workers as potentially exposed to the robot application's reach and hazards of other machines/components, and describes perimeter/presence safeguarding around the restricted space. `DOC-CONFIRMED`.

Lifecycle states requiring separate review include automatic production, loading/unloading, teaching/programming, setup, recovery after a protective stop, jam/fault clearing, maintenance, tool/end-effector change, validation and decommissioning.

## Hazardous energy and hazardous-event inventory

Representative paths, each requiring application-specific confirmation:

- robot multi-axis kinetic/gravity energy and stored mechanical energy;
- carried workpiece/tool ejection or dropping;
- pinch/crush/trap spaces between robot/tool/workpiece and fixed structures;
- positioner/turntable/indexer motion independent of robot motion;
- conveyors/feeders/upstream/downstream machine motion;
- pneumatic, hydraulic and vacuum tooling/grippers, including retained loads after supply loss;
- process energy such as welding, laser/cutting, heat or electrical energy where present;
- electrical stored energy and maintenance-isolation hazards.

`ROBOT STOPPED != CELL SAFE STATE PROVED` and `ROBOT CONTROLLER SAFE STATE != PERIPHERAL MACHINE SAFE STATE`.

## Whole-body access and occupancy

OSHA describes interlocked perimeter barriers whose gate opening stops automatic robot and associated-machinery operations, with restart requiring gate closure plus reactivation of a control outside the barrier. OSHA also documents accidents in which a worker entered a restricted space and inadequate perimeter guarding allowed exposure. `DOC-CONFIRMED`.

A gate switch proves a gate proposition; it does not prove that the safeguarded space is empty. Large cells, blind spots, multiple entrances, maintenance access and more than one person create an occupancy problem that must be addressed independently.

**Freeze:** `PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY`.

Where reset is used after whole-body access, the reset/rearm arrangement must not be treated as an occupancy sensor. ABB safety guidance states that manual reset should be deliberate, should not itself initiate hazardous motion, and should be located outside the danger zone with good visibility. ABB optical-safety guidance describes a pre-reset/time-reset arrangement for protected areas that cannot be fully seen from one reset location. `DOC-CONFIRMED`.

**Freeze:** `SAFETY RESET COMPLETE != CELL OCCUPANCY CLEARED`.

For multi-person entry, the capstone requires an explicit personnel-accounting/occupancy strategy appropriate to the cell; a single reset button is not credited as proof that all entrants exited. The exact architecture remains application-specific (`UNKNOWN`).

## Manual / teach / setup operation

Manual operation inside or near the safeguarded space is a different safety state, not simply automatic mode with a slower command. OSHA's robot guidance identifies teach-pendant enabling devices as a control against unexpected motion during programming. ABB's current OmniCore material describes a three-position enabling device as dedicated safety hardware for manual robot interaction; ABB SafeMove documentation describes recovery/manual behavior using the three-position enabling device. `DOC-CONFIRMED`.

Required proposition: when a person must be exposed for teaching/setup, the selected mode, enabling device and applicable safety-related motion limits must provide the alternate protection justified by the application; ordinary LinuxCNC/PLC/robot-program jog limits are not silently credited.

**Freeze:** `SOFTWARE JOG LIMIT != SAFE MANUAL OPERATION PROVED`.

Release of the enabling device, excessive squeeze where applicable, mode changes, loss of required safety communication, or violation of the configured safety function must lead to the specified safe response. Exact speed/force/space values remain `UNKNOWN` until the application risk assessment and validated safety configuration establish them.

## Restart and power restoration

Safeguard restoration and safety reset prepare a cell for a separate start decision; they are not themselves permission for hazardous motion. OSHA robot guidance says control systems should prevent automatic restart after restoration of electrical power and prevent hazardous conditions after hydraulic, pneumatic or vacuum loss/change. ABB reset guidance likewise distinguishes reset from a separate start command. `DOC-CONFIRMED`.

Required tests include gate open/close, presence-device clear, reset held/stuck, power loss/restoration, safety-controller restart, robot-controller restart, peripheral-controller restart and recovery from process faults.

**Freeze:** `SAFEGUARD RESTORED != HAZARDOUS MOTION AUTHORIZED`.

## Cell-level authority allocation

| Layer | Permitted role | Not automatically credited |
|---|---|---|
| Ordinary LinuxCNC / ordinary PLC / normal robot program | production sequencing, requests, ordinary motion/process commands | personnel-safety authority |
| Diagnostics/HMI | status, fault localization, event history, maintenance guidance | proof of physical safe state |
| Safety-related controller / certified robot safety function where justified | evaluate safety inputs, mode-dependent safety logic, safety-rated motion/space functions, command safety outputs | proof that every external final element physically achieved its state |
| Physical final elements | brakes, STO channels, contactors, safety valves, locking devices, mechanical restraints as applicable | cell-wide safety merely because one element changed state |
| Maintenance isolation | lockable energy isolation, dissipation/restraint and verification | production safeguarding substitute |

Certified robot-controller safety functions can legitimately be part of an SRP/CS when integrated and validated to their documented limits. This does **not** transfer personnel-safety authority to ordinary robot programs, LinuxCNC HAL, a normal PLC task, or an uncertified FPGA path.

## SRS transfer matrix

### Transfers substantially unchanged from mill/VMC baseline

- **SRS-GEN-ESTOP:** an emergency-stop demand causes the defined safe response for all hazardous cell energy paths within scope; reset does not restart.
- **SRS-GEN-RESET:** reset/rearm is deliberate, does not initiate hazardous motion, and enables a separate start command.
- **SRS-GEN-POWER:** loss/restoration of power cannot by itself cause hazardous restart.
- **SRS-GEN-MAINT:** servicing requiring hazardous-energy control uses isolation/dissipation/restraint/verification appropriate to the energy path; production interlocks are not a maintenance-isolation substitute.
- **SRS-GEN-DIAG:** diagnostic status is not substituted for physical validation evidence.

### Modified for robot/cell physics

- **SRS-RC-GUARD:** opening a perimeter safeguard during automatic operation causes the defined safety response for the robot **and associated hazardous machinery/process equipment within the protected-space function**, not merely a robot program pause.
- **SRS-RC-ACCESS:** access is permitted only when the physical hazardous-state/access proposition is satisfied. Robot standstill alone is insufficient where peripherals, gravity, tooling or process energy remain hazardous.
- **SRS-RC-MODE:** automatic, manual/teach, recovery and maintenance modes have explicit authority and safeguard rules; switching mode cannot silently remove required protection.
- **SRS-RC-STOP:** each protective stop defines whether monitored standstill, torque removal, brake application, process-energy removal or another state is required; the implementation must match the hazardous event.

### New robot/cell clauses

- **SRS-RC-OCCUPANCY:** whole-body entry requires a defensible method preventing restart while a person can remain in the safeguarded space; gate closure/reset alone is not credited as proof of vacancy.
- **SRS-RC-ENABLE:** exposed manual/teach motion, where permitted, requires the justified enabling/manual-operation architecture and validated safety-related limits; ordinary software jog limits are insufficient.
- **SRS-RC-PERIPHERAL:** every independently hazardous peripheral has a named safe-state proposition and safety authority path; robot safe state cannot stand in for conveyor/positioner/tool/process safe state.
- **SRS-RC-COORD:** coordinated safety signals between robot and peripheral equipment have defined loss-of-communication, stale-state and disagreement behavior.
- **SRS-RC-LOAD:** loss of pneumatic/hydraulic/vacuum/electrical actuation must not create an unanalysed dropped/ejected workpiece or tool hazard.
- **SRS-RC-RESTART:** after entry, safety violation, mode change, controller restart or power restoration, hazardous automatic operation requires all required safeguards restored plus a separate intentional start sequence.

## Fault / common-cause prompts

The capstone validation must consider at minimum: one gate channel open/stuck; cross-fault where applicable; presence sensor fault/obscuration; reset stuck; enabling-device channel fault; safety-network loss/stale data; robot safety output changes state but a peripheral does not; peripheral feedback falsely healthy; welded contactor/stuck valve; brake or load-retention failure; loss of vacuum/air/hydraulic pressure; power restoration; one controller rebooting while another remains live; common 24 V or network dependency; maintenance jumper/bypass left installed; and configuration mismatch between robot safety zones and physical cell layout.

`FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED` remains controlling.

## Human-factors / foreseeable defeat review

For each gate, scanner/light curtain, enabling device and recovery sequence ask what production or maintenance inconvenience rewards bypass. Common pressure points include repeated nuisance stops, blind reset locations, recovery requiring unnecessary entry/exit cycles, poor fault localization, awkward teach-mode selection, inaccessible lockout points and peripherals that must be manually recovered after every robot stop.

The remedy is not to weaken the safeguard. Redesign recovery, diagnostics, visibility, access and reset placement so correct use is the easier path. If the minimum attended-operation safeguard cannot be established, commissioning/experimental operation remains isolated or remote with people outside the danger zone.

## Validation skeleton

For each SRS clause record: physical proposition, precondition/mode, stimulus/fault, expected safety response, measurement/witness, acceptance criterion, result and revalidation trigger.

Robot/cell-specific physical checks include:

1. gate/access demand affects every hazardous path named by the SRS, not just robot program state;
2. whole-body entry cannot be followed by hazardous restart while a person can remain inside;
3. reset alone never initiates hazardous motion;
4. manual/teach enabling-device behavior and safety-related limits match the validated configuration;
5. safety-network or controller disagreement fails according to the SRS;
6. robot safety state does not mask an unsafe conveyor/positioner/tool/process state;
7. power and fluid-energy loss/recovery do not create an unanalysed drop, release or restart;
8. maintenance isolation is physically verified independently of production safeguarding.

## UNKNOWN register

Remain `UNKNOWN` until application evidence exists:

- required PL/SIL/integrity targets;
- exact stop category for each hazard;
- measured robot/peripheral stopping times;
- protective/separation distances;
- permitted manual/teach speeds, forces and zones;
- whether guard locking is required for a particular access point;
- exact occupancy/key-exchange/trapped-person-release architecture;
- load-retention behavior of a specific gripper/tool;
- proof-test intervals and quantitative diagnostic coverage;
- safe-network timing limits;
- final element response times and residual stored energy.

## Evidence anchors

- OSHA, *Guidelines for Robotics Safety*, STD 01-12-002: interlocked barriers, associated-machinery stopping, restart outside barrier, enabling devices, abnormal conditions and power restoration. `DOC-CONFIRMED`.
- OSHA Technical Manual, Section IV Chapter 4: robot-application/restricted-space hazards, presence/perimeter safeguarding, accidents involving whole-body entry, and safety-rated space/motion concepts. `DOC-CONFIRMED`.
- ABB, *Using an HMI for reset and start*: manual reset separate/deliberate, no motion initiation, separate start, visibility outside danger zone. `DOC-CONFIRMED`.
- ABB, *Optical safety devices*: supervised reset and pre-reset/time-reset example for areas not fully visible. `DOC-CONFIRMED`.
- ABB, *Functional safety and SafeMove RW 8*, rev. B (2026): start/restart interlock/reset and three-position enabling-device behavior. `DOC-CONFIRMED`.
- ABB OmniCore UI (2026): dedicated three-position enabling and safety hardware for manual robot interaction; completed application still requires integration/risk assessment/verification/validation. `DOC-CONFIRMED`.

## Next transfer

Begin the press-brake capstone. Reuse only generic SRS clauses whose physical propositions actually transfer. Build the press-brake hazard/energy boundary first: point-of-operation crush/pinch, ram/beam and tooling/workpiece interaction, gravity and stored fluid energy, rear/side access, setup/tool change and maintenance restraint. Keep hydraulic truth tables, valve response, stopping distance/time, pressure thresholds and integrity targets `UNKNOWN` until authoritative machine-specific evidence exists.
