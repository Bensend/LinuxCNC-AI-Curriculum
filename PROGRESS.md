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

Current safety emphasis: commissioning/validation includes common-cause and latent-failure analysis, a qualitative minimum-safe-to-operate gate, mode/feedback integrity, physical final-element proof, personnel-retention/restart-prevention for bodily-entry hazards, gravity-axis retaining-function proof/recovery, guard-locking/escape-release authority, safety-network identity/recommissioning authority, physical stop-performance validation, individual hydraulic final-element disagreement/inhibit behavior, post-replacement machine-level safety revalidation, explicit separation between switching-state evidence and physical hydraulic/motion witnesses, reset/restart/cold-start authority that rejects stale ordinary motion commands, and two-hand-control physical stopping/safety-distance authority.

Newest cross-cutting study: `safety-course/PRESS_BRAKE_TWO_HAND_TOTAL_RESPONSE_AND_STOPPING_MONITOR_AUTHORITY_TRACE_2026-09-20.md`. Rockford Systems RHPS hydraulic press-brake documentation adds implementation detail to the IRSST two-hand study: safety-distance validation can require separate two-hand/interface response, control-system response, final-control-element-to-physical-stop response, and stopping-performance-monitor allowance. It directs stop-time measurement toward the downstroke point producing the longest stopping time and requires distance revalidation when stopping performance worsens. Freeze: **TWO-HAND EVALUATOR RESPONSE != CONTROL-SYSTEM RESPONSE != FINAL CONTROL-ELEMENT RESPONSE != PHYSICAL RAM STOPPING RESPONSE != STOPPING-MONITOR ALLOWANCE** and **COMMAND TO STOP != FINAL CONTROL ELEMENT DE-ENERGIZED != RAM PHYSICALLY STOPPED**. Repeated reset is not a production workaround for a persistent safety-related fault.

Prior two-hand study: `safety-course/HYDRAULIC_PRESS_BRAKE_TWO_HAND_CONTROL_PHYSICAL_STOP_AUTHORITY_TRACE_2026-09-19.md`. IRSST hydraulic press-brake evidence ties two-hand safeguarding to reliable/repeatable physical ram stopping time and safety distance, and documents a real two-stage sequence where two-hand approach stops near the sheet before pedal-controlled bending. Freeze: **TWO-HAND INPUTS VALID != SAFETY DISTANCE VALID != STOPPING TIME RELIABLE/REPEATABLE != PHYSICAL RAM STOP PROVED != OPERATOR PROTECTED** and **BUTTON SIMULTANEITY PASS != HYDRAULIC FINAL ELEMENT RESPONDED != RAM STOPPED WITHIN THE ASSUMED ENVELOPE**. OpenPressBrake station geometry, stopping time, measurement method and safeguarding choice remain UNKNOWN.

Newest reset/restart study: `safety-course/RESET_RESTART_COLD_START_AND_STALE_COMMAND_AUTHORITY_STUDY_2026-09-19.md`. SICK, Pilz, and Rockwell evidence separates clearing a safety demand, intentional safety reset, safety-function readiness, and a subsequent intentional START. Rockwell safe-motion documentation additionally exposes cold-start behavior as a distinct restart-policy decision. Freeze: **HAZARD DEMAND CLEARED != SAFETY RESET PERMITTED != SAFETY RESET COMPLETED != SAFETY FUNCTION READY != ORDINARY START REQUEST FRESH != HAZARDOUS MOTION AUTHORIZED** and **POWER RESTORED != COLD-START SAFETY RESET SATISFIED != ORDINARY CONTROL STATE TRUSTWORTHY != STALE START ABSENT != PRODUCTION AUTHORITY**. LinuxCNC/normal FPGA/HMI state must not silently become fresh motion authority when safety is restored.

Newest primary-lane hydraulic studies remain `safety-course/HOLDING_VALVE_BENCH_PROOF_VS_MACHINE_RETENTION_REVALIDATION_BOUNDARY_STUDY_2026-09-19.md` and `safety-course/HOLDING_VALVE_COMPONENT_PROOF_VS_INSTALLED_DRIFT_WITNESS_STUDY_2026-09-19.md`. Terex Utilities professional service evidence separates individual holding-valve setting/reset verification from installed cylinder drift testing. These are not press-brake procedures and are not OpenPressBrake acceptance criteria. Freeze: **LOAD PHYSICALLY SUPPORTED FOR VALVE REMOVAL != INDIVIDUAL VALVE SETTING/RESET PASS != INSTALLED CYLINDER/LOAD DRIFT PASS != DYNAMIC STOPPING PERFORMANCE PASS != SAFETY REARM != FRESH PRODUCTION START** and **INSTALLED DRIFT FAIL != FAILED COMPONENT IDENTIFIED**.

