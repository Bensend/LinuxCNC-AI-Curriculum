# Lane B checkpoint — gravity-axis maintenance mechanical arrest boundary

Date: 2026-09-20

## Durable progress

Added `safety-course/GRAVITY_AXIS_MAINTENANCE_MECHANICAL_ARREST_CONTROL_BOUNDARY_STUDY_2026-09-20.md` in commit `48da5ea69828054313bddcf66a0ceb9f185da44b`.

The primary lane's newest work before selection was operating-mode cold-start/post-power requalification, while its ongoing press-brake hydraulic lane remains focused on holding/safety-valve service and unmasked retaining-function proof. Lane B therefore selected the independent physical maintenance/gravity-energy boundary and did not modify those artifacts.

## Frozen boundary

**LINUXCNC DISABLED != STO ACTIVE != MOTOR TORQUE ABSENT != GRAVITY ENERGY REMOVED.**

**BRAKE COMMAND APPLIED != BRAKE PHYSICALLY ENGAGED != REQUIRED HOLDING CAPACITY PROVED != AXIS MECHANICALLY SECURED FOR PERSONNEL ENTRY.**

**LOAD RETAINED BY A SERVICE BLOCK/ARREST != MACHINE READY FOR MOTION.**

**SUPPORT REMOVED != SAFETY REARMED != FRESH START AUTHORITY.**

## Evidence state

- DOC-CONFIRMED: IFA/DGUV vertical-axis guidance treats maintenance near gravity-loaded axes as requiring energy isolation plus safe support/arrest measures where applicable, with clear arrest-state indication and drive interlocking in the described architecture.
- DOC-CONFIRMED: Rockwell Safe Brake Control guidance distinguishes holding a stationary load from stopping a moving motor and requires attention to brake maintenance/actuation limits.
- DOC-CONFIRMED: Yaskawa Sigma-II likewise identifies the motor brake as a holding brake for a stopped vertical load, not a dynamic stopping brake.
- DOC-CONFIRMED: STOBER's brake-test action deliberately challenges holding capability and warns that a failed gravity-axis brake test can cause movement/drop; therefore brake testing itself requires a safe exclusion/test setup.
- UNKNOWN: OpenPressBrake physical blocking/arrest method, ratings, geometry, sensing, maintenance position, hydraulic trapped-energy state, lockout sequence, and post-maintenance proof.

## Compute

No compute was justified or consumed. Physical support strength/engagement cannot be established by software simulation.

## Precise next work

Find a press-brake or closely comparable gravity-axis OEM maintenance procedure that explicitly traces service position, isolation, physical block/pin/arrest installation and positive engagement, intrusive work, controlled support removal, safety/final-element revalidation, reset/rearm, and fresh production start. Prefer a source that states how the support is rated and how powered motion is prevented while support is installed. Do not invent an OpenPressBrake blocking design.