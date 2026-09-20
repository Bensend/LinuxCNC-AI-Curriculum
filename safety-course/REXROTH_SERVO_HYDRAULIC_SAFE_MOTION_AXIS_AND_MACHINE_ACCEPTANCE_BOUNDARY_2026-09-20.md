# Rexroth servo-hydraulic Safe Motion axis and machine acceptance boundary

## Purpose

Add an independent hydraulic-machine evidence lane without duplicating the primary stopping-performance/configuration work. This study uses Bosch Rexroth CytroForce-M documentation to trace where electrical Safe Motion acceptance ends and servo-hydraulic machine acceptance begins.

## Evidence labels

- **SOURCE-CONFIRMED** — directly stated in cited manufacturer documentation.
- **INFERENCE** — engineering consequence assembled from confirmed facts.
- **UNKNOWN** — OpenPressBrake-specific fact not established by this source.

## Source trace

### 1. The personnel-safety path crosses electrical and hydraulic final elements

**SOURCE-CONFIRMED.** Bosch Rexroth RE62270-B describes the safety-capable CytroForce-M for safety-related machine applications including gravity-loaded axes in press applications. The optional control block uses two series valves with separate spool-position monitoring in a line to a safely isolated chamber. Its braking/holding system acts in both electrical and hydraulic sections: Safe Torque Off and Safe Brake Control are triggered together; the drive output stage is blocked and the two hydraulic safety valves are switched off through two channels.

Source: Bosch Rexroth, `Servo-hydraulic actuator CytroForce-M`, RE62270-B, 01.21, product description / functional safety, accessed 2026-09-20.

### 2. Axis validation is physical mapping evidence

**SOURCE-CONFIRMED.** In the safety-function validation sequence, Rexroth requires axis validation to check that Safe Motion sensing — including encoder/scaling settings — corresponds to the real movement of the mechanical axis and expected values. Axis validation is required when scaling or encoder settings change, and successful validation is required before the servo-hydraulic actuator is used in a safety-related application. The manual permits multiple ways to create the physical movement, including external command/enable and manual movement.

This supports the freeze:

**ENCODER DATA PLAUSIBLE != SAFE-MOTION SENSING MAPPED TO THE REAL MECHANICAL AXIS.**

### 3. Drive acceptance is not sufficient for the servo-hydraulic machine

**SOURCE-CONFIRMED.** RE62270-B says machine acceptance is required when the servo-hydraulic actuator safety technology is first parameterized or modified. It explicitly states that applying safety functions to the servo-hydraulic actuator requires more than the acceptance described in the generic IndraDrive Safe Motion documentation; servo-hydraulic-specific deviations/extensions are part of machine acceptance.

This is the key curriculum boundary:

**DRIVE SAFETY ACCEPTANCE PASSED != SERVO-HYDRAULIC MACHINE SAFETY ACCEPTANCE PASSED.**

**SAFE-MOTION PARAMETERS VERIFIED != HYDRAULIC FINAL-ELEMENT PATH PHYSICALLY VALIDATED.**

### 4. Replacement scope must respect the hydraulic-system boundary

**SOURCE-CONFIRMED.** Rexroth states that the servo-hydraulic actuator generally must not be opened and the hydraulic system must remain closed; if a defective component requires opening the hydraulic system, Rexroth Service is to be contacted. It separately identifies limited replacement/service operations that do not require opening the closed hydraulic system.

This does not supply a universal post-repair acceptance matrix. It does establish that replacement scope is architecture-dependent and that opening the hydraulic safety/energy path is not equivalent to replacing an external cable or cover.

## Architecture lesson

A professional hydraulic-axis safety case should preserve at least these distinct witnesses:

1. safety demand exists;
2. drive safety function is selected and behaves as configured;
3. safety-related motion sensing maps to the real mechanical axis;
4. electrical torque-producing path reaches its intended safe state;
5. hydraulic safety final elements reach their intended state, including any claimed monitored valve state;
6. the physical axis stops/holds/moves only as the safety function permits;
7. any required quantitative performance is separately accepted;
8. reset/rearm does not substitute for a fresh ordinary motion/start command.

Items 1–8 as a generic curriculum ladder are **INFERENCE**. Rexroth's documentation supports the separation of drive, sensing, hydraulic final elements and machine acceptance; it does not define the eventual OpenPressBrake sequence.

## LinuxCNC / FPGA boundary

LinuxCNC and the ordinary FPGA may request normal motion, expose diagnostics and record acceptance evidence. They do not become personnel-safety authority because an encoder value looks correct, STO is reported active, or a valve command bit is off. The safety argument must cross the independent safety path into the real hydraulic/mechanical axis.

## OpenPressBrake unknowns

The following remain **UNKNOWN**:

- eventual OpenPressBrake hydraulic safety topology;
- number/type/arrangement of safety valves;
- whether valve-position monitoring is used and what it proves;
- safe stopping/holding behavior and quantitative limits;
- gravity-axis load cases;
- pressure thresholds or pressure-decay requirements;
- acceptance test conditions and intervals;
- PL/SIL/Category/DC/CCF targets;
- which maintenance actions invalidate which hydraulic acceptance evidence.

Do not transplant CytroForce-M topology, values, or acceptance criteria into OpenPressBrake.

## Evidence disposition

This is useful new hydraulic evidence because it explicitly says generic drive acceptance is insufficient for a servo-hydraulic safety application and requires physical axis validation. It still does **not** close the repository's harder open gap: a manufacturer procedure combining monitored hydraulic final-element position with pressure/motion witness, quantitative acceptance, deliberate mismatch/fault response and post-repair return-to-service.

## Precise next work

Seek authoritative servo-hydraulic/press documentation that extends this boundary into one complete physical acceptance chain:

`protective demand -> electrical safe-motion response -> monitored hydraulic valve/final-element response -> pressure/motion/holding witness -> quantitative criterion -> mismatch/fault disposition -> repair/replacement -> affected-function retest -> production release`.

If no source exposes that chain, mark this branch source-limited and rotate rather than filling the gap with inferred hydraulic truth tables.
