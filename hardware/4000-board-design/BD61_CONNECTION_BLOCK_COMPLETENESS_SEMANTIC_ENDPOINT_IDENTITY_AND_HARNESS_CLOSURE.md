# BD61 — Connection-Block Completeness, Semantic Endpoint Identity, and Harness Closure

## Purpose

BD60 closed the release-manifest question at whole-board level. BD61 attacks the board-specific boundary that most easily hides unwritten machine knowledge:

`machine endpoint -> board connection requirement -> connector family/pin -> signal/power/return semantics -> reusable block endpoint -> FPGA/logical endpoint -> physical placement/silkscreen -> harness destination -> verification -> release-consumable connection contract`

The governing rule is:

**A REUSABLE BLOCK CONTRACT DOES NOT DEFINE A BOARD CONNECTION.**

A reusable block owns its generic electrical function and reusable interface. A board-specific connection block/mold owns how one board exposes that function to a particular harness or machine endpoint. If a technician, schematic generator, FPGA/HAL mapper, PCB designer, or commissioning procedure still needs undocumented tribal knowledge to identify the endpoint, the connection contract is incomplete.

## Student-material readiness audit

Every repository file named below was opened and inspected in its CURRENT form during this run before use.

**VERIFIED_FOR_LESSON** for the bounded claims used:

- Curriculum `README.md` — evidence, provenance, uncertainty, experiments, and safety boundary.
- Curriculum `WORK_SELECTION_POLICY.md` — autonomous work selection and evidence-gain rules.
- Curriculum `hardware/4000-board-design/BD60_RELEASE_MANIFEST_CLOSURE_CANDIDATE_COMPLETENESS_AND_CROSS_DOMAIN_PROMOTION_GATES.md` — whole-board release-claim closure model.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — board-design lane authority through BD60.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthful status, integration-versus-qualification distinction, primitive/shared-resource ownership, and maintenance rules.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — mandatory reusable-block/adapter/board-integration ownership boundary.
- OpenPressBrake `hardware/blocks/differential_encoder/manifest.yaml` — current reusable encoder electrical/interface contract.
- OpenPressBrake `hardware/blocks/differential_encoder/integration/REV1_RESOURCE_CONTRACT.yaml` — current board-resource handoff including GPIO, LiteX-CNC function instance, power, termination, machine-fact, and remaining-release obligations.
- OpenPressBrake `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` — current bounded status and explicit board/machine integration gates.

The encoder material is **not** presented as production-proven. Its current status is SIMULATION-READY with important integration and release gates open.

## Learning objectives

A student must be able to:

1. keep reusable electrical-block definitions separate from board-specific connection blocks;
2. give every physical and logical endpoint a stable semantic identity;
3. define connector family, pin, signal direction/class, power, return, shield/chassis, and optional population semantics without guessing;
4. map a field endpoint through reusable block, FPGA resource, firmware function, and LinuxCNC/HAL meaning;
5. define physical placement, reference designator, user-visible label/silkscreen, mating orientation, and harness destination;
6. preserve unresolved physical facts as `VERIFY_AT_MACHINE` rather than inventing a complete-looking connector;
7. distinguish a board mapping from a real electrical adapter/translation function;
8. prove that generated schematic, PCB, FPGA/HAL configuration, harness documentation, and commissioning records consume the same connection identity; and
9. reject a release candidate whose connection requires unwritten knowledge.

## 1. The connection block is a board-specific mold

A reusable primitive should remain usable when the machine name and connector number are erased. The connection block should not.

For example, a reusable differential encoder receiver may legitimately own:

- A/Abar, B/Bbar, Z/Zbar electrical input classes;
- A_logic, B_logic, Z_logic conditioned outputs;
- receiver supply requirements;
- protection and termination options;
- generic FPGA resource demand; and
- generic timing/qualification constraints.

The board-specific connection mold owns facts such as:

- this instance is `X_AXIS_ENCODER`;
- it appears at connector `Jxx`;
- exact connector manufacturer/family/keying and mating part;
- exact pin numbers for A/Abar/B/Bbar/Z/Zbar, field power, return, shield, spare/DNP pins;
- connector voltage/current/contact constraints;
- FPGA semantic resource identity for A/B/Z;
- board edge/location/orientation;
- silkscreen/user label;
- harness destination and machine-side endpoint;
- selected termination population for this installation; and
- machine-specific field-power source/protection when the board supplies it.

