# BD22 — Boundary-Compatibility Matrices and Machine-Readable Interface Matching

## Purpose

BD21 classified a board boundary only after an engineer had understood both sides. BD22 asks the adversarial next question: **did the reusable blocks publish enough structured interface information that another engineer or configurator can reach the same result without tribal knowledge?**

This lesson develops both linked skills:

1. **block engineering** — publish a stable, revisioned interface contract that exposes the facts needed for composition; and
2. **board integration** — compare those contracts fail-closed, select direct integration or a qualified adapter, and keep board-specific connector mapping outside the reusable electrical contract.

The OpenPressBrake controller is a worked architectural example, not a production-proven reference board. The method applies to mills, lathes, plasma tables, routers, robots, press brakes, and custom automation.

## Student-material verification status for this run

The following current files were opened and inspected before this lesson was written:

- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — **VERIFIED_FOR_LESSON** for immutable reusable contracts, five-way boundary classification, adapter ownership, and fail-closed `VERIFY_AT_MACHINE` behavior.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — **VERIFIED_FOR_LESSON** for qualification/status semantics and the requirement that the external semantic interface contract be complete enough for board assembly.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml` — **VERIFIED_FOR_LESSON** only as a bounded example of useful structured interface/resource/electrical/fault fields. It is not evidence that every compatibility dimension is machine-readable or that the complete board is released.
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/manifest.yaml` — **ENGINEERING_REVIEW_NEEDED** for automated interface matching. It exposes a standardized 3V3 FPGA I/O boundary and extensive resource data, but `external_io_boundary` remains prose-like and does not itself publish the threshold/drive/lifecycle schema needed for a generic matcher.
- Curriculum `hardware/4000-board-design/BD21_ADAPTER_INTERFACE_BLOCK_SELECTION_AND_QUALIFICATION_DURING_BOARD_COMPOSITION.md` — **VERIFIED_FOR_LESSON** as the prerequisite classification method.

Readiness is claim-scoped. None of these labels establishes production readiness of the complete OpenPressBrake controller.

---

## 1. Names are not contracts

A future configurator must not connect two ports merely because both are named `UART`, `ENABLE`, `FAULT`, `3V3`, `ANALOG`, or `SPI`.

Freeze:

> **STRING MATCH != INTERFACE MATCH**

Compatibility is a proposition over two exact interface revisions and their context. A useful minimum record must answer whether the source and destination agree on the dimensions that can make the connection unsafe, invalid, inaccurate, nondeterministic, or resource-infeasible.

If a required dimension is missing, the result is `UNRESOLVED`, not `DIRECT_INTEGRATION`.

---

## 2. Compatibility dimensions

For each interface, publish structured fields where applicable:

| Dimension | Examples of machine-readable facts |
|---|---|
| identity | stable interface ID, schema revision, block revision, variant |
| role/direction | input, output, bidirectional, power source/sink, sense-only |
| drive type | push-pull, open-drain, tri-state, differential, current source, passive |
| operating envelope | nominal/min/max voltage and current, thresholds, absolute versus operating limits |
| impedance | source impedance, required load impedance, bias/termination assumptions |
| reference/return | signal reference, power return, chassis relation, prohibited joins |
| isolation/common mode | isolation provided/required, common-mode operating envelope, barrier ownership |
| lifecycle | reset, unconfigured, disabled, field-only, logic-only, brownout, power-down, back-power behavior |
| default authority | local pull state, enable ownership, watchdog/fault response |
| timing | bandwidth, edge rate, baud/data rate, setup/hold, latency where material |
| protocol semantics | electrical layer versus framing/register/application ownership |
| protection/fault | expected transient environment, fault tolerance, clamp/TVS ownership, prohibited fault assumptions |
| power dependencies | rails and current contracts required for the interface to be valid |
| logical resources | FPGA pins/banks, UART/SPI/bus resources, clocks, LUT/BRAM/PLL dependencies where applicable |
| cable/termination | only when cable/connector characteristics are part of the electrical envelope |
| safety authority | ordinary control/diagnostic versus separately validated safety role |
| evidence | source/revision and evidence class for each critical claim |
| invalidation | changes that force compatibility re-evaluation |

Not every field applies to every interface. `NOT_APPLICABLE` must be explicit and justified; it is different from unknown.

---

## 3. Four-valued field state

Each required compatibility fact should have one of four states:

- `KNOWN` — value/envelope is established by named evidence;
- `NOT_APPLICABLE` — dimension genuinely does not apply, with reason;
- `VERIFY_AT_MACHINE` — physical installed-machine fact must be measured/verified;
- `UNKNOWN` — required engineering information is missing.

