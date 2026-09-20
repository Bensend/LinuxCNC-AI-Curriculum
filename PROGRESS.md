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

Newest safety-input evidence: `safety-course/SAFETY_INPUT_MULTI_FAULT_SAFE_OUTPUT_AND_RESTART_DISPOSITION_STUDY_2026-09-20.md` closes the bounded Lane-B search with current Rockwell and SICK manufacturer evidence for multiple field-fault classes, safe-output disposition, repair/reset semantics, cold-start device testing, and restart separation. Freeze: **FAULT PHYSICALLY REMOVED != FAULT LATCH CLEARED != REQUIRED DEVICE TEST/CYCLE COMPLETE != MANUAL RESET COMPLETE != OUTPUT REAUTHORIZED**, and **RESET SIGNAL PRESENT != VALID RESET EDGE != FAULT REPAIRED != SAFE RESTART**. Generic safety-input fault-table searching is now information-gain limited unless materially new physical validation/masking evidence appears.

Newest final-element evidence: `safety-course/EXTERNAL_DEVICE_MONITORING_WELDED_CONTACTOR_PHYSICAL_FEEDBACK_STUDY_2026-09-20.md` traces Rockwell and Pilz EDM/feedback-loop architectures. External contactor feedback is checked before restart so a welded/non-deenergized switching element can inhibit restart or force lockout. Freeze: **SAFETY OUTPUT COMMANDED OFF != EXTERNAL CONTACTOR DE-ENERGIZED**, **CONTACTOR COIL DE-ENERGIZED != POWER CONTACTS PHYSICALLY OPEN**, **RESET REQUESTED != EDM HEALTHY != RESTART AUTHORIZED**, and **EDM FEEDBACK CLOSED != ALL HAZARDOUS ENERGY REMOVED**.

Newest hydraulic controlled-energy study: `safety-course/CINCINNATI_AUTOFORM_ENERGIZED_COUNTERBALANCE_PRESSURE_COMMISSIONING_AUTHORITY_TRACE_2026-09-20.md`. The Cincinnati AUTOFORM OEM procedure explicitly performs an energized counterbalance-pressure check/adjustment with no dies installed, a narrowed operator-control configuration, main drive energized, a prescribed cycle, physical pressure-gauge witness while the ram moves down, valve adjustment, multiple subsequent cycles, bilateral pressure recheck, and a motor/pump-OFF endpoint before gauge removal. The same maintenance section separately requires ram blocking, power OFF, and locked disconnect when the manifold valves themselves are serviced/removed. Freeze: **SAME HYDRAULIC SYSTEM != SAME ENERGY-CONTROL METHOD FOR EVERY TASK**, **HYDRAULIC ENERGY PRESENT != ALL ORDINARY OPERATOR STATIONS AUTHORIZED**, **CONTROL COMMAND ISSUED != TEST-PORT PRESSURE PHYSICALLY WITNESSED**, **ADJUSTMENT MADE != SETTING STABLE AFTER CYCLING != BOTH SIDES RECHECKED**, and **MEASUREMENT REQUIRES ENERGY != DISASSEMBLY MAY REMAIN ENERGIZED**.

Controlled-energy foundation: `safety-course/CONTROLLED_ENERGY_DIAGNOSTIC_AND_SETUP_MODE_AUTHORITY_TRACE_2026-09-20.md`. SICK, Rockwell, and Pilz professional examples show that legitimate setup/diagnostic work requiring energy does not mean "bypass safety": a special mode can suppress normal production authority while a task-specific safety function remains active.

Maintenance-isolation foundation: `safety-course/MAINTENANCE_ENERGY_ISOLATION_VS_CONTROL_SAFETY_AUTHORITY_TRACE_2026-09-20.md`. OSHA hazardous-energy and press slide-lock guidance establishes that control circuitry/interlocks are not, by themselves, energy-isolating devices for covered servicing; stored/residual energy must be controlled and isolation verified.

Primary post-replacement hydraulic source path remains branch-locally source-limited. `safety-course/CINCINNATI_AUTOFORM_COUNTERBALANCE_DRIFT_FAULT_LOCALIZATION_AND_RECHECK_TRACE_2026-09-20.md` closes named counterbalance pressure setting, repeated-cycle/both-side recheck, and physical drift fault localization, but still does not expose a post-replacement static retaining acceptance test.

Operating-mode/reset evidence remains in `safety-course/OPERATING_MODE_TRANSITION_COMMISSIONING_AND_STALE_COMMAND_WITNESS_STUDY_2026-09-20.md` and `safety-course/RESET_RESTART_COLD_START_AND_STALE_COMMAND_AUTHORITY_STUDY_2026-09-19.md`: safety reset/readiness and fresh ordinary START remain separate authorities.

Two-hand/physical-stop evidence remains in `safety-course/PRESS_BRAKE_TWO_HAND_TOTAL_RESPONSE_AND_STOPPING_MONITOR_AUTHORITY_TRACE_2026-09-20.md` and `safety-course/HYDRAULIC_PRESS_BRAKE_TWO_HAND_CONTROL_PHYSICAL_STOP_AUTHORITY_TRACE_2026-09-19.md`: evaluator response, control-system response, final-element response, physical ram stop, stopping-monitor allowance, and validated safety distance are distinct witnesses.

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

1. Extend the final-element proof lane beyond electrical contactor EDM: compare manufacturer evidence for drive STO/status feedback and hydraulic valve/spool monitoring. For each witness, state exactly what physical fact it proves and what remains unproved. Prefer architectures where failed feedback inhibits restart.
2. Treat generic safety-input fault-table searching as information-gain limited; reopen only for materially different physical validation or masking evidence.
3. Treat the post-replacement holding/counterbalance-valve static-retention chain as source-limited unless a genuinely new OEM/manifold source appears.
4. Preserve the reusable energized-diagnostic authority contract: exact task, remaining hazards, physical configuration, selected control authority, permitted actuation, physical witness, abort behavior, masking control, acceptance criterion, and exit/requalification.
5. Preserve return-to-service separation: diagnostic complete != personnel clear != safeguards restored/revalidated != safety reset/rearm != fresh production start.
6. Resume routine 4000 controller-board work only when it directly supports the safety checkpoint or the safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
