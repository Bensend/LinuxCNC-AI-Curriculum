# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-24

## Lane status

Independent board-design curriculum lane remains active alongside the separate safety curriculum. Durable lessons BD01 through BD63 are present. This checkpoint is board-design authority only and does not alter safety-course progress authority.

New this run: `BD63_BOARD_WIDE_POWER_DOMAIN_RETURN_CURRENT_SHIELD_CHASSIS_AND_FAULT_CONTAINMENT_CLOSURE.md`.

BD63 teaches:

`connector manifest + block power contracts -> source/protection tree -> per-domain load/current ledger -> startup/inrush/simultaneity -> return-current tracing -> shield/chassis bonds -> partial-power/backfeed states -> fault containment -> machine-readable power/ground manifest -> whole-board release gate`

## BD63 hard student-material audit

Every repository file named to students as finished material by BD63 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for bounded claims used:

- Curriculum `README.md`
- Curriculum `WORK_SELECTION_POLICY.md`
- Curriculum `hardware/4000-board-design/BD62_CONNECTION_CONTRACT_AGGREGATION_CONNECTOR_PANEL_ALLOCATION_AND_COLLISION_CHECKING.md`
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/REV1_3V3_POWER_HANDOFF.yaml`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/REV1_RESOURCE_CONTRACT.yaml`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/STATUS_CHECKLIST.md`
- OpenPressBrake `hardware/integration/REV1_RS485_POPULATION_POWER_AUTHORITY_REV1.yaml`

`ENGINEERING_REVIEW_NEEDED` as a complete evidence-discovery surface:

- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/STATUS_CHECKLIST.md` — its status text correctly relies on the published reusable 3V3 power contract, but its `Evidence currently present` list names `manifest.yaml` without enumerating the current `REV1_RESOURCE_CONTRACT.yaml` and `REV1_3V3_POWER_HANDOFF.yaml`. This is evidence-index drift, not evidence that those contracts are invalid.

BD63 itself was re-opened from current main after commit.

## Rules frozen by BD63

- individually protected blocks do not prove a valid whole-board power architecture;
- power closure is a source-to-load-to-return graph, not a flat current sum;
- every conversion boundary is accounted exactly once using the owning converter's justified envelope;
- steady, startup/inrush, transient, fault, and decoupling demands are different evidence classes and must not substitute for one another;
- simultaneity assumptions are explicit engineering dependencies, not hidden convenience factors;
- every normal and credible-fault current needs an intended return path;
- logic return, sensor/analog return, field/actuator return, communication COM, shield/chassis, and protective earth remain distinct until explicit grounding authority joins them;
- partial-power and remote-powered/local-unpowered states require backfeed review;
- fault ratings and TVS currents are not ordinary rail-load proxies;
- unsupported installed-machine current, grounding, shield, topology, and isolation facts remain `VERIFY_AT_MACHINE`; and
- ordinary power integrity/fault containment receives zero personnel-safety credit without separate safety-rated authority.

## Worked-example stress test

Current OpenPressBrake `modbus_rtu_rs485` provides a strong reusable power handoff for its selected nonisolated THVD1450 physical port: maximum operating `3V3` supply current is 3.0 mA per populated port and local decoupling is 0.1 uF per port. Optional 120-ohm A/B termination is a differential bus load, not a 3V3 rail load in this no-external-bias baseline. TVS transient current and bus-fault ratings are explicitly excluded as ordinary power-load proxies.

Current board integration scales those values by `N_RS485_POP` but correctly leaves the actual Rev1 populated-port count at `VERIFY_AT_MACHINE`; reserved capability cannot become a fabricated fixed power subtotal. The same authority leaves `RS485_COM`, shield/chassis convention, ground-potential difference, topology/termination, and whether galvanic isolation is required unresolved until machine evidence exists.

The block also retains local-unpowered/remote-powered behavior as an open qualification item. Therefore the current source-current handoff is useful for board aggregation without implying that return/shield or partial-power qualification is complete.

## Catalog stress-test result

Classification: **ENGINEERING_REVIEW_NEEDED** for a first-class machine-readable board power/ground manifest joining reusable block power handoffs to source/converter/protection ownership, steady/startup/inrush/capacitance demands, simultaneity, return-current paths, shield/chassis/PE bonds, partial-power cases, fault-containment boundaries, evidence revisions, and unresolved machine facts.

This is board-integration infrastructure, not a reason to move regulator, connector, grounding, shield, or machine-network facts into the reusable RS-485 primitive.

OpenPressBrake remained read-only because current main is actively advancing safety-interface and power-aggregation engineering. No active engineering files were overwritten.

## Current repository reconciliation

At run start the durable board-design lane ended at BD62. Concurrent safety-curriculum work had advanced curriculum main and was preserved.

Immediately before BD63 was written, curriculum main was `457a290d5940204a06d8314cd2d6b0ec34f99033` and OpenPressBrake main was `6ff42eef0b8ec826a06705b787754fe481f0f1da`. OpenPressBrake stayed read-only.

BD63 was committed as `1b77a5eeeaba1a47ad06ca06c71e68d4bc68eed2` and re-opened from current main before this checkpoint update.

## Next exact work

Build BD64 on **startup/default/de-energized sequencing, power-validity, watchdog/output-authority, and partial-power state-machine closure**:

`power/ground manifest -> rail-validity dependencies -> reset/configuration states -> output default authority -> enable/permissive chain -> watchdog/freshness -> partial-power transitions -> deterministic de-energization -> recovery/re-arm -> machine-readable startup/authority state model -> whole-board transition gate`

Stress that static power closure does not prove deterministic behavior during power-up, reset, FPGA configuration, communications loss, brownout, watchdog expiry, or recovery. Preserve the independent personnel-safety boundary.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was required for BD63. No GitHub-hosted compute was initiated. Future target executable checks, when justified, must use `[self-hosted, openpressbrake]` only.

## Safety boundary

BD63 teaches ordinary controller-board power integrity, return-current discipline, partial-power review, and fault containment. It does not establish PL/SIL/category, safety-rated power interruption, stopping performance, independent safety diagnostic coverage, or final-element validation. LinuxCNC/FPGA watchdogs, inhibits, communications, power-good logic, and ordinary fault containment remain zero-credit for personnel safety unless separate safety-rated design and validation explicitly establishes otherwise.
