# BD61 — Connection-Block Completeness, Semantic Endpoint Identity, and Harness Closure

Status: student-ready lesson framework with a bounded, audited OpenPressBrake worked example  
Lane: independent BOARD-DESIGN CURRICULUM  
OpenPressBrake source revision inspected for this lesson: `6ed297bd40e6cd2c3df11b9188e396eb8e2daf8b`

## Why this lesson exists

A reusable electrical block is not a connector, and a connector is not a reusable electrical block. Board integration fails when this boundary is blurred: a correct circuit can be connected to the wrong machine wire, return, FPGA endpoint, harness position, or service label.

The design flow for this lesson is:

`machine endpoint -> board connection requirement -> physical connector/pin -> semantic electrical endpoint -> functional owner -> FPGA/logical endpoint where applicable -> physical placement/marking -> harness destination -> verification -> release-consumable connection definition`

A connection definition is board-specific. It consumes a reusable block contract; it must not silently redefine the block.

## Learning objectives

By the end of the lesson the student can:

1. distinguish reusable functional-block ownership from board-specific connection ownership;
2. assign stable semantic endpoint identities before assigning physical pins;
3. give every physical contact an explicit disposition, including NC, reserved, key, shield, bridge, power, and return contacts;
4. trace power and return domains without collapsing them into generic `GND`;
5. trace a signal from machine/harness endpoint through connector and functional owner to FPGA/logical endpoint where one exists;
6. record connector placement, orientation, access, separation, and silkscreen as engineering inputs rather than late PCB cosmetics;
7. fail closed when connector family, mating hardware, harness condition, shield termination, or machine wiring is not proven;
8. decide whether a connection definition is board-capture-ready without claiming that the whole board or machine is qualified.

## Ownership rule

### Reusable block owns

Topology, component choices, electrical interface semantics, operating envelope, required rails/returns, intrinsic protection, isolation/signal-integrity requirements, and the evidence supporting those claims.

### Board-specific connection definition owns

Board/revision, connector reference, exact connector and footprint, pin mapping, mating part, wire range, contact derating, physical placement/orientation, human-readable markings, harness destination, and the mapping from physical contacts to the reusable block/shared resource/power-domain interface.

A board-specific connector name such as `J_Y1_SCALE` must never leak back into a reusable differential-encoder receiver merely because that receiver is used there.

## Semantic endpoint identity

Do not begin with `pin 4`. Begin with the endpoint's meaning.

A release-consumable endpoint record needs enough identity to answer all of these questions without unwritten knowledge:

- What physical machine/harness endpoint is this?
- What board and connector instance receives it?
- What is the physical pin/contact?
- What semantic net/interface crosses that contact?
- Which reusable block, shared resource, power domain, chassis point, or explicit `none` owns that semantic endpoint?
- What direction and electrical class apply?
- Which FPGA/logical endpoint consumes or produces it, if any?
- Which return/shield/power domain accompanies it?
- What is printed on the board for a technician?
- What source proves the mapping?
- What remains `VERIFY_AT_MACHINE`?

The semantic identity must survive a connector-family change. If changing a connector MPN changes the meaning of the endpoint, the design has coupled physical implementation to functional semantics too tightly.

## Contact completeness rule

Every physical position has exactly one explicit disposition. A blank position is not an NC position.

Acceptable dispositions include semantic signal, power, return, chassis/shield, `NC_LEGACY`, `NC_MACHINE`, `RESERVED`, `KEY`, and `BRIDGE`. The exact project schema controls spelling, but the engineering requirement is invariant: no physical contact is semantically anonymous.

For every semantic contact, record its functional owner and interface. A generator must reject, not guess, an ownerless semantic contact.

## Return and shield closure

A connection review must separately trace:

- logic/sensor supply and return;
- field/load supply and return;
- precision/signal return;
- chassis/protective earth;
- cable shield/drain.

Never join two returns because they are both casually called ground. The reusable block contract and board power architecture own whether a domain join is allowed.

## Harness closure

A connector is not closed merely because its schematic pins are assigned. Harness closure requires evidence for the mating interface and machine destination.

For retained machinery, record whether the existing harness is retained, replaced, adapted, or still `VERIFY_AT_MACHINE`. Connector manufacturer/series, keying, mating shell/contact, conductor range, cable bend/service access, and undocumented shield behavior are physical facts. Do not invent them from a schematic symbol.

If a source drawing gives an electrical wire number but does not prove connector construction, retain the wire mapping while leaving the connector construction unresolved.

## Physical and human-interface closure

Connection definitions own physical placement constraints that affect whether the board can actually be installed and serviced: board edge/region, PCB side, insertion axis, outward direction, mating/unmating clearance, cable bend, enclosure access, separation from incompatible circuitry, and keepouts.

They also own the field-service legend: connector label, pin/function labels where justified, polarity, pin 1, orientation, shield/chassis marks, warnings, and readable text direction. A correct net hidden behind ambiguous service labeling is not a complete physical interface.

## Worked example — bounded OpenPressBrake Rev1 connector authority

### Files inspected in current form during this lesson run

| File | Lesson readiness | Bounded use |
|---|---|---|
| `hardware/CONNECTION_DEFINITION_CONTRACT.md` | VERIFIED_FOR_LESSON | ownership, required fields, release gates, safety boundary |
| `hardware/connection_definition_schema.yaml` | VERIFIED_FOR_LESSON | machine-readable mold and fail-closed rules |
| `hardware/REV1_CONNECTOR_MAP.yaml` | ENGINEERING_REVIEW_NEEDED as a completed connection-definition set; VERIFIED_FOR_LESSON as the explicitly bounded current electrical pinout authority | shows known electrical pin positions and unresolved physical-machine facts |

