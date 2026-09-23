# BD64 — Connection-Definition Instance Closure and Generator-Ready Contracts

Status: student-ready lesson with bounded audited OpenPressBrake assertions  
Lane: independent BOARD-DESIGN CURRICULUM  
OpenPressBrake source revision inspected: `a644326acd6fcd57dc7f57dd2d86ae1e51dda00b`

## Purpose

BD63 established that schema-valid is not authority-valid. BD64 addresses the next mistake: treating an authority-reconciled semantic connector record as if it were ready to generate a manufacturable schematic/PCB interface.

The closure chain is:

`validated semantic record -> physical connector evidence -> footprint/pad proof -> electrical derating -> placement/marking/harness closure -> generator inputs -> KiCad capture eligibility -> evidence lock`

The central rule is: **semantic closure is not physical closure, and neither is manufacturing closure.** A generator must render only supported facts; it must never turn `TBD` or `VERIFY_AT_MACHINE` into plausible-looking hardware.

## Learning objectives

The student can:

1. separate semantic, physical, electrical-rating, mechanical/service, and manufacturing closure;
2. identify the evidence needed to freeze a connector MPN and footprint;
3. prove pad numbering independently rather than trusting symbol/footprint naming;
4. distinguish connector contact rating from released board/channel rating;
5. make placement, access, marking, mate, and harness compatibility first-class generator inputs;
6. compute board-capture eligibility from evidence rather than from record completeness;
7. lock generated artifacts to exact authority revisions and invalidate them on dependency drift;
8. preserve unresolved machine facts without inventing measurements.

## Student-facing source audit

Every OpenPressBrake file named below was opened in its current form during this run.

| File | Readiness | Bounded use |
|---|---|---|
| `hardware/CONNECTION_DEFINITION_CONTRACT.md` | VERIFIED_FOR_LESSON | ownership, required closure fields, generator boundary and release gates |
| `hardware/connection_definition_schema.yaml` | VERIFIED_FOR_LESSON | fail-closed instance mold; current checkpoint remains `SCHEMA_DEFINED_NOT_MIGRATED` |
| `hardware/REV1_FIELD_CONNECTOR_INTEGRATION_BOUNDARY.md` | VERIFIED_FOR_LESSON | physical-part ownership, connector selection classes, derating and machine-survey boundary |
| `hardware/REV1_CONNECTOR_MAP.yaml` | VERIFIED_FOR_LESSON only as bounded electrical-pinout authority; ENGINEERING_REVIEW_NEEDED as a complete physical connection set | preserved pin positions/functions and explicit mechanical unknowns |
| `hardware/blocks/STATUS_RULES.md` | VERIFIED_FOR_LESSON | evidence truthfulness and distinction between integration readiness and qualification |
| `board-design/BD63_CONNECTION_VALIDATION_AUTHORITY_RECONCILIATION.md` | VERIFIED_FOR_LESSON | prerequisite four-gate validation method and negative corpus |

No file above proves an exact retained connector MPN, footprint, pad mapping, mating hardware, board-edge geometry, cable-bend clearance, or harness condition for the audited legacy connectors. Those facts therefore remain unresolved.

## Five closure facets

### 1. Semantic closure

Every physical position has an explicit disposition and maps to the correct functional owner, power domain, return, chassis/shield role, or explicit NC/reserved state. This is the BD63 gate.

### 2. Physical-part closure

Freeze manufacturer, family, exact MPN, position count, keying/polarization, mate/contact system, accepted conductor range and construction only from current manufacturer evidence and, for retained interfaces, machine/harness evidence.

A matching position count is not proof of a matching connector.

### 3. Footprint/pad closure

The exact PCB footprint must be checked against the manufacturer drawing. Verify at minimum pad numbering, pitch, row/order convention, keying, mounting/retention features, drill/slot dimensions, courtyard/keepout implications and pin-1 orientation.

A library footprint name is not evidence that pad numbering matches the physical part.

### 4. Electrical-envelope closure

Record working voltage, continuous and relevant transient current, simultaneous-contact derating, conductor range, and applicable spacing constraints. Then reconcile those limits with the functional block and board power/current budget.

**Connector rating != released channel rating.** The released envelope is bounded by the weakest justified element across source/protection, PCB copper/vias, connector/contact, wire/harness, return path, ambient and simultaneity.

### 5. Placement/service/manufacturing closure

Record required edge/region, PCB side, insertion axis, outward direction, mating/unmating space, tool access, cable bend, enclosure access, separation/adjacency constraints, keepouts, connector/pin labels, orientation/polarity marks, mate/harness intent and evidence.

These are engineering inputs. They are not decorative PCB cleanup.

## Audited OpenPressBrake example — `J_DNC_PWR`

Use the simple two-position legacy controller-power interface to show what can and cannot be closed from current authority.

Current electrical pin authority supports:

- legacy connector identity: DNC60 J19;
- two physical positions;
- position 1 = wire 9 / `L9` / `CONTROLLER_24V` power input;
- position 2 = wire 4 / `L06` / `CONTROLLER_0V` return;
- interface class = controller power.

These are **KNOWN_AND_RECONCILABLE** semantic facts.

Current authority simultaneously says its mechanical identity is `VERIFY_AT_MACHINE`. The field-connector boundary further lists retained connector manufacturer/series, keying, mating-shell condition, conductor size, enclosure/board-edge access and cable-bend clearance among unresolved physical facts. Therefore the following are **not** currently justified:

- connector manufacturer/family/MPN;
- footprint or pad geometry;
- exact mating plug/contact;
- keying/polarization details;
- retained-harness condition;
- accepted/installed conductor size unless separately proven;
- board edge, orientation, insertion direction or absolute location;
- service/tool/cable-bend clearance;
- a released connector or board current rating.

