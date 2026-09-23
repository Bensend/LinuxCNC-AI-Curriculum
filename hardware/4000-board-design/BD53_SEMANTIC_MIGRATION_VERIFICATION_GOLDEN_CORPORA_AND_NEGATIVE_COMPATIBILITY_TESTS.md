# BD53 — Semantic Migration Verification, Golden Corpora, and Negative Compatibility Tests

## Purpose

BD52 defined how semantic schemas may evolve without rewriting engineering history. BD53 defines how to prove that a migration implementation actually preserves what it claims to preserve and rejects what it cannot know:

`migration rules -> representative historical corpus -> expected canonical outputs -> negative/ambiguous cases -> round-trip/loss checks -> consumer-impact oracle -> regression gate -> migration release`

A parser that accepts every historical file is not necessarily a safe migration tool. A transform can preserve syntax while losing units, provenance, authority scope, unresolved state, return-domain ownership, default behavior, or safety-boundary meaning. Migration verification therefore needs both positive golden cases and deliberately invalid/ambiguous negative cases.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD52_SEMANTIC_SCHEMA_EVOLUTION_BACKWARD_COMPATIBILITY_AND_MIGRATION_SAFETY.md` — **VERIFIED_FOR_LESSON** for schema-change classes, migration constraints, immutable historical identity, dual-read rules, and old-schema retirement.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for the board-design handoff through BD52.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for evidence truthfulness, formal status, integration-versus-qualification separation, and status maintenance.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for reusable-block/adapter/board-integration ownership boundaries and fail-closed automation classification.
- OpenPressBrake `hardware/blocks/digital_output_24v/integration/REV1_ISOLATED_INTERFACE_BOM.yaml` — **VERIFIED_FOR_LESSON** for the current frozen isolation/support population, typed supply/return domains, scaling rules, provenance, and open KiCad gates.
- OpenPressBrake `hardware/blocks/digital_output_24v/integration/validate_rev1_board_contract.py` — **VERIFIED_FOR_LESSON** as current executable structural-validation source. It explicitly checks isolation directionality, supply/return domains, population scaling, no-ground-bridge rules, ordinary-control safety boundary, and remaining physical gates.
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — **ENGINEERING_REVIEW_NEEDED** for current progress reporting because it still leaves `integration/validate_rev1_board_contract.py` update unchecked even though the current validator already contains the named Rev1 isolation/BOM/domain assertions. The checklist remains valid for the broader claim that the block is not yet schematic-ready or Rev-1 released.

The checklist discrepancy is used only as inspected catalog-defect evidence. It is not presented as proof that the validator has executed successfully on the required panel runner. Source presence and source inspection are not execution evidence.

## Learning objectives

The student must be able to:

1. build a migration corpus from exact historical evidence rather than invented examples alone;
2. distinguish golden positive fixtures from negative and ambiguous fixtures;
3. define an expected canonical semantic output independent of incidental serialization;
4. prove exact unit/precision transforms at engineering decision boundaries;
5. test preservation of provenance, authority state, unresolved facts, and supersession state;
6. design negative tests that prove the migrator rejects unsupported return/default/resource/safety ownership;
7. understand why round-trip success is necessary in some migrations but insufficient by itself;
8. define a consumer-impact oracle for dependency and evidence invalidation;
9. detect stale fixtures and status/reporting drift; and
10. release a migration only when both acceptance and rejection behavior are demonstrated.

## 1. Verification target: semantic behavior, not parser success

A migration validator shall answer at least four different questions:

1. **Can the old artifact be parsed?**
2. **Can its proven semantics be represented in the new schema?**
3. **Are unproven semantics kept unresolved instead of guessed?**
4. **Do downstream consumers receive the correct stale/preserve/block decision?**

These are not interchangeable.

**PARSES SUCCESSFULLY ≠ MIGRATES SAFELY.**

**MIGRATES WITHOUT ERROR ≠ PRESERVES ENGINEERING MEANING.**

**POSITIVE FIXTURES PASS ≠ AMBIGUITY FAILS CLOSED.**

A useful regression suite must prove both what the migrator accepts and what it refuses to manufacture.

## 2. Corpus classes

Maintain explicit classes rather than one undifferentiated fixture directory.

### `GOLDEN_HISTORICAL`

Exact historical records with known original schema, source revision, authority scope, and expected migrated semantic view.

Use these to prove harmless renames, exact unit transforms, known authority relationships, and reconstructable semantic splits.

### `GOLDEN_CURRENT`

Current-authority examples expressed directly in the target schema. These prove that migration output agrees with the semantics consumed by current design tooling without pretending current files were historical inputs.

### `NEGATIVE_CONTRADICTION`

Inputs that contain mutually incompatible claims. Expected result: explicit contradiction/failure, not last-value-wins behavior.

### `NEGATIVE_AMBIGUOUS`

Inputs where more than one new semantic interpretation is plausible. Expected result: unresolved/block, not guessed selection.

### `NEGATIVE_MISSING_EVIDENCE`

Inputs lacking evidence for a newly required facet. Expected result: `UNKNOWN`, `VERIFY_AT_MACHINE`, `ENGINEERING_REVIEW_NEEDED`, or `NOT_APPLICABLE` only when non-applicability is itself justified.

### `BOUNDARY_PRECISION`

Values chosen near limits where unit conversion, rounding, integer encoding, tolerance, or precision loss could change an engineering decision.

### `CONSUMER_IMPACT`

Fixtures designed to prove whether a changed semantic facet correctly preserves, stales, or blocks dependent evidence and generated artifacts.

## 3. Every fixture needs provenance

A fixture is engineering evidence only when its origin is known.

For each historical fixture retain at least:

- fixture ID;
- original schema ID/version;
- exact repository/source revision or released artifact identity;
- authority owner/scope;
- evidence class;
- expected canonical semantic result;
- expected unresolved facts;
- expected migration classification;
- expected consumer impact; and
- reason the fixture belongs in the corpus.

Do not silently refresh a historical fixture from current main. That destroys the historical question the test was intended to preserve.

**FIXTURE FILE EXISTS ≠ FIXTURE PROVENANCE IS CURRENTLY TRUSTWORTHY.**

**CURRENT SOURCE ≠ HISTORICAL GOLDEN INPUT.**

If an exact historical source cannot be reconstructed, label the case synthetic and state which behavior it tests. Synthetic negative cases are useful, but they must not masquerade as historical evidence.

## 4. Golden output is a canonical semantic model

Do not make formatting, YAML key order, comments, whitespace, generated UUIDs, or tool timestamps the migration oracle unless they carry engineering meaning.

Expected output should compare canonical semantic facets such as:

```yaml
schema: semantic-digest/v2
facets:
  - id: board.digital_output.isolation.command_fault1.supply.logic
    value: LOGIC_3V3
    return: LOGIC_GND
    authority_scope: board_rev1_integration
    evidence_state: PROVEN
  - id: board.digital_output.isolation.command_fault1.supply.field
    value: SWITCHED_IO_5V
    return: L07_SWITCHED_IO_RETURN
    authority_scope: board_rev1_integration
    evidence_state: PROVEN
