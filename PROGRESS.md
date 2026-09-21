# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14. F02 GRADUATED.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15.

Do not routinely reopen closed levels without a genuinely new material defect.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

### Primary active priority — safety course / professional machine implementation

Routine controller-board development remains a separate automation concern and must not displace safety work here.

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; and human-factors controls that make temporary commissioning states difficult to carry into production accidentally.

Newest 25E0 evidence: `safety-course/SIEMENS_S120_SPEED_WITNESS_TORQUE_REMOVAL_AND_RESTART_WINDOW_2026-09-21.md` advances beyond final-element position/status into a process witness. Siemens S120 Safety Integrated documentation shows SBR/SAM monitoring of the motor-speed trajectory during stopping, with STO following the documented shutdown/standstill criterion or timing condition; it explicitly distinguishes SS1E, where the external stop is not monitored by SBR/SAM. Separate Siemens SSM commissioning documentation exposes a defined restart/re-entry sequence in one configuration rather than permitting restart semantics to be inferred from `speed below threshold` alone. `25E0_PROCESS_WITNESS_RESTART_ADVERSARIAL_EXERCISE_2026-09-21.md` tests the resulting witness and demand-freshness boundaries.

Prior 25E0 evidence retained: `safety-course/THIRD_FINAL_ELEMENT_PNEUMATIC_HYDRAULIC_VALVE_MONITORING_BOUNDARY_2026-09-21.md` completed the third-family final-element trace. SMC VP/VG documents main-valve position detection and redundant residual-pressure release; Festo distinguishes direct valve monitoring, indirect monitoring and process-level diagnostics; Bosch Rexroth separates position-monitored hydraulic supply blocking from safe decompression. Public authoritative evidence did not expose one universal valve state machine containing disagreement timer + latch + reset-edge + held-start semantics, so that narrow generic search remains at an information-gain stop.

Cross-vendor comparison retained: Rockwell Safe Brake Control has explicit mismatch timing, fault state and correction-plus-reset semantics, while Siemens 3SK1 documents a configuration where a Start detected during feedback fault can lead to start when the feedback error clears. Recovery/restart semantics are implementation-specific and must be traced from the actual safety function.

Freeze: **FINAL-ELEMENT COMMAND/STATUS != PROCESS RESPONSE**, **PROCESS WITNESS VALID != ALL HAZARDOUS ENERGY SAFE**, **SAFE SPEED/SSM CONDITION TRUE != ORDINARY START AUTHORIZED**, **STO ACTIVE != MECHANICAL LOAD SECURED**, **MONITORED STOP SUCCESS != STOPPING PERFORMANCE UNIVERSALLY VALIDATED**, **SS1E != SS1 WITH INTERNAL PROCESS MONITORING**, **RESTART WINDOW != DEMAND FRESHNESS**, **VALVE POSITION FEEDBACK VALID != PRESSURE SAFE**, **VALVE POSITION FEEDBACK VALID != FLOW STOPPED**, **SUPPLY BLOCKED != STORED DOWNSTREAM ENERGY DECOMPRESSED**, **MONITORED POSITION != UNIVERSAL RESET/RESTART SEMANTICS**, **BRAKE FEEDBACK RECOVERED != BRAKE SAFETY FUNCTION RESET**, **FAULT CAUSE CORRECTED != OUTPUTS AUTOMATICALLY RE-ENERGIZED (MANUAL RESTART)**, **CONTROLLER RUNNING != BRAKE RELEASE AUTHORIZED**, **BRAKE FEEDBACK VALID != BRAKE TORQUE PROVED**, **SBC INTEGRITY TRUE != STOPPING PERFORMANCE VALIDATED**, **FEEDBACK ERROR -> SAFE STATE != START REQUEST CANCELLED**, **FEEDBACK RESTORED != FRESH START**, **AUTOMATIC MODE CONFIRMED != PRODUCTION START**, **SAFETY PERMISSION RESTORED != FRESH ORDINARY MOTION DEMAND**, **ENABLING DEVICE CENTER != FRESH MOTION AUTHORITY**, **BUMPLESS TRANSFER != FRESH START**, **SAFETY RESET != START COMMAND**, and **ORDINARY PRODUCTION GATE TRUE != PERSONNEL-SAFETY RELEASE**.

Existing durable safety evidence remains authoritative in Git, including the typed exceptional-state manifest, four-class validation matrix, physical-change return-to-service procedure, hydraulic/final-element witness studies, stopping-performance/safeguard coupling, enabling-device/reset/start authority studies, maintenance-isolation work, and temporary simulated-I/O/force-state studies. Do not collapse heterogeneous evidence into a generic `SAFE=true` bit.

Core freezes retained:
- **ACCESS CLEAR != PERSONNEL CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.**
- **VALVE COMMAND SAFE != PHYSICAL HYDRAULIC SAFE STATE PROVED.**
- **SAFETY OUTPUT OFF != EXTERNAL FINAL ELEMENT PHYSICALLY SAFE.**
- **RESET ACCEPTED != START AUTHORIZED.**
- **SAFETY-RELATED COMPONENT REPLACED != MACHINE SAFE TO RETURN TO SERVICE.**
- **TESTED != VALIDATED unless evidence class and acceptance criterion are named.**
- **PRODUCTION CONFIGURATION CLEAN != PERSONNEL-SAFETY FUNCTION VALIDATED.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Trace a professional implementation that combines **two different physical witness classes** in one documented safety/return-to-service decision — preferably final-element position plus pressure/motion, or brake status plus motion — and exposes explicit fault/restart behavior.
2. If public authoritative evidence does not expose that complete combined chain, record the source limit and rotate to another high-value 25E0/25C0 safety branch rather than inventing it.
3. Carry the **feedback recovery + demand freshness** rule through every restart/rearm path: ask what happens if reset/start/jog/cycle is already asserted while monitored evidence is invalid and then becomes valid.
4. Bound every feedback witness to the physical claim its actual device/circuit supports. Speed, brake switch, contactor auxiliary contact, drive status and valve-position signals have different evidence authority.
5. For gravity/vertical-load examples, explicitly trace whether a feedback fault or STO requires retaining controlled torque until a brake/retaining state is established. Never teach `fault => immediate torque removal` as a universal rule.
6. Treat demand freshness as a separate state-machine property for every service/setup/maintenance/hand/override transition: explicitly classify production requests as edge, level, latched, queued, cancelled, tracked or regenerated.
7. Preserve the typed exceptional-state manifest: machine-readable force/bypass/maintenance/simulation/baseline states are ordinary-control evidence; physical temporary aids may require inspection; personnel-retention and protective functions remain independent safety authority.
8. Reopen the generic hydraulic-valve reset branch only for genuinely new OEM evidence combining monitored position with process witness, quantitative acceptance, mismatch fault and return-to-service semantics.
9. Preserve the four validation evidence classes and modification-impact rules; never substitute checksum/configuration identity for a required physical witness.
10. Do not copy PL/SIL, stopping limits, hydraulic thresholds, brake delays, speed thresholds, proof-test intervals or diagnostic coverage from examples into OpenPressBrake without design-specific authority.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
