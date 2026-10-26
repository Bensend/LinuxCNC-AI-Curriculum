# 4400-CYCLE-01 — When a safety relay is ON, what has actually been checked?
**2026-10-26 | original manufacturer documentation | DOC-CONFIRMED only within exact device/edition | NON-GRADUATED**

## Question and novelty
Prior RST-01/EDM-01 already cover reset edges, external-device feedback, and unexpected restart. **Do not claim those mechanisms are newly discovered here.** The incremental evidence is an **on-state diagnostic limitation and periodic demand/inspection requirement**, a **start/feedback loop diagnostic caveat**, and an explicit **manufacturer-described subsystem boundary**. A green relay output is not a continuously proven physical stop path.

## Original sources actually inspected
1. **Pilz PNOZ s3**, *Operating Manual 21395-EN-19* (manufacturer original, 2025 edition): https://www.pilz.com/download/open/PNOZ_s3_Operat_Man_21395-EN-19.pdf . PDF pp. 8–10 (function description), 11–15 (configuration and wiring), 17–18 (operation/diagnostics), 23–24 (technical timing). Do not transfer statements to PNOZ s4, s30, other PNOZ s3 revisions, or a selected machine without matching the order code and edition.
2. **SICK**, *Safe Entry Exit – Flexi Soft*, 8021675/1BD4/2021-05-27: https://www.sick.com/media/docs/6/06/506/operating_instructions_safe_entry_exit_flexi_soft_variante_en_im0075506.pdf . PDF pp. 9–12: subsystem boundary and reset-button location/motion prohibition. This is a conveyor/robot-cell-oriented example, not a press-brake configuration.
3. **Prior repository evidence**, not a new finding: [Rockwell MSR142 reset-edge/power-return audit](4400_MSR142_RESET_EDGE_POWERUP_FEEDBACK_WIRING_SOURCE_AUDIT_2026-10-24.md); [Pilz s4/OMRON/SICK EDM audit](4400_PILZ_OMRON_SICK_EDM_RESET_EDGE_DEFAULT_CONFIG_AND_CONTACTOR_PROOF_AUDIT_2026-10-25.md); [EDM-01 learner module](../safety-course/4400_EDM_01_CONTACTOR_FEEDBACK_RESET_EDGE_AND_FRESH_MOTION_MODULE_2026-10-25.md).

## Exact evidence ledger
| ID | Class | Product-specific fact | Limitation / inference |
|---|---|---|---|
| C01 | DOC-CONFIRMED | PNOZ s3 p.17 **cannot automatically test the mechanical relay contact while its outputs are ON**; the manufacturer describes opening the safety contacts and starting the device so internal diagnostics can check correct opening. | **INFERENCE:** a long-energized output with green indication is not evidence that all dangerous contact failures have been continuously exercised/detected. |
| C02 | DOC-CONFIRMED | PNOZ s3 p.17 gives **conditional manufacturer check intervals**: at least monthly for its stated SIL 3/PL e use, yearly for its stated SIL 2/PL d use under its EU Machinery Directive context. | NOT a universal test frequency, selected-machine rating, or authorization to perform a live test. Duty-cycle, task, component and risk assessment must be reconciled by qualified design/validation. |
| C03 | DOC-CONFIRMED | PNOZ s3 pp.9–10 distinguishes automatic, simple manual, monitored falling-edge, monitored rising-edge, and startup-test modes. | Existing RST/EDM findings already establish this category; no new claim of generic button semantics. |
| C04 | DOC-CONFIRMED | PNOZ s3 p.10 warns the device does **not** recognize certain shorts/shorts across contacts in the combined **start/feedback loop**, recommending protected/separate routing or other suitable measures. | **UNKNOWN:** the precise boundary between this notice and the p.9 statements that monitored-start modes detect certain start-circuit shorts; do not silently interpret them as universal detection or universal non-detection. The actual loop wiring and fault coverage require product-specific review. |
| C05 | DOC-CONFIRMED | PNOZ s3 p.14 warns a bridged manual start contact can permit automatic activation on safeguard restoration. | The output restoring does not necessarily cause motion, but stale normal motion commands can make that a hazardous compound fault (**INFERENCE**). Already taught in EDM-01. |
| C06 | DOC-CONFIRMED | PNOZ s3 p.12 labels Y32 as an auxiliary semiconductor output and explicitly says it must not be used as a safety circuit. | HMI/diagnostic status is not physical stop/hold witness. |
| C07 | DOC-CONFIRMED | SICK Safe Entry Exit p.10 explicitly calls its sensors/controller a **subsystem**; complete safety functions require integration of sensors, control and actuators. | A certified component or application library does not validate final elements, load restraint, guard geometry or operator behavior. |
| C08 | DOC-CONFIRMED | SICK p.11 specifies reset outside the hazard with view of the danger zone and says reset activation must not initiate movement. | **INFERENCE:** separate physical safety rearm from fresh normal LinuxCNC/FPGA motion command, and provide usable clear status so operators do not bypass. |

## The unresolved wording tension (do not hide)
PNOZ s3 function description p.9 reports detection of some start-circuit shorts in monitored mode, while the p.10 NOTICE says shorts in the start/feedback loop are not recognized. These may refer to different fault paths, but the available prose alone does not establish the exact electrical partition. **UNKNOWN** until an exact terminal/fault path is mapped by qualified inspection or manufacturer clarification. Do not derive a diagnostic-coverage number from these two sentences.

## Failure-path reasoning (no live machine test)
- **Long idle energization:** internal contact-opening diagnostics may not have had a recent exercise. Ask for the actual device's required proof/check regimen and maintenance records, not a green LED.
- **Feedback bridged or miswired:** the controller may see a plausible state while a final element is not actually observed. Require exact contact identities, routing and manufacturer-defined feedback diagnostic coverage.
- **Safety output goes OFF, ram remains loaded:** electrical status does not prove hydraulic holding, mechanical restraint or zero residual energy.
- **Safety reset after outage:** a restored output is not fresh motion authorization; held pedal/queued cycle must not replay.
- **Operator avoids test because it disrupts production:** treat access to a safe, bounded qualified test and comprehensible status as a design requirement; do not bypass safeguards.

## Architecture boundary
Ordinary LinuxCNC/FPGA: production requests, UI and non-safety telemetry. Independent safety-related system: appropriate detection, logic, monitored outputs, reset/rearm. Physical final elements: verified drive/contactor/valve energy state, independent load retention and stored-energy isolation. Qualified physical validation: actual Y1/Y2 stop/hold and guards. **No ordinary software indication can be promoted into personnel-safety authority.**

## Evidence status and release
**SOURCE-CONFIRMED new LinuxCNC:** none. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none used. **DOC-CONFIRMED:** C01–C08 for exact manufacturer devices. **INFERENCE:** cross-system failure tree and usability response. **UNKNOWN:** OpenPressBrake safety relay/feedback wiring, exact safety function, periodic test requirements, hydraulic topology, Y1/Y2 physical witness, PL/SIL and independent evaluator outcome. G0/G1 HOLD; no personnel-exposed hazardous operation. Do not fabricate a test interval or run machine cycles to satisfy a paper study.

## Next discriminating evidence
Qualified restricted as-built G0 Stage A first; identify exact relay/controller, outputs, feedback contact identities, safety function and test instructions. Compare the manufacturer-specified diagnostic demand with actual operating/maintenance practice. Separately obtain physical ram stop/hold/isolation witness. If unavailable, this branch is at an information-gain stop; rotate to a different safety question rather than retesting invented circuits.
