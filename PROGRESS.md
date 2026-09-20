# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14. F02 GRADUATED; valid evaluator `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md`.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15. Closeout: `evaluation/3000-series-promotion-closeout-2026-09-15.md`.

Do not routinely reopen closed levels without a genuinely new material defect.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

### Primary active priority — safety course / professional machine implementation

Routine controller-board development remains a separate automation concern and must not displace safety work here.

Current safety emphasis includes machine hazard boundaries; independent safety authority; hydraulic/electrical/mechanical final-element proof; maintenance and return-to-service evidence; reset/restart/cold-start freshness; two-hand physical stopping/safety-distance authority; operating-mode commissioning; and explicit separation of normal stop, safety-related stop, hazardous-energy isolation, and deliberately bounded energized diagnostic authority.

Newest integrated setup authority evidence: `safety-course/SICK_SAFE_STATIONARY_MACHINE_SERVICE_MODE_RESET_ENABLE_START_AUTHORITY_TRACE_2026-09-20.md` combines SICK service-mode sequencing with its enabling-device guidance and Safety Multi-Box implementation. Service mode, safety reset, enabling-device permission and a separate start/jog action are distinct authorities; setup motion is reduced-speed in the worked training implementation. Freeze: **SERVICE/SETUP MODE SELECTED != SAFETY RESET ACCEPTED != ENABLING DEVICE VALID != MACHINE START**, and **SETUP SAFEGUARD OVERRIDE != UNRESTRICTED SPEED/MOTION AUTHORITY**. Generic enabling-device architecture searching is now information-gain limited; the remaining useful target is a physical all-in-one acceptance sequence covering held-command release/full-squeeze, 3->2 non-reactivation, setup exit, safeguard restoration and fresh production start.

Newest enabling-device final-element evidence: `safety-course/ROCKWELL_ENABLING_SWITCH_HELD_JOG_PHYSICAL_POWER_REMOVAL_TRACE_2026-09-20.md` traces middle-position enable plus separate jog through a safety relay to external K1/K2 contactors. Rockwell documents release/full squeeze de-energizing K1/K2 and hazardous motion coasting to stop, while ordinary non-enabling mode requires safe inputs plus a press-and-release Start action. Freeze: **MIDDLE-POSITION ENABLE != JOG COMMAND**, **RELEASE/FULL SQUEEZE != SOFTWARE STOP REQUEST**, and **CONTACTORS DE-ENERGIZED != AXIS INSTANTLY STATIONARY**. Preserve a source difference: Rockwell's worked application does not itself prove SICK's explicit 3->2 non-reactivation transition semantics; do not silently generalize exact re-entry behavior across implementations.

Newest press-brake stop-time lifecycle evidence: `safety-course/PRESS_BRAKE_STOP_TIME_DETERIORATION_SAFEGUARD_REPOSITION_LIFECYCLE_TRACE_2026-09-20.md` adds Rockford RHPS hydraulic press-brake evidence tying increased stopping time/distance to safety-distance recalculation and outward safeguard repositioning as required. Rockford also treats maintenance, brake wear and alterations as reasons stopping performance can change. Freeze: **STOPPING TIME INCREASED != EXISTING SAFEGUARD POSITION STILL ACCEPTABLE**, **PREVENTIVE MAINTENANCE COMPLETE != SAFETY PERFORMANCE REVALIDATED WHEN THE WORK CAN AFFECT STOPPING PERFORMANCE**, and **FAILURE RESETTABLE != FAILURE ACCEPTABLE FOR PRODUCTION**. Generic stop-time formula searching is information-gain limited.

Newest setup/safe-speed evidence: `safety-course/SETUP_MODE_SAFE_SPEED_AUTHORITY_AND_ACCEPTANCE_TIMEOUT_TRACE_2026-09-20.md` adds a Siemens commissioning trial where opening a safety door with commissioning mode selected reduces motion to SLS rather than preserving unrestricted speed; closing the door requires safety acknowledgement before normal behavior resumes. Siemens separately time-bounds acceptance-test mode and cancels an unfinished test on timeout. Pilz PNOZ s30 independently separates Setup and Automatic monitored-speed states. Freeze: **COMMISSIONING MODE SELECTED != UNRESTRICTED MOTION AUTHORITY**, **TEST TIMEOUT != TEST PASS**, and **MODE SELECTED != PHYSICAL SPEED SAFE**.

Newest reset/restart freshness evidence: `safety-course/PENDING_START_ACROSS_RESET_AND_FRESH_START_EDGE_AUTHORITY_STUDY_2026-09-20.md` materially closes the generic stale-command mechanism gap. Siemens explicitly warns that a pending PLC/start command can cause automatic restart when RESET is issued; SICK UE440/UE470 requires RESET to complete first and then a later START rising edge. Freeze: **RESET ACCEPTED != START AUTHORIZED**, **START INPUT HIGH != FRESH START EVENT**, **PRE-RESET START REQUEST != POST-RESET MOTION AUTHORITY**, and **SAFETY READY + STALE START != VALID RESTART**. Generic reset/restart searching is information-gain limited unless a source adds an integrated physical acceptance test that deliberately holds START through reset and observes no hazardous motion.

