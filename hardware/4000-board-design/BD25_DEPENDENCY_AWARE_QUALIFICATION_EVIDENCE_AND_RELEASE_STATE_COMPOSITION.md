# BD25 — Dependency-Aware Qualification Evidence and Release-State Composition

## Purpose

BD08 taught that evidence proves bounded claims, not whole designs. BD24 added stable semantic dependencies and stale propagation. BD25 joins those ideas so release state is computed from **current evidence bound to exact claims and envelopes**, not from the continued existence of old reports.

This lesson develops both linked skills:

1. **block engineering** — bind evidence to exact reusable requirements/interfaces, semantic revisions, operating envelopes, exclusions, acceptance criteria, and invalidation triggers; and
2. **board integration** — compose block evidence with board-specific connectivity, PCB/current-path/thermal, FPGA image/timing, LinuxCNC/HAL, bring-up, and machine facts without promoting one evidence class into another.

The OpenPressBrake repository is used only for current governance constraints in this lesson. The release examples are fictional/generic so no machine-specific value or qualification claim is invented.

## Student-material verification status for this run

The following current files were opened and inspected before this lesson was written and are **VERIFIED_FOR_LESSON** for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD08_QUALIFICATION_EVIDENCE_VERIFICATION_MATRIX_AND_REGRESSION_TRIGGERS.md` — bounded evidence classes, claim-specific qualification, and regression-trigger method.
- Curriculum `hardware/4000-board-design/BD24_MACHINE_READABLE_CATALOG_DEPENDENCY_GRAPH_IMPLEMENTATION_AND_MIGRATION.md` — stable semantic revisions, forward dependencies, generated reverse lookup, stale propagation, and release-gate behavior.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — exact BD25 work item and current lane state.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — distinction between integration readiness and full Rev-1 qualification, concrete-evidence requirement, and same-change maintenance rule.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable block/adapter/board-integration ownership and the independent personnel-safety boundary.

Readiness is claim-scoped. None of these files proves that the complete OpenPressBrake controller is production-qualified.

---

## 1. Evidence is a proposition binding, not a file attachment

A useful evidence record binds a result to the proposition it can actually support:

```yaml
id: EVD.GENERIC.OUTDRV.DEFAULT_OFF.BENCH_001
kind: evidence
method: bench_test
artifact_revision: fixture-r3
supports:
  - claim: QUAL.GENERIC.OUTDRV.DEFAULT_OFF
    semantic_revision: 4
    facets: [startup.unconfigured, watchdog.expired]
envelope:
  supply_v: [22, 26]
  ambient_c: [20, 25]
  load: representative_fixture
acceptance: output_remains_deenergized
result: PASS
exclusions:
  - reverse_polarity
  - surge
  - pcb_rev_other_than_tested
invalidated_by:
  - output_authority_topology_change
  - pull_network_change
  - tested_pcb_revision_change
