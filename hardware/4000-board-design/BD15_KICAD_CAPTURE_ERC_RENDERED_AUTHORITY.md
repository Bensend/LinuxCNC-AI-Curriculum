# BD15 — KiCad Capture Hierarchy, ERC, and Rendered-Authority Validation

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BOARD INTEGRATION  
**Design-flow position:** qualified block connectivity -> board integration -> schematic capture -> ERC -> rendered validation -> release evidence

## Purpose

A schematic is not the engineering authority merely because it is visible, generated, or accepted by ERC. BD15 teaches how already-engineered reusable blocks and board-specific connection ownership become a reviewable KiCad schematic without allowing the capture process or renderer to make electrical decisions.

The working chain is:

`engineering authority -> reusable block sheet/instance -> board integration/shared resources -> board-specific connection binding -> hierarchical/global/local net ownership -> symbol/footprint authority -> generated/rendered schematic -> ERC -> visual review -> rendered-net validation -> release evidence`

The core rule is:

**THE RENDERER CHOOSES REPRESENTATION FROM AUTHORITY; IT DOES NOT CHOOSE ELECTRICAL ENGINEERING.**

## Learning outcomes

By the end of BD15, the student can:

1. distinguish semantic interfaces from exact component-pin connectivity;
2. separate reusable-block internal connectivity from board-specific connection ownership;
3. define a schematic hierarchy without duplicating electrical authority;
4. decide which nets may be local, hierarchical, or board-global and document that choice;
5. bind symbols, pins, values and footprints to exact engineering/BOM authority;
6. explain what KiCad ERC can prove and what it cannot;
7. validate rendered connectivity against machine-readable authority rather than trusting appearance;
8. identify stale or conflicting source authorities before capture;
9. keep unresolved machine/connector facts fail-closed instead of inventing them during capture;
10. preserve personnel-safety boundaries while ordinary-control signals are represented on the same board schematic.

## Student-facing source audit

The following current OpenPressBrake `main` artifacts were opened directly during preparation and are `VERIFIED_FOR_LESSON` only for the bounded claims below:

- `hardware/blocks/differential_encoder/design/REV1_PRODUCTION_CONNECTIVITY.md` — exact one-encoder primitive topology and assembly-variant ownership.
- `hardware/blocks/differential_encoder/STATUS_CHECKLIST.md` — explicit readiness boundary: production connectivity exists, but auto-rendered schematic visual review, PCB integration, cable/termination selection, protected field power and release remain open.
- `hardware/rev1_schematic/NETLIST_CONTRACT.yaml` — inter-sheet semantic board-resource contract, including explicit rules that block-internal nets remain block-owned and several stale/superseded semantic entries must not be rendered as current design.
- `hardware/integration/REV1_BOARD_INTEGRATION_RECONCILIATION.yaml` — precedence/quarantine authority preventing stale core/comms, ADC, proportional and X-axis assumptions from re-entering capture.

These files are **not** presented as proof that the complete OpenPressBrake schematic is released. In particular, the current encoder status explicitly leaves visual schematic review and board release open.

The complete OpenPressBrake controller remains an engineering work in progress and is not production-proven.

## 1. Capture is a compilation step

Treat schematic capture as compilation from engineering authority, not as the place where missing engineering is casually completed.

Before a symbol or net is instantiated, ask:

- Which artifact owns the circuit topology?
- Which artifact owns the component identity/value?
- Which artifact owns the board instance count?
- Which artifact owns the connection/J-number and machine destination?
- Which artifact owns the rail/return/domain relationship?
- Which artifact owns FPGA or logical mapping?
- Which facts are still `TBD` or `VERIFY_AT_MACHINE`?
- Which older files are explicitly superseded?

If the answer is “the person drawing the schematic will decide,” capture authority is incomplete.

**SCHEMATIC CAPTURE MUST CONSUME ENGINEERING DECISIONS, NOT HIDE THEIR ABSENCE.**

## 2. Reusable sheet versus board-specific connection

A reusable functional sheet may own the internal circuitry of one primitive instance: devices, support parts, protection intrinsic to the primitive, local decoupling, internal nets, variant-populated parts, and semantic external ports.

It must not silently absorb:

- machine connector reference designators;
- machine wire numbers;
- machine-specific labels;
- board placement;
- machine harness destination;
- a board-specific connector MPN unless the functional block truly owns that physical interface by contract;
- unrelated shared board power/protection resources.

