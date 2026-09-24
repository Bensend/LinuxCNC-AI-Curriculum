# BD63 — Board-Wide Power-Domain, Return-Current, Shield/Chassis, and Fault-Containment Closure

## Purpose

BD62 established that individually valid connection contracts do not prove a valid connector panel. BD63 closes the next board-integration boundary:

`connector manifest + block power contracts -> source/protection tree -> per-domain load/current ledger -> startup/inrush/simultaneity -> return-current tracing -> shield/chassis bonds -> partial-power/backfeed states -> fault containment -> machine-readable power/ground manifest -> whole-board release gate`

The governing rule is:

**INDIVIDUALLY PROTECTED BLOCKS DO NOT PROVE A SAFE OR FUNCTIONAL BOARD POWER ARCHITECTURE.**

A board can contain well-engineered primitives and still fail because a shared source is undersized, current is counted on the wrong side of a converter, a quiet return carries actuator current, a shield is bonded incorrectly, a remote-powered interface back-powers an unpowered rail, or one branch fault propagates into unrelated control domains.

## Student-material readiness audit

Every repository file named below was opened and inspected in its CURRENT form during this run before use.

**VERIFIED_FOR_LESSON** for the bounded claims used:

- Curriculum `README.md` — evidence hierarchy, provenance, uncertainty, experiments, and safety boundary.
- Curriculum `WORK_SELECTION_POLICY.md` — autonomous work selection and evidence-gain rules.
- Curriculum `hardware/4000-board-design/BD62_CONNECTION_CONTRACT_AGGREGATION_CONNECTOR_PANEL_ALLOCATION_AND_COLLISION_CHECKING.md` — aggregate connector/resource closure and return-path collision rules.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — durable board-design authority through BD62.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthful maturity, evidence, primitive/shared-resource, and maintenance rules.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block versus board-integration ownership boundary.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml` — selected nonisolated RS-485 primitive, power contract, protection, fault requirements, and unresolved installation facts.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/REV1_3V3_POWER_HANDOFF.yaml` — manufacturer-backed per-populated-port 3V3 load handoff.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/REV1_RESOURCE_CONTRACT.yaml` — physical/logical resources, COM/shield semantics, reset behavior, and remaining verification.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/STATUS_CHECKLIST.md` — current bounded maturity and open fault/EMC/physical-integration gates.
- OpenPressBrake `hardware/integration/REV1_RS485_POPULATION_POWER_AUTHORITY_REV1.yaml` — current board-integration population/power authority.

The RS-485 material is used only for the bounded claims above. It is not presented as production-qualified: electrical fault/EMC qualification, local-unpowered/remote-powered review, connector/shield integration, final board allocation, and human release remain open.

## Learning objectives

A student must be able to:

1. build a source-to-load-to-return power tree without mixing rail domains or double-counting converted loads;
2. distinguish steady, startup, inrush, transient, fault, and decoupling demands;
3. define simultaneity assumptions explicitly rather than summing convenient subsets;
4. trace every normal and credible-fault current return to its intended source/bond point;
5. keep logic, analog, field, actuator, shield/chassis, and protective-earth semantics distinct until an explicit grounding authority joins them;
6. identify partial-power and backfeed paths across I/O, transceivers, protection devices, pullups, and remote equipment;
7. prove that branch faults are contained sufficiently for the claimed ordinary-control behavior;
8. preserve unresolved installed-machine grounding/shield/current facts as `VERIFY_AT_MACHINE`; and
9. produce a machine-readable power/ground manifest usable by schematic/PCB, commissioning, verification, and release review.

## 1. Power closure is a graph, not a sum

For each populated board variant, model nodes and directed relationships:

`source -> protection/switching -> conversion -> distribution -> load -> return -> source`

Record each conversion boundary once. If a 24-V source feeds a 5-V regulator that feeds a 3.3-V regulator, downstream 3.3-V current is not added directly to the 24-V ledger. The upstream ledger consumes the converter's input demand using a justified efficiency/envelope model.

At minimum each rail/domain record needs:

