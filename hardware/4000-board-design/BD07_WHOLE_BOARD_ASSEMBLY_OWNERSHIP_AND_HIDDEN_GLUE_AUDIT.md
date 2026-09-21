# BD07 — Whole-Board Assembly, Ownership, and Hidden-Glue Audit

## Purpose

This board-integration lesson asks a deliberately adversarial question:

> Can independently engineered reusable blocks and board-specific connection definitions actually be assembled into one controller without an engineer supplying unwritten joins?

The target flow is:

`block instances -> connection owners -> whole-board semantic graph -> domain/return/enable ownership -> aggregate resources -> hidden-glue audit -> capture plan -> rendered-net validation -> ERC/human review`

This is not permission to fill gaps by inference. An unresolved edge is a release gate, not an invitation to invent a net.

## Learning outcomes

A student completing BD07 can:

1. distinguish reusable block internals from board-integration edges and physical connection ownership;
2. build a whole-board graph in which every cross-block edge has one explicit owner;
3. detect duplicate connector authority, hidden power/return joins, implicit level translation, unowned enables/inhibits, and resource double counting;
4. keep equal nominal voltages and repeated machine wire labels from becoming accidental electrical joins;
5. aggregate FPGA, bus, power and connector demand without converting unknowns into estimates;
6. define a KiCad hierarchy/capture plan without reconstructing unfinished primitive circuitry;
7. separate repository-side semantic ownership from proof that the rendered schematic/netlist actually implements it; and
8. preserve the boundary between ordinary LinuxCNC/FPGA control and independent personnel-safety authority.

## Hard student-facing artifact audit for this run

The following OpenPressBrake files were opened and inspected in their current `main` form during preparation of this lesson. Their readiness labels apply only to the teaching purpose stated here.

| Artifact | Lesson readiness | What it may prove here | What it may not prove |
|---|---|---|---|
| `hardware/integration/REV1_FIELD_PIN_SEMANTIC_OWNERSHIP.yaml` | `VERIFIED_FOR_LESSON` | single-owner architecture for currently instantiated machine-facing connectors; explicit non-instantiated gates; domain and identity invariants | rendered schematic correctness, connector mechanics, machine facts, primitive internals |
| `hardware/integration/REV1_FIELD_PIN_UNIQUENESS_VALIDATION.md` | `VERIFIED_FOR_LESSON` | fail-closed acceptance semantics for comparing a future generated board against the ownership index | that the comparison has executed or passed |
| `hardware/connections/REV1_CONNECTION_COVERAGE_CHECKPOINT.md` | `VERIFIED_FOR_LESSON` | distinction between substantial electrical endpoint coverage and still-open physical/derating gates | capture readiness or production qualification |
| `hardware/integration/REV1_SCHEMATIC_RELEASE_GATE_MATRIX.md` | `VERIFIED_FOR_LESSON` | owner/evidence/closure-rule model for full-board release gates | closure of gates still marked open or partial |
| `hardware/connections/REV1_POWER_FEED_CONNECTIONS.yaml` | `VERIFIED_FOR_LESSON` as an incomplete board-specific connection example | explicit source/return semantics, functional ownership, placement/marking intent, and fail-closed release fields | exact connector/footprint, ampacity, conductor size, physical placement, or board-capture readiness |

No other OpenPressBrake file is assigned as finished student material by BD07. In particular, this lesson does not ask students to trust per-connector mirrors, manifests, or legacy maps merely because another repository artifact mentions them.

## 1. The assembly graph

Represent the controller as typed nodes and typed edges.

Useful node classes are:

- reusable functional-block instance;
- board-owned shared resource;
- board-specific connection instance;
- FPGA/core logical resource;
- power domain;
- return domain;
- machine endpoint; and
- evidence/release gate.

Every cross-block edge should answer five questions:

1. **Who owns the source semantics?**
2. **Who owns the destination semantics?**
3. **Who owns the board-level join?**
4. **What electrical/domain constraints apply at the join?**
5. **What evidence proves that the rendered implementation matches the intended join?**

If question 3 has no answer, the board has hidden glue. If it has two answers, the board has competing authority.

### Freeze

`EVERY CROSS-BLOCK EDGE HAS EXACTLY ONE BOARD-INTEGRATION OWNER`

This does not mean one file must own both reusable circuits. It means the decision to connect two published interfaces belongs somewhere explicit and singular.

## 2. Connection blocks are not duplicate circuits

A board-specific connection definition binds a physical machine/harness endpoint to semantic board interfaces. It may own connector positions, labels, placement requirements, harness destination and mapping to functional instances. It must not silently become a second implementation of the reusable block.

The inspected OpenPressBrake ownership index demonstrates the desired pattern: currently instantiated machine-facing connector references resolve to selected connection-definition owners, while service connectors are kept outside that machine-field ownership set and an unproven high-current-return endpoint remains explicitly non-instantiated.

