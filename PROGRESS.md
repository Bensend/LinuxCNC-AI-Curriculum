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

Newest 25E0 evidence: `safety-course/25E0_SERVICE_SETUP_MODE_AUTHORIZATION_AND_ENABLING_BOUNDARY_2026-09-21.md` traces service/setup mode authority across Siemens and Pilz. Siemens explicitly states that a mode selector must not itself trigger machine operation; setup with exposed personnel uses an enabling mechanism and a separate deliberate motion command, with controlled/reduced motion derived from the machine risk assessment. Pilz PITmode separates user/access permission from functionally safe operating-mode evaluation and exposes explicit configurable behavior when the authorization transponder is removed. The reusable chain is now `identity/permission -> safe mode selection -> enabling/protective condition -> separate ordinary motion demand -> production re-entry`. Public evidence inspected does not justify a universal held-Start/Jog/Cycle rule across service-to-automatic transition, so demand freshness remains a separate state-machine/validation requirement.

Maintenance/bypass evidence retained: `25E0_MAINTENANCE_BYPASS_FORCE_LIFECYCLE_AND_PRODUCTION_CARRYOVER_2026-09-21.md` turns temporary maintenance/commissioning states into an explicit lifecycle rather than a generic `maintenance_mode`. Rockwell safety forces must be removed, not merely disabled, before safety lock/signature; forcing an input overrides the real field value. Siemens S7 Distributed Safety independently requires deactivated safety mode to be verifiable, recommends indication/logging, and warns that safety-related data from an F-CPU in deactivated safety mode cannot simply be assumed safely generated. `25E0_EXCEPTIONAL_STATE_CARRYOVER_ADVERSARIAL_EXERCISE_2026-09-21.md` tests hidden force definitions, physical jumpers, configuration identity, physical revalidation, safety authority and held Cycle Start separately.

Validation methodology retained: `25E0_SAFETY_FUNCTION_VALIDATION_RECORD_AND_ACCEPTANCE_MATRIX_2026-09-21.md` and `25E0_VALIDATION_TEMPLATE_PHYSICS_STRESS_TEST_2026-09-21.md` require hazard/safe-state identity, proposition-to-witness mapping, physical energy chain, timing endpoints, fault injection, reset/rearm and demand freshness, temporary-state clearance, human-factors defeat resistance, modification impact and explicit safety-critical UNKNOWN handling. The same record was stress-tested across hydraulic/gravity and rotating-machine physics; reusable methodology does not imply reusable physical acceptance criteria.

Prior 25E0 evidence retained: active brake proof (Siemens SBT and SEW brake test), process-speed witnesses (Siemens S120), hydraulic/pneumatic final-element monitoring (SMC/Festo/Bosch Rexroth), Rockwell Safe Brake Control mismatch/reset semantics, and Siemens 3SK1 held-start/feedback-recovery behavior. Recovery/restart semantics remain implementation-specific and every feedback witness remains bounded to the physical proposition its actual circuit/device supports.

Freeze: **AUTHORIZED USER != SAFE MODE SELECTED**, **SAFE MODE SELECTED != HAZARDOUS MOTION AUTHORIZED**, **ENABLING DEVICE VALID != MOTION COMMAND**, **MODE SELECTOR != START DEVICE**, **SERVICE MODE EXIT != PRODUCTION START**, **ACCESS PERMISSION != PERSONNEL-SAFETY RELEASE**, **AUTHORIZED BYPASS != SAFE PHYSICAL CONDITION**, **BYPASS/FORCE DISABLED != BYPASS/FORCE REMOVED where the platform distinguishes them**, **FORCED INPUT TRUE != FIELD INPUT PHYSICALLY TRUE**, **SAFETY MODE RESTORED != SAFETY FUNCTION REVALIDATED**, **SAFETY SIGNATURE MATCHES != FIELD HARDWARE VALIDATED**, **VISIBLE WARNING != ADEQUATE RISK REDUCTION**, **EXCEPTIONAL STATE CLEARED != FRESH ORDINARY START DEMAND**, **MAINTENANCE COMPLETE != PRODUCTION READY until temporary-state clearance and impact-based revalidation are complete**, **FINAL-ELEMENT COMMAND/STATUS != PROCESS RESPONSE**, **STO ACTIVE != MECHANICAL LOAD SECURED**, **VALVE POSITION FEEDBACK VALID != PRESSURE SAFE**, **SUPPLY BLOCKED != STORED DOWNSTREAM ENERGY DECOMPRESSED**, **FEEDBACK RESTORED != FRESH START**, and **SAFETY RESET != START COMMAND**.

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

1. Trace **service/setup exit and automatic re-entry** in professional machine/application implementations far enough to determine how guard/protective-function restoration, enabling-device release, reset/rearm, automatic-mode selection and ordinary Start/Jog/Cycle interact.
2. Prefer actual machine-tool/robot application manuals rather than generic product catalogs. Specifically search for explicit behavior when an ordinary demand remains asserted across the transition; classify it as edge, level, latched, queued, cancelled, tracked or regenerated only from actual evidence.
3. If exact held-demand semantics remain undocumented after a bounded search, record that information-gain stop and rotate to **safe reduced-speed commissioning / safeguard-defeat human factors** rather than synthesizing a universal algorithm.
4. Preserve the exceptional-state manifest and production-readiness gate. Include software forces/bypasses, physical jumpers/aids, simulated witnesses, alternate parameters, safety-mode state, configuration identity, post-change physical tests, indication clearance and demand freshness.
5. Do not freeze universal bypass timeouts, key-switch circuits, PL/SIL targets, stopping limits, hydraulic thresholds or restart algorithms. Derive machine-specific acceptance from actual risk analysis and authoritative device/system semantics.
6. Keep LinuxCNC/ordinary FPGA roles bounded to normal control, indication, logging, diagnostics and ordinary-command gating. Independent safety authority and physical final-element/process validation remain separate.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