The board connection layer binds the primitive's semantic ports to a particular machine-facing connection instance.

For the inspected encoder example, the reusable primitive is one A/Abar, B/Bbar, Z/Zbar receiver. Its exact receiver/protection/termination topology is block-owned. The optional encoder supply is explicitly a shared board resource rather than hidden inside the primitive.

## 3. Semantic interface is not exact pin connectivity

A semantic port such as `ENC1_A` says what a signal means at an integration boundary. It does not, by itself, prove which AM26LV32 pin, protection device pin, resistor pad, FPGA ball, connector pin or return path implements it.

Capture requires a complete lowering path:

`semantic interface -> exact block pin/net connectivity -> board instance binding -> physical symbol pins -> board net -> connection pin`

If any step relies on unwritten knowledge, record a catalog/integration defect. Do not fill the gap from memory.

**SEMANTIC CONTRACT != EXACT PIN CONNECTIVITY.**

## 4. Hierarchy is representation, not ownership

A useful KiCad hierarchy often separates:

- reusable functional blocks;
- shared power and reference resources;
- FPGA/core/comms resources;
- machine-facing connections;
- board-level enable/watchdog logic;
- board integration glue that has explicit authority.

But a sheet boundary does not create electrical ownership. Conversely, two functions placed on one sheet do not become one reusable block.

The hierarchy may change for readability while engineering ownership remains stable. Preserve stable semantic interfaces so representation can evolve without melding blocks.

## 5. Local, hierarchical, and global nets

Choose net scope intentionally.

Use local/internal nets for block implementation details that must not escape the primitive. Use hierarchical ports for explicit block-to-board contracts. Use board-global labels only when the design authority actually defines a board-global electrical identity.

A global label is dangerous when it silently collapses distinct domains. OpenPressBrake's current authority explicitly requires L9, L6, L7 and L07 to remain distinct and separately forbids convenience joins such as L07 to L06. A renderer must preserve those distinctions.

Likewise, matching printed wire numbers are not sufficient proof of common electrical identity where the integration authority explicitly distinguishes them.

**SAME TEXT LABEL != PROVEN COMMON NET.**

## 6. Symbol, pin, value, and footprint authority

For every captured component, prove:

1. exact electrical part/value authority;
2. symbol pin numbering against the manufacturer package;
3. power/enable/unused pins and their required states;
4. footprint identity when physically selected;
5. footprint pad numbering against the exact package drawing;
6. population/DNP variant behavior;
7. reference designator uniqueness and stable instance identity.

A correct-looking symbol can still be electrically wrong if its pin numbering is wrong. A correct symbol does not prove the footprint. A verified footprint does not prove the board-specific connector/harness.

Where a physical connector remains `VERIFY_AT_MACHINE`, do not invent its MPN/footprint merely to eliminate a KiCad warning or complete a drawing.

## 7. Authority precedence must be resolved before rendering

The current OpenPressBrake board-integration reconciliation is a useful adversarial example because it explicitly quarantines stale fields from an older monolithic board-integration artifact. Current capture must reject retired KSZ8081/RMII core-comms assumptions, retired proportional-current ADC ownership, stale per-channel proportional command resources, and an unsupported direct negative-voltage assumption at Commander SK T4.

This demonstrates a critical rule:

**OLDER COMPLETE-LOOKING AUTHORITY DOES NOT OUTRANK NEWER POINT AUTHORITY.**

A capture pipeline should fail when two active sources disagree unless an explicit precedence/reconciliation record resolves the conflict. “Use whichever file is easiest to parse” is not acceptable.

## 8. Generated schematic versus verified schematic

Generation may save time and improve consistency, but generated output has at least three distinct states:

- `GENERATED` — a tool emitted schematic structure;
- `ERC_CLEAN_OR_REVIEWED` — KiCad electrical-rule checks were executed and dispositions recorded;
- `VERIFIED_RENDER` — a human and/or deterministic validator proved the rendered connectivity matches current engineering authority.

None of those alone means production release.

**GENERATED SCHEMATIC != VERIFIED SCHEMATIC != RELEASED BOARD.**

## 9. What ERC can prove

ERC is useful for questions encoded in the CAD model and its electrical pin types/rules, such as:

- unconnected required pins;
- incompatible driver/power pin relationships;
- some multiple-driver conflicts;
- missing power-driver declarations;
- explicit no-connect inconsistencies;
- rule violations represented in the schematic model.

ERC cannot determine that:

- the chosen topology is correct for the machine;
- a semantic net was mapped to the intended connector contact;
- a stale authority file was consumed;
- an industrial transient path is physically adequate;
- a connector is the actual installed machine mate;
- PCB copper/return geometry is acceptable;
- a field-power budget is correct;
- a LinuxCNC/HAL mapping is correct;
- an ordinary-control inhibit is safety-rated.

Therefore:

**ERC PASS != ENGINEERING CORRECTNESS.**

ERC warnings should be fixed or explicitly dispositioned; they should not be globally suppressed to make a release dashboard green.

## 10. Rendered-net validation

After capture/generation, extract the rendered schematic/netlist and compare it against authority.

A fail-closed validator should check, where authority exists:

- required component instances appear exactly once;
- exact component pins land on expected nets;
- mandatory enable/default-state pins are present;
- DNP/populated variants match the selected assembly profile;
- each field connector/contact has exactly one authorized disposition;
- forbidden joins are absent;
- expected shared nets are present;
- no unexplained generated pin/net appears;
- obsolete/superseded components or nets are absent;
- block-instance count matches board allocation;
- board-specific connection ownership is unique;
- personnel-safety authority is not accidentally represented as FPGA/LinuxCNC ownership.

Do not make the validator “helpful” by normalizing an unexplained discrepancy into the expected result. Unknown output should fail review.

## 11. Visual review remains mandatory

Machine-readable comparison catches many errors but does not replace human schematic review. Review the rendered sheets for:

- readable signal flow;
- visible power/return context;
- understandable hierarchy;
- correct connector orientation/pin presentation;
- support components visibly associated with their function;
- no hidden global-net surprises;
- explicit DNP/variant notes;
- safety-boundary notes where ordinary control interfaces with independent safety status;
- no misleading sheet titles or labels that imply unearned qualification.

The inspected encoder status currently leaves “Auto-rendered schematic visually reviewed against intended circuit” unchecked. That is a real release gate, not paperwork to bypass.

## 12. Schematic connectivity versus PCB current path

A schematic may correctly show two points on one electrical net while the PCB still routes load current through a sensitive reference path. Conversely, artificially splitting one electrical net in the schematic to force routing can create unnecessary grounding complexity.

Capture must preserve electrical identity; PCB constraints must separately preserve current-path, return, placement, transient-diversion and noise-control requirements.

**CORRECT SCHEMATIC NET != QUALIFIED PCB CURRENT PATH.**

For the encoder primitive, connector-edge transient diversion to `CHASSIS_PE` and keeping chassis/shield current out of FPGA logic ground are physical/layout requirements in addition to schematic connectivity.

## 13. Bounded OpenPressBrake worked example — encoder primitive

Use only the following bounded facts from the inspected current artifacts:

- one reusable primitive handles one differential incremental encoder;
- A/B/Z use AM26LV32 receiver channels 1/2/3;
- channel 4 is unused;
- receiver enables are hard-set to enabled from the 3.3-V/GND logic domain;
- one low-capacitance protection device is assigned per differential pair with transient return to `CHASSIS_PE`;
- 120-ohm termination footprints define populated and DNP assembly variants;
- local 100-nF receiver decoupling is frozen;
- the optional encoder supply remains a shared board resource;
- current board integration carries explicit encoder semantic nets and connector bindings;
- machine termination selection, protected encoder field power, abnormal-condition qualification, rendered schematic visual review, PCB integration and final release remain open.

This is enough to teach lowering one qualified primitive toward capture. It is not enough to claim the complete board is schematic-ready.

### Student exercise

Construct a capture-authority table for one encoder instance with columns:

`rendered object | semantic purpose | owning authority | exact pin/net evidence | board-specific binding | unresolved fact | release consequence`

Then mark each row `VERIFIED_FOR_LESSON`, `ENGINEERING_REVIEW_NEEDED`, `INCOMPLETE_NOT_STUDENT_MATERIAL`, or `DEPRECATED_OR_SUPERSEDED`.

Do not fill unresolved connector-family or machine-termination facts from assumption.