Newest accessible-cell acceptance evidence: `safety-course/SBOT_SPEED_STAND_BEHIND_RESTART_ACCEPTANCE_SEQUENCE_2026-09-20.md` materially closes the prior stand-behind acceptance gap with a SICK integrated safety-system test sequence. The manufacturer test starts the robot in Automated mode, interrupts PF1/PF2, deliberately stands behind the protective fields (or approves both simultaneously), expects the robot to stop, and permits restart only when all fields are free and reset has been actuated. The same acceptance table physically verifies field-set dimensions/overlap. Freeze: **ACCESS FIELD INTERRUPTED != RETAINED PERSON DETECTED**, **CONFIGURED FIELD OVERLAP != PHYSICAL OVERLAP VERIFIED**, and **RESET ACTUATED != PERSONNEL-CLEAR PROVED BY AN ARBITRARY ARCHITECTURE**. Scanner-specific generic searching is information-gain limited.

Physical protective-field commissioning foundation: `safety-course/PROTECTIVE_FIELD_PHYSICAL_BOUNDARY_AND_MACHINE_REACTION_COMMISSIONING_STUDY_2026-09-20.md` adds SICK/Rockwell manufacturer procedures requiring deliberate intrusion at multiple physical points/boundaries and observation of actual dangerous machine motion stopping. Freeze: **CONFIGURED PROTECTIVE FIELD != PHYSICAL PROTECTIVE FIELD VERIFIED**, **ONE INTRUSION POINT PASSED != ENTIRE REQUIRED BOUNDARY/AREA VERIFIED**, and **SCANNER INDICATES INTERRUPTION != DANGEROUS MACHINE MOVEMENT PHYSICALLY STOPPED**.

Prior accessible-cell foundation: `safety-course/ACCESSIBLE_CELL_SCANNER_GEOMETRY_RESET_AND_RESTART_VALIDATION_TRACE_2026-09-20.md`. Preserve **ACCESS FIELD CLEAR != HAZARD AREA PERSONNEL-CLEAR**, **SCANNER OSSD ON != MACHINE RESTART AUTHORIZED**, and **RESET OPERATED != HAZARDOUS MOTION AUTHORIZED**.

Newest hydraulic witness-boundary study: `safety-course/HYDRAULIC_POSITION_FEEDBACK_VS_PRESSURE_MOTION_PROOF_BOUNDARY_2026-09-20.md` separates final-element position feedback from independent pressure/energy and ram-motion witnesses. Freeze: **VALVE COMMAND SAFE != SOLENOID DE-ENERGIZED != POPPET/SPOOL IN MONITORED SAFE POSITION != DOWNSTREAM PRESSURE REMOVED != RAM PHYSICALLY STOPPED/RETAINED != QUANTITATIVE PERFORMANCE ACCEPTED**. Generic valve-catalog searching is information-gain limited.

Newest gravity-axis physical-proof study: `safety-course/SINAMICS_SAFE_BRAKE_TEST_UNMASKED_GRAVITY_AXIS_PHYSICAL_PROOF_SEQUENCE_2026-09-20.md` closes the current drive/brake sequence with Siemens manufacturer evidence. Freeze: **STO ACTIVE != SBC COMMAND VALID != BRAKE MECHANICS HEALTHY != REQUIRED HOLDING TORQUE PHYSICALLY PROVED**, **TWO BRAKES PRESENT != EACH BRAKE INDIVIDUALLY PROVED**, and **TEST ABORTED != TEST PASSED != PRODUCTION AUTHORITY**.

Cross-domain final-element foundation: `safety-course/FINAL_ELEMENT_WITNESS_EDM_STO_HYDRAULIC_POSITION_COMPARISON_2026-09-20.md`. Preserve the witness ladder from safety demand -> command -> actuator/function status -> energy-path state -> physical machine response -> performance acceptance -> restart/rearm. Do not collapse heterogeneous witnesses into a generic `SAFE=true` bit.

Safety-input evidence: `safety-course/SAFETY_INPUT_MULTI_FAULT_SAFE_OUTPUT_AND_RESTART_DISPOSITION_STUDY_2026-09-20.md`. Freeze: **FAULT PHYSICALLY REMOVED != FAULT LATCH CLEARED != REQUIRED DEVICE TEST/CYCLE COMPLETE != MANUAL RESET COMPLETE != OUTPUT REAUTHORIZED**.

Final-element EDM evidence: `safety-course/EXTERNAL_DEVICE_MONITORING_WELDED_CONTACTOR_PHYSICAL_FEEDBACK_STUDY_2026-09-20.md`. Freeze: **SAFETY OUTPUT COMMANDED OFF != EXTERNAL CONTACTOR DE-ENERGIZED != POWER CONTACTS PHYSICALLY OPEN**, and **EDM FEEDBACK CLOSED != ALL HAZARDOUS ENERGY REMOVED**.

