# BD55 — Validator Evidence Provenance, Execution Identity, and Regression-Result Promotion

## Purpose

BD54 separated rule existence, check-source existence, authorized execution, and demonstrated fault detection. BD55 makes the resulting evidence durable and promotion-safe:

`validator source + claim set + mutation corpus + exact execution environment -> pinned result identity -> result-to-claim mapping -> stale-result detection -> promotion gate -> release evidence`

A green workflow badge is not a transferable engineering fact. Evidence is useful only when another engineer can identify exactly what source, semantic claims, fixtures, dependencies, configuration, and execution environment produced it, and can tell whether later changes made it stale.

This applies to both BLOCK ENGINEERING and BOARD INTEGRATION. It does not turn ordinary controller validation into personnel-safety validation.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `README.md` — **VERIFIED_FOR_LESSON** for evidence hierarchy, exact-revision provenance, reproducible experiments, and uncertainty handling.
- Curriculum `hardware/4000-board-design/BD54_SEMANTIC_DEPENDENCY_COVERAGE_MUTATION_TESTING_AND_VALIDATOR_ADEQUACY.md` — **VERIFIED_FOR_LESSON** for semantic claim registers, mutation adequacy, dependency coverage, and the separation of source/execution/detection evidence.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for board-design progress through BD54.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for truthful status, concrete evidence, integration-versus-qualification separation, and the rule that CI proves only the checks it actually runs.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for reusable-block/adapter/board-integration ownership and fail-closed composition.
- OpenPressBrake `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the bounded encoder status/evidence claims used below; the block remains `SIMULATION-READY`, not schematic-ready or Rev-1 released.
- OpenPressBrake `hardware/blocks/differential_encoder/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` — **VERIFIED_FOR_LESSON** for the current board-consumption boundary and remaining `VERIFY_AT_MACHINE` facts.
- OpenPressBrake `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json` — **VERIFIED_FOR_LESSON** for the current six-instance A/B/Z semantic/package binding contract and pinned upstream provenance.
- OpenPressBrake `hardware/blocks/differential_encoder/integration/validate_rev1_litexcnc_encoder_binding.py` — **VERIFIED_FOR_LESSON** as current validator source, not by itself as execution evidence.
- OpenPressBrake `.github/workflows/rev1-board-integration.yml` — **VERIFIED_FOR_LESSON** for workflow intent and its required `[self-hosted, openpressbrake]` execution label; workflow configuration is not itself proof a particular validator ran.
- GitHub Actions run metadata for current OpenPressBrake main commit `5a3d7af6a58f0d494537212592302a3171cb6018` — **VERIFIED_FOR_LESSON** for the bounded fact that a Differential Encoder Block Simulation run completed successfully for that exact head SHA. This lesson does **not** infer from that run that every board-integration validator, mutation, synthesis, timing, or release gate ran.

No file above is presented as evidence that the current OpenPressBrake controller is production-proven.

## Learning objectives

The student must be able to:

1. define the identity of a validator result independently of a workflow name or green badge;
2. bind results to exact source, claim-set, corpus, configuration, dependency, and environment revisions;
3. distinguish workflow configuration, run occurrence, job/step execution, diagnostics, artifacts, and promoted engineering evidence;
4. map each promoted result to the semantic claims it actually supports;
5. detect when later changes stale all or part of prior evidence;
6. preserve valid unaffected evidence without blindly rerunning everything;
7. reject evidence produced on an unauthorized compute environment;
8. prevent stale results from promoting generated board, FPGA, HAL, or release artifacts;
9. preserve reusable-block versus board-integration ownership; and
10. keep ordinary controller evidence separate from independent personnel-safety authority.

## 1. Evidence has an identity

A useful validator result is a tuple, not a boolean:

`E = (validator, claim_set, corpus, inputs, dependencies, config_lock, environment, execution, diagnostics, outputs)`

At minimum record:

- evidence ID;
- validator path and exact blob/commit identity;
- semantic claim-set version/digest;
- positive and negative corpus identity;
- authoritative input artifact revisions/digests;
- dependency revisions/digests;
- board/machine configuration lock where applicable;
- runner class/labels and relevant tool versions;
- workflow/run/job/step identity when CI is used;
- start/end time and outcome;
- diagnostic IDs/reasons for negative cases;
- output artifact digests;
- claims supported;
- claims explicitly not supported;
- unresolved facts preserved; and
- supersession/staleness state.

**GREEN ≠ IDENTIFIED EVIDENCE.**

## 2. Workflow source is not run evidence

Keep these states separate:

1. `WORKFLOW_DECLARED` — repository source says a job should run.
2. `RUN_CREATED` — an execution exists for an exact commit/configuration.
3. `JOB_EXECUTED_AUTHORIZED` — the intended job ran on the authorized environment.
4. `TARGET_CHECK_EXECUTED` — the intended validator/command actually ran.
5. `EXPECTED_DIAGNOSTICS_OBSERVED` — negative cases failed for intended semantic reasons.
6. `RESULT_CAPTURED` — logs/artifacts/digests are retained with provenance.
7. `RESULT_PROMOTED` — an engineering authority explicitly accepts the bounded result for named claims.

None implies the next merely because a UI is green.

**WORKFLOW FILE EXISTS ≠ TARGET CHECK RAN.**

**RUN SUCCESS ≠ EVERY STEP RELEVANT TO THIS CLAIM RAN.**

**STEP RAN ≠ MUTATION ADEQUACY PROVEN.**

**RESULT EXISTS ≠ RESULT PROMOTED.**

## 3. Exact execution environment is part of the evidence

For executable OpenPressBrake engineering verification, the required environment is the local runner labeled `[self-hosted, openpressbrake]`.

Record enough environment identity to reproduce or bound the result:

- runner labels/class;
- OS/platform identity;
- tool versions that can change semantics;
- Python/package or simulator versions where relevant;
- FPGA toolchain/device target for synthesis/place-route/timing;
- KiCad/ERC version for CAD checks where behavior can differ;
- environment/configuration files or container/image digest if used; and
- any hardware fixture identity for bench tests.

A result from a GitHub-hosted runner is not an acceptable substitute merely because the command is the same.

**SAME COMMAND ≠ SAME AUTHORIZED EXECUTION IDENTITY.**

## 4. Promote claims, not runs

A single run can support several claims, and one claim can require several results. Promotion therefore maps evidence to semantic claim IDs.

Example:

| Claim | Required evidence | Promotion state |
|---|---|---|
| `ENC.BIND.INSTANCE_COUNT` | validator + exact binding/config | eligible after authorized pass |
| `ENC.BIND.ABZ_PACKAGE_MAP` | validator + current pin plan + module config + real-image binding | eligible after authorized pass |
| `ENC.TERM.MACHINE_SELECTION` | physical cable/end evidence | blocked; validator cannot invent it |
| `ENC.FIELD_5V.SUPPLY` | board power implementation + machine load evidence | blocked/open |
| `ENC.SAFETY.CREDIT_NONE` | semantic contract + validator/static review | ordinary-control boundary only |

Do not promote the run itself into a blanket statement such as “encoder verified.”

**RUN PASS ≠ BLOCK QUALIFIED.**

## 5. Result-to-claim mapping must include negative scope

Every promoted evidence record should say what it does **not** prove.

For the current encoder example, a successful bounded electrical or binding check does not establish:

- actual cable/end termination selection;
- encoder field +5-V source/current/protection;
- cable reflection/SI acceptance;
- ESD/surge/miswire/hot-plug qualification;
- routed PCB quality;
- schematic visual review;
- FPGA routed timing unless that exact flow ran;
- machine commissioning; or
- personnel-safety performance.

Negative scope prevents a true result from becoming a false broader claim.

## 6. Stale-result detection is dependency-aware

Evidence becomes stale when a dependency that can affect its supported claim changes.

Do not use only file timestamps or “newer commit exists.” Compare semantic dependencies.

Typical invalidators:

- validator source changes;
- claim meaning changes;
- mutation corpus changes in a way relevant to adequacy;
- authoritative input changes;
- FPGA pin/bank/resource plan changes;
- board connection mapping changes;
- power/return domain changes;
- machine configuration changes;
- toolchain change outside an accepted equivalence envelope;
- upstream proven-reference revision changes; or
- unresolved machine fact becomes resolved and changes selection.

Possible states:

- `CURRENT` — all relevant dependencies match promoted evidence;
- `STALE_REVALIDATE` — relevant dependency changed;
- `PARTIALLY_STALE` — only a subset of supported claims lost applicability;
- `SUPERSEDED` — newer promoted evidence replaces it;
- `HISTORICAL_ONLY` — retained for provenance/service history but not current new-build consumption;
- `BLOCKED_UNKNOWN` — required physical/configuration evidence is unresolved.

**NEW COMMIT ≠ ALL EVIDENCE STALE.**

**UNCHANGED VALIDATOR ≠ EVIDENCE CURRENT IF ITS INPUT AUTHORITY CHANGED.**

## 7. Partial staleness is important

Suppose an encoder board connector changes but the reusable receiver circuit does not.

Likely effects:

- reusable receiver electrical calculations may remain applicable;
- board connector/pin mapping evidence becomes stale;
- FPGA semantic binding may remain current if package balls are unchanged;
- harness/termination evidence may require review;
- board ERC/netlist evidence must be regenerated if connectivity changed.

This is why reverse dependency tracking is better than “rerun every test” and safer than “nothing in the validator changed.”

## 8. Current OpenPressBrake encoder evidence stress test

The inspected current encoder artifacts make the distinction concrete.

The machine-readable binding pins six logical encoder instances to explicit `ENCn_A/B/Z` semantic package balls and pins the hardware/LiteX-CNC reference commits. The validator checks reference drift, Rev29 package-plan authority, one-encoder primitive scope, A/B/Z structure, six logical instances, physical package mapping, collisions, termination remaining `VERIFY_AT_MACHINE`, and `safety_credit == none`.

The current status checklist records prior concrete CI run IDs for production-circuit evidence and says the Rev1 board contract validator is wired into whole-board integration. The current workflow source indeed targets `[self-hosted, openpressbrake]` and invokes the differential-encoder primitive-to-board allocation validator.

But these are different evidence objects. A status statement, validator source, workflow declaration, and run record must not be merged into one implied “verified” state.

Current main also has a successful `Differential Encoder Block Simulation` workflow run for exact head SHA `5a3d7af6a58f0d494537212592302a3171cb6018`. That proves the bounded run metadata only. Without inspecting the exact job/steps/logs and mapping them to claim IDs, BD55 does not promote that run into whole-board integration, mutation-adequacy, synthesis/timing, or release evidence.

This conservative treatment is intentional.

## 9. Promotion gate

A validator result may be promoted as release/integration evidence only when:

1. source and semantic claim-set identities are exact;
2. authoritative inputs and dependencies are pinned;
3. the required corpus is identified;
4. execution occurred on the authorized environment;
5. intended job/step/validator execution is demonstrated;
6. expected positive and negative outcomes are present for the declared claim set;
7. diagnostics show negative cases failed for the intended semantic reason;
8. output/log artifacts needed for review are retained or reproducibly recoverable;
9. unresolved physical facts remain unresolved;
10. result-to-claim mapping and negative scope are explicit;
11. reverse dependencies show no applicable semantic change since execution;
12. an appropriate engineering authority promotes the result; and
13. safety authority is not inferred from ordinary-control evidence.

If any required item is absent, use `NOT_PROMOTED`, `STALE_REVALIDATE`, or `BLOCKED_UNKNOWN` rather than guessing.

## 10. Evidence manifest pattern

A durable machine-readable result can use a structure like:

```yaml
evidence_id: ENC-BIND-REV29-001
subject: differential_encoder/rev1_litexcnc_binding
source_commit: <exact OpenPressBrake commit>
validator:
  path: hardware/blocks/differential_encoder/integration/validate_rev1_litexcnc_encoder_binding.py
  digest: <content digest>
