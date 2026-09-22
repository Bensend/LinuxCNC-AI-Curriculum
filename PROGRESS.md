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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; composition-aware acceptance scope; durable accepted-baseline/stale-evidence management; evidence freshness; and formal finding/disposition handling when inspection or proof contradicts the accepted physical baseline.

Newest learner-facing method: `safety-course/25E0_FINDING_DISPOSITION_CONTAINMENT_AND_COMMON_CAUSE_DEGRADATION_2026-09-22.md`. It adds stable `FIND-*` records and separates observation, acceptance criterion, immediate containment, suspected cause, corrective action, re-proof, acceptance, and closure. The original adverse observation is never overwritten by later repair or a passing retest.

Professional evidence from SICK shows stop-time measurement as a lifecycle method that can detect changes such as brake wear so corresponding measures can be initiated. Pilz safeguard inspection/validation independently separates inspection of current condition/safe function/overrun from validation that protective measures are correctly implemented. Rockwell explicitly warns that controller status indicators are only general diagnostics and must not be used to determine operational status. These support the lifecycle chain `finding -> containment -> affected propositions -> corrective action -> physical re-proof -> acceptance/closure`, rather than `finding -> repeat test until pass`.

The common-cause stress test now freezes **LOGICALLY INDEPENDENT SAFETY FUNCTIONS != PHYSICALLY INDEPENDENT SAFETY FUNCTIONS**. Separate safety sensors/logic may share a brake, drive, mechanical transmission, supply condition, contamination/temperature environment, or other physical dependency. A discovered degradation reverse-traces through the accepted-baseline ledger to each proposition that actually depends on it. It does not mechanically invalidate unrelated propositions, and shared dependency does not imply identical revalidation tests.

Prior freshness method: `safety-course/25E0_PROOF_OBLIGATION_EVIDENCE_FRESHNESS_AND_DISCOVERED_DEGRADATION_2026-09-22.md`. It separates scheduled time/use proof, latent-fault proof, discovered drift/degradation, and explicit change/event invalidation. A new physical measurement that contradicts the accepted baseline is itself a safety-relevant event; the curriculum does not wait for a repair work order before marking dependent evidence stale or failed.

Prior accepted-baseline method: `safety-course/25E0_ACCEPTED_SAFETY_BASELINE_AND_STALE_EVIDENCE_LEDGER_2026-09-22.md`. It gives safety functions, propositions, evidence, dependencies, changes and validation activities stable identities; records evidence validity assumptions; and requires reverse `show where used` lookup from a changed physical/configuration dependency to every affected proposition and safety function. Evidence made stale is not silently reused under a new work order or current checksum.

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
- **FINDING RECORDED != ROOT CAUSE KNOWN.**
- **REPAIR COMPLETE != SAFETY PROPOSITION RESTORED.**
- **REPEATED TEST PASSES != ORIGINAL ADVERSE RESULT DISPOSITIONED.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Create a compact reusable `FIND-*` / disposition record template that interoperates directly with `SF-*`, `PROP-*`, `EVID-*`, `DEP-*`, `CHG-*`, and `VAL-*` accepted-baseline identities.
2. Trace authoritative common-cause degradation beyond brakes—especially contamination, supply degradation/loss, environmental effects, or mechanical coupling—that can cross apparently independent safety channels/functions.
3. Develop recurrence/escalation rules: distinguish isolated correctable findings from repeated findings that indicate a design, maintenance, proof-method, or human-factors defect requiring broader corrective action.
4. Preserve machine-specific physics and `UNKNOWN`; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds, proof intervals, acceptable degradation percentages or diagnostic coverage.
5. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
