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

Newest learner-facing consolidation/assessment: `safety-course/25E0_CELL_RECOVERY_AUXILIARY_ENERGY_TRANSIENT_LEDGER_ASSESSMENT_2026-09-22.md`. It turns the mature recovery branch into one adversarial robot/automated-cell exercise: safety communication returns while personnel-clear and auxiliary pneumatic/tooling-energy propositions remain unresolved. It requires explicit `PROP/EVID/DEP/FIND/VAL` chains, distinguishes `UNAVAILABLE` from `STALE` and `UNKNOWN` evidence, reverse-traces a pneumatic finding, and requires a fresh post-recovery ordinary start. ABB robot/cell guidance and Festo pneumatic safety guidance provide professional evidence without inventing machine-specific safe-state truth.

Reusable records retained: `safety-course/OPEN_SAFETY_OBLIGATION_HANDOFF_RECORD.md`, `safety-course/FINDING_DISPOSITION_RECORD_TEMPLATE.md`, `safety-course/POWER_RECOVERY_TRANSITION_WORKSHEET.md`, and `safety-course/SAFETY_REINTEGRATION_RETURN_TO_SERVICE_STATE_TABLE.md`.

Newest freezes: **SAFETY COMMUNICATION RECOVERED != CELL HAZARDOUS ENERGY PROVED SAFE**, **REMOTE I/O HEALTHY != AUXILIARY PNEUMATIC/TOOLING PHYSICAL STATE PROVED**, **PERSONNEL CLEAR != AUXILIARY ENERGY SAFE != RESET AUTHORIZED != START AUTHORIZED**, **UNAVAILABLE EVIDENCE != STALE EVIDENCE; STALE EVIDENCE != UNKNOWN EVIDENCE**, **SAFE EXHAUST/DE-ENERGIZATION COMMAND != REQUIRED PHYSICAL EXHAUST/ENERGY PROPOSITION PROVED**, and **NETWORK RECOVERY MUST NOT REVIVE A HELD PRE-FAULT PRODUCTION DEMAND**.

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
- **SAFETY CONNECTION VALID != SAFETY FUNCTION REINTEGRATED.**
- **SAFETY FUNCTION REINTEGRATED != MACHINE-LEVEL PHYSICAL PROPOSITION FRESH.**
- **REINTEGRATION ACKNOWLEDGED != RESET/REARM AUTHORIZED != ORDINARY START AUTHORIZED.**
- **SEPARATE SAFETY CHANNELS != INDEPENDENT SAFETY EVIDENCE WHEN THEY SHARE A LOST DEPENDENCY.**
- **ELECTRONICS RECOVERED != MECHANICAL INSTALLATION UNCHANGED.**
- **OSSD/INPUT HEALTHY != GUARD GEOMETRY VALIDATED.**
- **ROBOT/CONTROLLER READY != CELL PERSONNEL-SAFETY READY.**
- **CELL SAFETY RESET != ROBOT PRODUCTION START.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

The safety-network/recovery branch is now consolidated rather than extended with more narrow notes. Next work should rotate to the highest-value open safety-design methodology branch:

1. Audit the safety-course syllabus/module map for the explicit repeatable safety-design workflow: machine/boundary definition -> hazardous energy/motion -> safe states -> required safety functions -> interfaces/final elements -> diagnostic/fault analysis -> reset/restart -> verification/validation -> maintenance/change control. Identify the highest-value missing learner-facing module rather than assuming coverage from scattered notes.
2. Prefer a branch that teaches **hazard-to-safety-function derivation and allocation** across electrical, hydraulic/pneumatic, mechanical/gravity and ordinary-control boundaries, because the recovery work now has diminishing marginal information gain.
3. Use professional complete-machine examples where available, but preserve machine-specific differences and `UNKNOWN`. Do not infer PL/SIL targets, stopping distances, hydraulic truth tables, pressure thresholds, proof intervals or diagnostic coverage without design-specific evidence.
4. Keep the human-factors rule first-class: make legitimate safe operation/recovery easier than bypass; inconvenience that predictably motivates defeat is a design defect to address.
5. If the syllabus audit shows that hazard-to-function derivation is already complete and instruction-ready, rotate to the next missing safety-design workflow stage rather than duplicating it.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