- stable domain ID and nominal/allowed voltage;
- owning source or converter;
- upstream source/domain;
- protection/current-limit owner;
- enabled/de-energized/default state;
- downstream consumers and evidence revision;
- steady maximum load;
- startup/inrush model or explicit unknown;
- downstream capacitance relevant to startup;
- simultaneity assumption;
- normal return path;
- fault return path;
- partial-power/backfeed dependencies; and
- release blockers.

## 2. Demand classes must not be substituted for one another

### 2.1 Steady operating current

Use manufacturer maximum, calculation, or qualified measured envelope appropriate to the claim. Typical current is not automatically a worst-case board budget.

### 2.2 Startup and inrush

Startup includes charging downstream capacitance, converter soft-start, sequenced loads, relays/contactors, motors/solenoids where applicable, and devices whose initialization state differs from steady operation. Do not manufacture an inrush multiplier when no evidence exists. Record capacitance and mark the unresolved startup question instead.

### 2.3 Transient and fault current

TVS surge current, output short current, bus-fault rating, and contact interrupt rating are not ordinary rail-load proxies. They belong to fault/transient analysis with their own duration, path, energy, protection, and clearing behavior.

### 2.4 Simultaneity

Define whether all loads may be active simultaneously. If the architecture guarantees mutual exclusion, preserve the mechanism and evidence that enforces it. Software scheduling alone must not be used as a hidden electrical derating assumption unless the release claim explicitly accepts that dependency and its failure behavior.

## 3. Return-current closure

For every load, draw the complete loop. A signal name such as `GND` is not proof of an acceptable return path.

Classify returns such as:

- logic return;
- analog/sensor return;
- field-I/O return;
- actuator/coil return;
- communication reference/common;
- cable shield/chassis;
- protective earth.

Then ask:

1. where does normal current flow?
2. where does startup/inrush current flow?
3. where does fault/transient current flow?
4. what impedance is shared with sensitive measurements or logic references?
5. what happens if a connector return opens before power/signal?
6. what happens when remote equipment is powered while the local board is not?

A board-level star point, split plane, chassis bond, RC/capacitive shield bond, or direct bond is an engineering decision requiring evidence. Do not infer it from net-name similarity.

## 4. Shield, chassis, COM, and protective earth

These identities are not interchangeable.

A shield may need a low-impedance chassis path for EMC while a communication COM provides a functional reference between transceivers. Protective earth exists for protective bonding and is not a convenient signal-return conductor. The board manifest must state each bond explicitly, including location, implementation, purpose, assembly state, and evidence.

If installed-machine evidence is required to decide one-end/two-end shield termination, isolation, or COM treatment, the state is `VERIFY_AT_MACHINE`; the schematic/PCB release must fail closed if that unresolved fact affects the selected implementation.

## 5. Partial-power and backfeed review

Review at least these states where applicable:

- board off, remote field device on;
- board logic on, field supply off;
- field supply on, FPGA/configuration not valid;
- one converter rail valid while a dependent rail is absent;
- connector inserted/removed with one side powered;
- communication line driven while local transceiver is unpowered; and
- output load externally energized while controller output stage is off.

Trace current through input clamps, ESD/TVS structures, pullups, level translators, transceivers, protection ICs, MOSFET body diodes, regulator outputs, and connector COM paths. Classify each path as allowed, blocked by design, current-limited/qualified, or unresolved.

## 6. Fault-containment closure

For each source/distribution branch, define credible faults and the intended containment boundary:

- load short to its return;
- load short to another rail/domain;
- connector pin short/miswire;
- reverse polarity where exposed;
- open return/reference;
- shield/chassis fault;
- downstream converter short/failure;
- remote-powered backfeed; and
- branch overload or wiring fault.

Record what limits or interrupts current, what else loses power, whether unrelated outputs can remain deterministic, what diagnostic becomes valid, and what evidence proves the behavior.

The goal is not to claim every ordinary controller branch is safety-rated. The goal is to prevent an unexamined fault in one ordinary function from silently corrupting unrelated board domains.

## 7. Worked OpenPressBrake stress test — RS-485 power and reference closure

The current `modbus_rtu_rs485` primitive is a useful example because it separates a well-bounded reusable load from unresolved installed-network facts.

The selected nonisolated THVD1450 implementation publishes, per populated physical port:

