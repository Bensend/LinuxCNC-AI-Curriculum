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

Current safety emphasis includes independent safety authority; physical final-element proof; process-response evidence; maintenance/return-to-service; reset/restart freshness; operating-mode commissioning; energized diagnostic authority; safe reduced-speed commissioning; human-factors controls against bypass; proposition-specific revalidation after change; and composition-aware acceptance scope when multiple changes overlap.

Newest composition method: `safety-course/25E0_MULTI_CHANGE_COMPOSITION_ACCEPTANCE_SCOPE_2026-09-22.md`. Siemens SINUMERIK/S120 acceptance methodology establishes that reduced/partial acceptance scope is derived from acceptance-test objects and logical groups after hardware/software/function changes; it is not justified merely by calling a change minor. Pilz independently documents validation depth as application/change dependent. The curriculum now requires taking the union of stale propositions from simultaneous changes and explicitly checking their interfaces. If changed items participate in the same guard/stop/access/retaining/energy-isolation proposition, local component diagnostics do not close the composed function.

Stress tests cover guard-switch + safety-encoder replacement, pressure-witness + load-holding-element replacement, and safety-encoder + drive-dynamics change. Freeze **LOCAL TEST PASS + LOCAL TEST PASS != COMPOSED SAFETY FUNCTION REVALIDATED**, **CHANGE COUNT != ACCEPTANCE SCOPE**, and **PARTIAL ACCEPTANCE != ARBITRARILY SMALL ACCEPTANCE**.

Proposition-specific method retained: `safety-course/25E0_PROPOSITION_SPECIFIC_REVALIDATION_AFTER_CHANGE_2026-09-22.md`. The reusable chain remains `change -> stale proposition/evidence -> physical re-proof -> acceptance authority -> configuration record -> reset/rearm -> fresh ordinary demand`.

Newest machine-tool supported-exception trace retained: `safety-course/25E0_MACHINE_TOOL_SAFE_LIMITED_SPEED_ACCESS_AND_RETURN_2026-09-21.md`. Supported-exception/adversarial evidence remains in the 25E0 setup, muting/override, production-return, exception-authority and safeguard-defeat studies.

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
- **COMPONENT DIAGNOSTIC PASS != SAFETY FUNCTION VALIDATED.**
- **SAME CHECKSUM != SAME FIELD PHYSICS.**

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Turn the composition method into a learner-facing **acceptance-scope dependency matrix**: safety function/proposition × input witness × logic/configuration × final element × process witness × machine dynamics × safeguard/access assumption.
2. Trace one authoritative professional example where a change outside the nominal safety component itself changes acceptance evidence — preferably control dynamics, mechanics, safeguard geometry, or machine configuration — without generalizing vendor-specific tests.
3. Add an adversarial accumulated-change case: individually documented changes across several maintenance windows whose combined stale evidence crosses a safety-function boundary even though no single work order appears large.
4. Preserve machine-specific physics and UNKNOWN handling; do not invent hydraulic truth tables, safe speeds, stopping distances, PL/SIL targets, pressure thresholds or diagnostic coverage.
5. If this branch reaches an information-gain stop, rotate to the highest-value open 4000 safety module rather than routine board design or closed 3000 work.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and proposition-specific return-to-service methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.