Prior primary-lane study: `safety-course/CINCINNATI_FM_VALVE_SERVICE_AND_POST_SERVICE_EVIDENCE_BOUNDARY_2026-09-19.md`. CINCINNATI requires the ram physically blocked and electrical isolation before valve service, but accessible material does not expose the desired post-replacement retaining challenge. Freeze: **RAM BLOCKED FOR VALVE SERVICE != SERVICED VALVE RETAINING FUNCTION PROVED != STOPPING PERFORMANCE PROVED != SAFETY REARM != PRODUCTION AUTHORITY**.

Prior BAYKAL evidence requires recurring stop-time control and provides a measurement connection point. Lazer Safe PCSS evidence separately monitors valve command/contact agreement and measures actual beam stopping performance. **VALVE COMMAND/MONITOR AGREEMENT != HYDRAULIC LOAD RETENTION PROVED != RAM PHYSICALLY STOPPED != STOPPING PERFORMANCE PROVED != PRODUCTION AUTHORITY.**

Personnel-retention freeze: **ACCESS CLEAR != PERSONNEL CLEAR != RETAINED-PERSON LIST EMPTY != BLIND AREA CLEAR != SAFETY RELEASE != FINAL-ELEMENT PROOF != ORDINARY START AUTHORITY.**

Gravity-axis proof freeze: **BRAKE TEST REQUEST != TEST TORQUE APPLIED != BRAKE HELD TEST TORQUE != LOAD PHYSICALLY RETAINED != TEST PASS != PRODUCTION AUTHORITY.**

Guard-locking freeze: **GUARD CLOSED != GUARD LOCKED != HAZARD CEASED != UNLOCK AUTHORIZED != PERSONNEL CLEAR != RESTART AUTHORIZED.**

Safety-network replacement freeze: **IP/NODE ADDRESS CORRECT != SAFETY DEVICE IDENTITY CORRECT != CONFIGURATION OWNERSHIP CORRECT != SAFETY CONFIGURATION VERIFIED != SAFETY CONNECTION RESTORED != FUNCTIONAL SAFETY REVALIDATED != HAZARDOUS-MOTION AUTHORITY != FRESH ORDINARY START.**

Hydraulic stop-proof freeze: **PROTECTIVE-DEVICE DEMAND != SAFETY OUTPUT CHANGED != HYDRAULIC FINAL ELEMENT REACHED SAFE POSITION != RAM STOPPED/RETRACTED AS REQUIRED != MEASURED STOP PERFORMANCE VALID != ACCESS SAFE.**

Replacement/revalidation freeze: **SAFETY-RELATED COMPONENT REPLACED != MACHINE SAFE TO RETURN TO SERVICE.** Machine-level revalidation does not itself establish an unmasked individual holding-valve load-retention proof.

Field-device revalidation freeze: **REPLACEMENT DEVICE INSTALLED != FIELD WIRING VERIFIED != SAFETY FUNCTION REVALIDATED != PHYSICAL HAZARD SAFE != PRODUCTION AUTHORITY.**

Home-shop maintenance rule: before work, remove/isolate/discharge/block/restrain or otherwise control the hazards relevant to the task. Never leave an unsafe/incomplete/bypassed machine unattended without unmistakable OUT OF SERVICE / DO NOT OPERATE tag-out or equivalent status. Tag-out communicates/preserves the state; it is not a substitute for physical hazard control.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Continue authoritative press-brake OEM/manifold service tracing for `specific holding/safety valve service/replacement -> individual retaining-function challenge without companion masking -> physical ram/load witness -> pass/fail disposition -> dynamic stopping-performance re-proof where applicable -> safety reset/rearm -> press-brake-specific production initiation`.
2. Prefer a machine/OEM service source that names the retaining/safety valve and states its post-service functional test. The missing bridge remains press-brake-specific post-reassembly proof.
3. Determine whether replacement of a monitored holding/safety valve requires that machine's stopping/start-up test and/or a separate static load-retention proof.
4. Continue two-hand implementation tracing from the now-established total-response chain toward a complete press example: `operator station(s) -> dual-channel evaluator -> simultaneity/anti-tiedown -> safety/control response -> actual final hydraulic element -> physical ram stop at documented worst-case point -> measured total stopping response -> stopping-monitor allowance -> validated safety distance -> both-controls-released requalification -> separate fresh production initiation`. Preserve the distinction between logic, final-element state and physical stop witnesses.
5. Trace two-retaining-element failure beyond the test itself: after A PASS / B FAIL, identify documented physical load-safe disposition and whether/when A must be re-proved after B service. Do not invent degraded production.
6. If hydraulic/two-hand source paths reach information-gain stops, continue reset/restart commissioning architecture: stale ordinary START challenge, safety-controller/power restoration, mode transition, and proof that safety reset cannot resurrect retained LinuxCNC/FPGA/HMI motion authority.
7. Resume routine 4000 controller-board work only when it directly supports this safety checkpoint or the safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.
