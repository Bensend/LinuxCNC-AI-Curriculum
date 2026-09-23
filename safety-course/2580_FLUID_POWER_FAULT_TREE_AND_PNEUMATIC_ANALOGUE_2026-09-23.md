# 2580 — Fluid-power fault tree and pneumatic analogue

## Purpose

Work backward from the physical proposition **hazardous closing/descent prevented**. This is deliberately not a machine-specific hydraulic truth table. The lesson separates functions that are often collapsed into one vague statement such as “the hydraulics are off.”

Evidence classes used here: `DOC-CONFIRMED`, `INFERENCE`, and `UNKNOWN`. No physical machine test has been performed.

## Four distinct hydraulic functions

1. **Directional blocking / neutral** — establishes a commanded or physically achieved flow-path state. It does not automatically isolate supply, exhaust trapped energy, or hold a gravity load.
2. **Supply isolation** — interrupts a source path. It does not automatically remove energy already stored downstream.
3. **Dump / decompression** — creates a path intended to reduce stored pressure. Its command or valve position does not prove every hazardous volume has reached a safe pressure.
4. **Load holding / mechanical restraint** — prevents hazardous load motion. This proposition is different from low supply pressure or a neutral directional valve.

A real machine may need several of these simultaneously or sequentially. None is a universal substitute for the others.

## Backward fault tree — hazardous closing/descent prevented

Top proposition: **H = hazardous closing/descent is prevented for the defined operating condition.**

H requires every physically relevant motion-producing path to be controlled. A generic decomposition is:

- **H1 — commanded hydraulic motion cannot continue or restart dangerously.**
  - safety-related control requests the defined safe state;
  - final hydraulic elements reach the required state;
  - a stuck spool or failed pilot path cannot silently preserve dangerous flow;
  - reset/rearm does not itself recreate a motion command.
- **H2 — an upstream pressure/flow source cannot continue driving the hazard through an unintended path.**
  - supply isolation/shutoff is achieved where required;
  - parallel, regeneration, pilot, cross-port, check-valve or bypass paths are included in the circuit analysis;
  - a single common hydraulic path is not mistaken for independent redundancy.
- **H3 — stored fluid energy cannot drive hazardous motion.**
  - accumulator energy is identified;
  - trapped cylinder/line/manifold volumes are identified;
  - decompression/exhaust paths actually reach the relevant volumes;
  - sensor placement is sufficient for the proposition being claimed.
- **H4 — gravity/external load cannot cause hazardous descent after active drive force is removed.**
  - the actual load-holding mechanism is identified;
  - hose/fitting failure is considered where it can bypass ordinary directional control;
  - internal valve leakage and cylinder/seal leakage are considered;
  - where fluid-power holding is insufficient for maintenance, a mechanical restraint is required.
- **H5 — covered failures are detected early enough to preserve the safety function or inhibit restart.**
  - valve-position diagnostics prove only the covered valve-position proposition;
  - pressure diagnostics prove pressure only at their measurement point within sensor/system evidence;
  - disagreement between command, valve position and pressure state causes the specified safe response;
  - diagnostics do not silently become the physical energy-removal mechanism.

## Failure-path matrix

