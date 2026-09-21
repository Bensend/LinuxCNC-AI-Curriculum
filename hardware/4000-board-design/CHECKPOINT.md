# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane is active alongside the safety curriculum. Durable first lesson:

- `BD01_BLOCK_VS_CONNECTION_CONTRACT_AND_READINESS_AUDIT.md`

BD01 establishes the reusable functional-block / board-specific connection-definition ownership boundary and introduces the hard current-file lesson-readiness audit.

## Verified current worked-example state

Current OpenPressBrake files were opened before use. The differential-encoder knowledge package and status checklist are suitable for teaching reusable-contract structure and the distinction between knowledge maturity and release readiness. They are not evidence of a production-qualified board. The current Rev1 Y2 scale connection definition is deliberately incomplete at the physical connector/harness layer and must not be presented as a finished board-capture example. Machine-power remains explicitly not schematic-ready and is excluded as a finished student design example.

No OpenPressBrake engineering file was modified: the incompleteness found by the lesson is already represented correctly by current status/VERIFY_AT_MACHINE gates, and filling those facts without machine evidence would be an architectural regression.

## Next exact work

Build BD02: `block requirements -> proven reference/topology -> calculations/derating -> protection/fault containment -> startup/default/de-energized state -> machine-readable resource declaration`.

Before selecting a worked block, re-read both repository mains and inspect every student-facing current file. Prefer an electrically mature block that can support the calculation/protection/default-state lesson without implying production qualification. If no candidate passes the hard verification rule, preserve the defect as a catalog action item and use a generic exercise rather than presenting incomplete material as finished.

A later integration lesson should return to the Y2 connection definition only after the physical connector/harness gates are actually closed, or explicitly use it as an incompleteness/fail-closed exercise.

## Compute

No simulation, synthesis, benchmark or executable verification was justified in this run. No GitHub-hosted compute was used.

## Safety boundary

This lane covers ordinary controller-board engineering. Independent personnel-safety authority remains outside ordinary LinuxCNC/FPGA logic unless separately safety-rated and validated.
