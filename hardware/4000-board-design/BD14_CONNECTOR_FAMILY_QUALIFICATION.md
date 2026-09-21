# BD14 — Connector-Family Qualification and Reusable Physical-Interface Evidence

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BLOCK/CONNECTION METHODOLOGY  
**Design-flow position:** reusable blocks -> reusable physical-interface evidence -> board-specific connections -> capture/PCB release

## Purpose

BD13 established that a connection mold is reusable methodology while a completed connector instance is board-specific. BD14 adds the missing middle layer: **reusable connector-family qualification evidence**.

The working flow is:

`manufacturer drawing -> exact family/MPN/contact system -> mating parts -> footprint/pad proof -> conductor range -> voltage/current/temperature derating -> creepage/clearance -> keying/polarization -> mechanical model/keepout -> sourcing/substitution rules -> evidence revision -> regression triggers -> connection-instance consumption`

A connector-family qualification record is reusable physical-component evidence. It is **not** a reusable functional electrical block, a machine wiring definition, or a board-specific connection instance.

## Learning outcomes

By the end of BD14, the student can:

1. distinguish functional-block authority, connector-family evidence, and board-specific connection authority;
2. build a connector-family evidence record from exact manufacturer authority rather than catalog-page resemblance;
3. prove footprint pad numbering against the exact selected part/drawing;
4. separate component/contact ratings from board/channel ratings;
5. preserve conductor, contact, mating, keying, creepage/clearance, temperature and simultaneous-current limitations;
6. define substitution rules that fail closed when a candidate changes a qualified property;
7. attach exact source/revision provenance and regression triggers to physical-interface evidence;
8. allow multiple connection instances to consume the same family evidence without inheriting each other's machine mapping, placement or labels;
9. refuse to invent a connector family when machine identity is still `VERIFY_AT_MACHINE`;
10. recognize when a physical-interface problem belongs in board integration rather than in a reusable functional block.

## Student-facing source audit

The following current OpenPressBrake `main` artifacts were opened and inspected during preparation of this lesson. They are `VERIFIED_FOR_LESSON` only for the bounded claims made here:

- `hardware/CONNECTION_DEFINITION_CONTRACT.md` — freezes the ownership boundary and explicitly identifies connector-family qualification data as reusable while J-number, semantic mapping, placement, labels, harness assignment and machine purpose remain board-specific.
- `hardware/REV1_FIELD_CONNECTOR_INTEGRATION_BOUNDARY.md` — freezes physical connector selection by electrical/interface class and requires exact manufacturer/series/MPN, mating system, ratings/derating, wire range, spacing, footprint/pin proof and harness compatibility before selection.
- `hardware/connection_definition_schema.yaml` — current fail-closed board-specific mold. Exact connector, footprint, mate and many physical facts remain `VERIFY_AT_MACHINE`; the generator may not invent them.
- `hardware/connections/REV1_ENCODER_CONNECTIONS.yaml` — three electrically instantiated encoder connectors whose exact physical connector family is still unknown.
- `hardware/connections/REV1_VALVE_POSITION_CONNECTIONS.yaml` — two electrically instantiated valve-position connectors whose exact physical connector family is also still unknown.

These files do **not** establish that the encoder and valve-position connectors share a physical family. They are used to show how multiple board-specific instances could consume qualified family evidence **after** physical identity is proved.

The complete OpenPressBrake board is not production-proven.

## 1. Three different authorities

### Reusable functional block

Owns electrical function: topology, components intrinsic to the function, semantic interface, required rails/returns, protection, isolation/signal-integrity requirements, resource needs, verified limits and qualification evidence.

### Reusable connector-family qualification

Owns evidence about a physical component system: exact family/series/MPN scope, mating/contact system, footprint/pad authority, conductor acceptance, component ratings and derating rules, creepage/clearance facts, keying/polarization, mechanical envelope, sourcing constraints, source revisions and regression triggers.

### Board-specific connection definition

