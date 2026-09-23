# BD56 — Evidence Dependency Graphs, Selective Invalidation, and Minimum-Safe Revalidation

## Purpose

BD55 gave validator results durable identities. BD56 teaches what happens after an engineering change:

`promoted evidence graph -> semantic change -> affected-claim traversal -> preserved evidence -> stale evidence -> minimum justified rerun set -> downstream regeneration -> promotion recovery`

The goal is neither “rerun everything” nor “rerun only the file that changed.” The goal is to invalidate exactly the engineering claims whose dependencies changed, preserve evidence whose semantic premises remain true, and prove the smallest revalidation set that safely restores promotion.

This applies to both BLOCK ENGINEERING and BOARD INTEGRATION. It grants no personnel-safety authority to ordinary LinuxCNC/FPGA evidence.

## Student-material readiness audit

The following current files were opened and inspected during this run before being presented here:

- Curriculum `README.md` — **VERIFIED_FOR_LESSON** for exact-revision provenance, reproducible evidence, uncertainty handling, and completion by technical handoff rather than prose volume.
- Curriculum `WORK_SELECTION_POLICY.md` — **VERIFIED_FOR_LESSON** for selecting unblocked, evidence-gaining work rather than manufacturing activity.
- Curriculum `hardware/4000-board-design/BD55_VALIDATOR_EVIDENCE_PROVENANCE_EXECUTION_IDENTITY_AND_REGRESSION_RESULT_PROMOTION.md` — **VERIFIED_FOR_LESSON** for result identity, claim promotion, negative scope, and partial staleness.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — **VERIFIED_FOR_LESSON** for progress through BD55 and the BD56 checkpoint.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for truthful status, concrete evidence, and mandatory checklist maintenance after material changes.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for block/adapter/board ownership and fail-closed composition.
- OpenPressBrake `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` — **VERIFIED_FOR_LESSON** for the bounded encoder status and remaining release gates.
- OpenPressBrake `hardware/blocks/differential_encoder/integration/REV1_BOARD_INTEGRATION_HANDOFF.md` — **VERIFIED_FOR_LESSON** for primitive-versus-board ownership, termination and field-power unknowns, and the three-input FPGA contract.
- OpenPressBrake `hardware/blocks/differential_encoder/integration/rev1_litexcnc_encoder_binding.json` — **VERIFIED_FOR_LESSON** for six A/B/Z logical bindings, Rev29 physical authority, and zero safety credit.
- OpenPressBrake `hardware/blocks/differential_encoder/integration/validate_rev1_litexcnc_encoder_binding.py` — **VERIFIED_FOR_LESSON** as current validator source, not execution evidence.
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/integration/rev29_max22216_rgmii_cabga256_pin_plan.json` — **VERIFIED_FOR_LESSON** for current Rev29 physical package allocation and the preserved 18 encoder balls.
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/integration/rev31_litexcnc_rev1_proven_modules.json` — **ENGINEERING_REVIEW_NEEDED** as a whole production-runtime authority because it deliberately retains obsolete pre-MAX22216 proportional PWM/discrete-driver entries; it is used here only as historical/proven LiteX-CNC module provenance and encoder/stepgen source data.
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/integration/rev32_openpressbrake_litexcnc_binding.json` — **VERIFIED_FOR_LESSON** for its explicit current role: fail-closed transformation of obsolete proportional entries into the Rev29 two-MAX22216 physical contract while retaining the older file only as bounded provenance input.

No file above is presented as evidence that the current OpenPressBrake controller is production-proven.

## Learning objectives

The student must be able to:

1. model claims, evidence, semantic authorities, generated artifacts, configuration facts, and unresolved physical facts as different dependency-node types;
2. distinguish direct from transitive invalidation;
3. invalidate a claim when a semantic premise changes even if its consumer file is byte-identical;
4. preserve evidence when a neighboring subsystem changes but the claim's complete dependency set remains equivalent;
5. compute a minimum-safe rerun set from affected claims rather than from filenames;
6. recognize shared-resource and whole-board nodes that enlarge the blast radius;
7. regenerate downstream schematic/FPGA/HAL/release artifacts only when their semantic locks require it;
8. keep reusable-block evidence separate from board-integration evidence; and
9. preserve `VERIFY_AT_MACHINE` and zero-safety-credit boundaries.

## 1. The evidence graph is typed

A useful graph contains at least these node classes:

- `SEMANTIC_AUTHORITY` — block contract, board mapping, power-domain rule, pin plan, configuration lock;
- `CLAIM` — a stable engineering proposition such as `ENC.BIND.ABZ_PACKAGE_MAP`;
- `EVIDENCE` — calculation, datasheet audit, validator result, simulation, bench result, ERC, synthesis/timing result;
- `GENERATED_ARTIFACT` — schematic, FPGA image, resource report, HAL/config, manufacturing output;
- `PHYSICAL_FACT` — installed cable, termination, machine voltage, encoder current, harness destination;
- `SHARED_RESOURCE` — FPGA bank, bus, rail, return domain, connector capacity, shared ADC/DAC/SPI resource;
- `RELEASE` — promoted configuration/revision consuming named claims and artifacts.

Edges are also typed. Useful relationships include `DEPENDS_ON`, `PROVES`, `CONSUMES`, `GENERATED_FROM`, `CONSTRAINS`, `SUPERSEDES`, and `BLOCKED_BY`.

A file path is provenance metadata on a node. It is not the graph itself.

**FILE DEPENDENCY ≠ ENGINEERING DEPENDENCY.**

## 2. Invalidation follows meaning, not edit distance

For a change set `Δ`, start from changed semantic nodes, not changed files.

Then traverse only edges whose relationship can affect the claim:

`Affected(Δ) = transitive_consumers(changed_semantics, claim-relevant edges)`

Classify each promoted claim:

- `PRESERVED` — all claim-relevant semantic premises remain equivalent;
- `STALE_REVALIDATE` — a premise changed and the old evidence no longer proves the current claim;
- `PARTIALLY_STALE` — evidence record supports several claims but only some premises changed;
- `BLOCKED_UNKNOWN` — a required physical/configuration fact is unresolved;
- `SUPERSEDED` — a newer authority/result replaces the old one;
- `HISTORICAL_ONLY` — retained for provenance but not current consumption.

**SMALL TEXT DIFF ≠ SMALL EVIDENCE BLAST RADIUS.**

**LARGE TEXT DIFF ≠ ALL EVIDENCE STALE.**

## 3. Worked OpenPressBrake case: proportional rebase without encoder requalification

The current Rev29 physical pin authority replaces the obsolete discrete proportional architecture with two MAX22216 devices on shared SPI. That is a major proportional-control semantic change. It removes six PWM resources plus discrete per-channel enable/fast-overcurrent/status GPIO and replaces them with shared SPI plus two `CS_N` and two `N_FAULT` resources.

Yet Rev29 intentionally preserves all 18 `ENCn_A/B/Z` package balls. The current encoder binding explicitly rebased its physical authority from Rev27 to Rev29 without changing those encoder balls. The encoder validator checks the Rev29 plan directly.

Therefore a correct dependency graph can say:

- proportional-driver resource claims: `STALE_REVALIDATE` or `SUPERSEDED` by the MAX22216 architecture;
- whole-board unique-GPIO/resource-total claims: `STALE_REVALIDATE` because shared-resource accounting changed;
- encoder A/B/Z package-map claim: potentially `PRESERVED`, because its exact 18 semantic signals and balls are unchanged and current validator authority points to Rev29;
- encoder termination selection: still `BLOCKED_UNKNOWN`; proportional architecture does not resolve cable topology;
- encoder field +5-V supply: still open; proportional architecture does not prove it;
- reusable AM26LV32 receiver electrical evidence: preserved unless a receiver/topology/envelope dependency changed;
- personnel-safety authority: remains `none`.

This is selective invalidation. Re-running encoder SPICE merely because the proportional architecture changed would add little evidence. Failing to re-solve whole-board FPGA resource totals would be unsafe.

## 4. Historical source can remain without remaining current authority

The current `rev31_litexcnc_rev1_proven_modules.json` is intentionally awkward: it contains useful pinned LiteX-CNC GPIO/encoder/stepgen provenance but also obsolete six-PWM/discrete proportional entries. The current `rev32_openpressbrake_litexcnc_binding.json` explicitly declares that those proportional entries are rejected/transformed before production parsing and are not production runtime authority.

This yields a critical graph rule:

**NODE RETAINED FOR PROVENANCE ≠ NODE AUTHORIZED FOR EVERY SEMANTIC FACET.**

The dependency graph must support facet-level authority. Consumers of encoder provenance may legitimately depend on the retained encoder portion. A new production proportional-resource report must not consume the obsolete proportional facet as current authority.

If tooling can express only “depends on file X,” it cannot represent this safely.

## 5. Direct and transitive invalidation

Example: move `ENC3_Z` to a different legal FPGA ball.

Directly stale:

- encoder package-map claim;
- encoder binding validator evidence;
- package-collision proof;
- board FPGA pin allocation evidence.

Transitively stale if they consume that mapping:

- generated FPGA constraints/platform resources;
- routed FPGA synthesis/place-route/timing evidence;
- schematic/netlist connector-to-FPGA mapping if the physical board connection changes;
- board bring-up records tied to the prior ball;
- released configuration digest.

Likely preserved:

- AM26LV32 receiver calculations;
- termination electrical options;
- receiver BOM;
- unrelated digital I/O qualification;
- machine cable facts, unless the connector/harness changed.

Do not modify the reusable receiver primitive to absorb a board pin move.

## 6. Shared resources enlarge the blast radius

Changes to a shared node can invalidate claims in otherwise untouched consumers.

Examples:

- SPI clock semantics change -> every bus consumer timing/protocol claim must be reviewed;
- 3V3 source capacity changes -> aggregate rail-margin claims and consumers near limits may stale;
- FPGA bank VCCIO changes -> every pin in that bank requires compatibility review;
- return-domain bond changes -> all affected transient/current-return claims require review;
- connector family change -> creepage/current/pinout/harness evidence can stale across several blocks.

This is why board integration must publish shared-resource dependencies explicitly rather than hiding them in prose.

## 7. Minimum-safe revalidation is a set-cover problem with engineering constraints

After invalidation, choose evidence actions that cover every stale claim while respecting required evidence class.

Conceptually:

`R_min = smallest justified set of checks such that every stale required claim has adequate current evidence`

But “smallest” does not mean cheapest at any cost. Constraints include:

- a static validator cannot replace a required physical measurement;
- SPICE cannot replace routed FPGA timing;
- synthesis cannot prove cable termination;
- a board-level check cannot silently qualify a generic primitive;
- a primitive bench test cannot prove a board connector mapping;
- ordinary controller tests cannot prove personnel-safety performance.

Prefer one check that legitimately covers several stale claims over redundant checks, but never merge unlike evidence classes merely to reduce runtime.

## 8. Three change classes students must distinguish

### A. Board mapping changes, primitive unchanged

Typical reruns: mapping validator, collision/resource checks, generated schematic/constraints, ERC, FPGA fit/timing if physical FPGA resources changed, affected bring-up.

Typical preserved evidence: primitive topology/calculations/BOM/protection if its interface envelope is unchanged.

### B. Primitive contract changes, consumer files untouched

Example: output-current envelope, default state, return-domain requirement, or pin semantics change.

Every consuming board/adapter must be found through reverse dependencies even if no consumer file changed. Re-run compatibility, aggregate resource/power checks, affected schematic/ERC, and qualification appropriate to the changed primitive claim.

**CONSUMER FILE UNCHANGED ≠ CONSUMER EVIDENCE CURRENT.**

### C. Shared-resource change

Recompute every dependent aggregate and boundary claim. This often has a larger blast radius than the textual edit suggests.

## 9. Promotion recovery sequence

For each change:

1. identify changed semantic facets and exact prior/new authority;
2. traverse reverse dependencies to affected claims;
3. classify preserved, stale, blocked, superseded, and historical evidence;
4. identify generated artifacts whose semantic lock contains stale claims;
5. choose the minimum adequate revalidation set;
6. run executable checks only on the authorized environment when genuinely required;
7. capture exact result identity and negative scope;
8. regenerate only affected downstream artifacts;
9. review semantic diffs;
10. repromote bounded claims; and
11. rebuild release identity from the new current claim/evidence set.

Never “unstale” evidence by editing its metadata to point at the new source. Produce new evidence or an explicit equivalence justification with review authority.

## 10. Machine-readable dependency record pattern

A future catalog layer should be able to express records like:

```yaml
claim_id: ENC.BIND.ABZ_PACKAGE_MAP
owner: board_integration
subject: differential_encoder/rev1
semantic_dependencies:
  - ENC.PRIMITIVE.ABZ_SINGLE_ENDED_OUTPUT
  - FPGA.REV29.ENCODER_PACKAGE_MAP
  - LITEXCNC.ENCODER.INSTANCE_CONFIG
