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

Newest post-change revalidation evidence: `safety-course/SINAMICS_COMPONENT_REPLACEMENT_REVALIDATION_SCOPE_AND_PHYSICAL_WITNESS_MATRIX_2026-09-20.md` applies the four-class validation scaffold to concrete Siemens component-replacement procedures. Siemens requires affected-drive function testing before danger-zone reentry/resumed operation after relevant replacement; S210/G220 procedures use bidirectional physical motion to recheck actual-value/direction sensing, and the G220 OM-SMT replacement procedure deliberately tests short-circuit and wire-break faults. Current SINUMERIK replacement tables scope acceptance portions to the changed dependency. Freeze: **COMPONENT REPLACED != SAFE STATE PROVED != DANGER-ZONE REENTRY AUTHORIZED != OPERATION RESUMED**, **CONFIGURATION RESTORED != ACTUAL-VALUE/DIRECTION MAPPING PHYSICALLY PROVED**, and **NORMAL FUNCTION PASSED != REQUIRED WIRING/FAULT DIAGNOSTICS REVALIDATED**. A reduced drive acceptance test does not prove unrelated machine safeguards, hydraulic/mechanical hazard paths, or fresh ordinary START authority.

Newest validation-lifecycle evidence: `safety-course/ROCKWELL_ENABLING_SWITCH_FAULT_INJECTION_AND_FUNCTIONAL_PROOF_TEST_LIFECYCLE_2026-09-20.md` adds a manufacturer-directed abnormal-operation validation sequence. Rockwell SAFETY-AT055 deliberately shorts an enabling-switch safety channel while jogging and separately removes the safety-I/O network connection; expected behavior includes physical contactor de-energization, diagnostics, and inability to reset/restart with the fault. Freeze: **NORMAL FUNCTION TEST PASSED != REPRESENTATIVE FAULT RESPONSE VALIDATED**, **SAFETY PROGRAM OUTPUT OFF != EXTERNAL CONTACTORS PHYSICALLY DE-ENERGIZED**, and **FAULT DIAGNOSTIC VISIBLE != RESET/RESTART AUTHORIZED**. Rockwell proof-test guidance also establishes that controller, safety-I/O, sensor and actuator proof-test obligations can differ; never copy a manufacturer example interval into OpenPressBrake without architecture-specific justification.

Newest reusable curriculum scaffold: `safety-course/SAFETY_VALIDATION_EVIDENCE_CLASS_AND_RETURN_TO_SERVICE_MATRIX_2026-09-20.md` separates four evidence classes: (A) normal-demand functional test, (B) deliberate abnormal-operation/fault-injection test, (C) quantitative physical performance test, and (D) periodic functional/proof test. Freeze: **TESTED != VALIDATED unless the evidence class and acceptance criterion are named**, **HAPPY-PATH PASS != FAULT RESPONSE VALIDATED**, **FAULT-INJECTION PASS != PHYSICAL PERFORMANCE ACCEPTED**, and **PHYSICAL PERFORMANCE PASS != PERIODIC PROOF-TEST PROGRAM DEFINED**. Return-to-service must identify which evidence classes a change invalidated, repeat affected tests after repair, restore/requalify safeguards, and still require a separate fresh ordinary start.

Newest integrated setup authority evidence: `safety-course/SICK_SAFE_STATIONARY_MACHINE_SERVICE_MODE_RESET_ENABLE_START_AUTHORITY_TRACE_2026-09-20.md` combines SICK service-mode sequencing with its enabling-device guidance and Safety Multi-Box implementation. Service mode, safety reset, enabling-device permission and a separate start/jog action are distinct authorities; setup motion is reduced-speed in the worked training implementation. Freeze: **SERVICE/SETUP MODE SELECTED != SAFETY RESET ACCEPTED != ENABLING DEVICE VALID != MACHINE START**, and **SETUP SAFEGUARD OVERRIDE != UNRESTRICTED SPEED/MOTION AUTHORITY**. Generic enabling-device architecture searching is now information-gain limited.