`UNKNOWN` and `VERIFY_AT_MACHINE` are blockers for any compatibility proposition that depends on them.

Freeze:

> **MISSING FIELD != WILDCARD**

A schema that treats absent data as “don't care” will eventually create a false-positive match.

---

## 4. Matching result

For a proposed source/destination pair, evaluate every applicable rule and emit one board-boundary result:

- `COMPATIBLE` — all required dimensions are established and mutually compatible;
- `INCOMPATIBLE` — at least one established dimension conflicts;
- `UNRESOLVED` — no established conflict, but at least one required fact is unknown or requires machine verification;
- `CONTRACT_DEFECT` — missing/contradictory information is intrinsic to a reusable block and must be repaired at the block owner.

Then map the result into BD21:

- `COMPATIBLE` normally permits `DIRECT_INTEGRATION` or `BOARD_INTEGRATION_MAPPING`;
- `INCOMPATIBLE` triggers qualified-adapter search or different-block selection;
- `UNRESOLVED` remains `UNRESOLVED`;
- `CONTRACT_DEFECT` becomes `BLOCK_CONTRACT_DEFECT`.

A matcher does not automatically create circuitry.

---

## 5. Fail-closed comparison rules

A robust matcher must distinguish **operating compatibility** from **survival compatibility**.

Examples:

- A 5-V-tolerant input may survive 5 V but still have thresholds incompatible with a 3.3-V source.
- A transceiver may tolerate an unpowered remote bus within a datasheet limit but not produce valid local logic while its rail is absent.
- A connector may carry the required current, while the selected board trace or return path does not.
- Two differential interfaces may use similar voltages but incompatible termination, common-mode, timing, or protocol semantics.

Rules:

1. compare operating envelopes, not only absolute maximum ratings;
2. compare direction and drive authority before voltage;
3. compare source and load impedance/termination where material;
4. compare reference and return domains explicitly;
5. check partial-power and back-power behavior before declaring direct integration;
6. check timing/protocol only after electrical compatibility is established;
7. aggregate power/resource dependencies exactly once;
8. preserve safety-authority boundaries regardless of electrical compatibility.

---

## 6. Board-specific connection molds stay separate

The matcher consumes reusable electrical contracts. It must not require a reusable block to know:

- J-number;
- board edge/location;
- exact machine harness destination;
- board-specific FPGA pin assignment;
- silkscreen/service label;
- connector instance count;
- physical routing choice.

Those remain board-specific connection/integration data.

Connector/cable data belongs in a reusable interface contract only when it changes the electrical envelope — for example characteristic impedance, shielding/reference strategy, required termination, current/contact limitations, or a qualified mating/contact system.

Freeze:

> **PHYSICAL MAPPING DATA != ELECTRICAL INTERFACE CONTRACT**

---

## 7. OpenPressBrake adversarial examples

### Example A — RS-485 is useful but not yet a universal matcher schema

The current `modbus_rtu_rs485` manifest exposes useful structured facts: FPGA-side `UART_TX`, `UART_RX`, `RS485_DE`; 3V3 supply; THVD1450 device; two-wire half-duplex topology; common-mode and bus-fault envelopes; optional termination; resource counts; and explicit field/board integration responsibilities.

That is enough to demonstrate why structured contracts are valuable. It is **not** permission for a generic matcher to infer every missing logic threshold, lifecycle, remote-unpowered, cable, or machine-ground fact from prose or from the selected part number.

Catalog pressure: promote compatibility-critical facts from prose/datasheet knowledge into a common interface schema when automated matching needs them.

### Example B — FPGA resource data is not an electrical port contract

The current FPGA-core manifest publishes 3V3 bank requirements and extensive resource accounting, but the generic external I/O boundary is summarized as a standardized 3V3 FPGA resource/pin interface. A future matcher still needs explicit port-class data such as direction/drive, thresholds, bank/rail identity, lifecycle behavior, default authority, and any pull/tri-state assumptions.

Catalog defect/action item: define reusable FPGA port classes separately from board-specific pin assignments. Do not put machine signal names or J-numbers into those classes.

### Example C — RS-485 isolation choice

The current non-isolated RS-485 variant is legitimate within its declared envelope, while the manifest leaves an isolated variant for machine/network conditions that justify it. If actual machine ground-potential/reference evidence is missing, the configurator must return `UNRESOLVED`/`VERIFY_AT_MACHINE`; it must not silently choose non-isolated because that variant is cheaper or already selected on another board.

---

## 8. Proposed machine-readable boundary record

A board composition can reference, rather than copy, interface authority:

