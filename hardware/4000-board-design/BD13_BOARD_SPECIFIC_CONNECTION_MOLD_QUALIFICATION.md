# BD13 — Board-Specific Connection-Mold Qualification

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BLOCK/CONNECTION METHODOLOGY  
**Design-flow position:** reusable blocks -> board-specific connections -> capture/PCB release

## Purpose

A reusable electrical block is not a connector, and a connector instance is not a reusable electrical block. This lesson teaches how to populate and qualify a **board-specific connection mold** without allowing machine-specific connector, harness, placement, or labeling decisions to leak backward into reusable circuitry.

The working flow is:

`machine endpoint evidence -> connection-mold fields -> connector electrical/mechanical requirements -> pin mapping -> power/return requirements -> functional/FPGA mapping -> placement/edge/orientation -> silkscreen/labels -> harness destination -> derating/clearance -> machine verification -> capture/PCB release state`

A connection mold is a methodology and schema. A completed connection definition is board-specific engineering data.

## Learning outcomes

By the end of BD13, the student can:

1. distinguish reusable functional-block ownership from board-specific connection ownership;
2. populate a connector instance from evidence without inventing unresolved physical facts;
3. prove that every physical contact has exactly one disposition;
4. trace each semantic pin to the owning functional block, shared resource, power domain, chassis, or explicit NC/reserved state;
5. keep signal return, load return, chassis/PE, and cable shield/drain distinct when the engineering requires it;
6. define placement, orientation, access, service, keepout, and silkscreen requirements as engineering inputs rather than late PCB cosmetics;
7. separate connector component rating from board/channel rating and require an actual derating basis;
8. classify unresolved machine facts as `VERIFY_AT_MACHINE` rather than guessing them;
9. decide whether a connection definition is merely electrically mapped, capture-ready, PCB-ready, or physically qualified;
10. identify when a connector problem is really a reusable-block contract defect.

## Student-facing source audit

The following current OpenPressBrake `main` artifacts were opened and inspected during preparation of this lesson. They are `VERIFIED_FOR_LESSON` only for the bounded claims made here:

- `hardware/CONNECTION_DEFINITION_CONTRACT.md` — ownership boundary, required fields, pin-map/power/placement/silkscreen contracts and capture release gates.
- `hardware/connection_definition_schema.yaml` — current machine-readable mold, explicit TBD/VERIFY_AT_MACHINE behavior and fail-closed `board_capture_ready` rule.
- `hardware/connections/REV1_ENCODER_CONNECTIONS.yaml` — strong example of electrically instantiated board-specific connections whose physical connector facts remain unresolved.
- `hardware/connections/REV1_CONNECTION_COVERAGE_CHECKPOINT.md` — current coverage/migration state and consolidated physical survey gates.
- `hardware/blocks/differential_encoder/manifest.yaml` — reusable functional owner used to verify that connector mechanics and machine channel count have not leaked into the primitive.

The complete OpenPressBrake board is **not** production-proven and none of these artifacts should be interpreted that way.

## 1. The ownership boundary

### Reusable functional block owns

The functional block owns electrical function: topology, components, semantic interfaces, direction and electrical envelope, required rails/returns, intrinsic protection, isolation/signal-integrity requirements, FPGA resource contract where applicable, verified limits, and engineering evidence.

### Board-specific connection definition owns

The connection definition owns the physical board boundary: exact connector and mate, footprint/pad numbering, physical pin mapping, voltage/current/contact derating, wire range, placement/orientation/access, board-edge constraints, silkscreen, harness destination, and machine-facing purpose.

### The rule

**CONNECTION MOLD REUSE != CONNECTION INSTANCE REUSE.**

Reuse the schema, qualification methods, connector-family evidence, placement conventions, label conventions, and validators. Do not pretend `J12 Y1 ENCODER` is a generic reusable electrical block.

If a connection cannot map cleanly to a functional block's semantic interface, do not rename nets inside the connection record to hide the mismatch. Reopen the correct owning contract.

## 2. Start with endpoint evidence, not a favorite connector

Before selecting a connector, create an endpoint evidence record containing at least:

| Question | Required disposition |
|---|---|
| What machine function crosses this boundary? | known / TBD |
| Direction? | input / output / bidirectional / power / return |
| Working voltage? | value + authority / TBD |
| Continuous and transient current? | value + authority / TBD |
| Number and type of contacts? | evidence-backed |
| Signal class? | logic, differential, analog, 24-V I/O, field power, load, etc. |
| Required return? | exact named domain |
| Shield/drain/chassis treatment? | explicit / VERIFY_AT_MACHINE |
| Harness retained? | retain / replace / adapter / new / VERIFY_AT_MACHINE |
| Wire size? | evidence-backed / VERIFY_AT_MACHINE |
| Environment/service constraints? | evidence-backed / TBD |
| Machine destination/source? | explicit |

Connector selection before this table is sufficiently bounded risks turning a convenient part into an undocumented electrical requirement.

## 3. Populate the mold fail-closed

The current schema deliberately permits `TBD` and `VERIFY_AT_MACHINE`. That is a feature.