Newest enabling-device final-element evidence: `safety-course/ROCKWELL_ENABLING_SWITCH_HELD_JOG_PHYSICAL_POWER_REMOVAL_TRACE_2026-09-20.md` traces middle-position enable plus separate jog through a safety relay to external K1/K2 contactors. Rockwell documents release/full squeeze de-energizing K1/K2 and hazardous motion coasting to stop, while ordinary non-enabling mode requires safe inputs plus a press-and-release Start action. Freeze: **MIDDLE-POSITION ENABLE != JOG COMMAND**, **RELEASE/FULL SQUEEZE != SOFTWARE STOP REQUEST**, and **CONTACTORS DE-ENERGIZED != AXIS INSTANTLY STATIONARY**.

Newest press-brake stop-time lifecycle evidence: `safety-course/PRESS_BRAKE_STOP_TIME_DETERIORATION_SAFEGUARD_REPOSITION_LIFECYCLE_TRACE_2026-09-20.md` adds Rockford RHPS hydraulic press-brake evidence tying increased stopping time/distance to safety-distance recalculation and outward safeguard repositioning as required. Freeze: **STOPPING TIME INCREASED != EXISTING SAFEGUARD POSITION STILL ACCEPTABLE** and **PREVENTIVE MAINTENANCE COMPLETE != SAFETY PERFORMANCE REVALIDATED WHEN THE WORK CAN AFFECT STOPPING PERFORMANCE**.

Newest setup/safe-speed evidence: `safety-course/SETUP_MODE_SAFE_SPEED_AUTHORITY_AND_ACCEPTANCE_TIMEOUT_TRACE_2026-09-20.md` adds a Siemens commissioning trial where opening a safety door with commissioning mode selected reduces motion to SLS rather than preserving unrestricted speed; closing the door requires safety acknowledgement before normal behavior resumes. Freeze: **COMMISSIONING MODE SELECTED != UNRESTRICTED MOTION AUTHORITY**, **TEST TIMEOUT != TEST PASS**, and **MODE SELECTED != PHYSICAL SPEED SAFE**.

Newest reset/restart freshness evidence: `safety-course/PENDING_START_ACROSS_RESET_AND_FRESH_START_EDGE_AUTHORITY_STUDY_2026-09-20.md` materially closes the generic stale-command mechanism gap. Freeze: **RESET ACCEPTED != START AUTHORIZED**, **START INPUT HIGH != FRESH START EVENT**, **PRE-RESET START REQUEST != POST-RESET MOTION AUTHORITY**, and **SAFETY READY + STALE START != VALID RESTART**.

Newest accessible-cell acceptance evidence: `safety-course/SBOT_SPEED_STAND_BEHIND_RESTART_ACCEPTANCE_SEQUENCE_2026-09-20.md` adds a SICK integrated safety-system test that deliberately challenges stand-behind behavior and physical field overlap. Preserve **ACCESS FIELD INTERRUPTED != RETAINED PERSON DETECTED** and **CONFIGURED FIELD OVERLAP != PHYSICAL OVERLAP VERIFIED**.

Physical protective-field commissioning foundation: `safety-course/PROTECTIVE_FIELD_PHYSICAL_BOUNDARY_AND_MACHINE_REACTION_COMMISSIONING_STUDY_2026-09-20.md`. Preserve **CONFIGURED PROTECTIVE FIELD != PHYSICAL PROTECTIVE FIELD VERIFIED** and **SCANNER INDICATES INTERRUPTION != DANGEROUS MACHINE MOVEMENT PHYSICALLY STOPPED**.

Newest hydraulic witness-boundary study: `safety-course/HYDRAULIC_POSITION_FEEDBACK_VS_PRESSURE_MOTION_PROOF_BOUNDARY_2026-09-20.md`. Preserve **VALVE COMMAND SAFE != SOLENOID DE-ENERGIZED != POPPET/SPOOL IN MONITORED SAFE POSITION != DOWNSTREAM PRESSURE REMOVED != RAM PHYSICALLY STOPPED/RETAINED != QUANTITATIVE PERFORMANCE ACCEPTED**.

Newest gravity-axis physical-proof study: `safety-course/SINAMICS_SAFE_BRAKE_TEST_UNMASKED_GRAVITY_AXIS_PHYSICAL_PROOF_SEQUENCE_2026-09-20.md`. Preserve **STO ACTIVE != SBC COMMAND VALID != BRAKE MECHANICS HEALTHY != REQUIRED HOLDING TORQUE PHYSICALLY PROVED**.

