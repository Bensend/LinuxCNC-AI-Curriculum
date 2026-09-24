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

`research/WORKED_SELECTED_SAFETY_CHAIN_QUALIFICATION_2026-09-24.md` applies that gate to an inspectable SICK deTec4 Core protective-device chain with external safety logic and positively guided downstream contactors/EDM, using Pilz PNOZ s4 only as separately fenced architecture evidence. It refuses to infer cross-vendor electrical compatibility.

`research/WORKED_COHERENT_SAFETY_CHAIN_ROCKWELL_2026-09-24.md` closes the next evidence question with a manufacturer-supported Rockwell 450L light-curtain -> 440C-CR30 -> 100S-C contactor/feedback application family. The published application allocates dual OSSD safety inputs, safety-output withdrawal, contactor coil control, mechanically linked auxiliary feedback and reset behavior. This resolves the existence/semantics question without creating a generic compatibility rule. It also freezes **MECHANICALLY LINKED CONTACTOR FEEDBACK != MACHINE SAFE STATE PROVED**. No bench lab is justified merely to rediscover this documented interface behavior.

`research/ROCKWELL_EXACT_CHAIN_FAULT_AND_STO_COMPARISON_2026-09-24.md` deepens that chain using Rockwell 100-TD013 / SUVA family evidence, attacks welded contactor, feedback open/short/plausible state, common 24 V/0 V loss/restoration, held reset and retained ordinary cycle-start, and compares contactor interruption against a Siemens drive-STO architecture. It freezes **FEEDBACK PLAUSIBLE != CONTACTOR MECHANISM PROVED**, **REDUNDANT CONTACTORS != INDEPENDENT ENERGY-REMOVAL CHANNELS**, and **FINAL-ELEMENT ARCHITECTURE DETERMINES THE LEGITIMATE WITNESS**. Exact selected 450L/100S-C/CR30 catalog/configuration, load and suppression details remain schematic-blocking rather than guessed.

`research/FINAL_ELEMENT_WITNESS_MATRIX_2026-09-24.md` now carries that distinction across redundant contactors, drive STO, monitored hydraulic valve enable/safe valve-drive shutdown and mechanical restraint. Fiessler AKAS-F + AKFH/AKFR provides inspectable valve-position/enable monitoring evidence; Bosch Rexroth independently separates servo-pump normal-motion authority from an end-position-monitored on/off-valve safety block; HAWE EV2D provides a third safe valve-drive architecture. The matrix freezes **NORMAL MOTION AUTHORITY != SAFETY FINAL-ELEMENT AUTHORITY** and keeps selected-machine hydraulic truth tables, trapped-energy behavior and physical safe-state witnesses explicitly UNKNOWN until justified.

