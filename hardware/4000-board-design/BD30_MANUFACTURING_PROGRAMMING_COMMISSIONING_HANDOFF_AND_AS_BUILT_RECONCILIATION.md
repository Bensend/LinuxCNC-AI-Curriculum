# BD30 — Manufacturing, Programming, Commissioning Handoff and As-Built Reconciliation

## Purpose

BD29 established that designed, built, and installed identities are different propositions. BD30 teaches how a released design crosses manufacturing, programming, inspection, first power, and commissioning without losing that distinction.

The governing flow is:

`released baseline -> manufacturing package -> actual population/options -> programmed identity -> assembly inspection -> first-power record -> as-built deviations -> engineering disposition -> commissioned identity -> installed baseline -> release inheritance`

This lesson develops both linked skills:

1. **block engineering** — publish manufacturing-relevant block facts without embedding board quantity, connector identity, or machine assumptions in reusable circuitry; and
2. **board integration** — transform a released board baseline into traceable manufacturing/programming instructions and reconcile what was actually built before commissioning/release inheritance.

OpenPressBrake is a worked governance example, not a production-released example. Nothing here claims the current controller is production-proven.

## Hard student-material audit

The following current-main files were opened and inspected during this run and are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- Curriculum `hardware/4000-board-design/BD29_RELEASED_CONFIGURATION_IDENTITY_TRACEABILITY_AND_VARIANT_APPLICABILITY.md` — immutable release identity and designed/built/installed distinction.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed before BD30 — exact lane assignment.
- Curriculum `WORK_SELECTION_POLICY.md` — independent-lane work selection.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — readiness truthfulness and separation of integration readiness from Rev-1 qualification.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable block versus adapter versus board-integration ownership.
- OpenPressBrake `hardware/blocks/dry_contact_relay_output/REV1_BOARD_POWER_HANDOFF.md` — scalable per-instance board-power handoff while preserving primitive scope.
- OpenPressBrake `hardware/blocks/dry_contact_relay_output/STATUS_CHECKLIST.md` — current unresolved CAD, PCB, machine, and qualification gates.

The dry-contact relay files are not assigned as examples of a finished block. They are used only to show a bounded engineering handoff and truthful open gates; their current classification for finished student material is `ENGINEERING_REVIEW_NEEDED`.

---

## 1. A release is design authority, not proof of the physical build

Manufacturing starts from an immutable released baseline. It does not create permission to silently reinterpret it.

Keep separate records for:

- released design authority;
- manufacturing work instructions;
- actual component population and options;
- actual programming/configuration;
- inspection and test evidence;
- approved deviations/rework;
- installed machine identity.

Freeze:

> **RELEASED DESIGN != AS-BUILT IDENTITY**

## 2. Manufacturing package is derived authority

A manufacturing package should resolve the released baseline into buildable instructions: exact PCB/fabrication revision, assembly/BOM revision, approved alternates and population options, polarity/orientation notes, controlled assembly options, programming requirements, inspection criteria, and identifiers that must be captured.

The package may add process detail, but it may not silently change electrical semantics. If manufacturing needs a different component, topology, population option, or programming behavior, that is a deviation/change requiring engineering disposition.

Freeze:

> **WORK INSTRUCTION MAY EXPLAIN THE RELEASE; IT MAY NOT SECRETLY REDESIGN IT**

## 3. Reusable blocks publish scalable handoffs; boards own quantity

The inspected OpenPressBrake dry-contact relay handoff publishes 16.7 mA nominal `24V_MACHINE` current and about 0.40 W coil dissipation per energized instance, while explicitly leaving configured instance count and simultaneous-use assumptions to board integration. That is the correct direction of authority.

Manufacturing may populate the board-defined quantity. It must not convert the primitive into a machine-sized relay bank or infer an unstated machine duty pattern.

Freeze:

> **PER-INSTANCE BLOCK CONTRACT × RELEASED POPULATION = BOARD BUILD; POPULATION DOES NOT REDEFINE THE BLOCK**

## 4. Approved alternates require explicit applicability

An approved alternate belongs in the released manufacturing authority only when equivalence/qualification exists for the facets the design consumes.