Owns the actual board instance: J-number, machine purpose, semantic nets, functional owner mapping, machine/harness destination, selected qualified connector record, placement/orientation/access, labels/silkscreen and board-specific release state.

**CONNECTOR-FAMILY EVIDENCE != FUNCTIONAL BLOCK != CONNECTION INSTANCE.**

## 2. Minimum connector-family qualification record

A reusable physical-interface evidence record should contain at least:

| Field | Required evidence |
|---|---|
| Qualification ID | durable unique ID + revision |
| Manufacturer/family | exact manufacturer and family/series |
| Qualified MPN scope | exact MPN or explicitly bounded variant set |
| Construction | board header, terminal block, circular, cable shell, etc. |
| Positions | exact qualified position count/variant rules |
| Contact system | exact contact type/plating/material where relevant |
| Mate | exact compatible mating parts/contact system |
| Keying/polarization | exact qualified scheme |
| PCB footprint | exact footprint identity |
| Pad numbering | independently cross-checked against manufacturer drawing |
| Pitch/mechanical envelope | drawing-backed dimensions/tolerances |
| Conductor range | accepted wire/conductor range and preparation requirements |
| Working ratings | voltage/current/temperature facts from manufacturer authority |
| Derating | simultaneous-contact, ambient, conductor and other applicable basis |
| Creepage/clearance | connector-attributable facts and limits |
| Mechanical constraints | insertion/removal, latch, keepout, mounting hardware |
| Source authority | exact document number/revision/date/pages where possible |
| Sourcing | approved exact parts; lifecycle/source notes |
| Substitution | properties that must be re-proved for any substitute |
| Regression triggers | changes requiring REVIEW/RECALCULATE/REQUALIFY |

Unknown facts remain unresolved. A family name is not enough.

## 3. Exact part scope matters

Do not qualify a broad family by inspecting one convenient member and assuming every variant is equivalent.

A qualification may cover multiple MPNs only when the manufacturer evidence proves that the relevant properties are invariant or the record explicitly captures the variant differences. Position count, pitch, current rating, contact plating, keying, mounting style, wire acceptance, creepage/clearance, latch geometry and footprint may differ inside one marketing family.

**SAME FAMILY NAME != SAME QUALIFIED PHYSICAL INTERFACE.**

## 4. Footprint and pad-number proof

For the exact selected board part:

1. obtain the manufacturer dimensional/pin-identification drawing;
2. identify the manufacturer viewing convention;
3. map each numbered contact to the PCB land/pad;
4. independently check the CAD footprint against that mapping;
5. verify pitch, row spacing, drill/slot geometry, mounting features and keepout as applicable;
6. record drawing/revision authority;
7. render/inspect the footprint before release when a CAD footprint exists.

A library footprint with a matching name is evidence only after it is checked.

**LIBRARY FOOTPRINT EXISTS != PAD NUMBERING VERIFIED.**

## 5. Ratings and derating remain bounded

Connector-family qualification may establish component/contact facts, but it does not establish the board interface rating.

Keep separate:

- manufacturer contact current rating and its test conditions;
- simultaneous-contact/ambient derating;
- accepted conductor size and termination method;
- connector voltage and spacing facts;
- board pad/via/copper/current-path capability;
- upstream protection/branch capability;
- load steady-state/inrush/fault envelope;
- thermal environment and enclosure conditions.

The board-specific released rating is the supported intersection of the complete path.

**QUALIFIED CONNECTOR RATING != RELEASED CHANNEL RATING.**

## 6. Mechanical evidence is reusable only where it really is invariant

Family evidence may own connector body dimensions, latch envelope, mating travel, manufacturer-required keepout and mounting hardware geometry. It should not own the connector's location on a particular board, enclosure access, local cable bend, adjacent noisy circuitry, machine harness routing or printed service label.

Those remain connection-instance/integration facts.

## 7. Keying and misconnection

Record exact polarization/keying and which variants are physically compatible. If two interface classes use the same family, board integration must still determine whether color/keying/positioning/separation is sufficient for plausible service misconnection.

