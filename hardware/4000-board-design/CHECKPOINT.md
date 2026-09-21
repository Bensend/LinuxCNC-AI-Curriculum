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

BD01 establishes reusable-block versus board-specific connection-definition ownership. BD02 covers proven-reference selection, explicit deltas, calculations/derating, protection reasoning and resource declarations. BD03 switches to board integration with machine-I/O decomposition, typed resource budgeting, connection requirements and unresolved-resource ownership. BD04 returns to block engineering and teaches output authority, deterministic default/de-energized states, watchdog boundaries, power-domain loss, fault containment and evidence-based qualification. BD05 switches back to board integration and teaches source/load ownership, normal and fault-current return tracing, startup/inrush aggregation, return/chassis/PE/shield distinctions, partial-power/back-power analysis and release gates. BD06 returns to block engineering and teaches exact connectivity/BOM authority, fail-closed schematic-capture gates, board-specific connector binding, ERC limits, human review and revision provenance. BD07 returns to board integration and teaches single-owner whole-board semantic assembly, hidden-glue detection, canonical connection ownership, aggregate resource accounting, capture hierarchy and the distinction between semantic ownership and rendered-net proof.

## BD07 verified worked-example state

Every OpenPressBrake file assigned to students in BD07 was opened and inspected in current `main` form during this run.

### Whole-board ownership and validation

`VERIFIED_FOR_LESSON` for the specific architecture/validation claims used in BD07:

- `hardware/integration/REV1_FIELD_PIN_SEMANTIC_OWNERSHIP.yaml`
- `hardware/integration/REV1_FIELD_PIN_UNIQUENESS_VALIDATION.md`
- `hardware/connections/REV1_CONNECTION_COVERAGE_CHECKPOINT.md`
- `hardware/integration/REV1_SCHEMATIC_RELEASE_GATE_MATRIX.md`

The ownership index gives every currently instantiated machine-facing connector exactly one selected connection-definition owner and keeps unproven endpoints explicit. The newest validation contract requires a future rendered board to prove that ownership fail-closed rather than assuming repository-side semantics imply correct implementation. Review mirrors are explicitly excluded as alternate schematic-generation authorities.

Current OpenPressBrake evidence therefore supports:

`SEMANTIC OWNER DEFINED != RENDERED NET VERIFIED`

and

`REVIEW MIRROR != SECOND ELECTRICAL AUTHORITY`.

The generated full-board comparison is still pending; BD07 does not claim it has executed or passed.

### Bounded connection-block example

`hardware/connections/REV1_POWER_FEED_CONNECTIONS.yaml` is `VERIFIED_FOR_LESSON` as an intentionally incomplete board-specific connection-definition example. It explicitly maps the controller and sensor-field source/return semantics, functional ownership, prohibited joins, placement intent and silkscreen/marking intent while leaving exact connector manufacturer/family/MPN, footprint/pad mapping, conductor range, ampacity/current envelope and physical installation facts unresolved. Its own release fields remain `board_capture_ready: false`.

This is useful teaching material precisely because the unresolved physical facts are machine-readable gates rather than hidden assumptions.

## Catalog stress-test result

BD07 found that the newest OpenPressBrake integration direction directly addresses a major curriculum concern: duplicate connector authority and unwritten cross-board joins. The single machine-readable field-pin ownership index plus explicit rendered-net acceptance contract is a stronger architecture than allowing every connection artifact or review mirror to become an equal source.

The remaining gap is correctly exposed rather than papered over: the repository has semantic ownership before it has rendered-board proof. Full-board release therefore remains open.

BD07 freezes these integration rules:

- `EVERY CROSS-BLOCK EDGE HAS EXACTLY ONE BOARD-INTEGRATION OWNER`.
- `CONNECTION DEFINITION != REUSABLE PRIMITIVE INTERNAL CIRCUIT`.
- `MATCHING WIRE NUMBER != PROVEN COMMON NET`.
- `SAME NOMINAL VOLTAGE != SAME BOARD DOMAIN`.
- `RENDERER CHOOSES STRUCTURE FROM AUTHORITY; RENDERER DOES NOT DO ELECTRICAL ENGINEERING`.

No OpenPressBrake engineering files were changed. Current board-development work is actively advancing the same field-pin uniqueness lane, so curriculum work consumed the newest state read-only instead of racing it.

## Current repository reconciliation

OpenPressBrake `main` was re-read immediately before this checkpoint update and remained at `65399bf738ce84d3ffd38343e477a9d5392ec691` (`integration: define Rev1 field-pin uniqueness validation gate`). That commit adds the fail-closed validation contract BD07 uses and explicitly says rendered-schematic checking is pending.

LinuxCNC-AI-Curriculum `main` also advanced during the run from unrelated safety-course work. BD07 was created as a new independent file, then re-opened in current form before this checkpoint update. No overlapping board-curriculum file had been modified by another lane.

## Carried catalog defect from BD06

The BD06 digital-input manifest reconciliation defect remains open unless a later OpenPressBrake change closes it: current engineering/reference authority withdrew the old universal 500 pF / 6.5 pF parasitic release gate while the machine-readable manifest still carried legacy mandatory fields. Do not use that package as a finished capture example until current main is re-inspected and the contradiction is actually resolved.

## Next exact work

Build BD08 as a **BLOCK ENGINEERING** lesson on qualification evidence and verification matrices:

`requirement -> failure mode -> evidence needed -> analytical proof -> executable test when justified -> bench test -> machine verification -> release status -> regression trigger`

Select a candidate reusable block only after opening its current engineering contract, manifest, exact connectivity/BOM where applicable, calculations, verification artifacts and status checklist. Prefer a block that cleanly distinguishes datasheet/calculation/static-validation evidence from bench/machine evidence and still-open qualification gates.

The adversarial question is whether a student can tell exactly what has been proved, by what method, against which revision, and what design change invalidates that evidence. Treat vague statements such as “tested,” “protected,” “validated,” or “CI passes” as catalog defects unless the evidence package identifies the requirement, setup, acceptance criterion, result and revision applicability.

Do not run simulation or other compute merely to populate the lesson. If a concrete verification question genuinely requires executable work, use only `[self-hosted, openpressbrake]`; never use GitHub-hosted Actions.

## Compute

No simulation, synthesis, benchmark or executable verification was justified in BD07. No hosted compute was used.

## Safety boundary

BD07 concerns ordinary controller-board integration. The current OpenPressBrake ownership and validation contracts correctly allow the retained safety-enable boundary to be connected/observed without transferring personnel-safety authority to LinuxCNC or ordinary FPGA logic. The independent safety system remains authoritative unless a separately safety-rated design and validation proves otherwise.
