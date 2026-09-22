# BD36 — Multi-Variant Lifecycle Migration and Coexistence

## Purpose

BD35 established bounded alternate and lifecycle decisions. BD36 addresses the system-level problem that follows: old and new board/configuration generations often coexist in manufacturing, service stock, software, and installed machines.

The governing flow is:

`replacement strategy -> compatibility matrix -> coexistence window -> manufacturing cut-in -> service transition -> FPGA/software/HAL compatibility -> migration evidence -> field rollout -> rollback/containment -> legacy retirement`

This lesson develops both linked skills:

1. **block engineering** — preserve explicit reusable contracts and revise them only when a generic semantic change is justified; and
2. **board integration** — manage multiple board/configuration generations without pretending they are one configuration or contaminating reusable blocks with migration glue.

OpenPressBrake is used only as a current governance/example source. It is not represented as production-proven hardware.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD35_SERVICE_PARTS_APPROVED_ALTERNATES_OBSOLESCENCE_AND_LIFECYCLE_MIGRATION.md` — bounded alternate/lifecycle policy and exact-identity rules.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD36 — board-lane assignment and exact next work.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — readiness/evidence gates.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block, adapter, board-integration, machine-fact, and safety-authority boundaries.
- OpenPressBrake `hardware/blocks/motor_drive_interface/manifest.yaml` — exact generic interface/resource contract and board-owned connector boundary.
- OpenPressBrake `hardware/blocks/motor_drive_interface/STATUS_CHECKLIST.md` — current `SIMULATION-READY` state and open release gates.

The current `motor_drive_interface` is not assigned as finished production hardware. It remains `SIMULATION-READY`; selected drive timing, abnormal fault qualification, schematic review, final connector/cable integration, board integration, simultaneous-axis thermal/SI evidence and human release remain open. For production use it is `ENGINEERING_REVIEW_NEEDED`.

---

## 1. Migration is a population problem, not just a design revision

A replacement design can be correct while the migration plan is wrong. At minimum distinguish:

- old released engineering baseline;
- new released engineering baseline;
- manufacturing work in process;
- service/spare stock;
- installed/as-maintained field population;
- unknown legacy identity;
- software/FPGA/HAL configurations that support one or both generations.

> **NEW GENERATION RELEASED != OLD POPULATION MIGRATED**

Do not infer physical population from the current catalog head.

## 2. Build an explicit compatibility matrix

For every generation pair record compatibility by semantic facet, not by family name. Useful axes include:

- reusable electrical interfaces;
- connector/harness pinout;
- power/return domains;
- FPGA pin/resource map;
- watchdog/default/output-authority behavior;
- firmware/bitstream identity;
- LinuxCNC/HAL-visible names, polarity, scaling and timing;
- machine configuration;
- service fixture/programming compatibility;
- mechanical fit and keying;
- qualification envelope.

Classify each direction separately: `COMPATIBLE`, `COMPATIBLE_WITH_CONFIG`, `ADAPTER_REQUIRED`, `NOT_COMPATIBLE`, or `UNKNOWN_VERIFY`.

> **A WORKS WITH B != B WORKS WITH A**

Forward and backward compatibility are separate claims.

## 3. Preserve exact configuration identity during coexistence

A coexistence window is not permission to call both generations “the controller.” Every manufactured, spare, installed, repaired, or rolled-back unit must retain exact identity for the board, BOM/options, FPGA image, LinuxCNC/HAL configuration, approved adapters, and relevant machine mapping.

If a common software package supports multiple hardware generations, hardware detection or explicit configuration selection must fail closed when identity is ambiguous.

> **COMMON SOFTWARE != COMMON HARDWARE SEMANTICS**

## 4. Manufacturing cut-in is a controlled boundary

Define the cut-in using traceable criteria such as release ID, work order/lot/serial range, PCB revision, BOM revision, programmed-image identity, effective date, and disposition of work in process.

Do not use “after we ran out of old parts” as the configuration boundary.

A staged cut-in may legitimately produce old and new boards at the same time. Both remain truthful configurations with their own evidence.

## 5. Service transition is separate from manufacturing transition

New manufacturing can migrate before field service does. Spare-board policy must state which generation can replace which installed generation and under what configuration or adapter requirements.

A spare that physically plugs in but needs a different FPGA/HAL profile is not a like-for-like replacement.

> **SPARE FITS != SERVICE COMPATIBLE**

Service compatibility must include the resulting as-maintained identity.

## 6. Do not widen reusable contracts merely to hide incompatible generations

If generations differ only in board connector/pin mapping, preserve the reusable block and express the difference in board-specific connection/integration records.

If a meaningful reusable transformation can bridge generations, qualify an adapter.

If the generic electrical/semantic function itself changed, create a real reusable-block revision and propagate `SHOW WHERE USED`.

Do not create a vague union contract that says both incompatible behaviors are valid merely so one block ID can cover history.

> **MIGRATION CONVENIENCE != GENERIC CONTRACT**

A successful board is not evidence that incompatible generations should share one reusable contract.

## 7. FPGA/software/HAL compatibility is first-class migration evidence

A board revision with the same field connectors can still be incompatible if its FPGA resource map, polarity, timing, watchdog semantics, scaling, or HAL naming changed.

For each supported pairing record:

- board generation;
- FPGA image/toolchain identity;
- pin/resource map;
- watchdog/default behavior;
- LinuxCNC/HAL configuration identity;
- machine timing/scaling/polarity profile;
- programming/recovery method;
- regression evidence.

A build that succeeds does not establish compatibility.

## 8. Migration evidence follows changed semantic facets

For each old/new pairing classify evidence as preserved, stale, requiring bounded regression, requiring new qualification, or inapplicable.

Examples:

- connector-only board remap can preserve reusable electrical qualification but requires connection/harness verification;
- changed FPGA pin bank can stale I/O-standard and resource evidence;
- changed line driver can stale timing/load/SI/thermal/protection evidence;
- changed regulator can stale startup/shared-load/thermal evidence;
- unchanged block circuitry does not need gratuitous requalification when only board mapping changed.

> **MIGRATION TEST PASSED != ALL DEPENDENT EVIDENCE CURRENT**

## 9. Rollback must be a real supported configuration

A rollout plan needs a rollback state that is identifiable, buildable/programable where applicable, serviceable, and supported by evidence. “Put the old board back” is not sufficient when the machine configuration, FPGA/HAL image, harness, or service history has already changed.

Record rollback prerequisites and the exact resulting as-maintained identity.

> **ROLLBACK PLAN != OLD HARDWARE IN A BOX**

If a field finding appears during rollout, containment can pause cut-in, quarantine affected stock, or restore a known prior configuration while root cause proceeds.

## 10. Unknown legacy identity fails closed

When an installed unit's exact generation or service history is unknown, do not infer compatibility from enclosure, family name, or apparent connector fit.

Mark the required facts `VERIFY_AT_MACHINE` and inspect before applying a migration, spare, firmware image, HAL profile, or field action.

> **UNKNOWN LEGACY IDENTITY != OLDEST KNOWN BASELINE**

## 11. Retire legacy support only when the population is bounded

Legacy retirement can mean no new manufacture, no service stock, no software support, no field retrofit support, or full installed-population retirement. These are different states.

Before withdrawing a supported configuration, establish which production, service, spare and installed/as-maintained populations remain. Unknown units require explicit treatment; silence is not evidence that they disappeared.

> **NO RECENT ORDERS != NO INSTALLED POPULATION**

Retirement should preserve historical configuration/evidence records even when active support ends.

## 12. OpenPressBrake worked governance example

The inspected `motor_drive_interface` publishes a generic two-pair differential command primitive using exact `AM26LV31EIDR` and `TPD4E05U06DQAR` identities. It deliberately keeps the physical connector in board integration, and its status still has final connector/cable, selected-drive timing, fault, thermal/SI, integration and release gates open.

That boundary illustrates how a future board-generation migration should work. If a new board changes only the physical connector or FPGA-to-instance mapping while preserving the reusable transmitter contract, those generation differences belong in board connection/integration and configuration records. The reusable primitive should not gain old-board/new-board connector names.

If a future generation requires a materially different electrical transmitter contract, it should be a real block revision or qualified adapter, not a widened union contract. Any claim that old and new boards can share one FPGA/HAL image would also require explicit resource, timing, polarity, watchdog and mapping evidence.

No actual OpenPressBrake released generations, installed population, migration, spare policy, or field rollout are asserted here.

## 13. Cross-machine reuse

The same method applies to mills, lathes, plasma tables, routers, robots, press brakes and custom automation. Multiple generations can coexist for years. Reusable block contracts remain machine-independent; board connection records, software profiles, service policy and installed identity carry generation-specific facts.

## 14. Safety boundary

Ordinary LinuxCNC/FPGA controllers may observe status from or command ordinary interfaces associated with an independent safety system, but this migration method grants no personnel-safety authority.

A controller-generation migration that preserves an ordinary safety-status signal proves only the bounded electrical/configuration behavior actually verified. Changes inside the independent safety architecture require their own safety-rated change and validation process.

> **CONTROLLER GENERATION COMPATIBLE != SAFETY FUNCTION REVALIDATED**

---

## Lab — eight adversarial coexistence cases

Use a fictional controller family serving several machine classes.

### Case 1 — mixed old/new boards sharing software

Two board generations can run the same application package but require different FPGA images and HAL pin maps. Build the compatibility matrix and fail-closed selection method.

### Case 2 — staged manufacturing cut-in

Old inventory and work in process overlap the new release for three weeks. Define exact cut-in identity and prevent date-only ambiguity.

### Case 3 — spare-board compatibility

A new spare mechanically fits an old machine but requires a harness adapter and different polarity configuration. Classify ownership, evidence and resulting as-maintained identity.

### Case 4 — rollback after a field finding

A new-generation rollout develops an intermittent issue. Define containment and an exact supported rollback state without erasing the failed evidence or service changes.

### Case 5 — unknown legacy identity

A machine has the family label but no reliable board/service record. Identify `VERIFY_AT_MACHINE` facts before choosing hardware, FPGA/HAL profile or retrofit.

### Case 6 — corrupt union contract

Old and new boards expose electrically incompatible interfaces. A proposal suggests widening one reusable block contract to allow both. Reject or restructure it using the block/adapter/integration decision test.

### Case 7 — asymmetric compatibility

New software can support old hardware, but old software cannot safely drive the new hardware's changed default/polarity semantics. Record compatibility direction explicitly.

### Case 8 — legacy retirement

Manufacturing has used only the new generation for a year, but service stock and several unknown field units remain. Define which support states may be retired and which cannot yet be closed.

For each case submit:

- exact old/new configuration identities;
- compatibility matrix by semantic facet and direction;
- reusable block/adapter/board-integration ownership;
- manufacturing cut-in state;
- service/spare policy;
- FPGA/software/HAL compatibility identity;
- preserved/stale/new evidence;
- installed/as-maintained population or unknowns;
- rollout and rollback state;
- `VERIFY_AT_MACHINE` items;
- legacy-retirement decision;
- safety-authority statement.

### Lab pass criteria

A passing submission must preserve exact identity through coexistence; define compatibility directionally; keep board-specific migration facts out of reusable blocks; create adapters only for real reusable transformations; treat FPGA/HAL identity as configuration; provide a real rollback baseline; fail closed on unknown legacy identity; use installed/as-maintained population evidence; and refuse premature legacy retirement or unsupported safety claims.

---

## Catalog stress-test result

BD36 exposes a concrete migration infrastructure need. Future tooling should represent a versioned compatibility/migration graph joining:

- old/new release and board identities;
- reusable block/adapter revisions;
- connector/harness/connection definitions;
- FPGA image/toolchain/resource-map identity;
- LinuxCNC/HAL/machine-configuration identity;
- directional compatibility by semantic facet;
- manufacturing cut-in and WIP disposition;
- service/spare substitution policy;
- installed/as-maintained applicability;
- preserved/stale/regression evidence;
- rollout/rollback states;
- unknown `VERIFY_AT_MACHINE` populations;
- lifecycle/support/retirement state.

Do not encode this as machine-generation exceptions inside reusable block manifests. Reusable blocks own generic electrical function and contract; coexistence and population migration require a separate traceable configuration layer.

Current OpenPressBrake does not yet provide this repository-wide migration graph. Keep this gap `ENGINEERING_REVIEW_NEEDED`; do not invent released generations or installed assets.

## Durable freezes

- `NEW GENERATION RELEASED != OLD POPULATION MIGRATED`
- `A WORKS WITH B != B WORKS WITH A`
- `COMMON SOFTWARE != COMMON HARDWARE SEMANTICS`
- `SPARE FITS != SERVICE COMPATIBLE`
- `MIGRATION CONVENIENCE != GENERIC CONTRACT`
- `MIGRATION TEST PASSED != ALL DEPENDENT EVIDENCE CURRENT`
- `ROLLBACK PLAN != OLD HARDWARE IN A BOX`
- `UNKNOWN LEGACY IDENTITY != OLDEST KNOWN BASELINE`
- `NO RECENT ORDERS != NO INSTALLED POPULATION`
- `CONTROLLER GENERATION COMPATIBLE != SAFETY FUNCTION REVALIDATED`

## Next exact work

Build BD37 on **migration execution evidence and fleet convergence**: planned population -> serialized migration work package -> pre-change identity capture -> hardware/configuration change -> verification -> as-maintained update -> exception handling -> fleet convergence metrics -> residual legacy/unknown population -> closure decision.

Stress partial migrations, failed field updates, wrong FPGA/HAL profile detection, rollback records, units unreachable for inspection, and the difference between rollout completion percentage and evidence-backed configuration convergence.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD36. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.