For every connection instance populate:

- board ID/revision and physical reference;
- interface name/class/purpose;
- exact connector manufacturer/family/MPN **only when supported**;
- position count, keying, polarization, footprint, mate and contact system;
- working voltage/current/transient/derating and wire envelope;
- one explicit disposition for every physical position;
- functional owner/instance/interface for every semantic pin;
- all power, return, chassis/PE and shield/drain relationships;
- placement region/edge/side/orientation/access/keepout/separation;
- connector and pin markings;
- harness compatibility intent and evidence;
- verification sources and remaining machine survey items;
- release fields.

Missing physical facts remain unresolved. A generator is a renderer/checker, not an engineer allowed to fill them in.

## 4. Every contact needs exactly one disposition

A physical connector position may be a semantic net, NC, reserved, key, shield, or an explicitly engineered bridge. It may not be ambiguous.

For a semantic pin, prove this chain:

`physical contact -> semantic net -> functional/shared/power/chassis owner -> interface -> direction/electrical meaning -> machine destination`

An NC contact is still a deliberate disposition. A connector with eight mapped signals and one unexplained ninth position is not complete.

## 5. Returns and shields are first-class pins

Never normalize all return-like contacts to `GND`.

The connection record must preserve the distinctions established by functional and board integration authority, including as applicable:

- sensor/logic supply and return;
- field/load supply and load-current return;
- precision/signal return;
- chassis/protective earth;
- cable shield/drain.

Two returns may ultimately share an upstream electrical node while still having different permitted PCB current paths. Conversely, two machine wires with the same printed number are not automatically one net.

## 6. Physical placement is engineering

A connector definition is incomplete if the electrical pinout is known but the board cannot be laid out without unwritten mechanical knowledge.

Record as applicable:

- required edge/region and PCB side;
- insertion axis and outward-facing direction;
- mating/unmating and tool access;
- cable bend envelope;
- enclosure/panel accessibility;
- adjacency to chassis/shield entry;
- separation from high-current/noisy/precision regions;
- mating-hardware keepouts;
- fixed XY/tolerance only when mechanically constrained.

Absolute coordinates are normally a PCB-layout result, not something to invent in the connection mold.

## 7. Silkscreen is part of the physical interface

The board-specific record owns what the technician sees: connector label, pin/function labels where useful, polarity, pin-1/orientation marks, shield/chassis marks, justified warnings, and text direction/legibility constraints.

**SCHEMATIC NET NAME != SERVICE LABEL.**

A good semantic net can be a poor human label. The connection definition translates engineering identity into a deliberate physical human interface without changing the electrical semantics.

## 8. Ratings and derating

A connector datasheet rating does not establish board or channel capability.

For each connection distinguish:

1. connector/contact component rating;
2. populated-contact simultaneous-current assumptions;
3. temperature/environment derating;
4. conductor capability;
5. footprint/pad/copper/current-path capability;
6. source protection and branch limits;
7. load/inrush/fault envelope;
8. creepage/clearance requirements where applicable.

The released interface rating is bounded by the complete current path and its evidence, not the largest number on the connector datasheet.

## 9. Worked OpenPressBrake example — encoder connections

The current Rev1 encoder connection definitions are a useful **incomplete-on-purpose** example.

What is already frozen for Y1/Y2/X:

- legacy electrical pin positions;
- explicit ENC1/ENC2/ENC3 functional assignment;
- every contact disposition;
- encoder field 5-V and return semantics;
- differential A/Abar, B/Bbar, Z/Zbar mapping;
- connector-level service labels and polarity marks;
- connector-edge field region intent;
- prohibition on silently joining X-encoder qualified wire `S14_XENC_111` to the unrelated PVR qualified wire `S13_PVR_Y2S2_111`.

What is deliberately **not** frozen:

- exact connector manufacturer/family/MPN;
- exact PCB footprint and verified pad numbering;
- mating hardware;
- physical edge/facing/service/cable-bend details;
- harness compatibility confirmation;
- electrical envelope/derating;
- cable/termination facts needed to select the reusable receiver assembly variant.

Therefore these definitions are not board-capture-ready. Their own release record correctly leaves `board_capture_ready: false`.

The reusable `differential_encoder` manifest remains separate. It owns the AM26LV32E-based receiver function, protected/unterminated variants, 3.3-V FPGA-side interface, resource requirements, chassis-transient requirement and qualification boundaries. It explicitly leaves machine channel count to board configuration and field supply to a board resource. That is the desired separation.

## 10. Adversarial stress test

For one board-specific connection, challenge each of these statements:

1. "We know the pinout, so choose any footprint with the right pin count."
2. "The connector is rated 8 A, so call the board output 8 A."
3. "Both returns eventually reach machine 0 V, so join them beside the connector."
4. "The schematic has a connector name, so silkscreen can wait until layout."
5. "The old harness probably fits."
6. "The machine drawing shows wire 111 twice, so those are one net."
7. "The reusable encoder block should include J12 so the whole thing is reusable."
8. "The generator can select the closest connector if the MPN is missing."
9. "The connector is electrically complete, so it is PCB-ready."
10. "A safety-system status signal enters this connector, therefore this board becomes the safety authority."

