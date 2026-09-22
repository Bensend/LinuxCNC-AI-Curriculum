# BD41 — Release Dependency Invalidation, Semantic Change Impact, and Controlled Re-Promotion

## Purpose

BD40 separated artifact integrity, provenance, and release authority. BD41 addresses what happens after a released or service-authorized configuration consumes engineering evidence and that upstream evidence changes:

`released artifact -> upstream semantic change -> SHOW WHERE USED -> affected claim/evidence classification -> stale/quarantine decision -> bounded regression -> new candidate -> re-promotion or documented non-impact -> downstream fleet/service applicability`

The lesson develops both linked skills. **Block engineering** must make changed contract facets explicit enough that downstream users can identify what became stale. **Board integration** must know exactly which facets each release consumed, preserve unaffected evidence, rerun only justified regression, and fail closed when dependency identity is unknown.

OpenPressBrake is used as a current worked-example and catalog stress test. It is not represented as production-proven hardware or as having a released fleet.

## Hard student-material audit

The following current-main files were opened and inspected during this run:

- Curriculum `hardware/4000-board-design/BD40_CONFIGURATION_PROVENANCE_ATTESTATIONS_TRUST_AND_ARTIFACT_PROMOTION.md` — `VERIFIED_FOR_LESSON` for candidate/promotion/staleness concepts.
- Curriculum `WORK_SELECTION_POLICY.md` — `VERIFIED_FOR_LESSON` for independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — `VERIFIED_FOR_LESSON` for evidence-backed status, maintenance, and truthfulness rules.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — `VERIFIED_FOR_LESSON` for block/adapter/integration ownership.
- OpenPressBrake `hardware/blocks/safety_interface/manifest.yaml` — `ENGINEERING_REVIEW_NEEDED` as a current example of a recently changed semantic composition contract.
- OpenPressBrake `hardware/blocks/safety_interface/STATUS_CHECKLIST.md` — `ENGINEERING_REVIEW_NEEDED` because it is stale relative to the current manifest.

The safety-interface files are **not** assigned as finished student material. They are presented only as an explicitly identified live defect showing why semantic dependency invalidation and same-change status maintenance matter.

## 1. Invalidate claims, not filenames

A repository path is not an engineering dependency. A release may consume one semantic facet of a block while being independent of another.

Examples of semantic facets include:

- input voltage/current envelope;
- output current, duty, or transient envelope;
- default/watchdog state;
- return-domain or isolation rule;
- FPGA GPIO count, bank voltage, clock or timing requirement;
- connector pin meaning;
- board-specific mapping;
- component identity when electrical limits depend on it;
- qualification evidence for a specific claimed envelope.

When an upstream file changes, ask **which engineering claim changed?** Then use `SHOW WHERE USED` on that claim/facet.

> **FILE CHANGED != EVERY DOWNSTREAM CLAIM STALE**

> **FILE UNCHANGED != SEMANTIC CONTRACT UNCHANGED**

A generated or copied artifact can remain byte-for-byte unchanged while the evidence that authorized its use has become stale.

## 2. Stable semantic IDs make impact analysis tractable

A durable dependency record should bind a consumer to the exact upstream semantic facet and revision/evidence identity it consumed, not merely to a filename.

Conceptually:

`consumer release -> semantic facet ID -> accepted value/envelope -> evidence revision -> applicability`

For example, a board release may consume a digital-output block's `watchdog_state=inactive` and `logic_supply=3V3` while a connector assembly consumes only the board's output-net assignment. If a thermal limit changes but the board never operated near that limit, the thermal facet still requires disposition, but unrelated connector evidence should not automatically be discarded.

## 3. Classify the change before choosing regression

For every upstream change classify at least:

- **EDITORIAL_ONLY** — wording/format changed; engineering meaning demonstrably unchanged.
- **EVIDENCE_CORRECTION** — supporting evidence was corrected without intentionally changing the contract; downstream claims that relied on the corrected fact require impact review.
- **CONTRACT_NARROWING** — allowed envelope or capability decreased.
- **CONTRACT_EXPANSION** — a broader envelope is newly claimed; old releases do not automatically consume it.
- **BEHAVIOR_CHANGE** — startup/default/fault/timing/logic semantics changed.
- **RESOURCE_CHANGE** — FPGA pins/banks/LUT/BRAM/PLL/bus/power/shared-resource demand changed.
- **PHYSICAL_MAPPING_CHANGE** — board connector, pinout, harness, placement, or board-specific connection changed.
- **COMPONENT_SUBSTITUTION** — topology may be unchanged while limits, leakage, timing, package, thermal behavior, protection, sourcing, or qualification evidence changes.
- **TOOLCHAIN/BUILD_CHANGE** — source semantics may be intended unchanged while generated binary, timing, resource use, or reproducibility changes.
- **UNKNOWN_IMPACT** — dependency identity or evidence is insufficient; fail closed.