Hydraulic controlled-energy study: `safety-course/CINCINNATI_AUTOFORM_ENERGIZED_COUNTERBALANCE_PRESSURE_COMMISSIONING_AUTHORITY_TRACE_2026-09-20.md` provides a real energized pressure measurement/adjustment procedure and separately requires blocked ram, power OFF and locked disconnect for manifold valve service/removal.

Controlled-energy foundation: `safety-course/CONTROLLED_ENERGY_DIAGNOSTIC_AND_SETUP_MODE_AUTHORITY_TRACE_2026-09-20.md`. Legitimate setup/diagnostic work requiring energy does not mean "bypass safety": a special mode can suppress normal production authority while a task-specific safety function remains active.

Maintenance-isolation foundation: `safety-course/MAINTENANCE_ENERGY_ISOLATION_VS_CONTROL_SAFETY_AUTHORITY_TRACE_2026-09-20.md`. Control circuitry/interlocks are not, by themselves, energy-isolating devices for covered servicing; stored/residual energy must be controlled and isolation verified.

Primary post-replacement hydraulic source path remains branch-locally source-limited. `safety-course/CINCINNATI_AUTOFORM_COUNTERBALANCE_DRIFT_FAULT_LOCALIZATION_AND_RECHECK_TRACE_2026-09-20.md` closes named counterbalance pressure setting, repeated-cycle/both-side recheck, and physical drift fault localization, but still does not expose a post-replacement static retaining acceptance test.

Operating-mode/reset evidence remains in `safety-course/OPERATING_MODE_TRANSITION_COMMISSIONING_AND_STALE_COMMAND_WITNESS_STUDY_2026-09-20.md` and `safety-course/RESET_RESTART_COLD_START_AND_STALE_COMMAND_AUTHORITY_STUDY_2026-09-19.md`: safety reset/readiness and fresh ordinary START remain separate authorities.

Two-hand/physical-stop evidence remains in `safety-course/PRESS_BRAKE_TWO_HAND_TOTAL_RESPONSE_AND_STOPPING_MONITOR_AUTHORITY_TRACE_2026-09-20.md` and `safety-course/HYDRAULIC_PRESS_BRAKE_TWO_HAND_CONTROL_PHYSICAL_STOP_AUTHORITY_TRACE_2026-09-19.md`.

Personnel-retention freeze: **ACCESS CLEAR != PERSONNEL CLEAR != RETAINED-PERSON LIST EMPTY != BLIND AREA CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.**

Gravity-axis proof freeze: **BRAKE TEST REQUEST != TEST TORQUE APPLIED != BRAKE HELD TEST TORQUE != LOAD PHYSICALLY RETAINED != TEST PASS != PRODUCTION AUTHORITY.**

Guard-locking freeze: **GUARD CLOSED != GUARD LOCKED != HAZARD CEASED != UNLOCK AUTHORIZED != PERSONNEL CLEAR != RESTART AUTHORIZED.**

Safety-network replacement freeze: **IP/NODE ADDRESS CORRECT != SAFETY DEVICE IDENTITY CORRECT != CONFIGURATION OWNERSHIP CORRECT != SAFETY CONFIGURATION VERIFIED != SAFETY CONNECTION RESTORED != FUNCTIONAL SAFETY REVALIDATED != HAZARDOUS-MOTION AUTHORITY != FRESH ORDINARY START.**

Hydraulic stop-proof freeze: **PROTECTIVE-DEVICE DEMAND != SAFETY OUTPUT CHANGED != HYDRAULIC FINAL ELEMENT REACHED SAFE POSITION != RAM STOPPED/RETRACTED AS REQUIRED != MEASURED STOP PERFORMANCE VALID != ACCESS SAFE.**

Replacement/revalidation freeze: **SAFETY-RELATED COMPONENT REPLACED != MACHINE SAFE TO RETURN TO SERVICE.**

Home-shop maintenance rule: before work, remove/isolate/discharge/block/restrain or otherwise control the hazards relevant to the task. Never leave an unsafe/incomplete/bypassed machine unattended without unmistakable OUT OF SERVICE / DO NOT OPERATE tag-out or equivalent status. Tag-out communicates/preserves the state; it is not a substitute for physical hazard control.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Seek a manufacturer/OEM *acceptance procedure* that deliberately holds jog/inch while challenging enabling-device release, full squeeze and 3->2 recovery, then exits setup, restores/requalifies the ordinary safeguard and demonstrates a separate fresh production START. Architecture/catalog evidence alone is now insufficient.
2. Seek an integrated safe-speed setup acceptance sequence only if it adds physical SLS/SSM challenge to that enabling-device/mode-exit chain; generic SLS and enabling-device searches are information-gain limited separately.
3. Reopen press-brake stop-time work only for a stronger all-in-one return-to-service checklist or genuinely new OEM evidence; generic formula searching is information-gain limited.
4. Reopen hydraulic final-element work only for genuinely new OEM/manifold evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
5. Treat generic EDM/STO/brake/status-bit, scanner, safety-input, reset/restart and enabling-device cataloging as information-gain limited.
6. Preserve energized-diagnostic authority, physical final-element proof, and return-to-service as separate evidence layers.
7. Resume routine controller-board work only when it directly supports the safety checkpoint or safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