Connector-family qualification proves what mates. It does not decide what **should** be allowed to mate on a machine.

## 8. Sourcing and substitution

A substitute is not qualified merely because distributor filters show the same pitch and position count.

At minimum compare:

- exact contact/pad numbering;
- mating compatibility;
- keying/polarization;
- mounting and footprint geometry;
- current/voltage/temperature ratings and test conditions;
- conductor range/termination method;
- creepage/clearance;
- contact material/plating where relevant;
- retention/latch behavior;
- mechanical envelope and keepout.

Classify the result:

- `DROP_IN_QUALIFIED` — every property within the qualification scope is proved equivalent;
- `REVIEW_REQUIRED` — differences exist but may be acceptable after engineering review;
- `NEW_QUALIFICATION_REQUIRED` — the substitute falls outside the qualified scope.

Do not let procurement silently widen engineering authority.

## 9. Evidence revision and regression triggers

The qualification record must carry exact source revision where possible. Changes that should reopen evidence include:

- connector MPN/family/contact change;
- manufacturer drawing revision affecting geometry, numbering, ratings or mating;
- footprint/pad change;
- mating part/contact change;
- conductor size/termination method change;
- current population or ambient assumption change;
- keying/polarization change;
- mechanical mounting/retention change;
- a substitute outside the explicitly qualified set.

Map each trigger to `RERUN`, `RECALCULATE`, `REVIEW`, or `REQUALIFY` rather than using a generic "recheck connector" note.

## 10. How a connection instance consumes family evidence

A board-specific connection should reference a qualification ID/revision and then add its own facts.

Example conceptual handoff:

`connector_family_qualification: CFQ-017 rev C`

The family record may supply exact MPN, mate/contact system, footprint/pad proof, component ratings, conductor range and mechanical body envelope.

The connection instance still supplies:

- `J_Y1_SCALE` or other reference;
- `Y1 ENCODER` purpose;
- semantic nets and functional owner instance;
- power/return/shield mapping;
- machine harness destination;
- board edge/side/orientation;
- local access/cable-bend/separation constraints;
- silkscreen/service labels;
- board-specific derating/current-path proof;
- harness compatibility evidence.

Two instances may reference the same qualification while remaining different connections.

## 11. OpenPressBrake worked boundary — do not invent the family

The current Rev1 encoder definitions have three board-specific instances. Their electrical pin dispositions and functional ownership are substantially frozen, but `manufacturer`, `family`, `mpn`, `footprint` and `mate` remain `VERIFY_AT_MACHINE`. Their release state keeps exact connector, footprint/pad proof, electrical envelope, placement and harness compatibility open.

The current Rev1 valve-position definitions similarly freeze the electrical roles for two four-position interfaces, including a nominal 24-V sensor supply, 0-to-12-V position signal and quiet sensor return, while exact connector identity, footprint/mate, installed sensor current, conductor size, placement and harness compatibility remain open.

Therefore BD14 does **not** create an OpenPressBrake connector-family record from these files. Doing so would convert a missing physical-machine fact into invented catalog authority.

The correct current state is:

- the **method/schema** for family qualification is teachable;
- the OpenPressBrake connection instances remain blocked on physical identity where stated;
- after machine survey identifies an exact connector, manufacturer evidence can support a real qualification record;
- only then may multiple instances reference the same record if their exact physical parts truly fall within its scope.

## 12. Adversarial reuse test

Given two connection instances proposed to share one qualification, challenge:

1. Are the exact MPNs within the record's qualified scope?
2. Is pad numbering identical and proved for each PCB part?
3. Do they use the same mating/contact system?
4. Are keying/polarization variants actually compatible as intended?
5. Are conductor sizes inside the qualified range?
6. Are both applications within the connector component's supported electrical/thermal envelope?
7. Does either application need a different creepage/clearance class?
8. Does either machine harness change mating or service constraints?
9. Is board-specific simultaneous current separately proved?
10. Did any semantic net, J-number, placement or label leak into the reusable family record?