The current contract explicitly says `REV1_CONNECTOR_MAP.yaml` remains the electrical pinout authority until deliberate migration into connection definitions. The machine-readable schema likewise reports `SCHEMA_DEFINED_NOT_MIGRATED` and states that exact connector family, footprint, mating hardware, placement/service clearances, harness facts, and other physical details remain unresolved.

That is an excellent teaching example because the correct conclusion is **not** “the connectors are finished.” The correct conclusion is: substantial electrical pinout evidence exists, while the release-consumable physical connection definitions do not yet exist.

### Example: Y1 scale

The current pinout records a nine-position differential-encoder interface with encoder return, protected 5 V, A/A-bar, B/B-bar, Z/Z-bar, and an explicit legacy NC position. It also records chassis/PE shield treatment at the connector region. However, its `mechanical` field is `VERIFY_AT_MACHINE`.

Therefore a student may use the record to practice semantic endpoint tracing, but must not claim exact connector MPN, footprint, mating part, board location, harness fit, or board-capture readiness.

### Example: X-axis drive

The current map demonstrates why semantic ownership matters. The connector contains an analog command, ordinary direction/control signals, switched L7/L07 power-domain contacts, and an external safety-enable path that is explicitly retained outside ordinary board control. A connection definition must preserve those distinctions rather than turning the connector into one generic “drive interface.”

The independent Pilz-to-drive enable remains outside ordinary FPGA/LinuxCNC personnel-safety authority. Monitoring or routing a status does not transfer safety authority to the normal controller.

### Example: proportional-valve return

The current map marks the PVR6 X2 high-current return as `VERIFY_AT_MACHINE_AND_CONFIRM_HARNESS_EXISTS` and provides a fallback requirement if that harness is absent. This is a model fail-closed pattern: do not force a high-current return through a low-current logic/sensor return merely to complete a drawing.

## Lab — build a release-consumable connection definition

Choose a non-safety machine interface from a board other than OpenPressBrake, such as a mill spindle encoder, lathe index encoder, plasma torch-height analog input, router VFD command, robot limit input, or custom-automation sensor.

Produce one board-specific connection definition using the following sequence:

1. state the machine endpoint and evidence source;
2. select a qualified reusable block or explicitly record the missing block requirement;
3. assign semantic endpoints before physical pins;
4. select the connector family using electrical, mechanical, service, and harness constraints;
5. enumerate every physical contact and disposition;
6. map semantic contacts to functional owner/instance/interface;
7. trace all power, return, shield, and chassis paths;
8. map FPGA/logical endpoints where applicable;
9. record placement/orientation/clearance/separation constraints;
10. define field-service silkscreen/legend requirements;
11. record mating/harness destination and compatibility evidence;
12. mark unresolved physical facts `VERIFY_AT_MACHINE` rather than guessing;
13. run the release checklist below.

## Release checklist

A connection definition is board-capture-ready only when all are true:

- every physical contact has exactly one explicit disposition;
- exact connector and footprint are frozen and pad numbering is independently verified;
- voltage/current/wire/derating claims have evidence;
- power, return, shield, and chassis domains are explicit;
- semantic contacts map to functional owners and interfaces;
- FPGA/logical endpoints are mapped where required by the board architecture;
- placement, orientation, access, separation, and keepout requirements are recorded;
- service markings are recorded;
- mating/harness compatibility is known or intentionally changed;
- unresolved machine facts are explicitly identified;
- the connection definition does not duplicate or override reusable-block engineering;
- no ordinary controller connection is represented as independent personnel-safety authority.

A passed connection checklist proves only the connection definition's bounded readiness. It does not prove block qualification, PCB qualification, machine commissioning, or production readiness.

## Catalog stress-test result

The OpenPressBrake architecture already contains the right separation between reusable functional blocks and board-specific connection definitions. The current stress-test defect is **migration/closure**, not a reason to merge those layers: the Rev1 electrical pinout authority has not yet been instantiated into completed connection-definition records, and many physical connector/harness facts are intentionally unresolved.

Do not paper over that gap in teaching. It is a concrete integration action item: instantiate the schema connector-by-connector while preserving `REV1_CONNECTOR_MAP.yaml` authority until each migration is explicitly reconciled. Exact physical facts must come from machine survey/manufacturer evidence.

## Evidence and safety discipline

Classify evidence explicitly: source drawing/manual, manufacturer datasheet/drawing, calculation, simulation, bench test, machine verification, inference, or unknown. A simulator cannot determine installed connector keying or harness condition. An ERC pass cannot establish machine wiring. A correct pin map cannot establish personnel-safety performance.

The ordinary FPGA/LinuxCNC controller may monitor safety state and participate in normal output inhibits, but this lesson grants it no independent personnel-safety authority.

## Checkpoint

BD61 is complete as a curriculum lesson. The next board-design lesson should exercise **connection-definition migration and cross-domain consistency**: migrate one bounded connector instance from electrical pinout authority into the connection-definition mold, then check the result against reusable-block interfaces, FPGA/resource mapping, power/return domains, KiCad connector capture requirements, and harness evidence without inventing unresolved physical facts.
