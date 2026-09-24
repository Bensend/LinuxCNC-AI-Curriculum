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

The package explicitly requires each module to consume current upstream IDs/provenance/status/UNKNOWNs, declare dependencies, preserve stale/residual state and run a stale-dependency check before handoff. Human-factor redesign, architecture change, machine-transfer assumption, requirement edit, boundary change or new energy/hazard can create a `CHG` event and invalidate downstream evidence until reviewed/revalidated.

**Reusable safety implementation contracts:** `hardware/SAFETY_BLOCK_INTERFACE_CONTRACTS.md` defines the safety-input family, independent core safety controller, safety-output/final-element family and FPGA-to-safety interface. `research/SAFETY_INPUT_AND_FPGA_INTERFACE_SOURCE_AUDIT_2026-09-24.md` source-audits `SI-DRY2`, `SI-OSSD2`, and the FPGA hard-inhibit/service boundary. Concrete implementation-spec templates now exist for `SI-DRY2`, `SI-OSSD2`, `FS-IF`, `SC-CORE`, and `SO` at `hardware/*_IMPLEMENTATION_SPEC_TEMPLATE.md`. They require selected-device evidence, exact diagnostic/reset ownership, explicit power/reset/configuration behavior, dependency/CCF records and physical-witness-aware validation rather than generic electrical assumptions.

`research/SAFETY_BLOCK_DEPENDENCY_CCF_REVIEW_2026-09-24.md` adversarially traces common 24 V/0 V, protection, connectors/cable, test-pulse sources, input resources, reset/configuration, service/debug paths, output/pilot supplies, feedback and mechanical dependencies. Generic family schematics remain NOT FROZEN until selected products/resources satisfy the templates.

`research/SAFETY_CORE_OUTPUT_SOURCE_AUDIT_2026-09-24.md` extends the source audit to `SC-CORE` and `SO`: reset/rearm semantics are product/architecture specific; EDM proves only supported external-device state; STO removes torque-generating capability but is not electrical isolation or proof of standstill; gravity/external-force loads require separately justified holding/safe-state propositions.

`research/SAFETY_RESTART_REARM_OUTPUT_WITNESS_AND_ARCHITECTURE_AUDIT_2026-09-24.md` adversarially checks held/stuck reset, reset visibility/occupancy, plausible-but-wrong feedback, gravity/external force, power loss/restoration, common output/pilot supplies and service transitions. `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md` is the learner-facing evidence gate between reusable template and schematic capture.

`research/WORKED_SELECTED_SAFETY_CHAIN_QUALIFICATION_2026-09-24.md` now applies that gate to an inspectable SICK deTec4 Core protective-device chain with external safety logic and positively guided downstream contactors/EDM, using Pilz PNOZ s4 only as a separately fenced external-logic/output architecture reference. The exercise deliberately refuses to assert cross-vendor electrical compatibility without exact selected-device evidence. It exposed two reusable evidence gaps now corrected in the worksheet: cross-product compatibility is a first-class schematic gate, and feedback must identify the physical/electrical target plus its relationship rather than only a signal name.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **EDM SATISFIED != HAZARDOUS ENERGY ABSENT**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **DUAL DRY CONTACT != CROSS-SHORT DETECTION**, **RESET ACCEPTED != HAZARDOUS MOTION COMMANDED**, **RESET INPUT ACTIVE != DELIBERATE RESET EVENT PROVED**, **RESET DEVICE ACCESSIBLE != SAFEGUARDED SPACE CLEAR PROVED**, **POWER RESTORED != REARM ELIGIBLE**, **PROTECTIVE FIELD CLEAR != RESTART AUTHORIZED**, **MATCHING COMMAND/FEEDBACK != INDEPENDENT PHYSICAL WITNESS**, **FINAL-ELEMENT FEEDBACK HEALTHY != COMMON DEPENDENCY ABSENT**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **GUARD CLOSED != DANGEROUS STATE ENDED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**, **FPGA INHIBIT ASSERTED != PHYSICAL SAFE STATE PROVED**, **PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION**, **PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY**, **PUMP OFF != RAM/BEAM SAFE STATE PROVED**, **VALVE POSITION EXPECTED != RAM SAFE STATE PROVED**, **SERVO PUMP ZERO COMMAND != HYDRAULIC SAFETY FUNCTION PROVED**, and **LINUXCNC DISABLED != PLASMA POWER MAINTENANCE ISOLATION**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25F0 information-separated competency gates; do not self-score or expose evaluator-only expected answers before learner commitment.
2. Deepen the worked selected-chain example with **current exact product interface evidence** for one coherent manufacturer-supported chain where possible. Prefer an application/manual pair that explicitly documents OSSD/input compatibility, reset/restart behavior, output/final-element wiring and EDM/feedback.
3. If a cross-vendor chain is retained, do not infer compatibility from nominal 24 V or signal names; require producer-output and receiver-input pulse/threshold/filter/current/reference evidence plus manufacturer restrictions.
4. Trace one selected final element far enough to state exactly what its feedback target/mechanical relationship proves and what hazardous-energy proposition still requires independent physical validation.
5. Use that evidence to decide whether a bounded bench lab would answer a concrete unresolved interface question. If authoritative documentation resolves it, do not run the lab. If a lab is justified, use `[self-hosted, openpressbrake]` only.
6. Keep generic safety schematics NOT FROZEN and machine-specific hydraulic truth tables, valve fail states, stopping limits/distances, pressure thresholds, safe-speed values, process/fume/fire acceptance values, proof-test intervals and PL/SIL/integrity targets UNKNOWN until justified.

Newest precise checkpoint: `checkpoints/2026-09-24T1049Z-safety-worked-chain-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.