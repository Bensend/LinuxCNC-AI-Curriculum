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

The repeatable safety-design methodology covers:

`machine/lifecycle boundary -> hazardous event -> risk-reduction hierarchy -> physical safe-state proposition -> safety-function/SRS derivation -> composition/allocation -> fault analysis/diagnostic design -> architecture/dependency/CCF allocation -> integrity-method selection/target allocation -> verification/validation/physical proof -> commissioning/release -> maintenance/change control/revalidation`

2520 through 25F0 external information-separated competency execution remain OPEN and branch-local; do not self-score or contaminate them. **2540–25F0** retain READY FOR EXTERNAL/FRESH EVALUATION state where their release gates say so.

**25F0 — Machine safety capstones** completed its learner-facing coverage audit on 2026-09-24. The mill/VMC baseline, lathe/turning-center delta, robot/automated-cell delta, press-brake capstone and narrow plasma/cutting safety transfer remain durable. 25F0 is READY FOR EXTERNAL/FRESH EVALUATION, not self-graduated.

**Whole-sequence integration and release:** `research/SAFETY_COURSE_WHOLE_SEQUENCE_INTEGRATION_AUDIT_2026-09-24.md` found no missing prerequisite or contradictory authority boundary. `safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md` is the cumulative 2520–25F0 engineering handoff. `research/SAFETY_COURSE_ROUTE_TO_TRACEABILITY_PACKAGE_AUDIT_2026-09-24.md` maps the routes to package fields and freezes route continuity/stale-evidence behavior. `research/SAFETY_COURSE_TOP_LEVEL_RELEASE_READINESS_AUDIT_2026-09-24.md` finds the sequence internally release-ready for information-separated evaluation, **not graduated** while external/fresh gates remain open.

The package now explicitly requires each module to consume current upstream IDs/provenance/status/UNKNOWNs, declare dependencies, preserve stale/residual state and run a stale-dependency check before handoff. Human-factor redesign, architecture change, machine-transfer assumption, requirement edit, boundary change or new energy/hazard can create a `CHG` event and invalidate downstream evidence until reviewed/revalidated.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **GUARD CLOSED != DANGEROUS STATE ENDED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**, **PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION**, **PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY**, **PUMP OFF != RAM/BEAM SAFE STATE PROVED**, **VALVE POSITION EXPECTED != RAM SAFE STATE PROVED**, **SERVO PUMP ZERO COMMAND != HYDRAULIC SAFETY FUNCTION PROVED**, and **LINUXCNC DISABLED != PLASMA POWER MAINTENANCE ISOLATION**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25F0 information-separated competency gates; do not self-score or expose evaluator-only expected answers before learner commitment.
2. Continue the highest-value unblocked safety-related 4000 branch: convert the independent-safety boundary into reusable interface contracts for the safety-input family, independent core safety controller, safety-output/final-element family and FPGA-to-safety interface.
3. Make each block/interface declare the Safety Design Package IDs it implements/observes (`SRS`, `PHY`, `AUTH`, `DEP`, `ARC`, `VAL`) and its authority boundary.
4. Build dependency/CCF and fail-safe-default requirements into those contracts before schematic implementation; keep normal LinuxCNC/FPGA command/diagnostic paths non-authoritative for personnel safety unless separately justified.
5. Preserve practical human factors: safe wiring, setup, replacement, diagnostics and guard restoration should be easier than bypass where practical.
6. Keep machine-specific hydraulic truth tables, valve fail states, stopping limits/distances, pressure thresholds, safe-speed values, process/fume/fire acceptance values, proof-test intervals and PL/SIL/integrity targets UNKNOWN until justified by machine/product/site evidence.
7. Freeze executable compute only if a concrete unresolved implementation question survives authoritative evidence; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-24T0536Z-safety-release-ready-interface-contracts-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.