```

The oracle must include authority/provenance and unresolved state where those affect consumption.

**SAME ELECTRICAL VALUE ≠ SAME SEMANTIC RECORD WHEN OWNER OR EVIDENCE STATE DIFFERS.**

## 5. Positive tests: prove exact transforms

A positive migration test should demonstrate one named compatibility claim at a time.

Examples:

- representation-only rename preserves stable facet ID and value;
- ohm/kohm conversion preserves exact physical resistance and comparison behavior;
- an explicitly historical return-domain field migrates to the same typed return domain;
- a known one-to-many semantic split populates only outputs supported by source evidence;
- superseded historical authority remains historical/superseded after migration;
- a current-authority record remains consumable only for its declared scope.

Avoid giant fixtures where twenty transforms change at once and a failure cannot identify which semantic guarantee broke.

## 6. Negative tests are first-class engineering evidence

For every rule that says “must not infer,” create a case that attempts the prohibited inference.

Minimum negative set:

- generic `GND` with no evidence of logic/analog/field/chassis ownership;
- omitted startup/default state;
- omitted enable owner;
- omitted shared-resource owner;
- ordinary controller enable/status signal with no personnel-safety authority evidence;
- old overloaded field compatible with two different new semantic splits;
- value with missing unit;
- value whose unit conversion loses decision-relevant precision;
- superseded source incorrectly marked current;
- board-specific connector mapping injected into a reusable-block contract;
- missing machine measurement replaced by a plausible default.

Expected behavior is explicit failure or unresolved state according to dependency reach.

**REJECTING BAD INPUT IS PART OF THE PRODUCT.**

A migration release with no negative corpus has not demonstrated fail-closed behavior.

## 7. Round-trip testing: useful but insufficient

For representation-only and exactly invertible migrations, test:

`old -> new -> old`

and compare canonical old-schema semantics.

But round-trip success alone can be misleading. A migrator can carry an opaque old string through a new field and reproduce the original bytes while failing to expose the new ownership or unresolved-state question.

Therefore require both:

- round-trip/loss check where invertibility is claimed; and
- target-schema semantic assertions proving the new representation carries the intended meaning.

**ROUND-TRIP BYTES MATCH ≠ TARGET SEMANTICS ARE COMPLETE.**

For intentionally non-invertible schema improvements, document why reverse reconstruction is impossible and preserve the immutable original release record instead.

## 8. Precision and limit-boundary tests

Unit migrations require values near engineering boundaries, not only convenient round numbers.

For each numeric facet that participates in a limit decision, test:

- exact nominal conversion;
- smallest represented increment;
- value just below a threshold;
- value exactly at the threshold;
- value just above the threshold;
- negative/sign behavior when applicable;
- overflow/range behavior; and
- tolerance/uncertainty representation.

If `4.096 V` becomes `4096 mV`, the test is trivial only if storage and comparison rules are explicit. If a conversion changes precision or rounding, demonstrate that no pass/fail classification silently changes.

**NUMERIC ROUND TRIP ≠ LIMIT DECISION PRESERVED.**

## 9. Consumer-impact oracle

Migration verification is incomplete until downstream consequences are checked.

For each changed facet, the oracle should identify consumers and expected disposition:

- `PRESERVE_EVIDENCE` — representation changed but semantic claim is equivalent;
- `REENCODE_AND_RECHECK` — semantics equivalent but tool interpretation/encoding changed;
- `MARK_STALE` — dependency is newly explicit or meaning changed;
- `BLOCK_GENERATION` — required fact remains ambiguous/unknown;
- `NOT_AFFECTED` — no dependency path exists.

The oracle should cover reusable block consumers, adapters, board-specific connection blocks, aggregate FPGA/power/bus/connector budgets, generated KiCad artifacts, LinuxCNC/HAL mappings, qualification evidence, and release locks where applicable.

**MIGRATION PASS ≠ DOWNSTREAM EVIDENCE CURRENT.**

## 10. Current OpenPressBrake digital-output stress test

The current Rev1 isolated digital-output material provides a useful source-level example without claiming release completion.

The frozen isolation/support BOM publishes:

- `STISO621 = N`;
- `STISO620 = ceil(N/2)`;
- `100 nF decouplers = 2*(N+ceil(N/2))`;
- field 220-kOhm pull-downs `= 3*N`;
- explicit logic-side `LOGIC_3V3/LOGIC_GND` and field-side `SWITCHED_IO_5V/L07_SWITCHED_IO_RETURN` domains;
- a prohibition on a copper bridge between logic ground and L07; and
- exact first-machine population values for `N=8`.

The current board-contract validator now contains structural assertions for those scaling, domain, pin-contract, provenance, and no-bridge invariants. It also asserts that retained Pilz drive enable has no board-control connection and that the board is ordinary control, not safety rated.

This creates excellent future migration/generation negative cases:

1. map field return to `LOGIC_GND` because both are named ground-like returns -> **must fail**;
2. swap STISO620 side ownership -> **must fail**;
3. migrate `N=8` as the reusable primitive channel count -> **must fail architectural ownership**;
4. drop one per-side decoupler during population transform -> **must fail quantity invariant**;
5. infer external output load/current from reusable files -> **must remain `VERIFY_AT_MACHINE`**;
6. infer personnel-safety authority from retained Pilz status/enable relationships -> **must fail authority transfer**.

These cases demonstrate both BLOCK ENGINEERING and BOARD INTEGRATION: the reusable one-channel output remains distinct from board-level isolation packing, field-return ownership, machine population, connector/FPGA mapping, and independent safety authority.

## 11. Catalog stress-test defect: status drift

The hard audit found a concrete status-maintenance defect.

Current `digital_output_24v/STATUS_CHECKLIST.md` still leaves unchecked the item stating that `integration/validate_rev1_board_contract.py` must be updated to fail on the L07/L06 bridge, unswitched field-side supply, wrong regulator divider/pins, or missing isolation topology.

However, the current validator source already contains the isolation/BOM/domain assertions added by current main, including no-ground-bridge, side-domain, pin-contract, population-scaling, decoupling, and ordinary-control boundary checks.

This does **not** prove the validator has executed successfully on `[self-hosted, openpressbrake]`, and it does **not** make the block schematic-ready. It does prove that the checklist's source-progress statement is stale relative to current implementation.

Classification: **ENGINEERING_REVIEW_NEEDED** status/reporting defect.

Required catalog action when active digital-output work permits:

- reconcile the checklist wording with current validator source;
- distinguish “validator source implements invariant” from “validator executed and passed on authorized runner”;
- retain execution as open until concrete runner evidence exists;
- keep KiCad symbol/footprint, rendered connectivity/ERC, PCB isolation/return-path, thermal/current-path, machine facts, FPGA assignment, and human release gates open.

This is exactly why migration/release verification must test metadata/status consistency as well as data transforms.

**STATUS CHECKBOX ≠ IMPLEMENTATION STATE.**

**IMPLEMENTATION PRESENT ≠ EXECUTION EVIDENCE.**

**EXECUTION PASS ≠ REV-1 RELEASE.**

## 12. Stale-fixture detection

Golden corpora themselves can rot.

A test suite should detect when:

- a fixture claimed as current no longer matches current authority;
- a historical fixture lost its pinned source revision;
- a source was superseded but fixture metadata still marks it current;
- an expected output was regenerated from the implementation under test instead of independently reviewed;
- a negative fixture accidentally became valid after a schema change; or
- a fixture references a deleted/renamed semantic facet without an explicit migration record.

Never update expected outputs merely to make a failing test green. Review the semantic change first.

**GOLDEN FILE UPDATED ≠ REGRESSION RESOLVED.**

## 13. Migration release gate

A migration version may be released for new-build consumption only when:

1. schema and migration IDs are explicit;
2. migration rules are versioned;
3. representative historical fixtures are pinned to exact evidence;
4. positive golden cases pass;
5. required negative/ambiguous cases reject or remain unresolved as designed;
6. unit/precision boundary tests pass;
7. round-trip/loss claims are demonstrated where applicable;
8. provenance, authority, supersession, and unresolved states are preserved;
9. consumer-impact oracle results match dependency expectations;
10. stale-fixture checks pass;
11. old/new dual-read behavior cannot create dual authority;
12. safety ownership cannot be manufactured or transferred;
13. executable regressions, if required, pass only on the authorized local runner; and
14. human review accepts the migration evidence package.

If the authorized local runner is unavailable, executable migration evidence is `BLOCKED/NOT_RUN`. Documentation and source review may continue, but do not substitute GitHub-hosted compute.

## 14. Student lab

Create a migration-verification plan for a hypothetical `semantic-digest/v1 -> v2` transition using a reusable block plus board-specific integration.

Required deliverables:

1. three `GOLDEN_HISTORICAL` fixtures with pinned provenance;
2. two `GOLDEN_CURRENT` target-schema records;
3. at least six negative cases, including ambiguous return ownership and ordinary-control-to-safety authority leakage;
4. one precision-boundary numeric case;
5. one overloaded-field split that partially migrates and leaves at least one facet unresolved;
6. a consumer-impact oracle covering one reusable block consumer, one connection block, one aggregate resource budget, one generated schematic/HAL consumer, and one qualification item;
7. a stale-fixture detection rule; and
8. a migration release decision with explicit remaining blockers.

The student must explain which facts belong to the reusable block and which belong to the board-specific connection/integration layer. Machine-specific facts that are not evidenced remain `VERIFY_AT_MACHINE/TBD`.

## 15. Cross-machine reuse

The same verification method applies beyond press brakes.

A mill may migrate spindle-drive command semantics; a lathe may split encoder electrical capability from spindle-index board mapping; a plasma table may make torch-interface return/isolation ownership explicit; a router may migrate step/dir voltage-class metadata; a robot may split reusable joint-driver contracts from connector/harness mappings; custom automation may add watchdog/default-state facets.

The corpus should test reusable semantics without embedding one machine's connector names, channel counts, or harness assumptions into the reusable block.

## 16. Safety boundary

This lesson verifies semantic migration for ordinary board-design authority. It does not establish PL, SIL, category, stopping performance, final-element diagnostics, or safety validation.

A migration may preserve a fact that an ordinary controller monitors a safety status or interfaces to an enable/STO mechanism. It may not convert that relationship into independent personnel-safety authority.

Any fixture that attempts such authority transfer is a required negative case.

## 17. Durable rules from BD53

- **PARSES SUCCESSFULLY ≠ MIGRATES SAFELY.**
- **POSITIVE FIXTURES PASS ≠ AMBIGUITY FAILS CLOSED.**
- **CURRENT SOURCE ≠ HISTORICAL GOLDEN INPUT.**
- **SAME ELECTRICAL VALUE ≠ SAME SEMANTIC RECORD WHEN OWNER OR EVIDENCE STATE DIFFERS.**
- **REJECTING BAD INPUT IS PART OF THE PRODUCT.**
- **ROUND-TRIP BYTES MATCH ≠ TARGET SEMANTICS ARE COMPLETE.**
- **NUMERIC ROUND TRIP ≠ LIMIT DECISION PRESERVED.**
- **MIGRATION PASS ≠ DOWNSTREAM EVIDENCE CURRENT.**
- **GOLDEN FILE UPDATED ≠ REGRESSION RESOLVED.**
- **STATUS CHECKBOX ≠ IMPLEMENTATION STATE.**
- **IMPLEMENTATION PRESENT ≠ EXECUTION EVIDENCE.**
- **EXECUTION PASS ≠ REV-1 RELEASE.**

## Catalog stress-test result

BD53 exposes two missing durable capabilities above the current per-block files:

1. a versioned migration-regression corpus with provenance-pinned positive, negative, ambiguity, precision, and consumer-impact fixtures; and
2. a status/evidence consistency check capable of distinguishing source implementation, authorized execution evidence, formal block status, and release state.

Both remain **ENGINEERING_REVIEW_NEEDED**. The current digital-output status drift should be corrected by the active engineering lane when it can do so without conflicting with ongoing Rev1 work.

## Next lesson

BD54 should address **semantic dependency coverage, mutation testing, and validator adequacy**:

`semantic rules -> validator claims -> targeted mutations -> expected detection -> undetected mutation analysis -> dependency-coverage map -> validator improvement -> adequacy gate`

The key question is no longer merely whether tests pass, but whether the validation suite demonstrably detects the classes of semantic corruption it claims to prevent.