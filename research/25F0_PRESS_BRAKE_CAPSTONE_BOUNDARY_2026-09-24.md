# 25F0 — Press-brake capstone: hazard/energy boundary and SRS skeleton

## Purpose

Begin the press-brake transfer from the cross-machine 25F0 contract without inventing machine-specific hydraulic behavior. This pass establishes the physical hazard boundary and first SRS skeleton. It is not a commissioning design for a particular brake.

## Authoritative baseline

OSHA describes powered press brakes as machines that form stock between a lower die and a top die attached to a movable ram/slide. It highlights high operator involvement, point-of-operation exposure, accidental cycling from operating controls, and workpiece movement/whip during bending. OSHA identifies presence sensing, two-hand controls, pullback/restraint and other guarding approaches depending on the operation. `DOC-CONFIRMED`.

OSHA's hydraulic-press guidance separately emphasizes severe point-of-operation injury potential and operator material handling, while its press-brake directive distinguishes normal-production safeguarding from hazardous-energy control for servicing/maintenance. `DOC-CONFIRMED`.

A current Lazer Safe Sentinel installation manual demonstrates an important implementation fact without making it universal: press-brake guarding can depend on measured/calculated stopping-time limits and light-curtain response/distance parameters. Therefore stop performance is a physical validation input, not a value to invent from controller logic. `DOC-CONFIRMED` for that product; transfer to other machines is `INFERENCE` only.

## Machine/lifecycle boundary

Include, where present:

- ram/beam/slide and upper/lower tooling;
- frame/bed and point of operation;
- workpiece and supports/followers;
- backgauge and other powered positioning axes;
- hydraulic power unit, cylinders, manifolds/valves, accumulators and trapped-pressure volumes;
- electrical drives, contactors, brakes and stored electrical energy;
- front, side and rear access paths;
- foot pedal, two-hand controls and other cycle initiation;
- optical/presence safeguards and guards;
- safety-related controller and physical final elements;
- tooling retention and mechanical maintenance/restraint devices;
- material-handling aids and nearby helpers/operators.

Lifecycle states: production bending, setup/programming, tool change, first-piece proving, recovery/jam clearing, cleaning, maintenance, validation and decommissioning.

## Hazardous-energy / hazardous-event map

1. **Point-of-operation closing motion** — crushing/shearing between tooling, workpiece and body.
2. **Workpiece motion** — part rise/whip/drop during bend; pinch/crush between workpiece and ram/front face/support/fixed structure.
3. **Ram/beam gravity and stored fluid energy** — hazardous descent or inability to hold a safe state after ordinary power/command removal, depending on machine architecture.
4. **Hydraulic stored pressure** — accumulator/trapped pressure or load-supported pressure can remain after pump shutdown.
5. **Backgauge/auxiliary axes** — crush/pinch or unexpected motion at rear/side zones independent of the primary ram proposition.
6. **Tooling** — tool change, retention, falling/heavy tooling and incorrect installation hazards.
7. **Electrical/stored energy** — drives, DC buses and cabinet energy during service.
8. **Unexpected cycle initiation/restart** — foot pedal/control actuation, reset/rearm mistakes or power restoration.

Exact hydraulic paths and failure consequences are machine-specific and remain `UNKNOWN` until schematic/source/measurement evidence exists.

## Core physical-proposition freezes

- `PUMP OFF != RAM/BEAM SAFE STATE PROVED`.
- `VALVE COMMAND OFF != HAZARDOUS DESCENT PREVENTED PROVED`.
- `PRESSURE READING LOW != MECHANICAL LOAD RESTRAINED PROVED`.
- `LIGHT CURTAIN CLEAR != POINT OF OPERATION SAFE`.
- `LIGHT CURTAIN INTERRUPTED != RAM PHYSICALLY STOPPED PROVED`.
- `RAM STOPPED != STORED HYDRAULIC/GRAVITY ENERGY REMOVED`.
- `FOOT PEDAL RELEASED != UNEXPECTED RESTART PREVENTED PROVED`.
- `FRONT POINT-OF-OPERATION SAFEGUARDED != REAR/SIDE HAZARDS CONTROLLED`.
- `NORMAL PRODUCTION SAFEGUARD != TOOL-CHANGE/MAINTENANCE RESTRAINT`.

## SRS skeleton

### Generic clauses transferred

- **SRS-GEN-ESTOP:** E-stop demand produces the defined safe response for every hazardous energy/motion path in its scope; reset does not restart.
- **SRS-GEN-RESET:** reset/rearm is deliberate, does not initiate hazardous motion and enables a separate start decision.
- **SRS-GEN-POWER:** loss/restoration of control or mains power cannot itself cause hazardous restart.
- **SRS-GEN-MAINT:** servicing requiring hazardous-energy control uses isolation, dissipation/restraint and verification; production safeguarding is not substituted for maintenance isolation.
- **SRS-GEN-DIAG:** ordinary LinuxCNC/FPGA/HMI diagnostics do not replace safety-related control or physical proof.

### Modified press-brake clauses