The correct result is not to choose a convenient two-pin terminal block. The correct result is a semantically useful but **board-capture-ineligible** connection instance until physical evidence closes the required fields.

## Generator-ready states

Use explicit states instead of one overloaded `ready` flag:

- `SEMANTICALLY_RECONCILED` — pin/function/owner/domain authority is reconciled; physical facts may remain unresolved.
- `PHYSICAL_PART_FROZEN` — exact connector and mate are supported by evidence.
- `FOOTPRINT_VERIFIED` — footprint/pad mapping independently matches the frozen part.
- `ELECTRICAL_ENVELOPE_SUPPORTED` — connector/contact/wire limits and derating are supported and reconciled with board limits.
- `PLACEMENT_HARNESS_MARKING_CLOSED` — mechanical/service/harness/human-interface facts required for capture are supported.
- `BOARD_CAPTURE_ELIGIBLE` — every release prerequisite is closed and no prohibited duplication of functional-block engineering exists.
- `GENERATED_ARTIFACT_LOCKED` — generated schematic/PCB-facing artifact records exact source revisions/digests and can be invalidated when they drift.

A project may generate a **review-only preview** from earlier states if unresolved fields remain visibly unresolved and the artifact is mechanically incapable of masquerading as released capture. Do not populate a production footprint placeholder merely to make a preview look complete.

## Generator contract

A connection-definition generator/checker should consume, not invent:

1. schema/contract version;
2. board/revision and connection-instance identity;
3. source electrical pin authority;
4. functional-owner/shared-resource references;
5. exact connector and mate evidence;
6. verified footprint/pad mapping;
7. supported electrical envelope and derating basis;
8. placement/keepout/access constraints;
9. silkscreen/marking requirements;
10. harness compatibility decision and evidence;
11. unresolved facts and release state.

For each generated object, emit provenance sufficient to answer: **which exact source fact caused this symbol pin, footprint pad, net, label, or constraint to exist?**

## Evidence lock

A board-capture artifact is stale when any consumed authority changes materially. At minimum lock:

- source repository revision;
- connection schema/contract revision;
- connection-instance revision/digest;
- electrical pin-authority revision/digest;
- functional block/resource contract revisions consumed by the instance;
- connector manufacturer drawing revision or stable document identity;
- footprint definition revision/digest;
- machine-survey evidence identity for retained-harness/mechanical facts;
- generator version/configuration.

Before promotion, re-resolve those dependencies against current main. If any semantic dependency changed, apply the evidence-invalidation method from the preceding board-design lessons rather than assuming unchanged generated output means unchanged validity.

## Fail-closed examples

A generator or release checker must reject these plausible shortcuts:

- selecting an arbitrary two-position connector for `J_DNC_PWR` because the source has two pins;
- assigning a footprint before exact connector evidence exists;
- treating a footprint library name as pad-numbering proof;
- using the connector datasheet's headline contact current as the board/controller power rating;
- collapsing `L06` into a generic return without reconciling the board power-domain architecture;
- inventing board-edge placement because the connector is machine-facing;
- claiming retained-harness compatibility without inspecting the mate/harness;
- silently replacing `VERIFY_AT_MACHINE` with a concrete value;
- generating production KiCad capture while release prerequisites remain false;
- retaining an old generated connector after its MPN, footprint, pin authority or machine evidence changed without revalidation.

## KiCad capture eligibility

KiCad generation/capture is allowed as production-intent board capture only after the connection instance satisfies the contract's release gates. ERC cannot prove connector mechanical identity, harness compatibility, pad numbering, current derating, service clearance or provenance. Those must be closed before ERC can become meaningful downstream evidence.

Once eligible, schematic capture should preserve the semantic nets and typed returns from their owning blocks, instantiate the exact verified connector symbol/footprint mapping, preserve explicit NC/reserved contacts, and carry evidence-lock metadata into the generated/captured design where practical.

## Catalog stress-test result

The current architecture has the right ownership boundary, but the audited repository still lacks migrated release-consumable connection instances with exact physical connector evidence. That is **ENGINEERING_REVIEW_NEEDED** infrastructure, not permission to guess parts.

The teaching exercise exposes an important catalog requirement: connection instances need machine-readable closure state and evidence references per facet, not merely a single `board_capture_ready` Boolean. That allows tooling to distinguish a useful semantic migration from a physically frozen connector and prevents unresolved machine facts from being hidden by a generated schematic.

OpenPressBrake remains read-only in this lesson. Current main is actively advancing reusable resource contracts, and no justified connector physical evidence appeared that would safely close the legacy interface without machine survey.

## Transfer exercise

For a mill, lathe, plasma table, router, robot, or custom automation board, choose one ordinary non-safety connector. Produce a closure matrix with the five facets above. For every concrete physical value, identify the exact manufacturer or machine evidence. For every unresolved value, state whether it blocks semantic integration, board capture, PCB layout, harness release, or final commissioning.

Then identify one plausible shortcut that would make the CAD look more complete while making the engineering evidence worse.

## Safety boundary

This lesson concerns ordinary board interfaces. Routing, marking, or generating a connection definition never grants personnel-safety authority. Independent safety equipment and its separately validated architecture retain that authority.

## Checkpoint

BD64 is complete. Next develop **BD65 — KiCad Connection Generation, Provenance-Carrying Capture, and ERC Boundaries**:

`capture-eligible connection instance -> deterministic symbol/footprint/net generation -> provenance metadata -> ERC -> semantic reconciliation -> generated-artifact diff -> evidence lock -> board-integration acceptance`

Do not let ERC or successful generation substitute for physical connector, current-rating, harness, safety, or machine-verification evidence.