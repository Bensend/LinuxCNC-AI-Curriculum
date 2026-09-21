# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane remains active alongside the safety curriculum. Durable lessons BD01 through BD20 are present. This checkpoint is board-design authority only and does not alter the separate safety-course progress authority.

New this run:

- `BD20_MACHINE_READABLE_POWER_BUDGET_DEPENDENCY_GRAPHS_AND_RELEASE_GATES.md`

BD20 teaches:

`block contract ID -> instance count -> operating mode -> rail/domain -> converter edge -> source aggregate -> protection setting -> physical-path qualification -> release claim -> change invalidation`.

The central adversarial requirement is that a board configuration must answer **which exact missing reusable contract prevents which upstream claim**. Missing required dependencies propagate `UNKNOWN`; they never become zero or disappear from the report.

## BD20 hard student-material audit

Every repository file named to students by BD20 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- OpenPressBrake `hardware/blocks/README.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md`
- OpenPressBrake `hardware/integration/REV1_CORE_LOW_VOLTAGE_LOAD_CONTRACT_AUDIT.yaml`
- OpenPressBrake `hardware/integration/REV1_CORE_LOAD_OWNERSHIP_HANDOFF.yaml`, with its stale RS-485 closure text explicitly quarantined rather than taught as current state
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml`
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/design/REV47_CORE_POWER_CONTRACT_OWNERSHIP.md`
- OpenPressBrake `hardware/blocks/machine_power/manifest.yaml`
- Curriculum `hardware/4000-board-design/BD19_POWER_CONTRACT_CLOSURE_AND_UPSTREAM_PROTECTION_SIZING.md`

Readiness remains claim-scoped. None of these artifacts establishes production readiness of the complete OpenPressBrake controller.

## Result classes frozen by BD20

- `KNOWN_SUBTOTAL` — arithmetic over currently closed dependencies; useful but incomplete when required blockers remain.
- `COMPLETE_TOTAL` — all required dependencies closed for a named rail/domain, mode, population and revision.
- `CAPACITY_CHECK` — comparison of complete demand against a source/converter/connector/conductor/copper capacity envelope.
- `RELEASED_PROTECTION_SETTING` — protection value whose normal-load, startup, tolerance, source, fault, weakest-path, thermal/SOA and coordination prerequisites are closed as applicable.

Freeze:

- `MISSING REQUIRED DEPENDENCY != ZERO LOAD`.
- `KNOWN_SUBTOTAL != COMPLETE_TOTAL`.
- `COMPLETE_TOTAL != CAPACITY_CHECK`.
- `CAPACITY_CHECK != RELEASED_PROTECTION_SETTING`.
- `COMPLETE ELECTRICAL TOTAL != QUALIFIED PHYSICAL PATH`.
- `COPIED STATUS TEXT != LIVE CONTRACT STATE`.

## Catalog stress-test result

The current CORE low-voltage audit already behaves like an early dependency graph: encoder receiver demand is countable while shared analog and digital-I/O logic-side demands remain explicitly not countable. This supports useful known subtotals without pretending the complete CORE total exists.

The current RS-485 manifest is a positive leaf-contract example: selected THVD1450, <=3 mA 3V3 steady current per populated physical transceiver, 100 nF local decoupling, no invented startup proxy, and explicit forbidden load proxies.

The current FPGA-core Rev47 authority is a deliberately open parent dependency: the reusable core owns `5V_CORE_IN` hot and startup contracts, but their numerical closure is still open. Therefore upstream CORE totals and TPS26633 release claims that require them remain open.

The stress test exposed a concrete metadata-governance defect: `REV1_CORE_LOAD_OWNERSHIP_HANDOFF.yaml` still carries historical RS-485 state text saying the supply-demand contract is missing, while the newer current RS-485 manifest now publishes it. BD20 does not teach the stale status. It records the drift as `ENGINEERING_REVIEW_NEEDED` and recommends stable referenced contract IDs/revisions rather than copied closure text.

A future shared machine-readable power-contract schema should carry stable contract ID/revision, owner, variant, source domain, steady/startup separation, quantity basis, provenance, exclusions, applicability, and regression triggers. Board aggregates should reference those contracts rather than copy their values/status.

No OpenPressBrake engineering file was changed. The active OpenPressBrake lane has just strengthened the mandatory reusable-block/adapter/board-integration boundary, and the curriculum stayed read-only rather than racing that work.

## Current repository reconciliation

Immediately before the BD20 write, LinuxCNC-AI-Curriculum `main` was `5f26eac8993f84f390e55ce45ddc06175c22b436`. BD20 was then committed as `d190f0c90581489fb09a363d3e715d42f3478312`.

Immediately before the BD20 write, OpenPressBrake `main` was `3390ae30a01510a448b0dd589f9d5c53037d977c` (`methodology: link mandatory adapter boundary rule`). That current change was opened through the linked `BLOCK_ADAPTER_INTEGRATION_RULES.md` and consumed read-only.

Before this checkpoint write, curriculum `main` was re-read at `d190f0c90581489fb09a363d3e715d42f3478312`; no overlapping post-BD20 curriculum change was present.

## Next exact work

Build BD21 on **adapter/interface block selection and qualification during board composition**.

Use the current mandatory OpenPressBrake block/adapter/integration boundary and intentionally present incompatible but individually valid reusable interfaces. Require classification as:

- `DIRECT_INTEGRATION`
- `BLOCK_CONTRACT_DEFECT`
- `ADAPTER_REQUIRED`
- `BOARD_INTEGRATION_MAPPING`
- `UNRESOLVED`

The adversarial test is whether students/configurators can resolve a real electrical mismatch without contaminating either reusable block, while also refusing to create an adapter when the work is merely a board-specific wire/pin/connector mapping. Preserve board-specific connection blocks as molds; do not let them become hidden electrical adapters.

Before naming any current OpenPressBrake artifact, open it again from current main. If active board work overlaps an example, consume it read-only or switch examples rather than overwriting newer engineering work.

## Compute

No simulation, synthesis, place-and-route, benchmark or executable verification was justified for BD20. The current work is dependency semantics, contract closure, metadata consistency and physical qualification. Future executable work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD20 concerns ordinary controller power accounting, deterministic behavior and fault containment. No LinuxCNC, FPGA, watchdog, eFuse, ordinary I/O, dependency graph or board-power result receives independent personnel-safety authority from this work.