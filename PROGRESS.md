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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; composition-aware acceptance scope; and durable accepted-baseline/stale-evidence management.

Newest learner-facing method: `safety-course/25E0_ACCEPTED_SAFETY_BASELINE_AND_STALE_EVIDENCE_LEDGER_2026-09-22.md`. It gives safety functions, propositions, evidence, dependencies, changes and validation activities stable identities; records evidence validity assumptions; and requires reverse `show where used` lookup from a changed physical/configuration dependency to every affected proposition and safety function. Evidence made stale is not silently reused under a new work order or current checksum.

The shared-change stress test shows why one changed brake or other common physical dependency can invalidate two safety functions differently. A protective-device function may depend on measured stopping performance/separation distance while an access-release function may instead depend on independent stopped-motion evidence—or, in a different architecture, on a delay derived from stopping behavior. Freeze **ONE PHYSICAL CHANGE != ONE UNIVERSAL REVALIDATION TEST** and **SHARED DEPENDENCY != IDENTICAL SAFETY PROPOSITION**.

Lifecycle evidence now explicitly separates two trigger lanes. Rockwell functional-safety documentation treats proof-test intervals as application-dependent and allows system elements to have different proof-test/useful-life requirements. Pilz distinguishes frequent functional checks, periodic safeguard inspection/stop-performance testing, and inspection after modifications or exceptional events. Therefore a calendar/use/degradation proof schedule and event-triggered proposition-specific revalidation are independent obligations. Freeze **PERIODIC PROOF DUE DATE != PERMISSION TO DEFER CHANGE-TRIGGERED REVALIDATION** and **EVENT REVALIDATION COMPLETE != FUTURE PERIODIC PROOF CANCELLED**.

Prior methods retained: `safety-course/25E0_ACCEPTANCE_SCOPE_DEPENDENCY_MATRIX_AND_ACCUMULATED_CHANGE_REVIEW_2026-09-22.md`, `safety-course/25E0_MULTI_CHANGE_COMPOSITION_ACCEPTANCE_SCOPE_2026-09-22.md`, and `safety-course/25E0_PROPOSITION_SPECIFIC_REVALIDATION_AFTER_CHANGE_2026-09-22.md`.

Core freezes retained:
- **ACCESS CLEAR != PERSONNEL CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.**
- **VALVE COMMAND SAFE != PHYSICAL HYDRAULIC SAFE STATE PROVED.**
- **SAFETY OUTPUT OFF != EXTERNAL FINAL ELEMENT PHYSICALLY SAFE.**
- **RESET ACCEPTED != START AUTHORIZED.**
- **SAFETY-RELATED COMPONENT REPLACED != MACHINE SAFE TO RETURN TO SERVICE.**
- **TESTED != VALIDATED unless evidence class and acceptance criterion are named.**
- **ENERGY REMOVED AT SOURCE != STORED PROCESS ENERGY SAFE.**
- **TORQUE REMOVED != ROTATION STOPPED.**
- **COMMANDED REDUCED SPEED != SAFETY-RATED SPEED MONITORING.**
- **AUTHORIZED BYPASS != SAFE PHYSICAL CONDITION.**
- **COMPONENT DIAGNOSTIC PASS != SAFETY FUNCTION VALIDATED.**
- **SAME CHECKSUM != SAME FIELD PHYSICS.**
- **CHANGE COUNT != ACCEPTANCE SCOPE.**
- **ACCEPTED ONCE != ACCEPTED FOREVER.**
- **CURRENT DIAGNOSTICS != CURRENT PHYSICAL VALIDATION EVIDENCE.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Extend the ledger into a learner-facing **proof obligation / evidence freshness review** that distinguishes evidence expiration, latent-failure proof, wear/drift monitoring, and revalidation after actual change.
2. Trace authoritative evidence for maintenance/inspection findings that themselves trigger expanded validation scope—for example a stop-time trend or safeguard defect that reveals the accepted physical baseline is no longer representative.
3. Stress-test evidence freshness where a periodic proof discovers degraded stopping performance even though no work order/change was recorded, and trace how that finding propagates through safeguard positioning/access propositions.
4. Preserve machine-specific physics and `UNKNOWN`; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds or diagnostic coverage.
5. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