- `3V3` operating supply current maximum: **3.0 mA**;
- local decoupling: **0.1 uF**;
- one transceiver per physical port;
- optional 120-ohm A/B termination, DNP by default and populated only at a verified physical bus end; and
- installation-dependent `RS485_COM` and `SHIELD` semantics.

The board integration authority scales the known load as:

`I_3V3_RS485_MAX = 3.0 mA * N_RS485_POP`

`C_3V3_RS485_LOCAL = 0.1 uF * N_RS485_POP`

But current repository evidence deliberately leaves `N_RS485_POP = VERIFY_AT_MACHINE`. Therefore the fixed Rev1 numeric subtotal remains open. Reserved communication capability is not populated hardware and must not be converted into a fabricated load.

### 7.1 Correct accounting boundary

Count each populated THVD1450 exactly once on `3V3`. Do not duplicate that load inside the FPGA-core block or machine-power block. If `3V3` comes from an upstream converter, convert the aggregate 3V3 demand once at the owning regulator using a justified conversion envelope.

The optional 120-ohm A/B termination is a differential bus load, not a 3V3 rail load in this baseline because there is no external failsafe-bias network. Likewise, TVS transient current and transceiver bus-fault ratings are not ordinary 3V3 demand.

### 7.2 Return/shield boundary remains open

The reusable contract refuses to collapse `RS485_COM` or `SHIELD` into logic return. Current board authority also leaves cable/reference/common wiring, ground-potential difference, shield/chassis convention, and the need for galvanic isolation at `VERIFY_AT_MACHINE`.

Therefore a board-wide power/ground manifest may consume the 3.0-mA electrical load contract while still blocking final communication-reference and shield/bond closure. **Known rail current does not prove known grounding.**

### 7.3 Partial-power question remains a release gate

The block's current remaining verification explicitly includes local-unpowered/remote-powered behavior. Until that is closed, a whole-board release must not claim that the communication interface cannot back-power or otherwise violate an unpowered local domain under every installed-network state.

This is a useful evidence-boundary lesson: the source-current contract is `VERIFIED_FOR_LESSON` for aggregation, while broader fault/partial-power qualification remains open.

## 8. Machine-readable power/ground manifest

A minimum board artifact can look like:

```yaml
board_variant: REV1
power_ground_manifest_revision: 1
rails:
  - id: PWR.3V3
    source: TBD_REGULATOR
    voltage_nominal_v: 3.3
    consumers:
      - id: LOAD.RS485
        formula_current_max_mA: "3.0 * N_RS485_POP"
        formula_capacitance_uF: "0.1 * N_RS485_POP"
        evidence: modbus_rtu_rs485/REV1_3V3_POWER_HANDOFF.yaml
    unresolved:
      - N_RS485_POP
returns_and_bonds:
  - id: REF.RS485_COM
    relationship_to_logic_gnd: VERIFY_AT_MACHINE
  - id: SHIELD.RS485
    chassis_bond: VERIFY_AT_MACHINE
partial_power_cases:
  - id: PP.RS485_REMOTE_ON_LOCAL_OFF
    state: OPEN_QUALIFICATION_ITEM
fault_containment:
  - id: FC.RS485_BUS_FAULT
    ordinary_3v3_load_proxy_allowed: false
release_state: BLOCKED_UNKNOWN
```

A production artifact should add source limits, converter envelopes, protection ownership, all consumers, return/bond nodes, startup states, simultaneity classes, fault cases, evidence revisions, and stale-dependency tracking.

## 9. Whole-board power/ground gate

Before promoting a complete board, prove:

1. every populated load belongs to exactly one owning rail/domain ledger;
2. every conversion boundary is counted exactly once;
3. source, regulator, connector, copper, protection, and thermal limits support the justified simultaneous envelope;
4. startup/inrush and downstream capacitance are supported or explicitly blocking;
5. every normal current has a closed return path to its source;
6. sensitive returns are not silently used for high-current actuator/fault current;
7. every shield/chassis/PE/functional-reference bond is explicit and justified;
8. credible partial-power states have been reviewed for backfeed and invalid biasing;
9. credible branch faults have an identified containment/clearing path and release effect;
10. unresolved installed-machine grounding/current/shield facts remain `VERIFY_AT_MACHINE` rather than guessed;
11. schematic/PCB and connector manifests consume the same domain/bond identities; and
12. ordinary control power architecture is not misrepresented as independent personnel-safety authority.

