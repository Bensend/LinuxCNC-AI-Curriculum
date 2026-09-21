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

Newest exceptional-state evidence: `safety-course/ROCKWELL_PLANTPAX_BYPASS_AGGREGATION_AND_PRODUCTION_GATE_BOUNDARY_2026-09-21.md` establishes that PlantPAx exposes runtime bypass summary state (`Sts_BypActive`) and process interlock bypass state, but public evidence does not justify inventing a universal vendor `production_clean` primitive. `safety-course/ROCKWELL_PLANTPAX_MAINTENANCE_OWNERSHIP_PERSISTENCE_AND_FRESH_START_BOUNDARY_2026-09-21.md` adds that Maintenance acquired/released state can persist through controller powerup and PROG-to-RUN. `safety-course/ROCKWELL_PILZ_EXCEPTION_CLEANUP_RESET_AND_FRESH_START_SEPARATION_2026-09-21.md` then closes the architecture boundary: Rockwell exposes Maintenance release and ordinary Start as distinct command/readiness surfaces, while Pilz safety guidance independently requires safeguard/E-stop reset to prepare for restart rather than automatically restart hazardous motion. `25C0_PERSISTENT_MAINTENANCE_STATE_REBOOT_HANDOFF_EXERCISE_2026-09-21.md` adversarially tests the handoff.

Freeze: **POWER CYCLE != MAINTENANCE STATE SANITIZED**, **PROG-to-RUN != PRODUCTION HANDOFF COMPLETE**, **BYPASS CLEARED != MAINTENANCE OWNERSHIP RELEASED**, **MAINTENANCE RELEASE != START COMMAND**, **SAFETY RESET != START COMMAND**, **AUTHORITY RESTORED != OLD MOTION DEMAND FRESH**, and **ORDINARY PRODUCTION GATE TRUE != PERSONNEL-SAFETY RELEASE**.

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

1. The universal aggregate exceptional-state gate search is source-limited; the cleanup/reset/start separation is now adequately supported at architecture level. Do not continue generic force/bypass/reset searches merely to add volume.
2. Next investigate **stale demand / queued command / automatic-cycle resumption across mode or command-authority transitions** in a real controller or machine implementation. Seek authoritative evidence about whether an old automatic demand is invalidated, held, or resumed after Maintenance/Service/Hand/Override release.
3. If public sources do not expose those semantics, mark that narrow branch source-limited and rotate to another open 25C0/25E0 human-factors/validation branch.
4. Investigate test-edit/simulation persistence across reboot/download/redundancy transitions only where authoritative platform documentation changes return-to-production reasoning; never invent cross-platform clearing semantics.
5. Preserve the typed exceptional-state manifest: machine-readable force/bypass/maintenance/simulation/baseline states are ordinary-control evidence; physical temporary aids may require inspection; personnel-retention and protective functions remain independent safety authority.
6. Reopen hydraulic final-element work only for genuinely new OEM evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
7. Do not copy PL/SIL, stopping limits, hydraulic thresholds, proof-test intervals or diagnostic coverage from examples into OpenPressBrake without design-specific authority.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.