Distinguish:

- `APPROVED_FOR_THIS_RELEASE`;
- `APPROVED_FOR_NAMED_VARIANTS_ONLY`;
- `ENGINEERING_REVIEW_REQUIRED`;
- `UNAPPROVED_AS_BUILT_DEVIATION`.

A qualified alternate omitted from an obsolete pick list is a manufacturing-document defect; it is not automatically an electrical design defect. Conversely, a same-value/package substitution is not automatically approved.

Freeze:

> **PROCUREMENT SIMILARITY != RELEASE APPLICABILITY**

## 5. Programming is manufacturing configuration

FPGA images, boot/configuration data, controller firmware where applicable, LinuxCNC/HAL configuration packages, calibration/configuration data, and checksums are first-class identities when they affect behavior.

A correct PCB/BOM loaded with the wrong FPGA image does not match the released controller configuration even if basic I/O toggles successfully.

Programming records should capture at least artifact ID/revision, immutable hash/checksum, target board identity, programming result, and verification/readback appropriate to the technology.

Freeze:

> **PROGRAMMING PASS != CORRECT PROGRAMMED IDENTITY**

## 6. Inspection must compare actual to released authority

Inspection is not merely workmanship review. It also reconciles configuration identity.

Check causally relevant items such as:

- PCB/fabrication marking;
- controlled component identities;
- population/DNP options;
- orientation/polarity;
- connector option and board-specific connection definition;
- rework wires/cuts/component changes;
- programmed artifact identity;
- required labels/serial identifiers.

Record `MATCH`, `APPROVED_DEVIATION`, `UNRESOLVED_DEVIATION`, or `MISMATCH` rather than forcing every observation into pass/fail.

## 7. As-built deviations are findings, not annotations to erase

For every material deviation record:

`observed delta -> affected released facet -> owner -> engineering disposition -> evidence/regression required -> resulting configuration identity`

Possible dispositions include accept as equivalent within the existing release, rework to released baseline, approve a controlled variant/new release, or reject/quarantine.

Do not overwrite the released BOM, schematic, or FPGA identity to make the physical unit appear conforming after the fact.

Freeze:

> **REWORK COMPLETE != DEVIATION HISTORY DELETED**

## 8. First power and bench I/O prove bounded claims only

First-power/bring-up evidence can establish questions such as rail presence, current reasonableness, programming communication, default/de-energized behavior, basic I/O direction, or absence of obvious assembly faults.

It cannot by itself prove:

- configuration identity when a mismatch remains;
- full operating-envelope qualification;
- PCB thermal/creepage/current-path qualification;
- machine wiring facts not inspected;
- independent personnel-safety validation.

The current OpenPressBrake relay checklist is a useful warning: even with electrical connectivity and a board-power handoff, CAD mapping, rendered schematic/ERC, PCB copper/creepage, machine mapping, bench checks, and board-level worst-case qualification remain open.

Freeze:

> **BOARD POWERS AND I/O WORKS != RELEASE INHERITANCE**

## 9. Release inheritance is a reconciliation result

A built unit inherits a released baseline only when all material identities match or every material deviation has an approved disposition whose evidence supports equivalence/applicability.

Use a fail-closed result:

```yaml
claimed_release: REL.CONTROLLER_A.R1.0007
as_built_identity: BUILD.A00173
hardware_match: MATCH
programmed_identity: MISMATCH
open_deviations: 1
release_inheritance: BLOCKED
next_action: load_and_verify_released_fpga_image
```

`BLOCKED` does not mean the unit is necessarily damaged. It means the engineering proposition "this is release R" has not been proved.

## 10. Commissioning reconciles the board to the machine

Before machine commissioning, reconcile board identity with machine-specific connection/harness/HAL facts. A field replacement board may be electrically valid yet still require mapping confirmation before motion/output authority is enabled.

Unknown legacy facts remain `VERIFY_AT_MACHINE`, with the smallest causally sufficient task named explicitly.

Examples: connector option, harness pinout revision, observed FPGA hash, HAL/configuration checksum, machine voltage/load class, or NO/NC mapping.

Freeze:

