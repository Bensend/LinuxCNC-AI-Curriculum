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

Newest evidence: `safety-course/ABB_ROBOTWARE8_GUARD_STOP_RESET_AND_SEPARATE_START_BOUNDARY_2026-09-21.md` traces an actual professional robot return path. ABB RobotWare 8 documents a start/restart interlock after safety violations, safety-related stops, operating-mode switches and controller restart. Reset clears the interlock/returns the controller to motors-on eligibility; program Start remains a separate action. This freezes **GUARD/SAFETY CONDITION RESTORED != START/RESTART INTERLOCK RESET**, **RESET ACCEPTED != PROGRAM START**, and **MOTORS ON != PROGRAM START**. Public evidence still does not justify a universal electrical/software rule for an ordinary Start/Jog/Cycle input held across the transition; that implementation detail remains UNKNOWN/design-specific.

The held-demand boundary is also exercised in `safety-course/25C0_SETUP_TO_AUTOMATIC_HELD_DEMAND_REVIEW_EXERCISE_2026-09-21.md`, anchored by `SIEMENS_ABB_SETUP_TO_AUTOMATIC_RETURN_AND_FRESH_START_BOUNDARY_2026-09-21.md`. A conservative ordinary-control freshness gate may invalidate pre-transition demand without moving personnel-safety authority into LinuxCNC/normal FPGA control.

Newest rotated branch: `safety-course/KUKA_REDUCED_SPEED_COMMAND_VS_SAFETY_MONITORING_HUMAN_FACTORS_2026-09-21.md` uses KUKA Sunrise documentation to distinguish T1's ordinary reduced velocity from safety-oriented velocity monitoring. KUKA explicitly warns that the standard T1 250 mm/s reduced velocity is not safety-rated monitoring unless the applicable safety monitoring is configured. FANUC DCS independently corroborates the distinction between ordinary motion command and certified independent position/speed monitoring. Freeze **COMMANDED REDUCED SPEED != SAFETY-RATED SPEED MONITORING**, **T1/SETUP MODE LABEL != SAFE SPEED PROVED**, and **NORMAL CONTROLLER SPEED OVERRIDE != INDEPENDENT PROCESS-SPEED WITNESS**. Do not import KUKA's 250 mm/s value into OpenPressBrake or other machine classes.

Maintenance/bypass evidence retained: `25E0_MAINTENANCE_BYPASS_FORCE_LIFECYCLE_AND_PRODUCTION_CARRYOVER_2026-09-21.md` turns temporary maintenance/commissioning states into an explicit lifecycle rather than a generic `maintenance_mode`. Rockwell safety forces must be removed, not merely disabled, before safety lock/signature; forcing an input overrides the real field value. Siemens S7 Distributed Safety independently requires deactivated safety mode to be verifiable, recommends indication/logging, and warns that safety-related data from an F-CPU in deactivated safety mode cannot simply be assumed safely generated.

Validation methodology retained: `25E0_SAFETY_FUNCTION_VALIDATION_RECORD_AND_ACCEPTANCE_MATRIX_2026-09-21.md` and `25E0_VALIDATION_TEMPLATE_PHYSICS_STRESS_TEST_2026-09-21.md` require hazard/safe-state identity, proposition-to-witness mapping, physical energy chain, timing endpoints, fault injection, reset/rearm and demand freshness, temporary-state clearance, human-factors defeat resistance, modification impact and explicit safety-critical UNKNOWN handling.

Prior 25E0 evidence retained: active brake proof (Siemens SBT and SEW brake test), process-speed witnesses (Siemens S120), hydraulic/pneumatic final-element monitoring (SMC/Festo/Bosch Rexroth), Rockwell Safe Brake Control mismatch/reset semantics, Siemens 3SK1 held-start/feedback-recovery behavior, service/setup authorization and enabling boundaries, and exceptional-state production carryover controls.

Freeze: **AUTHORIZED USER != SAFE MODE SELECTED**, **SAFE MODE SELECTED != HAZARDOUS MOTION AUTHORIZED**, **ENABLING DEVICE VALID != MOTION COMMAND**, **MODE SELECTOR != START DEVICE**, **SERVICE MODE EXIT != PRODUCTION START**, **ACCESS PERMISSION != PERSONNEL-SAFETY RELEASE**, **AUTHORIZED BYPASS != SAFE PHYSICAL CONDITION**, **BYPASS/FORCE DISABLED != BYPASS/FORCE REMOVED where the platform distinguishes them**, **FORCED INPUT TRUE != FIELD INPUT PHYSICALLY TRUE**, **SAFETY MODE RESTORED != SAFETY FUNCTION REVALIDATED**, **SAFETY SIGNATURE MATCHES != FIELD HARDWARE VALIDATED**, **VISIBLE WARNING != ADEQUATE RISK REDUCTION**, **EXCEPTIONAL STATE CLEARED != FRESH ORDINARY START DEMAND**, **MAINTENANCE COMPLETE != PRODUCTION READY until temporary-state clearance and impact-based revalidation are complete**, **FINAL-ELEMENT COMMAND/STATUS != PROCESS RESPONSE**, **STO ACTIVE != MECHANICAL LOAD SECURED**, **VALVE POSITION FEEDBACK VALID != PRESSURE SAFE**, **SUPPLY BLOCKED != STORED DOWNSTREAM ENERGY DECOMPRESSED**, **FEEDBACK RESTORED != FRESH START**, **SAFETY RESET != START COMMAND**, **COMMANDED REDUCED SPEED != SAFETY-RATED SPEED MONITORING**.

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

1. Build a reusable **safeguard-defeat / commissioning-shortcut review method**. For each foreseeable shortcut (guard bypass, defeated/taped enabling device, ordinary software speed override, persistent service key/mode, simulated witness, force/jumper), capture the inconvenience motivating it, the hazardous consequence, the engineered usability correction, and the validation evidence needed before production return.
2. Stress-test the method against at least two unlike machines, preferably a press-brake/hydraulic gravity-axis case and a rotating spindle/robot-cell case. Preserve machine-specific physics and do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets or bypass timeouts.
3. Keep reduced-speed command and independent safety monitoring separate. LinuxCNC may provide conservative defaults, deliberate jog semantics, indication/logging and stale-demand cancellation; it does not thereby become personnel-safety authority.
4. Preserve the exceptional-state manifest and production-readiness gate: software forces/bypasses, physical jumpers/aids, simulated witnesses, alternate parameters, safety-mode state, configuration identity, post-change physical tests, indication clearance and demand freshness.
5. If a safeguard cannot be restored and the machine cannot meet the minimum safe-to-operate threshold, teach isolated/remote experimental operation with people outside the danger zone and residual risk stated plainly rather than normalizing bypass.
6. Continue authoritative professional implementation tracing where it has information gain; do not resume broad searches for a universal held-demand algorithm without a specific controller/application evidence target.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and safeguard-defeat human-factors methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.