Any required unresolved gate fails closed.

## 10. Lab — attack the board power tree

Using at least four populated connection/block instances across at least three electrical domains:

1. build the source/converter/protection tree;
2. create per-domain steady-load and downstream-capacitance ledgers;
3. define startup and simultaneity assumptions;
4. trace every load's normal return;
5. mark shield/chassis/PE bonds separately;
6. enumerate partial-power states;
7. inject at least four defects: double-count a converted load, merge a sensor return into an actuator return, create an undocumented shield-to-logic bond, and remote-power an unpowered interface;
8. show that the manifest detects or blocks each defect;
9. preserve unsupported installed-machine facts as `VERIFY_AT_MACHINE`; and
10. produce a release disposition with exact evidence needed to close each blocker.

Repeat with another machine class such as a mill, plasma table, router, robot, or automation cell. The rail names and loads may differ; the closure method must survive the change.

## 11. Catalog stress-test result

The current RS-485 artifacts show a strong reusable power handoff: a manufacturer-backed per-populated-port load, explicit decoupling, parameterized board population, and explicit exclusions preventing fault/bus ratings from becoming load proxies. The board integration authority also correctly refuses to invent population, COM, shield, topology, or isolation facts.

The stress test exposes the next integration-infrastructure requirement: a first-class machine-readable **board power/ground manifest** joining block power handoffs to source/converter/protection ownership, startup/inrush/capacitance, simultaneity, return-current paths, shield/chassis/PE bonds, partial-power cases, fault-containment boundaries, evidence revisions, and unresolved `VERIFY_AT_MACHINE` facts.

Classification: **ENGINEERING_REVIEW_NEEDED** infrastructure. This is not a reason to move board-specific regulator, connector, grounding, or machine-network facts into the reusable RS-485 primitive.

A secondary evidence-discovery defect remains visible: the current RS-485 `STATUS_CHECKLIST.md` evidence list names `manifest.yaml` but does not enumerate the current `REV1_RESOURCE_CONTRACT.yaml` and `REV1_3V3_POWER_HANDOFF.yaml` even though its status text relies on the published power contract. Bounded status claims remain usable, but the evidence index should be reconciled by the active engineering lane.

## 12. Safety boundary

This lesson concerns ordinary board power integrity and fault containment. It does not establish PL/SIL/category, safety-rated power interruption, safe torque off performance, stopping performance, diagnostic coverage, or final-element safety validation. Ordinary LinuxCNC/FPGA watchdogs, output inhibits, communications, and power-good logic receive zero personnel-safety credit unless a separate safety-rated design and validation explicitly establishes otherwise.

## 13. Completion criteria

A student passes BD63 when they can produce and defend a board power/ground manifest that:

- preserves reusable block power contracts without contaminating them with board-specific assumptions;
- counts each load and conversion boundary exactly once;
- distinguishes steady, startup/inrush, transient, and fault demands;
- traces normal and fault return currents;
- defines shield/chassis/PE/reference bonds explicitly;
- reviews partial-power/backfeed states;
- demonstrates fault containment appropriate to the ordinary-control claim;
- preserves unsupported machine facts as blockers; and
- remains machine-readable for CAD, commissioning, verification, and release consumers.

## Durable next work

BD64 should develop **startup/default/de-energized sequencing, power-validity, watchdog/output-authority, and partial-power state-machine closure**:

`power/ground manifest -> rail-validity dependencies -> reset/configuration states -> output default authority -> enable/permissive chain -> watchdog/freshness -> partial-power transitions -> deterministic de-energization -> recovery/re-arm -> machine-readable startup/authority state model -> whole-board transition gate`

Stress that static power closure does not prove deterministic behavior during power-up, reset, FPGA configuration, communications loss, brownout, watchdog expiry, or recovery.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was required for BD63. No GitHub-hosted compute was used. Future executable verification, when justified, must use `[self-hosted, openpressbrake]` only.