The corresponding validation contract adds a critical rule: review mirrors are not alternate schematic-generation authority. A human-readable copy can be useful for review while still being forbidden as a second source of truth.

### Freeze

`REVIEW MIRROR != SECOND ELECTRICAL AUTHORITY`

and

`CONNECTION DEFINITION != REUSABLE PRIMITIVE INTERNAL CIRCUIT`

## 3. Hidden-glue audit

Before schematic capture, inspect the whole-board graph for at least these defect classes.

### 3.1 Duplicate connector ownership

A physical connector reference or position appears under more than one owner, or a review mirror is consumed as if it were canonical.

### 3.2 Hidden power joins

Two rails share a nominal voltage or upstream supply, so the integrator merges them without explicit authority. OpenPressBrake currently requires distinct board identities for core, sensor, proportional-field and switched-I/O power domains.

### 3.3 Hidden return joins

A generic `GND` name hides materially different return duties. A quiet sensor/analog return must not accidentally become a high-current proportional-load path, and the current OpenPressBrake ownership contract explicitly prohibits collapsing its switched return into the machine L06 return.

### 3.4 Unowned enables and inhibits

A block exposes enable/inhibit semantics, but no board artifact owns how the signal is generated, conditioned, powered, defaulted, or routed. Treat the edge as open until that ownership exists.

### 3.5 Implicit level translation or isolation

A logic-level signal crosses domains and the schematic integrator quietly adds a translator, isolator, pull-up, pull-down, or protection network that no block contract owns. That is new electrical design and must be engineered as such.

### 3.6 Resource double counting

Two blocks independently assume the same FPGA pin, ADC channel, SPI chip select, interrupt, rail budget, PLL, connector position, or other singleton resource. Board integration owns allocation and aggregation.

### 3.7 Machine-specific leakage

A reusable primitive acquires a machine wire number, connector family, cabinet location, installed sensor identity, or machine-only source/return assumption merely because one board needs it. Move that information back to machine configuration or the board-specific connection layer.

## 4. Equal labels are not proof of identity

Whole-board integration must distinguish a label from an electrical identity.

The inspected OpenPressBrake ownership and validation artifacts explicitly retain two qualified occurrences of machine wire `111` as different semantic identities. They also forbid collapsing several 24-V board domains simply because their upstream source relationships may be related.

Therefore:

`MATCHING WIRE NUMBER != PROVEN COMMON NET`

`SAME NOMINAL VOLTAGE != SAME BOARD DOMAIN`

A proposed merge requires explicit evidence and an owning integration decision.

## 5. Aggregate resources at the board layer

For every instantiated block, build a resource ledger with at least:

| Resource | Demand source | Allocation owner | Evidence class | Status |
|---|---|---|---|---|
| FPGA pins/bank constraints | block interface + core constraints | board integration | calculated/configured | OPEN/CLOSED |
| LUT/FF/BRAM/PLL/timing | actual implementation | FPGA build evidence | synthesis/P&R | UNKNOWN until measured |
| bus endpoints/chip selects | block interface | board integration | configured | OPEN/CLOSED |
| rail current | block envelope × instances | board power integration | calculation + load evidence | OPEN/CLOSED |
| startup/inrush | relevant blocks/domains | board power integration | calculation/test | OPEN/CLOSED |
| connector contacts | connection definition | connection owner | machine/part evidence | OPEN/CLOSED |
| return-path duty | load + domain contract | board integration | trace/review/test | OPEN/CLOSED |

Do not convert `VERIFY_AT_MACHINE` or `TBD` into a convenient number merely to complete the spreadsheet.

## 6. Capture hierarchy

A useful KiCad hierarchy should preserve engineering ownership rather than erase it. A conceptual hierarchy can contain:

- reusable primitive sheets or generated primitive sections;
- core/shared-resource sections;
- board-owned power/distribution sections;
- board-specific connection sections; and
- explicit top-level integration joins.

The exact hierarchy is project-specific. The important test is whether a reviewer can identify which layer owns every electrical decision.

A renderer may instantiate only exact published topology. It must not choose component values, create missing pull networks, decide return joins, invent connectors, or reinterpret machine facts.

### Freeze

`RENDERER CHOOSES STRUCTURE FROM AUTHORITY; RENDERER DOES NOT DO ELECTRICAL ENGINEERING`

## 7. Semantic ownership is not rendered proof

The current OpenPressBrake field-pin ownership index is repository-side authority, but its inspected validation document explicitly states that rendered-net comparison is still pending. The expected acceptance test is fail-closed: each instantiated connector appears exactly once, every physical position is represented once as a semantic net or explicit unconnected disposition, forbidden joins remain absent, and unexplained generated pins fail the check.

This yields an important maturity ladder:

`SEMANTIC OWNER DEFINED`

`!= CONNECTION ELECTRICALLY DESCRIBED`

`!= CAPTURE READY`

`!= RENDERED NET VERIFIED`

`!= ERC/HUMAN REVIEWED`

`!= PCB/PHYSICAL QUALIFIED`

