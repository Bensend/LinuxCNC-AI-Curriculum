# BD59 — Evidence Consumption Locks, Release Manifests, and Stale-Proof Rejection

## Purpose

BD56–BD58 established dependency-driven invalidation, claim-specific preservation proofs, and proof lifecycle. BD59 closes the next gap: a release candidate must prove which exact current evidence it consumed.

`current claims + promoted evidence/proofs -> release evidence manifest -> exact consumption locks -> generation/release candidate -> dependency drift -> stale-proof rejection -> targeted recovery -> release promotion`

This applies to both BLOCK ENGINEERING and BOARD INTEGRATION. A green generator, valid schematic, successful synthesis, or passing HAL configuration is not enough if the candidate consumed stale, ambiguous, or superseded authority.

## Student-material readiness audit

Every repository file named below was opened and inspected in its CURRENT form during this run before use.

**VERIFIED_FOR_LESSON** for the bounded claims used:

- Curriculum `README.md` — provenance, reproducibility, uncertainty, and technical-handoff standard.
- Curriculum `WORK_SELECTION_POLICY.md` — evidence-gaining autonomous work selection.
- Curriculum `hardware/4000-board-design/BD58_EQUIVALENCE_PROOF_LIFECYCLE_REVIEW_EXPIRATION_AND_ASSUMPTION_DRIFT.md` — proof lifecycle and downstream staleness.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — board-design progress through BD58.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthful status, concrete evidence, maintenance, and CI limits.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable block / adapter / board-integration ownership.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/REV1_RESOURCE_CONTRACT.yaml` — current machine-readable one-port resource/integration handoff.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml` — current reusable electrical/resource/power/verification contract.

**ENGINEERING_REVIEW_NEEDED** as a complete current-status authority:

- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/STATUS_CHECKLIST.md` — its current evidence list does not name the already-current `REV1_RESOURCE_CONTRACT.yaml`. The checklist's bounded electrical/readiness claims remain usable, but the omission means a release consumer cannot prove complete current evidence discovery from the authoritative status surface alone. Under `STATUS_RULES.md`, material integration/evidence changes are expected to update the checklist in the same change.

No audited file is evidence that the OpenPressBrake controller is production-proven.

## Learning objectives

A student must be able to:

1. distinguish an evidence repository from the evidence actually consumed by a release candidate;
2. build a release evidence manifest with exact claim, authority, proof, configuration, generator, and output identities;
3. reject a candidate when any consumed proof is stale, blocked, superseded, or outside its scope;
4. distinguish release-wide invalidation from partial regeneration/revalidation;
5. preserve reusable-block evidence separately from board-specific connection/resource evidence;
6. carry unresolved physical-machine facts as explicit blockers rather than invented values;
7. trace evidence consumption forward into schematic, PCB, FPGA/gateware, LinuxCNC/HAL, and commissioning artifacts; and
8. keep ordinary-control evidence from acquiring personnel-safety authority.

## 1. Evidence existence is not evidence consumption

A repository may contain the correct datasheet calculation, current block contract, current board mapping, and a valid preservation proof while a generated candidate still consumes an older file or cached value.

Therefore:

**CURRENT EVIDENCE EXISTS ≠ CANDIDATE CONSUMED CURRENT EVIDENCE.**

**GENERATION SUCCEEDED ≠ INPUT AUTHORITY WAS CURRENT.**

**SCHEMATIC LOOKS RIGHT ≠ RELEASE EVIDENCE IS LOCKED.**

**SAME OUTPUT HASH ≠ SAME RELEASE AUTHORITY.**

The release candidate needs a durable record of the semantic inputs and promoted evidence it actually consumed.

## 2. Release evidence manifest

A release evidence manifest is not a BOM and not merely a list of source files. It is the candidate's claim-to-evidence lock.

At minimum record:

- candidate/release identity;
- exact repository revision(s);
- configuration identity/digest;
- each required claim/facet ID;
- authoritative source identity/digest for that facet;
- promoted evidence or preservation-proof ID and lifecycle state;
- negative scope and unresolved facts;
- reusable-block revision and selected variant;
- board-specific connection/resource-allocation identity;
- generator/toolchain identity;
- generated artifact identity/digest;
- reviewer/promotion authority; and
- dependency/invalidation triggers inherited from consumed evidence.

Example shape:

```yaml
candidate_id: board_rev1_candidate_004
claims:
  - claim_id: rs485.port0.resource_contract
    authority:
      path: hardware/blocks/modbus_rtu_rs485/REV1_RESOURCE_CONTRACT.yaml
      digest: exact_digest
    evidence_state: CURRENT
    scope: one_populated_nonisolated_port
    negative_scope:
      - physical_bus_end
      - installed_termination
      - shield_chassis_strategy
      - galvanic_isolation_requirement
artifacts:
  schematic:
    digest: exact_digest
    generated_from_manifest: exact_manifest_digest
