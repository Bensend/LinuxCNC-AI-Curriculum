# BD42 — Change-Wave Planning, Regression Ordering, and Release-Train Containment

## Purpose

BD41 taught semantic invalidation for one upstream change. Real controller development rarely changes one thing at a time. BD42 teaches how to handle several valid engineering changes without either rerunning everything independently or combining so much work that causality, rollback, and release authority disappear.

`multiple upstream changes -> dependency graph -> common affected consumers -> merge/separate change waves -> regression ordering -> candidate lineage -> partial promotion -> incompatible population handling -> rollback points -> release-train closure`

This lesson develops both linked skills. **Block engineering** must publish changes as bounded semantic deltas with evidence and independent qualification state. **Board integration** must compose those deltas into controlled waves, order regression by dependency, preserve candidate lineage, and prevent a partially validated release train from leaking into manufacturing or service.

OpenPressBrake is a current worked example and catalog stress test. It is not represented as production-proven or as having a released fleet.

## Hard student-material audit

The following current-main files were opened and inspected during this run:

- Curriculum `hardware/4000-board-design/BD41_RELEASE_DEPENDENCY_INVALIDATION_SEMANTIC_CHANGE_AND_CONTROLLED_REPROMOTION.md` — `VERIFIED_FOR_LESSON` for semantic invalidation and controlled re-promotion concepts.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — `VERIFIED_FOR_LESSON` for lane state and BD42 work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — `VERIFIED_FOR_LESSON` for evidence-backed status and same-change maintenance rules.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — `VERIFIED_FOR_LESSON` for reusable block/adapter/board-integration ownership.
- OpenPressBrake `.github/workflows/digital-output-24v-sim.yml` — `VERIFIED_FOR_LESSON` for the required `[self-hosted, openpressbrake]` execution boundary and current digital-output verification sequence.
- OpenPressBrake `hardware/blocks/digital_output_24v/integration/validate_rev1_board_contract.py` — `ENGINEERING_REVIEW_NEEDED` as a current active-engineering artifact; useful only as an explicitly bounded example of a newly expanded structural contract.
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — `ENGINEERING_REVIEW_NEEDED` because its current checkbox still says the Rev1 validator must be updated even though the inspected validator now enforces the listed isolation/BOM/domain rules.

The two digital-output engineering files are **not assigned as finished student material**. Their mismatch is used only as a live change-wave/catalog-maintenance defect. The active OpenPressBrake engineering lane owns reconciliation.

## 1. A change wave is an engineering unit, not a batch of commits

A **change wave** is the smallest set of semantic changes that should be qualified and promoted together because their evidence or consumers are materially coupled.

A wave is not defined by:

- a day of commits;
- one pull request;
- one engineer;
- one directory;
- one release milestone;
- every change currently waiting.

A defensible wave has explicit inputs, affected semantic facets, consumers, regression plan, candidate lineage, rollback boundary, and promotion authority.

> **SAME RELEASE DATE != SAME CHANGE WAVE**

> **SAME BOARD != ALL CHANGES MUST BE QUALIFIED TOGETHER**

## 2. Merge waves only when coupling is real

Two changes are good candidates for one wave when separating them would create false or duplicated evidence, for example:

- a power-contract change and the board power-budget update that consumes it;
- an FPGA resource-map change and the board mapping that must move with it;
- a component substitution plus the calculation/thermal envelope revision caused by that substitution;
- a reusable adapter revision and a board release whose old interface cannot consume the new adapter independently.

Keep changes in separate waves when independent qualification and rollback are valuable, for example:

- an unrelated connector pin remap and a generic block current-envelope change;
- two independent block revisions that merely happen to land on the same board;
- a documentation-only correction and a toolchain rebuild;
- a service-only migration change and an unrelated new-build-only feature.

> **COMMON CONSUMER != AUTOMATIC COMMON WAVE**

The question is whether the changes share causal evidence or must be promoted atomically, not whether they eventually meet on the same PCB.

## 3. Build the affected-consumer graph before ordering tests

For each proposed change record:

`change ID -> changed semantic facets -> direct consumers -> transitive consumers -> evidence invalidated -> candidate artifacts -> applicable populations`

Then overlay all changes. Shared consumers become visible before tests are scheduled.

The overlay should distinguish:

- `A_ONLY`
- `B_ONLY`
- `A_AND_B_SHARED`
- `UNAFFECTED`
- `UNKNOWN_DEPENDENCY`

Unknown dependency is not silently assigned to the shared set or unaffected set. It remains a blocker until resolved.

## 4. Regression ordering follows dependencies and diagnostic value

Do not begin with the most expensive whole-board test merely because it is available. Order regression so failures retain diagnostic value.

A useful default order is:

1. validate each changed reusable block's own affected generic claims;
2. validate changed adapters/shared resources;
3. validate board-specific connection/resource composition;
4. run structural checks such as connectivity, power/return-domain rules, FPGA allocation, ERC, and configuration identity;
5. run bounded executable electrical/FPGA checks justified by unresolved questions;
6. run cross-block/whole-board regression;
7. run LinuxCNC/HAL semantic mapping regression where affected;
8. run bench/machine checks only for claims that require physical evidence;
9. promote the exact candidate whose lineage matches the evidence.

