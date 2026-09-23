# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-22

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD45 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD45_EXCEPTION_RECURRENCE_SYSTEMIC_DEFECT_DETECTION_AND_CATALOG_PROCESS_FEEDBACK.md`.

BD45 teaches:

`closed/current exceptions -> recurrence clustering -> common semantic cause -> board-only pattern vs reusable defect vs process defect -> corrective action -> cross-population impact -> catalog/process update -> regression -> recurrence monitoring`

## BD45 hard student-material audit

Every repository file named to students as finished material by BD45 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- Curriculum `hardware/4000-board-design/BD44_EXCEPTION_DEBT_WAIVER_BURNDOWN_AND_TEMPORARY_CONTROL_RETIREMENT.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/REV1_BOARD_INTEGRATION_HANDOFF.md` for the bounded one-port integration handoff
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml` for current reusable interface/resource declarations and explicit FPGA-resource TBDs
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/STATUS_CHECKLIST.md` for current status and open qualification gates

The current RS-485 primitive is not represented as production-proven or REV 1 READY. Its inspected checklist leaves gateware execution, fault/EMC qualification, connector/shield/topology integration, PCB review, cost/resource closure, and human release open.

The newly created BD45 lesson was re-opened from current main after commit and checked against these inspected sources.

## Rules frozen by BD45

- exception closure does not establish systemic root-cause closure;
- cluster recurrence by normalized semantic cause, not symptom, component family, filename, connector, or machine name;
- same symptom does not prove same cause, and different symptoms do not prove different causes;
- repeated board errors do not automatically establish a reusable-block defect;
- repeated meaningful glue circuitry is evidence to investigate a reusable adapter rather than hide transformation circuitry in board integration;
- shared-resource recurrence is distinct from primitive failure;
- repeated status/checklist drift is a process/governance defect even after individual records are repaired;
- first observed population is not necessarily the only affected population;
- systemic corrective action must identify changed semantic facets and reverse-dependency/population reach;
- block correction, board-integration correction, adapter creation, shared-resource correction, and process correction have different regression obligations;
- recurrence monitoring should use an exposure denominator where meaningful;
- absence of new reports alone does not prove recurrence elimination;
- repeated service success does not qualify a new-build alternate;
- required executable regression uses only `[self-hosted, openpressbrake]`; unavailable authorized compute remains BLOCKED/NOT_RUN;
- ordinary-controller safety-status recurrence/correction does not establish independent personnel-safety validation.

## Worked-example stress test

The current `modbus_rtu_rs485` one-port handoff is a useful bounded example because it sharply separates reusable electrical ownership from board/installation ownership. The primitive owns the selected nonisolated transceiver/protection/default-state contract and publishes per-port 3V3/FPGA demands. Board integration owns installed quantity, FPGA pin assignment, protocol/baud selection, connector mapping, shield/chassis treatment, bus topology/termination, aggregate power accounting, and installation isolation assessment.

That boundary allows students to classify hypothetical recurrence without inventing OpenPressBrake failures: connector mapping recurrence is integration/process; repeated justified isolation need may justify a separately engineered variant/adapter; ignored published 3V3 demand is integration/resource-planning process unless the contract itself is wrong; unresolved LUT/register demand remains visible reusable resource-contract incompleteness until gateware evidence exists; termination-location recurrence remains network/integration and VERIFY_AT_MACHINE discipline.

## Catalog stress-test result

BD45 exposes a missing recurrence/systemic-corrective-action layer above the reusable catalog. It should join closed/current exception history to normalized semantic cause IDs, architectural classification (`BOARD_INTEGRATION`, `BLOCK_DEFECT`, `ADAPTER_GAP`, `SHARED_RESOURCE`, `PROCESS`), reverse dependencies, affected populations, corrective-action revisions, targeted regression, exposure denominators, recurrence monitoring, and systemic closure authority.

The teaching stress test also reinforces that reusable blocks need stable semantic IDs and complete-enough machine-readable interface/resource contracts to diagnose recurrence without unwritten board knowledge. The current RS-485 manifest still marks LUT/register estimates `TBD_after_gateware`; BD45 treats that as explicit incompleteness, not permission to invent resource numbers.

This proposed recurrence infrastructure is `ENGINEERING_REVIEW_NEEDED`.

## Current repository reconciliation

At run start the board-design checkpoint ended at BD44. Curriculum main had concurrent safety-course commits but no post-BD44 board-design lesson. OpenPressBrake current main was `32af348d65cfa24e8b6f2c6dd49ac33fa2ad0039` (`rs485: publish Rev1 board integration handoff`).

BD45 was committed as `f2fb54c2f5e732d273416ca9e6345a7b3185d036` and re-opened from current main. Immediately before this checkpoint write, curriculum main still had BD45 as the newest board-design lesson and OpenPressBrake main remained `32af348d65cfa24e8b6f2c6dd49ac33fa2ad0039`. OpenPressBrake was consumed read-only; no active engineering artifact was overwritten.

## Next exact work

Build BD46 on **corrective-action effectiveness, leading indicators, and prevention evidence**:

`systemic correction -> preventive/detective controls -> leading indicators -> exposure-normalized monitoring -> escape detection -> effectiveness review -> control tuning -> sustained closure or recurrence reopen`

Stress a validator that passes but does not cover the escaped semantic defect, an apparent recurrence reduction caused only by lower exposure, a process control that detects drift but does not prevent it, a block correction whose board consumers remain stale, and a safety-status monitoring improvement that must not be promoted into independent safety-function authority.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD45. No GitHub-hosted runner was used.

## Safety boundary

BD45 teaches recurrence and systemic corrective action for ordinary controller hardware/configuration. It does not establish PL/SIL/category, stopping performance, final-element validation, or independent personnel-safety authority. A corrected recurring defect in an ordinary safety-status monitor, watchdog, handshake, STO request, or inhibit path proves nothing about validation of the independent safety function.
