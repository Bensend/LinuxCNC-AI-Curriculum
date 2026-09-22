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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; composition-aware acceptance scope; durable accepted-baseline/stale-evidence management; evidence freshness; formal finding/disposition handling; non-brake common-cause degradation; and recurrence escalation.

Newest learner-facing method: `safety-course/25E0_NON_BRAKE_COMMON_CAUSE_AND_RECURRENCE_ESCALATION_2026-09-22.md`. It extends common-cause reasoning beyond brakes using authoritative SICK contamination/calibration evidence and Rockwell safety field-power/environment requirements, then adds recurrence/escalation rules across design, maintenance/proof, environment/process, and human-factors lanes.

Reusable record: `safety-course/FINDING_DISPOSITION_RECORD_TEMPLATE.md` interoperates with `SF-*`, `PROP-*`, `EVID-*`, `DEP-*`, `CHG-*`, and `VAL-*` accepted-baseline identities. It preserves original adverse evidence, containment, reverse show-where-used, recurrence links, correction, physical re-proof, acceptance, reset/rearm, and fresh ordinary demand as distinct facts.

The new common-cause cases freeze **SEPARATE LOGIC CHANNELS != SEPARATE PHYSICAL/ENVIRONMENTAL DEPENDENCIES**, **DEVICE DIAGNOSTIC HEALTHY != SHARED ENVIRONMENTAL CAUSE ABSENT**, **CLEANED != DEVICE-SPECIFIC CALIBRATION/REPROOF COMPLETE**, and **POWER RESTORED != ALL DEPENDENT SAFETY PROPOSITIONS REVALIDATED**. Repeated findings are linked rather than merged; recurrence is an escalation signal, not proof of one root cause or a license to invent a universal failure-count threshold.

Prior finding method: `safety-course/25E0_FINDING_DISPOSITION_CONTAINMENT_AND_COMMON_CAUSE_DEGRADATION_2026-09-22.md`. It adds stable `FIND-*` records and separates observation, acceptance criterion, immediate containment, suspected cause, corrective action, re-proof, acceptance, and closure. The original adverse observation is never overwritten by later repair or a passing retest.

Prior freshness method: `safety-course/25E0_PROOF_OBLIGATION_EVIDENCE_FRESHNESS_AND_DISCOVERED_DEGRADATION_2026-09-22.md`. It separates scheduled time/use proof, latent-fault proof, discovered drift/degradation, and explicit change/event invalidation. A new physical measurement that contradicts the accepted baseline is itself a safety-relevant event.

Prior accepted-baseline method: `safety-course/25E0_ACCEPTED_SAFETY_BASELINE_AND_STALE_EVIDENCE_LEDGER_2026-09-22.md`. It gives safety functions, propositions, evidence, dependencies, changes and validation activities stable identities; records evidence validity assumptions; and requires reverse `show where used` lookup from a changed physical/configuration dependency to every affected proposition and safety function.

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
- **RECURRENCE != ROOT CAUSE PROVED.**
- **REPEATED REPAIR SUCCESS != RECURRING DEFECT DISPOSITIONED.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Connect recurrence escalation to corrective/preventive-action ownership and prove that open findings/containment/re-proof obligations survive shift and maintenance handoff without collapsing into a green machine-status indication.
2. Trace one authoritative mechanical-coupling or mounting/alignment common-cause example where nominally separate safety sensing shares a physical structure or installation dependency.
3. Build a learner adversarial exercise where recurring nuisance trips are treated as a human-factors/design warning rather than justification to weaken, mute, bypass, or transfer safety authority to ordinary LinuxCNC/FPGA control.
4. Preserve machine-specific physics and `UNKNOWN`; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds, proof intervals, contamination limits, escalation counts, acceptable degradation percentages or diagnostic coverage.
5. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
