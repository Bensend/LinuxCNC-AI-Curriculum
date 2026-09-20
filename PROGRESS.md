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

Newest accessible-cell validation study: `safety-course/ACCESSIBLE_CELL_SCANNER_GEOMETRY_RESET_AND_RESTART_VALIDATION_TRACE_2026-09-20.md` advances SICK/Pilz presence-sensing evidence into a commissioning contract. Manufacturer guidance requires restart interlock where the field can be left toward the hazard or personnel cannot be detected everywhere, and current SICK S300 instructions require reset outside the hazard, inaccessible from inside, with full view of the hazardous area. Scanner reset and machine restart remain separate actions. Freeze: **ACCESS FIELD CLEAR != HAZARD AREA PERSONNEL-CLEAR**, **SCANNER OSSD ON != MACHINE RESTART AUTHORIZED**, **RESET OPERATED != HAZARDOUS MOTION AUTHORIZED**, and **RESET LOCATION OUTSIDE CELL != RESET OPERATOR HAS FULL VIEW OF REQUIRED CLEARANCE AREA**. The derived adversarial validation now explicitly includes blind/stand-behind occupancy, retained-person challenge, stale-command challenge, final-element observation and fresh machine start; the exact combined script remains INFERENCE until a manufacturer acceptance procedure explicitly supplies it.

Newest hydraulic witness-boundary study: `safety-course/HYDRAULIC_POSITION_FEEDBACK_VS_PRESSURE_MOTION_PROOF_BOUNDARY_2026-09-20.md` uses Parker monitored poppet/spool valves and Bosch Rexroth manifold/safety guidance to separate final-element position feedback from independent pressure/energy and ram-motion witnesses. Freeze: **VALVE COMMAND SAFE != SOLENOID DE-ENERGIZED != POPPET/SPOOL IN MONITORED SAFE POSITION != DOWNSTREAM PRESSURE REMOVED != RAM PHYSICALLY STOPPED/RETAINED != QUANTITATIVE PERFORMANCE ACCEPTED**. No single authoritative press-brake procedure was found combining all layers with mismatch timeout, restart inhibition and return-to-service; that complete chain remains UNKNOWN and generic valve-catalog searching is now information-gain limited.

Newest gravity-axis physical-proof study: `safety-course/SINAMICS_SAFE_BRAKE_TEST_UNMASKED_GRAVITY_AXIS_PHYSICAL_PROOF_SEQUENCE_2026-09-20.md` closes the current drive/brake sequence with Siemens manufacturer evidence. SBT establishes the suspended load, selects one brake/test direction/sequence, closes the selected brake, deliberately keeps the companion brake open, applies defined test torque, and uses encoder-observed motion against a parameterized positional tolerance as the physical performance witness. Brake close/open expectations are timed/faulted and test exit is ordered before ordinary setpoint authority returns. Freeze: **STO ACTIVE != SBC COMMAND VALID != BRAKE MECHANICS HEALTHY != REQUIRED HOLDING TORQUE PHYSICALLY PROVED**, **TWO BRAKES PRESENT != EACH BRAKE INDIVIDUALLY PROVED**, and **TEST ABORTED != TEST PASSED != PRODUCTION AUTHORITY**. OpenPressBrake-specific torque, tolerance, interval, brake topology and required PL/SIL remain UNKNOWN.

Prior presence/restart foundation: `safety-course/PRESENCE_SENSING_REAR_ACCESS_RESTART_INTERLOCK_AUTHORITY_STUDY_2026-09-20.md` traces SICK and Pilz manufacturer guidance for stand-behind/rear-access hazards. Freeze: **ACCESS FIELD CLEAR != HAZARD AREA PERSONNEL-CLEAR != RESTART INTERLOCK SATISFIED**, and **PROTECTIVE DEVICE RESET != SAFETY REQUALIFIED != MACHINE RESTART AUTHORIZED != FRESH ORDINARY START**.

Cross-domain final-element foundation: `safety-course/FINAL_ELEMENT_WITNESS_EDM_STO_HYDRAULIC_POSITION_COMPARISON_2026-09-20.md` compares electrical contactor EDM, drive STO/torque-disabled status, safety brake feedback, and hydraulic spool/neutral-position monitoring. Preserve the witness ladder from safety demand -> command -> actuator/function status -> energy-path state -> physical machine response -> performance acceptance -> restart/rearm. Do not collapse heterogeneous witnesses into a generic `SAFE=true` bit.

Safety-input evidence: `safety-course/SAFETY_INPUT_MULTI_FAULT_SAFE_OUTPUT_AND_RESTART_DISPOSITION_STUDY_2026-09-20.md` closes the bounded generic field-fault search. Freeze: **FAULT PHYSICALLY REMOVED != FAULT LATCH CLEARED != REQUIRED DEVICE TEST/CYCLE COMPLETE != MANUAL RESET COMPLETE != OUTPUT REAUTHORIZED**.

