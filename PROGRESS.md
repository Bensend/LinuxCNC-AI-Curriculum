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

Newest exceptional-state evidence: `safety-course/ROCKWELL_RUNNING_APPLICATION_EXCEPTION_STATE_OBSERVABILITY_AND_AUDIT_BOUNDARY_2026-09-21.md` establishes that Logix running logic can read I/O `ForceStatus` (installed and enabled separately) through GSV, and can read a controller Audit Value whose monitored changes can include online edits and force operations. This closes part of the prior runtime-observability gap while exposing a more important boundary: **current exceptional-state absence and accepted-production baseline identity are different evidence classes**. `25C0_RUNTIME_MANIFEST_VS_BASELINE_INTEGRITY_EXERCISE_2026-09-21.md` adversarially tests that distinction. Freeze: **NO I/O FORCES INSTALLED != NO OTHER EXCEPTIONS**, **AUDIT VALUE CHANGED != CURRENT EXCEPTION ACTIVE**, **NO PENDING ONLINE EDITS != KNOWN PRODUCTION BASELINE**, and **ENGINEERING UI CAN DISPLAY STATE != RUNNING APPLICATION CAN AUTHORITATIVELY READ THAT STATE**.

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

1. Seek a real controller/machine implementation combining more than one live exceptional-state class in running logic (for example force + maintenance bypass/test mode + baseline/change status) and explicitly gating automatic production or return-to-service.
2. Prefer authoritative evidence for machine-readable maintenance bypass/service/test state with defined clearing semantics; keep personnel-safety authority independent.
3. If no public implementation exposes the aggregate production gate, record the source-availability limit and rotate to the highest-value open 25C0/25E0 branch rather than inventing a universal manifest API.
4. Investigate test-edit/simulation persistence across reboot/download/redundancy transitions only where authoritative platform documentation changes return-to-production reasoning; never invent cross-platform clearing semantics.
5. Reopen hydraulic final-element work only for genuinely new OEM evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
6. Preserve the four validation evidence classes and modification-impact rules; never substitute checksum/configuration identity for a required physical witness.
7. Do not copy PL/SIL, stopping limits, hydraulic thresholds, proof-test intervals or diagnostic coverage from examples into OpenPressBrake without design-specific authority.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
