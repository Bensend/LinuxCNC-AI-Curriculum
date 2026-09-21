# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane is active alongside the safety curriculum. Durable lessons now present:

- `BD01_BLOCK_VS_CONNECTION_CONTRACT_AND_READINESS_AUDIT.md`
- `BD02_REFERENCE_TO_BLOCK_CONTRACT_CALCULATION_PROTECTION_AND_RESOURCES.md`
- `BD03_MACHINE_IO_TO_BOARD_RESOURCE_AND_CONNECTION_PLAN.md`
- `BD04_DEFAULT_STATE_OUTPUT_AUTHORITY_WATCHDOG_AND_FAULT_CONTAINMENT.md`

BD01 establishes reusable-block versus board-specific connection-definition ownership. BD02 covers proven-reference selection, explicit deltas, calculations/derating, protection reasoning and resource declarations. BD03 switches to board integration with machine-I/O decomposition, typed resource budgeting, connection requirements and unresolved-resource ownership. BD04 returns to block engineering and teaches output authority, deterministic default/de-energized states, watchdog boundaries, power-domain loss, fault containment and evidence-based qualification.

## BD04 verified worked-example state

Every OpenPressBrake file named to students in BD04 was opened in current main-branch form during this run:

- `hardware/blocks/digital_output_24v/engineering.yaml` — `VERIFIED_FOR_LESSON` for reusable ownership, semantic interfaces, deterministic command-loss invariant, machine-input unknowns, calculation structure and ordinary-control safety boundary.
- `hardware/blocks/digital_output_24v/manifest.yaml` — `VERIFIED_FOR_LESSON` for default/watchdog state, FPGA-resource declaration, fault requirements and deliberately unresolved board/application ratings.
- `hardware/blocks/digital_output_24v/design/REV1_ISOLATED_INTERFACE_CONTRACT.md` — `VERIFIED_FOR_LESSON` for separated logic/field-domain architecture, field-side OFF authority and first-machine isolation delta; it is not presented as released production hardware.
- `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — `VERIFIED_FOR_LESSON` for maturity boundaries. The reusable non-isolated variant is simulation-ready; the Rev1 isolated board path remains explicitly not schematic-ready.

OpenPressBrake current main tree was re-read before checkpointing at `9893ce2f8d5ac076aad5a19679afa1f750e8433e`. The active engineering state has moved substantially since BD03, including additional Rev1 isolated-output work, so this run consumed that newest state read-only and did not overwrite OpenPressBrake engineering files.

## Catalog stress-test result

BD04 confirms a useful reusable-block property: deterministic local OFF authority is explicit and physically grounded in command pull-down behavior rather than being hidden in software assumptions.

It also freezes an important board-integration distinction:

`LOCAL COMMAND PULL-DOWN != SYSTEM WATCHDOG`

and

`WATCHDOG REQUESTS OFF != PHYSICAL OUTPUT PROVED OFF`.

The reusable block states that watchdog/control loss must resolve OFF at system integration, but it does not pretend to own the board-level watchdog. A later complete-board lesson must trace watchdog/inhibit authority end-to-end through FPGA logic, translation/isolation, field command node, output device and measured field state.

The current catalog also correctly refuses to promote the IPS1025H device capability into a board channel rating. Actual steady current, inrush, inductance, simultaneous-channel count, copper/vias, connector rating and thermal envelope remain typed machine/board evidence gates.

No catalog correction was justified this run: the important incompleteness is already explicit, and active OpenPressBrake output integration is changing. Curriculum work therefore remained read-only with respect to that block.

## Next exact work

Build BD05 as a board-integration lesson on:

`power domains -> source/load budget -> normal current path -> fault-current return -> startup/inrush aggregation -> return-domain joins -> chassis/PE/shield boundary -> cross-block back-power analysis -> verification gates`

Before assigning any worked example, open current machine-power, field-power, FPGA/core-power, connection-definition and board-integration files actually needed by the lesson. Do not infer readiness from catalog status. Prefer a small cross-block slice that can be traced completely rather than presenting the whole OpenPressBrake power tree as finished.

BD05 must force students to distinguish normal return, fault-current return, shield/chassis/PE, logic reference and isolated field return. It should explicitly challenge partial-power cases where one domain is alive and another is dead, and should treat connector return pins and board-specific joins as connection/integration authority rather than reusable-block assumptions.

If current power files conflict or are actively being changed, record the exact defect and either use them only as an incomplete case study or select a different verified slice. Do not repair active engineering files merely to simplify the lesson.

## Compute

No simulation, synthesis, benchmark or executable verification was justified in BD04. No hosted compute was used. Executable board/FPGA work remains restricted to `[self-hosted, openpressbrake]` when a concrete question requires it.

## Safety boundary

BD04 concerns ordinary machine-control output behavior. Deterministic OFF, watchdog action, diagnostics and output-device protection do not create personnel-safety credit. Independent safety authority remains outside ordinary LinuxCNC/FPGA logic unless separately safety-rated and validated.