If step 2 fails, do not bury the failure under a later kitchen-sink pass.

> **LATER INTEGRATION PASS != EARLIER FAILED CLAIM ERASED**

## 5. Candidate lineage must survive every partial pass

Every candidate must identify the exact set of semantic changes it contains.

Example lineage:

- `C0` — previously promoted baseline;
- `C1=A` — block change A only;
- `C2=B` — board mapping change B only;
- `C3=A+B` — combined candidate;
- `C4=A+B+fix(B)` — combined candidate after a regression finding.

Evidence from `C1` cannot be attached to `C3` unless the dependency analysis shows the tested claim remains equivalent. Evidence from `C3` cannot be used to claim that `C1` was independently valid.

> **SAME FEATURE SET != SAME CANDIDATE LINEAGE**

> **PASS ON SUPERSET CANDIDATE != PROOF OF EVERY SUBSET CANDIDATE**

## 6. Partial promotion is allowed only with explicit boundaries

A release train may contain several waves. One wave may become acceptable before another.

Partial promotion is defensible when:

- the promoted wave has complete applicable evidence;
- its artifact identity is immutable;
- unresolved waves are not accidentally included in the promoted artifact;
- downstream manufacturing/service systems can distinguish the promoted configuration;
- rollback remains defined;
- population applicability is explicit.

Do not call the entire train released because one wave passed.

> **ONE WAVE PROMOTED != RELEASE TRAIN CLOSED**

A combined binary or board revision that physically contains unqualified wave B prevents pretending that wave A alone was promoted.

## 7. Late failures reopen only what they actually invalidate

Suppose A and B passed their local checks, board integration passed, and a later whole-board test finds a shared interaction failure.

Record:

- the exact failing candidate;
- the failed proposition;
- whether A, B, or their interaction is implicated;
- evidence that remains valid;
- evidence made stale by the fix;
- the new candidate lineage;
- the regression boundary for the fix.

Do not erase earlier passes. Do not preserve them blindly either.

> **FIX APPLIED != PRE-FIX EVIDENCE CURRENT**

A late interaction failure is often evidence that the catalog or integration contracts failed to publish a coupling assumption. Feed that defect back to the correct architectural layer.

## 8. Rollback points are configuration identities

A rollback point is not `git revert` and not `install the old board`.

A usable rollback point binds the supported combination of:

- board/revision and populated options;
- reusable block/adapter revisions consumed;
- connector/harness mapping;
- FPGA image/resource map/toolchain identity;
- LinuxCNC/HAL/machine configuration;
- required service/programming artifacts;
- known population applicability;
- evidence proving the rollback state remains authorized.

Rollback from a failed combined wave may return to `C0`, `C1`, or another supported intermediate state. The choice depends on compatibility evidence, not convenience.

## 9. Populations may move on different waves

New build, depot service, field retrofit, legacy supported equipment, and unreachable/unknown assets can have different compatibility constraints.

A wave record should state at least:

- `NEW_BUILD`
- `SERVICE_REPLACEMENT`
- `FIELD_RETROFIT`
- `ROLLBACK_ONLY`
- `NOT_APPLICABLE`
- `UNKNOWN_REQUIRES_RECONCILIATION`

A release train is not closed merely because new production converged. Residual service or installed populations remain explicit.

> **NEW BUILD CONVERGED != INSTALLED POPULATION CONVERGED**

## 10. Board-only changes do not force generic block requalification

A connector pin moves from J4-3 to J4-5 while the connected block's electrical/semantic contract is unchanged. That is board integration. Recheck the connection definition, silkscreen, harness, fixture, documentation, FPGA mapping if applicable, and affected board release evidence.

Do not revise or requalify the reusable block merely to make the release train look uniform.

Conversely, if the change adds level shifting, isolation, filtering, or protection, use the block/adapter/integration decision test. Real circuitry does not become a board-only change because it arrived during a connector revision.

## 11. Current OpenPressBrake stress test — active digital-output wave

Current OpenPressBrake main advanced through an isolated digital-output Rev1 BOM/contract change and then added the Rev1 board-contract validator to the self-hosted digital-output workflow. The inspected workflow correctly targets `runs-on: [self-hosted, openpressbrake]`.

The inspected validator now checks, among other things, L7/L07 field-domain ownership, the prohibition on L07-to-L06/logic-ground bridging, STISO620/STISO621 population and pin-domain rules, frozen isolation/support BOM identities, the `SWITCHED_IO_5V` field-side regulator contract, X-axis ordinary-command mapping, retained direct Pilz drive-enable ownership, and required PCB-release gates.

The inspected `STATUS_CHECKLIST.md`, however, still contains an unchecked item saying `integration/validate_rev1_board_contract.py` must be updated to fail on L07/L06 bridge, unswitched `SWITCHED_IO_5V`, wrong regulator divider/pins, or missing isolation topology. The current validator plainly implements substantial portions of that requirement.