`!= MACHINE VERIFIED`

`!= PRODUCTION PROVEN`

## 8. Why ERC is late, not magical

The inspected schematic-release matrix correctly keeps ERC unavailable until a complete generated/captured schematic exists. ERC can detect many structural electrical mistakes, but it cannot decide whether an unresolved machine connector exists, whether two returns should be bonded, whether a load envelope is correct, or whether an ordinary FPGA signal has personnel-safety authority.

Run ERC after the design authority is sufficiently complete to render. Then triage every error/warning and perform human schematic review. Passing ERC does not promote unfinished engineering.

## 9. Worked bounded slice: board power-entry connections

The inspected power-feed connection definition is useful precisely because it is honest about its boundary.

It electrically instantiates two board-specific source/return interfaces and records their functional ownership, prohibited joins, placement intent and markings. Yet manufacturer, family, MPN, footprint, pad-number verification, wire range, current/contact derating and several physical facts remain unresolved; both instances explicitly remain `board_capture_ready: false`.

This is a good connection-block example because incompleteness is machine-readable rather than hidden in prose.

Student task: draw only the semantic assembly graph for these two connections. Do **not** select a connector or footprint. Mark every unresolved physical or ampacity fact as a gate. Explain why the two 24-V feeds cannot be merged merely to simplify capture.

## 10. Kitchen-sink review procedure

For a complete controller review, perform this sequence:

1. enumerate block instances without opening their internals to redesign them;
2. enumerate canonical connection owners;
3. enumerate board-owned shared resources and domains;
4. construct all intended cross-block edges;
5. reject every edge with zero or multiple owners;
6. aggregate FPGA/bus/power/connector resources;
7. perform domain/return/enable/inhibit ownership review;
8. search for hidden glue and machine-specific leakage;
9. build the capture hierarchy using only exact available authority;
10. leave unresolved sections explicitly gated rather than guessed;
11. render/generate the board connectivity when authority is sufficient;
12. compare rendered field pins and cross-block joins against semantic ownership;
13. run ERC and human schematic review;
14. preserve open physical, PCB, thermal, EMC, bench and machine-validation gates.

The current OpenPressBrake schematic-release matrix explicitly allows schematic assembly to proceed while release gates remain open. That is useful: integration can expose conflicts early without pretending unfinished blocks are qualified.

## 11. Lab — find the unwritten engineer

Given a board architecture, produce four artifacts:

### A. Ownership graph

For every cross-block edge, record source interface, destination interface, board-level owner, domain, default/de-energized expectation, and evidence source.

### B. Hidden-glue defect ledger

For each unexplained join, classify it as one of:

- missing connection definition;
- missing reusable-block interface;
- missing board shared-resource contract;
- missing translation/isolation/protection block;
- ambiguous power/return identity;
- duplicate authority;
- machine fact requiring verification; or
- stale/superseded authority.

Do not fix the lesson around the defect. Feed the defect back into the catalog/integration architecture.

### C. Resource aggregation table

Aggregate FPGA, bus, power and connector resources. Separate calculated/configured demand from synthesis/test evidence and unknowns.

### D. Release-gate matrix

For each open item identify exactly one owner, evidence required, and closure rule. A gate with no owner is itself a design defect.

## 12. Transfer exercise

Repeat the ownership audit for one non-press-brake controller: mill, lathe, plasma table, router, robot, or custom automation cell.

The machine endpoints change; the method does not. Reusable circuitry should remain reusable, while machine connector/harness identities belong to board-specific connection definitions and machine configuration.

## 13. Safety boundary

Ordinary LinuxCNC/FPGA logic may observe safety status and may participate in watchdog/output-inhibit and STO/enable interfaces. That does not make the ordinary controller the personnel-safety authority.

The inspected OpenPressBrake ownership/validation artifacts explicitly preserve this distinction for the retained safety-enable boundary. BD07 requires the same separation on any other board unless a separately safety-rated design and validation establishes otherwise.

## Catalog stress-test result

The newest OpenPressBrake integration work materially strengthens the catalog architecture by adding a single machine-readable field-pin owner index and an explicit fail-closed rendered-net validation contract. The teaching stress test supports that direction.

The remaining catalog-level weakness is not hidden: semantic ownership exists before rendered-board proof. That is acceptable only because the repository keeps the validation gate open rather than promoting ownership definition into implementation evidence.

No OpenPressBrake engineering file is changed by BD07. Current board-development work is actively advancing this same field-pin uniqueness lane, so the curriculum consumes it read-only rather than racing it.

## Next lesson

BD08 returns to block engineering and should focus on **qualification evidence and verification matrices**:

`requirement -> failure mode -> analytical evidence -> executable test when justified -> bench test -> machine verification -> release status -> regression trigger`

Candidate examples must again be opened in current form before assignment. Prefer a block whose status distinguishes calculation, datasheet evidence, static validation, bench evidence and still-open physical qualification so students learn that passing a script is not equivalent to qualifying hardware.