If item 10 is yes, the reusable evidence layer has begun absorbing board-specific connection data and must be corrected.

## 13. Student lab — create and consume a connector-family qualification

Choose a real connector with an exact manufacturer MPN and authoritative manufacturer drawing. Produce:

1. qualification ID/revision;
2. exact MPN/family scope;
3. source/revision ledger;
4. mating/contact system table;
5. footprint/pad-number proof;
6. conductor/termination envelope;
7. component electrical/temperature/derating table;
8. creepage/clearance evidence;
9. mechanical body/keepout/keying record;
10. sourcing/substitution rules;
11. regression-trigger matrix;
12. two hypothetical board-specific connection instances consuming the same qualification but using different semantic nets, labels, machine purposes and placements.

Then prove that changing one instance's label, J-number, machine destination or board edge does **not** modify the reusable qualification. Conversely, changing the connector MPN, footprint, mate or relevant manufacturer authority must trigger qualification review.

### Stop conditions

Do not mark the family qualification complete when any property relied upon by a consuming connection is based only on distributor text, visual resemblance, an unverified library footprint, an inferred mate, or an unbounded family-level assumption.

## 14. Catalog stress-test findings

BD14 identifies a useful future catalog layer: a machine-readable connector-family qualification record referenced by connection definitions. It should contain physical-component evidence and regression semantics but no functional topology or machine mapping.

A future schema should support at least:

- durable qualification ID/revision;
- exact qualified MPN/variant scope;
- exact source document revisions;
- mating/contact system;
- verified footprint/pad authority;
- component electrical/mechanical limits;
- conductor and derating rules;
- keying/polarization;
- substitution status;
- regression triggers;
- evidence readiness state.

Do not add an OpenPressBrake family instance until exact physical identity is evidence-backed. Current field-connector work is active, so this curriculum pass leaves OpenPressBrake read-only rather than creating speculative catalog records.

## 15. Safety boundary

Connector-family qualification may support wiring that carries safety-system signals, but it establishes no personnel-safety function. Ordinary LinuxCNC/FPGA controller hardware may monitor or route independent safety status without becoming the safety authority.

## Durable freezes

- `CONNECTOR-FAMILY EVIDENCE != FUNCTIONAL BLOCK != CONNECTION INSTANCE`.
- `SAME FAMILY NAME != SAME QUALIFIED PHYSICAL INTERFACE`.
- `LIBRARY FOOTPRINT EXISTS != PAD NUMBERING VERIFIED`.
- `QUALIFIED CONNECTOR RATING != RELEASED CHANNEL RATING`.
- `PHYSICALLY MATES != SHOULD BE ALLOWED TO MATE`.
- `DISTRIBUTOR FILTER MATCH != QUALIFIED SUBSTITUTE`.
- `MACHINE IDENTITY UNKNOWN != PERMISSION TO CREATE A FAMILY RECORD`.
- `QUALIFICATION REUSE != J-NUMBER/NET/PLACEMENT/LABEL REUSE`.
- `VERIFY_AT_MACHINE != LICENSE TO GUESS`.
- `ORDINARY CONNECTOR EVIDENCE != PERSONNEL-SAFETY AUTHORITY`.

## Readiness result

The current OpenPressBrake governance and the two inspected connection-definition sets are **VERIFIED_FOR_LESSON** for the bounded ownership, fail-closed and unresolved-identity claims made here. They are **INCOMPLETE_NOT_STUDENT_MATERIAL** if presented as completed physical connector-family qualifications.

That is the intended result: the curriculum can teach the qualification method without fabricating the missing machine facts.

## Next lesson

**BD15 — KiCad capture hierarchy, ERC, and rendered-authority validation.** Start from current main, select only blocks/connections whose exact capture authority is verified, and teach how reusable block connectivity plus board-specific connection ownership becomes a reviewable schematic without letting the renderer invent electrical engineering.