| Failure / challenge | What can go wrong | Required reasoning response | What must remain UNKNOWN without design-specific evidence |
|---|---|---|---|
| Directional spool sticks in flow-producing position | neutral command exists but hazardous flow remains | independent shutoff/blocking or another justified final-element path must address the physical flow proposition; monitor covered spool state where applicable | exact failure rate, DC, achieved PL/SIL |
| Internal valve leakage / drift | closed/neutral valve does not indefinitely hold load | treat load holding as its own function; validate permissible drift and holding architecture for the actual load | leakage rate, safe dwell time |
| Accumulator remains charged | pump is off but stored energy can still move actuator | identify accumulator connection and isolation/decompression path; verify state at the hazardous volume | safe pressure threshold, decay time |
| Trapped line/cylinder volume | main supply and dump can both look safe while an isolated volume remains energetic | trace every trapped volume created by check valves, blocked ports and actuator chambers | residual pressure at uninstrumented points |
| Hose/fitting rupture | intended metering/blocking path is bypassed and gravity load can run away | evaluate load-holding/hose-failure protection close enough to the actuator for the actual failure path | load capacity and stopping distance |
| Cylinder/seal failure | pressure may transfer/leak and load can drift or descend | analyze actuator as part of final-element chain; mechanical restraint may be required for maintenance/exposure | failure consequence for an unspecified cylinder |
| Valve-position monitor disagrees | command and physical element state differ | latch/inhibit according to safety design; do not claim pressure or load state from position alone | whether the specific discrepancy timing meets a target integrity level |
| Pressure sensor reads low | one measurement point is low | state exactly which volume the sensor witnesses; separately analyze isolated volumes and gravity | pressure elsewhere in circuit |
| Common hydraulic manifold/path | nominally redundant electrical channels converge into one dangerous hydraulic failure | count physical dependencies, not wires; redesign or explicitly justify the common final element | achieved Category/PL/SIL |
| Replacement valve appears equivalent | response, leakage, spool arrangement, monitoring or duty differs | require change control and revalidation of affected propositions | equivalence based on package/port size alone |

## Diagnostic witness discipline

For every diagnostic, write two sentences:

1. **This evidence supports:** the narrow proposition actually observed.
2. **This evidence does not prove:** the next physical proposition that still needs evidence.

Examples:

- Valve-position switch: supports `covered spool/element is in the monitored position`; does not prove `downstream pressure is harmless`.
- Pressure transducer: supports `pressure at this sensing point is within the validated measurement condition`; does not prove `all trapped volumes are depressurized`.
- Pump-contactor feedback: supports `covered electrical final element changed state`; does not prove `accumulator energy is gone`.
- Mechanical block presence sensor: may support `block is detected in its monitored position`; does not by itself prove `block strength/engagement safely restrains the actual load`.

## Accumulators are an independent energy source

**DOC-CONFIRMED:** Parker describes piston accumulators as devices for energy storage/auxiliary power and notes that they may maintain fail-safe power after loss of pump or electric power. Parker also warns not to loosen fittings or disassemble an accumulator while it is pressurized.

Teaching consequence: **LOSS OF PUMP/ELECTRIC POWER != LOSS OF ACCUMULATOR ENERGY.** An accumulator can be intentionally useful to complete a safe cycle, but its stored energy must still appear explicitly in the hazard and maintenance analysis.

## Pneumatic analogue

Pneumatic safety has the same proposition problem even though the components differ.

Generic safe-exhaust chain:

`independent safety demand -> safe-exhaust final element(s) -> supply isolated + protected downstream volume connected to exhaust -> pressure/force falls as required -> hazardous pneumatic motion/force no longer possible`

### Authoritative anchors

**DOC-CONFIRMED:** Festo distinguishes SDE (safe de-energization of the directly downstream pneumatic system), SEZ (safe energization using a defined force/time behavior), and PUS (prevention of unexpected start-up). Festo also distinguishes pneumatic SS1 from SS2: SS1 reduces pressure after reaching the defined standstill condition, whereas SS2 maintains chamber pressure to maintain standstill.

**DOC-CONFIRMED:** Festo's MS6-SV documentation identifies safe exhausting and prevention of unexpected pressurization as safety functions and warns that downstream devices must not impair the pneumatic protective measure. It also specifies a forced switching interval for the cited configuration, demonstrating that diagnostic/proof-test assumptions are part of the application evidence rather than optional catalog trivia.

**DOC-CONFIRMED:** SMC's VP/VG residual-pressure-release family provides main-valve position detection. SMC states that in a dual residual-pressure-release arrangement, if one valve fails to operate the other can release residual pressure, and explicitly warns that the component alone does not guarantee safety of the complete equipment.

### Pneumatic failure tree

For the proposition **hazardous pneumatic motion/force prevented** ask:

- Is incoming supply actually isolated?
- Is the protected downstream volume actually connected to a sufficient exhaust path?
- Can a check valve, cylinder chamber, local reservoir, hose routing or downstream device trap pressure?
- Can gravity or an external load move the actuator after air force disappears?
- Does exhausting one side of a cylinder create motion rather than remove the hazard?
- Can repressurization itself create hazardous motion or force?
- Does reset merely rearm the safety function, or does it unintentionally repressurize/start the machine?
- Does the exhaust silencer/downstream hardware preserve the validated exhaust capability?
- Are valve-position diagnostics being mistaken for proof of downstream pressure?

