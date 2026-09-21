# Board-design curriculum checkpoint — BD18

Date: 2026-09-21  
Lane: independent LinuxCNC/OpenPressBrake board-design curriculum

## Completed

Created `hardware/4000-board-design/BD18_WHOLE_BOARD_PARTIAL_POWER_AND_BACKPOWER_INTEGRATION_AUDIT.md` at commit `066de9e879e8b2b56af2717d771bd35a642013fa`.

BD18 composes BD17 block-local lifecycle contracts into a whole-board partial-power/back-power audit. It teaches domain inventory, fault-created power combinations, bidirectional cross-domain path tracing, separate survivability/validity/authority judgments, USB/service-source auditing, field-to-logic backfeed review, output-authority tracing and bounded bench qualification.

## Student-facing verification

Opened directly from current main during this run:

- OpenPressBrake `hardware/blocks/machine_power/manifest.yaml`
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/manifest.yaml`
- OpenPressBrake `hardware/blocks/digital_input_24v/manifest.yaml`
- OpenPressBrake `hardware/integration/REV1_CORE_LOAD_OWNERSHIP_HANDOFF.yaml`
- Curriculum `hardware/4000-board-design/BD17_STARTUP_RESET_PARTIAL_POWER_AND_DEENERGIZED_STATE_CONTRACTS.md`
- completed BD18 itself, reopened after creation

They are `VERIFIED_FOR_LESSON` only for the bounded claims used in BD18.

## Adversarial findings

1. The core has a useful explicit USB boundary: FT2232H is self-powered from 3V3_CORE and VBUS is detection/reference only, with no-board-power/no-backfeed intent.
2. machine_power deliberately keeps PVR sensor and proportional field sources outside CORE accounting and explicitly requires prevention of field-domain backfeed through diagnostic/current-sense/driver/protection structures.
3. The isolated digital-input architecture is strong for normal/transient operation but still lacks a complete machine-readable field-only/logic-only/ramp/recovery lifecycle contract.
4. A strong core `GLOBAL_OUTPUT_ENABLE` is necessary but does not prove every downstream field-powered driver remains inactive in every partial-power state.
5. Power-load ownership and partial-power ownership need analogous rules: reusable blocks own intrinsic cross-domain behavior; board integration owns composition.
6. Whole-board back-power dependencies are not yet uniformly machine-readable/generatable from the catalog.

## OpenPressBrake interaction

OpenPressBrake main advanced during this run to `6e7a8ba2539b837f09f09bfdccf60c6be620917a` (`integration: bind Rev1 CORE load contracts to owning blocks`). Because the active engineering lane is changing the same power/integration area, OpenPressBrake remained read-only. BD18 consumes that newest authority without overwriting it.

No executable verification was justified. Missing PCB parasitics, connector mating order, external-device behavior and incomplete lifecycle contracts cannot be proved by rerunning unchanged simulations. Future bounded compute remains restricted to `[self-hosted, openpressbrake]`.

## Durable freezes

- Intended startup order is not proof other power combinations cannot occur.
- Separate power budgets are not proof of electrical isolation.
- Galvanic isolation on one path is not complete-board back-power immunity.
- USB connected is not board powered for a detect-only self-powered service contract.
- Survivability, signal validity and output authority are separate claims.
- Reusable blocks own intrinsic partial-power behavior; board integration owns composition.
- Unknown unpowered-input/clamp behavior is a catalog defect, not an integrator assumption.
- Ordinary-control fault containment carries no personnel-safety credit.

## Exact next work — BD19

Teach **power-contract closure and upstream protection sizing without double counting**:

`reusable load contracts -> steady/startup envelopes -> board operating modes/simultaneity -> derived-rail referral -> aggregate source demand -> eFuse ILIM/dVdT -> conductor/connector/copper/thermal checks -> fault coordination -> qualification/regression triggers`

Re-read both mains first. Use current OpenPressBrake CORE-load ownership work only where owning blocks have published defensible numerical contracts. Keep unresolved core/RS485/LVDT/DI/DO/shared-analog supply-demand values open. Do not substitute converter ratings, absolute maxima, field-load current or connector ratings for operating demand. Preserve field-source separation and safety boundary. If exact configured-image power computation becomes genuinely necessary, run it only on `[self-hosted, openpressbrake]`; otherwise continue source/evidence review without hosted compute.