Core freezes remain in force, especially: **VERIFIED DESIGN != VALIDATED MACHINE SAFETY FUNCTION**, **FAULT DETECTED != PHYSICAL SAFE STATE ACHIEVED**, **LOW COST != LOW RIGOR**, **EDM HEALTHY != PHYSICAL SAFE STATE PROVED**, **EDM SATISFIED != HAZARDOUS ENERGY ABSENT**, **MECHANICALLY LINKED CONTACTOR FEEDBACK != MACHINE SAFE STATE PROVED**, **FEEDBACK PLAUSIBLE != CONTACTOR MECHANISM PROVED**, **REDUNDANT CONTACTORS != INDEPENDENT ENERGY-REMOVAL CHANNELS**, **FINAL-ELEMENT ARCHITECTURE DETERMINES THE LEGITIMATE WITNESS**, **NORMAL MOTION AUTHORITY != SAFETY FINAL-ELEMENT AUTHORITY**, **SAFETY RELAY OUTPUT OFF != FINAL ENERGY PATH OPEN PROVED**, **DUAL CHANNEL INPUT != REDUNDANT FINAL ELEMENT**, **DUAL DRY CONTACT != CROSS-SHORT DETECTION**, **RESET ACCEPTED != HAZARDOUS MOTION COMMANDED**, **RESET INPUT ACTIVE != DELIBERATE RESET EVENT PROVED**, **RESET DEVICE ACCESSIBLE != SAFEGUARDED SPACE CLEAR PROVED**, **POWER RESTORED != REARM ELIGIBLE**, **PROTECTIVE FIELD CLEAR != RESTART AUTHORIZED**, **MATCHING COMMAND/FEEDBACK != INDEPENDENT PHYSICAL WITNESS**, **FINAL-ELEMENT FEEDBACK HEALTHY != COMMON DEPENDENCY ABSENT**, **STO ACTIVE != MOTOR STANDSTILL PROVED**, **STO ACTIVE != ELECTRICAL ISOLATION**, **SUPPLY ISOLATED != DOWNSTREAM PRESSURE EXHAUSTED**, **DUMP COMMANDED != PRESSURE SAFE PROVED**, **GUARD CLOSED != DANGEROUS STATE ENDED**, **COMPONENT PL/SIL CLAIM != MACHINE SAFETY FUNCTION PL/SIL CLAIM**, **ORDINARY LINUXCNC/FPGA DIAGNOSTICS != PERSONNEL-SAFETY AUTHORITY**, **FPGA INHIBIT ASSERTED != PHYSICAL SAFE STATE PROVED**, **PRODUCTION INTERLOCK != MAINTENANCE ENERGY ISOLATION**, **PERIMETER GATE CLOSED != SAFEGUARDED SPACE KNOWN EMPTY**, **PUMP OFF != RAM/BEAM SAFE STATE PROVED**, **VALVE POSITION EXPECTED != RAM SAFE STATE PROVED**, **SERVO PUMP ZERO COMMAND != HYDRAULIC SAFETY FUNCTION PROVED**, and **LINUXCNC DISABLED != PLASMA POWER MAINTENANCE ISOLATION**.

## 4000 foundation/core

Durable foundation includes `hardware/BLOCK_SPEC_TEMPLATE.md`, `hardware/4000-block-map.md`, Colorlight core research/copy-adapt contract, firmware/watchdog comparisons and LiteX-CNC output audit. Routine board development is secondary to the active safety course in this automation.

## Exact next work

1. Preserve the 2520–25F0 information-separated competency gates; do not self-score or expose evaluator-only expected answers before learner commitment.
2. Locate the actual safety-output implementation-spec template filename and reconcile the eight-field final-element witness contract from `FINAL_ELEMENT_WITNESS_MATRIX_2026-09-24.md` into it; update `SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md` if any field is absent.
3. Deepen one monitored hydraulic architecture only as far as authoritative public component/system documentation permits: valve-position target, enable authority, feedback dependency and residual hydraulic-energy boundary. Do not infer a press-brake hydraulic truth table.
4. Add an adversarial commissioning/proof-test case where valve feedback is healthy but beam motion/pressure evidence contradicts it; the physical proposition must win over controller status.
5. Connect the final-element witness matrix back into the cumulative Safety Design Package IDs (`SRS`, `PHY`, `AUTH`, `DEP`, `ARC`, `VAL`) so witness/residual-energy distinctions survive handoff and change control.
6. Freeze a bounded bench lab only if a concrete selected-interface uncertainty remains after documentation. If justified, use `[self-hosted, openpressbrake]` only; otherwise continue source/design work.
7. Keep generic safety schematics NOT FROZEN and machine-specific hydraulic truth tables, valve fail states, stopping limits/distances, pressure thresholds, safe-speed values, process/fume/fire acceptance values, proof-test intervals and PL/SIL/integrity targets UNKNOWN until justified.

Newest precise checkpoint: `checkpoints/2026-09-24T1241Z-safety-hydraulic-witness-next.md`.

## Laboratory compute checkpoint

`LAB_COMPUTE_LOG.md` remains authoritative. No simulation/build/test compute was consumed in this session. No GitHub-hosted runner was used.

## Global next-work rule

Continue safety-course professional implementation tracing and repeatable safety-design methodology. Prefer authoritative professional schematics, manufacturer safety documentation and standard engineering before simulation. Do not use GitHub-hosted runners for curriculum compute; when a concrete unresolved question justifies compute, target the self-hosted runner `[self-hosted, openpressbrake]` only.