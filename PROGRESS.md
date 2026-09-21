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

Newest professional implementation evidence: `safety-course/SIEMENS_ABB_SETUP_TO_AUTOMATIC_RETURN_AND_FRESH_START_BOUNDARY_2026-09-21.md` closes the immediate setup/manual -> safeguarded automatic trace at the evidence-supported level. Siemens SIRIUS documentation separates setup/automatic monitored regimes from the later Start action available after actuators are off and the feedback circuit is closed; ABB robot documentation independently separates Manual/Automatic operating mode from Start. The exact behavior of a held ordinary PLC/CNC command across arbitrary mode transitions remains design-specific/UNKNOWN. `25C0_SETUP_TO_AUTOMATIC_HELD_DEMAND_REVIEW_EXERCISE_2026-09-21.md` tests that boundary.

Freeze: **AUTOMATIC MODE CONFIRMED != PRODUCTION START**, **SAFETY PERMISSION RESTORED != FRESH ORDINARY MOTION DEMAND**, **FEEDBACK CIRCUIT CLOSED != START COMMAND**, **ENABLING DEVICE CENTER != FRESH MOTION AUTHORITY**, **ENABLING DEVICE HELD != START COMMAND**, **SETUP MODE SELECTED != SAFEGUARD SUSPENSION VALID**, **RETURN TO AUTOMATIC MODE != PRODUCTION START**, **COMMAND SOURCE NOT SELECTED != ITS SETTINGS ERASED**, **BUMPLESS TRANSFER != FRESH START**, **SAFETY RESET != START COMMAND**, and **ORDINARY PRODUCTION GATE TRUE != PERSONNEL-SAFETY RELEASE**.

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

1. Carry the new **permission freshness + demand freshness** rule through 25C0/25E0 reviews: distinguish present permission/input level from the transition/history required to establish new authority and a fresh command. Do not universalize one vendor's state machine.
2. The narrow setup-to-auto source trace has reached a useful evidence boundary: authoritative sources establish mode/permission/start separation but not universal held-input semantics. Rotate to another high-value professional safety implementation rather than repeatedly searching for a generic PLC rule.
3. Prefer a new 25E0 branch on restart/rearm after loss and restoration of a safety-related field signal or final-element feedback, especially implementations that distinguish automatic reset, manual reset, restart inhibit, and physical feedback without conflating them.
4. Treat demand freshness as a separate state-machine property for every service/setup/maintenance/hand/override transition: explicitly classify production requests as edge, level, latched, queued, cancelled, tracked or regenerated.
5. Preserve the typed exceptional-state manifest: machine-readable force/bypass/maintenance/simulation/baseline states are ordinary-control evidence; physical temporary aids may require inspection; personnel-retention and protective functions remain independent safety authority.
6. Reopen hydraulic final-element work only for genuinely new OEM evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
7. Preserve the four validation evidence classes and modification-impact rules; never substitute checksum/configuration identity for a required physical witness.
8. Do not copy PL/SIL, stopping limits, hydraulic thresholds, proof-test intervals or diagnostic coverage from examples into OpenPressBrake without design-specific authority.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.