A change may occupy several classes.

## 4. `SHOW WHERE USED` must operate in both directions

Forward dependency answers: *what does this release consume?*

Reverse dependency answers: *which blocks, adapters, board variants, FPGA images, HAL configurations, qualification claims, service packages, and installed/as-maintained populations consume this changed facet?*

The minimum impact graph is:

`semantic facet -> direct consumers -> released/configuration artifacts -> service/new-build applicability -> installed/as-maintained population`

Do not stop at the schematic. A changed electrical assumption may invalidate a board calculation, which may invalidate a promoted FPGA/board package, which may affect a service-authorized population even when the FPGA bits themselves did not change.

## 5. Preserve unaffected evidence

Change control should be conservative without becoming destructive. If evidence remains valid under the new semantic state, retain it and record why.

Useful dispositions are:

- `UNAFFECTED_WITH_RATIONALE`
- `STALE_REVIEW_REQUIRED`
- `REGRESSION_REQUIRED`
- `REQUALIFICATION_REQUIRED`
- `REBUILD_REQUIRED`
- `REPROMOTION_REQUIRED`
- `QUARANTINE_UNKNOWN_DEPENDENCY`

Do not rerun expensive work merely because it lives nearby in the tree. Conversely, do not preserve evidence merely because its file did not change.

> **PROXIMITY != DEPENDENCY**

> **BOUNDED REGRESSION != MINIMAL-CONVENIENT REGRESSION**

The regression scope comes from the dependency graph and changed claim, not from convenience.

## 6. Requalification and re-promotion are different operations

If a reusable block's generic contract changes, the block may require requalification for the affected generic claims. A board release that consumes those claims separately requires impact disposition and, where its release authority becomes stale, controlled re-promotion.

Requalifying the block does not automatically re-promote every board that used an older revision. Re-promoting a board does not automatically advance the reusable block's formal status.

> **BLOCK REQUALIFIED != BOARD RELEASE REPROMOTED**

> **BOARD REPROMOTED != BLOCK STATUS ADVANCED**

This separation prevents machine-specific release metadata from leaking into reusable circuitry.

## 7. Stale, quarantine, and non-impact decisions

A released artifact need not always be revoked immediately when an upstream change occurs. The correct state depends on the claim and uncertainty.

- Mark **stale** when a known consumed dependency changed and impact review/regression is pending.
- **Quarantine** when dependency identity, artifact provenance, or applicability is uncertain enough that continued programming/service use cannot be defended.
- Record **non-impact** only with an explicit engineering rationale tied to the changed semantic facet and consumer envelope.
- **Revoke** authority when evidence shows the artifact is no longer acceptable for a defined use/population.
- **Supersede** when a newer authorized artifact replaces it without implying the older historical evidence was false.

> **NO OBSERVED FAILURE != NON-IMPACT PROOF**

## 8. Component substitution: same topology can still invalidate evidence

Suppose a MOSFET is replaced by a same-package part and the schematic topology is unchanged. Impact analysis must still examine the facets actually consumed: gate threshold/drive margin, Rds(on), leakage, avalanche/transient capability, thermal resistance, capacitance/switching, package pinout, absolute maximums, and qualification evidence.

A board operating far below a changed current limit may preserve some evidence with rationale, while thermal or fault evidence tied to the old part may require regression.

> **TOPOLOGY UNCHANGED != ENGINEERING ENVELOPE UNCHANGED**

## 9. FPGA resource-map changes can hide behind stable HAL names

A stable LinuxCNC/HAL pin name does not prove the same physical FPGA pin, I/O bank, electrical standard, timing path, or board connector is still used.

If an FPGA resource map changes, trace:

`HAL semantic -> FPGA function -> physical FPGA resource -> board net -> connection block -> field connector/harness`

Then rerun the checks justified by the changed resources: bank-voltage compatibility, pin collisions, clock-capable requirements, timing, synthesis/place-and-route, board mapping, or physical verification.

