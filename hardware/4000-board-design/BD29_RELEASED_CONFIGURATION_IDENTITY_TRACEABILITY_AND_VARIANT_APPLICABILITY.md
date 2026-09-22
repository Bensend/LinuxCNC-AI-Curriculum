# BD29 — Released-Configuration Identity, Traceability, and Variant Applicability

## Purpose

BD28 taught how to control engineering changes without forcing every catalog improvement into every released board. BD29 supplies the missing configuration identity needed to make that discipline operational after hardware leaves the design workspace.

The governing flow is:

`release proposition -> immutable released baseline ID -> exact block/adapter/board/PCB/BOM/FPGA/HAL identities -> machine applicability -> evidence bindings -> designed identity -> installed identity -> supported/superseded/withdrawn state -> SHOW WHERE USED / SHOW WHAT IS INSTALLED -> change applicability -> migration or field-action traceability`

This lesson develops both linked skills:

1. **block engineering** — preserve stable reusable semantic identities and qualification evidence so a released product can state exactly which block contract it consumed; and
2. **board integration** — bind those reusable identities to an immutable board/configuration baseline, distinguish design intent from the physically installed population, and determine which released or installed units are actually affected by later changes.

OpenPressBrake is used only for current governance constraints. The release examples below are fictional/generic. Nothing in this lesson claims that the current OpenPressBrake controller is production-proven or released.

## Hard student-material audit

The following files were opened and inspected in current `main` during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD25_DEPENDENCY_AWARE_QUALIFICATION_EVIDENCE_AND_RELEASE_STATE_COMPOSITION.md` — evidence-to-exact-claim/revision binding, evidence lifecycle, composed release state, and reusable/board/machine evidence separation.
- Curriculum `hardware/4000-board-design/BD28_ENGINEERING_CHANGE_CONTROL_CATALOG_TO_RELEASED_VARIANTS.md` — old/new configuration baselines, compatibility classification, variant applicability, preservation of superseded baselines, and separation of design release from field action.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` — board-design lane state and exact BD29 assignment before this lesson.
- Curriculum `WORK_SELECTION_POLICY.md` — autonomous lane selection and branch-local blocker policy.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — integration readiness versus full Rev-1 qualification, concrete-evidence truthfulness, and same-change status maintenance.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — immutable reusable contracts during composition, adapter ownership, board-integration ownership, `VERIFY_AT_MACHINE`, and independent personnel-safety boundary.

No inspected file is used here as evidence of a released OpenPressBrake production configuration.

---

## 1. A released configuration is an immutable engineering identity

A release record must identify one exact approved configuration. Do not use `main`, `latest`, a family name, or a mutable spreadsheet row as release identity.

A useful record begins like this:

```yaml
release_id: REL.GENERIC.CONTROLLER_A.R1.0007
state: CURRENT_FOR_NEW_BUILD
released_at: 2026-09-22
board_variant: BOARD.CONTROLLER_A@7
pcb:
  design_revision: PCB.CONTROLLER_A@4
  fabrication_revision: FAB.CONTROLLER_A@4
assembly:
  bom_revision: BOM.CONTROLLER_A@9
fpga:
  image_id: FPGA.CONTROLLER_A.IOSET3@12
  build_hash: recorded_exactly
linuxcnc:
  hal_config_id: HAL.CONTROLLER_A.IOSET3@6
  machine_config_id: LINUXCNC.CONTROLLER_A@5
```

Once issued, `REL.GENERIC.CONTROLLER_A.R1.0007` continues to mean that configuration. A later release receives another ID.

Freeze:

> **RELEASE ID != MOVING POINTER**

---

## 2. Bind exact reusable semantics, not merely family names

The release must state which reusable contracts were consumed.

