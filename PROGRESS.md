# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

Repository artifacts, not chat history, are authoritative. Detailed history remains in Git and referenced research/results/evaluation artifacts.

## Closed prerequisite levels

- **1000 series:** GRADUATED / CLOSED.
- **2000 series:** GRADUATED / CLOSED as of 2026-09-14. F02 GRADUATED; valid evaluator `evaluation/F02-fresh-ai-evaluation-2026-09-14-valid.md`; closeout `evaluation/2000-series-closeout-state-2026-09-11.md` finalized 2026-09-14.
- **3000 series:** GRADUATED / CLOSED as of 2026-09-15 after formal promotion/playbook-completeness review. Closeout: `evaluation/3000-series-promotion-closeout-2026-09-15.md`.

Do not routinely reopen closed levels without a genuinely new material defect.

## Active curriculum level

**4000 — hardware and AI-assisted implementation.**

### Primary active priority — safety course / professional machine implementation

The owner has promoted the LinuxCNC/OpenPressBrake safety course to the primary active 4000 priority. Routine controller-board development remains a separate automation concern and must not displace safety work here.

Current safety emphasis includes machine hazard boundaries; independent safety authority; hydraulic/electrical/mechanical final-element proof; maintenance and return-to-service evidence; reset/restart/cold-start freshness; two-hand physical stopping/safety-distance authority; operating-mode commissioning; and explicit separation of normal stop, safety-related stop, and hazardous-energy isolation.

Newest cross-machine maintenance study: `safety-course/MAINTENANCE_ENERGY_ISOLATION_VS_CONTROL_SAFETY_AUTHORITY_TRACE_2026-09-20.md`. OSHA hazardous-energy and press slide-lock guidance establishes that control circuitry/interlocks are not, by themselves, energy-isolating devices for covered servicing; stored/residual energy must be controlled and isolation verified. Freeze: **NORMAL STOP COMMAND != SAFETY-RELATED STOP != HAZARDOUS-ENERGY ISOLATION**, **E-STOP ACTIVE != ELECTRICAL ENERGY ISOLATED != HYDRAULIC PRESSURE DISCHARGED != GRAVITY LOAD PHYSICALLY RESTRAINED**, **GUARD INTERLOCK OPEN != MACHINE PHYSICALLY ISOLATED FOR COVERED SERVICE**, **SAFETY PLC/RELAY OUTPUT OFF != ENERGY-ISOLATING DEVICE OPEN/LOCKED**, **LOCK/TAG APPLIED != STORED ENERGY RENDERED SAFE != ISOLATION VERIFIED**, and **ISOLATION VERIFIED != MACHINE READY FOR PRODUCTION**. For OpenPressBrake, normal LinuxCNC/HAL/FPGA state must not be promoted to maintenance-isolation authority merely because it can command outputs off.

Newest primary hydraulic study remains `safety-course/CINCINNATI_AUTOFORM_COUNTERBALANCE_DRIFT_FAULT_LOCALIZATION_AND_RECHECK_TRACE_2026-09-20.md`. Cincinnati AUTOFORM evidence closes named counterbalance pressure setting, repeated-cycle/both-side recheck, and physical drift fault localization, but still does not expose a post-replacement static retaining acceptance test. Freeze: **RAM DRIFT OBSERVED != COUNTERBALANCE VALVE FAILED**, **FAULT FOLLOWS SWAPPED COMPONENT != REPLACEMENT COMPONENT POST-SERVICE FUNCTION PROVED**, **COUNTERBALANCE PRESSURE CORRECT != RAM STATICALLY RETAINED UNDER A DEFINED ACCEPTANCE LOAD/TIME**. This source path is now branch-locally source-limited unless genuinely new OEM/manifold evidence appears.

Operating-mode/reset evidence remains in `safety-course/OPERATING_MODE_TRANSITION_COMMISSIONING_AND_STALE_COMMAND_WITNESS_STUDY_2026-09-20.md` and `safety-course/RESET_RESTART_COLD_START_AND_STALE_COMMAND_AUTHORITY_STUDY_2026-09-19.md`: safety reset/readiness and fresh ordinary START remain separate authorities; retained LinuxCNC/HAL/HMI/FPGA state must not silently become a fresh motion command after safety recovery or power restoration.