Do not push those facts into the generic receiver merely to make the board easier to describe.

## 2. Minimum release-consumable connection contract

A connection contract should contain at least these fields or explicit equivalents.

### Identity and ownership

- `connection_id` — stable board-specific semantic ID;
- `board_variant` / applicability;
- `machine_function_id` — semantic machine endpoint, not only a connector reference;
- `reusable_block_id` and instance ID;
- contract revision and authority/provenance lock;
- readiness/closure state.

### Physical connector definition

- connector manufacturer, family/series, exact part number, keying and gender where applicable;
- PCB footprint and orientation rule;
- mating connector/contact identity when required for release;
- pin count and exact pin numbering authority;
- voltage/current/contact/temperature/environment constraints relevant to the use;
- board reference designator;
- physical board edge/zone/location and access/orientation constraints;
- user-visible label/silkscreen text.

If those physical facts are not yet established, keep them explicit `TBD`/`VERIFY_AT_MACHINE`. A placeholder connector is not release closure.

### Pin semantics

For every pin, record:

- pin number;
- semantic signal ID and displayed label;
- direction from the board perspective;
- electrical class and nominal/allowed voltage;
- expected current or current-limit ownership where relevant;
- source/sink/open-drain/differential/contact semantics where relevant;
- associated return/reference;
- shield/chassis treatment;
- default/de-energized behavior for outputs and enables;
- protection owner;
- reusable-block endpoint or board-owned resource consumed;
- optional/DNP/spare status with a prohibition against accidental reuse when necessary.

A signal without its return/reference is not a complete electrical connection.

### Logical/resource binding

Where the endpoint reaches programmable logic, record:

- stable FPGA semantic resource ID;
- package pin/bank/electrical-standard authority;
- logical function instance (encoder, stepgen, GPIO, SPI peripheral, PWM, etc.);
- firmware/gateware semantic binding;
- LinuxCNC/HAL semantic owner or `TBD_FROM_GENERATED_RUNTIME` until generated/runtime evidence exists;
- watchdog/freshness/inhibit dependency where applicable.

Counting GPIO alone is insufficient when a function also consumes FPGA logic resources.

### Harness and machine destination

Record:

- harness ID or `VERIFY_AT_MACHINE`;
- cable type/pairing/shield assumptions;
- wire/pair identifiers if known;
- machine-side connector/device destination;
- machine-side pin/terminal identity if verified;
- routing/environment constraints that affect electrical acceptance;
- service/disconnect expectations;
- any field power source and return path.

The board contract must distinguish **board truth** from **installed-machine truth**. Unknown machine wiring stays unknown.

## 3. Semantic endpoint identity must survive every representation

A releaseable design should allow the same endpoint to be traced without name guessing:

`MACHINE.X_ENCODER.A -> CONN.X_ENC.PIN_A -> BLOCK.ENCODER[2].A -> BLOCK.ENCODER[2].A_logic -> FPGA.ENCODER[2].A -> FW.ENCODER[2].A -> LINUXCNC semantic feedback`

The exact syntax is project-specific. The requirement is stable identity and declared transformations.

Aliases are permitted only when the mapping is explicit. A schematic net called `ENC3_A`, a gateware resource called `encoder_2_a`, and a HAL pin with a generated name may represent the same semantic endpoint, but the release graph must prove that relationship rather than relying on human pattern recognition.

## 4. Worked OpenPressBrake stress test — differential encoder

The current reusable encoder manifest is deliberately generic. One primitive receives one A/Abar, B/Bbar, Z/Zbar encoder and emits three 3.3-V logic signals. Physical connector family, mating contacts, harness adaptation, optional encoder field supply, and termination selection remain integration responsibilities.

The current Rev1 resource contract strengthens that handoff. Per primitive it requires:

- three FPGA inputs: A_logic, B_logic, Z_logic;
- one LiteX-CNC encoder function instance;
- 17 mA maximum `LOGIC_3V3` source-capacity allocation;
- connector-edge transient protection returned to `CHASSIS_PE`;
- board-owned physical connector/pin mapping;
- board-owned optional encoder field power if the installed encoder requires it; and
- termination population chosen from verified line topology.

