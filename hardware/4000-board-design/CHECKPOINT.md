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

BD01 establishes reusable-block versus board-specific connection-definition ownership. BD02 covers proven-reference selection, explicit deltas, calculations/derating, protection reasoning and resource declarations. BD03 switches to board integration with machine-I/O decomposition, typed resource budgeting, connection requirements and unresolved-resource ownership. BD04 returns to block engineering and teaches output authority, deterministic default/de-energized states, watchdog boundaries, power-domain loss, fault containment and evidence-based qualification. BD05 switches back to board integration and teaches source/load ownership, normal and fault-current return tracing, startup/inrush aggregation, return/chassis/PE/shield distinctions, partial-power/back-power analysis and release gates. BD06 returns to block engineering and teaches exact connectivity/BOM authority, fail-closed schematic-capture gates, board-specific connector binding, ERC limits, human review and revision provenance.

## BD06 verified worked-example state

Every OpenPressBrake file named to students in BD06 was opened and inspected in current main-branch form during this run.

### Differential encoder

`VERIFIED_FOR_LESSON` for exact reusable electrical authority, but explicitly not presented as schematic-ready or production-qualified:

- `hardware/blocks/differential_encoder/engineering.yaml`
- `hardware/blocks/differential_encoder/manifest.yaml`
- `hardware/blocks/differential_encoder/design/REV1_PRODUCTION_CONNECTIVITY.md`
- `hardware/blocks/differential_encoder/design/PRODUCTION_BOM_REV1.yaml`
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md`

The package freezes one-encoder primitive ownership, exact AM26LV32EIPWR receiver connectivity, hard-enable treatment, connector-edge pair protection to CHASSIS_PE, terminated/unterminated variants, decoupling, shield bond and exact BOM. Its status still leaves schematic visual review, machine termination selection, protected encoder field supply, abnormal-condition work, PCB integration and release gates open. This is intentionally taught as `EXACT REUSABLE CONNECTIVITY != SCHEMATIC-READY`.

### Digital input

The following are `VERIFIED_FOR_LESSON` only as an adversarial inconsistency case, not as finished capture material:

- `hardware/blocks/digital_input_24v/engineering.yaml`
- `hardware/blocks/digital_input_24v/manifest.yaml`
- `hardware/blocks/digital_input_24v/REFERENCE_REBASE.md`
- `hardware/blocks/digital_input_24v/STATUS_CHECKLIST.md`

Current engineering/reference authority withdraws the old universal <=500 pF effective FGND-to-other-ground / 6.5 pF residual PCB-parasitic release gate. The current manifest still contains legacy fields and verification/placement language that treat those numbers as mandatory. The engineering file itself says such legacy manifest fields are superseded.

Readiness result: `ENGINEERING_REVIEW_NEEDED` for manifest reconciliation and `INCOMPLETE_NOT_STUDENT_MATERIAL` as a finished schematic-capture example.

## Catalog stress-test result

BD06 exposed a concrete catalog defect that mature prose/status alone would not reveal: contradictory machine-readable authority can survive after an engineering correction.

Freeze:

`ONE FILE SAYS SUPERSEDED + ANOTHER MACHINE-READABLE FILE STILL ENFORCES IT = CAPTURE BLOCKED`

and

`SEMANTIC CONTRACT != PRODUCTION CONNECTIVITY != SCHEMATIC-READY != QUALIFIED`.

Concrete OpenPressBrake action item: reconcile `hardware/blocks/digital_input_24v/manifest.yaml` to the current `engineering.yaml`, `REFERENCE_REBASE.md`, and `STATUS_CHECKLIST.md`, removing/demoting the withdrawn universal 500 pF/6.5 pF requirement everywhere it remains mandatory. Preserve the frozen 470 pF nominal CEMC component and current manufacturer-topology policy. Re-run relevant static validators after that engineering change.

This curriculum run did not edit OpenPressBrake because the defect can be stated precisely without risking an overlapping engineering change. OpenPressBrake main was re-read immediately before checkpointing at `f5c05614b7b891f4134b7fd4ae0cbf5969e103b8` (`integration: quarantine duplicate Rev1 connector mirrors`). Recent active work is in Rev1 connector authority and analog-input Rev31 reconciliation, so BD06 remained read-only against the engineering repository.

## Next exact work

Build BD07 as a **BOARD INTEGRATION** lesson on whole-board machine-readable assembly and kitchen-sink review:

`block instances -> board-specific connection blocks -> whole-board net/resource graph -> cross-block domain/return/enable ownership -> FPGA/bus/power aggregation -> hidden-glue audit -> KiCad hierarchy/capture plan -> whole-board ERC/review gates`

The adversarial question is whether independently documented blocks can actually be assembled into a complete controller without unwritten joins. Every cross-block edge must have exactly one owner. The lesson must detect duplicate connector authority, hidden power/ground joins, unowned enables/inhibits, implicit level translation, resource double counting, machine-specific leakage into reusable blocks and connector mirrors that can drift.

Before naming any current OpenPressBrake integration/connection file to students, open the canonical file in current main and inspect any quarantine/deprecation/mirror governance introduced by the recent `f5c05614` connector-authority change. Do not teach a duplicate/mirror path as canonical merely because an older lesson or manifest names it.

Prefer a bounded complete slice first; only call the full Rev1 board a kitchen-sink example where current evidence actually supports the specific claim. Do not claim production proof.

## Compute

No simulation, synthesis, benchmark or executable verification was justified in BD06. No hosted compute was used. Executable board/FPGA work remains restricted to `[self-hosted, openpressbrake]` when a concrete question requires it.

## Safety boundary

BD06 concerns ordinary controller-board electrical capture and provenance. Exact wiring, deterministic defaults, watchdog interfaces and STO/enable interfacing do not create personnel-safety credit. Independent safety authority remains outside ordinary LinuxCNC/FPGA logic unless separately safety-rated and validated.
