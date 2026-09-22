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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; composition-aware acceptance scope; durable accepted-baseline/stale-evidence management; evidence freshness; formal finding/disposition handling; common-cause degradation; recurrence escalation; handoff persistence; restart/power-domain recovery; field-power witness reacquisition; asynchronous brownout/recovery ordering; safety-network reintegration; shared-dependency reverse tracing; and cell-level authority separation.

Newest learner-facing method: `safety-course/25E0_SAFETY_NETWORK_REINTEGRATION_COMMON_CAUSE_AND_CELL_TRANSFER_2026-09-22.md`. It traces Rockwell safety-connection fault semantics, Siemens/ABB passivation and reintegration behavior, separates communication validity from safety-function reintegration and machine-level acceptance, stress-tests one shared field-power source feeding multiple nominally separate safety inputs, reconnects post-outage guard geometry to physical validation, and transfers the method to robot/automated-cell authority boundaries.

Reusable records retained: `safety-course/OPEN_SAFETY_OBLIGATION_HANDOFF_RECORD.md`, `safety-course/FINDING_DISPOSITION_RECORD_TEMPLATE.md`, and `safety-course/POWER_RECOVERY_TRANSITION_WORKSHEET.md`.

Newest freezes: **SAFETY CONNECTION VALID != SAFETY FUNCTION REINTEGRATED**, **SAFETY FUNCTION REINTEGRATED != MACHINE-LEVEL PHYSICAL PROPOSITION FRESH**, **REINTEGRATION ACKNOWLEDGED != RESET/REARM AUTHORIZED != ORDINARY START AUTHORIZED**, **SEPARATE SAFETY CHANNELS != INDEPENDENT SAFETY EVIDENCE WHEN THEY SHARE A LOST DEPENDENCY**, **ELECTRONICS RECOVERED != MECHANICAL INSTALLATION UNCHANGED**, **OSSD/INPUT HEALTHY != GUARD GEOMETRY VALIDATED**, **ROBOT/CONTROLLER READY != CELL PERSONNEL-SAFETY READY**, and **CELL SAFETY RESET != ROBOT PRODUCTION START**.

Core freezes retained include:
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
- **RESET/REARM COMPLETE != START COMMAND.**
- **HELD PRE-OUTAGE DEMAND != FRESH POST-RECOVERY DEMAND.**
- **CONTROLLER LOGIC SURVIVED != FIELD WITNESS SURVIVED.**
- **COMMUNICATION RESTORED != PHYSICAL WITNESS REACQUIRED.**
- **FIELD POWER RESTORED != MACHINE-LEVEL SAFETY PROPOSITION FRESH.**
- **I/O DIAGNOSTIC CLEARED != RETURN-TO-SERVICE ACCEPTANCE.**
- **MORE DOMAINS ONLINE != FEWER SAFETY BLOCKERS unless required evidence was actually gained.**
- **RECOVERY ORDER != AUTHORITY ORDER.**
- **TRANSFERABLE SAFETY METHOD != TRANSFERABLE MACHINE PHYSICS.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Turn the strengthened monotonic-recovery rule into a compact learner-facing **reintegration/return-to-service state table** that distinguishes transport healthy, safety connection valid, device diagnostics valid, reintegration eligible, reintegration complete, physical proposition fresh, reset/rearm eligible, and fresh ordinary start.
2. Deepen shared-dependency analysis beyond one power supply: trace one professional common-cause communication/network-infrastructure case and distinguish shared network loss from independent field-device faults without claiming Ethernet redundancy or PL/SIL performance not established by the design.
3. Build an adversarial cell-recovery exercise where a robot safety connection recovers while an auxiliary pneumatic/tooling hazard and personnel-clear proposition remain unresolved; require separate authority/evidence for each.
4. Connect the new network/reintegration branch to the durable `PROP/EVID/DEP/FIND/VAL` ledger with an explicit example showing which evidence becomes stale versus merely unavailable during a transient connection loss, and when historical physical evidence remains valid versus requiring fresh proof.
5. Preserve machine-specific physics and `UNKNOWN`; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds, proof intervals, sensing distances, network reaction-time requirements or diagnostic coverage.
6. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