It explicitly refuses to invent LUT/register counts, encoder field voltage/current/startup demand, cable topology, termination state, return arrangement, or existing machine protection.

That is good reusable-block behavior. It is also proof that the resource contract alone is **not** a complete connection block.

### 4.1 What remains to close a board connection

For an installed encoder instance, board integration still needs evidence for at least:

- exact connector family/part/keying and footprint;
- exact A/Abar/B/Bbar/Z/Zbar/power/return/shield pin map;
- physical connector location/orientation and silkscreen;
- machine harness/device destination;
- installed encoder electrical output class;
- cable topology/impedance/termination facts;
- whether the controller supplies encoder field power;
- field voltage/current/startup and protection if supplied;
- return-conductor arrangement; and
- selected terminated versus unterminated assembly variant.

The status checklist independently confirms that termination selection, protected encoder field-supply implementation, cable/reflection qualification, PCB integration, and release gates remain open. Therefore a student must not present an inferred X/Y encoder connector as a finished example merely because A/B/Z logic allocation exists.

### 4.2 FPGA function resources are part of connection closure

Current engineering now records one LiteX-CNC encoder function instance per populated receiver primitive. This matters because a connection contract that maps only three physical FPGA inputs is semantically incomplete: the board also needs a consuming quadrature/index function and must ultimately prove aggregate FPGA fit.

The connection contract should therefore reference both physical I/O allocation and logical-function allocation. Target LUT/register counts remain unresolved until authoritative accounting or target synthesis exists; BD61 does not fabricate them.

## 5. Connection versus adapter decision

Apply `BLOCK_ADAPTER_INTEGRATION_RULES.md` before adding circuitry.

If the field connector merely maps already-compatible encoder pairs to the reusable receiver, that is board integration.

If the selected machine sensor is electrically incompatible and needs level translation, isolation, protocol conversion, analog conditioning, or another meaningful transformation, the answer is not to hide circuitry in the connector mold. Search for a qualified reusable adapter. If none exists, open a real adapter-block engineering task.

**A CONNECTION BLOCK MAY MAP; IT MUST NOT SECRETLY TRANSFORM.**

## 6. Default, enable, return, and partial-power closure

Connection reviews frequently document active signal pins and omit the paths that determine failure behavior. For every connection ask:

- What return/reference completes this signal or load path?
- What happens when field power exists but logic power does not?
- What happens when logic exists but field power does not?
- Is any external pin capable of back-powering an unpowered domain?
- For an output, what physical mechanism establishes the de-energized/default state?
- For an enable, what bias establishes the inactive state before FPGA configuration?
- Does shield/chassis current have a deliberate path distinct from signal return?
- Can a connector pin expose stored energy after command removal?

If the reusable block owns the answer, reference its contract. If the board/harness owns it, the connection contract must state it. If neither owns it, record a closure defect.

## 7. Machine-readable connection schema

A useful minimum machine-readable shape is:

```yaml
connection_id: CONN.X_ENCODER
board_variant: REV1
machine_function: X_AXIS_ENCODER
block_instance: differential_encoder.2
connector:
  mpn: VERIFY_AT_MACHINE
  footprint: TBD
  location: TBD
  silkscreen: X ENC
pins:
  - pin: TBD
    semantic_id: MACHINE.X_ENCODER.A
    block_endpoint: A
    electrical_class: differential_rs422_like_input
    return_reference: paired_with_Abar
  - pin: TBD
    semantic_id: MACHINE.X_ENCODER.ABAR
    block_endpoint: Abar
    electrical_class: differential_rs422_like_input
fpga_binding:
  function_instance: encoder.2
  signals: [A_logic, B_logic, Z_logic]
harness:
  destination: VERIFY_AT_MACHINE
termination_variant: VERIFY_AT_MACHINE
field_power:
  supplied_by_controller: VERIFY_AT_MACHINE
closure_state: BLOCKED_UNKNOWN
```

This example intentionally remains blocked. It demonstrates truthful schema shape without inventing OpenPressBrake connector facts.

