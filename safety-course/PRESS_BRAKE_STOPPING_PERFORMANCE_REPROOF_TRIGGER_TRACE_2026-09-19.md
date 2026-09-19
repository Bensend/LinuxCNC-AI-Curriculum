# Press-Brake Stopping-Performance Re-Proof Trigger Trace

Date: 2026-09-19

## Purpose

Close part of the unresolved press-brake return-to-service gap with authoritative evidence for when physical stopping performance is re-proved, while keeping valve-state monitoring, stopping performance, hydraulic load retention, and production authority distinct.

## Primary source

Lazer Safe, *Sentinel Press Brake Guarding System Operation Manual*, LS-CS-M-066, Original Language Version 1.10, released 2021-09-03:
https://www.lazersafe.com/assets/documents/Operator-manuals/LS-CS-M-066-Sentinel-Press-Brake-Guarding-System-Operation-Manual-1.10.pdf

Evidence class below is `DOC-CONFIRMED` unless otherwise stated.

## Physical stopping witness

The Sentinel/PGS-2 system measures press-beam stop time and stop distance each time the beam is stopped. When the configured stopping limit is exceeded, an emergency stop is initiated and an overrun test is performed.

This supports:

**SAFETY STOP COMMAND != PHYSICAL STOPPING PERFORMANCE PROVED.**

The physical machine must still demonstrate acceptable stopping behavior.

## Start-up re-proof sequence

On power-up the Sentinel starts with an emergency-stop condition active. Operator Reset clears that condition and activates the relevant outputs, but the first closing sequence is not treated as ordinary production: the system requires a start-up overrun test.

For the test, the beam is deliberately moved down at high speed and automatically stopped. The manual says this tests the emergency-stop outputs and assesses the stopping performance of the press brake. A passing result is explicitly reported to the operator.

The manual then notes that after the start-up test it may be necessary to reset the machine emergency-stop circuit and/or restart the hydraulic pump.

This provides a useful authority separation:

`POWER RESTORED -> SENTINEL INITIALISED -> RESET / OUTPUT ENABLE -> DELIBERATE PHYSICAL OVERRUN TEST -> TEST PASS -> MACHINE E-STOP/PUMP RECOVERY AS REQUIRED -> PRODUCTION-READY PATH`

It is incorrect to collapse power-up/reset directly into production authority.

## Re-proof triggers

The overrun test is repeated:

- at every power-up;
- every 24 hours of continuous machine operation;
- when returning to high-speed operation after a slow-speed start-up test; and
- when the system detects that stopping performance has deteriorated significantly during normal operation.

This is especially important for the curriculum because it demonstrates that stopping performance is a **maintained physical property**, not a commissioning constant.

Freeze:

**INITIAL STOPPING TEST PASS != LIFETIME STOPPING-PERFORMANCE PROOF.**

and:

**DETECTED STOPPING-PERFORMANCE DETERIORATION -> RE-PROOF REQUIRED BEFORE NORMAL HIGH-SPEED AUTHORITY.**

## Fault clearing is bounded

The manual's reset interface distinguishes a clearable operator error from a persistent fault/emergency-stop condition. If Reset cannot clear the error, the underlying fault/emergency-stop condition must be corrected before the error can be cleared.

Therefore:

**PRESS RESET != REPAIR != PHYSICAL RE-PROOF.**

A reset request cannot manufacture a passing stopping-performance result.

## Relationship to hydraulic valve monitoring

The same manual defines EDM as external-device monitoring of a valve/solenoid monitor and states that the system monitors machine-process failures including hydraulic-valve failures. That is useful integration evidence, but it does not justify treating valve monitor agreement as the physical stopping witness.

Preserve:

**VALVE/SOLENOID MONITOR AGREEMENT != STOP TIME/DISTANCE PROOF != RAM/LOAD RETENTION PROOF != SAFE PRESSURE PROOF.**

## What this does not establish

`UNKNOWN` — This operator manual does not expose the exact hydraulic safe-state topology for each valve disagreement.

`UNKNOWN` — It does not establish that replacement of any particular hydraulic valve automatically triggers the overrun test; do not infer a service trigger that the source does not state.

`UNKNOWN` — It does not establish the required proof after replacement of a monitored retaining valve, nor whether another retaining element can mask a failed element during such proof.

`UNKNOWN` — It does not establish an OpenPressBrake stopping-distance/time value. No numerical value is transferred.

## Curriculum / commissioning implication

A press-brake validation package should treat the following as separate evidence objects:

1. safety demand accepted;
2. safety output changed;
3. monitored valve/final element reached the expected switching state;
4. ram physically stopped/retracted/retained as required;
5. measured stopping performance passed the machine-specific limit;
6. stored hydraulic energy/pressure is in the state required by the safety function;
7. any required fault repair is complete;
8. required physical re-proof has passed;
9. safety reset/rearm is accepted;
10. press-brake-specific production initiation authority is established.

Do not let ordinary LinuxCNC/HAL or a normal FPGA substitute command-state knowledge for items 3–8.

## Next target

Continue searching for OEM/service evidence that explicitly joins a **specific monitored hydraulic valve disagreement or replacement** to the physical ram/load-safe disposition and the required post-repair valve/restraint/stopping-performance proof. The Sentinel evidence closes the maintained-stop-performance/retest branch but does not close that valve-specific service chain.
