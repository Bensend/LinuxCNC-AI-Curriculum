# Rockwell enabling-switch fault injection and functional proof-test lifecycle

Date: 2026-09-20
Course: 4000 safety / professional machine implementation

## Question

After the existing curriculum established enabling-device positions, separate jog authority, contactor power removal, post-replacement testing, and physical reduced-speed checks, what evidence shows that commissioning/maintenance must also challenge hidden wiring/network/output faults rather than only prove the happy path?

## Authoritative evidence

### Rockwell Safety Function: Enabling Switch — SAFETY-AT055

**DOC-CONFIRMED.** Rockwell's verification/validation checklist includes abnormal-operation tests while the system is jogging. One explicit test shorts Channel 1 to Test Source 1, then operates the enabling switch. Expected disposition: both contactors de-energize; machine and safety-program status indicate the condition; the system cannot reset/restart while the fault remains.

The same checklist deliberately removes the Ethernet connection between safety I/O and the controller while the system continues to run. Expected disposition is again de-energization of all contactors with machine/I/O diagnostic indication. Communication is then restored as a separate step.

Source: Rockwell Automation, *Safety Function: Enabling Switch*, publication SAFETY-AT055, verification/validation checklist. https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at055_-en-p.pdf

This is stronger than a catalog claim because the manufacturer directs deliberate fault insertion into an assembled safety function and requires observation of the physical final elements.

### Rockwell machine-safety validation guidance

**DOC-CONFIRMED.** Rockwell's safety application techniques describe validation as functional testing of the safety control system under normal operating conditions and potential fault injection of failure modes, normally documented with a checklist.

Source: Rockwell Automation, *Emergency Stop Products: Integrated Safety Controller Connected to a Series of Dual-channel E-stop Buttons*, SAFETY-AT036C-EN-P, 2021. https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at036_-en-p.pdf

### Functional verification/proof-test interval boundary

**DOC-CONFIRMED.** Rockwell's GuardLogix safety reference says IEC 61508 functional verification tests occur at user-defined intervals; the controller can have a long interval while safety I/O, sensors and actuators may require shorter intervals, and the controller should be included when testing those other components. Current PowerFlex safety documentation similarly says proof-test interval is application-dependent and other system components can have different useful lives/test needs.

Sources:
- Rockwell Automation, *GuardLogix Controller Systems Safety Reference Manual*, 1756-RM093J-EN-P.
- Rockwell Automation, *PowerFlex 755T Safe Stop Functional Safety — Safety Application Requirements*.

**DOC-CONFIRMED.** Current PointMax safety-I/O documentation gives a concrete example of why architecture matters: some safety-output modes require functional testing that the output can reach the safe state at specified intervals, with the interval depending on architecture/application assumptions. This is not an OpenPressBrake interval and must not be copied as one.

Source: Rockwell Automation, PointMax safety output module documentation, *Safety Application Suitability Levels*.

## Evidence ladder

The assembled safety function must not stop at these weak observations:

`input status changes -> safety logic says stop -> output command says off`

The Rockwell enabling-switch validation provides a stronger chain:

`deliberately inserted wiring/network fault -> safety logic detects/handles fault -> external contactors de-energize -> diagnostics visible -> reset/restart inhibited while fault persists -> fault physically removed/restored -> recovery/requalification handled separately`

## Frozen distinctions

- **NORMAL FUNCTION TEST PASSED != REPRESENTATIVE FAULT RESPONSE VALIDATED.**
- **SAFETY INPUT CHANGED STATE != FIELD WIRING FAULT DETECTION PROVED.**
- **SAFETY PROGRAM OUTPUT OFF != EXTERNAL CONTACTORS PHYSICALLY DE-ENERGIZED.**
- **NETWORK CONNECTION RESTORED != SAFETY FUNCTION AUTOMATICALLY REQUALIFIED.**
- **FAULT DIAGNOSTIC VISIBLE != RESET/RESTART AUTHORIZED.**
- **ONE-TIME COMMISSIONING TEST != LIFETIME PROOF-TEST OBLIGATION SATISFIED.**
- **CONTROLLER PROOF-TEST INTERVAL != SENSOR/I/O/ACTUATOR PROOF-TEST INTERVAL.**
- **MANUFACTURER EXAMPLE INTERVAL != OPENPRESSBRAKE INTERVAL.**

## Practical curriculum contract

A safety validation/return-to-service worksheet should identify, per safety function:

1. normal demand test;
2. representative single faults that the claimed architecture is intended to detect/tolerate;
3. deliberate fault insertion method that does not create uncontrolled exposure;
4. expected physical final-element disposition;
5. expected diagnostics;
6. whether reset is inhibited while the fault remains;
7. restoration step;
8. required requalification after restoration;
9. fresh ordinary start requirement;
10. recurring functional/proof-test requirement and its authoritative basis.

This is **INFERENCE** as a reusable worksheet structure synthesized from the manufacturer evidence. It is not a claim that every machine requires identical injected faults.

## OpenPressBrake boundary

For OpenPressBrake, do not invent:

- required PL/SIL;
- proof-test interval;
- diagnostic coverage;
- exact faults that must be injected;
- hydraulic fault truth tables;
- safe stopping time/distance;
- whether a particular network or safety-I/O architecture will be used.

Those remain **UNKNOWN** until the actual safety architecture/risk assessment/component requirements establish them.

LinuxCNC and the ordinary FPGA may log/display the results of these tests, but personnel-safety authority remains in the independent safety architecture and physical final elements.

## Information-gain result

The generic enabling-device *position* branch was already source-limited, but this manufacturer checklist reopens a different, higher-value dimension: deliberate abnormal-operation validation of the assembled safety function. Further generic enabling-switch catalog searching is still low value. Next work should build a cross-function commissioning/maintenance validation matrix that distinguishes happy-path function tests, deliberate fault-injection tests, quantitative physical performance tests, and periodic proof tests, using existing authoritative course evidence rather than inventing machine-specific requirements.

## Compute

No simulation/build/test compute was justified. No GitHub-hosted runner used. No self-hosted compute needed.