This is `ENGINEERING_REVIEW_NEEDED`. It does **not** prove every intended structural case has been tested, nor does it justify checking the box from curriculum automation. It does prove that status/evidence reconciliation is part of closing a change wave. `STATUS_RULES.md` requires material integration results to update the block checklist in the same change.

The curriculum therefore records the defect and leaves OpenPressBrake read-only because this exact block is under active engineering.

## 12. Safety boundary

Change-wave management for ordinary LinuxCNC/FPGA controller hardware does not create personnel-safety authority. A wave may include an ordinary safety-status monitor or operational handshake, but its regression/promotion does not validate the independent safety function, stopping performance, final elements, PL/SIL/category, or hazardous-energy control.

> **RELEASE TRAIN CLOSED != INDEPENDENT SAFETY FUNCTION VALIDATED**

## Lab — five adversarial release trains

Use a fictional controller family shared across a mill, lathe, plasma table, router, robot cell, and press brake.

### Train A — simultaneous power and FPGA changes
A block's 5 V load allocation increases while an unrelated FPGA pin-bank remap occurs. Decide whether to merge or separate waves, identify shared board consumers, order checks, and define rollback.

### Train B — two block revisions touch one board
A digital-output protection revision and encoder-input termination revision both affect the same board. Avoid assuming common PCB consumption means common qualification.

### Train C — connector-only board change
A field connector pinout changes with no electrical transformation. Keep generic blocks unchanged and identify board/harness/fixture/service regression.

### Train D — late shared failure
Two local block regressions pass, then whole-board testing exposes a shared 3V3 rail transient. Preserve valid local evidence, invalidate the shared assumption, create a corrected candidate lineage, and rerun the bounded affected set.

### Train E — split service population
A new board/FPGA package is valid for new builds and one machine family but a legacy service population cannot accept the new harness. Define partial promotion, service-only legacy support, incompatible population handling, and release-train closure criteria.

For each train submit the change graph, merge/separate rationale, candidate lineage, ordered regression plan, preserved/stale evidence, promotion boundary, rollback identity, population applicability, `VERIFY_AT_MACHINE` facts, and safety-authority statement.

### Lab pass criteria

A passing submission minimizes redundant verification **without** destroying causality; keeps reusable blocks separate from board-specific connection changes; orders regression from changed claims toward integration; preserves exact candidate lineage; treats partial promotion as bounded authority; keeps incompatible/unknown populations visible; and never turns ordinary-controller release evidence into personnel-safety validation.

## Catalog stress-test result

BD42 exposes a missing release-management capability above the reusable catalog: a machine-readable **change-wave/release-train ledger** should join:

- change-wave ID and constituent semantic change IDs;
- old/new stable semantic facet identities;
- direct/reverse dependency graph snapshot;
- merge/separate rationale;
- candidate lineage and exact artifact/configuration digests;
- ordered regression nodes and prerequisites;
- preserved/stale/failed evidence with rationale;
- block requalification versus board re-promotion ownership;
- partial-promotion authority and unresolved-wave quarantine;
- rollback configuration identities;
- new-build/service/field/as-maintained applicability;
- incompatible/unknown populations;
- `VERIFY_AT_MACHINE` dependencies;
- closure authority and retained negative evidence.

This belongs above generic block circuitry. Reusable blocks publish stable contracts and evidence; release infrastructure composes independent changes without contaminating those contracts.

The current digital-output checklist/validator drift is a concrete wave-closure defect. Active OpenPressBrake engineering should reconcile the checklist against the exact validator coverage and actual self-hosted run evidence before claiming that structural gate closed.

## Durable freezes

- `SAME RELEASE DATE != SAME CHANGE WAVE`
- `COMMON CONSUMER != AUTOMATIC COMMON WAVE`
- `LATER INTEGRATION PASS != EARLIER FAILED CLAIM ERASED`
- `SAME FEATURE SET != SAME CANDIDATE LINEAGE`
- `PASS ON SUPERSET CANDIDATE != PROOF OF EVERY SUBSET CANDIDATE`
- `ONE WAVE PROMOTED != RELEASE TRAIN CLOSED`
- `FIX APPLIED != PRE-FIX EVIDENCE CURRENT`
- `NEW BUILD CONVERGED != INSTALLED POPULATION CONVERGED`
- `RELEASE TRAIN CLOSED != INDEPENDENT SAFETY FUNCTION VALIDATED`

## Next exact work

Build BD43 on **release-train observability, gate dashboards, and exception authority**:

`change waves -> gate graph -> machine-readable status -> evidence freshness -> blocked/waived/failed states -> exception authority -> expiry/revalidation -> promotion visibility -> audit reconstruction`

Stress a green dashboard built from stale evidence, a waiver with no expiry, a skipped self-hosted FPGA check, a board-only exception incorrectly mutating a reusable block status, and a safety-related ordinary monitor whose exception must not imply safety-function acceptance.

## Compute

No new simulation, synthesis, place-and-route, timing run, or other executable engineering verification was needed to write BD42. The inspected OpenPressBrake workflow itself targets `[self-hosted, openpressbrake]`. No GitHub-hosted compute was used by this curriculum run.