## 14. Adversarial capture review

Challenge a proposed schematic with these faults:

1. a renderer consumes stale RMII authority because it is in an older complete board file;
2. L07 is globally renamed to L06 to reduce net labels;
3. the encoder termination variant is populated without machine cable evidence;
4. a library connector footprint is assigned while the exact machine connector remains unknown;
5. ERC passes after an expected connector signal is mapped to the wrong contact;
6. a transient protection return is tied to logic ground because both symbols need a ground-looking label;
7. an unused receiver channel is left with undocumented input disposition;
8. a generated schematic has never been visually reviewed;
9. a validator ignores an extra generated pin because it does not appear in its expected list;
10. a Pilz-derived permission signal is labeled in a way that implies the FPGA is the personnel-safety authority.

For each fault identify whether the correct response is authority reconciliation, capture correction, ERC disposition, rendered-net validation, machine verification, PCB/layout review, or safety-boundary correction.

## 15. Release evidence packet

A capture-stage evidence packet should include:

- exact source-authority revisions;
- selected block/assembly variants;
- connection-instance revisions;
- generated/captured schematic revision;
- symbol/footprint library revisions or pinned identities;
- ERC report and explicit dispositions;
- rendered-net validation result;
- visual-review record;
- unresolved-gate ledger;
- change/regression triggers.

A later source-authority change must invalidate the relevant rendered evidence. Do not retain an old ERC/rendered-net pass merely because the `.kicad_sch` file itself was not manually edited.

## 16. Catalog stress-test findings

BD15 exposes four useful catalog requirements:

1. exact primitive connectivity must be machine-readable enough that a renderer/validator does not depend on prose interpretation;
2. board integration needs explicit precedence when older broad authority and newer point authority overlap;
3. every generated field contact needs one authorized disposition and unexplained rendered objects must fail closed;
4. capture/release evidence should record source revisions so upstream changes can invalidate stale schematic evidence automatically.

OpenPressBrake already contains meaningful pieces of this architecture, but the inspected encoder status proves the rendered visual-review/release chain is not complete. Therefore this curriculum run does not patch the active OpenPressBrake capture lane or claim whole-board schematic release.

## 17. Safety boundary

Ordinary controller schematics may show monitoring of independent safety status and ordinary hardware inhibits. That does not transfer personnel-safety authority into LinuxCNC, FPGA logic, ERC, or the board renderer. Keep the retained independent safety path visibly distinct and do not assign safety credit without a separately justified safety-rated design and validation.

## Durable freezes

- `RENDERER REPRESENTS AUTHORITY; RENDERER DOES NOT INVENT ENGINEERING`.
- `SEMANTIC CONTRACT != EXACT PIN CONNECTIVITY`.
- `HIERARCHY != OWNERSHIP`.
- `SAME TEXT LABEL != PROVEN COMMON NET`.
- `OLDER COMPLETE-LOOKING AUTHORITY != CURRENT AUTHORITY`.
- `GENERATED SCHEMATIC != VERIFIED SCHEMATIC != RELEASED BOARD`.
- `ERC PASS != ENGINEERING CORRECTNESS`.
- `CORRECT SCHEMATIC NET != QUALIFIED PCB CURRENT PATH`.
- `UNKNOWN CONNECTOR/FOOTPRINT != PERMISSION TO INVENT ONE`.
- `ORDINARY CONTROL REPRESENTATION != PERSONNEL-SAFETY AUTHORITY`.

## Readiness result

The inspected OpenPressBrake encoder production-connectivity, encoder status, board netlist contract and integration reconciliation are `VERIFIED_FOR_LESSON` for the bounded ownership, precedence, exact primitive-connectivity and incomplete-release claims made here.

They are `INCOMPLETE_NOT_STUDENT_MATERIAL` if presented as proof of a released complete OpenPressBrake schematic. The current encoder checklist itself explicitly leaves rendered schematic visual review and final board release open.

## Next lesson

**BD16 — FPGA/resource aggregation and executable fit evidence.** Build the whole-board resource ledger from block contracts and board instances, then distinguish arithmetic allocation from synthesis/place-and-route/timing evidence. Any executable fit/timing work must run only on `[self-hosted, openpressbrake]`; if that runner cannot be dispatched from the curriculum lane, continue source/evidence review and record the blocker rather than using hosted compute.