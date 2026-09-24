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

**Reusable safety implementation contracts:** `hardware/SAFETY_BLOCK_INTERFACE_CONTRACTS.md` defines the safety-input family, independent core safety controller, safety-output/final-element family and FPGA-to-safety interface. `research/SAFETY_INPUT_AND_FPGA_INTERFACE_SOURCE_AUDIT_2026-09-24.md` source-audits `SI-DRY2`, `SI-OSSD2`, and the FPGA hard-inhibit/service boundary. Concrete implementation-spec templates now exist at `hardware/SI-DRY2_IMPLEMENTATION_SPEC_TEMPLATE.md`, `hardware/SI-OSSD2_IMPLEMENTATION_SPEC_TEMPLATE.md`, and `hardware/FS-IF_IMPLEMENTATION_SPEC_TEMPLATE.md`. They require selected-device evidence, exact discrepancy/diagnostic ownership, explicit reset/configuration behavior, dependency/CCF records and physical-witness-aware validation rather than generic 24 V or OSSD assumptions.

`research/SAFETY_BLOCK_DEPENDENCY_CCF_REVIEW_2026-09-24.md` adversarially traces common 24 V/0 V, protection, connectors/cable, test-pulse sources, input resources, reset/configuration, service/debug paths, output/pilot supplies, feedback and mechanical dependencies. Generic family schematics remain NOT FROZEN until selected products/resources satisfy the templates.

`research/SAFETY_CORE_OUTPUT_SOURCE_AUDIT_2026-09-24.md` extends the source audit to `SC-CORE` and `SO`: reset/rearm semantics are product/architecture specific; EDM proves only supported external-device state; STO removes torque-generating capability but is not electrical isolation or proof of standstill; gravity/external-force loads require separately justified holding/safe-state propositions. Each contract continues to require `SRS/PHY/AUTH/DEP/ARC/VAL` linkage, fail-safe defaults, dependency/CCF declaration, physical-witness discipline and explicit non-authority for ordinary LinuxCNC/FPGA paths. This is a curriculum engineering contract, not a machine-specific certified design.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **DUAL DRY CONTACT != CROSS-SHORT DETECTION**, **RESET ACCEPTED != HAZARDOUS MOTION COMMANDED**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **GUARD CLOSED != DANGEROUS STATE ENDED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**, **FPGA INHIBIT ASSERTED != PHYSICAL SAFE STATE PROVED**, **PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION**, **PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY**, **PUMP OFF != RAM/BEAM SAFE STATE PROVED**, **VALVE POSITION EXPECTED != RAM SAFE STATE PROVED**, **SERVO PUMP ZERO COMMAND != HYDRAULIC SAFETY FUNCTION PROVED**, and **LINUXCNC DISABLED != PLASMA POWER MAINTENANCE ISOLATION**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25F0 information-separated competency gates; do not self-score or expose evaluator-only expected answers before learner commitment.
2. Convert the `SC-CORE` source audit into a concrete implementation-spec template separating safety demand, reset request, reset accepted/rearm eligibility, permissive restoration and ordinary start/cycle request.
3. Create per-class `SO` implementation-spec templates for relay/contactor, drive STO, monitored valve/dump and brake/load-holding interfaces. Require exact product evidence and state explicitly what each feedback witness proves and does not prove.
4. Perform an adversarial restart/rearm/output-witness review covering stuck/held reset, reset location/visibility, plausible-but-wrong EDM/feedback, gravity/external force, power loss/restoration, common output/pilot supplies and service/maintenance transitions.
5. Keep generic safety schematics NOT FROZEN until selected-device/application evidence satisfies the implementation templates and dependency/CCF gates.
6. Keep safe wiring, diagnostics, replacement and guard restoration easier than bypass where practical.
7. Keep machine-specific hydraulic truth tables, valve fail states, stopping limits/distances, pressure thresholds, safe-speed values, process/fume/fire acceptance values, proof-test intervals and PL/SIL/integrity targets UNKNOWN until justified by machine/product/site evidence.
8. Freeze executable compute only if a concrete unresolved implementation question survives authoritative evidence; use `[self-hosted, openpressbrake]` only.

Newest precise checkpoint: `checkpoints/2026-09-24T0838Z-safety-core-output-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.