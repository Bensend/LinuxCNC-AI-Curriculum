# 25E0 checkpoint — validation record and machine-physics stress test

Date: 2026-09-21

## Durable progress

- Added `safety-course/25E0_SAFETY_FUNCTION_VALIDATION_RECORD_AND_ACCEPTANCE_MATRIX_2026-09-21.md`.
- Added `safety-course/25E0_VALIDATION_TEMPLATE_PHYSICS_STRESS_TEST_2026-09-21.md`.
- The reusable record now forces hazard/safe-state identity, authority/energy chain, proposition-to-witness mapping, timing endpoints, fault injection, reset/rearm and demand freshness, temporary commissioning-state clearance, human-factors defeat resistance, modification impact, and explicit safety-critical `UNKNOWN` handling.
- Stress-tested the method against two deliberately different physics families: a hydraulic/gravity-loaded vertical axis and a rotating spindle/table.
- Added DOC-CONFIRMED Rockwell safe-motion validation evidence: ArmorKinetix Safe Monitor Functions provides function-specific normal/abnormal validation checklists; SLS monitors motor/axis speed and can trigger application-specific STO/SS1/SS2 action. These semantics do not supply machine-specific thresholds.
- No executable compute was justified. No GitHub-hosted runner was used.

## New freezes

- `ENERGY REMOVED AT SOURCE != STORED PROCESS ENERGY SAFE`.
- `TORQUE REMOVED != ROTATION STOPPED`.
- `ROTATION STOPPED != RETAINING CAPABILITY PROVED`.
- `PRESSURE MEASURED SAFE AT ONE POINT != ALL HYDRAULIC VOLUMES SAFE`.
- `SAME VALIDATION TEMPLATE != SAME PHYSICAL ACCEPTANCE CRITERIA`.
- `GENERIC METHODOLOGY MAY BE REUSABLE; MACHINE PHYSICS MAY NOT BE ABSTRACTED AWAY`.
- `UNKNOWN != FAIL`, but a safety-critical UNKNOWN blocks the acceptance claim that depends on it.

## Exact next work

Advance 25E0 into **maintenance/bypass human-factors validation**. Trace professional safety-controller/commissioning implementations that expose explicit lifecycle semantics for bypass/override/force/service-key/simulated-witness states: who/what authorizes them, conspicuous indication, mode/access restrictions, timeout or bounded use where applicable, reset/restart interactions, prevention of automatic carryover into production, physical/configuration clearance, and required revalidation.

Prefer authoritative manufacturer safety manuals and inspectable professional architectures over generic warnings. Keep personnel-safety authority independent from LinuxCNC/ordinary FPGA logic. Do not invent universal timeout values or bypass algorithms.

If public sources do not expose a complete lifecycle, record the evidence boundary and rotate to another open safety module rather than synthesizing one.