supporting_evidence:
  - ENC-BIND-REV29-001
consumers:
  - FPGA.REV1.IMAGE_BINDING
  - BOARD.REV1.ENCODER_NETS
negative_scope:
  - termination_selection
  - encoder_field_5v
  - personnel_safety
state: CURRENT
```

This is methodology, not a claim that OpenPressBrake already implements this exact schema.

## 11. Catalog stress-test finding

The current encoder/MAX22216 rebase demonstrates that OpenPressBrake already performs selective semantic preservation manually: Rev29 changed proportional architecture while deliberately preserving encoder balls, and the encoder binding was rebased to current physical authority. However, the reasoning is distributed across revision prose, JSON contracts, validators and status checklists.

Classification: **ENGINEERING_REVIEW_NEEDED** for a machine-readable evidence-dependency graph that supports:

- stable semantic claim IDs;
- facet-level dependencies rather than whole-file authority;
- reverse lookup / Show Where Used;
- typed shared-resource dependencies;
- preserved/stale/partially-stale state;
- explicit supersession;
- generated-artifact evidence locks;
- minimum-safe rerun planning;
- unresolved physical facts; and
- promotion recovery.

A particularly important requirement is to represent a retained historical/provenance source such as Rev31 as authoritative for selected unchanged facets while explicitly ineligible for obsolete proportional runtime facets. Do not solve this by deleting provenance or by copying machine-specific facts into reusable blocks.

## 12. Lab — compute the blast radius

Given the inspected encoder/FPGA artifacts, analyze these changes independently:

1. `ENC3_Z` moves to a different FPGA ball, receiver circuit unchanged.
2. AM26LV32 maximum-current budgeting value changes after a datasheet correction, pin map unchanged.
3. MAX22216 architecture replaces the obsolete discrete proportional PWM allocation while all 18 encoder balls remain unchanged.
4. Actual machine evidence selects `rs422_120r_protected` for one populated encoder.
5. FPGA bank-1 VCCIO changes away from 3.3 V.

For each, produce:

- changed semantic nodes;
- directly stale claims;
- transitively stale claims/artifacts;
- preserved evidence with reason;
- `BLOCKED_UNKNOWN` items;
- minimum adequate revalidation set;
- whether local executable compute is required; and
- safety-boundary statement.

A correct answer does not maximize reruns. It maximizes justified coverage while preserving valid evidence.

## 13. Cross-machine transfer

Apply the same graph method to one non-press-brake controller:

- mill spindle encoder plus VFD interface;
- lathe spindle/index plus threading path;
- plasma torch-height analog/input chain;
- router step/dir bank plus field enables;
- robot joint encoders plus shared bus; or
- automation cell digital I/O plus relay outputs.

Show at least one board-specific change that leaves reusable primitive evidence valid and one reusable-block change that invalidates multiple board consumers without editing their files.

## 14. Safety boundary

Evidence graphs for ordinary LinuxCNC/FPGA control may track watchdogs, output inhibits, safety-status monitoring, and interfaces to independent STO/enable mechanisms. They do not grant personnel-safety authority.

If an independent safety subsystem is a dependency, record the boundary and interface facts needed by ordinary control. Do not model ordinary-controller validation as proof of PL/SIL/category, stopping performance, safety diagnostic coverage, or final-element safety validation.

## 15. Durable rules frozen by BD56

- **FILE DEPENDENCY ≠ ENGINEERING DEPENDENCY.**
- **CONSUMER FILE UNCHANGED ≠ CONSUMER EVIDENCE CURRENT.**
- **SMALL TEXT DIFF ≠ SMALL EVIDENCE BLAST RADIUS.**
- **LARGE TEXT DIFF ≠ ALL EVIDENCE STALE.**
- evidence invalidation follows semantic facets and typed reverse dependencies;
- historical provenance may remain valid for selected facets while being ineligible for superseded facets;
- shared-resource changes can invalidate untouched consumers;
- minimum-safe revalidation must cover every stale claim with the correct evidence class;
- preserved evidence requires an explicit equivalence reason, not convenience;
- generated artifacts become stale when a supporting semantic/evidence lock becomes stale even if bytes are unchanged;
- block evidence and board-integration evidence remain separate; and
- ordinary-control evidence receives zero personnel-safety credit unless separate safety-rated authority explicitly establishes otherwise.

## Next checkpoint

Build BD57 on **evidence-equivalence decisions and preservation proofs**:

`changed dependency -> claimed equivalence -> equivalence criteria -> counterexample search -> bounded preservation proof -> reviewer authority -> preserved-evidence record -> future invalidation trigger`

Stress the dangerous middle ground where a dependency changed but engineers believe an existing result still applies. Teach when that can be justified without rerunning and when a rerun is mandatory.