If executable synthesis/place-and-route or timing verification is genuinely required, run it only on `[self-hosted, openpressbrake]`. Never substitute GitHub-hosted compute.

> **HAL NAME UNCHANGED != HARDWARE PATH UNCHANGED**

## 10. Board connector remaps are integration changes, not block changes

If a board revision moves an already-compatible block signal from one connector pin to another while preserving the reusable block's electrical contract, the change belongs to board-specific connection/integration authority.

Trace the affected connection definition, silkscreen, harness, documentation, FPGA/logical mapping where applicable, test fixture, manufacturing/service instructions, and installed applicability. Do **not** mutate the reusable block merely to absorb a J-number or pin number.

If the remap introduces real electrical translation/protection, classify that circuitry under the block/adapter/integration decision test rather than hiding it in a pin table.

## 11. Toolchain rebuilds require equivalence evidence

Rebuilding unchanged FPGA source with a different synthesis/place-and-route tool version can produce a different binary and different timing/resource placement. Source equivalence alone does not prove artifact equivalence.

The release process must define what equivalence means for the intended use and what evidence is required: functional regression, timing closure, resource fit, generated-image identity, deterministic-build evidence where available, or bounded hardware verification.

> **SOURCE UNCHANGED != GENERATED ARTIFACT EQUIVALENT**

A different binary is not automatically defective, but it is a new candidate until the applicable authority model says otherwise.

## 12. Current OpenPressBrake stress test — a live semantic drift defect

The inspected current `safety_interface/manifest.yaml` was recently changed to a concrete Rev1 composition: seven protected Pilz status inputs, six protected operational command outputs, thirteen 3V3 FPGA GPIO total, command power in the L7/L07 switched domain, and explicit preservation of wires 75 and 63 as independent hardwired boundaries. It remains `behavioral_only` and does not claim personnel-safety authority.

However, the inspected current `safety_interface/STATUS_CHECKLIST.md` still describes the output dependency as conditional, says exact channel count/output class/polarity/timing/returns depend on an unknown external contract, and says not to freeze the final output primitive until that contract is known. Those statements no longer match the current manifest's frozen Rev1 composition.

This is `ENGINEERING_REVIEW_NEEDED`, not student-ready finished hardware. It is also exactly the kind of defect BD41 is intended to expose: an upstream semantic change occurred, but an adjacent authoritative status artifact did not receive the corresponding invalidation/update even though `STATUS_RULES.md` requires material changes to update the checklist in the same change.

Do **not** resolve the contradiction by choosing whichever file is more convenient. Engineering must reconcile the intended current authority and then propagate the corrected semantic state through dependents. Because this block is under active OpenPressBrake development, this curriculum run records the defect rather than overwriting that work.

The reusable/integration boundary remains intact: the composition may consume protected digital input/output primitives and FPGA resources, while physical connectors and pin assignments remain board integration. Personnel-safety decision and hazardous-energy isolation remain outside ordinary LinuxCNC/FPGA authority.

## 13. Safety boundary

Semantic invalidation for an ordinary controller does not create personnel-safety authority. A changed ordinary status-monitor or handshake path may require controller regression, but that regression is not proof of PL/SIL/category, stopping performance, final-element behavior, or validation of the independent safety function.

The current OpenPressBrake safety-interface manifest explicitly prohibits ordinary controller authority over the independent hardwired safety boundaries. Preserve that distinction during every change-impact analysis.

> **CONTROLLER REGRESSION PASS != INDEPENDENT SAFETY FUNCTION VALIDATED**

## Lab — eight adversarial change cases

Use a fictional controller family shared across a mill, lathe, plasma table, router, robot cell, and press brake. Do not assume a change affects every product equally.

### Case 1 — component substitution, topology unchanged
A field-output transistor is replaced by a same-package alternate with lower avalanche capability and different Rds(on). Identify semantic facets, direct consumers, stale evidence, preserved evidence, and required regression.

### Case 2 — FPGA pin/resource remap, HAL names unchanged
The HAL interface is byte-for-byte identical, but several FPGA pins move to another bank. Determine what must be rechecked and why stable logical names are insufficient.

### Case 3 — board connector remap
A board revision moves `ENCODER_Z` to a different connector pin with no electrical transformation. Keep the change in board-specific connection authority and enumerate downstream harness/test/service impacts.

