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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; and human-factors controls that make temporary commissioning states difficult to carry into production accidentally.

Newest 25E0 evidence: `safety-course/25E0_MAINTENANCE_BYPASS_FORCE_LIFECYCLE_AND_PRODUCTION_CARRYOVER_2026-09-21.md` turns temporary maintenance/commissioning states into an explicit lifecycle rather than a generic `maintenance_mode`. Rockwell documentation provides a strong professional example: safety forces are allowed only in the unlocked/unsigned development state and must be **removed, not merely disabled**, before safety lock/signature; forcing an input overrides the real field value, so a forced signal is not physical evidence. FactoryTalk Security exposes separate authorization for forcing safety tags. Siemens S7 Distributed Safety independently requires deactivated safety mode to be verifiable, recommends operator indication/logging, warns that safety-related data from an F-CPU in deactivated safety mode can no longer be assumed safely generated, and ties modification/configuration identity to acceptance consequences. `25E0_EXCEPTIONAL_STATE_CARRYOVER_ADVERSARIAL_EXERCISE_2026-09-21.md` tests hidden force definitions, physical jumpers, configuration identity, post-maintenance physical validation, safety authority, and held Cycle Start as separate evidence classes.

Validation methodology retained: `25E0_SAFETY_FUNCTION_VALIDATION_RECORD_AND_ACCEPTANCE_MATRIX_2026-09-21.md` and `25E0_VALIDATION_TEMPLATE_PHYSICS_STRESS_TEST_2026-09-21.md` require hazard/safe-state identity, proposition-to-witness mapping, physical energy chain, timing endpoints, fault injection, reset/rearm and demand freshness, temporary-state clearance, human-factors defeat resistance, modification impact and explicit safety-critical UNKNOWN handling. The same record was stress-tested across hydraulic/gravity and rotating-machine physics; reusable methodology does not imply reusable physical acceptance criteria.

Prior 25E0 evidence retained: active brake proof (Siemens SBT and SEW brake test), process-speed witnesses (Siemens S120), hydraulic/pneumatic final-element monitoring (SMC/Festo/Bosch Rexroth), Rockwell Safe Brake Control mismatch/reset semantics, and Siemens 3SK1 held-start/feedback-recovery behavior. Recovery/restart semantics remain implementation-specific and every feedback witness remains bounded to the physical proposition its actual circuit/device supports.

Freeze: **AUTHORIZED BYPASS != SAFE PHYSICAL CONDITION**, **BYPASS/FORCE DISABLED != BYPASS/FORCE REMOVED where the platform distinguishes them**, **FORCED INPUT TRUE != FIELD INPUT PHYSICALLY TRUE**, **SAFETY MODE RESTORED != SAFETY FUNCTION REVALIDATED**, **SAFETY SIGNATURE MATCHES != FIELD HARDWARE VALIDATED**, **SERVICE KEY/PASSWORD PRESENT != PERSONNEL-SAFETY AUTHORITY**, **VISIBLE WARNING != ADEQUATE RISK REDUCTION**, **EXCEPTIONAL STATE CLEARED != FRESH ORDINARY START DEMAND**, **MAINTENANCE COMPLETE != PRODUCTION READY until temporary-state clearance and impact-based revalidation are complete**, **BRAKE COMMAND/STATUS != BRAKE HOLDING CAPABILITY PROVED**, **FINAL-ELEMENT COMMAND/STATUS != PROCESS RESPONSE**, **SAFE SPEED != ORDINARY START AUTHORIZED**, **STO ACTIVE != MECHANICAL LOAD SECURED**, **VALVE POSITION FEEDBACK VALID != PRESSURE SAFE**, **SUPPLY BLOCKED != STORED DOWNSTREAM ENERGY DECOMPRESSED**, **FEEDBACK RESTORED != FRESH START**, **SAFETY RESET != START COMMAND**, and **ORDINARY PRODUCTION GATE TRUE != PERSONNEL-SAFETY RELEASE**.

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

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Advance maintenance/bypass human factors into **service/setup operating-mode architecture** using professional implementations: trace how mode selection, enabling devices/hold-to-run, reduced/safe motion, guard bypass/muting, ordinary command authority, indication and exit-to-production are composed without making the normal CNC/PLC the sole safety authority.
2. Prefer one implementation with explicit physical key/mode selection or access control and one with programmable safety mode logic; compare what the authorization mechanism proves versus what the independent safety function must still enforce.
3. Trace **carryover prevention**: determine what happens to Start/Jog/Cycle requests already asserted during service/setup when the machine returns to automatic. Classify demand as edge, level, latched, queued, cancelled, tracked or regenerated from actual documentation; do not assume.
4. Preserve the exceptional-state manifest and production-readiness gate. Include software forces/bypasses, physical jumpers/aids, simulated witnesses, alternate parameters, safety-mode state, configuration identity, post-change physical tests, indication clearance and demand freshness.
5. Do not freeze universal bypass timeouts, key-switch circuits, PL/SIL targets, stopping limits, hydraulic thresholds or restart algorithms. Derive machine-specific acceptance from actual risk analysis and authoritative device/system semantics.
6. Keep LinuxCNC/ordinary FPGA roles bounded to normal control, indication, logging, diagnostics and ordinary-command gating. Independent safety authority and physical final-element/process validation remain separate.
7. If the service/setup mode branch becomes source-limited, rotate to another open 4000 safety module rather than manufacturing synthetic tests.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
