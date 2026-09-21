# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane is active alongside the safety curriculum. Durable lessons now present:

- `BD01_BLOCK_VS_CONNECTION_CONTRACT_AND_READINESS_AUDIT.md`
- `BD02_REFERENCE_TO_BLOCK_CONTRACT_CALCULATION_PROTECTION_AND_RESOURCES.md`

BD01 establishes reusable-block versus board-specific connection-definition ownership. BD02 advances block engineering through proven-reference selection, explicit deltas, calculations/derating, protection-current-path reasoning, startup/default states, machine-readable resource declarations, and release gates.

## Current verified worked-example state

The current OpenPressBrake `REFERENCE_BASELINE_POLICY.md`, differential-encoder `REFERENCE_REBASE.md`, `engineering.yaml`, and `STATUS_CHECKLIST.md` were opened and re-opened during BD02 construction. They are `VERIFIED_FOR_LESSON` for the claims BD02 makes. The encoder package is a useful strong example precisely because its reference rebase and machine-readable contract are mature while cable/termination, protected field power, transient qualification, schematic visual review, PCB integration and final release remain explicitly open.

The current analog-input status was inspected during candidate selection and remains `INCOMPLETE_NOT_STUDENT_MATERIAL` as a coherent finished block because Rev31 authority reconciliation is still open and older machine-readable/prose authorities contain stale contradictory burden/reference/direct-drive assumptions. It is excluded from finished-example use rather than papered over.

No OpenPressBrake engineering file was modified. Recent OpenPressBrake main includes active analog-input authority reconciliation and new Rev1 encoder connection-definition work; curriculum work consumed current state read-only rather than colliding with those engineering changes.

## Catalog stress-test result

The encoder contract exposes board-scalable GPIO and 3.3-V current equations and clean ownership boundaries. It does not currently claim quantified LUT/FF/BRAM/timing cost for the inherited LiteX-CNC encoder implementation. BD02 treats those values as unknown rather than inventing them. Quantitative FPGA-fit teaching must wait for justified synthesis evidence from the permitted local runner.

## Next exact work

Build BD03 as the first board-integration lesson:

`machine I/O decomposition -> qualified block-instance selection -> FPGA/bus/power/domain budget -> board-specific connection needs -> unresolved-resource ledger`

Use the encoder primitive as only one input type. Before naming any additional block or board artifact to students, open and inspect every current supporting file and classify readiness. Avoid actively changing OpenPressBrake blocks; if a needed example is inconsistent, record the catalog defect and use a verified alternative or explicit incomplete case study.

BD03 should force a board-level resource table that distinguishes **known calculated demand**, **machine/configuration input**, **measured/synthesis evidence**, and **TBD/VERIFY_AT_MACHINE**. It must not convert logical FPGA capacity into routed-fit evidence without local synthesis/place-route/timing results.

## Compute

No simulation, synthesis, benchmark or executable verification was justified in BD02. No hosted compute was used. Future FPGA quantitative-fit work may run only on `[self-hosted, openpressbrake]`.

## Safety boundary

This lane covers ordinary controller-board engineering. Independent personnel-safety authority remains outside ordinary LinuxCNC/FPGA logic unless separately safety-rated and validated.