# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14. F02 GRADUATED; valid evaluator `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md`; closeout `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15 after formal promotion/playbook-completeness review. Closeout: `evaluation/3000-series-promotion-closeout-2026-09-15.md`.

Do not routinely reopen closed levels without a genuinely new material defect.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

### Primary active priority — safety course / professional machine implementation

The owner has promoted the LinuxCNC/OpenPressBrake safety course to the primary active 4000 priority. Routine controller-board development remains a separate automation concern and must not displace safety work here.

Current safety emphasis: commissioning/validation includes common-cause and latent-failure analysis, a qualitative minimum-safe-to-operate gate, mode/feedback integrity, physical final-element proof, personnel-retention/restart-prevention for bodily-entry hazards, gravity-axis retaining-function proof/recovery, guard-locking/escape-release authority, safety-network identity/recommissioning authority, physical stop-performance validation, individual hydraulic final-element disagreement/inhibit behavior, post-replacement machine-level safety revalidation, and explicit separation between switching-state evidence and physical hydraulic/motion witnesses.

Newest primary-lane study: `safety-course/CINCINNATI_FM_VALVE_SERVICE_AND_POST_SERVICE_EVIDENCE_BOUNDARY_2026-09-19.md`. A real CINCINNATI FM OEM manual states that reservoir/cylinder manifold valves are removable for service/replacement and requires the ram to be physically blocked, machine power off, and the electrical disconnect off/locked before valve service. Its accessible maintenance material does not provide an individual post-replacement static retaining challenge, companion-path masking defeat, or a valve-replacement-triggered stopping test. Freeze: **RAM BLOCKED FOR VALVE SERVICE != SERVICED VALVE RETAINING FUNCTION PROVED != STOPPING PERFORMANCE PROVED != SAFETY REARM != PRODUCTION AUTHORITY** and **VALVE IS REMOVABLE/REPLACEABLE != OEM POST-REPLACEMENT PROOF PROCEDURE IDENTIFIED**.

Prior BAYKAL study remains: `safety-course/PRESS_BRAKE_OEM_STOP_TIME_MAINTENANCE_AND_INITIAL_REVALIDATION_TRACE_2026-09-19.md`. BAYKAL identifies hydraulic safety-valve elements, requires an initial machine test-run checking emergency/safety/limit-switch function and hydraulic leakage, requires stop-time control every six months, and provides a connection point for the stop-time measuring device. Replacement-trigger behavior remains UNKNOWN.

Prior durable boundary remains: Lazer Safe PCSS Option 28 separately monitors holding/safety-valve command/contact agreement, while PCSS start-up tests separately measure actual beam stopping distance/time and block normal operation until required tests pass. **VALVE COMMAND/MONITOR AGREEMENT != HYDRAULIC LOAD RETENTION PROVED != RAM PHYSICALLY STOPPED != STOPPING PERFORMANCE PROVED != PRODUCTION AUTHORITY.**

Personnel-retention freeze: **ACCESS CLEAR != PERSONNEL CLEAR != RETAINED-PERSON LIST EMPTY != BLIND AREA CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.**

Gravity-axis proof freeze: **BRAKE TEST REQUEST != TEST TORQUE APPLIED != BRAKE HELD TEST TORQUE != LOAD PHYSICALLY RETAINED != TEST PASS != PRODUCTION AUTHORITY.**

Guard-locking freeze: **GUARD CLOSED != GUARD LOCKED != HAZARD CEASED != UNLOCK AUTHORIZED != PERSONNEL CLEAR != RESTART AUTHORIZED.**

Safety-network replacement freeze: **IP/NODE ADDRESS CORRECT != SAFETY DEVICE IDENTITY CORRECT != CONFIGURATION OWNERSHIP CORRECT != SAFETY CONFIGURATION VERIFIED != SAFETY CONNECTION RESTORED != FUNCTIONAL SAFETY REVALIDATED != HAZARDOUS-MOTION AUTHORITY != FRESH ORDINARY START.**

Hydraulic stop-proof freeze: **PROTECTIVE-DEVICE DEMAND != SAFETY OUTPUT CHANGED != HYDRAULIC FINAL ELEMENT REACHED SAFE POSITION != RAM STOPPED/RETRACTED AS REQUIRED != MEASURED STOP PERFORMANCE VALID != ACCESS SAFE.**

Replacement/revalidation freeze: **SAFETY-RELATED COMPONENT REPLACED != MACHINE SAFE TO RETURN TO SERVICE.** Machine-level revalidation does not itself establish an unmasked individual holding-valve load-retention proof.

Field-device revalidation freeze: **REPLACEMENT DEVICE INSTALLED != FIELD WIRING VERIFIED != SAFETY FUNCTION REVALIDATED != PHYSICAL HAZARD SAFE != PRODUCTION AUTHORITY.**

Home-shop maintenance rule: before work, remove/isolate/discharge/block/restrain or otherwise control the hazards relevant to the task. Never leave an unsafe/incomplete/bypassed machine unattended without unmistakable OUT OF SERVICE / DO NOT OPERATE tag-out or equivalent status. Tag-out communicates/preserves the state; it is not a substitute for physical hazard control.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Continue authoritative press-brake OEM/manifold service tracing for `specific holding/safety valve service/replacement -> individual retaining-function challenge without companion masking -> physical ram/load witness -> pass/fail disposition -> dynamic stopping-performance re-proof where applicable -> safety reset/rearm -> press-brake-specific production initiation`.
2. Prefer a machine/OEM service source that names the retaining/safety valve and states its post-service functional test. CINCINNATI now proves independent physical ram blocking for valve service, but not post-repair functional proof; BAYKAL proves periodic stop-time maintenance, but not the replacement trigger.
3. Determine whether replacement of a monitored holding/safety valve requires that machine's stopping/start-up test and/or a separate static load-retention proof.
4. Trace two-retaining-element failure beyond the test itself: after A PASS / B FAIL, identify documented physical load-safe disposition and whether/when A must be re-proved after B service. Do not invent degraded production.
5. Preserve stopping performance as a maintained physical property and preserve distinct witnesses for service restraint, valve switching state, static retention, beam stopping, and stored-energy state.
6. Resume routine 4000 controller-board work only when it directly supports this safety checkpoint or the safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.