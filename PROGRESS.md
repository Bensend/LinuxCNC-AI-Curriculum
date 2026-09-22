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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; composition-aware acceptance scope; durable accepted-baseline/stale-evidence management; evidence freshness; formal finding/disposition handling; common-cause degradation; recurrence escalation; handoff persistence; and restart/power-domain recovery.

Newest learner-facing method: `safety-course/25E0_FRESH_DEMAND_AND_PARTIAL_POWER_DOMAIN_RECOVERY_2026-09-22.md`. It traces professional unexpected-start/restart evidence and separates device reset/restart features from machine-level permission. It adds a learner-facing recovery-state table and stress-tests both partial-power cases: safety authority survives while LinuxCNC/HMI cycles, and LinuxCNC/HMI survives while independent safety authority cycles.

Reusable records retained: `safety-course/OPEN_SAFETY_OBLIGATION_HANDOFF_RECORD.md` and `safety-course/FINDING_DISPOSITION_RECORD_TEMPLATE.md`.

New freezes: **POWER RESTORED != START AUTHORITY**, **AUTOMATIC SAFETY-CIRCUIT RESET != AUTOMATIC MACHINE RESTART PERMISSION**, **DRIVE RESTART INHIBITION CLEARED != FRESH PRODUCTION DEMAND**, **RESET/REARM COMPLETE != START COMMAND**, **HELD PRE-OUTAGE DEMAND != FRESH POST-RECOVERY DEMAND**, **LINUXCNC/HMI STATE SURVIVED != SAFETY AUTHORITY SURVIVED**, **SAFETY AUTHORITY SURVIVED != ORDINARY COMMAND FRESHNESS SURVIVED**, and **PARTIAL POWER-DOMAIN RECOVERY != WHOLE-MACHINE STATE CONTINUITY**.

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

1. Turn the recovery-state table into a reusable learner worksheet that forces each transition to name its authority, required evidence, stale-demand handling, and what remains `UNKNOWN`.
2. Trace professional examples for restoration after **loss of only field-device/safety-I/O power** while controller logic remains alive; distinguish communication/configuration recovery from reacquired physical witness validity.
3. Stress-test a multi-domain brownout/rapid-recovery case where power domains return in different orders and ordinary command state survives; determine which transitions must be monotonic toward inhibition until evidence is reacquired.
4. Add a machine-class comparison (press brake/gravity axis, spindle machine, plasma/router) showing that the freshness method transfers while physical propositions differ.
5. Preserve machine-specific physics and `UNKNOWN`; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds, proof intervals, alignment tolerances or diagnostic coverage.
6. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
