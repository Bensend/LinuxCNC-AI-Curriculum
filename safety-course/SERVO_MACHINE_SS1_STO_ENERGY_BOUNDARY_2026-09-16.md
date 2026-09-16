# Servo-machine SS1/STO energy-boundary trace — 2026-09-16

## Objective

Create a reusable professional servo-machine safety trace that distinguishes **controlled stopping**, **torque prevention**, **holding/gravity restraint**, **guard unlocking**, and **electrical isolation**. This is the servo-machine counterpart to the press-brake hydraulic energy-boundary work.

## Authoritative manufacturer evidence

### Siemens SINAMICS Safety Integrated

Siemens documents application patterns in which an E-stop selects SS1, the converter brakes the motor, and the drive then transitions to STO. Siemens separately documents Safe Brake Control (SBC) for safe control of a motor holding brake and SOS/SLS/SS2 for applications where monitored standstill or limited motion is required.

Siemens also states for SINAMICS drive architecture that STO can disable torque without physically disconnecting the power electronics. Therefore:

`STO != mains isolation`

### Rockwell Automation safe-motion examples

Rockwell documents SS1 as initiating and monitoring controlled motor deceleration and then using its output to request drive STO at/near the configured standstill condition. A 2023 guard-door/SLS application example shows a sequence in which safe-motion logic leads through SS1/STO and guard unlocking only after the required state is achieved.

Rockwell explicitly warns in its safe-position/guard-door material that a standstill based on STO is **not valid for overdriving or gravitational loads that may move after motor torque is removed**.

Evidence class: `DOC-CONFIRMED`.

## Energy-state trace

### Normal run

`normal CNC/motion controller -> drive motion command -> energized drive power stage -> motor torque -> axis motion`

Safety system independently supervises the relevant protective devices and safe-motion state.

### Guard/E-stop requiring controlled stop

Representative professional pattern:

`guard/E-stop safety demand -> safety controller / drive safety function -> SS1 -> controlled deceleration -> standstill criterion -> STO -> torque-producing authority inhibited`

Depending on machine design, a holding brake may then be controlled through an independent safe brake function such as SBC.

### What STO establishes

STO establishes a safety-related prevention of torque generation by the drive when correctly implemented and validated for the drive/application.

It does **not** by itself establish:

- open mains disconnect;
- discharged DC link;
- electrically dead motor terminals;
- prevention of gravity/overhauling-load motion;
- mechanical immobilization;
- safe maintenance access.

### What SS1 adds

SS1 provides a controlled stopping phase before STO. This can be important where immediate torque removal would allow excessive coast or an undesirable uncontrolled stop.

It does not turn E-stop into maintenance isolation.

## Gravity/overhauling axis

For a vertical axis, suspended head, robot joint or other load that can move when motor torque disappears, this chain is incomplete:

`SS1 -> STO`

The machine must separately address the load-retention hazard. Depending on the actual machine this can involve a validated holding brake, counterbalance, mechanical restraint, hydraulic load-holding element or another engineered measure. The correct architecture cannot be invented generically.

This directly parallels the press-brake finding that `pump off` does not prove `ram cannot descend`.

## Guard unlocking

A professional safe-motion architecture can intentionally keep a guard locked while hazardous motion remains and unlock it only after the required safe state is established. Conversely, applications using SLS/SOS may intentionally permit access while limited/monitored motion remains available.

Therefore the curriculum must not teach:

`guard open = all machine electrical power removed`

The correct question is:

`What safe state is required for this hazard and task, and which independent safety function/final element establishes it?`

## Electrical isolation for maintenance

Safe-motion functions are operating safety functions, not a substitute for electrical isolation where the maintenance task requires de-energization. The physical isolation trace remains separate:

`facility supply -> machine disconnect -> branch protection/contactors -> drive line/DC bus -> motor`

The maintenance procedure must identify the isolation boundary and stored-energy/discharge requirements for the actual drive.

## Failure-path analysis

### Ordinary CNC commands zero but drive safety remains enabled
Normal controller state is not independent safety evidence. A software fault, stale command or drive-interface fault remains possible.

### SS1 cannot decelerate as expected
A professional SS1 function monitors the stop against configured limits and transitions/faults according to its validated implementation. Exact timing/limit values are application-specific and must not be invented.

### STO succeeds on a vertical load
Motor torque disappears, but gravity may still move the load. Additional holding/retention safety measures are required when the hazard analysis identifies this condition.

### Guard unlocked from ordinary PLC bit
This bypasses the intended safety-state proof if the guard-lock release is safety-related. Guard release must be derived from the validated safety architecture where required.

### Drive reports STO but maintenance begins on live DC bus
Personnel can still face electrical hazard because torque prevention is not electrical isolation. Maintenance isolation/discharge procedure remains separate.

## Comparison with hydraulic press brake

| Servo machine | Hydraulic press brake analogue |
|---|---|
| ordinary velocity/torque command zero | proportional command zero |
| SS1 controlled deceleration | controlled hydraulic deceleration/soft-stop function |
| STO | safety valve path removing hazardous actuation authority |
| safe holding brake / gravity restraint | monitored holding/load-control valve + mechanical ram restraint as applicable |
| drive mains/DC isolation | pump/main electrical disconnect + stored-pressure control |
| safe speed/position feedback | Y1/Y2 position/valve-state monitoring |

The analogy is conceptual only; it is not a claim of equivalent PL/SIL or implementation.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC and the normal FPGA controller can request stops, command zero, report status and implement non-safety watchdog/fault containment. They must not silently become the sole personnel-safety authority.

For servo axes, expose separate interfaces for normal enable/command and drive safety functions such as STO where the drive provides them. For hydraulic axes, preserve the same separation between ordinary proportional-current control and independent hydraulic safety authority.

## Claims ledger

| Claim | Classification |
|---|---|
| SS1 is a controlled deceleration followed by a safe state such as STO in documented drive applications | DOC-CONFIRMED |
| STO is distinct from electrical isolation | DOC-CONFIRMED |
| STO alone does not safely retain every gravitational/overhauling load | DOC-CONFIRMED |
| Safe brake control can be a distinct safety function | DOC-CONFIRMED |
| Guard access may be conditioned on standstill or may use limited safe motion depending on application | DOC-CONFIRMED |
| A particular OpenPressBrake/retrofit axis needs a specific SS1 time, SLS speed, PL/SIL or brake design | UNKNOWN until machine-specific analysis/validation |

## Next work

Use an inspectable complete machine-tool electrical schematic to identify where its guard/E-stop safety chain lands: drive STO terminals/network safety, spindle/servo contactors, brake outputs and main isolation. Overlay this with the generic manufacturer drive-safety trace above.

No compute is required for the current evidence question.
