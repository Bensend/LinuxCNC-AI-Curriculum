# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane remains active alongside the safety curriculum. Durable lessons BD01 through BD22 are present. This checkpoint is board-design authority only and does not alter the separate safety-course progress authority.

New this run:

- `BD22_BOUNDARY_COMPATIBILITY_MATRICES_AND_MACHINE_READABLE_INTERFACE_MATCHING.md`

BD22 teaches fail-closed interface composition:

`exact interface revisions -> structured compatibility dimensions -> COMPATIBLE | INCOMPATIBLE | UNRESOLVED | CONTRACT_DEFECT -> BD21 classification -> adapter search/board mapping -> invalidation`

The central adversarial requirement is that missing required data never behaves as a wildcard and that board-specific physical mapping remains separate from reusable electrical interface authority.

## BD22 hard student-material audit

Every repository file named to students by BD22 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml`
- Curriculum `hardware/4000-board-design/BD21_ADAPTER_INTERFACE_BLOCK_SELECTION_AND_QUALIFICATION_DURING_BOARD_COMPOSITION.md`

`ENGINEERING_REVIEW_NEEDED` for automated interface matching:

- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/manifest.yaml` — useful resource/bank data exist, but the generic external-I/O boundary is still too prose-like to be a complete generic matcher contract by itself.

The newly created BD22 lesson was re-opened from current main after commit and checked for internal consistency.

Readiness remains claim-scoped. No artifact in this lesson establishes production readiness of the complete OpenPressBrake controller.

## Rules frozen by BD22

- `STRING MATCH != INTERFACE MATCH`.
- `MISSING FIELD != WILDCARD`.
- `ABSOLUTE-MAX SURVIVAL != OPERATING COMPATIBILITY`.
- `RESOURCE FIT != ELECTRICAL COMPATIBILITY`.
- `PHYSICAL MAPPING DATA != ELECTRICAL INTERFACE CONTRACT`.
- `ELECTRICALLY COMPATIBLE != SAFETY-QUALIFIED`.

Required facts use explicit states `KNOWN | NOT_APPLICABLE | VERIFY_AT_MACHINE | UNKNOWN`. Any `VERIFY_AT_MACHINE` or `UNKNOWN` fact required by the compatibility proposition blocks a positive match.

## Catalog stress-test result

BD22 exposed two durable catalog pressures rather than papering over them in lesson prose:

1. a common, versioned semantic interface schema is needed so blocks can publish direction/drive, operating envelopes, impedance, reference/return, isolation/common-mode, lifecycle/default behavior, timing/protocol, protection, power/resources, evidence and invalidation data in a form a configurator can compare;
2. reusable FPGA port classes are needed separately from board-specific FPGA pin assignments. Current FPGA resource counts and 3V3-bank requirements are useful but do not alone prove electrical compatibility of a particular I/O boundary.

The current RS-485 manifest is a useful bounded positive example because it exposes protocol-side signals, field-side signals, selected transceiver, 3V3 rail, common-mode/bus-fault envelopes, termination, FPGA resources, power contract and board-owned connector responsibilities. It still must not be treated as a universal interface schema or as permission to infer unstated lifecycle/threshold/machine-ground facts.

No OpenPressBrake engineering file was changed. Current OpenPressBrake work has advanced into FPGA configuration-bias and motor-drive enable ownership, both adjacent to lifecycle/interface authority, so the curriculum consumed current files read-only rather than racing active engineering.

## Current repository reconciliation

At the start of this run, the last board-design checkpoint was `6f2e9372e1c0928b6cbd3750ea7eaf9af1bca34f`; later safety-lane commits were present on curriculum main and were preserved.

BD22 was committed as `bfc1682f06b0b44dc09da57926cf3895f7e7494e`. The lesson was then re-opened from current main.

Immediately before this checkpoint write, curriculum main was re-read with BD22 at `bfc1682f06b0b44dc09da57926cf3895f7e7494e`; no overlapping post-BD22 board-design change was present.

Immediately before this checkpoint write, OpenPressBrake main was re-read at `100d6ef53c4f5dce73be7f4b2f064fe9575bd9d6` (`motor drive: reconcile enable ownership with frozen connectivity`). OpenPressBrake remained read-only.

## Next exact work

Build BD23 on **interface-contract schema design, stable semantic IDs, and change-impact invalidation**.

The lesson should turn BD22's comparison dimensions into a minimal extensible schema without creating a monolithic one-size-fits-all electrical type. Require stable IDs/revisions for requirements, interfaces and assumptions; downstream boundary records must declare dependencies; reverse lookup must support `SHOW WHERE USED`; and a changed interface/assumption must automatically mark dependent boundary decisions, adapters, connection definitions, resource plans, schematic claims and qualification evidence stale until revalidated.

Adversarially test semantic changes that do and do not require a new interface revision. Keep machine-specific names, J-numbers, connector placement and harness destination in board integration. Do not migrate active OpenPressBrake block files merely to satisfy the lesson if ownership or current engineering work overlaps.

## Compute

No simulation, synthesis, place-and-route, benchmark or executable verification was justified for BD22. The work is contract semantics, metadata structure, evidence classification and fail-closed composition. Future executable work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD22 concerns ordinary electrical/logical compatibility. A successful compatibility result does not establish PL/SIL/category, diagnostic coverage, safety integrity, or independent personnel-safety authority. Safety authority remains in a separately engineered and validated safety architecture unless explicit evidence supports otherwise.
