# BD27 — Qualification Finding Disposition and Regression Closure

## Purpose

BD25 made release evidence claim- and revision-bound. BD26 derived a full-board qualification campaign from those release dependencies. BD27 teaches what happens when that campaign finds something wrong.

The core workflow is:

`failed/anomalous evidence -> preserve evidence -> classify finding -> locate owning authority -> corrective revision -> SHOW WHERE USED -> select regressions -> rerun/recalculate/review/requalify -> recompute residual release state`

This lesson develops both linked skills:

1. **block engineering** — decide when a board-level finding exposes a genuine reusable-block defect, revise the reusable authority on generic engineering grounds, preserve failed evidence, and requalify the affected claims; and
2. **board integration** — distinguish reusable defects from adapter defects, connection/mapping errors, shared-resource interactions, FPGA/HAL errors, and machine-only mismatches, then regress exactly the affected composition without contaminating unrelated reusable blocks.

OpenPressBrake is used only for bounded current governance/status examples. Nothing in this lesson claims the current controller is production-qualified.

## Hard student-material audit

The following files were opened and inspected in their current `main` form during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md` — exact evidence/claim/revision binding, stale-state propagation, and composed release states.
- Curriculum `hardware/4000-board-design/BD26_FULL_BOARD_QUALIFICATION_PLANNING_AND_EVIDENCE_CLOSURE.md` — release-derived campaign planning, residual-open-claim ledger, preservation of negative evidence, and release review.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — lane state and the exact BD27 assignment before this lesson.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — integration versus full-qualification gates, concrete-evidence requirement, and same-change status maintenance.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block/adapter/board-integration ownership, machine-fact handling, and safety boundary.
- OpenPressBrake `hardware/blocks/digital_output_24v/STATUS_CHECKLIST.md` — a current example where reusable shared-reference circuitry and the first-board isolated implementation have deliberately different applicability and unresolved release work.

The OpenPressBrake digital-output status is **not** student authority for a completed Rev1 implementation. Its isolated board path still has open production BOM/capture, structural validation, rendered-connectivity, fault/corner, PCB thermal/current-path, integration, and human-release gates.

---

## 1. A failed test is evidence, not permission to patch the nearest file

When a qualification item fails or behaves unexpectedly, first preserve the exact observation:

- evidence ID and result;
- tested article/revision;
- stimulus and envelope;
- expected witness;
- actual witness;
- stop condition or anomaly;
- setup/tool/instrument facts that matter;
- exact claim the test attempted to support;
- links to the design/configuration revisions under test.

Do not edit the design and overwrite the failing log. The failed result becomes historical evidence for the old revision and a provenance link for the corrective action.

Freeze:

> **FAILED EVIDENCE != DISPOSABLE EVIDENCE**

A current failure can be more valuable than ten old passes because it identifies a proposition the current design does not satisfy.

---

## 2. Classify the finding before choosing the fix

Use an ownership classification such as:

- `REUSABLE_BLOCK_DEFECT` — the generic reusable contract/circuit/evidence is wrong or incomplete for its claimed envelope;
- `ADAPTER_DEFECT` — a genuine reusable transformation/interface block fails its own A/B contract;
- `BOARD_INTEGRATION_DEFECT` — compatible blocks were composed incorrectly, a shared resource was misallocated, or a cross-block interaction was not handled;
- `CONNECTION_DEFINITION_DEFECT` — board-specific connector/pin/location/silkscreen/harness mapping is wrong while reusable electrical semantics remain valid;
- `FPGA_RESOURCE_OR_LOGIC_DEFECT` — package pin, bank, clock/resource, image, or ordinary FPGA logic is wrong;
- `LINUXCNC_HAL_MAPPING_DEFECT` — the hardware may be correct but the software-visible semantic path is mapped/configured incorrectly;
- `MACHINE_FACT_MISMATCH` — the installed machine differs from a declared/assumed physical fact and the reusable design is not thereby defective;
- `TEST_OR_EVIDENCE_DEFECT` — fixture, method, acceptance criterion, instrumentation, or evidence binding is incapable/incorrect;
- `UNRESOLVED` — evidence is insufficient to assign authority; stop rather than patch by guess.

The finding can reveal more than one defect, but each corrective action still needs a proper owner.

Freeze:

> **WHERE FAILURE WAS OBSERVED != WHERE DEFECT IS OWNED**

---

## 3. Reusable-block defects require generic engineering justification

A board test can expose a reusable-block defect. Example: a block claims deterministic inactive behavior whenever its logic side is unpowered, but the assembled board demonstrates a back-power path intrinsic to the block topology under a condition already inside the reusable contract.

That is not a reason to add board-specific glue. The reusable block authority must be corrected because its generic claim is false.

A proper correction should:

1. preserve the failing evidence against the old semantic/design revision;
2. revise the block requirement/interface/topology or narrow the claimed envelope;
3. update calculations, BOM/connectivity/status as affected;
4. increment the relevant semantic revision;
5. mark evidence consuming the changed facets stale;
6. use `SHOW WHERE USED` to identify every board/adapter/resource consumer;
7. select and execute justified regressions;
8. requalify the corrected reusable claim before dependent release claims can return current.

Do not silently broaden or narrow the contract merely to make the current board pass.

---

## 4. Machine-only mismatches must not contaminate reusable blocks

Suppose a reusable input is valid for a published electrical envelope, but the installed machine has an undocumented sensor variant outside that envelope.

The observation is real. The reusable block is not automatically defective.

Correct options may include:

- correct the machine configuration/wiring;
- select another already-qualified block;
- introduce a genuine reusable adapter if a meaningful transformation is justified;
- revise the reusable block only if there is independent generic engineering reason to expand its envelope;
- leave the condition `VERIFY_AT_MACHINE`/blocked until the physical fact is established.

Freeze:

> **MACHINE MISMATCH != AUTOMATIC REUSABLE-BLOCK DEFECT**

This protects the catalog from becoming a collection of accidental machine-specific exceptions.

---

## 5. Adapter defects and board mappings have different corrective homes

Current OpenPressBrake governance requires real electrical transformation circuitry to live in a qualified adapter, while connector/pin/net/placement mapping stays board integration.

Therefore:

- a level translator whose output threshold is wrong is an adapter defect;
- a field connector assigned to the wrong otherwise-compatible channel is a connection-definition defect;
- a missing isolator cannot be repaired by documenting a board wire;
- a swapped J-number does not justify revising reusable electrical qualification;
- a board-specific FPGA package pin assignment belongs to board/FPGA integration, not the generic I/O block.

Freeze:

> **CORRECTIVE HOME FOLLOWS ENGINEERING AUTHORITY, NOT FILE CONVENIENCE**

---

## 6. J-number-only corrections should have narrow invalidation

Consider a connection definition that maps a compatible field signal to J7 but the intended connector is J9. If voltage/current/reference semantics, reusable block, electrical topology, PCB current path, and logical function are unchanged, the correction can invalidate:

- connection-definition review;
- connector/harness mapping evidence;
- board drawing/silkscreen evidence where affected;
- machine installation verification if already performed against the old mapping.

It should not automatically stale:

- generic reusable-block electrical qualification;
- unrelated block calculations;
- an unchanged adapter's qualification;
- unrelated FPGA timing evidence.

The dependency graph should make this distinction mechanically possible.

Freeze:

> **BOARD LABEL/MAPPING CHANGE != GLOBAL ELECTRICAL REQUALIFICATION**

---

## 7. A local fix can invalidate neighboring consumers through shared resources

Narrow regression does not mean optimistic regression.

Suppose a corrected block revision increases its 3V3 steady demand or startup current. The local functional fix may pass, but that semantic resource change can affect:

- shared regulator aggregate;
- source protection setting;
- startup/inrush envelope;
- connector/copper/current-path qualification;
- thermal evidence;
- neighboring consumers if the rail droop/startup contract changes;
- complete-board release.

The block's local test passing is not enough. `SHOW WHERE USED` must traverse shared-resource dependencies and stale the affected aggregate/release evidence.

Conversely, do not rerun unrelated regressions merely because they are easy to run. Each regression needs a causal path from changed semantics or physical implementation to the claim being rechecked.

Freeze:

> **LOCAL FIX PASS != DEPENDENT SYSTEM REGRESSION CLOSED**

---

## 8. Select regressions from changed facets and dependency edges

For each correction, build a change-impact record:

```yaml
finding: FIND.GENERIC.042
old_revision: IFACE.OUTDRV@4
new_revision: IFACE.OUTDRV@5
changed_facets:
  - lifecycle.unpowered_behavior
  - power.startup_current
