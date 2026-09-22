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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; and human-factors controls that make bypass/defeat and temporary commissioning states harder than the intended safe workflow.

Newest revalidation method: `safety-course/25E0_PROPOSITION_SPECIFIC_REVALIDATION_AFTER_CHANGE_2026-09-22.md` closes the immediate change-impact methodology task. Siemens G220 and SINUMERIK provide concrete component-replacement evidence: replacement/firmware work triggers reduced or complete acceptance work according to the affected object; encoder/sensor-module replacement can require actual-value acquisition, direction/calibration and affected safety-function tests. Siemens S120 explicitly permits reduced acceptance only after identifying affected acceptance-test objects/logical groups. Pilz independently treats validation depth as lifecycle/change dependent. The method maps `change -> stale proposition/evidence -> physical re-proof -> acceptance authority -> configuration record -> reset/rearm -> fresh ordinary demand`.

Stress tests now cover both hydraulic/gravity-axis and rotating/servo cases. They explicitly separate component health, witness integrity, final-element state, process response, stopping/holding performance, configuration identity, exceptional-state clearance, reset/rearm and ordinary-demand freshness. Freeze **PART REPLACED != SAFETY PROPOSITION RESTORED**, **ALARM ACKNOWLEDGED != FUNCTION VALIDATED**, **CHECKSUM/CONFIGURATION MATCH != FIELD PHYSICS PROVED**, and **FORCE/SIMULATION DISABLED != REAL WITNESS REVALIDATED**.

Newest machine-tool supported-exception trace retained: `safety-course/25E0_MACHINE_TOOL_SAFE_LIMITED_SPEED_ACCESS_AND_RETURN_2026-09-21.md` closes the immediate non-robot setup/access evidence gap. Rockwell Kinetix documents SLS with door and enabling-switch monitoring: safe speed is detected before door unlock, enabling is retained during hazardous-area access, and return requires leaving the area, closing the door/restoring the SLS input, reset when configured, then releasing enabling. A separate Rockwell machine assist/production example uses keyed mode selection, enabling-device task motion, and safety-rated speed monitoring. Siemens SINUMERIK independently documents SLS for setup and other machine-tool safety functions.

Supported-exception and adversarial evidence retained: `safety-course/25E0_SETUP_ENABLING_REDUCED_MOTION_SUPPORTED_EXCEPTION_2026-09-21.md`, `safety-course/25E0_SUPPORTED_EXCEPTION_VS_DEFEAT_STRESS_TEST_2026-09-21.md`, `safety-course/25E0_PRODUCTION_RETURN_EXCEPTIONAL_STATE_CHECKLIST_AND_ADVERSARIAL_EXERCISE_2026-09-21.md`, `safety-course/25E0_SICK_PILZ_MUTING_OVERRIDE_INTENTIONAL_EXCEPTION_BOUNDARY_2026-09-21.md`, and `safety-course/25E0_SAFEGUARD_DEFEAT_AND_COMMISSIONING_SHORTCUT_REVIEW_METHOD_2026-09-21.md`.

Core freezes retained:
- **ACCESS CLEAR != PERSONNEL CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.**
- **VALVE COMMAND SAFE != PHYSICAL HYDRAULIC SAFE STATE PROVED.**
- **SAFETY OUTPUT OFF != EXTERNAL FINAL ELEMENT PHYSICALLY SAFE.**
- **RESET ACCEPTED != START AUTHORIZED.**
- **SAFETY-RELATED COMPONENT REPLACED != MACHINE SAFE TO RETURN TO SERVICE.**
- **TESTED != VALIDATED unless evidence class and acceptance criterion are named.**
- **PRODUCTION CONFIGURATION CLEAN != PERSONNEL-SAFETY FUNCTION VALIDATED.**
- **ENERGY REMOVED AT SOURCE != STORED PROCESS ENERGY SAFE.**
- **TORQUE REMOVED != ROTATION STOPPED.**
- **ROTATION STOPPED != RETAINING CAPABILITY PROVED.**
- **COMMANDED REDUCED SPEED != SAFETY-RATED SPEED MONITORING.**
- **AUTHORIZED BYPASS != SAFE PHYSICAL CONDITION.**
- **MAINTENANCE COMPLETE != PRODUCTION READY until temporary-state clearance and impact-based revalidation are complete.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Turn the proposition-specific method into a learner-facing **maintenance/change impact decision record** that can be completed before work starts and closed after validation; it must prevent technicians from discovering required tests only at production-return time.
2. Trace one authoritative professional example where the required acceptance scope changes with a specific component class or safety-function change, and map that example into the record without generalizing vendor-specific tests to unrelated machines.
3. Add an adversarial case involving two simultaneous changes whose affected propositions overlap, so the learner must detect that passing each component's local diagnostic does not necessarily revalidate the composed machine safety function.
4. Preserve machine-specific physics and UNKNOWN handling; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds or diagnostic coverage.
5. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than returning to routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.