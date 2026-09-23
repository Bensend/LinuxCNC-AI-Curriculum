# BD49 — Configuration Change Control, Deterministic Regeneration, and Semantic Diff Review

## Purpose

BD48 closed initial configuration selection. BD49 addresses what happens after a locked board configuration changes:

`locked configuration -> requested change -> semantic intent diff -> affected authority/resource set -> re-solve -> deterministic regeneration -> semantic output diff -> targeted verification -> promotion/release decision`

The goal is not merely to regenerate files. The goal is to prove what engineering meaning changed, what remained valid, and which evidence must be repeated before the regenerated configuration may be promoted.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `hardware/4000-board-design/BD48_CONFIGURATION_SELECTION_CLOSURE_AMBIGUITY_RESOLUTION_AND_FAIL_CLOSED_BOARD_GENERATION.md` — **VERIFIED_FOR_LESSON** for selection locks, ambiguity, topology-aware resources, and deterministic generation.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for the board-design handoff.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for evidence truthfulness, material-change reconciliation, and readiness semantics.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for immutable reusable contracts during board composition and correct adapter/integration classification.
- OpenPressBrake `hardware/blocks/relay_contactor_driver/manifest.yaml` — **VERIFIED_FOR_LESSON** for the current one-coil reusable contract, three FPGA GPIOs per instance, shared field resources, and unresolved final board envelope.
- OpenPressBrake `hardware/blocks/relay_contactor_driver/REV1_BOARD_INTEGRATION_HANDOFF.md` — **VERIFIED_FOR_LESSON** for current board-owned population, FPGA, connector, branch-protection, field-distribution, mapping, and current-envelope decisions.
- OpenPressBrake `hardware/blocks/relay_contactor_driver/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the current `SIMULATION-READY` state and remaining qualification/release gates.

The relay-driver material is a bounded integration example. It is not presented as `SCHEMATIC-READY`, production-proven, safety-rated, or `REV 1 READY`.

## Learning objectives

The student must be able to:

1. express a configuration change as semantic intent rather than only a file diff;
2. identify directly and transitively affected blocks, connection mappings, resources, generated artifacts, and evidence;
3. preserve reusable block contracts when a change is board-specific;
4. re-solve shared resources and packing after population changes;
5. distinguish deterministic regeneration from engineering equivalence;
6. review semantic output changes even when textual/generated files look similar;
7. select targeted regression from changed claims and dependencies;
8. retain negative evidence and superseded configuration identity; and
9. keep ordinary-controller change review separate from personnel-safety validation.

## 1. Change control starts with the locked baseline

A requested change must identify the exact configuration lock being changed. Capture:

- baseline configuration/release identity;
- requested engineering intent;
- reason and authority for the request;
- changed machine requirements or physical facts, if any;
- allowed scope; and
- explicitly prohibited collateral changes.

Do not start from a working directory whose provenance is uncertain.

**LATEST FILES ≠ KNOWN BASELINE.**

## 2. Review semantic intent before text

Classify the requested change by meaning. Useful facets include:

- required function/channel population;
- reusable electrical contract;
- adapter contract;
- connector/pin/harness mapping;
- FPGA pin/bank/logical allocation;
- bus/address allocation;
- power/current/startup/thermal demand;
- package/shared-resource packing;
- physical placement or label;
- LinuxCNC/HAL semantic mapping;
- machine fact; and
- evidence/release applicability.

A one-line configuration edit may change several of these. Conversely, a large regenerated file may contain no engineering-semantic change.

**TEXT DIFF SIZE ≠ ENGINEERING CHANGE SIZE.**

## 3. Compute the affected authority/resource set

Use stable dependency edges and `SHOW WHERE USED` semantics to identify:

1. directly changed semantic claims;
2. reusable blocks/adapters whose contracts are consumed;
3. board-specific connection blocks;
4. shared FPGA, bus, power, connector, package, thermal, and return-path resources;
5. generated schematic/BOM/resource/FPGA/HAL outputs; and
6. evidence whose assumptions include any changed claim.

Unchanged evidence is preserved only when its assumptions remain demonstrably unchanged.

**FILE UNCHANGED ≠ EVIDENCE STILL APPLICABLE.**

## 4. Board-only changes must remain board-only

A connector pin swap, silkscreen correction, physical connector choice, instance-to-FPGA mapping, or machine wire-number remap does not justify modifying a reusable block when its published electrical contract remains satisfied.

If the change reveals real translation, isolation, filtering, clamping, or another meaningful electrical function, apply the block/adapter/integration decision test instead.

**BOARD MAPPING CHANGE ≠ BLOCK REDESIGN.**

## 5. Population changes force shared-resource re-solving

Adding or removing one primitive can affect more than one channel line. Recompute all shared constraints whose equations include population or grouping:

- package count and spare channels;
- FPGA GPIO/bank allocation;
- rail current and startup demand;
- branch protection and simultaneous-load assumptions;
- connector/contact allocation;
- board area/placement/routing pressure;
- bus addresses/chip selects; and
- thermal/current-path limits.

Do not patch only the visible instance table.

### Bounded OpenPressBrake example

The current `relay_contactor_driver` primitive is one external 24 V coil driver. Each populated instance consumes one `COIL_COMMAND` FPGA output plus two diagnostic FPGA inputs. `COIL_FIELD_24V_PROTECTED` and branch protection are shared board resources; physical connector selection, installed count, FPGA ball assignment, field distribution, machine mapping, and final published current/repetition/simultaneity envelope remain integration-owned.

Therefore changing configured relay-driver population from `N` to `N+1` necessarily changes FPGA demand from `N` command outputs and `2N` diagnostic inputs to `N+1` and `2(N+1)`. It also triggers re-evaluation of field distribution, branch protection, simultaneous-channel assumptions, connector allocation, and PCB current/thermal constraints. It does **not** justify changing the one-coil reusable primitive merely because the board gained a channel.

The current block remains `SIMULATION-READY`; its final board current/repetition/simultaneity envelope, abnormal/fault qualification, PCB constraints, shared-resource closure, board integration, and human signoff remain open. A population-change exercise must not imply those release gates are already closed.

## 6. Re-solve before regenerating

Run the BD48 compatibility/constraint solver against the changed intent and current eligible authorities. A formerly unique solution may become:

- `UNIQUE_VALID_SELECTION` again;
- `MULTIPLE_VALID_SELECTIONS` because the change opens alternatives;
- `NO_VALID_SELECTION` because a shared resource is exceeded; or
- `BLOCKED_UNKNOWN_FACT` because a new physical fact is required.

Generation remains blocked unless the intended output's required selection state is closed.

**OLD SELECTION + NEW INTENT ≠ VALID CONFIGURATION.**

## 7. Deterministic regeneration is necessary but not equivalence proof

Regeneration must pin:

- baseline and new configuration-lock identities;
- exact consumed authority revisions/digests;
- decision records;
- generator/schema/tool versions;
- resolved resource allocations; and
- output digests.

The same locked inputs should reproduce the same semantic outputs. But a successful deterministic run does not prove the new configuration is equivalent to the old one.

**DETERMINISTIC REGENERATION ≠ ENGINEERING EQUIVALENCE.**

## 8. Perform a semantic output diff

Review generated outputs by engineering meaning, not only bytes or line order.

At minimum compare:

- function/channel population;
- connector and pin assignments;
- electrical nets and return paths;
- component/package population;
- power/current/startup resource totals by node/domain;
- FPGA pins, banks, clocks, LUT/register/BRAM/PLL and reserved resources;
- bus/address allocation;
- default/reset/watchdog authority;
- LinuxCNC/HAL names and semantics;
- unresolved `VERIFY_AT_MACHINE` facts;
- qualification assumptions; and
- safety-boundary annotations.

A schematic can look electrically identical while having different authority inputs, generator versions, configuration facts, or evidence applicability.

**SAME-LOOKING SCHEMATIC ≠ SAME RELEASE IDENTITY.**

Likewise, a large textual diff caused by deterministic ordering or generator formatting is not automatically a large engineering change.

## 9. Target verification from changed semantics

Regression scope should follow the changed claims and their dependency closure.

Examples:

- connector-only remap: mapping consistency, connector ratings, harness destination, ERC/connectivity, labels; no automatic reusable-block electrical requalification;
- population increase: shared rail/current/startup, package/resource packing, FPGA allocation, connector capacity, thermal/simultaneous-load checks;
- reusable block electrical-contract revision: block requalification plus every dependent board/configuration claim affected by changed facets;
- FPGA/HAL semantic remap: pin/bank resource checks, gateware/HAL mapping, default/output authority, bring-up tests;
- changed power-domain topology: current-return tracing, startup/transient budgets, protection coordination, ERC/layout constraints.

Do not use a downstream pass to erase an upstream failed or stale claim.

**TARGETED REGRESSION ≠ MINIMAL CONVENIENT TESTING.**

## 10. Promotion decision

The regenerated candidate may be promoted only when:

1. semantic intent is authorized;
2. selection is closed;
3. every material generated difference is explained;
4. required targeted verification is current and passing;
5. unresolved facts are compatible with the claimed release scope;
6. superseded baseline identity remains recoverable;
7. downstream service/new-build applicability is explicit; and
8. human release authority required by project governance is satisfied.

A generated candidate can be technically useful while remaining unpromoted.

## 11. Adversarial lab

### Case A — one-channel population increase

Add one instance of a one-channel primitive.

Expected reasoning: recompute GPIO, shared rail/protection, connector, thermal, package/grouping, and board-placement resources. Do not fork the reusable primitive into a machine-count variant.

### Case B — connector-only remap

Move an already compatible field signal to another connector position with unchanged electrical requirements.

Expected reasoning: keep the reusable block unchanged. Update the board-specific connection block/mapping and verify connector/harness semantics plus generated connectivity.

### Case C — upstream block contract changes

A reusable block changes a declared rail demand or FPGA requirement while the board intent is unchanged.

Expected reasoning: mark dependent resource evidence/generated outputs stale through dependency edges, re-solve, regenerate, and repeat affected checks. An unchanged board configuration file is not proof of no impact.

### Case D — regenerated schematic looks identical

Two generated schematics render identically, but one consumed a superseded block authority and the other consumed its current successor.

Expected reasoning: they are not automatically equivalent release artifacts. Compare authority provenance and changed semantic facets; retain distinct configuration/release identities until non-impact is established.

### Case E — safety-related ordinary interface remap

A status-monitor input from an independent safety system moves to a different FPGA pin and ordinary-controller checks pass.

Expected reasoning: verify the ordinary monitoring path and default behavior, but do not claim that this validates the independent personnel-safety function, PL/SIL/category, stopping performance, or final elements.

## 12. Machine-readable change record

A future configuration system should support a record conceptually like:

```yaml
configuration_change_id: CHG-<stable-id>
baseline_lock: null
requested_intent:
  authority: null
  reason: null
  semantic_facets: []