claim_set:
  version: <claim-set identity>
  claims:
    - ENC.BIND.INSTANCE_COUNT
    - ENC.BIND.ABZ_PACKAGE_MAP
    - ENC.BIND.NO_SAFETY_CREDIT
inputs:
  - path: hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json
    digest: <digest>
  - path: hardware/blocks/fpga_core_ecp5_25/integration/rev29_max22216_rgmii_cabga256_pin_plan.json
    digest: <digest>
execution:
  runner_labels: [self-hosted, openpressbrake]
  run_id: <run>
  job_id: <job>
  result: PASS
negative_scope:
  - cable_termination_selection
  - encoder_field_5v_supply
  - routed_fpga_timing
  - personnel_safety
state: CURRENT
```

The schema is illustrative methodology, not a claim that OpenPressBrake already has this exact manifest.

## 11. Catalog stress-test finding

The current encoder artifacts contain unusually good provenance in several places: exact upstream commits, explicit current package-plan authority, validator source, workflow source, status evidence, and named historical CI runs. Teaching promotion still requires a human to reconcile those representations to answer a simple question: **which exact execution supports which exact semantic claims right now?**

Classification: **ENGINEERING_REVIEW_NEEDED** for a normalized validator-evidence manifest/promotion layer.

Required future catalog/tooling infrastructure:

- stable semantic claim IDs;
- validator/corpus/input digests;
- exact workflow/run/job/step identity;
- authorized runner/toolchain identity;
- expected diagnostic IDs;
- result-to-claim and negative-scope mapping;
- reverse-dependency staleness rules;
- partial-staleness support;
- promotion authority/state;
- historical/service retention without current-consumption authority; and
- generated-artifact release gates that reject stale or unpromoted evidence.

Do not solve this by embedding board-specific counts, connector assignments, or machine facts into the reusable encoder primitive.

## 12. Block engineering versus board integration

For reusable BLOCK ENGINEERING, evidence commonly binds:

- topology and component values;
- calculations and derating;
- protection/fault behavior;
- startup/default state;
- per-instance resources;
- generic simulation/bench qualification; and
- claimed operating envelope.

For BOARD INTEGRATION, evidence commonly binds:

- instance counts;
- FPGA pins/banks/resources;
- shared power/current budgets;
- connection blocks/connectors;
- return/ground domains;
- board configuration;
- generated schematic/ERC;
- LinuxCNC/LiteX-CNC/HAL mapping; and
- board bring-up.

A board-level result must not silently promote the generic primitive, and a primitive result must not prove a board-specific mapping.

## 13. Generated artifacts and release locks

A generated schematic, resource report, FPGA image, HAL file, or manufacturing package should carry the evidence/configuration lock from which it was produced.

Before promotion verify:

`artifact semantic digest -> configuration lock -> authority set -> supporting evidence IDs -> CURRENT`

If an upstream evidence ID becomes `STALE_REVALIDATE`, affected generated consumers become stale even if their bytes have not changed.

**UNCHANGED BYTES ≠ CURRENT RELEASE EVIDENCE.**

## 14. Lab — build an evidence-promotion register

Using the inspected encoder example, create a register with at least these rows:

1. reusable AM26LV32 receiver electrical evidence;
2. six-instance LiteX-CNC A/B/Z semantic binding;
3. Rev1 primitive-to-board allocation;
4. termination-variant selection;
5. encoder field +5-V supply;
6. FPGA routed-fit/timing evidence;
7. board connector/harness mapping; and
8. personnel-safety authority.

For each row record:

- owner layer;
- current authority source;
- exact execution evidence required;
- present evidence state;
- negative scope;
- staleness dependencies;
- promotion authority; and
- next action.

Correct outcomes include `BLOCKED_UNKNOWN` and `NOT_PROMOTED`. Students lose credit for inventing machine facts merely to make every row green.

## 15. Cross-machine transfer exercise

Apply the same evidence model to one non-press-brake system: mill, lathe, plasma table, router, robot, or custom automation.

Identify one reusable validator result that can transfer unchanged and one board/machine result that cannot. Explain the dependency difference. The objective is to prove the evidence architecture is reusable even when the first worked machine is not.

## 16. Safety boundary

Ordinary LinuxCNC/FPGA/controller validation may support process-control correctness, watchdog/output inhibition, status monitoring, and interface mapping. It does not establish PL/SIL/category, stopping performance, diagnostic coverage of an independent safety function, or final-element safety validation.

A promoted evidence record must never gain `personnel_safety` authority merely because its validator ran successfully on the required local runner.

## 17. Completion standard

BD55 is complete when the student can take a green engineering run and answer, without relying on memory:

- exactly what source and claims were tested;
- exactly what inputs/dependencies/configuration were used;
- where and with what relevant tools it executed;
- which negative cases demonstrated intended detection;
- what claims the result supports and does not support;
- whether later semantic changes made any supported claims stale;
- which generated consumers must be blocked or regenerated; and
- who/what is allowed to promote the result.

The durable rule is:

**A TEST RESULT BECOMES ENGINEERING EVIDENCE ONLY WHEN ITS IDENTITY, SCOPE, PROVENANCE, APPLICABILITY, AND PROMOTION STATE ARE EXPLICIT.**

## Next exact work

Build BD56 on **evidence dependency graphs, selective invalidation, and minimum-safe revalidation**:

`promoted evidence graph -> semantic change -> affected-claim traversal -> preserved evidence -> stale evidence -> minimum justified rerun set -> downstream regeneration -> promotion recovery`

Stress changes that alter one board mapping without changing a reusable primitive, changes that alter a primitive contract without touching every consumer file, and changes whose textual diff is small but whose evidence blast radius is large.