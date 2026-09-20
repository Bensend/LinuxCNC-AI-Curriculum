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

Newest stopping-performance configuration evidence: `safety-course/PRESS_STOPPING_PERFORMANCE_WORST_CASE_MEASUREMENT_AND_SAFEGUARD_CONFIGURATION_AUTHORITY_2026-09-20.md` uses OSHA press-safety evidence to show that a quantitative stop result is evidence for the tested physical machine condition, not an abstract controller property. Mechanical-press PSDI guidance explicitly couples stop measurement to relevant machine conditions (including planned upper-die load/counterbalance state) and to the longest relevant measured stopping behavior; safeguard geometry remains coupled to current stopping performance. Freeze: **STOP-TIME NUMBER RECORDED != STOPPING PERFORMANCE VALID FOR EVERY MACHINE CONFIGURATION**, **ONE FAVORABLE STOP TEST != WORST-CASE RELEVANT STOPPING PERFORMANCE ESTABLISHED**, and **STOPPING PERFORMANCE ACCEPTED != INSTALLED SAFEGUARD GEOMETRY VERIFIED**. Do not copy mechanical-press numerical rules into OpenPressBrake; its hydraulic test conditions and limits remain UNKNOWN pending machine-specific design and validation.

Newest post-change revalidation evidence: `safety-course/SINAMICS_COMPONENT_REPLACEMENT_REVALIDATION_SCOPE_AND_PHYSICAL_WITNESS_MATRIX_2026-09-20.md` applies the four-class validation scaffold to concrete Siemens component-replacement procedures. Siemens requires affected-drive function testing before danger-zone reentry/resumed operation after relevant replacement; S210/G220 procedures use bidirectional physical motion to recheck actual-value/direction sensing, and the G220 OM-SMT replacement procedure deliberately tests short-circuit and wire-break faults. Current SINUMERIK replacement tables scope acceptance portions to the changed dependency. Freeze: **COMPONENT REPLACED != SAFE STATE PROVED != DANGER-ZONE REENTRY AUTHORIZED != OPERATION RESUMED**, **CONFIGURATION RESTORED != ACTUAL-VALUE/DIRECTION MAPPING PHYSICALLY PROVED**, and **NORMAL FUNCTION PASSED != REQUIRED WIRING/FAULT DIAGNOSTICS REVALIDATED**. A reduced drive acceptance test does not prove unrelated machine safeguards, hydraulic/mechanical hazard paths, or fresh ordinary START authority.

Newest validation-lifecycle evidence: `safety-course/ROCKWELL_ENABLING_SWITCH_FAULT_INJECTION_AND_FUNCTIONAL_PROOF_TEST_LIFECYCLE_2026-09-20.md` adds a manufacturer-directed abnormal-operation validation sequence. Rockwell SAFETY-AT055 deliberately shorts an enabling-switch safety channel while jogging and separately removes the safety-I/O network connection; expected behavior includes physical contactor de-energization, diagnostics, and inability to reset/restart with the fault. Freeze: **NORMAL FUNCTION TEST PASSED != REPRESENTATIVE FAULT RESPONSE VALIDATED**, **SAFETY PROGRAM OUTPUT OFF != EXTERNAL CONTACTORS PHYSICALLY DE-ENERGIZED**, and **FAULT DIAGNOSTIC VISIBLE != RESET/RESTART AUTHORIZED**. Rockwell proof-test guidance also establishes that controller, safety-I/O, sensor and actuator proof-test obligations can differ; never copy a manufacturer example interval into OpenPressBrake without architecture-specific justification.

Newest reusable curriculum scaffold: `safety-course/SAFETY_VALIDATION_EVIDENCE_CLASS_AND_RETURN_TO_SERVICE_MATRIX_2026-09-20.md` separates four evidence classes: (A) normal-demand functional test, (B) deliberate abnormal-operation/fault-injection test, (C) quantitative physical performance test, and (D) periodic functional/proof test. Freeze: **TESTED != VALIDATED unless the evidence class and acceptance criterion are named**, **HAPPY-PATH PASS != FAULT RESPONSE VALIDATED**, **FAULT-INJECTION PASS != PHYSICAL PERFORMANCE ACCEPTED**, and **PHYSICAL PERFORMANCE PASS != PERIODIC PROOF-TEST PROGRAM DEFINED**. Return-to-service must identify which evidence classes a change invalidated, repeat affected tests after repair, restore/requalify safeguards, and still require a separate fresh ordinary start.

Additional durable safety-course evidence remains under `safety-course/`; preserve prior freezes for setup/enabling authority, stale-start rejection, protective-field commissioning, hydraulic witness boundaries, gravity-axis brake proof, EDM/final-element feedback, controlled-energy diagnostics, maintenance isolation, guard locking, personnel retention and safety-network replacement.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Find a modern machine/OEM partial-acceptance or post-maintenance matrix that scopes revalidation by the affected safety function and includes physical hydraulic/mechanical final elements or safeguard geometry. Prefer press/press-brake or another high-energy machine.
2. Preserve the new distinction between a stop-test number and the physical machine configuration that the result actually validates. Do not invent OpenPressBrake worst-case hydraulic test conditions.
3. Use the four-class matrix plus modification-impact rules to distinguish what a particular change invalidates. Do not require all four evidence classes mechanically when the change cannot affect them, but never substitute checksum/configuration identity for a required physical witness.
4. Reopen hydraulic final-element work only for genuinely new OEM/manifold evidence combining monitored position with pressure/motion witness, quantitative acceptance, mismatch fault and return-to-service.
5. Treat generic drive replacement, EDM/STO/brake/status-bit, scanner, safety-input, reset/restart and enabling-device cataloging as information-gain limited.
6. Preserve energized-diagnostic authority, physical final-element proof, fault-injection validation, periodic proof testing, safeguard requalification and return-to-service as separate evidence layers.
7. Do not copy proof-test intervals, PL/SIL, stopping limits, hydraulic thresholds, mechanical-press formulas/test states or diagnostic coverage from examples into OpenPressBrake without design-specific authority.
8. Resume routine controller-board work only when it directly supports the safety checkpoint or safety priority reaches a genuine information-gain stop.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.