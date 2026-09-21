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

Newest machine-tool supported-exception trace: `safety-course/25E0_MACHINE_TOOL_SAFE_LIMITED_SPEED_ACCESS_AND_RETURN_2026-09-21.md` closes the immediate non-robot setup/access evidence gap. Rockwell Kinetix documents SLS with door and enabling-switch monitoring: safe speed is detected before door unlock, enabling is retained during hazardous-area access, and return requires leaving the area, closing the door/restoring the SLS input, reset when configured, then releasing enabling. A separate Rockwell machine assist/production example uses keyed mode selection, enabling-device task motion, and safety-rated speed monitoring. Siemens SINUMERIK independently documents SLS for setup and other machine-tool safety functions. Freeze **SLS REQUESTED != SAFE SPEED PROVED**, **ENABLING VALID != MOTION COMMAND**, **ORDINARY CNC VELOCITY LIMIT != SAFETY-RATED ACTUAL-SPEED MONITORING**, and **DOOR CLOSED != PRODUCTION RETURN COMPLETE**.

Newest supported-exception trace retained: `safety-course/25E0_SETUP_ENABLING_REDUCED_MOTION_SUPPORTED_EXCEPTION_2026-09-21.md` extends intentional-exception study beyond material-flow muting. ABB enabling-control guidance separates enabling permission from a separate start control and documents a setup/maintenance pattern in which displaced normal protection is replaced by a specific mode, continuous enabling/hold-to-run behavior and reduced-risk operation. ABB SafeMove recovery further separates enabling-device recovery from deliberate jog action. KUKA independently establishes that ordinary T1 reduced velocity is not automatically safety-rated reduced-speed monitoring.

Newest adversarial transfer retained: `safety-course/25E0_SUPPORTED_EXCEPTION_VS_DEFEAT_STRESS_TEST_2026-09-21.md` compares a supported setup/enabling/reduced-motion architecture with a spare guard actuator + taped jog + ordinary LinuxCNC velocity override that produces the same normal-controller `recovery_permit` bit. Equal permissive bits do not imply equal safety evidence. A held Cycle Start across the transition is not granted fresh production authority by restored safety eligibility.

Newest learner-facing return method: `safety-course/25E0_PRODUCTION_RETURN_EXCEPTIONAL_STATE_CHECKLIST_AND_ADVERSARIAL_EXERCISE_2026-09-21.md` requires explicit exceptional-state inventory, positive clearance, configuration identity, proposition-specific physical revalidation, fault/diagnostic restoration, independent safety authority, ordinary-demand freshness, and human-factors/shift handoff before production return. A safety-critical `UNKNOWN` blocks the acceptance claim that depends on it.

Professional intentional-exception evidence retained: `safety-course/25E0_SICK_PILZ_MUTING_OVERRIDE_INTENTIONAL_EXCEPTION_BOUNDARY_2026-09-21.md` compares SICK deTec4/Flexi Compact and Pilz PSEN opII4H muting-dependent override. These systems expose a legitimate exceptional-state architecture with qualified eligibility, deliberate activation, indication/monitoring, bounded time/sequence/repetition, explicit exit/fault behavior, and return to normal protective logic.

Safeguard-defeat methodology retained: `safety-course/25E0_SAFEGUARD_DEFEAT_AND_COMMISSIONING_SHORTCUT_REVIEW_METHOD_2026-09-21.md` turns foreseeable defeat into an engineering review: legitimate task, manipulation incentive/friction, shortcut, destroyed physical evidence, hazard consequence, incentive-removing usability correction, defeat resistance, exceptional-mode boundary, persistence/carryover, physical revalidation and demand freshness.

Maintenance/bypass and validation evidence retained: temporary maintenance/commissioning states are explicit lifecycle states; validation artifacts require hazard/safe-state identity, proposition-to-witness mapping, physical energy chain, timing endpoints, fault injection, reset/rearm and demand freshness, temporary-state clearance, human-factors defeat resistance, modification impact and explicit safety-critical UNKNOWN handling.

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

1. Build proposition-specific **revalidation-after-exception/change** guidance: identify exactly which prior evidence becomes stale after safety sensor replacement, brake work, valve work, encoder/configuration change, wiring repair, or temporary force/simulation.
2. Stress-test that method against one hydraulic/gravity-axis case and one rotating/servo machine case. Separate component health, final-element state, process response, stopping performance, configuration identity, reset/rearm, and fresh ordinary demand.
3. Make modification impact explicit: `exception ended`, `part replaced`, `force removed`, `alarm clear`, or `signature valid` cannot substitute for re-proving the affected physical proposition.
4. Preserve machine-specific physics: do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds, muting geometry, override counts, or timeouts.
5. If a safeguard cannot be restored and the machine cannot meet the minimum safe-to-operate threshold, teach isolated/remote experimental operation with people outside the danger zone and residual risk stated plainly rather than normalizing bypass.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.