Cross-domain final-element foundation: `safety-course/FINAL_ELEMENT_WITNESS_EDM_STO_HYDRAULIC_POSITION_COMPARISON_2026-09-20.md`. Preserve the witness ladder from safety demand -> command -> actuator/function status -> energy-path state -> physical machine response -> performance acceptance -> restart/rearm. Do not collapse heterogeneous witnesses into a generic `SAFE=true` bit.

Safety-input evidence: `safety-course/SAFETY_INPUT_MULTI_FAULT_SAFE_OUTPUT_AND_RESTART_DISPOSITION_STUDY_2026-09-20.md`. Freeze: **FAULT PHYSICALLY REMOVED != FAULT LATCH CLEARED != REQUIRED DEVICE TEST/CYCLE COMPLETE != MANUAL RESET COMPLETE != OUTPUT REAUTHORIZED**.

Final-element EDM evidence: `safety-course/EXTERNAL_DEVICE_MONITORING_WELDED_CONTACTOR_PHYSICAL_FEEDBACK_STUDY_2026-09-20.md`. Freeze: **SAFETY OUTPUT COMMANDED OFF != EXTERNAL CONTACTOR DE-ENERGIZED != POWER CONTACTS PHYSICALLY OPEN**, and **EDM FEEDBACK CLOSED != ALL HAZARDOUS ENERGY REMOVED**.

Hydraulic controlled-energy study: `safety-course/CINCINNATI_AUTOFORM_ENERGIZED_COUNTERBALANCE_PRESSURE_COMMISSIONING_AUTHORITY_TRACE_2026-09-20.md` provides a real energized pressure measurement/adjustment procedure and separately requires blocked ram, power OFF and locked disconnect for manifold valve service/removal.

Controlled-energy foundation: `safety-course/CONTROLLED_ENERGY_DIAGNOSTIC_AND_SETUP_MODE_AUTHORITY_TRACE_2026-09-20.md`. Legitimate setup/diagnostic work requiring energy does not mean "bypass safety": a special mode can suppress normal production authority while a task-specific safety function remains active.

Maintenance-isolation foundation: `safety-course/MAINTENANCE_ENERGY_ISOLATION_VS_CONTROL_SAFETY_AUTHORITY_TRACE_2026-09-20.md`. Control circuitry/interlocks are not, by themselves, energy-isolating devices for covered servicing; stored/residual energy must be controlled and isolation verified.

Primary post-replacement hydraulic source path remains branch-locally source-limited. `safety-course/CINCINNATI_AUTOFORM_COUNTERBALANCE_DRIFT_FAULT_LOCALIZATION_AND_RECHECK_TRACE_2026-09-20.md` closes named counterbalance pressure setting, repeated-cycle/both-side recheck, and physical drift fault localization, but still does not expose a post-replacement static retaining acceptance test.

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

1. Find a machine/OEM post-maintenance or post-repair procedure that adds the downstream layer not closed by the Siemens drive evidence: quantitative physical machine performance (stop time/distance, brake holding, hydraulic retention, etc.), consequent safeguard requalification/repositioning if required, and explicit production release. Prefer press/press-brake or another high-energy machine.
2. Use the four-class matrix plus Lane-B modification-impact rules to distinguish what a particular change invalidates. Do not require all four evidence classes mechanically when the change cannot affect them, but never substitute checksum/configuration identity for a required physical witness.
3. Reopen hydraulic final-element work only for genuinely new OEM/manifold evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
4. Reopen press-brake stop-time work only for a stronger all-in-one post-maintenance/return-to-service checklist or genuinely new OEM evidence.
5. Treat generic drive replacement, EDM/STO/brake/status-bit, scanner, safety-input, reset/restart and enabling-device cataloging as information-gain limited.
6. Preserve energized-diagnostic authority, physical final-element proof, fault-injection validation, periodic proof testing, safeguard requalification and return-to-service as separate evidence layers.
7. Do not copy proof-test intervals, PL/SIL, stopping limits, hydraulic thresholds or diagnostic coverage from examples into OpenPressBrake without design-specific authority.
8. Resume routine controller-board work only when it directly supports the safety checkpoint or safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