```yaml
consumes:
  blocks:
    - id: BLOCK.DIN24
      semantic_revision: 3
      quantity: 12
    - id: BLOCK.DOUT24
      semantic_revision: 5
      quantity: 8
  adapters:
    - id: ADAPTER.ISO_STATUS_3V3
      semantic_revision: 2
      quantity: 1
  shared_resources:
    - id: BLOCK.POWER_5V
      semantic_revision: 4
```

`BLOCK.DOUT24` by itself is insufficient. If revision 6 later changes a consumed facet, applicability depends on whether the release used revision 5, revision 6, or a compatible sub-envelope.

Freeze:

> **FAMILY NAME != RELEASED SEMANTIC IDENTITY**

---

## 3. Connection definitions remain board-specific

The release record may bind board-specific connection definitions such as:

- connector family and populated option;
- pin assignment;
- FPGA package-pin assignment;
- block instance to connector mapping;
- physical connector location;
- silkscreen/label revision;
- harness destination definition.

Those identities belong to the board baseline. They do not become reusable-block semantics merely because release traceability records them.

If a connection contains real level translation, isolation, conditioning, protocol conversion, or reusable protection, that electrical function belongs in a qualified adapter/block under current OpenPressBrake governance.

Freeze:

> **TRACEABILITY OF BOARD MAPPING != PROMOTION INTO REUSABLE BLOCK**

---

## 4. BOM identity is part of release identity

A released BOM should identify the approved manufacturer part, approved alternates when genuinely qualified, population option, and material revision needed to reproduce the released assembly.

A purchasing substitution that was never captured cannot inherit the released baseline by assumption.

For an unrecorded substitute:

```yaml
installed_part_identity: UNKNOWN_OR_UNAPPROVED
released_baseline_match: UNRESOLVED
release_inheritance: BLOCKED
required_action:
  - identify_actual_part
  - evaluate_consumed_facets
  - bind_equivalence_evidence_or_create_new_variant
```

The unit may work. That does not establish that it is the released configuration.

Freeze:

> **FUNCTIONS ON BENCH != CONFIGURATION IDENTITY PROVED**

---

## 5. FPGA and HAL/software configuration are first-class release components

Identical PCBs can behave differently with different FPGA images, pin/resource maps, watchdog logic, polarity, timing, HostMot2/LiteX-CNC configuration, or HAL wiring.

A hardware release record therefore cannot stop at PCB and BOM.

At minimum bind, where applicable:

- exact FPGA image/build identity;
- source/configuration revision used to build it;
- synthesis/toolchain identity when release evidence depends on it;
- pin/resource mapping revision;
- LinuxCNC configuration identity;
- HAL mapping revision;
- parameters whose values alter released behavior;
- checksums/hashes or other immutable artifact identifiers appropriate to the build system.

Freeze:

> **SAME PCB != SAME CONTROLLER CONFIGURATION**

---

## 6. Designed, built, and installed identities are different propositions

Keep three questions separate:

1. **Designed baseline** — what engineering approved.
2. **Built identity** — what manufacturing records say was assembled/programmed.
3. **Installed identity** — what is actually present in the machine now.

A useful installed record is a delta from a known release only when the base identity is actually established:

```yaml
asset_id: MACHINE.CELL17.CONTROLLER1
original_release: REL.GENERIC.CONTROLLER_A.R1.0007
installed_state:
  board_serial: A00173
  pcb_revision_observed: PCB.CONTROLLER_A@4
  fpga_image_observed: FPGA.CONTROLLER_A.IOSET3@13
  hal_config_observed: HAL.CONTROLLER_A.IOSET3@7
  retrofit_records:
    - RETROFIT.CELL17.2027_004
identity_state: MODIFIED_FROM_RELEASE
```

Do not overwrite the original release record to describe a field retrofit.

Freeze:

> **DESIGNED == BUILT == INSTALLED MUST BE PROVED, NOT ASSUMED**

---

## 7. Retrofit creates installed history, not rewritten history

When a machine is modified:

1. preserve its pre-retrofit installed identity;
2. record the approved change/retrofit instruction;
3. record the exact resulting installed hardware/FPGA/HAL/machine configuration;
4. bind new or reused evidence to the resulting state;
5. update the asset's current installed-baseline pointer;
6. preserve the full chain for applicability queries.

A retrofit may make an installed unit equivalent to an existing released variant, or it may create a separately controlled installed configuration. Equivalence requires evidence; matching a few visible parts is insufficient.

Freeze:

> **RETROFIT COMPLETE != ORIGINAL RELEASE RECORD REWRITTEN**

---

## 8. Release lifecycle state must preserve legacy support truthfully

Useful release states include:

- `CURRENT_FOR_NEW_BUILD` — approved baseline for new production;
- `SUPPORTED_LEGACY` — no longer preferred for new builds but still inside accepted released claims;
- `SUPERSEDED_NOT_FOR_NEW_BUILD` — historical baseline retained, replacement preferred, no automatic field action implied;
- `RETROFIT_REQUIRED` — named installed populations require an approved migration;
- `WITHDRAWN_BLOCKED` — release claim is no longer accepted for continued use/new build under the named disposition;
- `UNKNOWN_INSTALLED_IDENTITY` — actual installed configuration cannot be established sufficiently for applicability/release inheritance.

`SUPERSEDED` is not a synonym for unsafe. `WITHDRAWN_BLOCKED` requires an actual engineering disposition, not merely the existence of a newer design.

Freeze:

> **LEGACY != INVALID**

---

## 9. `SHOW WHERE USED` and `SHOW WHAT IS INSTALLED` answer different questions

`SHOW WHERE USED` traverses engineering dependencies:

`changed semantic facet -> consuming blocks/adapters/boards/releases`

`SHOW WHAT IS INSTALLED` traverses configuration/asset records:

`release or semantic identity -> built serials/assets/machines currently recorded with that identity`

A field-action query normally needs both:

```text
changed facet
 -> affected released baselines
 -> affected serial/build populations
 -> currently installed assets
 -> compatibility/migration disposition
```

Do not notify or retrofit every unit carrying the same product family name when only a subset consumed the affected semantic revision.

Freeze:

> **ENGINEERING APPLICABILITY != INSTALLED POPULATION UNTIL THE GRAPHS ARE JOINED**

---

## 10. Unknown installed identity fails closed

Legacy equipment often lacks perfect records. That is not permission to guess.

Use states such as:

- `IDENTITY_CONFIRMED`;
- `IDENTITY_PARTIAL`;
- `UNKNOWN_INSTALLED_IDENTITY`;
- `VERIFY_AT_MACHINE`.

A change may therefore produce an applicability result like:

```yaml
asset: MACHINE.LEGACY_04
possible_affected_releases:
  - REL.GENERIC.CONTROLLER_A.R1.0005
  - REL.GENERIC.CONTROLLER_A.R1.0007
applicability: VERIFY_AT_MACHINE
release_inheritance: BLOCKED_PENDING_IDENTITY
```

The verification task should name the minimum facts needed: PCB marking, populated component identity, FPGA image hash, connector option, harness revision, HAL/configuration checksum, or another causally relevant identifier.

Freeze:

> **UNKNOWN INSTALLED IDENTITY != BEST-GUESS BASELINE**

---

## 11. Evidence bindings belong to the released proposition

A release record should bind the evidence set used to approve that exact baseline, rather than merely link a general `test reports` folder.

```yaml
evidence_bindings:
  - claim: QUAL.BOARD.CONNECTIVITY@8
    evidence: EVD.BOARD.CONNECTIVITY.ERC_014
    state_at_release: CURRENT
  - claim: QUAL.BOARD.FPGA_IMAGE_TIMING@11
    evidence: EVD.FPGA.PNR_044
    state_at_release: CURRENT
  - claim: QUAL.BOARD.BRINGUP@3
    evidence: EVD.BOARD.BRINGUP_021
    state_at_release: CURRENT
```