```yaml
boundary_id: BND_RS485_SERVICE_1
source:
  interface_id: fpga_uart_3v3_pushpull
  revision: TBD
  instance: uart_service_1
destination:
  interface_id: rs485_logic_side_thvd1450
  revision: TBD
  instance: rs485_port_1
checks:
  direction_drive: TBD
  voltage_thresholds: TBD
  reference_return: TBD
  lifecycle_partial_power: TBD
  timing_protocol: TBD
  power_resources: TBD
result: UNRESOLVED
adapter: null
board_mapping: connection_mold_owned
invalidation:
  - source_interface_revision_change
  - destination_interface_revision_change
  - rail_or_bank_change
  - lifecycle_contract_change
```

The `TBD` entries are intentional. This example demonstrates fail-closed structure; it does not invent current OpenPressBrake interface IDs or pretend compatibility has been proven.

---

## 9. Contract ownership and regression

The reusable block owns facts intrinsic to its interface. Board integration owns instance selection and physical mapping. A compatibility decision stores references to the source/destination contract revisions, not copied prose.

Re-run matching when any relevant item changes, including:

- block/interface revision;
- selected component/variant;
- rail or FPGA-bank voltage;
- drive type or thresholds;
- lifecycle/default behavior;
- isolation/reference strategy;
- termination/cable requirement;
- protocol timing;
- protection envelope;
- resource allocation;
- machine fact previously marked `VERIFY_AT_MACHINE`.

A previously green boundary becomes stale until re-evaluated.

---

## 10. Adversarial lab

Build a compatibility matrix for at least eight proposed boundaries. Include:

1. one fully compatible digital pair;
2. one voltage/threshold mismatch;
3. one drive-type mismatch such as push-pull versus wired/open-drain expectation;
4. one reference/common-mode mismatch;
5. one missing lifecycle/partial-power fact;
6. one timing/protocol mismatch despite electrical compatibility;
7. one board-only connector/pin mapping that must stay outside reusable contracts;
8. one machine-dependent isolation/reference decision that remains `VERIFY_AT_MACHINE`.

For every row record exact interface revisions, required fields, evidence class, result, BD21 classification, next owner, and invalidation triggers.

The learner loses credit for filling an unknown field with a plausible value merely to complete the table.

---

## 11. Catalog stress-test result

Teaching automated matching exposes two durable catalog pressures:

1. **common interface schema** — blocks currently publish useful information in different structures and prose; automated composition needs stable semantic fields and IDs without forcing every block into one electrical shape;
2. **FPGA port classes** — logical resource counts and bank voltage are necessary but not sufficient to prove electrical compatibility of a particular reusable I/O boundary.

These are catalog defects/action items, not reasons to contaminate board integration with inferred values.

Do not retrofit active OpenPressBrake blocks merely to satisfy this lesson while overlapping engineering work is in progress. Introduce the schema only when its ownership/versioning rules are clear and current block work can migrate without losing authority.

---

## 12. Safety boundary

A compatibility engine can prove only the ordinary electrical/logical propositions encoded and evidenced by its contracts. It cannot grant safety integrity, PL/SIL/category, diagnostic coverage, or independent personnel-safety authority.

An ordinary FPGA/LinuxCNC monitor can be electrically compatible with a safety-system status output while remaining outside the independent safety decision path.

Freeze:

> **ELECTRICALLY COMPATIBLE != SAFETY-QUALIFIED**

---

## 13. Release gate

A boundary may be released for schematic composition only when:

- exact source/destination interface revisions are identified;
- every required compatibility dimension is `KNOWN` or justified `NOT_APPLICABLE`;
- no `VERIFY_AT_MACHINE` fact required by the proposition remains open;
- operating and survival envelopes are not confused;
- reference/return and lifecycle behavior are compatible;
- timing/protocol semantics are compatible;
- power/resource effects are included exactly once;
- direct integration or qualified adapter ownership is explicit;
- board-specific physical mapping remains in the connection mold;
- safety authority is correctly bounded;
- invalidation triggers are recorded.

Freeze:

- **STRING MATCH != INTERFACE MATCH.**
- **MISSING FIELD != WILDCARD.**
- **ABSOLUTE-MAX SURVIVAL != OPERATING COMPATIBILITY.**
- **RESOURCE FIT != ELECTRICAL COMPATIBILITY.**
- **PHYSICAL MAPPING DATA != ELECTRICAL INTERFACE CONTRACT.**
- **ELECTRICALLY COMPATIBLE != SAFETY-QUALIFIED.**

## 14. Completion artifact

Submit the eight-row compatibility matrix plus one proposed reusable interface schema fragment. The schema must be generic enough to survive removal of the current board/machine names and specific enough that an unknown required field forces `UNRESOLVED` rather than a guessed match.

The lesson is complete only when another engineer can reproduce each boundary result from repository evidence without relying on the original designer's memory.