promotion_state: CANDIDATE_NOT_RELEASED
```

A path without a digest/revision is not a lock. A digest without semantic identity is not enough either: consumers must know what claim the object supports.

## 3. Consumption states

For each required claim, classify the consumed evidence:

- `LOCKED_CURRENT` — exact current promoted evidence is consumed within scope.
- `LOCKED_CURRENT_NARROWED` — current proof is valid only for a narrower envelope and candidate stays inside it.
- `STALE_REJECT` — consumed evidence/proof has a triggered dependency.
- `BLOCKED_UNKNOWN` — release needs a physical/configuration fact that remains unresolved.
- `SUPERSEDED_REJECT` — a newer authority explicitly replaces the consumed one.
- `HISTORICAL_ONLY_REJECT` — retained provenance but forbidden as current release evidence.
- `NOT_REQUIRED` — claim is outside this candidate, with justification.

A release gate fails closed if a required claim has no unambiguous consumption state.

## 4. Release lock is semantic, not whole-repository pinning

Pinning a Git SHA is necessary provenance but does not prove that every artifact inside that commit is authoritative for every facet. BD51–BD58 already showed that authority can be facet-specific and that stale status surfaces can coexist with newer evidence.

The release manifest therefore locks both:

1. exact repository/object identity; and
2. the semantic authority relationship for the named claim.

This avoids two opposite errors:

- rejecting every candidate whenever any unrelated repository file changes; and
- accepting a candidate merely because its inputs came from one pinned commit even though one of those inputs was stale or superseded inside that commit.

## 5. Worked OpenPressBrake case: RS-485 resource handoff

Current OpenPressBrake `modbus_rtu_rs485/REV1_RESOURCE_CONTRACT.yaml` publishes one reusable nonisolated physical port per primitive instance. Per populated port it declares two FPGA outputs (`UART_TX`, `RS485_DE`), one FPGA input (`UART_RX`), one UART TX resource, one UART RX resource, one driver-enable resource, one differential A/B pair, <=3.0 mA operational `3V3` demand, and 0.1 uF local decoupling.

It also carries integration invariants: DE defaults inactive with the frozen 10-kOhm pull-down; 120-ohm termination is DNP unless physical bus-end evidence exists; external failsafe bias is not added by default; shield is not casually bonded to logic return; RS485_COM/reference requirements must be checked; and isolation is a separate engineered variant if required.

The current `manifest.yaml` independently agrees on the selected THVD1450DR nonisolated architecture, three single-ended FPGA GPIO resources, one UART TX/RX/DE set, <=3 mA `3V3` operating demand, 100-nF decoupling, DNP 120-ohm termination, and board-owned physical connector/shield decisions.

### 5.1 What a board candidate may lock now

For `N` populated ports, board resource aggregation may consume the current resource contract for:

- `2*N` FPGA outputs;
- `1*N` FPGA inputs;
- `N` UART TX, `N` UART RX, and `N` driver-enable logical resources;
- `N` differential A/B pairs;
- `3.0*N mA` maximum operational `3V3` demand; and
- `0.1*N uF` local decoupling.

That is reusable-block evidence. The board candidate must separately lock its actual population `N`, FPGA pin assignment, connector mapping, physical placement, and board power aggregation.

### 5.2 What remains release-blocking if required by the candidate

The resource contract deliberately leaves actual port count/device identities, protocol roles/addresses/baud, cable/topology, physical bus ends, existing termination/bias, COM/reference wiring, shield/chassis convention, isolation requirement, and harness condition as `VERIFY_AT_MACHINE`.

A release candidate that needs any of those facts cannot replace them with convenient defaults. For example, `termination = populated` requires evidence that the board is at a physical bus end. The reusable block's DNP default is not permission to guess topology.

### 5.3 Adversarial status-surface finding

The current authoritative `STATUS_CHECKLIST.md` describes the block as schematic-ready contract/reference-rebased and lists `manifest.yaml`, connectivity, BOM, validators, and workflow evidence. But its `Evidence currently present` section does not name the newly current `REV1_RESOURCE_CONTRACT.yaml`.

That does not make the new resource contract technically false. It demonstrates why release evidence discovery cannot be inferred from a checklist label alone. A candidate generator that only follows the status evidence list could miss the current board-resource handoff; a generator that scans for newest filenames could consume unreviewed material. Both are unsafe patterns.

Classification: **ENGINEERING_REVIEW_NEEDED** for joining authoritative status, semantic claim IDs, and release-consumption locks mechanically.

OpenPressBrake remains read-only here because this exact RS-485 integration surface is actively advancing on current main.

## 6. Stale-proof rejection algorithm

Before generation or release promotion:

1. resolve the candidate's required semantic claims;
2. resolve current authority for each claim/facet;
3. load only promoted evidence/proofs eligible for that claim;
4. evaluate BD58 lifecycle triggers against current dependencies;
5. reject `STALE_TRIGGERED`, `BLOCKED_UNKNOWN`, `SUPERSEDED`, and `HISTORICAL_ONLY` evidence;
6. confirm narrowed proofs contain the candidate's operating envelope;
7. lock exact evidence/authority/configuration digests into the release manifest;
8. generate artifacts using only those locked inputs;
9. record output/toolchain identities;
10. re-check dependency heads immediately before promotion; and
11. promote only if every required claim remains satisfied.

The second dependency check matters because evidence can change while generation/review is in progress.

## 7. Race-safe release promotion

A release pipeline must handle this race:

`lock evidence -> generate/review -> dependency changes -> promote old candidate`

Fail closed by recording the dependency head/digest set at lock time and comparing it again at promotion time. If a claim-relevant dependency changed, do not silently relabel the old candidate current.

Classify the change with BD56/BD58:

- irrelevant to candidate claims: preserve with recorded justification;
- equivalent for a named claim: require a current BD57 preservation proof;
- changed premise: stale affected claim and regenerate/revalidate minimum necessary artifacts;
- unresolved conflict: block promotion.

**PROMOTION CHECK MUST REVALIDATE THE LOCK, NOT JUST THE OUTPUT FILES.**

## 8. Selective recovery after rejection

One stale dependency does not automatically require rebuilding every engineering artifact.

Examples:

- RS-485 port count changes: re-solve aggregate FPGA GPIO/UART resources, `3V3` power, decoupling, connector population, and affected generated board artifacts. Do not redesign the reusable THVD1450 primitive.
- Physical bus-end evidence changes: update termination population and affected schematic/BOM/assembly/commissioning evidence; unrelated FPGA resource arithmetic may remain current.
- UART/gateware implementation changes: resource/timing/loopback evidence may stale while the frozen transceiver electrical topology remains current.
- Shield/chassis implementation changes: PCB/EMC/connector evidence may stale without changing UART logical resources.

Recovery should follow typed dependency edges and then issue a new candidate identity. Do not mutate the old release record to hide rejection history.

## 9. Generated artifacts need evidence locks too

A schematic, PCB, FPGA image, LinuxCNC/HAL configuration, or commissioning package should be traceable back to the release evidence manifest that generated/approved it.

For a complete controller, useful forward links include:

`claim -> evidence/proof -> release manifest -> connection/resource model -> schematic/PCB -> FPGA build -> LinuxCNC/HAL mapping -> bench/commissioning record`

This is the release-side complement to Show Where Used. Reverse lookup asks what depends on a claim. Forward consumption asks exactly what a candidate used.

## 10. Block versus board ownership remains intact

The RS-485 primitive owns its electrical function, THVD1450/SM712 topology, reset default, electrical envelope, per-port resource contract, and generic integration invariants.

The board-specific connection layer owns actual connector type/pins, populated count, FPGA ball mapping, physical board location, silkscreen, harness destination, topology-specific termination decision, shield/chassis implementation, and machine destination.

Do not make release locking easier by copying those board facts into the reusable block. The manifest should join separate authorities, not erase their boundaries.

## 11. Lab — build and break a release lock

Construct a hypothetical controller candidate with two RS-485 ports. Produce a release evidence manifest that locks the current reusable resource contract and separate board-specific allocations.

Then evaluate these events independently:

1. Port count changes from 2 to 3.
2. A machine survey proves port 1 is at a physical bus end.
3. A new gateware UART implementation changes LUT/register use but not external TX/RX/DE semantics.
4. The RS-485 block status checklist is updated to name the resource contract without changing its content.
5. THVD1450 electrical topology is unchanged, but board shield termination changes.
6. A new machine measurement shows ground-potential difference requires isolation.
7. An unrelated curriculum typo changes.

For each event submit: affected claim IDs, prior consumption state, lifecycle trigger, preserved evidence, stale evidence, required regeneration/revalidation, new candidate identity requirement, and promotion decision.

## 12. Catalog stress-test result

The current catalog increasingly publishes strong machine-readable block resource contracts, but release consumers still need a normalized layer that proves exactly which current claims/evidence were consumed.

Classification: **ENGINEERING_REVIEW_NEEDED** for a machine-readable release-evidence system supporting:

- stable claim/facet/evidence/proof IDs;
- exact authority and configuration digests;
- evidence lifecycle eligibility;
- reusable-block plus board-connection composition without ownership leakage;
- `VERIFY_AT_MACHINE` blockers;
- release candidate identities;
- generated-artifact/toolchain locks;
- forward evidence consumption and reverse Show Where Used;
- race-safe pre-promotion dependency recheck;
- selective invalidation/regeneration; and
- immutable rejection/renewal lineage.

Do not implement this as "use newest file," a single repository SHA, a checklist checkbox, or a whole-block current/stale flag.

## 13. Completion standard

A student passes BD59 only if they can build a candidate evidence manifest from current claim authority, reject stale or unresolved inputs, preserve only justified unaffected evidence, regenerate the minimum affected artifacts, and demonstrate that the promoted candidate consumed exactly the evidence it claims.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification is required for this methodology or the audited RS-485 status/resource-contract finding. No GitHub-hosted compute is authorized. If a future stale claim genuinely requires executable verification, use only `[self-hosted, openpressbrake]`.

## Safety boundary

BD59 concerns release evidence for ordinary board-design/controller functions. It does not establish PL/SIL/category, stopping performance, independent safety diagnostic coverage, final-element validation, or personnel-safety authority. Ordinary LinuxCNC/FPGA release evidence receives zero personnel-safety credit unless a separate safety-rated design and validation explicitly supports that claim.
