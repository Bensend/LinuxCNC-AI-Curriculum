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

Newest exceptional-state synthesis: `safety-course/EXCEPTIONAL_STATE_MANIFEST_PRODUCTION_HANDOFF_PATTERN_2026-09-21.md` defines a typed manifest for I/O/SFC forces, online/test edits, simulated I/O, ordinary software bypasses, maintenance/service/setup/override modes, safety muting/override, temporary physical jumpers/test aids, and personnel-retention mechanisms. Rockwell evidence shows one engineering surface can aggregate controller, force, online-edit and safety status while preserving distinct semantics; PlantPAx supplies explicit bypass state/clearing behavior. Pilz key-in-pocket supplies the contrasting safety-related restart-inhibit pattern. Freeze: **NO CONTROLLER-REPORTED EXCEPTIONS != NO PHYSICAL TEMPORARY AIDS PRESENT**, **PRODUCTION CONFIGURATION CLEAN != PERSONNEL-SAFETY FUNCTION VALIDATED**, and **SHIFT HANDOFF COMPLETE != EXCEPTIONAL STATE CLEARED unless each applicable class has positive disposition**.

Existing durable safety evidence remains authoritative in Git, including the four-class validation matrix, physical-change return-to-service procedure, hydraulic/final-element witness studies, stopping-performance/safeguard coupling, enabling-device/reset/start authority studies, maintenance-isolation work, and temporary simulated-I/O/force-state studies. Do not collapse heterogeneous evidence into a generic `SAFE=true` bit.

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

1. Seek a real controller/machine implementation exposing multiple exceptional-state classes programmatically to the running application, not merely in an engineering UI.
2. Prefer evidence that ties aggregate exceptional-state status to a production handoff/enable while preserving independent personnel-safety authority.
3. Investigate test-edit/simulation persistence across reboot/download/redundancy transitions only where authoritative platform documentation makes it relevant; never invent cross-platform clearing semantics.
4. Reopen hydraulic final-element work only for genuinely new OEM evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
5. Preserve the four validation evidence classes and modification-impact rules; never substitute checksum/configuration identity for a required physical witness.
6. Do not copy PL/SIL, stopping limits, hydraulic thresholds, proof-test intervals or diagnostic coverage from examples into OpenPressBrake without design-specific authority.
7. Routine controller-board work resumes only when it directly supports the safety checkpoint or safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
