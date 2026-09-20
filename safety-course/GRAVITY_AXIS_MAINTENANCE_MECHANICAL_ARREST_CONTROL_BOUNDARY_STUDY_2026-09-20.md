# Gravity-axis maintenance mechanical-arrest and control-boundary study

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Question

When personnel must work at or near a gravity-loaded vertical axis, what evidence is required beyond ordinary control disable, STO, a holding-brake command, or LinuxCNC state before the axis can be treated as physically secured for maintenance?

## Evidence labels

- **DOC-CONFIRMED** — directly supported by cited professional/manufacturer documentation.
- **SOURCE-CONFIRMED** — directly supported by inspectable source/configuration.
- **TEST-CONFIRMED** — demonstrated by an applicable controlled test.
- **COMMUNITY-REPORTED** — reported by practitioners but not independently established here.
- **INFERENCE** — engineering conclusion drawn from confirmed evidence; not itself a quoted requirement.
- **UNKNOWN** — not established for OpenPressBrake.

## DOC-CONFIRMED — DGUV/IFA vertical-axis maintenance guidance

IFA Report 7/2013e treats maintenance, cleaning, and repair at or next to vertical axes as a distinct hazard case. Where feasible it calls for safe support / arrest of the vertical axis, a lockable mains disconnect, clear indication of interlocked/unlocked state, and—in the described arresting-device architecture—control interrogation of the arresting position and interlocking with drive control. Where safe suspension is not reasonably feasible, the report still calls for moving to the lowest position where possible, describing safe-support measures, disconnecting and locking the mains switch, warning against presence under the vertical axis, and use of skilled personnel.

This is a useful architectural boundary: control inhibition and electrical isolation address unexpected actuation, but a gravity-loaded member can retain mechanical potential energy. A maintenance-safe state therefore cannot be inferred solely from LinuxCNC disabled, FPGA outputs low, STO active, contactors open, or a brake command asserted.

## DOC-CONFIRMED — holding brake is not automatically a stopping brake

Rockwell Automation's Safe Brake Control application technique distinguishes holding from stopping. It states that holding brakes are intended to keep a stationary disabled load from moving and are not designed to stop a moving motor. It also describes sequencing that keeps motor torque present while the brake applies, helping prevent a vertical load from dropping. Brake manufacturers define maintenance/inspection requirements and actuation-cycle limits.

Yaskawa Sigma-II documentation similarly describes the servomotor brake as a de-energization holding brake for preventing gravity movement after power-off and says it is used to hold a stopped motor rather than as a braking device.

Therefore:

**BRAKE COMMAND APPLIED != BRAKE PHYSICALLY ENGAGED != REQUIRED HOLDING CAPACITY PROVED != AXIS MECHANICALLY SECURED FOR PERSONNEL ENTRY.**

## DOC-CONFIRMED — static brake test is a hazardous proof action, not a maintenance support

STOBER SD6 documentation describes a brake-test action that applies a defined test torque/force against the engaged brake to check whether required holding capability remains. It explicitly warns that if test force exceeds brake capability, a gravity-loaded axis can move or drop and requires the travel area to be clear.

This separates periodic functional proof from maintenance restraint:

**BRAKE TEST REQUEST != BRAKE HELD TEST LOAD != SAFE SUPPORT INSTALLED != PERSONNEL MAY ENTER THE DROP/CRUSH ZONE.**

A test that intentionally challenges a brake must not be confused with the physical support/arrest used to make intrusive maintenance safe.

## Practical architecture freeze

For a gravity-loaded axis, keep these claims separate:

`ordinary motion stopped -> safety stop / drive inhibition established -> hazardous energy isolated as required -> gravity/load path identified -> mechanical support/arrest established where required -> support/arrest state verified -> maintenance access permitted`

On return to service:

`maintenance complete -> personnel/tools clear -> support/arrest removal deliberately controlled -> safety devices restored -> final-element/brake function revalidated as required -> safety reset/rearm -> separate fresh ordinary start`

Freeze:

**LINUXCNC DISABLED != STO ACTIVE != MOTOR TORQUE ABSENT != GRAVITY ENERGY REMOVED.**

**BRAKE OUTPUT OFF/ON STATE != BRAKE MECHANICALLY ENGAGED != LOAD PHYSICALLY RETAINED.**

**LOAD RETAINED BY A SERVICE BLOCK/ARREST != MACHINE READY FOR MOTION.**

**SUPPORT REMOVED != SAFETY REARMED != FRESH START AUTHORITY.**

## Failure-path / commissioning questions

A machine-specific maintenance and commissioning plan should answer, without assuming OpenPressBrake details:

1. What members can fall, drift, rotate, spring, or otherwise move from stored mechanical/gravity energy after electrical/hydraulic power is removed?
2. What physical support, blocking, pinning, arresting, lowest-position strategy, or equivalent is approved for each intrusive maintenance task?
3. Is the support intended for personnel protection, merely setup convenience, or both? Do not promote a convenience prop into a safety device without evidence.
4. How is engaged versus disengaged support state made unmistakable to the technician?
5. If support state is electrically monitored, does loss/misadjustment of that sensor defeat motion inhibition? Sensor state is still not proof of support strength.
6. Can normal control, LinuxCNC, FPGA, drive, hydraulic, pneumatic, or manual valve action move against an installed support? If so, what prevents damaging or ejecting it?
7. What happens after power restoration while the support remains installed? Motion must not arise merely because ordinary control state recovered.
8. After support removal, what brake/final-element/retaining-function tests are required before production authority returns?
9. Are test procedures themselves capable of dropping/moving the axis? If so, define an exclusion zone and safe test setup from authoritative machine documentation.
10. Does maintenance require a separate lockout/isolation procedure even when functional-safety functions are healthy? Preserve that separation explicitly.

## LinuxCNC/OpenPressBrake boundary

LinuxCNC/HAL and the ordinary FPGA may display maintenance state, inhibit normal commands, or report support/arrest sensors, but those functions do not become personnel-safety authority merely because they are useful. The independent safety architecture and physical maintenance controls must carry the personnel-protection claim appropriate to the machine.

For OpenPressBrake specifically, the ram/load geometry, approved blocking method, mechanical arrest device, arrest sensing, load capacity, hydraulic trapped-energy behavior, brake presence, maintenance position, lockout procedure, and post-maintenance proof sequence are **UNKNOWN** here. No values or topology are invented.

## Relationship to the primary lane

This study deliberately does not duplicate the primary lane's hydraulic holding/safety-valve service, individual retaining-element challenge, press-brake stopping-time proof, or operating-mode cold-start work. It addresses the independent physical-maintenance boundary: preventing gravity/stored mechanical energy from becoming a personnel hazard while work is performed.

## No-compute decision

No executable verification is justified. A software simulation cannot prove the strength, placement, engagement, or load-retention capability of a real maintenance support/arrest. No GitHub-hosted or self-hosted runner compute was consumed.

## Precise next-work checkpoint

Seek an authoritative press-brake or comparable gravity-axis OEM maintenance procedure that traces:

`maintenance request -> ram/axis placed in documented service position -> hazardous energy isolated -> physical block/pin/arrest installed -> engagement positively verified -> intrusive work -> personnel/tools clear -> controlled support removal -> safety/final-element revalidation -> reset/rearm -> fresh production start`

Prefer a source that explicitly states how the physical support is rated/engaged and how motion is prevented while it is installed. Do not infer an OpenPressBrake support design from generic vertical-axis guidance.