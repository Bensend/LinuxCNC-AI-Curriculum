# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane is active alongside the safety curriculum. Durable lessons now present:

- `BD01_BLOCK_VS_CONNECTION_CONTRACT_AND_READINESS_AUDIT.md`
- `BD02_REFERENCE_TO_BLOCK_CONTRACT_CALCULATION_PROTECTION_AND_RESOURCES.md`
- `BD03_MACHINE_IO_TO_BOARD_RESOURCE_AND_CONNECTION_PLAN.md`
- `BD04_DEFAULT_STATE_OUTPUT_AUTHORITY_WATCHDOG_AND_FAULT_CONTAINMENT.md`
- `BD05_POWER_DOMAINS_RETURNS_PARTIAL_POWER_AND_FAULT_PATHS.md`
- `BD06_MACHINE_READABLE_CONNECTIVITY_AND_SCHEMATIC_CAPTURE_READINESS.md`
- `BD07_WHOLE_BOARD_ASSEMBLY_OWNERSHIP_AND_HIDDEN_GLUE_AUDIT.md`
- `BD08_QUALIFICATION_EVIDENCE_VERIFICATION_MATRIX_AND_REGRESSION_TRIGGERS.md`

BD08 returns to BLOCK ENGINEERING and teaches the evidence chain:

`requirement -> failure mode -> evidence needed -> analytical/manufacturer proof -> executable verification when justified -> bench test -> machine verification -> release status -> regression trigger`.

## BD08 verified worked-example state

Every OpenPressBrake file assigned to students in BD08 was opened and inspected in current `main` form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims made in BD08:

- `hardware/blocks/differential_encoder/engineering.yaml`
- `hardware/blocks/differential_encoder/manifest.yaml`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`
- `hardware/blocks/differential_encoder/design/REV1_PRODUCTION_CONNECTIVITY.md`
- `hardware/blocks/differential_encoder/design/PRODUCTION_BOM_REV1.yaml`
- `hardware/blocks/differential_encoder/design/REV1_RECEIVER_TIMING_CONTRACT.md`
- `hardware/blocks/differential_encoder/simulation/validate_production_receiver_rev1.py`
- `hardware/blocks/differential_encoder/simulation/rev1_datasheet_crosscheck.py`
- `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json`

The encoder package is suitable for teaching evidence boundaries because it contains exact static connectivity/BOM validation, manufacturer-derived timing limits, retained bounded simulation evidence, explicit FPGA semantic binding, named validation states, and recalculation triggers while still leaving real physical/integration gates open.

The current status explicitly leaves cable/reflection behavior, machine-selected termination, protected encoder field power, board-level ESD/surge and miswire/hot-plug qualification, schematic visual review, PCB integration, synthesis/place-route/timing, final cost, board release and human signoff open. BD08 therefore does not call the block `SCHEMATIC-READY`, fully qualified, or `REV 1 READY`.

## BD08 catalog stress-test result

The encoder package passes the teaching stress test better than many broad status labels because `engineering.yaml` already carries named validation items and recalculation triggers. The main granularity weakness is that `manifest.yaml` summarizes the block as `simulation-ready` while several independent evidence classes and release gates exist beneath that label. This is not treated as a contradiction because the status checklist explicitly bounds the term, but future catalog evolution should prefer machine-readable requirement/evidence/regression relationships over increasingly broad one-word maturity states.

BD08 freezes:

- `TEST RAN != REQUIREMENT PROVED`.
- `CI GREEN != BLOCK QUALIFIED`.
- `STATIC CONNECTIVITY PASS != PHYSICAL QUALIFICATION`.
- `DATASHEET DEVICE LIMIT != QUALIFIED SYSTEM LIMIT`.
- `MODEL PASS != OMITTED PHYSICS PASS`.
- `LOGICAL BINDING PASS != SYNTHESIS/P&R/TIMING PASS`.
- `REUSABLE BLOCK QUALIFICATION != INSTALLED MACHINE QUALIFICATION`.
- `EVIDENCE WITHOUT REVISION APPLICABILITY OR REGRESSION TRIGGER BECOMES STALE EVIDENCE`.
- `ORDINARY-CONTROL VERIFICATION != PERSONNEL-SAFETY AUTHORITY`.

No OpenPressBrake engineering file was changed. Current board-development work is actively advancing whole-board renderer/field-pin authority, so curriculum work remained read-only against that repository.

## Current repository reconciliation

Immediately before the BD08 curriculum write, OpenPressBrake `main` was `469b1c94635859cc3385c4916c522d9af82c3b1d` (`integration: bind Rev1 field-pin ownership into renderer contract`). It was re-read again after the lesson commit and remained unchanged. The differential-encoder path itself has not been modified by the current renderer work; its newest path-specific engineering overlay predates this run.

LinuxCNC-AI-Curriculum `main` had advanced independently through safety-course commits before BD08 was created. BD08 was added as a new file rather than overwriting another lane's work. This checkpoint was fetched again immediately before replacement so the update reconciles against current board-lane state.

## Carried catalog defect from BD06

The BD06 digital-input manifest reconciliation defect remains open unless a later OpenPressBrake change closes it: engineering/reference authority withdrew the old universal 500 pF / 6.5 pF parasitic release gate while the machine-readable manifest still carried legacy mandatory fields. Do not use that package as a finished capture example until current main is re-inspected and the contradiction is actually resolved.

## Next exact work

Build BD09 as a **BOARD INTEGRATION** lesson on staged board bring-up and commissioning evidence:

`pre-power inspection -> resistance/short checks -> current-limited staged power -> rail verification -> FPGA/config identity -> one interface at a time -> default/fault challenge -> LinuxCNC/HAL mapping -> machine connection -> commissioning/regression record`

Select a bounded controller slice only after opening every current student-facing artifact. Prefer a slice whose power source/return, reusable block, board-specific connection owner, FPGA binding, and open release gates can all be traced without implying that the full OpenPressBrake Rev1 controller is released.

BD09 must distinguish bench bring-up from qualification: successful first power is not surge/EMC/thermal qualification, successful FPGA communication is not routed timing proof unless the synthesis/P&R evidence exists, and a LinuxCNC/HAL signal changing is not proof of the field electrical state unless the physical witness supports that claim.

Do not run compute merely for demonstration. If a concrete unresolved synthesis, P&R, timing, simulation, or regression question genuinely requires executable work, use only `[self-hosted, openpressbrake]`; never use GitHub-hosted Actions.

## Compute

No simulation, synthesis, benchmark or executable verification was justified in BD08. Existing evidence was inspected; unchanged tests were not rerun. No hosted compute was used.

## Safety boundary

BD08 concerns evidence for ordinary controller-board functions. The encoder worked example explicitly has no personnel-safety credit. Verification quality does not transfer personnel-safety authority to LinuxCNC, FPGA logic, watchdogs, or ordinary diagnostics. Independent machine safety remains authoritative unless a separately safety-rated design and validation establishes otherwise.