Two-hand/physical-stop evidence remains in `safety-course/PRESS_BRAKE_TWO_HAND_TOTAL_RESPONSE_AND_STOPPING_MONITOR_AUTHORITY_TRACE_2026-09-20.md` and `safety-course/HYDRAULIC_PRESS_BRAKE_TWO_HAND_CONTROL_PHYSICAL_STOP_AUTHORITY_TRACE_2026-09-19.md`: evaluator response, control-system response, final-element response, physical ram stop, stopping-monitor allowance, and validated safety distance are distinct witnesses.

Holding-valve evidence remains bounded by `safety-course/HOLDING_VALVE_BENCH_PROOF_VS_MACHINE_RETENTION_REVALIDATION_BOUNDARY_STUDY_2026-09-19.md`, `safety-course/HOLDING_VALVE_COMPONENT_PROOF_VS_INSTALLED_DRIFT_WITNESS_STUDY_2026-09-19.md`, and `safety-course/CINCINNATI_FM_VALVE_SERVICE_AND_POST_SERVICE_EVIDENCE_BOUNDARY_2026-09-19.md`. Individual component setting/reset, installed drift, dynamic stopping performance, safety rearm, and fresh production start must not be collapsed into one pass.

Personnel-retention freeze: **ACCESS CLEAR != PERSONNEL CLEAR != RETAINED-PERSON LIST EMPTY != BLIND AREA CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.**

Gravity-axis proof freeze: **BRAKE TEST REQUEST != TEST TORQUE APPLIED != BRAKE HELD TEST TORQUE != LOAD PHYSICALLY RETAINED != TEST PASS != PRODUCTION AUTHORITY.**

Guard-locking freeze: **GUARD CLOSED != GUARD LOCKED != HAZARD CEASED != UNLOCK AUTHORIZED != PERSONNEL CLEAR != RESTART AUTHORIZED.**

Safety-network replacement freeze: **IP/NODE ADDRESS CORRECT != SAFETY DEVICE IDENTITY CORRECT != CONFIGURATION OWNERSHIP CORRECT != SAFETY CONFIGURATION VERIFIED != SAFETY CONNECTION RESTORED != FUNCTIONAL SAFETY REVALIDATED != HAZARDOUS-MOTION AUTHORITY != FRESH ORDINARY START.**

Hydraulic stop-proof freeze: **PROTECTIVE-DEVICE DEMAND != SAFETY OUTPUT CHANGED != HYDRAULIC FINAL ELEMENT REACHED SAFE POSITION != RAM STOPPED/RETRACTED AS REQUIRED != MEASURED STOP PERFORMANCE VALID != ACCESS SAFE.**

Replacement/revalidation freeze: **SAFETY-RELATED COMPONENT REPLACED != MACHINE SAFE TO RETURN TO SERVICE.** Machine-level revalidation does not itself establish an unmasked individual holding-valve load-retention proof.

Home-shop maintenance rule: before work, remove/isolate/discharge/block/restrain or otherwise control the hazards relevant to the task. Never leave an unsafe/incomplete/bypassed machine unattended without unmistakable OUT OF SERVICE / DO NOT OPERATE tag-out or equivalent status. Tag-out communicates/preserves the state; it is not a substitute for physical hazard control.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Treat the press-brake holding/counterbalance-valve post-replacement chain as source-limited unless a genuinely new OEM/manifold source appears; do not spend whole sessions rereading the same Cincinnati/BAYKAL/Lazer Safe/Rockford evidence.
2. Continue the maintenance branch into **controlled-energy diagnostic/commissioning work vs fully isolated maintenance**. Find professional examples where energy must remain present for a measurement/test and trace the compensating safeguards: restricted operating mode, enabling device/hold-to-run, reduced speed/force, physical exclusion, independent restraint, test point design, or other documented measures.
3. Keep task-specific energy maps explicit. A press-brake ram block may control gravity motion without proving electrical/hydraulic isolation; a disconnect may isolate electrical input without proving trapped hydraulic/gravity energy safe.
4. Preserve return-to-service separation: isolation removal != safeguards restored/revalidated != personnel clear != safety rearm != fresh production start.
5. Continue two-hand and two-retaining-element traces when genuinely new implementation evidence is available; do not invent degraded production after a failed redundant element.
6. Resume routine 4000 controller-board work only when it directly supports the safety checkpoint or the safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