unchanged_facets:
  - field_voltage_envelope
  - logical_polarity
  - connector_independent_semantics
show_where_used:
  - BOARD.A.boundary.output_3
  - BOARD.B.boundary.output_1
  - RESOURCE.3V3.aggregate
stale_evidence:
  - EVD.OUTDRV.PARTIAL_POWER.001
  - EVD.BOARD_A.STARTUP.004
  - EVD.RESOURCE_3V3.STARTUP.002
preserved_current_evidence:
  - EVD.OUTDRV.FIELD_CLAMP.003
regression_plan:
  - recalculate block startup envelope
  - repeat partial-power bench evidence
  - recompute 3V3 aggregate
  - re-evaluate dependent board startup evidence
```

Do not claim `unchanged` without enough authority to know the facet is unchanged.

---

## 9. Preserve superseded evidence and close the finding causally

A finding is not closed because a commit says `fix test`.

A useful disposition record contains:

- finding ID;
- original failed/anomalous evidence;
- classification and owner;
- root cause or bounded cause statement;
- corrective design/configuration revision;
- semantic facets changed;
- `SHOW WHERE USED` impact set;
- evidence marked stale/superseded;
- selected regressions and why;
- regression results;
- residual blockers;
- final disposition: `OPEN`, `CORRECTED_PENDING_REGRESSION`, `REGRESSION_FAILED`, `CLOSED_FOR_CLAIM`, or `WONT_FIX_WITH_JUSTIFICATION`.

Old evidence remains available and is marked `SUPERSEDED` or otherwise inapplicable; it is not rewritten to describe the corrected design.

Freeze:

> **DESIGN CORRECTED != FINDING CLOSED**

---

## 10. Recompute complete-board release after every material correction

After regression work, recompute release from current dependencies/evidence rather than restoring the previous release state by hand.

Ask:

1. Is the corrected owning claim current?
2. Are all changed semantic facets represented by the new revision?
3. Did every affected downstream consumer get revalidated or remain explicitly stale?
4. Did shared-resource totals/protection/thermal assumptions change?
5. Did board connection or machine evidence become stale?
6. Did FPGA/HAL mapping need regeneration/review?
7. Are unresolved findings still visible in the residual ledger?
8. Did any correction cross the ordinary-control/independent-safety boundary?

Freeze:

> **PREVIOUSLY RELEASED != AUTOMATICALLY RELEASED AFTER CHANGE**

---

## 11. Safety-status findings stay inside the authority boundary

An ordinary controller may observe a safety-system status signal and discover, for example, wrong polarity, wrong input mapping, or an electrical interface mismatch. Correct the ordinary electrical/status interface at its proper owner.

Do not respond by moving E-stop logic, guard logic, stopping authority, discrepancy logic, or safety reset behavior into ordinary FPGA/LinuxCNC control. This curriculum does not grant PL/SIL/category or personnel-safety authority.

Freeze:

> **SAFETY-STATUS OBSERVATION != AUTHORITY TO REDESIGN THE SAFETY FUNCTION IN THE ORDINARY CONTROLLER**

---

## 12. Current OpenPressBrake catalog lesson

The current `digital_output_24v` status is a useful ownership example. It explicitly separates a reusable non-isolated shared-reference variant from the first-machine isolated board path. The reusable variant is valid only where the declared shared reference is intentional; current first-board authority forbids using that path by bridging its switched field return to logic ground. The isolated path has a different topology and still has open production and qualification gates.

If a future board-level test of the isolated implementation fails, disposition must identify whether the cause is intrinsic to the reusable output stage, intrinsic to the isolation/interface circuitry, a shared `SWITCHED_IO_5V` resource issue, board connectivity, or an installed-machine fact. Simply editing the reusable IPS1025H primitive because the failure was seen at an output connector would violate the catalog architecture.

The status also preserves the independent safety boundary: ordinary X-axis direction outputs may remain controller functions while the safety-owned drive-enable path remains controlled by the independent safety system.

---

## Lab — disposition six adversarial findings

Build a fictional controller with reusable I/O blocks, one genuine adapter, one shared power resource, board-specific connection definitions, an FPGA resource plan, LinuxCNC/HAL mapping, one machine-only physical assumption, and an ordinary safety-status input.

Inject these six findings:

1. **Reusable defect:** board partial-power testing exposes a back-power path intrinsic to a reusable block and inside its published contract.
2. **Machine-only mismatch:** an installed sensor has a physical/electrical property outside the declared machine assumption, while the reusable block remains valid inside its contract.
3. **Adapter defect:** a real level/range transformation fails its B-side contract.
4. **J-number correction:** an electrically compatible channel is assigned to the wrong physical connector; generic circuitry is unchanged.
5. **Shared-resource ripple:** a block correction increases startup demand enough that the shared-resource aggregate and neighboring startup evidence must be revisited.
6. **Safety-status observation:** ordinary control reads the independent safety system incorrectly; correct only the status-interface/mapping defect and preserve independent safety authority.

For each finding submit:

- preserved original evidence;
- classification and owning authority;
- proposed corrective revision or justified machine/configuration action;
- changed semantic facets;
- `SHOW WHERE USED` impact set;
- evidence made stale/superseded;
- evidence explicitly preserved current and why;
- scoped regression plan;
- resulting residual-release chain.

### Lab pass criteria

A passing submission must:

- never delete or rewrite failed evidence to make the corrected design appear always passing;
- classify ownership before proposing a correction;
- revise a reusable block only for a genuine generic defect;
- keep machine-specific mismatch out of the reusable block unless independent generic engineering justifies expansion;
- distinguish adapters from board-specific connection definitions;
- preserve reusable electrical qualification through a J-number-only correction when semantics truly do not change;
- propagate shared-resource changes to neighboring consumers and top-level release;
- justify both selected and omitted regressions through dependency/change facets;
- recompute release rather than manually restoring green state;
- preserve the independent personnel-safety boundary.

---

## Catalog stress-test result

BD27 exposes a missing machine-readable capability complementary to BD26's campaign derivation: **finding disposition and corrective-change impact**. A mature catalog should be able to bind a finding to failed evidence, classify its owning authority, record the corrective semantic revision, run `SHOW WHERE USED`, mark only causally affected evidence stale, preserve unrelated evidence current, attach regression results, and recompute release.

That layer must not become an excuse for broad automatic invalidation. The value comes from facet-level dependencies and explicit causal paths.

This run does not retrofit that machinery into active OpenPressBrake engineering. Current OpenPressBrake main is changing adjacent analog-input protection/envelope work, so the catalog remains read-only and this gap is recorded as `ENGINEERING_REVIEW_NEEDED`.

## Compute

No simulation, synthesis, place-and-route, timing, or executable engineering verification is justified for this lesson. The engineering question is finding ownership, dependency impact, and regression semantics. Any future executable verification remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Durable freezes

- `FAILED EVIDENCE != DISPOSABLE EVIDENCE`.
- `WHERE FAILURE WAS OBSERVED != WHERE DEFECT IS OWNED`.
- `MACHINE MISMATCH != AUTOMATIC REUSABLE-BLOCK DEFECT`.
- `CORRECTIVE HOME FOLLOWS ENGINEERING AUTHORITY, NOT FILE CONVENIENCE`.
- `BOARD LABEL/MAPPING CHANGE != GLOBAL ELECTRICAL REQUALIFICATION`.
- `LOCAL FIX PASS != DEPENDENT SYSTEM REGRESSION CLOSED`.
- `DESIGN CORRECTED != FINDING CLOSED`.
- `PREVIOUSLY RELEASED != AUTOMATICALLY RELEASED AFTER CHANGE`.
- `SAFETY-STATUS OBSERVATION != AUTHORITY TO REDESIGN THE SAFETY FUNCTION IN THE ORDINARY CONTROLLER`.

## Next lesson

BD28 should teach **engineering change control from qualified catalog through released board variants**: change proposal -> affected semantic IDs -> compatibility classification -> reusable/adapter/board revision policy -> evidence invalidation -> board-variant applicability -> migration/retrofit decision -> release-note/configuration-baseline update. The adversarial lab should include a backward-compatible reusable improvement, a breaking interface revision requiring adapter or board respin, a BOM substitution that is electrically equivalent only after evidence, a machine-only retrofit, and a change that must not be pushed into already released boards without a justified field-action decision.