Historical evidence state at release and present evidence applicability are distinct. Later discovery may stale or invalidate a claim without erasing what was known when the release was issued.

Freeze:

> **RELEASE HISTORY MUST REMAIN AUDITABLE AFTER EVIDENCE STATE CHANGES**

---

## 12. Safety-status identity is tracked without granting safety authority

If an ordinary controller electrically monitors status from an independent safety system, the release record should identify the ordinary receiver block/adapter, mapping, FPGA/HAL configuration, and installed interface revision exactly like other ordinary I/O.

That traceability proves only which ordinary interface was designed/installed. It does not establish PL/SIL/category, stopping performance, diagnostic coverage, safety validation, or personnel-safety authority.

If a change actually alters an independent safety function, disposition belongs to the separate safety design/validation process.

Freeze:

> **SAFETY-STATUS CONFIGURATION TRACEABILITY != SAFETY VALIDATION**

---

## 13. Cross-machine reuse still uses exact configuration identity

The same reusable block catalog can support mills, lathes, plasma tables, routers, robots, press brakes, and custom automation. Configuration records should make this easier, not contaminate blocks with machine names.

For example, a generic encoder receiver revision may appear in:

- a mill spindle encoder release;
- a lathe spindle/orientation release;
- a robot axis feedback interface;
- a press-brake backgauge controller.

The reusable block identity remains generic. Each board/machine release records its own instance count, mapping, FPGA resources, connectors, harness destinations, and applicability.

Freeze:

> **CROSS-MACHINE REUSE REQUIRES SHARED BLOCK IDENTITY AND SEPARATE BOARD/MACHINE BASELINES**

---

## Lab — eight adversarial configuration records

Use a fictional catalog with one digital-input primitive, one output primitive, one adapter, one shared power block, two board variants, two FPGA images, two HAL configurations, and at least five installed assets.

Disposition all eight cases:

1. **Two released variants, different block revisions.** Variant A consumes `BLOCK.OUT@4`; Variant B consumes `BLOCK.OUT@5`. A change affects only a facet introduced in revision 5. Produce the correct release and installed-population impact set.
2. **New catalog revision for new builds only.** Revision 6 improves margin while revision 5 remains supported. Keep the legacy baseline supported without automatic retrofit.
3. **Unrecorded BOM substitution.** A returned board contains a same-value/package part not present in the released BOM. Block release inheritance until identity/equivalence is established.
4. **FPGA/HAL mismatch.** PCB/BOM match the release, but the FPGA image and HAL mapping belong to another variant. Classify the unit as not matching the claimed release even if basic I/O appears to work.
5. **Machine retrofit.** An installed machine moves from one released configuration to another approved configuration. Preserve original and resulting identities plus the retrofit record.
6. **Supported legacy baseline.** A superseded revision remains within accepted claims. Show why `SUPERSEDED_NOT_FOR_NEW_BUILD` or `SUPPORTED_LEGACY` does not imply mandatory field action.
7. **Withdrawn baseline.** A later finding invalidates a named semantic claim for a subset of serials. Join `SHOW WHERE USED` with `SHOW WHAT IS INSTALLED` to identify the affected population without sweeping unaffected variants into the action.
8. **Safety-status interface revision.** Track exact ordinary receiver/FPGA/HAL identity while explicitly refusing to infer personnel-safety validation.

For each submit:

- immutable release ID;
- designed block/adapter/shared-resource semantic revisions;
- board/connection/PCB/BOM identities;
- FPGA image and LinuxCNC/HAL identities;
- evidence bindings;
- release lifecycle state;
- built identity when available;
- installed identity and confidence/state;
- `SHOW WHERE USED` result;
- `SHOW WHAT IS INSTALLED` result;
- change applicability;
- migration/field-action disposition;
- unresolved facts and exact `VERIFY_AT_MACHINE` task where needed.

