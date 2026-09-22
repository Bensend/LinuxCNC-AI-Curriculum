# BD21 — Adapter/Interface Block Selection and Qualification During Board Composition

## Purpose

This lesson stress-tests board composition at the exact place where reusable architectures most often decay into one-off glue: the boundary between two individually reasonable interfaces.

The learner must preserve two independent skills at once:

1. **block engineering** — publish a stable, evidence-backed generic interface contract; and
2. **board integration** — compose compatible contracts without silently modifying either block or hiding transformation circuitry in board-specific wiring.

The OpenPressBrake controller is the worked architectural example, but the method applies equally to mills, lathes, plasma tables, routers, robots, press brakes, and custom automation.

## Student-material verification status for this run

The following current OpenPressBrake files were opened and inspected before this lesson was written:

- `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for block/adapter/integration ownership and classification rules.
- `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for reusable-block qualification/status semantics.

These readiness labels are claim-scoped. They do not establish that the complete OpenPressBrake board is production-proven or Rev-1 released.

No other OpenPressBrake repository artifact is assigned as finished student material in this lesson. Current active board engineering is intentionally consumed read-only.

---

## 1. The composition problem

A schematic can be electrically wrong even when every selected block is individually well designed.

Suppose Block A publishes an output and Block B publishes an input. The fact that both sides call the signal `ENABLE`, `POSITION`, `FAULT`, `SPI`, `24V`, or `ANALOG` does not establish compatibility. Integration must compare the contracts, not the names.

Freeze:

> **SAME SIGNAL NAME != COMPATIBLE INTERFACE CONTRACT**

Before connecting two block boundaries, compare at least:

- direction and drive authority;
- voltage/current operating range and absolute limits;
- source and sink behavior;
- logic thresholds or analog transfer range;
- source impedance and load impedance;
- reference/return domain;
- isolation assumptions;
- common-mode range;
- startup, reset, unpowered and partial-power behavior;
- default/de-energized state;
- timing, bandwidth, update rate and protocol semantics;
- fault/transient/protection expectations;
- whether either side can back-power the other;
- connector/cable effects when those are part of the electrical envelope;
- whether the signal carries ordinary-control information or participates in an independently validated safety architecture.

If a required fact is unknown, compatibility is not established.

---

## 2. Mandatory five-way classification

For every proposed boundary, classify it before drawing glue circuitry.

### `DIRECT_INTEGRATION`

Use when the published contracts already match electrically and semantically. Board integration may connect the interfaces and perform ordinary board mapping.

Examples:

- a 3.3-V push-pull FPGA output to a block input explicitly qualified for that logic family and domain;
- a block's declared power input connected to the compatible board rail/return it requests;
- a qualified SPI peripheral connected to a compatible controller SPI resource within the published timing/electrical envelope.

No adapter is created merely to make the drawing look modular.

### `BLOCK_CONTRACT_DEFECT`

Use when one reusable block cannot be safely or deterministically integrated because its generic contract is wrong, contradictory, or missing information intrinsic to that block.

Examples:

- an output block does not state what happens while its logic rail is absent but field power remains;
- an analog input claims a voltage range but omits the required source-impedance envelope needed to meet settling accuracy;
- a digital interface omits its input thresholds or output drive type.

Do not patch the missing generic fact in the board notes. Return the defect to the block owner, revise the generic contract on engineering grounds, and requalify affected claims.

### `ADAPTER_REQUIRED`

Use when both neighboring contracts are legitimate but incompatible and a real electrical transformation is required.

Examples include:

- level translation;
- galvanic isolation;
- differential/single-ended conversion;
- current/voltage conversion;
- analog scaling or buffering;
- protocol/physical-layer conversion;
- reusable conditioning or protection required specifically between two interface classes.

An adapter is a real reusable block, not a synonym for glue.

### `BOARD_INTEGRATION_MAPPING`

Use when no electrical transformation is required and the work is only board-specific composition.

Examples:

- assigning an FPGA pin/resource to a compatible block input;
- selecting which block instance reaches connector J4;
- pin-number mapping;
- connector location/orientation;
- silkscreen/service labels;
- harness destination;
- net naming;
- instance count and population choice.

Freeze:

> **DO NOT CREATE A CATALOG BLOCK FOR A WIRE.**

### `UNRESOLVED`

Use when evidence is insufficient to establish one of the other classifications.

Unknown machine wiring, undocumented installed-device voltage, uncertain return topology, missing connector identity, or unverified timing does not authorize a guess. Physical-machine facts remain `VERIFY_AT_MACHINE`/TBD until measured or supported by authoritative evidence.

