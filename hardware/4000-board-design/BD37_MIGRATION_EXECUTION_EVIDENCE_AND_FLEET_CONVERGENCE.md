# BD37 — Migration Execution Evidence and Fleet Convergence

## Purpose

BD36 defined multi-variant compatibility and coexistence. BD37 teaches how a migration is actually executed across a real population without confusing scheduled work, attempted work, successful verification, and evidence-backed configuration convergence.

The governing flow is:

`planned population -> serialized work package -> pre-change identity capture -> controlled change -> verification -> as-maintained update -> exception/rollback handling -> convergence accounting -> residual legacy/unknown population -> closure decision`

This lesson develops both linked skills:

1. **block engineering** — preserve stable reusable contracts and trace only justified generic findings back into blocks; and
2. **board integration** — execute board/FPGA/HAL/harness migrations while preserving exact per-unit configuration identity and evidence.

OpenPressBrake is used only as a current engineering-governance example. It is not represented as production-proven hardware or as having a real migrated fleet.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD36_MULTI_VARIANT_LIFECYCLE_MIGRATION_AND_COEXISTENCE.md` — directional compatibility, coexistence, rollback, unknown-identity and retirement rules.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD37 — board-lane status and exact next work.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — evidence/readiness gates.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable block, adapter and board-integration ownership.
- OpenPressBrake `hardware/blocks/relay_contactor_driver/manifest.yaml` — generic primitive interfaces/resources and unresolved board-owned current/connector facts.
- OpenPressBrake `hardware/blocks/relay_contactor_driver/STATUS_CHECKLIST.md` — current `SIMULATION-READY` state and open release gates.
- OpenPressBrake `hardware/blocks/relay_contactor_driver/REV1_LOGIC_3V3_POWER_HANDOFF.md` — current evidence-backed per-instance logic-rail handoff and explicit board/machine unknowns.

The relay/contactor-driver material is not assigned as finished production hardware. It remains `SIMULATION-READY`; released current/repetition/simultaneity, PCB/current path, connector, branch coordination, abnormal-condition, thermal, board-integration and human-release gates remain open. For production use it is `ENGINEERING_REVIEW_NEEDED`.

---

## 1. Migration plans do not migrate hardware

A migration plan defines intent. Fleet state changes only when a specific serialized/configuration-controlled unit is changed and its resulting state is verified and recorded.

Keep separate counts for:

- `PLANNED` — in the target population;
- `SCHEDULED` — work package assigned;
- `ATTEMPTED` — change activity began;
- `CHANGED_UNVERIFIED` — physical/configuration change completed but required verification is incomplete;
- `VERIFIED_TARGET` — target configuration identity and required verification both established;
- `ROLLED_BACK_VERIFIED` — restored to an explicitly supported prior configuration and verified;
- `EXCEPTION_HOLD` — finding blocks disposition;
- `UNREACHABLE_UNKNOWN` — population member exists but identity/change status cannot currently be established;
- `NOT_APPLICABLE` — excluded by evidence-backed applicability, not convenience.

> **WORK ORDER CLOSED != CONFIGURATION CONVERGED**

A technician closing a job, shipping a replacement board, or reporting that a machine runs does not establish the target as-maintained configuration.

## 2. Every migration unit gets a serialized work package

The work package must bind the intended action to an exact asset/unit identity. At minimum record:

- asset/serial identity or other immutable unit key;
- pre-change board/release/BOM identity;
- pre-change FPGA/firmware/toolchain identity where material;
- pre-change LinuxCNC/HAL/machine-configuration identity;
- installed adapters/harness/jumper/options relevant to compatibility;
- intended target identity;
- approved procedure revision;
- required parts/images/configurations and their exact identities;
- verification requirements and limits;
- rollback baseline and trigger;
- `VERIFY_AT_MACHINE` facts that must be captured before proceeding.

Do not use a generic instruction such as “upgrade all controllers to Rev B” when the population contains unknown or mixed baselines.

## 3. Capture pre-change identity before disturbing evidence

The pre-change record is not paperwork after the fact. It is evidence needed to prove applicability, diagnose failures, and perform rollback.

Capture before removal or reprogramming:

- physical board revision and identifiable BOM/options;
- installed connector/harness/adapter state;
- programmed FPGA/firmware identity;
- HAL/machine configuration identity;
- relevant calibration/configuration values;
- observed deviations, jumpers, rework or undocumented substitutions;
- current fault/failure evidence;
- machine facts required by the migration contract.

If identity cannot be established, stop at the appropriate boundary and classify the unit `UNREACHABLE_UNKNOWN` or `EXCEPTION_HOLD` rather than guessing.

> **EXPECTED OLD CONFIGURATION != OBSERVED PRE-CHANGE CONFIGURATION**

## 4. Apply only a configuration-complete target

A target configuration is more than a PCB. It may include:

- board/BOM/options;
- reusable block and adapter revisions;
- board-specific connection/harness mapping;
- FPGA image and resource/pin map;
- LinuxCNC/HAL configuration;
- machine-specific polarity/scaling/timing values;
- approved service parts;
- calibration/configuration data;
- required physical machine changes.

The migration procedure must prevent mixed-generation combinations that are not explicitly supported by the BD36 compatibility matrix.

> **NEW BOARD INSTALLED != TARGET CONFIGURATION INSTALLED**

## 5. Hardware/profile matching must fail closed

A wrong FPGA or HAL profile can produce a controller that boots and communicates while exposing incorrect polarity, pin assignment, timing, watchdog, scaling, or output semantics.

Verification should therefore establish identity, not merely functionality. Prefer positive matching such as signed/hash-identified images, board revision/option identification, configuration manifests, or another bounded method appropriate to the design.

If automatic detection cannot distinguish supported variants reliably, require explicit controlled selection and independent verification.

> **PROGRAMMING SUCCESS != CORRECT PROFILE**

## 6. Verification must prove the claimed migration boundary

Verification follows changed semantic facets. A useful hierarchy is:

1. **identity verification** — exact target components/configuration are present;
2. **structural verification** — connectors, harnesses, jumpers, options and mappings match the target;
3. **electrical/resource verification** — changed rails, returns, I/O banks, protection, FPGA resources and interfaces satisfy their contracts;
4. **functional verification** — intended command/status behavior is correct;
5. **machine-specific verification** — required physical machine facts and mappings are confirmed;
6. **regression evidence** — dependent claims made stale by the migration are refreshed.

A bounded migration test does not refresh unrelated stale qualification evidence.

> **FUNCTIONAL PASS != CONFIGURATION IDENTITY PROVED**

## 7. Preserve failures and partial attempts

A failed update is configuration history. Record:

- exact pre-change identity;
- intended target;
- actions actually completed;
- point of failure;
- evidence captured;
- uncertain intermediate state;
- disposition;
- rollback or recovery action;
- final verified as-maintained state.

Do not overwrite the failed attempt with the later successful result.

A partially programmed or partially rewired controller must not be counted as either the old or target baseline until its actual state is established.

> **RETRY PASS != FIRST ATTEMPT NEVER FAILED**

## 8. Rollback is another controlled migration

Rollback uses the same discipline as forward migration. It must identify the supported rollback board, FPGA/HAL/configuration, harness/adapters and machine state and then verify the resulting as-maintained identity.

If the forward migration included irreversible harness or machine changes, “reinstall old board” may not recreate the old supported baseline.

Count a unit as `ROLLED_BACK_VERIFIED`, not as successfully migrated to the new target.

> **SERVICE RESTORED != TARGET MIGRATION COMPLETE**

## 9. Update as-maintained identity immediately after verification

The resulting configuration record must bind the unit to what is actually installed after the event, including deviations and approved exceptions.

Do not wait for fleet closure to reconcile per-unit records. Fleet metrics are derived from these records; they are not a substitute for them.

A unit with successful tests but unresolved material identity remains `CHANGED_UNVERIFIED` or `EXCEPTION_HOLD`.

## 10. Measure convergence from evidence, not activity

Useful fleet metrics include:

- total evidence-bounded applicable population;
- `VERIFIED_TARGET` count;
- `ROLLED_BACK_VERIFIED` count;
- `EXCEPTION_HOLD` count;
- known legacy supported count;
- known legacy unsupported count;
- `UNREACHABLE_UNKNOWN` count;
- changed-but-unverified count;
- applicability-excluded count with evidence.

A simple activity percentage such as `completed work orders / scheduled work orders` is not a convergence metric.

A defensible target-convergence ratio is conceptually:

`VERIFIED_TARGET / evidence-bounded applicable population`

but the denominator must explicitly expose unknown/unreachable assets rather than silently deleting them.

> **ROLLOUT COMPLETION % != EVIDENCE-BACKED FLEET CONVERGENCE**

## 11. Unknown and unreachable population remains visible

Machines may be offline, sold, inaccessible, undocumented, or unable to be inspected during the rollout. Their absence from the technician queue is not evidence of target state.

Classify them explicitly and define what evidence would resolve them. Depending on the field action, closure may require later inspection, administrative retirement with provenance, containment, or an explicit residual-risk/support decision by the proper authority.

> **NOT REACHED != NOT AFFECTED**

## 12. Fleet closure is a configuration/evidence decision

Do not close migration merely because the planned date elapsed or the last scheduled technician visit finished.

Closure requires an explicit disposition for every member of the bounded population:

- verified target;
- verified supported rollback/legacy state intentionally retained;
- evidence-backed not applicable;
- formally retired/removed from service with provenance; or
- explicitly accepted unresolved residual state by the proper authority.

Unknown unsupported units prevent a claim of complete target convergence.

Historical pre-change, failure, rollback and exception evidence remains immutable after closure.

> **NO OPEN WORK ORDERS != NO RESIDUAL LEGACY/UNKNOWN POPULATION**

## 13. Catalog feedback from migration execution

Migration execution can reveal genuine catalog defects, but field inconvenience alone is not permission to modify a reusable block.

Examples:

- repeated inability to distinguish board variants is normally a board/configuration/DFT identity problem;
- recurring connector remap mistakes belong to connection/integration records when the generic electrical contract is unchanged;
- a recurring real electrical incompatibility may justify a reusable adapter;
- a generic block behavior that contradicts its published contract is a block defect and triggers normal requalification/`SHOW WHERE USED` handling.

Preserve the OpenPressBrake rule: compatible interfaces connect in board integration; real reusable transformations belong in adapters; reusable blocks change only on generic engineering grounds.

## 14. OpenPressBrake worked governance example

The inspected `relay_contactor_driver` is a one-coil reusable primitive. Its current manifest deliberately leaves the released controller current, simultaneous-instance assumptions, final connector/contact rating, PCB geometry and branch protection to board-level qualification. The current 3V3 handoff provides a conservative **4.2 mA maximum `LOGIC_3V3` source-capacity allocation plus 100 nF local bypass per populated primitive**, while explicitly warning that this is a source-sizing bound rather than expected consumption and does not establish a released coil/channel rating.

That is useful migration governance. A future board generation could legitimately change instance count, connector mapping, branch protection or FPGA-to-instance mapping without rewriting the reusable primitive. A serialized migration work package would need the exact board-specific target and would aggregate the published reusable resource contract for the actual population.

A field unit whose actual relay/contactor load, harness, connector or unusual suppression is undocumented remains `VERIFY_AT_MACHINE`; a fleet spreadsheet must not invent those facts merely to increase convergence percentage.

The block itself remains `SIMULATION-READY`, not production released. No real OpenPressBrake fleet, released migration, serial population or field action is asserted here.

## 15. Cross-machine reuse

The same method applies to mills, lathes, plasma tables, routers, robots, press brakes and custom automation. The configuration details differ, but every migration benefits from exact pre/post identity, bounded compatibility, verification by changed semantic facet, preserved negative evidence, and honest residual-population accounting.

## 16. Safety boundary

This lesson covers ordinary controller hardware/configuration migration. Ordinary LinuxCNC/FPGA status or inhibit functions do not become independent personnel-safety authority because they are included in a migration work package.

If a migration touches an independent safety architecture, its required safety-rated change control and validation are separate. A correct ordinary controller profile proves only the bounded ordinary controller behavior actually verified.

> **FLEET CONVERGED != PERSONNEL-SAFETY FUNCTION REVALIDATED**

---

## Lab — eight adversarial migration-execution cases

Use a fictional controller family deployed across several machine classes.

### Case 1 — work order closed, wrong profile installed

A replacement board is installed and the machine communicates, but post-check reveals the FPGA image belongs to another board variant. Classify state and define recovery evidence.

### Case 2 — partial harness migration

A technician installs the new board but only half of the required harness adapter changes are completed before the visit ends. Preserve the intermediate state and prevent false old/new identity.

### Case 3 — successful rollback

A new configuration develops an intermittent field issue and the unit is restored to an explicitly supported prior configuration. Record the forward failure and the verified rollback without counting the unit as target-converged.

### Case 4 — unreachable machine

A machine in the bounded population cannot be inspected during rollout. Show how it remains visible in the denominator/residual state rather than disappearing from the report.

### Case 5 — undocumented legacy modifications

Pre-change inspection finds an unrecorded jumper and substitute component. Stop, classify ownership and define engineering disposition before migration.

### Case 6 — functional pass with uncertain identity

I/O tests pass, but the programmed-image hash and board option cannot be established. Explain why the unit is not `VERIFIED_TARGET`.

### Case 7 — misleading rollout metric

Ninety-eight of 100 scheduled work orders are closed, but five units were rolled back, three have unresolved exceptions and ten additional legacy units were never included in the original schedule. Build honest convergence metrics.

### Case 8 — genuine generic defect discovered during migration

Several machine classes expose the same violation of a reusable block's published generic contract. Route the finding to block engineering, identify affected semantic facets and `SHOW WHERE USED`, and keep machine-specific migration history outside the reusable manifest.

For each case submit:

- bounded population/applicability basis;
- exact pre-change identity;
- intended target identity;
- serialized work-package state;
- actions actually completed;
- identity/structural/electrical/functional verification;
- preserved negative evidence;
- resulting as-maintained identity;
- exception/rollback state;
- convergence classification;
- `VERIFY_AT_MACHINE` facts;
- reusable-block/adapter/board-integration ownership;
- safety-authority statement.

### Lab pass criteria

A passing submission must distinguish planned, attempted, changed-unverified, verified-target, rollback, exception and unknown states; capture pre-change identity before modification; fail closed on wrong/ambiguous FPGA-HAL matching; preserve failed attempts; treat rollback as configuration history; update as-maintained identity per unit; calculate convergence from evidence rather than work-order activity; retain unreachable/unknown assets visibly; and refuse unsupported production or personnel-safety claims.

---

## Catalog stress-test result

BD37 exposes a concrete execution infrastructure need. Future tooling should provide a serialized migration ledger joined to the BD36 compatibility graph with:

- asset/unit identity;
- applicability decision and provenance;
- pre-change as-maintained configuration;
- target release/board/BOM/options;
- block/adapter/connection revisions;
- FPGA/toolchain/image/resource-map identity;
- LinuxCNC/HAL/machine-configuration identity;
- work-package/procedure revision;
- `VERIFY_AT_MACHINE` observations;
- actual actions and intermediate state;
- verification/evidence references;
- failure/exception/rollback history;
- final as-maintained identity;
- convergence classification;
- residual support/retirement state.

Fleet dashboards must be derived from this evidence ledger rather than maintained as an independent optimistic spreadsheet.

Do not place serialized fleet history in reusable block manifests. Reusable manifests own generic engineering contracts; the migration ledger owns unit/population history.

Current OpenPressBrake does not yet provide this repository-wide serialized migration ledger or an evidence-backed installed population. Keep this gap `ENGINEERING_REVIEW_NEEDED`; do not invent serial assets or field migrations.

## Durable freezes

- `WORK ORDER CLOSED != CONFIGURATION CONVERGED`
- `EXPECTED OLD CONFIGURATION != OBSERVED PRE-CHANGE CONFIGURATION`
- `NEW BOARD INSTALLED != TARGET CONFIGURATION INSTALLED`
- `PROGRAMMING SUCCESS != CORRECT PROFILE`
- `FUNCTIONAL PASS != CONFIGURATION IDENTITY PROVED`
- `RETRY PASS != FIRST ATTEMPT NEVER FAILED`
- `SERVICE RESTORED != TARGET MIGRATION COMPLETE`
- `ROLLOUT COMPLETION % != EVIDENCE-BACKED FLEET CONVERGENCE`
- `NOT REACHED != NOT AFFECTED`
- `NO OPEN WORK ORDERS != NO RESIDUAL LEGACY/UNKNOWN POPULATION`
- `FLEET CONVERGED != PERSONNEL-SAFETY FUNCTION REVALIDATED`

## Next exact work

Build BD38 on **fleet-closure audit, residual support states, and evidence-backed legacy retirement**: migration ledger -> reconciliation audit -> unresolved identity/finding closure -> support-state classification -> spare/tool/software retention -> evidence archive -> retirement authorization -> future `SHOW WHAT IS INSTALLED` / field-action discoverability.

Stress units administratively retired but still physically installed, lost serial traceability, unsupported legacy boards that remain operational, service stock with obsolete FPGA/HAL tooling, archived evidence that can no longer reproduce a programmed image, and the difference between ending migration work and retiring support obligations.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was justified for BD37. No GitHub-hosted runner was used. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.