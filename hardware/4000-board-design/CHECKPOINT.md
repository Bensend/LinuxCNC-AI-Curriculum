# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane is active alongside the safety curriculum. Durable lessons now present:

- `BD01_BLOCK_VS_CONNECTION_CONTRACT_AND_READINESS_AUDIT.md`
- `BD02_REFERENCE_TO_BLOCK_CONTRACT_CALCULATION_PROTECTION_AND_RESOURCES.md`
- `BD03_MACHINE_IO_TO_BOARD_RESOURCE_AND_CONNECTION_PLAN.md`

BD01 establishes reusable-block versus board-specific connection-definition ownership. BD02 advances block engineering through proven-reference selection, explicit deltas, calculations/derating, protection-current-path reasoning, startup/default states, machine-readable resource declarations, and release gates. BD03 switches to board integration: machine-I/O decomposition, block-instance selection, typed FPGA/bus/power/domain budgeting, connection-definition needs and an explicit unresolved-resource ledger.

## Current verified worked-example state

For BD03, current OpenPressBrake main was re-read before writing and before this checkpoint update. The following student-facing artifacts were opened in current form:

- `hardware/blocks/differential_encoder/engineering.yaml` — `VERIFIED_FOR_LESSON` for ownership, scalable GPIO/current equations, machine-configuration unknowns and ordinary-control safety boundary.
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` — `VERIFIED_FOR_LESSON` for present Rev1 allocation evidence and release limitations.
- `hardware/connections/rev1/J_PVR_ELEC_PWR.yaml` — `VERIFIED_FOR_LESSON AS AN INCOMPLETE CONNECTION-DEFINITION CASE`; electrical L6/L06 mapping and prohibited undocumented domain joins are useful, but exact connector/footprint/rating/harness/placement and final board-level source/return assignment remain unresolved, so it is not presented as capture-ready.

The newest OpenPressBrake commit at final recheck remained `7be88cc7f904c731cc5c4db0948cfd02744128e4` (`integration: instantiate Rev1 PVR-side electronics power connection`). No OpenPressBrake engineering files were modified by this curriculum run.

## Catalog stress-test result

BD03 confirms that the encoder machine-readable contract is useful at board level: for N instances it exposes `3N` FPGA inputs and `0.017N A` maximum aggregate 3.3-V receiver demand while keeping installed encoder current, cable and termination outside the reusable primitive.

The lesson deliberately refuses to infer quantitative LUT/FF/BRAM/PLL/timing cost. Logical GPIO allocation is not routed FPGA fit or timing closure. Quantitative FPGA-fit teaching still requires justified synthesis/place-route/timing evidence on the permitted local runner.

The new PVR-side connection definition demonstrates the desired fail-closed connection mold: preserve known machine electrical identity and return-domain boundaries while leaving unsupported connector mechanics and physical placement unresolved. This is a positive incomplete example, not finished student capture material.

## Next exact work

Build BD04 as a block-engineering lesson on:

`startup/default/de-energized state -> enable/output authority -> watchdog interaction -> protection/fault containment -> ordinary-control safety boundary -> verification matrix`

Select a current ordinary-output block only after opening its engineering contract, manifest/connectivity, calculations, status, simulation/test evidence and relevant board-integration files. Prefer an output/driver block that makes authority and de-energized behavior explicit. If the candidate requires unwritten assumptions or contradictory files, record the exact catalog defect and either repair it with justified evidence (only if it does not overlap active board work) or exclude it and choose another block.

BD04 should force students to distinguish: FPGA command state, hardware enable state, power-domain availability, field-output physical state, watchdog/fault state, and independent personnel-safety authority. Do not teach `FPGA output low = machine safe` as a universal rule.

After BD04, return to integration for a power/ground/current-return tracing lesson that follows complete current paths across multiple blocks and connection definitions.

## Compute

No simulation, synthesis, benchmark or executable verification was justified in BD03. No hosted compute was used. Future FPGA quantitative-fit work may run only on `[self-hosted, openpressbrake]`.

## Safety boundary

This lane covers ordinary controller-board engineering. Independent personnel-safety authority remains outside ordinary LinuxCNC/FPGA logic unless separately safety-rated and validated.