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

Newest exceptional-state evidence: `safety-course/ROCKWELL_PLANTPAX_BYPASS_AGGREGATION_AND_PRODUCTION_GATE_BOUNDARY_2026-09-21.md` establishes that PlantPAx exposes runtime bypass summary state (`Sts_BypActive`) and process interlock bypass state, but public evidence does not justify inventing a universal vendor `production_clean` primitive. `safety-course/ROCKWELL_PLANTPAX_MAINTENANCE_OWNERSHIP_PERSISTENCE_AND_FRESH_START_BOUNDARY_2026-09-21.md` adds a stronger persistence result: Rockwell documents Maintenance acquired/released state as persisting through controller powerup and PROG-to-RUN for relevant process instructions, while bypass/check, Maintenance acquire/release, and physical/virtual device selection are distinct operations/state dimensions. `25C0_PERSISTENT_MAINTENANCE_STATE_REBOOT_HANDOFF_EXERCISE_2026-09-21.md` adversarially tests the resulting handoff boundary.

Freeze: **POWER CYCLE != MAINTENANCE STATE SANITIZED**, **PROG-to-RUN != PRODUCTION HANDOFF COMPLETE**, **BYPASS CLEARED != MAINTENANCE OWNERSHIP RELEASED**, **MAINTENANCE OWNERSHIP RELEASED != PHYSICAL DEVICE MODE PROVED**, **EXCEPTION CLEANUP ACTION != NEW START AUTHORITY**, and **ORDINARY PRODUCTION GATE TRUE != PERSONNEL-SAFETY RELEASE**.

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

1. The narrow search for a public universal aggregate exceptional-state production gate is now branch-locally source-limited. Do not continue generic force/bypass searches merely to manufacture such an API.
2. Rotate to the highest-value open 25C0/25E0 human-factors branch. Prefer authoritative implementations showing the boundary between maintenance/service-mode cleanup and fresh production start/restart authority, especially where cleanup cannot itself resume hazardous motion.
3. Investigate test-edit/simulation persistence across reboot/download/redundancy transitions only where authoritative platform documentation changes return-to-production reasoning; never invent cross-platform clearing semantics.
4. Preserve the typed exceptional-state manifest: machine-readable force/bypass/maintenance/simulation/baseline states are ordinary-control evidence; physical temporary aids may require inspection; personnel-retention and protective functions remain independent safety authority.
5. Reopen hydraulic final-element work only for genuinely new OEM evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
6. Preserve the four validation evidence classes and modification-impact rules; never substitute checksum/configuration identity for a required physical witness.
7. Do not copy PL/SIL, stopping limits, hydraulic thresholds, proof-test intervals or diagnostic coverage from examples into OpenPressBrake without design-specific authority.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.