# BD38 — Fleet-Closure Audit, Residual Support, and Evidence-Backed Legacy Retirement

## Purpose

BD37 taught evidence-backed migration execution. BD38 teaches the harder end-state question: when may migration work stop, what legacy configurations must still be supported, and what evidence is required before a configuration can be retired without destroying future field-action discoverability?

The governing flow is:

`migration ledger -> reconciliation audit -> unresolved identity/finding closure -> support-state classification -> spare/tool/software retention -> evidence archive -> retirement authorization -> future SHOW WHAT IS INSTALLED / field-action discoverability`

This lesson develops both linked skills. **Block engineering** must preserve generic contracts and evidence needed to understand old revisions without stuffing fleet history into reusable manifests. **Board integration** must preserve exact board/FPGA/HAL/harness/configuration identity and supportability across installed and retired populations.

OpenPressBrake is used only as a current governance example. It is not represented as production-proven hardware or as having a real installed fleet.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD37_MIGRATION_EXECUTION_EVIDENCE_AND_FLEET_CONVERGENCE.md` — serialized migration state, residual population, rollback, as-maintained identity and convergence rules.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD38 — board-lane status and exact next work.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — readiness evidence and truthfulness gates.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable block, adapter and board-integration ownership.
- OpenPressBrake `hardware/blocks/dry_contact_relay_output/STATUS_CHECKLIST.md` — current unresolved CAD/PCB/machine/release gates.
- OpenPressBrake `hardware/blocks/dry_contact_relay_output/CAD_CAPTURE_HANDOFF_REV1.md` — frozen electrical capture input, installed-toolchain verification requirement, abstract reusable contacts and explicit ordinary-control safety boundary.

The dry-contact relay material is not assigned as finished production hardware. It remains `NOT READY`; installed KiCad symbol/footprint verification, rendered schematic/ERC, actual PCB current geometry, first-machine mapping, creepage/clearance, source/thermal qualification and human release evidence remain open. For production use it is `ENGINEERING_REVIEW_NEEDED`.

---

## 1. Target convergence and support retirement are different decisions

A migration can reach its target while support obligations remain for legacy configurations. Conversely, management can stop active migration work without proving the legacy population disappeared.

Keep at least these questions separate:

1. Did each applicable asset reach a known as-maintained state?
2. Which known legacy states remain physically installed?
3. Which states are still supported for operation, repair, rollback, investigation or field action?
4. Which states are retired, and what evidence proves retirement?

> **MIGRATION WORK ENDED != LEGACY SUPPORT RETIRED**

## 2. Reconcile the population before closure

Perform a fleet-closure audit against the serialized migration ledger, not against work-order counts. Every bounded asset must reconcile to evidence such as:

- `VERIFIED_TARGET`;
- verified supported legacy/rollback state;
- known unsupported-but-installed state under explicit disposition;
- evidence-backed `NOT_APPLICABLE`;
- physically removed/decommissioned with provenance;
- transferred/sold with traceable disposition when relevant;
- unresolved/unknown state that remains visibly open.

An administrative database flag is not enough if physical disposition is material.

> **ADMINISTRATIVELY RETIRED != PHYSICALLY REMOVED**

## 3. Unknown identity remains a live obligation

Lost serial labels, undocumented board swaps, inaccessible machines and corrupted configuration records do not become harmless at project closure.

For every unknown state record:

- what population relationship is known;
- what identity facets are missing;
- why the asset cannot currently be resolved;
- what inspection/evidence would resolve it;
- what containment or support restrictions apply meanwhile;
- who owns disposition authority.

Do not infer the newest or most common configuration.

> **UNKNOWN CONFIGURATION != RETIRED CONFIGURATION**

## 4. Use explicit residual support states

A useful lifecycle vocabulary is:

- `CURRENT_SUPPORTED` — normal supported target configuration;
- `LEGACY_SUPPORTED` — older configuration intentionally supported within a defined envelope;
- `SERVICE_ONLY` — no new builds, but bounded service/repair remains authorized;
- `ROLLBACK_ONLY` — retained only as an explicitly supported recovery state;
- `UNSUPPORTED_INSTALLED` — known installed configuration without a support claim; requires explicit operational/field disposition;
- `RETIREMENT_PENDING` — retirement intended but physical/configuration evidence incomplete;
- `RETIRED_VERIFIED` — removal/decommissioning and required records established;
- `UNKNOWN_UNRESOLVED` — identity or disposition insufficient to classify safely.

The state must attach to an exact configuration identity or bounded family/envelope, not merely a marketing generation name.

## 5. A support claim requires retained capability

If a configuration is still supported, retain enough capability to perform the support actually promised. Depending on the system this may include:

- exact FPGA/firmware images and hashes;
- source revision and reproducible build instructions or a deliberately bounded binary-only support policy;
- toolchain/version/container/VM identity where material;
- LinuxCNC/HAL/machine configuration;
- board/BOM/adapter/connection definitions;
- programming cable/interface requirements;
- calibration/configuration data format;
- test procedure and limits;
- approved spare/alternate identities;
- required fixture/adapter hardware;
- known machine-side `VERIFY_AT_MACHINE` requirements.

Do not claim support that depends on tooling, credentials, files or hardware that no longer exists.

> **ARCHIVED BINARY EXISTS != SUPPORT CAPABILITY EXISTS**

## 6. Reproducibility must be proved or its loss bounded

For programmable logic and software, distinguish:

- exact archived released binary available;
- binary hash/identity independently verifiable;
- source and toolchain capable of reproducing an equivalent artifact;
- source exists but historical toolchain is unavailable;
- image exists but programming path is unavailable;
- neither image nor reproducible source remains.

Do not silently describe the last three states as fully supported. If exact rebuild reproducibility is intentionally not required because a verified immutable released binary is the support artifact, state that policy and preserve the programming/verification path.

> **SOURCE ARCHIVED != RELEASE REPRODUCIBLE**

## 7. Service stock has configuration identity too

A spare board on a shelf is not automatically usable. Record or verify:

- board/BOM/options;
- approved substitutions;
- FPGA/firmware state or required programming procedure;
- compatible HAL/configuration generations;
- adapters/harnesses needed for each supported installation;
- storage-life or calibration constraints where applicable;
- test status and evidence;
- support-state applicability.

A legacy spare that can no longer be programmed or verified may be inventory but not a defensible service capability.

> **SPARE ON SHELF != SUPPORTED SPARE**

## 8. Preserve evidence needed for future field actions

Retirement must not erase history needed to answer future questions such as:

- Which installed or formerly installed assets consumed block revision X?
- Which units used alternate component Y?
- Which machines carried FPGA image Z or HAL mapping Q?
- Which units were rolled back after a failed migration?
- Which units were physically removed before a later field action?

Preserve `SHOW WHERE USED` engineering dependencies and `SHOW WHAT IS INSTALLED` / historical as-maintained records as distinct but joinable evidence.

> **RETIRED FROM SUPPORT != ERASED FROM TRACEABILITY**

## 9. Negative evidence remains evidence

Failed updates, rejected substitutions, abnormal bench findings, wrong-profile detections, rollback reasons and unresolved machine observations must remain linked to the configuration history after retirement.

Do not compress history into only the final successful state. Future failure analysis may depend on knowing what was attempted and rejected.

## 10. Retirement authorization requires explicit gates

Before `RETIRED_VERIFIED`, require evidence appropriate to the claimed retirement boundary. A defensible gate normally asks:

1. Is the applicable installed population reconciled?
2. Are unknown/unreachable units resolved or explicitly dispositioned by proper authority?
3. Is physical removal/decommissioning established where required?
4. Are service stock and rollback obligations reconciled?
5. Are active field actions/nonconformances closed or transferred to a retained authority?
6. Is historical configuration/evidence archived and discoverable?
7. Are required legal/regulatory/contractual retention obligations handled by the responsible process?
8. Does retirement avoid falsely changing reusable-block engineering history?

> **NO PLANNED SERVICE != RETIREMENT AUTHORIZED**

## 11. Unsupported-but-installed is a real state

A machine may remain operational after engineering support ends. Do not hide that state by calling the board retired.

`UNSUPPORTED_INSTALLED` should remain discoverable and carry explicit restrictions/disposition. The curriculum does not prescribe a business or safety decision for such an asset; it requires configuration truthfulness so the proper authority can make one.

If a future field action applies to its consumed semantic facets, the asset must still be findable.

## 12. Block history and fleet history remain separate

Fleet retirement is not permission to delete old reusable block contracts or rewrite them to match the current catalog head.

Preserve enough old block/adapter/board/configuration identity to interpret historical evidence. Generic engineering consequences discovered during retirement may justify a new block revision, but machine retirement facts belong in configuration/service records.

The OpenPressBrake architecture rule still applies: compatible interfaces connect in board integration; meaningful reusable transformations belong in adapters; generic blocks change only for generic engineering reasons.

## 13. OpenPressBrake worked governance example

The inspected `dry_contact_relay_output` demonstrates why lifecycle identity must bind more than a block name. Its electrical capture input is frozen around K1 `G5Q-1 DC24`, Q1 `2N7002BK`, D1 `BAS21GW-Q`, R1 1 kOhm and R2 100 kOhm, while the physical field connector remains board integration. The handoff explicitly requires installed KiCad symbol/footprint verification before schematic-ready status and forbids changing manufacturer-backed electrical connectivity merely to fit a CAD asset.

A future service policy could not truthfully say “dry-contact relay supported” without identifying the actual board revision, connector mapping, programmed controller configuration, applicable load envelope and retained verification/programming capability. Likewise, a shelf spare with the right relay but an unknown PCB/profile would not establish supportability.

The current block remains `NOT READY`; no released OpenPressBrake population, service stock, support state or retirement action is asserted here.

## 14. Cross-machine reuse

The same closure method applies to mills, lathes, plasma tables, routers, robots, press brakes and custom automation. Different machines retain different spares and toolchains, but configuration truthfulness, evidence-backed retirement and historical discoverability remain the same.

## 15. Safety boundary

This lesson governs ordinary controller lifecycle/configuration evidence. It does not authorize retirement of an independent personnel-safety function, define PL/SIL/category, or replace safety validation/change-control requirements.

A legacy ordinary controller being `RETIRED_VERIFIED` says nothing about whether an independent safety system may be retired, modified or credited.

> **CONTROLLER SUPPORT RETIRED != SAFETY FUNCTION RETIRED**

---

## Lab — eight adversarial fleet-closure cases

Use a fictional controller family deployed across multiple machine classes.

### Case 1 — administratively retired, still installed

An asset is marked retired in the service database, but a later photo shows the controller still operating. Reconcile physical and administrative evidence and classify the support state.

### Case 2 — lost serial traceability

A legacy board has no readable serial label and its service record cannot establish board option or FPGA image. Define the minimum evidence needed before retirement or support classification.

### Case 3 — unsupported but operational

A machine remains in production with a known legacy configuration after formal engineering support ends. Preserve discoverability and define what must not be claimed.

### Case 4 — obsolete programming tool

Several verified legacy spares exist, but the only known programmer/toolchain no longer runs. Decide whether the service claim remains defensible and what remediation evidence is needed.

### Case 5 — archived source, unreproducible image

Source is present but the historical FPGA toolchain is missing and a rebuild does not match the released image. Distinguish source retention, binary retention and reproducibility.

### Case 6 — shelf spare with unknown profile

A board is labeled as a spare for two machine variants, but its FPGA/HAL compatibility is not established. Prevent inventory presence from becoming a support claim.

### Case 7 — migration closed with residual unknowns

All scheduled work orders are closed, but three machines are unreachable and one sold machine has uncertain disposition. Decide whether target convergence, migration closure and legacy retirement can each be claimed.

### Case 8 — later field action after retirement

A generic block defect is discovered two years after one board generation was retired. Show how preserved engineering dependency and historical as-maintained records identify formerly installed, removed, unsupported-installed and unknown assets without rewriting block history.

For each case submit:

- bounded population and applicability provenance;
- exact known configuration identity;
- missing/unknown semantic facets;
- support-state classification;
- installed/removed/retired evidence;
- retained image/source/toolchain/HAL/fixture/spare capability;
- negative evidence and unresolved findings;
- future field-action discoverability;
- block/adapter/board-integration ownership;
- `VERIFY_AT_MACHINE` items;
- retirement authority/gates still open;
- safety-authority statement.

### Lab pass criteria

A passing submission must separate target convergence from support retirement; refuse to infer physical removal from an administrative flag; keep unknown and unsupported-installed assets visible; distinguish archived artifacts from reproducible/supportable configurations; treat service stock as configuration-controlled; preserve historical and negative evidence; keep `SHOW WHERE USED` joinable to historical `SHOW WHAT IS INSTALLED`; and refuse unsupported production or personnel-safety claims.

---

## Catalog stress-test result

BD38 exposes a lifecycle infrastructure need above the reusable catalog. Future tooling should join the BD36 compatibility graph and BD37 serialized migration ledger to a **support/retirement registry** containing:

- exact configuration identity/envelope;
- current/legacy/service-only/rollback/unsupported/retirement state;
- installed and historical asset applicability;
- physical disposition evidence;
- retained board/BOM/adapter/connection definitions;
- FPGA/firmware binary identity and hashes;
- source/toolchain/reproducibility status;
- LinuxCNC/HAL/machine configuration identity;
- programming/test/fixture capability;
- service stock and approved-alternate applicability;
- open nonconformance/field-action relationships;
- negative evidence and rollback history;
- archive locations/retention authority;
- retirement authorization and provenance.

This information does not belong in reusable block manifests. Reusable blocks own generic electrical contracts; support/retirement records own population and lifecycle state.

Current OpenPressBrake does not establish a released installed population, service-stock system, support registry or retirement population. Keep this infrastructure need `ENGINEERING_REVIEW_NEEDED`; do not invent assets or support claims.

## Durable freezes

- `MIGRATION WORK ENDED != LEGACY SUPPORT RETIRED`
- `ADMINISTRATIVELY RETIRED != PHYSICALLY REMOVED`
- `UNKNOWN CONFIGURATION != RETIRED CONFIGURATION`
- `ARCHIVED BINARY EXISTS != SUPPORT CAPABILITY EXISTS`
- `SOURCE ARCHIVED != RELEASE REPRODUCIBLE`
- `SPARE ON SHELF != SUPPORTED SPARE`
- `RETIRED FROM SUPPORT != ERASED FROM TRACEABILITY`
- `NO PLANNED SERVICE != RETIREMENT AUTHORIZED`
- `UNSUPPORTED INSTALLED != RETIRED VERIFIED`
- `CONTROLLER SUPPORT RETIRED != SAFETY FUNCTION RETIRED`

## Next exact work

Build BD39 on **configuration evidence escrow, disaster recovery, and long-horizon reproducibility**:

`released/as-maintained identities -> authoritative artifact inventory -> integrity/hash/signature verification -> redundant archive/escrow -> toolchain/environment capture -> restore drill -> programming/test recovery -> evidence of reproducibility -> loss/degradation disposition`

Stress corrupted archives, missing proprietary tool installers/licenses, hashes without binaries, source without submodules/dependencies, VM/container drift, undocumented programmer hardware, calibration/test fixtures that cannot be recreated, and a disaster-recovery restore that boots but cannot prove the released FPGA/HAL identity.

No simulation, synthesis, place-and-route, timing run or other executable engineering verification is justified by BD38. Future executable engineering work remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.