### Lab pass criteria

A passing submission must:

- never use `latest`/`main` as an immutable release identity;
- bind exact reusable semantic revisions rather than family names;
- keep board-specific connection identity outside reusable electrical authority;
- include FPGA and HAL/configuration identity when behavior depends on them;
- distinguish designed, built, and installed states;
- preserve immutable historical release and retrofit records;
- block release inheritance for unrecorded/unknown BOM or configuration identity;
- distinguish superseded legacy support from withdrawn/blocked state;
- join engineering dependency and installed-asset graphs for field applicability;
- keep unknown legacy facts as `VERIFY_AT_MACHINE`;
- preserve the independent personnel-safety boundary.

---

## Catalog stress-test result

BD29 confirms the next catalog/integration pressure: stable semantic IDs and release-state composition are not sufficient without a **variant-aware released-configuration and installed-asset registry**.

A mature system should be able to answer, without relying on tribal knowledge:

- What exact engineering configuration did release `R` mean?
- Which reusable semantic revisions did it consume?
- Which evidence supported that release?
- Which serial/build records claim that release?
- What is actually installed now?
- Which assets have been retrofitted away from their original baseline?
- Which released/installed populations consume a changed semantic facet?
- Which identities are unknown and therefore require machine verification?

Current OpenPressBrake governance supplies the block/readiness and block/adapter/integration boundaries needed to build such a system, but the inspected governance does not itself establish a repository-wide released-configuration/installed-asset registry. Record that infrastructure gap as `ENGINEERING_REVIEW_NEEDED`; do not fabricate release or serial data for the current controller.

No active OpenPressBrake engineering file is modified by this lesson.

## Compute

No simulation, synthesis, place-and-route, timing, regression execution, or other executable engineering verification is justified for BD29. This is configuration identity and traceability methodology. Future executable verification remains restricted to `[self-hosted, openpressbrake]`; no hosted Actions fallback is allowed.

## Durable freezes

- `RELEASE ID != MOVING POINTER`.
- `FAMILY NAME != RELEASED SEMANTIC IDENTITY`.
- `TRACEABILITY OF BOARD MAPPING != PROMOTION INTO REUSABLE BLOCK`.
- `FUNCTIONS ON BENCH != CONFIGURATION IDENTITY PROVED`.
- `SAME PCB != SAME CONTROLLER CONFIGURATION`.
- `DESIGNED == BUILT == INSTALLED MUST BE PROVED, NOT ASSUMED`.
- `RETROFIT COMPLETE != ORIGINAL RELEASE RECORD REWRITTEN`.
- `LEGACY != INVALID`.
- `ENGINEERING APPLICABILITY != INSTALLED POPULATION UNTIL THE GRAPHS ARE JOINED`.
- `UNKNOWN INSTALLED IDENTITY != BEST-GUESS BASELINE`.
- `RELEASE HISTORY MUST REMAIN AUDITABLE AFTER EVIDENCE STATE CHANGES`.
- `SAFETY-STATUS CONFIGURATION TRACEABILITY != SAFETY VALIDATION`.
- `CROSS-MACHINE REUSE REQUIRES SHARED BLOCK IDENTITY AND SEPARATE BOARD/MACHINE BASELINES`.

## Next lesson

BD30 should turn released-configuration identity into **manufacturing/programming/commissioning handoff and as-built reconciliation**:

`released baseline -> manufacturing package -> component/option traceability -> programmed FPGA/software identity -> assembly inspection -> first-power/bring-up record -> as-built deviations -> disposition -> installed baseline -> release inheritance`

The adversarial lab should include wrong-population options, an approved alternate not reflected in an old pick list, a correct PCB with wrong FPGA image, a reworked board whose as-built delta was not recorded, and a field replacement board whose machine-specific HAL/harness identity must be reconciled before commissioning.