- **SRS-PB-POO:** during an operating cycle, the selected point-of-operation safeguarding strategy prevents unacceptable personnel exposure to the closing/tooling hazard for the actual bend mode and material-handling task.
- **SRS-PB-STOP:** when a protective device requires stopping, the machine achieves the validated physical stopping proposition before a person can reach the hazard. Exact stopping time/distance is `UNKNOWN` until measured/justified.
- **SRS-PB-WORKPIECE:** safeguarding and work method account for hazardous workpiece movement/whip and pinch zones created by the bending part, not only the die gap.
- **SRS-PB-ACCESS:** front, rear and side access paths are separately assessed; protection of the front point of operation does not automatically protect backgauge or rear/side hazards.
- **SRS-PB-MODE:** production, setup, tool-change and maintenance states have explicit authority/safeguard rules; a convenience setup mode cannot silently become unprotected production.

### New press-brake clauses

- **SRS-PB-GRAVITY:** any gravity-loaded ram/beam hazard has a named physical prevention/holding/restraint proposition appropriate to the actual machine; ordinary software command removal is insufficient evidence.
- **SRS-PB-FLUID:** every stored-fluid-energy path relevant to personnel exposure has a named isolation/dump/holding proposition and validation method. No generic valve truth table is assumed.
- **SRS-PB-TOOLCHANGE:** tool installation/removal and work inside the die/ram danger region use a maintenance/setup strategy that addresses gravity, stored energy and tooling retention independently of normal production guarding.
- **SRS-PB-CYCLE:** foot pedal/two-hand/other cycle initiation is mode-appropriate, protected against unintended actuation where required, and cannot defeat the selected point-of-operation safeguard.
- **SRS-PB-AUX:** backgauge, follower/support and auxiliary motion hazards have their own safe-state/authority path where personnel can be exposed.
- **SRS-PB-HELPER:** multi-person bends or helper exposure require safeguarding/start logic and work practices that protect every exposed person; operator control alone is not proof of helper safety.

## Authority boundary

Ordinary LinuxCNC or an FPGA may calculate bend sequence, command proportional valves/drives, position backgauges, display safety status and request stops. It is not credited as the sole personnel-safety authority. Independent safety-related control must command/monitor the justified safety architecture, while physical final elements and mechanical restraints establish the actual energy/motion state.

The separate OpenPressBrake controller-board automation may develop normal-control valve electronics; this curriculum does not transfer safety authority to those ordinary outputs.

## Validation skeleton

For each SRS requirement: define physical proposition, operating mode/preconditions, demand/fault, expected response, physical measurement/witness, acceptance criterion, result and revalidation trigger.

Press-brake-specific validation questions include:

1. Does point-of-operation protection remain effective for the actual part geometry and bend sequence, including part movement/whip?
2. Does interruption of a protective device produce the required physical stop within the measured/validated limit?
3. Can any rear/side/auxiliary motion remain hazardous after the front safeguard has responded?
4. On pump/control-power loss, what physically prevents hazardous ram/beam movement, and how is that proposition proved?
5. What trapped/accumulated pressure remains after shutdown and how is it safely dissipated/verified for maintenance?
6. Can reset, foot-pedal restoration or power restoration cause an unexpected cycle?
7. During tool change or maintenance, what mechanical/energy-isolation method protects a person in the die/ram hazard region?
8. What happens under a stuck valve, failed feedback device, broken safety channel, common supply loss or mismatched controller state? Exact answers remain machine-specific until evidence exists.

## Safe-to-operate threshold

If the point-of-operation safeguard, unexpected-restart prevention, rear/side exposure control, and required gravity/fluid-energy safe-state propositions cannot be established for the actual machine, it should not be operated with people exposed to the hazard. Experimental operation must remain isolated/remote with people outside the danger zone and residual risk stated explicitly.

## UNKNOWN register

- machine-specific hydraulic truth table and valve topology;
- fail state and diagnostic coverage of each valve/pressure sensor;
- actual ram/beam gravity behavior;
- accumulator/trapped-volume inventory;
- required/achieved stopping time and distance;
- optical safeguard safety distance and muting/blanking configuration;
- PL/SIL/integrity target;
- safe speed or pressure thresholds;
- backgauge/follower safe states;
- proof-test intervals;
- exact tooling-restraint and maintenance-block requirements;
- specific machine compliance with any current B11/ISO/EN press-brake standard.

## Evidence anchors

- OSHA eTool, *Powered Press Brakes*: operator involvement, point-of-operation hazards, accidental cycling and workpiece movement, safeguarding methods. `DOC-CONFIRMED`.
- OSHA eTool, *Hydraulic Presses*: severe point-of-operation hazard and production safeguarding context. `DOC-CONFIRMED`.
- OSHA CPL 02-01-025, *Guidelines for Point of Operation Guarding of Power Press Brakes*: normal-production safeguarding versus servicing/maintenance hazardous-energy control. `DOC-CONFIRMED`.
- Lazer Safe, *Sentinel Press Brake Guarding System Installation Manual*, v1.15 (2024): product-specific stopping-time/light-curtain parameterization and automatic light-curtain test behavior. `DOC-CONFIRMED` for that system only.

## Exact next work

Trace professional hydraulic press-brake safety architectures from inspectable manufacturer schematics/manuals: follow protective-device/E-stop demand through independent safety logic to physical valves/contactors/holding or restraint elements and feedback. Compare at least two implementations before generalizing. Preserve machine-specific differences and keep all unsupported physical values `UNKNOWN`.
