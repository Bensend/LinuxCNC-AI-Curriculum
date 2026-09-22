# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane remains active alongside the safety curriculum. Durable lessons BD01 through BD21 are present. This checkpoint is board-design authority only and does not alter the separate safety-course progress authority.

New this run:

- `BD21_ADAPTER_INTERFACE_BLOCK_SELECTION_AND_QUALIFICATION_DURING_BOARD_COMPOSITION.md`

BD21 teaches the mandatory composition classification:

`DIRECT_INTEGRATION | BLOCK_CONTRACT_DEFECT | ADAPTER_REQUIRED | BOARD_INTEGRATION_MAPPING | UNRESOLVED`

The central adversarial requirement is that a real electrical transformation cannot be hidden in board integration, while ordinary pin/net/connector mapping cannot be promoted into a fake reusable electrical block.

## BD21 hard student-material audit

Every repository file named to students by BD21 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`

The newly created BD21 lesson was re-opened from current main after commit and checked for internal consistency.

Readiness remains claim-scoped. No artifact in this lesson establishes production readiness of the complete OpenPressBrake controller.

## Rules frozen by BD21

- `SAME SIGNAL NAME != COMPATIBLE INTERFACE CONTRACT`.
- `WORKS ON THIS BOARD != REUSABLE ARCHITECTURE`.
- `REAL TRANSFORMATION != BOARD WIRING`.
- `PIN MAPPING != ADAPTER`.
- `MISSING GENERIC CONTRACT FACT != BOARD-INTEGRATION DETAIL`.
- `ADAPTER QUALIFIED != NEIGHBORING BLOCKS ABSORBED`.
- `ORDINARY ADAPTER != PERSONNEL-SAFETY AUTHORITY`.
- Do not create a catalog block for a wire.

## Catalog stress-test result

The current mandatory OpenPressBrake adapter methodology is strong enough to support a student-facing decision procedure. It explicitly prevents board convenience from contaminating reusable primitives and requires genuine adapters to receive independent engineering/qualification.

BD21 turns that governance into a boundary record suitable for future machine-readable automation. Each boundary should eventually carry source/destination interface IDs and revisions, classification, compatibility evidence, selected adapter if applicable, board-mapping owner, unresolved blockers, machine-verification items, safety-authority class and invalidation triggers.

The next catalog pressure is therefore not another prose rule. It is structured interface compatibility data. A future configurator should be able to reject a newly incompatible block revision without relying on remembered schematic intent.

No OpenPressBrake engineering file was changed. Current OpenPressBrake main is actively closing shared ADC/DAC consumer integration, so the curriculum consumed current block governance read-only rather than racing active board work.

## Current repository reconciliation

At the start of the run, LinuxCNC-AI-Curriculum `main` was `db53e95781c8768215a2f45c0bc4d37861cbc3d5`.

Immediately before the BD21 checkpoint write, curriculum `main` was re-read at `479885a1883f82ccc67a1b3d28aa60f5281a5a3e`, the BD21 lesson commit. No overlapping board-design change was present.

Immediately before the checkpoint write, OpenPressBrake `main` was re-read at `38fc0bf6dd9029a6d8458a9b2e4a0a0b8a84be6f` (`shared_adc_dac: record Rev31 consumer closeout`). OpenPressBrake remained read-only.

## Next exact work

Build BD22 on **boundary-compatibility matrices and machine-readable interface matching**.

The lesson should test whether reusable contracts contain enough structured information to compare:

- direction/drive type;
- voltage/current envelope and thresholds;
- source/load impedance;
- reference/return domain;
- isolation/common-mode requirements;
- startup/reset/unpowered/partial-power behavior;
- timing/bandwidth/protocol semantics;
- protection/fault assumptions;
- power/resource dependencies;
- safety-authority classification.

Require fail-closed matching: missing required fields yield `UNRESOLVED`, not an inferred match. Keep board-specific connector molds outside reusable interface contracts except where connector/cable characteristics are genuinely part of the electrical envelope. Use current OpenPressBrake examples only after reopening every named artifact from current main.

## Compute

No simulation, synthesis, place-and-route, benchmark or executable verification was justified for BD21. The work is architecture ownership, interface-contract semantics and qualification methodology. Future executable work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD21 concerns ordinary controller composition and interface ownership. A qualified ordinary adapter or LinuxCNC/FPGA path does not become independent personnel-safety authority. Safety authority remains in a separately engineered and validated safety architecture unless explicit evidence supports otherwise.