Final-element EDM evidence: `safety-course/EXTERNAL_DEVICE_MONITORING_WELDED_CONTACTOR_PHYSICAL_FEEDBACK_STUDY_2026-09-20.md`. Freeze: **SAFETY OUTPUT COMMANDED OFF != EXTERNAL CONTACTOR DE-ENERGIZED != POWER CONTACTS PHYSICALLY OPEN**, and **EDM FEEDBACK CLOSED != ALL HAZARDOUS ENERGY REMOVED**.

Hydraulic controlled-energy study: `safety-course/CINCINNATI_AUTOFORM_ENERGIZED_COUNTERBALANCE_PRESSURE_COMMISSIONING_AUTHORITY_TRACE_2026-09-20.md` provides a real energized pressure measurement/adjustment procedure and separately requires blocked ram, power OFF and locked disconnect for manifold valve service/removal.

Controlled-energy foundation: `safety-course/CONTROLLED_ENERGY_DIAGNOSTIC_AND_SETUP_MODE_AUTHORITY_TRACE_2026-09-20.md`. Legitimate setup/diagnostic work requiring energy does not mean "bypass safety": a special mode can suppress normal production authority while a task-specific safety function remains active.

Maintenance-isolation foundation: `safety-course/MAINTENANCE_ENERGY_ISOLATION_VS_CONTROL_SAFETY_AUTHORITY_TRACE_2026-09-20.md`. Control circuitry/interlocks are not, by themselves, energy-isolating devices for covered servicing; stored/residual energy must be controlled and isolation verified.

Primary post-replacement hydraulic source path remains branch-locally source-limited. `safety-course/CINCINNATI_AUTOFORM_COUNTERBALANCE_DRIFT_FAULT_LOCALIZATION_AND_RECHECK_TRACE_2026-09-20.md` closes named counterbalance pressure setting, repeated-cycle/both-side recheck, and physical drift fault localization, but still does not expose a post-replacement static retaining acceptance test.

Operating-mode/reset evidence remains in `safety-course/OPERATING_MODE_TRANSITION_COMMISSIONING_AND_STALE_COMMAND_WITNESS_STUDY_2026-09-20.md` and `safety-course/RESET_RESTART_COLD_START_AND_STALE_COMMAND_AUTHORITY_STUDY_2026-09-19.md`: safety reset/readiness and fresh ordinary START remain separate authorities.

Two-hand/physical-stop evidence remains in `safety-course/PRESS_BRAKE_TWO_HAND_TOTAL_RESPONSE_AND_STOPPING_MONITOR_AUTHORITY_TRACE_2026-09-20.md` and `safety-course/HYDRAULIC_PRESS_BRAKE_TWO_HAND_CONTROL_PHYSICAL_STOP_AUTHORITY_TRACE_2026-09-19.md`.

Holding-valve evidence remains bounded by `safety-course/HOLDING_VALVE_BENCH_PROOF_VS_MACHINE_RETENTION_REVALIDATION_BOUNDARY_STUDY_2026-09-19.md`, `safety-course/HOLDING_VALVE_COMPONENT_PROOF_VS_INSTALLED_DRIFT_WITNESS_STUDY_2026-09-19.md`, and `safety-course/CINCINNATI_FM_VALVE_SERVICE_AND_POST_SERVICE_EVIDENCE_BOUNDARY_2026-09-19.md`.

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

1. Primary lane: seek a manufacturer **accessible-cell commissioning/acceptance procedure** that explicitly scripts deliberate stand-behind/blind-area occupancy and stale-command restart challenge with observed final-element behavior. Preserve the current derived validation script as INFERENCE until such evidence is found.
2. If that source path reaches an information-gain stop, rotate to another open safety module with a concrete physical evidence gap rather than repeating generic scanner guidance.
3. Reopen the hydraulic final-element lane only for a genuinely new OEM/manifold procedure combining monitored valve position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
4. Treat generic EDM/STO/brake/status-bit and generic safety-input fault-table cataloging as information-gain limited.
5. Treat the post-replacement holding/counterbalance-valve static-retention chain as source-limited unless a genuinely new OEM/manifold source appears.
6. Preserve the reusable energized-diagnostic authority contract: exact task, remaining hazards, physical configuration, selected control authority, permitted actuation, physical witness, abort behavior, masking control, acceptance criterion, and exit/requalification.
7. Preserve return-to-service separation: diagnostic complete != personnel clear != safeguards restored/revalidated != safety reset/rearm != fresh production start.
8. Resume routine 4000 controller-board work only when it directly supports the safety checkpoint or the safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