## Repressurization / restart boundary

Safe exhaust is only half of the lifecycle. Repressurization can itself be hazardous.

A practical architecture should make the safe path easy:

`safety demand cleared -> explicit reset/rearm conditions satisfied -> safety system permits controlled repressurization -> soft-start/defined energization where required -> normal controller still needs a separate motion/start command`

Therefore:

- **SAFETY RESET != REPRESSURIZATION BY DEFINITION.**
- **REPRESSURIZED != MOTION START AUTHORIZED.**
- **SOFT START != PERSONNEL-SAFETY PROOF UNLESS IT IS PART OF THE VALIDATED SAFETY FUNCTION.**

## Electrical vs fluid-power vs mechanical risk reduction

| Hazard proposition | Electrical measure can contribute | Fluid-power measure may be required | Mechanical measure may be required |
|---|---|---|---|
| stop issuing motion command | yes | not necessarily | no |
| interrupt pump/solenoid electrical command | yes | not sufficient by itself | no |
| isolate pressure/flow path | command/monitoring only | yes | no |
| exhaust/decompress trapped fluid energy | command/monitoring only | yes | sometimes for residual load |
| hold gravity/suspended load | sensing/control may contribute | often | often for maintenance/exposure where fluid holding alone is insufficient |
| maintenance access into crush zone | LOTO status may be monitored | pressure isolation/decompression | positive restraint/blocking may be necessary |

The lesson must never turn the rightmost two columns into optional afterthoughts merely because LinuxCNC or an FPGA can observe more signals.

## Human-factors design rule

A safeguard that operators routinely defeat because restart is violent, exhaust is excessively disruptive, a block is hard to install, or recovery is opaque has a design problem. Prefer architectures with controlled repressurization, clear state indication, accessible approved restraints, and reset/recovery procedures that do not reward bypassing the safety path.

If the machine cannot establish the minimum physical safe-state proposition with people exposed, it should not be operated with people in the danger zone. Experimental operation must be isolated/remote with residual risk stated.

## New freezes

- **LOSS OF PUMP/ELECTRIC POWER != LOSS OF ACCUMULATOR ENERGY.**
- **REDUNDANT ELECTRICAL CHANNELS != REDUNDANT HYDRAULIC FINAL ELEMENTS.**
- **VALVE-POSITION FEEDBACK != PRESSURE/LOAD-STATE PROOF.**
- **SAFE EXHAUST VALVE OPEN != EVERY DOWNSTREAM VOLUME PROVED DEPRESSURIZED.**
- **PNEUMATIC SUPPLY EXHAUSTED != GRAVITY LOAD RESTRAINED.**
- **SAFETY RESET != REPRESSURIZATION != MOTION START AUTHORIZATION.**
- **MAINTENANCE ACCESS REQUIRES ENERGY/LOAD CONTROL BEYOND AN ORDINARY FUNCTIONAL STOP WHEN THE HAZARD DEMANDS IT.**

## Evidence still deliberately UNKNOWN

For any generic press/vertical-axis example: exact valve truth table, accumulator volume/precharge, pressure threshold, exhaust/decompression time, stopping distance, cylinder leakage, hose-failure transient, brake/block capacity, diagnostic coverage, Category, PL, SIL, and required safety distance remain `UNKNOWN` until design-specific evidence exists.

## Source provenance

- Existing 2580 source-preparation artifact and its Bosch Rexroth/Parker/HAWE references.
- Parker Hannifin, *Piston Accumulators — Service and Maintenance*, current manufacturer PDF surfaced 2026-09-23.
- Festo, *Safe pneumatics* safety-function guidance, current manufacturer page surfaced 2026-09-23.
- Festo, *Soft-start/quick exhaust valves MS-SV* documentation, 2025/01 edition surfaced 2026-09-23.
- SMC, VP/VG residual-pressure-release valve manufacturer documentation, current manufacturer pages surfaced 2026-09-23.

No executable lab was required; the unresolved questions here are architecture/evidence questions answerable without simulation.