> **VALID REPLACEMENT HARDWARE != VALID MACHINE CONFIGURATION UNTIL MAPPING IS RECONCILED**

## 11. Connection blocks remain board-specific through manufacturing

Manufacturing and commissioning need connector type/pins, placement, silkscreen, FPGA/logical mapping, and harness destination. Recording these does not move them into reusable electrical blocks.

If a boundary contains real translation, isolation, conditioning, protocol conversion, or reusable protection, that circuitry remains a qualified adapter/block. Pin mapping remains board integration.

## 12. Safety boundary

Manufacturing/programming/commissioning records for an ordinary controller may verify that the ordinary safety-status receiver is populated, programmed, mapped, and electrically functioning as claimed. They do not establish PL/SIL/category, stopping performance, diagnostic coverage, or independent personnel-safety validation.

Freeze:

> **CONFIGURATION TRACEABILITY OF SAFETY STATUS != SAFETY-FUNCTION VALIDATION**

---

## Lab — eight adversarial handoffs

Use a fictional released controller with reusable blocks, board-specific connection definitions, a controlled BOM, two FPGA images, two HAL configurations, and several machine installations.

Disposition these cases:

1. **Wrong population option.** Correct PCB, but an option resistor/connector population belongs to another released variant.
2. **Stale pick list.** A qualified alternate is valid for the release but absent from an obsolete manufacturing pick list. Fix the manufacturing authority without inventing an electrical redesign.
3. **Wrong FPGA image.** PCB/BOM are correct; basic I/O works; programmed identity belongs to another variant.
4. **Unrecorded rework.** Board contains a wire/component rework that may be electrically justified but has no controlled deviation record.
5. **Bench-pass identity mismatch.** All simple bench I/O tests pass while a controlled component identity remains unresolved.
6. **Field replacement.** Replacement board matches a valid release but machine-specific HAL/harness mapping has not yet been reconciled.
7. **Unknown legacy board.** Define the minimum `VERIFY_AT_MACHINE` observations needed to determine whether release inheritance/applicability can be established.
8. **Safety-status receiver.** Trace population/programming/mapping and electrical function while explicitly refusing to treat this evidence as safety validation.

For each submit:

- claimed immutable release ID;
- manufacturing-package identity;
- observed PCB/BOM/population identity;
- programmed artifact identities/hashes;
- inspection result;
- deviations and affected facets;
- disposition owner;
- required evidence/regression;
- first-power/bench evidence scope;
- machine mapping state;
- release-inheritance state;
- installed identity after commissioning;
- unresolved facts/`VERIFY_AT_MACHINE` task;
- safety-authority statement.

### Lab pass criteria

A passing submission must keep design authority, manufacturing instructions, as-built identity, commissioning evidence, and installed identity separate; fail closed on material unresolved deviations; preserve rework/deviation history; treat FPGA/HAL identity as configuration when behavior depends on it; keep connection definitions board-specific; avoid contaminating reusable blocks with manufacturing quantity or machine mapping; and preserve the independent safety boundary.

---

## Catalog stress-test result

BD30 exposes the next infrastructure pressure: configuration traceability needs a machine-readable **as-built/deviation/programming record** that can join released design authority to actual serialized hardware and installed state.

A mature implementation should answer:

- what release was this unit intended to implement?
- what exact PCB/BOM/options were actually populated?
- which approved alternates were used?
- what FPGA/software/HAL artifacts were actually loaded?
- what rework/deviations occurred and who dispositioned them?
- what evidence proves release inheritance?
- what machine mapping was reconciled at commissioning?
- what is installed now?

OpenPressBrake does not yet provide evidence of a production released/serialized population, so no fictional serial or release registry is added there.

## Precise checkpoint

BD30 is complete when the student can take an immutable released baseline through manufacturing and commissioning without confusing design intent with physical reality, and can block release inheritance despite a successful bench test when configuration identity is unresolved.

Next: **BD31 — production test architecture, fixture contracts, calibration identity, and evidence capture**. Teach how reusable block contracts drive fixture/test requirements without making fixtures part of the product block, how board-level production tests differ from qualification, how calibration constants are controlled, and how test evidence binds to serialized as-built identity.