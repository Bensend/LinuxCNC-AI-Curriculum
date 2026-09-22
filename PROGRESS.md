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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; and composition-aware acceptance scope when changes overlap across one or several maintenance windows.

Newest learner-facing method: `safety-course/25E0_ACCEPTANCE_SCOPE_DEPENDENCY_MATRIX_AND_ACCUMULATED_CHANGE_REVIEW_2026-09-22.md`. It converts the composition method into a safety-function/proposition × input witness × logic/configuration × final element × process witness × machine dynamics/stored energy × safeguard/access dependency matrix. Every cell is explicitly `UNCHANGED/VALID`, `STALE`, `UNKNOWN`, or `N/A`; stale/unknown cells are unioned across changes and traced horizontally into every affected end-to-end proposition.

The professional non-safety-component trace is now explicit. Siemens SINUMERIK requires open-/closed-loop commissioning to be complete before Safety Integrated acceptance because changed drive-control dynamics can change over-travel. Pilz and Rockwell independently tie safeguard position to actual/worst-case machine stopping performance and identify brake wear, mechanical condition, load/speed/tooling or control behavior as contributors to stopping response. Freeze **NON-SAFETY PARAMETER != OUTSIDE SAFETY EVIDENCE BOUNDARY**.

The accumulated-change adversarial case spans three maintenance windows: brake replacement, ordinary servo tuning/production-speed change, then safeguard relocation. Each work order can appear locally bounded, yet all three intersect the same protective-device-to-safe-stop-before-access proposition. The learner must compare against the last accepted safety baseline and union stale evidence across windows. Freeze **WORK ORDER CLOSED != SAFETY EVIDENCE REFRESHED**, **NO SINGLE LARGE CHANGE != NO COMPOSED SAFETY CHANGE**, and **CURRENT CONFIGURATION CHECKSUM != CURRENT PHYSICAL ACCEPTANCE BASELINE**.

Prior composition method retained: `safety-course/25E0_MULTI_CHANGE_COMPOSITION_ACCEPTANCE_SCOPE_2026-09-22.md`. Proposition-specific method retained: `safety-course/25E0_PROPOSITION_SPECIFIC_REVALIDATION_AFTER_CHANGE_2026-09-22.md`.

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

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Turn the accepted-baseline idea into a reusable **safety evidence baseline / stale-evidence ledger** with stable proposition IDs, evidence identity, change dependencies, revalidation status, and reverse `show where used` lookup.
2. Stress-test that ledger against a multi-function machine where one physical change affects two safety functions differently (for example a common brake/drive or shared guard zone), without inventing machine-specific acceptance thresholds.
3. Trace authoritative professional lifecycle evidence for periodic/recurrent proof versus event-driven revalidation, distinguishing scheduled proof/inspection from revalidation triggered by modification, fault, or exceptional commissioning state.
4. Preserve machine-specific physics and `UNKNOWN`; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds or diagnostic coverage.
5. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
