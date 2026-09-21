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

Newest methodology: `safety-course/25E0_SAFEGUARD_DEFEAT_AND_COMMISSIONING_SHORTCUT_REVIEW_METHOD_2026-09-21.md` turns foreseeable defeat into an engineering review: legitimate task, manipulation incentive/friction, shortcut, destroyed physical evidence, hazard consequence, incentive-removing usability correction, defeat resistance, exceptional-mode boundary, persistence/carryover, physical revalidation and demand freshness. Pilz/ISO 14119 implementation guidance and OSHA machine-guarding guidance independently support designing safeguards around real work and reducing interference/incentive rather than relying only on anti-tamper measures. Freeze **DIFFICULT TO BYPASS != LOW INCENTIVE TO BYPASS**, **INTERLOCK SIGNAL HEALTHY != GUARD PHYSICALLY EFFECTIVE when defeated**, **SERVICE MODE SELECTED != REPLACEMENT SAFETY FUNCTIONS VALIDATED**, and **FORCE/JUMPER REMOVED != DESTROYED PHYSICAL PROPOSITION REVALIDATED**.

The method was stress-tested against (1) a hydraulic/gravity-axis press-brake case involving a spare guard actuator and ordinary LinuxCNC speed limit, and (2) a rotating spindle/robot-cell case involving a defeated enabling device, persistent service mode and ordinary software speed override. The review structure transfers; physical acceptance criteria do not. LinuxCNC/normal FPGA may reduce defeat incentive through good setup UI, deliberate jog semantics, diagnostics, indication/logging and stale-demand cancellation, but do not thereby become personnel-safety authority.

Prior current evidence retained: ABB RobotWare 8 start/restart interlock separates guard/safety restoration, reset/motors-on eligibility and program Start. KUKA Sunrise distinguishes ordinary T1 reduced velocity from separately configured safety-oriented velocity monitoring; FANUC DCS corroborates independent actual position/speed monitoring. Public evidence still does not justify a universal electrical/software rule for an ordinary Start/Jog/Cycle input held across every transition; that implementation detail remains UNKNOWN/design-specific.

Maintenance/bypass evidence retained: `25E0_MAINTENANCE_BYPASS_FORCE_LIFECYCLE_AND_PRODUCTION_CARRYOVER_2026-09-21.md` turns temporary maintenance/commissioning states into an explicit lifecycle rather than a generic `maintenance_mode`. Rockwell safety forces must be removed, not merely disabled, before safety lock/signature; forcing an input overrides the real field value. Siemens S7 Distributed Safety independently requires deactivated safety mode to be verifiable, recommends indication/logging, and warns that safety-related data from an F-CPU in deactivated safety mode cannot simply be assumed safely generated.

Validation methodology retained: `25E0_SAFETY_FUNCTION_VALIDATION_RECORD_AND_ACCEPTANCE_MATRIX_2026-09-21.md` and `25E0_VALIDATION_TEMPLATE_PHYSICS_STRESS_TEST_2026-09-21.md` require hazard/safe-state identity, proposition-to-witness mapping, physical energy chain, timing endpoints, fault injection, reset/rearm and demand freshness, temporary-state clearance, human-factors defeat resistance, modification impact and explicit safety-critical UNKNOWN handling.

Prior 25E0 evidence retained: active brake proof (Siemens SBT and SEW brake test), process-speed witnesses (Siemens S120), hydraulic/pneumatic final-element monitoring (SMC/Festo/Bosch Rexroth), Rockwell Safe Brake Control mismatch/reset semantics, Siemens 3SK1 held-start/feedback-recovery behavior, service/setup authorization and enabling boundaries, and exceptional-state production carryover controls.

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

1. Convert the defeat-review method into a **production-return / exceptional-state checklist and adversarial exercise** that a learner can apply without seeing the answer. Include physical defeat aids, software forces, simulated witnesses, service-mode persistence, alternate parameters, safety configuration identity, physical revalidation and stale ordinary demand.
2. Trace one authoritative professional implementation where bypass/muting/override is intentionally supported for a legitimate process task (e.g. muting, maintenance override, setup access). Capture the constraints that keep the exception from silently becoming normal production behavior; distinguish safety-rated override/muting from an ordinary PLC/LinuxCNC bypass.
3. Preserve machine-specific physics: do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds or bypass timeouts.
4. If a safeguard cannot be restored and the machine cannot meet the minimum safe-to-operate threshold, teach isolated/remote experimental operation with people outside the danger zone and residual risk stated plainly rather than normalizing bypass.
5. Continue authoritative professional implementation tracing where it has information gain; do not resume broad searches for a universal held-demand algorithm without a specific controller/application evidence target.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and safeguard-defeat human-factors methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
