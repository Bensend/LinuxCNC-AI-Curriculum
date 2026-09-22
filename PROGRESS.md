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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; composition-aware acceptance scope; durable accepted-baseline/stale-evidence management; evidence freshness; formal finding/disposition handling; non-brake common-cause degradation; recurrence escalation; corrective/preventive-action ownership; handoff persistence; mechanical/installation common cause; and restart/power-loss persistence of open safety obligations.

Newest learner-facing method: `safety-course/25E0_POWER_LOSS_RECOVERY_THREE_AUTHORITY_AND_PHYSICAL_PROOF_2026-09-22.md`. It traces Siemens/Rockwell/Pilz power-up, fault acknowledgement, cold-start, restart-interlock and safe-status evidence and separates three authorities: independent safety controller/I/O state, durable safety/maintenance evidence, and volatile LinuxCNC/FPGA/HMI state. It extends the physical-proof boundary from contactors into drive/brake/valve propositions without inventing machine physics.

Reusable records: `safety-course/OPEN_SAFETY_OBLIGATION_HANDOFF_RECORD.md` defines what open `FIND-*` / stale `PROP-*` / pending `VAL-*` state must survive restart, power loss, shift change and maintenance handoff. `safety-course/FINDING_DISPOSITION_RECORD_TEMPLATE.md` preserves original adverse evidence, containment, reverse show-where-used, recurrence links, correction, physical re-proof, acceptance, reset/rearm, and fresh ordinary demand as distinct facts.

New freezes: **POWER RESTORED != SAFETY FUNCTIONS FULLY ACTIVE DURING STARTUP**, **POWER CYCLE ACKNOWLEDGED != FAULT CAUSE CORRECTED**, **SAFETY CONTROLLER HEALTHY != DURABLE SAFETY OBLIGATIONS CLEARED**, **EXPECTED SAFETY SIGNATURE != PHYSICAL PROCESS PROPOSITION FRESH**, **RESET AVAILABLE != RESET AUTHORIZED**, **SAFE OUTPUT/DRIVE STATUS != EVERY DOWNSTREAM PHYSICAL PROPOSITION PROVED**, **LINUXCNC READY != PERSONNEL-SAFETY RETURN-TO-SERVICE ACCEPTANCE**, and **PRE-POWER-LOSS ORDINARY DEMAND != FRESH POST-RECOVERY DEMAND**.

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
- **WORK ORDER CLOSED != SAFETY FINDING CLOSED.**
- **HMI GREEN != OPEN SAFETY OBLIGATIONS CLEARED.**
- **VOLATILE CONTROLLER STATE LOST != SAFETY OBLIGATION CLEARED.**
- **SAFETY MODULE HEALTHY != EXTERNAL DEVICE STATE PROVED.**
- **EXTERNAL DEVICE FEEDBACK HEALTHY != EVERY DOWNSTREAM PROCESS PROPOSITION PROVED.**
- **REBOOT SUCCESS != RETURN-TO-SERVICE ACCEPTANCE.**
- **MISSING PERSISTENT RECORD != NO OPEN OBLIGATION.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Trace authoritative professional evidence for **fresh ordinary demand after power restoration** and unexpected-start prevention across safety controller, drive and machine-control layers; distinguish device-level automatic restart features from machine-level permission.
2. Build a learner-facing recovery-state table for `BOOTING / SAFE-INHIBITED / DIAGNOSTIC-VALID / OBLIGATION-BLOCKED / RESET-ELIGIBLE / REARMED / PRODUCTION-DEMAND-REQUIRED`, explicitly keeping LinuxCNC readiness informational rather than safety authority.
3. Stress-test partial power-domain recovery: safety controller remains powered while ordinary CNC/HMI power cycles, and the inverse case where CNC remains powered while safety I/O/controller power cycles. Determine which evidence is stale, reacquired, or unaffected.
4. Preserve machine-specific physics and `UNKNOWN`; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds, proof intervals, alignment tolerances, escalation counts, acceptable degradation percentages or diagnostic coverage.
5. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
