# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane remains active alongside the safety curriculum. Durable lessons BD01 through BD19 are present. The prior checkpoint text had fallen behind at BD09; this update reconciles it to the actual lesson directory without altering the separate safety-course progress authority.

New this run:

- `BD19_POWER_CONTRACT_CLOSURE_AND_UPSTREAM_PROTECTION_SIZING.md`

BD19 teaches:

`reusable load contract -> board instance count -> operating-mode simultaneity -> derived-rail referral -> source aggregate -> protection settings -> connector/conductor/copper/thermal checks -> fault coordination -> regression evidence`.

## BD19 hard student-material audit

Every repository file named to students by BD19 was opened and inspected in current form during this run.

`VERIFIED_FOR_LESSON` for the bounded claims used:

- OpenPressBrake `hardware/blocks/README.md`
- OpenPressBrake `hardware/blocks/STATUS_RULES.md`
- OpenPressBrake `hardware/integration/REV1_CORE_LOAD_OWNERSHIP_HANDOFF.yaml`
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/design/REV47_CORE_POWER_CONTRACT_OWNERSHIP.md`
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/manifest.yaml`
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml`
- OpenPressBrake `hardware/blocks/machine_power/manifest.yaml`
- Curriculum `hardware/4000-board-design/BD18_WHOLE_BOARD_PARTIAL_POWER_AND_BACKPOWER_INTEGRATION_AUDIT.md`

Readiness is claim-scoped. The RS-485 manifest is a positive example of a reusable supply-demand handoff: selected THVD1450 port, <=3 mA 3V3 steady current per populated physical transceiver, 100 nF local decoupling, no invented startup-current proxy, and explicit forbidden proxy quantities. This does not promote its unresolved EMC/field/physical integration work.

The FPGA-core power ownership is `ENGINEERING_REVIEW_NEEDED` for numerical closure: ownership is correctly assigned to the reusable core, but the final `5V_CORE_IN` hot/steady and startup envelope remains to be established from the selected population/configured image. Board integration must not reconstruct the core from component maxima.

The machine-power TPS26633 logic-branch ILIM and startup/inrush settings remain open. Current authority explicitly requires actual downstream CORE aggregation and excludes separately sourced sensor/proportional field loads from that logic branch.

## Catalog stress-test result

The catalog now demonstrates both sides of the power-contract method:

- a **closed bounded handoff** in RS-485, where board integration can consume a defensible reusable 3V3 load contract; and
- an **honestly open handoff** in the FPGA core, where ownership is frozen but the numerical contract is not yet complete.

BD19 freezes:

- `CAPACITY != LOAD`.
- `ABSOLUTE MAXIMUM != OPERATING DEMAND`.
- `FAULT CURRENT != NORMAL SUPPLY CURRENT`.
- `FIELD LOAD != LOGIC-RAIL LOAD WHEN SOURCES ARE SEPARATE`.
- `PHYSICAL DEVICE COUNT != LOGICAL CHANNEL COUNT`.
- `DOWNSTREAM LOAD REFERRED UPSTREAM != SECOND INDEPENDENT LOAD`.
- `STEADY STATE != STARTUP/INRUSH != FAULT-CLEARING TRANSIENT`.
- `SOURCE CAPACITY != DISTRIBUTION-PATH QUALIFICATION`.
- `OWNERSHIP ASSIGNED != NUMERICAL CONTRACT CLOSED`.
- `PROTECTION SETTING TBD IS BETTER THAN A PROXY-DERIVED NUMBER`.

No OpenPressBrake engineering file was changed. Current board/power work is active and is already closing the exact reusable contracts BD19 consumes; curriculum remained read-only rather than racing that lane.

## Current repository reconciliation

Immediately before the BD19 write, LinuxCNC-AI-Curriculum `main` was `b24b0ca3a02520301459bb93b443188d04fbc70d`; its latest change was in the separate safety/timing lane. BD19 was added as a new board-design file.

Immediately before the BD19 write, OpenPressBrake `main` was `88ace815210d624fc309ddfcb7249f31f7c0af9f` (`rs485: record published power-contract evidence`). That change is directly relevant and was consumed read-only: it closes the RS-485 reusable 3V3 supply-demand handoff while leaving other CORE load contracts open.

## Next exact work

Build BD20 on **machine-readable power-budget dependency graphs and release gates**:

`block contract ID -> instance count -> operating mode -> converter edge -> source-domain total -> unresolved dependency propagation -> protection setting -> physical-path qualification -> change-trigger invalidation`.

The adversarial question is whether the board configuration can answer **which exact missing reusable contract prevents which upstream claim**. A total must not render as authoritative if one of its required dependencies is unresolved. The lesson should distinguish `KNOWN_SUBTOTAL`, `COMPLETE_TOTAL`, `CAPACITY_CHECK`, and `RELEASED_PROTECTION_SETTING` so a partially populated spreadsheet/YAML cannot masquerade as a closed power budget.

Before naming any current OpenPressBrake artifact, open it again from current main. If the active board lane publishes additional load contracts, consume them read-only unless a non-overlapping catalog defect is clearly justified.

## Compute

No new simulation, synthesis, benchmark or executable verification was justified in BD19. The blocking work is contract/evidence closure and physical distribution/fault coordination. Future executable work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Safety boundary

BD19 concerns ordinary controller power integrity and protection coordination. No LinuxCNC, FPGA, watchdog, eFuse, ordinary I/O, or board power function receives independent personnel-safety authority from this work.