### Case 4 — toolchain rebuild
Unchanged RTL is rebuilt with a newer FPGA toolchain and produces a different bitstream. Define candidate identity, equivalence evidence, and re-promotion requirements.

### Case 5 — evidence correction narrows one facet
A calculation correction reduces the qualified continuous-current envelope but leaves startup/default behavior unchanged. Invalidate consumers of the current facet without discarding unrelated default-state evidence.

### Case 6 — contract expansion
A block is newly qualified for a wider temperature range. Explain why historical board releases do not automatically acquire that wider claim.

### Case 7 — dependency identity missing
An old service artifact records only `uses digital output block` with no revision/facet identity. Decide whether non-impact can be proved. Fail closed where the evidence cannot support a bounded conclusion.

### Case 8 — ordinary safety-status interface change
A non-safety FPGA monitor path changes filtering while the independent safety system is unchanged. Define ordinary-controller regression and explicitly state what personnel-safety validation has **not** been established.

For every case submit:

- changed semantic facet(s) and change class;
- old/new identity and evidence provenance;
- direct and reverse `SHOW WHERE USED` results;
- affected block/adapter/board/configuration artifacts;
- preserved evidence with rationale;
- stale/quarantined evidence;
- bounded regression or requalification plan;
- whether rebuild is required;
- whether re-promotion is required;
- new-build/service/as-maintained applicability;
- installed-population impact where known;
- `VERIFY_AT_MACHINE` facts;
- safety-authority statement.

### Lab pass criteria

A passing submission invalidates by semantic dependency rather than filename proximity, preserves defensibly unaffected evidence, distinguishes block requalification from board/configuration re-promotion, traces logical-to-physical FPGA and connector paths, treats unknown dependency identity as a fail-closed condition, and does not claim ordinary-controller regression as personnel-safety validation.

## Catalog stress-test result

BD41 exposes a missing release/configuration capability above the reusable catalog: a machine-readable **semantic invalidation and re-promotion ledger** should join:

- stable semantic facet ID and old/new revision/value/envelope;
- change class and provenance;
- direct and reverse dependency edges;
- exact consumers and applicable variants;
- affected/preserved evidence IDs and rationale;
- stale/quarantine/revocation state;
- regression/requalification requirements and results;
- candidate rebuild identity and artifact digest;
- re-promotion/non-impact authority;
- new-build/service/as-maintained applicability;
- affected installed populations;
- `VERIFY_AT_MACHINE` dependencies;
- retained negative evidence and rollback history.

This infrastructure belongs above generic block circuitry. Reusable manifests should publish stable generic facets and evidence; board/release infrastructure should record exactly which facets were consumed.

The current `safety_interface` manifest/checklist drift is a concrete catalog-maintenance defect. It should be reconciled by the active OpenPressBrake engineering lane, because current main shows that block was just changed. The curriculum must not paper over the mismatch or present either file as finished student material.

## Durable freezes

- `FILE CHANGED != EVERY DOWNSTREAM CLAIM STALE`
- `FILE UNCHANGED != SEMANTIC CONTRACT UNCHANGED`
- `PROXIMITY != DEPENDENCY`
- `NO OBSERVED FAILURE != NON-IMPACT PROOF`
- `TOPOLOGY UNCHANGED != ENGINEERING ENVELOPE UNCHANGED`
- `HAL NAME UNCHANGED != HARDWARE PATH UNCHANGED`
- `SOURCE UNCHANGED != GENERATED ARTIFACT EQUIVALENT`
- `BLOCK REQUALIFIED != BOARD RELEASE REPROMOTED`
- `BOARD REPROMOTED != BLOCK STATUS ADVANCED`
- `CONTROLLER REGRESSION PASS != INDEPENDENT SAFETY FUNCTION VALIDATED`

## Next exact work

Build BD42 on **change-wave planning, regression ordering, and release-train containment**:

`multiple upstream changes -> dependency graph -> common affected consumers -> merge/separate change waves -> regression ordering -> candidate lineage -> partial promotion -> incompatible population handling -> rollback points -> release-train closure`

Stress simultaneous power-contract and FPGA-map changes, two independent block revisions touching one board, a board-only connector change that should not force generic block requalification, a late regression failure after some evidence was already refreshed, and service populations that cannot migrate in one wave. Require students to minimize redundant testing without combining changes so aggressively that causality and rollback evidence are lost.