state: CURRENT
```

The evidence artifact may be a log, calculation, report, scope capture, synthesis report, inspection record, or machine-verification record. Its file path is not the engineering claim.

Freeze:

> **EVIDENCE FILE EXISTS != CURRENT CLAIM PROVED**

---

## 2. Evidence state and engineering result are separate axes

Use evidence lifecycle states such as:

- `CURRENT` — still applicable to the exact claim/revision/envelope;
- `STALE_PENDING_REVALIDATION` — upstream semantics or applicability changed;
- `EXPIRED` — time/calibration/periodic interval exceeded where such an interval is justified;
- `SUPERSEDED` — replaced for future release use but retained for history;
- `INVALID` — method/setup/result cannot support the claimed proposition;
- `BLOCKED_UNKNOWN` — required applicability fact is `UNKNOWN` or `VERIFY_AT_MACHINE`.

Keep those separate from the result itself: `PASS`, `FAIL`, `PARTIAL`, or `NOT_APPLICABLE`.

A stale PASS is not a current PASS. A current FAIL is valuable current evidence and must not be hidden by selecting an older PASS.

Freeze:

> **PASS/FAIL != CURRENT/STALE**

---

## 3. Evidence must carry scope and envelope

At minimum, evidence-to-claim binding should record:

- stable evidence ID when durable reference is useful;
- method/evidence class;
- exact claim ID and semantic revision;
- consumed facets;
- design/PCB/FPGA/software revision where applicable;
- setup, instruments/toolchain, and configuration when material;
- operating/fault envelope actually exercised;
- acceptance criterion;
- result;
- exclusions;
- provenance;
- invalidation/regression triggers;
- evidence lifecycle state.

Do not widen an evidence envelope by prose. If a nominal 24-V bench test covered one ambient/load condition, it cannot prove a later widened voltage, temperature, cable, load, or fault envelope without justified analysis or new evidence.

Freeze:

> **VALID INSIDE TESTED/ANALYZED ENVELOPE != VALID INSIDE WIDER CLAIMED ENVELOPE**

---

## 4. Reusable evidence, board evidence, and machine evidence do not promote automatically

### Reusable-block evidence

Can support a generic block claim only within the reusable block's declared contract and qualification envelope.

### Board-integration evidence

Can support instance mapping, shared-resource composition, cross-block interactions, board-specific power/return behavior, connector mapping, PCB current paths, thermal behavior, and assembled-board behavior.

### Machine evidence

Can establish installed cable/load/device/wiring/environment/configuration facts and installed behavior.

A successful board bench test may reveal a reusable-block defect, but it does not automatically qualify the generic block for every allowed catalog use. Likewise, generic block qualification does not prove that a particular board routed, powered, configured, or connected it correctly.

Freeze:

> **BOARD BENCH PASS != REUSABLE BLOCK QUALIFICATION**
>
> **REUSABLE BLOCK QUALIFICATION != BOARD INSTANCE QUALIFICATION**

---

## 5. Release is a composed claim

A complete controller release proposition should depend on lower-level propositions rather than on a folder full of reports.

A generic composition can look like:

```text
QUAL.BOARD.RELEASE@7
  -> QUAL.BLOCK.INPUTS@3
  -> QUAL.BLOCK.OUTPUTS@4
  -> QUAL.BLOCK.FPGA_CORE@5
  -> QUAL.BOARD.CONNECTIVITY@8
  -> QUAL.BOARD.POWER_RETURNS@6
  -> QUAL.BOARD.PCB_CURRENT_THERMAL@2
  -> QUAL.BOARD.FPGA_IMAGE_TIMING@11
  -> QUAL.BOARD.LINUXCNC_HAL_MAPPING@4
  -> QUAL.BOARD.BRINGUP@3
  -> ASM.MACHINE.REQUIRED_FACTS@current
```

Every dependency can have its own evidence package and state. The top-level release is `CURRENT` only when all required dependencies are current and satisfied for the release envelope.

A useful release evaluator must fail closed on:

- missing required evidence;
- stale/invalid evidence;
- unresolved `UNKNOWN` or `VERIFY_AT_MACHINE` facts required by the claim;
- failed acceptance criteria;
- evidence whose envelope does not cover the release envelope;
- semantic revision mismatch;
- dependency-graph integrity errors.

Freeze:

> **MANY GREEN ARTIFACTS != COMPOSED RELEASE**

---

## 6. Change-impact examples

### Case A — evidence still exists, semantic revision changed

A reusable output's reset behavior changes from high-Z to driven-low. The old bench report remains in Git and still says PASS. Because it proves revision 3 while the release consumes revision 4, affected evidence becomes `STALE_PENDING_REVALIDATION` until applicability is reviewed and required testing/calculation is repeated.

### Case B — claimed envelope widened

A nominal qualification covered 22–26 V. The reusable contract expands to 18–30 V. The old evidence can remain current for the old sub-envelope but cannot close the new full-envelope claim. Record partial applicability rather than rewriting history.

### Case C — board bench evidence incorrectly promoted

One assembled board works with one load and cable. That supports the tested board/configuration. It cannot be relabeled as generic qualification for the reusable driver across its entire catalog envelope.

### Case D — J-number-only change

A compatible field connector changes from J7 to J9, with electrical contract, circuit, PCB electrical behavior, and reusable block unchanged. Board connection-definition evidence may need update/review. Generic reusable electrical qualification does not become stale merely because the board-specific designator changed.

### Case E — safety-status interface

An ordinary FPGA input may be electrically verified to read a status output from an independent safety system. That evidence can support **status-interface electrical correctness**. It does not prove the safety function, PL/SIL/category, diagnostic coverage, stopping performance, or personnel-safety authority.

Freeze:

> **SAFETY-STATUS ELECTRICAL EVIDENCE != SAFETY-FUNCTION VALIDATION**

---

## 7. Evidence selection must prefer applicability, not recency alone

When multiple evidence records exist, do not choose the newest file automatically.

Selection order should answer:

1. Does the record support the exact claim ID/revision/facets?
2. Does its envelope cover the release claim?
3. Is the method capable of proving the proposition?
4. Is the evidence lifecycle state current?
5. Are required setup/tool/instrument/calibration facts valid?
6. Has a later contradictory result or discovered degradation invalidated the prior conclusion?
7. Is the evidence reusable-, board-, or machine-scoped correctly?

A later file can be less applicable than an older one. A newly discovered failure cannot be ignored merely because a previous passing report remains stored.

---

## 8. Release-state composition should preserve why it is blocked

Do not reduce every incomplete release to `FAIL`.

Useful composed states include:

- `CURRENT_RELEASED`
- `BLOCKED_MISSING_EVIDENCE`
- `BLOCKED_STALE_EVIDENCE`
- `BLOCKED_UNKNOWN_MACHINE_FACT`
- `BLOCKED_FAILED_CRITERION`
- `BLOCKED_ENVELOPE_GAP`
- `BLOCKED_GRAPH_ERROR`
- `SUPERSEDED`

Emit the shortest causal chain:

```text
BLOCKED_ENVELOPE_GAP
QUAL.BOARD.RELEASE@7
 -> QUAL.BLOCK.OUTDRV@4
 -> EVD.GENERIC.OUTDRV.DEFAULT_OFF.BENCH_001
 reason: evidence covers 22..26 V; claim requires 18..30 V
