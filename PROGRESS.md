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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; composition-aware acceptance scope; durable accepted-baseline/stale-evidence management; evidence freshness; formal finding/disposition handling; common-cause degradation; recurrence escalation; handoff persistence; restart/power-domain recovery; field-power witness reacquisition; asynchronous brownout/recovery ordering; safety-network reintegration; shared-dependency reverse tracing; cell-level authority separation; and now an explicit repeatable hazard-to-safety-function derivation/allocation workflow.

Newest learner-facing methodology: `safety-course/2520_HAZARD_TO_SAFETY_FUNCTION_DERIVATION_AND_ALLOCATION_2026-09-22.md`. A syllabus/module audit found that the course named 2520 `From hazards to safety functions` but lacked one explicit instruction-ready chain from machine/lifecycle boundary through hazardous event, risk-reduction hierarchy, physical safe-state proposition, safety-function requirement, sensing/logic/final-element allocation, proof obligation, reset/restart, validation and residual risk. The new module closes that gap using SICK ISO-12100-style risk-assessment guidance, Pilz safety-concept/SRS guidance, and Rockwell safety-lifecycle/function/STO guidance. It explicitly keeps machine-specific PL/SIL targets, stopping criteria, pressure thresholds, hydraulic truth tables and similar physical facts `UNKNOWN` until established.

Newest learner-facing recovery consolidation/assessment retained: `safety-course/25E0_CELL_RECOVERY_AUXILIARY_ENERGY_TRANSIENT_LEDGER_ASSESSMENT_2026-09-22.md`. It turns the mature recovery branch into one adversarial robot/automated-cell exercise: safety communication returns while personnel-clear and auxiliary pneumatic/tooling-energy propositions remain unresolved. It requires explicit `PROP/EVID/DEP/FIND/VAL` chains, distinguishes `UNAVAILABLE` from `STALE` and `UNKNOWN` evidence, reverse-traces a pneumatic finding, and requires a fresh post-recovery ordinary start.

Reusable records retained: `safety-course/OPEN_SAFETY_OBLIGATION_HANDOFF_RECORD.md`, `safety-course/FINDING_DISPOSITION_RECORD_TEMPLATE.md`, `safety-course/POWER_RECOVERY_TRANSITION_WORKSHEET.md`, and `safety-course/SAFETY_REINTEGRATION_RETURN_TO_SERVICE_STATE_TABLE.md`.

Newest methodology freezes: **HAZARD IDENTIFIED != SAFETY FUNCTION SPECIFIED**, **SAFETY DEVICE SELECTED != RISK-REDUCTION METHOD DERIVED**, **DEVICE SAFE STATE != MACHINE PHYSICAL SAFE STATE**, **COMMAND/STATUS EVIDENCE != PHYSICAL PROCESS PROOF unless the proposition and architecture justify it**, **PL/SIL-CAPABLE COMPONENT != MACHINE SAFETY FUNCTION PL/SIL**, **TRANSFERABLE METHOD != TRANSFERABLE MACHINE PHYSICS**, **RESET/REARM != ORDINARY START AUTHORITY**, **UNKNOWN PHYSICAL FACT != PERMISSION TO INVENT A CONSERVATIVE NUMBER**, and **LINUXCNC/FPGA NORMAL CONTROL != INDEPENDENT PERSONNEL-SAFETY AUTHORITY**.

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

The recovery branch remains consolidated. Continue the repeatable safety-design methodology:

1. Stress-test the new 2520 hazard-to-function worksheet on a substantially different machine/cell without transferring press/spindle physics.
2. Build a learner-facing **safety-function composition and conflict-analysis** stage: multiple safety functions sharing final elements; mode-dependent demands; common power/mechanical/network dependencies; and functions whose requested physical states can interact or conflict.
3. Use an explicit allocation/dependency matrix tracing `HZ -> PROP -> SF -> input/logic/final element -> DEP -> EVID -> VAL`, with ordinary LinuxCNC/FPGA authority shown separately from independent safety authority.
4. Include an adversarial case where E-stop, guard, setup/enabling and process-fault functions share a final element. Combining functions must not silently erase the strongest required physical safe-state proposition.
5. Do not move into component selection or PL/SIL arithmetic until the functions are coherently derived/composed. Do not invent machine-specific integrity targets, stopping distances, hydraulic truth tables, pressure thresholds, diagnostic coverage or proof intervals.
6. Keep the human-factors rule first-class: make legitimate safe operation/setup/recovery easier than bypass; predictable bypass incentive is a design defect to address.

Newest precise checkpoint: `checkpoints/2026-09-22T1446Z-safety-hazard-function-derivation-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
