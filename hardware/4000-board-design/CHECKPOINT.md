# 4000 Board-Design Curriculum Checkpoint

Date: 2026-09-21

## Lane status

Independent board-design curriculum lane is active alongside the safety curriculum. Durable lessons now present:

- `BD01_BLOCK_VS_CONNECTION_CONTRACT_AND_READINESS_AUDIT.md`
- `BD02_REFERENCE_TO_BLOCK_CONTRACT_CALCULATION_PROTECTION_AND_RESOURCES.md`
- `BD03_MACHINE_IO_TO_BOARD_RESOURCE_AND_CONNECTION_PLAN.md`
- `BD04_DEFAULT_STATE_OUTPUT_AUTHORITY_WATCHDOG_AND_FAULT_CONTAINMENT.md`
- `BD05_POWER_DOMAINS_RETURNS_PARTIAL_POWER_AND_FAULT_PATHS.md`

BD01 establishes reusable-block versus board-specific connection-definition ownership. BD02 covers proven-reference selection, explicit deltas, calculations/derating, protection reasoning and resource declarations. BD03 switches to board integration with machine-I/O decomposition, typed resource budgeting, connection requirements and unresolved-resource ownership. BD04 returns to block engineering and teaches output authority, deterministic default/de-energized states, watchdog boundaries, power-domain loss, fault containment and evidence-based qualification. BD05 switches back to board integration and teaches source/load ownership, normal and fault-current return tracing, startup/inrush aggregation, return/chassis/PE/shield distinctions, partial-power/back-power analysis and release gates.

## BD05 verified worked-example state

Every OpenPressBrake file named to students in BD05 was opened and inspected in current main-branch form during this run:

- `hardware/REV1_BOARD_INTEGRATION.yaml` — `VERIFIED_FOR_LESSON` for board-specific domain ownership and non-collapse rules. It explicitly separates CORE_24V, PROP_FIELD_24V, PVR_SENSOR_24V and SWITCHED_IO_24V, and preserves analog/high-current/switched/core layout-zone distinctions. It is not presented as proof that every branch is production-qualified.
- `hardware/blocks/machine_power/design/REV11_SENSOR_POWER_DOMAIN_RECONCILIATION.md` — `VERIFIED_FOR_LESSON` for an adversarial catalog/integration correction. It records why the earlier sensor-field-behind-logic-eFuse assumption was invalid for Rev1 and moves source-domain authority back to board integration.
- `hardware/blocks/machine_power/STATUS_CHECKLIST.md` — `VERIFIED_FOR_LESSON` for maturity/release-gate teaching only. It explicitly says machine_power is NOT YET SCHEMATIC-READY and leaves ILIM/dVdT, separate sensor branch protection/current/drop, return/ground/chassis/PE relationships, PCB/current-path, thermal/fault/EMC and integration gates open.

OpenPressBrake main was re-read before curriculum writes. Current engineering head observed this run was `a873cfdd4e796f0a3f7c49f16a6927c6c2498772` (`integration: instantiate Rev1 proportional valve power boundary`). Because power integration is actively moving, BD05 consumed current engineering state read-only and did not edit OpenPressBrake files.

## Catalog stress-test result

BD05 confirms that the reusable-block/board-integration split survives a real source-domain correction: the reusable machine-power primitive can retain its electrical semantics while the board integration owns which physical machine source actually feeds a field rail.

The important freezes are:

`SAME NOMINAL VOLTAGE != SAME POWER DOMAIN`

`PROTECTED DEVICE PRESENT != FAULT CURRENT PATH QUALIFIED`

`DOMAIN OFF != NO ENERGY ENTERS DOMAIN`

and

`SEMANTIC BLOCK RAIL != AUTHORITY TO OVERRIDE VERIFIED BOARD SOURCE ASSIGNMENT`.

The Rev11 correction is a positive catalog stress-test result because the contradiction was made durable and fail-closed instead of being papered over. The remaining grounding/return and branch-protection gaps are already explicit. No new OpenPressBrake catalog edit was technically justified while active power integration is changing.

## Next exact work

Build BD06 as a **block-engineering** lesson on machine-readable connectivity and capture readiness:

`semantic interfaces -> exact component pins/nets -> parameter/BOM authority -> machine-readable connectivity -> connection-definition binding -> capture gate -> generated/hand-captured KiCad schematic -> ERC -> human schematic review -> revision evidence`

The lesson must attack the failure mode where prose and status are mature but exact production connectivity is incomplete. It should teach that a block is not schematic-ready until every required component pin, support part, return, enable/default-state network, protection path and externally bound semantic interface has an exact authority.

Before exposing any candidate block to students, open its current engineering contract, manifest, exact connectivity artifact, BOM/parameter authority, status checklist, and any generated schematic/ERC evidence actually referenced. Prefer a block whose machine-readable connectivity is sufficiently complete to teach the positive path, plus one explicitly incomplete case to teach fail-closed capture gating. Do not use current active proportional/power work as a finished positive example unless current main actually supports that claim.

BD06 should also make connection definitions remain board-specific: exact field connector part/pins/placement/silkscreen/harness destination bind to semantic block ports at board integration; they do not become part of the reusable block merely to simplify schematic generation.

## Compute

No simulation, synthesis, benchmark or executable verification was justified in BD05. No hosted compute was used. Executable board/FPGA work remains restricted to `[self-hosted, openpressbrake]` when a concrete question requires it.

## Safety boundary

BD05 concerns ordinary controller-board power architecture. Domain separation, power-good logic, watchdog qualification, output inhibits and deterministic de-energized behavior do not create personnel-safety credit. Independent safety authority remains outside ordinary LinuxCNC/FPGA logic unless separately safety-rated and validated.