```

This makes release state actionable rather than merely red.

---

## 9. Catalog stress-test result

Current OpenPressBrake status governance already contains the right human-level principle: integration readiness and full Rev-1 qualification are separate, checked status requires concrete repository evidence, CI proves only the tests it actually runs, and material design/evidence changes require status maintenance. Current adapter governance likewise keeps reusable, adapter, board-integration, machine, and safety authority distinct.

The missing durable layer remains machine-readable **evidence-to-semantic-claim binding and composed release-state evaluation**. A future catalog implementation should add that without duplicating electrical authority or retroactively pretending legacy evidence has scope metadata it never recorded.

This run does not retrofit active OpenPressBrake engineering files. The deficiency is recorded as `ENGINEERING_REVIEW_NEEDED`, not silently filled with invented metadata.

---

## Lab — compose and break a release claim

Build a fictional release graph with at least:

- two reusable block qualification propositions;
- one board connectivity proposition;
- one PCB current/thermal proposition;
- one FPGA image/timing proposition;
- one LinuxCNC/HAL mapping proposition;
- one bring-up proposition;
- one `VERIFY_AT_MACHINE` assumption;
- one ordinary electrical interface to an independent safety-status output.

Attach evidence records with exact claim/revision/envelope bindings. Produce `SHOW WHERE USED` for each evidence-backed proposition and compute the top-level release state.

Then adversarially perform all five changes from Section 6. For each, identify exactly which evidence remains current, which becomes stale/partial/blocked, and the shortest causal chain preventing release.

### Lab pass criteria

A passing submission must:

- never treat evidence-file existence as proof;
- distinguish evidence result from evidence lifecycle state;
- preserve exact semantic revision and envelope applicability;
- keep reusable, board, and machine evidence scopes separate;
- preserve a reusable qualification result through a board-only J-number change when electrical semantics are unchanged;
- stale or limit evidence when semantic revision/envelope changes;
- propagate unresolved machine facts to the dependent release claim;
- expose a causal blocked-release chain;
- refuse to convert safety-status interface evidence into personnel-safety validation.

---

## Compute

No simulation, synthesis, place-and-route, benchmark, or executable engineering verification is justified for this lesson. The engineering question is evidence semantics and release composition. Future executable verification remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Durable freezes

- `EVIDENCE FILE EXISTS != CURRENT CLAIM PROVED`.
- `PASS/FAIL != CURRENT/STALE`.
- `VALID INSIDE TESTED/ANALYZED ENVELOPE != VALID INSIDE WIDER CLAIMED ENVELOPE`.
- `BOARD BENCH PASS != REUSABLE BLOCK QUALIFICATION`.
- `REUSABLE BLOCK QUALIFICATION != BOARD INSTANCE QUALIFICATION`.
- `MANY GREEN ARTIFACTS != COMPOSED RELEASE`.
- `J-NUMBER CHANGE != AUTOMATIC REUSABLE ELECTRICAL INVALIDATION`.
- `SAFETY-STATUS ELECTRICAL EVIDENCE != SAFETY-FUNCTION VALIDATION`.

## Next lesson

BD26 should move from release semantics into **full-board qualification planning and evidence closure**: derive a release-oriented verification campaign from the dependency/evidence graph, order checks by risk and destructive potential, distinguish pre-power/bench/PCB/FPGA/HAL/machine evidence, challenge fault/default/partial-power states, record residual open claims, and prevent commissioning success from laundering unresolved reusable or safety claims into a production-release statement.