affected:
  direct_claims: []
  dependent_authorities: []
  shared_resources: []
  generated_outputs: []
  evidence: []
resolve_result: null
new_selection_lock: null
semantic_diff:
  changed: []
  preserved: []
  unresolved: []
verification:
  required: []
  results: []
promotion:
  state: CANDIDATE
  release_authority: null
  applicability: []
provenance:
  baseline_output_digests: []
  regenerated_output_digests: []
```

This is schema direction, not a claim that OpenPressBrake currently implements it.

## 13. Catalog stress-test result

BD49 exposes a missing machine-readable **configuration-change and semantic-regeneration layer** above selection locks. It must connect requested semantic intent to reverse dependencies, shared-resource re-solving, generated-output semantic diffs, evidence invalidation/preservation, targeted regression, and release applicability.

The relay-driver example reinforces a catalog requirement: per-instance resource demand is not enough by itself. Integration tooling must also know which resources scale linearly with instance count and which require board-owned aggregation, protection, thermal, connector, and simultaneous-load closure.

Proposed infrastructure remains **ENGINEERING_REVIEW_NEEDED**. No OpenPressBrake engineering file is changed by this lesson because current main is actively advancing Rev-1 board integration.

## 14. Compute rule

No simulation, synthesis, place-and-route, timing/resource execution, or executable regression is required merely to teach this change-control method. If a real semantic change requires executable verification, run it only on `[self-hosted, openpressbrake]`. If that authorized compute is unavailable, preserve `BLOCKED/NOT_RUN`; never substitute hosted compute.

## 15. Safety boundary

Configuration change review may verify ordinary LinuxCNC/FPGA monitoring, watchdog, inhibit, or STO/enable-interface behavior within its declared role. It does not establish independent personnel-safety authority.

**ORDINARY CONTROLLER DIFF REVIEW ≠ SAFETY VALIDATION.**

## Completion criteria

The student passes BD49 when they can start from an exact locked baseline, express a change semantically, compute affected dependencies/resources, preserve block/adapter/integration boundaries, re-solve before generation, perform deterministic regeneration, review semantic rather than merely textual output differences, derive targeted regression from changed claims, and make a bounded promotion decision without overstating safety or qualification.

## Next lesson

BD50 should cover **generated-artifact equivalence, canonicalization, and reproducibility acceptance**:

`two candidate generations -> normalize non-semantic variation -> compare semantic model -> compare authority/provenance -> classify exact/equivalent/materially-different -> reproducibility evidence -> acceptance or investigation`
