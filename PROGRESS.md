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

Current safety emphasis includes independent safety authority; physical final-element proof; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; and human-factors controls that make temporary commissioning states difficult to carry into production accidentally.

Newest professional implementation evidence: `safety-course/SIEMENS_3SK1_FEEDBACK_ERROR_HELD_START_AND_RESTART_INHIBIT_2026-09-21.md` closes the immediate 25E0 question with explicit vendor behavior. Siemens 3SK1 documentation says a feedback-circuit error holds the safety relay in the safe state while the error persists, but a Start signal detected during that interval can cause start after the feedback error is eliminated; Siemens provides a specific start-button interconnection to prevent automatic start on feedback-error correction. This is direct evidence that safe-state residence and feedback restoration do not themselves cancel stale command intent. `25E0_FEEDBACK_RECOVERY_HELD_START_ADVERSARIAL_EXERCISE_2026-09-21.md` tests the failure path and bounded authority of external-device monitoring.

Freeze: **FEEDBACK ERROR -> SAFE STATE != START REQUEST CANCELLED**, **FEEDBACK RESTORED != FRESH START**, **START SIGNAL PRESENT != START TRANSITION AFTER FEEDBACK VALID**, **EDM/FEEDBACK VALID != COMPLETE PHYSICAL SAFE-STATE PROOF**, **AUTOMATIC MODE CONFIRMED != PRODUCTION START**, **SAFETY PERMISSION RESTORED != FRESH ORDINARY MOTION DEMAND**, **ENABLING DEVICE CENTER != FRESH MOTION AUTHORITY**, **BUMPLESS TRANSFER != FRESH START**, **SAFETY RESET != START COMMAND**, and **ORDINARY PRODUCTION GATE TRUE != PERSONNEL-SAFETY RELEASE**.

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

1. Carry the new **feedback recovery + demand freshness** rule through 25E0 reviews: for every restart/rearm path ask what happens if reset/start/jog/cycle is already asserted while monitored final-element feedback is invalid and then becomes valid.
2. Trace a different professional final-element implementation where feedback disagreement has explicit timeout/latching/manual-reset semantics (drive STO feedback, safety valve/valve terminal, brake or contactor monitoring). Determine whether recovery alone restores eligibility or whether a new reset transition is required. Do not assume Siemens 3SK1 behavior is universal.
3. Bound every feedback witness to the physical claim its actual device/circuit supports. A contactor auxiliary contact, drive status or valve-terminal signal is not generic proof of zero torque, pressure, ram motion, stored energy or stopping performance.
4. Treat demand freshness as a separate state-machine property for every service/setup/maintenance/hand/override transition: explicitly classify production requests as edge, level, latched, queued, cancelled, tracked or regenerated.
5. Preserve the typed exceptional-state manifest: machine-readable force/bypass/maintenance/simulation/baseline states are ordinary-control evidence; physical temporary aids may require inspection; personnel-retention and protective functions remain independent safety authority.
6. Reopen hydraulic final-element work only for genuinely new OEM evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
7. Preserve the four validation evidence classes and modification-impact rules; never substitute checksum/configuration identity for a required physical witness.
8. Do not copy PL/SIL, stopping limits, hydraulic thresholds, proof-test intervals or diagnostic coverage from examples into OpenPressBrake without design-specific authority.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
