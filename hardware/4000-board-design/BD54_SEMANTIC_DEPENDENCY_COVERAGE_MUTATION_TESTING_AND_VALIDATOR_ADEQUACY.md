# BD54 — Semantic Dependency Coverage, Mutation Testing, and Validator Adequacy

## Purpose

BD53 established positive and negative semantic migration corpora. BD54 asks a harder question: **does a validator actually detect the engineering faults it claims to guard against?**

`semantic rules -> validator claims -> targeted mutations -> expected detection -> undetected mutation analysis -> dependency-coverage map -> validator improvement -> adequacy gate`

A green current tree proves only that the current inputs satisfy the checks that actually ran. It does not prove that a validator would reject a wrong return domain, missing default state, stale authority, wrong resource owner, quantity drift, or ordinary-control/safety-boundary leakage.

This lesson applies the same adversarial method to BLOCK ENGINEERING and BOARD INTEGRATION. A reusable block validator must cover the block's generic contract. A board validator must cover board-specific composition, connection, resource, and authority rules without moving those rules into the reusable primitive.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `README.md` — **VERIFIED_FOR_LESSON** for evidence hierarchy, reproducible verification, uncertainty handling, and the rule that convincing prose is not completion.
- Curriculum `hardware/4000-board-design/BD53_SEMANTIC_MIGRATION_VERIFICATION_GOLDEN_CORPORA_AND_NEGATIVE_COMPATIBILITY_TESTS.md` — **VERIFIED_FOR_LESSON** for positive/negative corpus design, consumer-impact oracles, and fail-closed migration verification.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for the board-design handoff through BD53.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for evidence truthfulness, formal status, integration-versus-qualification separation, and the rule that CI proves only the checks it actually runs.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for reusable-block/adapter/board-integration ownership and fail-closed composition classification.
- OpenPressBrake `hardware/blocks/safety_interface/REV1_STRUCTURAL_COMPOSITION_CONTRACT.yaml` — **VERIFIED_FOR_LESSON** for the drawing-derived Rev1 composition invariants used as the bounded mutation-planning example.
- OpenPressBrake `hardware/blocks/safety_interface/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the current bounded claim that this interface remains `BEHAVIORAL ONLY — NOT SCHEMATIC-READY`, with physical/no-bypass verification and generic additional-handshake details still open.

No file above is presented as proof that the current OpenPressBrake controller is production-proven. The safety-interface composition contract is used as a machine-readable **ordinary-control composition boundary** and explicitly assigns no personnel-safety authority to LinuxCNC, FPGA logic, or ordinary field I/O.

## Learning objectives

The student must be able to:

1. convert semantic requirements into explicit validator claims;
2. distinguish source inspection, validator execution, mutation detection, and release evidence;
3. build targeted mutations that each violate one engineering invariant;
4. distinguish syntactic mutations from semantic mutations;
5. map semantic facets to validators and downstream consumers;
6. identify undetected mutations as validator or contract defects rather than acceptable test noise;
7. avoid false coverage created by duplicate checks of the same representation;
8. preserve reusable-block versus board-integration ownership while testing both layers;
9. test fail-closed handling of unresolved machine facts and stale authority;
10. keep ordinary controller validation separate from independent personnel-safety validation; and
11. define an adequacy gate based on demonstrated fault detection rather than a green baseline alone.

## 1. Four different evidence states

Keep these separate:

1. **RULE EXISTS** — an engineering requirement is written somewhere authoritative.
2. **CHECK EXISTS** — validator source appears to implement a check for that rule.
3. **CHECK EXECUTED** — concrete evidence shows the validator ran on an authorized environment/revision.
4. **FAULT DETECTED** — a representative violating mutation was rejected for the intended reason.

None implies the next.

**RULE DOCUMENTED ≠ RULE ENFORCED.**

**CHECK SOURCE PRESENT ≠ CHECK EXECUTED.**

**CHECK EXECUTED GREEN ≠ CHECK CAN DETECT ITS TARGET FAULT.**

**MUTANT REJECTED ≠ CORRECT RULE DETECTED IT.**

The last distinction matters. A malformed YAML mutation rejected by a parser does not prove the electrical-domain validator would reject a well-formed but electrically wrong domain assignment.

## 2. Semantic mutation, not random corruption

Mutation testing for board design should alter one engineering meaning while keeping the artifact otherwise plausible.

Useful mutation classes include:

- `DOMAIN_SUBSTITUTION` — replace a typed return/supply with another valid but wrong domain;
- `OWNER_SUBSTITUTION` — assign a resource or authority to the wrong architectural owner;
- `OMISSION` — remove a required startup/default/enable/resource facet;
- `QUANTITY_OFF_BY_ONE` — preserve valid syntax but break population accounting;
- `BOUNDARY_COLLAPSE` — merge two intentionally separate electrical or authority boundaries;
- `AUTHORITY_ESCALATION` — mark a historical, ordinary-control, or diagnostic fact as current command/safety authority;
- `STALE_SOURCE_SELECTION` — point a consumer at superseded authority;
- `MACHINE_FACT_INVENTION` — replace `VERIFY_AT_MACHINE` with a plausible guessed value;
- `REUSABILITY_LEAK` — inject board connector, machine name, or fixed machine count into a reusable primitive;
- `DEPENDENCY_DROP` — remove a semantic dependency while leaving the consumer apparently valid.

Avoid random byte flips as the primary adequacy test. They mostly measure parser robustness.

## 3. Build a validator-claim register

Before mutating anything, list what the validator claims to protect.

Minimum record per claim:

- stable claim ID;
- authoritative semantic source;
- owner layer: reusable block, adapter, board connection/integration, machine configuration, or release;
- exact invariant;
- validator/check expected to enforce it;
- representative valid case;
- representative violating mutation;
- expected disposition: reject, block, stale, unresolved, or warning;
- expected diagnostic identity/reason;
- downstream consumers affected if the rule escapes;
- execution environment required; and
- evidence state.

If a claim cannot be expressed precisely enough to design a violating mutation, the contract is probably not machine-checkable enough yet.

**HARD TO MUTATE PRECISELY = POSSIBLE CONTRACT DEFECT.**

## 4. Dependency coverage is semantic, not line coverage

Traditional code coverage can show that a validator branch executed. It cannot show that every important engineering dependency is protected.

Build a dependency-coverage map:

`semantic facet -> owner -> consumers -> enforcing checks -> negative mutation -> expected detection`

Example facets:

- field return domain;
- logic return domain;
- startup/default state;
- enable authority;
- FPGA resource ownership;
- shared power resource ownership;
- connector mapping owner;
- population scaling formula;
- supersession/current-authority state;
- `VERIFY_AT_MACHINE` state;
- ordinary-control versus independent-safety authority.

Coverage is weak when an important facet has consumers but no enforcing check, or a check but no demonstrated negative case.

## 5. Coverage classes

Use explicit classes rather than one percentage:

### `DECLARED_ONLY`

A semantic rule exists, but no validator claim is identified.

### `STATIC_CHECK_MAPPED`

A validator check is mapped to the rule, but no mutation evidence exists.

### `MUTATION_DETECTED`

A representative, well-formed violating mutation is rejected for the intended semantic reason.

### `DOWNSTREAM_CONTAINED`

The mutation is also prevented from producing or promoting stale downstream artifacts.

### `BLOCKED_UNKNOWN`

The rule depends on unresolved physical evidence. Correct behavior is to preserve `VERIFY_AT_MACHINE`/unknown and block unsupported closure.

Do not collapse these into a misleading “92% covered” number unless weighting and semantics are explicitly justified.

## 6. Mutation quality rules

A useful mutant should:

1. remain syntactically valid;
2. violate one named semantic claim;
3. preserve unrelated fields where practical;
4. reach the validator stage intended to detect it;
5. have an independently defined expected outcome; and
6. not rely on the implementation under test to generate its own oracle.

For a quantity formula, test more than one population. A validator hard-coded to the first machine's `N` can accidentally pass the installed configuration while violating the reusable scaling rule.

For typed domains, mutate to another **valid named domain**, not nonsense text. This proves domain compatibility rather than enum parsing.

For authority, mutate a valid ordinary-control signal into a safety-authority role. This proves the ownership boundary rather than spelling validation.

## 7. Equivalent mutants and duplicate evidence

Some mutations are semantically equivalent. Two tests that both rename `LOGIC_GND` to an invalid token may exercise the same parser path and add little confidence.

Track a mutation's semantic target and detection reason. Deduplicate tests that provide no new engineering coverage.

Conversely, one semantic facet may require several mutations when failure modes differ. A return-domain contract may need:

- wrong but valid return domain;
- omitted return;
- prohibited bridge between domains; and
- stale source that uses an old generic `GND` representation.

These are not necessarily equivalent because they exercise different escape paths.

## 8. Escaped mutants are engineering findings

When a well-designed mutant survives:

1. confirm the mutant really violates current authority;
2. confirm it reached the intended validator;
3. check whether another validator should own the rule;
4. classify the escape;
5. improve the correct architectural artifact; and
6. add the mutant to the regression corpus.

Possible classifications:

- `VALIDATOR_MISSING_CHECK`;
- `CONTRACT_NOT_MACHINE_READABLE`;
- `WRONG_OWNER_LAYER`;
- `DEPENDENCY_GRAPH_MISSING_EDGE`;
- `AUTHORITY_PRECEDENCE_AMBIGUOUS`;
- `MUTANT_INVALID_TEST`;
- `EXPECTED_UNRESOLVED_NOT_FAILURE`.

Do not patch the lesson with unwritten knowledge. An escaped mutant that reveals required human memory is a catalog/tooling defect.

## 9. Current OpenPressBrake Rev1 composition stress test

The inspected Rev1 safety-interface composition contract provides a bounded example because it publishes explicit fail-closed invariants while remaining outside personnel-safety authority.

Current board composition states:

- exactly seven documented Pilz-status inputs, each consuming `digital_input_24v`;
- exactly six documented operational outputs, each consuming `digital_output_24v`;
- seven FPGA inputs and six FPGA outputs;
- zero direct 24-V field-to-FPGA connections;
- operational-command field domain `L7/L07`;
- prohibited `L07 -> L06` bridge;
- wire 75 outside ordinary FPGA command authority;
- wire 63 outside OpenPressBrake ordinary logic; and
- no personnel-safety credit assigned to this composition.

These are board-specific composition facts. They do **not** redefine either reusable I/O primitive to have seven or six channels.

### Mutation plan

A future validator for this contract should be challenged with at least these well-formed mutations:

| Mutation | Expected result | Why |
|---|---|---|
| status input count `7 -> 6` | reject | drawing-derived composition count drift |
| output count `6 -> 7` | reject | board population drift |
| `digital_input_24v_instances: 7 -> 8` while list remains seven | reject | aggregate resource inconsistency |
| `direct_24v_fpga_connections: 0 -> 1` | reject | field-to-FPGA boundary violation |
| one operational output `field_domain: L7_L07 -> L6_L06` | reject | bypasses preserved switched-domain composition |
| remove `prohibited_bridge: L07_to_L06` | reject/block | required fail-closed domain constraint disappears |
| wire 75 `ordinary_fpga_role` changed to command | reject | ordinary-control authority escalation |
| wire 63 routed through ordinary logic | reject | independent hardwired boundary collapse |
| `safety_authority: none -> personnel_safety` | reject | unsupported safety-authority manufacture |
| replace a `verify_at_machine` item with guessed `confirmed: true` | reject/block absent evidence | physical fact invention |

This table is a **mutation plan**, not execution evidence. No claim is made here that a current OpenPressBrake validator already implements or passes these mutations.

## 10. Catalog stress-test finding: composition contract lacks named validator evidence

The inspected composition contract is unusually good at stating fail-closed invariants, but during this run no named validator or mutation-regression artifact was presented alongside it as evidence that those invariants are automatically enforced.

Classification: **ENGINEERING_REVIEW_NEEDED** for automated enforcement/adequacy infrastructure, while the contract itself is **VERIFIED_FOR_LESSON** for the bounded semantic claims above.

This is not a reason to modify the active safety-interface engineering work from the curriculum lane. It is a concrete catalog action item:

- give machine-readable invariants stable claim IDs;
- map each claim to an enforcing validator or explicitly mark it manual;
- add representative well-formed negative mutations;
- preserve exact source revision and expected diagnostic outcome;
- distinguish validator-source presence from authorized execution evidence;
- propagate escaped mutations to affected board/resource/generated-artifact consumers; and
- keep unresolved physical facts fail-closed.

The teaching exercise therefore exposed a real reusable methodology need without contaminating the reusable I/O primitives with first-machine counts.

## 11. Block engineering versus board integration

Mutation suites must preserve architectural ownership.

For a reusable block, mutate generic electrical claims such as:

- voltage/range limits;
- protection topology;
- default state;
- enable semantics;
- per-instance FPGA resources;
- shared-resource declaration; and
- fault behavior.

For board integration, mutate:

- instance count;
- connector/pin mapping;
- FPGA assignment;
- aggregate power/resource budget;
- board-specific return-domain mapping;
- physical labels/silkscreen mapping;
- machine endpoint selection; and
- configuration authority.

A board-specific failed mutation must not be “fixed” by embedding the board fact in the reusable block.

**BOARD MUTANT ESCAPES ≠ PRIMITIVE MUST BECOME MACHINE-SPECIFIC.**

## 12. Cross-block and kitchen-sink mutations

Local validators can all pass while the complete board is wrong.

Add integration-level mutations for:

- two blocks claiming the same exclusive FPGA pin;
- incompatible bank-voltage assignments;
- aggregate current exceeding a domain budget;
- duplicated bus address/chip select;
- missing common return where one is required;
- prohibited return bridge where isolation is required;
- watchdog/output-authority path bypass;
- connection block pointing to a superseded block revision;
- HAL mapping that commands a different physical endpoint than the connection block; and
- generated schematic/resource report built from different configuration locks.

These belong above individual block validators because they arise only in composition.

## 13. Startup/default-state mutations

Default behavior is especially easy to omit because the nominal running state still works.

For every command-capable output path, mutation tests should attempt to:

- remove the declared power-off state;
- invert the inactive state;
- remove pull-up/pull-down ownership;
- make FPGA configuration state authoritative before valid configuration;
- remove watchdog inhibit behavior; and
- permit an unresolved enable owner to default enabled.

Expected behavior is fail-closed rejection or unresolved/block according to the architecture.

Do not infer a machine's safe state merely because an electrical output defaults low. Personnel safety remains a separate analysis and authority.

## 14. Authority and stale-source mutations

Validators must test source selection, not only electrical values.

Mutate:

- `CURRENT -> SUPERSEDED` while leaving the same numeric value;
- source revision to an unpinned branch name where a release lock requires exact identity;
- machine overlay to exceed its parent reusable envelope;
- service-only authority into new-build eligibility;
- inferred evidence into measured/bench-verified evidence; and
- `VERIFY_AT_MACHINE` into a concrete value without provenance.

A validator that compares only values can miss all of these.

**SAME VALUE ≠ SAME AUTHORITY.**

## 15. Diagnostic quality matters

A mutant should be rejected for the right reason. Diagnostics should identify:

- violated claim ID;
- semantic facet;
- owner layer;
- expected versus observed relationship;
- source/provenance involved; and
- affected consumers or generation gate.

If every mutation fails with “schema invalid,” the validator may be too shallow to demonstrate engineering adequacy.

## 16. Adequacy gate

A validator may be called **ADEQUATE FOR A DECLARED CLAIM SET** only when:

1. the claim set is explicit and versioned;
2. each claim has an authority owner;
3. each claim maps to one or more checks or is explicitly manual;
4. representative valid inputs pass;
5. representative well-formed violating mutations exist for machine-checkable claims;
6. those mutations are rejected for the intended semantic reason;
7. unresolved physical facts remain unresolved rather than receiving defaults;
8. stale/superseded authority mutations are covered where relevant;
9. cross-block claims are tested at board-integration scope rather than hidden in primitives;
10. consumer impact is blocked/staled correctly when a mutation escapes upstream;
11. safety-authority escalation is rejected for ordinary-control artifacts;
12. exact validator/mutation-suite revision and execution evidence are recorded; and
13. required executable evidence is run only on the authorized local runner.

Adequacy is scoped. A validator adequate for connectivity is not thereby adequate for thermal, transient, timing, EMC, personnel-safety, or physical-machine claims.

## 17. Local-compute rule

Mutation regressions are executable verification when they are actually run.

For this project they may run only on the local OpenPressBrake panel PC through the self-hosted runner labeled `[self-hosted, openpressbrake]` when executable evidence is genuinely required. Do not consume GitHub-hosted Actions minutes.

This lesson required source/contract review and mutation-plan design, not execution. Therefore no mutation suite, simulation, synthesis, place-and-route, timing run, or other executable engineering verification was run here.

If future adequacy promotion requires execution and the authorized runner is unavailable, record `BLOCKED/NOT_RUN`; do not substitute hosted compute.

## 18. Student lab

Choose one reusable block contract and one board-specific connection/composition contract that have already passed the hard student-material verification rule.

Produce:

1. a validator-claim register with at least eight stable claim IDs;
2. a semantic dependency map from those claims to consumers;
3. at least eight well-formed mutations spanning domain, ownership, omission, quantity, stale authority, and unresolved machine facts;
4. at least two startup/default-state mutations;
5. one reusability-leak mutation;
6. one ordinary-control-to-personnel-safety authority escalation mutation;
7. expected diagnostic identity for each mutant;
8. an escaped-mutant disposition workflow;
9. an adequacy matrix showing `DECLARED_ONLY`, `STATIC_CHECK_MAPPED`, `MUTATION_DETECTED`, `DOWNSTREAM_CONTAINED`, or `BLOCKED_UNKNOWN`; and
10. a short explanation of why any board-specific failed mutation does not justify contaminating the reusable block.

Do not execute tests on hosted compute. If execution is required for the lab environment, use only the authorized local runner and preserve the exact revision/results.

## 19. Review questions

1. Why does a green validator run not prove that a wrong return domain would be detected?
2. What makes a semantic mutation stronger than random file corruption?
3. Why should a wrong but valid domain name be preferred over nonsense text in a domain mutation?
4. What does a surviving mutant tell you about the validator or contract?
5. Why is source-line coverage not equivalent to semantic dependency coverage?
6. When should an escaped board mutation create an adapter/block defect versus a board-integration fix?
7. Why must `VERIFY_AT_MACHINE` be mutation-tested against plausible invented defaults?
8. Why can two different mutations that both fail parsing provide little extra engineering confidence?
9. What additional evidence is needed before saying a validator is adequate for a declared claim set?
10. Why can ordinary controller status/enable validation never manufacture personnel-safety authority?

## 20. Durable rules frozen by BD54

- **GREEN CURRENT TREE ≠ VALIDATOR ADEQUACY.**
- **CHECK SOURCE PRESENT ≠ CHECK EXECUTED.**
- **CHECK EXECUTED ≠ TARGET FAULT DETECTED.**
- **MUTANT REJECTED ≠ CORRECT SEMANTIC RULE DETECTED IT.**
- Mutation tests should remain syntactically valid and violate named engineering semantics.
- Semantic dependency coverage is more important than validator source-line coverage for engineering claims.
- Every machine-checkable “must not” rule should have a representative negative mutation.
- Surviving valid mutants are engineering findings and must be classified, not ignored.
- Authority/provenance mutations matter even when electrical values are unchanged.
- Unknown machine facts must survive as unknown/`VERIFY_AT_MACHINE`; plausible defaults are not evidence.
- Reusable-block mutations and board-integration mutations have different owners.
- Board-specific composition failures do not justify machine-specific reusable primitives.
- Cross-block resource, connection, generation, and HAL consistency require board-level mutation coverage.
- Validator adequacy is scoped to an explicit claim set; it is never blanket qualification.
- Ordinary LinuxCNC/FPGA validation cannot confer independent personnel-safety authority.
- Executable adequacy evidence, when required, uses only `[self-hosted, openpressbrake]`.

## Next handoff

Build BD55 on **validator evidence provenance, execution identity, and regression-result promotion**:

`validator source + claim set + mutation corpus + exact execution environment -> signed/pinned result identity -> result-to-claim mapping -> stale-result detection -> promotion gate -> release evidence`

Stress the distinction between source existing, a workflow being configured, a run occurring on the authorized runner, the run testing the intended revision/corpus, and the resulting evidence still being applicable after semantic or dependency changes.