---

## 3. Adapter versus board-specific connection mold

A connection mold and an adapter solve different problems.

A **connection mold** is board-specific. It owns facts such as:

- connector type and physical pin assignment;
- board connector reference;
- what block/interface each pin reaches;
- board power/ground contacts;
- FPGA/logical mapping;
- physical board location and orientation;
- service labels/silkscreen;
- machine/harness destination.

An **adapter** owns an electrical transformation with a reusable A-side and B-side contract.

Conceptually:

`Block A contract -> Adapter A-side | transformation | Adapter B-side -> Block B contract`

The adapter does not absorb Block A, Block B, the board connector, or the machine-specific harness.

A pin rearrangement is not an adapter. A board-specific connector is not an adapter merely because it changes physical form. Conversely, a level shifter or analog scaling stage must not be hidden inside a connection mold merely because it sits near a connector.

---

## 4. Qualification contract for a real adapter

A proposed adapter must be engineered like any other reusable block. At minimum it needs:

1. **scope and generic function** — what transformation it performs and what it explicitly does not own;
2. **A-side interface contract** — electrical, timing, return/reference, lifecycle and fault assumptions;
3. **B-side interface contract** — the same for the transformed side;
4. **transformation definition** — transfer function, polarity, gain, protocol mapping, isolation boundary, or other exact behavior;
5. **provenance** — reference topology/source revision where applicable, plus datasheet-backed facts versus inference;
6. **calculations and derating** — thresholds, current, power, impedance, bandwidth, thermal and tolerance work appropriate to the claimed envelope;
7. **protection and fault containment** — including what happens when either side is powered alone or faulted;
8. **startup/default/de-energized behavior** — including reset, unconfigured logic, watchdog interaction where applicable, brownout and recovery;
9. **power/resource contract** — rail demand, FPGA/bus resources, shared resources and instance-count rules;
10. **exact manufacturing connectivity** — intended components/values and net ownership;
11. **verification evidence** — calculations first; simulation/bench/synthesis only when the engineering question requires it;
12. **qualification envelope** — what combinations of voltage, timing, source/load and environment are actually supported;
13. **machine-readable contract data** — enough for a future configurator to test compatibility without prose-only tribal knowledge;
14. **regression triggers** — changes that invalidate evidence or require requalification;
15. **safety boundary** — ordinary controller adaptation does not gain personnel-safety authority merely by being independently qualified.

A reusable adapter follows the same truthful maturity model as other blocks. `BASELINE / READY FOR INTEGRATION` is not the same as full `REV 1 READY` qualification.

---

## 5. Adversarial classification lab

For each case, the learner must record the classification, evidence used, missing facts, and the owner of the next action. Do not invent component values.

### Case A — compatible logic

A controller publishes a 3.3-V push-pull output. A reusable peripheral publishes a 3.3-V CMOS input on the same logic domain, with compatible thresholds, current and startup behavior.

Expected reasoning: likely `DIRECT_INTEGRATION`. FPGA pin assignment and net naming remain board integration.

### Case B — voltage mismatch with valid contracts

A reusable controller output is valid only at 3.3 V. A selected peripheral input requires a different logic voltage and neither block claims tolerance of the other domain.

Expected reasoning: both contracts may be valid; real level translation is needed. Classify `ADAPTER_REQUIRED` unless a different already-compatible block is selected.

### Case C — missing unpowered behavior

A field-input block specifies nominal thresholds and isolation but does not establish what its logic-side output does when field power is present and logic power is absent.

Expected reasoning: this is not automatically an adapter problem. The missing behavior is intrinsic to the reusable field-input contract: `BLOCK_CONTRACT_DEFECT` or `UNRESOLVED` pending engineering evidence.

### Case D — connector J-number and harness mapping

Two compatible electrical interfaces need to be routed through a particular board connector, assigned physical pins, placed on the board edge, and labeled for service.

Expected reasoning: `BOARD_INTEGRATION_MAPPING`. This belongs in the board-specific connection mold, not a reusable adapter.

### Case E — analog range conversion

A valid sensor/interface produces a range that exceeds the valid input range of a selected ADC-facing reusable block. Both contracts are intentional and complete.

Expected reasoning: if the blocks must remain selected, a real scaling/buffering/protection function is needed: `ADAPTER_REQUIRED`. Its accuracy, impedance, protection and partial-power behavior must be qualified.

### Case F — unknown installed machine device

A legacy machine wire is labeled `FAULT`, but its source voltage, output type, return reference and de-energized behavior have not been verified.