A passing review rejects every shortcut unless specific evidence proves the underlying claim.

## 11. Student lab — qualify a connection mold

Choose a machine endpoint for a mill, lathe, plasma table, router, robot, press brake, or custom machine. Do not copy an OpenPressBrake connector mechanically unless the new machine actually uses it.

Produce:

1. endpoint evidence table;
2. populated connection definition;
3. one-row-per-contact pin disposition table;
4. functional-owner trace for every semantic pin;
5. power/return/shield domain table;
6. connector/contact/current-path derating ledger;
7. placement/orientation/access/keepout record;
8. silkscreen/service-label plan;
9. harness compatibility decision;
10. `VERIFY_AT_MACHINE` list;
11. release checklist;
12. catalog-defect report for anything that required unwritten functional-block knowledge.

### Stop conditions

Do **not** mark the connection capture-ready if any of the following is unresolved:

- exact connector/footprint/pad numbering;
- contact disposition;
- required electrical envelope/derating;
- power/return/shield ownership;
- functional instance mapping;
- placement/orientation/access needed for layout;
- required markings;
- harness compatibility;
- unmarked machine facts.

The correct result may be `INCOMPLETE_NOT_STUDENT_MATERIAL` or `ENGINEERING_REVIEW_NEEDED`. An explicit incomplete result is better engineering than a fabricated complete one.

## 12. Catalog stress-test findings

BD13 exposes several catalog-level improvements worth carrying forward:

1. **Connection readiness should be mechanically validated as well as electrically validated.** A schema can require the fields, but a board-level validator should eventually fail capture/release when an instantiated connector lacks physical-part, footprint, derating, placement, or harness evidence.
2. **Connector-family qualification is reusable data without becoming a functional block.** Manufacturer drawing, footprint/pad proof, contact system, wire range, derating and mating-part evidence can be shared across connection instances while J-number, machine purpose, net mapping and placement remain board-specific.
3. **Electrical mapping complete and physical connection qualified need separate maturity states.** The current encoder definitions already demonstrate this distinction; tooling should preserve it rather than compressing both into one generic "complete" flag.
4. **Machine-survey evidence should be attachable to individual fields.** `VERIFY_AT_MACHINE` is fail-closed today, but field-level provenance would make later closure and regression review stronger.
5. **Harness identity deserves a durable qualified identifier.** Reusing a connector family does not prove that an existing harness is electrically, mechanically, or conditionally fit for reuse.

These are methodology/catalog findings, not permission to modify an actively changing OpenPressBrake integration lane without coordination.

## 13. Safety boundary

Connection definitions may route or monitor independent safety-system signals, but ordinary LinuxCNC/FPGA hardware gains no personnel-safety authority from that routing. Do not credit a connection definition, FPGA watchdog, or ordinary output inhibit as the independent safety function unless a separately safety-rated design and validation supports that claim.

## Durable freezes

- `REUSABLE BLOCK != BOARD-SPECIFIC CONNECTION INSTANCE`.
- `CONNECTION MOLD REUSE != CONNECTION INSTANCE REUSE`.
- `ELECTRICAL PINOUT KNOWN != PHYSICAL CONNECTOR QUALIFIED`.
- `RIGHT PIN COUNT != VERIFIED FOOTPRINT/PAD MAPPING`.
- `CONNECTOR COMPONENT RATING != RELEASED BOARD/CHANNEL RATING`.
- `SAME NOMINAL RETURN != PERMISSION TO SHARE PCB CURRENT PATH`.
- `SAME MACHINE WIRE NUMBER != PROVEN COMMON NET`.
- `SCHEMATIC NET NAME != SERVICE LABEL`.
- `VERIFY_AT_MACHINE != LICENSE TO GUESS`.
- `GENERATOR RENDERS/CHECKS AUTHORITY; GENERATOR DOES NOT INVENT AUTHORITY`.
- `ELECTRICAL CONNECTION COMPLETE != CAPTURE READY != PCB READY != MACHINE QUALIFIED`.
- `ORDINARY CONNECTION TO SAFETY STATUS != PERSONNEL-SAFETY AUTHORITY`.

## Readiness result for the worked example

`REV1_ENCODER_CONNECTIONS.yaml` is **VERIFIED_FOR_LESSON** as an example of correctly bounded, electrically instantiated connection definitions with explicit physical gates. It is **INCOMPLETE_NOT_STUDENT_MATERIAL** if presented as a finished physical connector/PCB-release example.

That dual classification is intentional: readiness attaches to the claim being taught, not merely to the filename.

## Next lesson

**BD14 — connector-family qualification and reusable physical-interface evidence.** Build the reusable evidence layer beneath connection molds without turning connector families into functional electrical blocks: manufacturer drawing authority, footprint/pad proof, mating/contact system, conductor range, derating, creepage/clearance, mechanical model/keepout, sourcing/substitution rules, and regression triggers. Then instantiate that evidence into at least two different board-specific connections to prove the reuse boundary.