## 8. Cross-artifact consistency gates

Before a connection becomes release-consumable, check that:

1. schematic connector symbol pin numbers match the connection contract;
2. footprint pad numbers and orientation match the symbol/connector datasheet;
3. PCB placement satisfies the declared edge/location/access constraints;
4. silkscreen/user label identifies the intended endpoint without ambiguity;
5. power and return pins connect to the declared domains;
6. reusable-block endpoints and assembly variant match the selected contract;
7. FPGA package allocation and logical function allocation match the same semantic endpoint;
8. generated/runtime LinuxCNC/HAL mapping references the same semantic function;
9. harness documentation agrees with board pinout and machine destination;
10. commissioning tests stimulate/observe the same endpoint; and
11. all `VERIFY_AT_MACHINE` facts required by the release claim have evidence.

A mismatch is `CROSS_DOMAIN_CONFLICT` or `STALE_CONSUMER`, not a cosmetic documentation issue.

## 9. Lab — build and attack a connection contract

Given one reusable I/O block and a machine I/O requirement:

1. identify the reusable block contract without modifying it;
2. define a board-specific `connection_id` and machine semantic endpoint;
3. create the connector/pin/power/return/shield table;
4. bind block endpoints and FPGA/logical resources;
5. add physical location, orientation, and silkscreen requirements;
6. add harness destination and machine-side evidence fields;
7. mark every unsupported physical fact `VERIFY_AT_MACHINE`/`TBD`;
8. classify any required transformation as direct integration, block defect, adapter required, board mapping, or unresolved;
9. perform the cross-artifact consistency gates; and
10. produce a release disposition.

Adversarially remove the designer's explanatory notes. If another engineer cannot reconstruct the intended connection from the contract and cited authorities alone, the contract fails.

## 10. Catalog stress-test result

The current OpenPressBrake differential-encoder artifacts demonstrate strong reusable electrical and resource contracts, including explicit machine-fact unknowns and the newly explicit one-to-one LiteX-CNC encoder-function allocation. They also expose the next catalog/integration requirement: a first-class machine-readable **board connection contract** that joins stable machine endpoint IDs to connector/pin/physical placement/silkscreen, reusable block endpoints, power/return/shield ownership, FPGA physical and logical resources, harness destination, assembly variant, commissioning evidence, and unresolved physical facts.

This is not a defect in the generic encoder primitive. It is a board-integration infrastructure gap. Do not solve it by contaminating the reusable encoder with OpenPressBrake-specific connector names or machine harness assumptions.

## 11. Safety boundary

Encoder feedback, FPGA decoding, LinuxCNC/HAL mapping, connector correctness, ordinary watchdogs, and commissioning diagnostics are ordinary process-control functions here. They receive zero personnel-safety credit.

A correct connection contract may document a status interface to an independent safety system, but it does not become the independent personnel-safety authority by being complete.

## 12. Completion criteria

A student passes BD61 when they can produce and defend a connection contract that:

- is board-specific without contaminating the reusable block;
- contains no invented machine facts;
- identifies every pin, return/reference, power path, shield/chassis path, default/enable dependency, logical resource, physical placement/label, and harness destination needed by its release scope;
- distinguishes mapping from real adapter circuitry;
- is machine-readable enough for schematic/PCB/FPGA/HAL/harness/commissioning consumers;
- exposes unresolved facts as fail-closed release gates; and
- preserves the independent personnel-safety boundary.

## Durable next work

BD62 should develop **connection-contract aggregation, connector-panel allocation, and collision checking**:

`qualified connection contracts -> connector population/placement plan -> pin/contact/current aggregation -> shared field-power/return/shield resources -> FPGA/function bindings -> mechanical/label/access collisions -> harness-service review -> machine-readable board connector manifest -> whole-board consistency gate`

Use a current OpenPressBrake example only after reopening every student-facing artifact. Treat connector-family selection, mating hardware, installed harness facts, and physical machine dimensions as evidence-bearing facts rather than convenient assumptions.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable verification was required to answer BD61's connection-ownership question. No GitHub-hosted compute was used. Future target synthesis/resource checks, when justified, must use `[self-hosted, openpressbrake]` only.