Expected reasoning: `UNRESOLVED` and `VERIFY_AT_MACHINE`. A guessed optocoupler, divider or level shifter is not evidence.

### Case G — safety-system status monitor

An independent safety relay exposes an auxiliary/status signal to an ordinary controller for display/diagnostics. Electrical adaptation may be needed.

Expected reasoning: the electrical boundary can be classified normally, including `ADAPTER_REQUIRED` if warranted, but the resulting ordinary controller path receives **no independent personnel-safety authority**. Safety action remains in the separately engineered safety architecture.

### Case H — fake adapter

A proposed `AXIS1_TO_J7_ADAPTER` contains no electrical transformation; it only renames nets and maps compatible signals to connector pins.

Expected reasoning: reject the catalog object. `BOARD_INTEGRATION_MAPPING` plus a board-specific connection mold is the correct owner.

---

## 6. Board-composition boundary record

For every block-to-block boundary, record at least:

| Field | Required content |
|---|---|
| boundary_id | Stable board-level identifier |
| source_interface | Block/interface ID and revision |
| destination_interface | Block/interface ID and revision |
| classification | One of the five mandatory classes |
| compatibility_basis | Which contract fields prove or disprove compatibility |
| adapter_id | Qualified adapter ID/revision when applicable |
| board_mapping_owner | Connection mold/integration record when applicable |
| unresolved_items | Explicit blockers, never silently omitted |
| machine_verification | `VERIFY_AT_MACHINE` items when physical facts are unknown |
| safety_authority | Ordinary-control vs separately validated safety role |
| invalidation_triggers | Source/destination/adapter changes requiring re-check |

This is the seed for a future machine-readable compatibility graph.

---

## 7. Catalog stress-test questions

A block catalog has a defect if an integrator cannot answer these without unwritten knowledge:

- What exact interface revision am I consuming?
- Is the signal direction and electrical type explicit?
- What are valid operating and unpowered states?
- What reference/return domain does the interface assume?
- Is isolation required, provided, or prohibited?
- What source/load impedance and timing envelope applies?
- What protection belongs to the block versus the board versus an adapter?
- What FPGA/bus/power resources are consumed?
- What evidence proves the claimed envelope?
- What change invalidates the compatibility decision?

If the answer lives only in a designer's memory, the curriculum must treat that as a catalog defect rather than adding a convenient explanatory sentence that the engineering repository cannot support.

---

## 8. Cross-machine transfer

The classification method is intentionally machine-independent.

- A mill may need a differential spindle-encoder receiver adapter.
- A lathe may need a legacy spindle-drive command interface.
- A plasma table may need isolated arc-voltage conditioning.
- A router may only need direct step/direction mapping to compatible drivers.
- A robot may require protocol or differential physical-layer conversion.
- A press brake may require analog or field-interface adaptation between reusable control blocks and legacy machine devices.

The board name changes; the ownership test does not.

---

## 9. Release gate

A board boundary is not ready for schematic release merely because someone knows how to make it work.

Before release, require:

- both neighboring interface contracts identified by revision;
- classification recorded;
- direct compatibility proven, or a qualified adapter selected;
- no real transformation hidden in board integration;
- board-specific connector facts kept in the connection mold;
- unknown machine facts still explicit;
- lifecycle/partial-power behavior checked across the boundary;
- resource and power effects included exactly once;
- safety authority correctly bounded;
- regression triggers recorded.

Freeze:

- **SAME SIGNAL NAME != COMPATIBLE INTERFACE CONTRACT.**
- **WORKS ON THIS BOARD != REUSABLE ARCHITECTURE.**
- **REAL TRANSFORMATION != BOARD WIRING.**
- **PIN MAPPING != ADAPTER.**
- **MISSING GENERIC CONTRACT FACT != BOARD-INTEGRATION DETAIL.**
- **ADAPTER QUALIFIED != NEIGHBORING BLOCKS ABSORBED.**
- **ORDINARY ADAPTER != PERSONNEL-SAFETY AUTHORITY.**

## 10. Completion artifact

The learner submits a boundary table containing at least eight cases, including all five classifications, with at least one deliberately incompatible pair of individually valid reusable interfaces. For every `ADAPTER_REQUIRED` case, the learner must either select an already-qualified catalog adapter or write a development/qualification contract for a new adapter. For every `BOARD_INTEGRATION_MAPPING` case, the learner must show why creating a reusable electrical block would be catalog clutter.

The lesson is complete only when the learner can remove the current board and machine names and explain which artifacts remain reusable and why.
