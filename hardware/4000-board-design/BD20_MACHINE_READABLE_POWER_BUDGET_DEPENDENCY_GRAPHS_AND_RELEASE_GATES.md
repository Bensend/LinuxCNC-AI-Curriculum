# BD20 — Machine-Readable Power-Budget Dependency Graphs and Release Gates

**Lane:** independent LinuxCNC/OpenPressBrake board-design curriculum  
**Track:** BLOCK ENGINEERING -> BOARD INTEGRATION  
**Design-flow position:** block power contracts -> dependency graph -> source-domain aggregation -> protection release -> physical-path qualification -> change invalidation

## Purpose

BD19 established that a defensible board power budget consumes reusable-block load contracts exactly once and must not substitute capacity, absolute maximum, field current, or fault current for operating demand. BD20 makes that method machine-readable and fail-closed.

A spreadsheet or YAML file containing many plausible numbers is not a closed power budget if one required dependency is unresolved. The board configuration must be able to answer:

**Which exact missing reusable contract prevents which upstream claim?**

The dependency chain is:

`block contract ID -> instance count -> operating mode -> rail/domain node -> converter edge -> source-domain aggregate -> protection setting -> physical-path qualification -> release claim`

A missing node propagates `UNKNOWN` to every claim that depends on it. It does not become zero and it does not disappear from a subtotal.

## Learning outcomes

The student can:

1. represent reusable load contracts as versioned graph nodes rather than anonymous spreadsheet cells;
2. distinguish a known subtotal from a complete total;
3. propagate unresolved dependencies to upstream claims;
4. represent converter referral as an explicit directed edge so downstream demand is not counted twice;
5. apply instance count and operating-mode simultaneity without modifying the reusable block;
6. separate source-domain aggregation from capacity checks and physical-path qualification;
7. gate eFuse/fuse/current-limit settings on complete normal/startup evidence;
8. preserve startup/inrush as a separate graph from steady-state operating demand when their composition rules differ;
9. record provenance and applicability on every frozen contract;
10. invalidate dependent claims when a block revision, instance count, operating mode, converter, source, connector, conductor, PCB path, or protection element changes;
11. identify a catalog defect when a reusable block cannot publish the information needed by the graph;
12. keep ordinary controller power integrity separate from personnel-safety authority.

## Student-facing source audit

The following CURRENT files were opened and inspected during this run. They are `VERIFIED_FOR_LESSON` only for the bounded claims used here:

- OpenPressBrake `hardware/blocks/README.md` — reusable primitive/shared-resource ownership, current/time/duty contract, request-to-board aggregation, and exact-once assembly rules.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthfulness, evidence, baseline-vs-qualification, and maintenance rules.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — current mandatory block/adapter/integration boundary; composition must not mutate reusable blocks merely to make one board easier.
- OpenPressBrake `hardware/integration/REV1_CORE_LOW_VOLTAGE_LOAD_CONTRACT_AUDIT.yaml` — current fail-closed accounting classification and explicit unresolved CORE consumers.
- OpenPressBrake `hardware/integration/REV1_CORE_LOAD_OWNERSHIP_HANDOFF.yaml` — current ownership handoff and anti-double-count rules. Its RS-485 state text is historical relative to the newer block manifest and must not be treated as current RS-485 closure authority.
- OpenPressBrake `hardware/blocks/modbus_rtu_rs485/manifest.yaml` — current positive reusable 3V3 load contract for the selected THVD1450 physical transceiver.
- OpenPressBrake `hardware/blocks/fpga_core_ecp5_25/design/REV47_CORE_POWER_CONTRACT_OWNERSHIP.md` — current core ownership of `5V_CORE_IN` hot/startup demand and the still-open numerical closure.
- OpenPressBrake `hardware/blocks/machine_power/manifest.yaml` — current source-domain split and intentionally open TPS26633 logic-branch ILIM/startup gates.
- Curriculum `hardware/4000-board-design/BD19_POWER_CONTRACT_CLOSURE_AND_UPSTREAM_PROTECTION_SIZING.md` — reopened so BD20 extends rather than changes its accounting semantics.

None of these files proves the complete OpenPressBrake board production-ready.

## 1. Four result classes that must never be conflated

Every machine-readable power report shall label its result class.

### `KNOWN_SUBTOTAL`

The arithmetic sum of the dependencies that are currently known. It is useful for progress and sanity checking, but it is not a complete load claim if required nodes are unresolved.

### `COMPLETE_TOTAL`

A total whose required dependency closure is complete for a named rail/domain, operating mode, population, design revision, and evidence scope.

### `CAPACITY_CHECK`

A comparison between a complete demand claim and the capacity/derating envelope of a source, converter, connector, conductor, copper path, or other carrying element. Passing it does not itself release a protection setting or the board.

### `RELEASED_PROTECTION_SETTING`

A protection value whose prerequisites are complete: applicable normal load, startup/inrush, setting tolerance, source behavior, downstream fault behavior, weakest-path limits, thermal/SOA constraints, and coordination evidence as required by that topology.

Freeze:

**KNOWN_SUBTOTAL != COMPLETE_TOTAL != CAPACITY_CHECK != RELEASED_PROTECTION_SETTING.**

## 2. Dependency graph node types

A practical graph needs explicit node classes.

| Node type | Examples | Required identity |
|---|---|---|
| reusable load contract | RS-485 3V3 demand, FPGA core 5V input demand | block ID + contract revision + variant |
| board instance/population | 3 ports, 9 logical DI channels implemented by grouped devices | board revision + instance identity/count basis |
| operating mode | boot, idle, full ordinary activity, service | mode ID + simultaneity rule |
| rail/domain | 3V3, 5V_MAIN, CORE_24V, PROP_FIELD_24V | canonical domain ID |
| converter edge | 3V3 <- 5V, 5V_MAIN <- CORE_24V | converter ID + efficiency/startup model applicability |
| aggregate | 3V3 steady total, CORE_24V startup envelope | scope + dependency list |
| capacity element | buck, source, connector, conductor, PCB path | exact selected element/path + derating basis |
| protection claim | TPS26633 ILIM/dVdT, branch fuse | exact setting/device + prerequisite list |
| physical qualification | contact ampacity, copper temperature rise, voltage drop | exact path/revision + evidence |

A node without stable identity cannot support reliable change invalidation.

## 3. Edges carry engineering meaning

Do not make every graph edge mean merely `depends_on` if the calculation semantics differ. Useful edge types include:

- `INSTANCE_OF` — board population consumes a reusable contract;
- `ACTIVE_IN_MODE` — demand participates in a named operating mode;
- `SUPPLIED_BY` — load belongs to a rail/domain;
- `REFERRED_THROUGH` — downstream demand is transformed through a converter;
- `AGGREGATES_INTO` — exact-once arithmetic membership;
- `EXCLUDED_FROM` — explicit source-domain exclusion;
- `LIMITED_BY` — capacity or physical path bounds a demand;
- `REQUIRED_FOR_SETTING` — claim cannot release until dependency closes;
- `QUALIFIED_BY` — physical/electrical evidence supports a release claim;
- `INVALIDATES_ON_CHANGE` — regression trigger edge.

The graph must distinguish a dependency from an exclusion. Otherwise field current can silently leak into a logic budget.

## 4. Unknown propagation is fail-closed

Suppose a 3V3 aggregate contains five required consumers. Four are known and one reusable block still owes a supply-demand contract.

The correct report is conceptually:

```text
3V3 steady known subtotal = sum(known dependencies)
3V3 steady complete total = UNKNOWN
blocking dependency = <exact contract ID>
```

It is not:

```text
3V3 total = sum(known dependencies) + 0
```

Nor should the missing consumer simply be omitted from the displayed dependency set.

A useful graph evaluator should return the transitive blocker set for any requested claim. Asking why `TPS26633_ILIM_RELEASED` is false should produce the exact unresolved contracts and physical gates upstream of that claim.

Freeze:

**MISSING REQUIRED DEPENDENCY != ZERO LOAD.**

## 5. Current OpenPressBrake example: countable versus unresolved

The current CORE low-voltage audit already contains the seeds of a dependency graph.

A differential-encoder receiver contribution is marked countable: three receivers, 0.017 A maximum each on 3V3, 0.051 A aggregate maximum.

The same audit intentionally marks other dependencies `NOT_COUNTABLE_YET` or `LOGIC_SIDE_NOT_COUNTABLE_YET`, including the complete shared ADC/DAC rail load and the logic-side digital I/O demands. It also explicitly forbids using ISO1212 field-loop current, IPS1025H output capability, machine load current, or analog-output field envelopes as CORE proxies.

That means a graph may publish a known CORE/3V3 subtotal while refusing to publish a complete CORE total.

## 6. Current positive leaf contract: RS-485

The current RS-485 manifest publishes:

- selected variant: non-isolated THVD1450;
- source rail: 3V3;
- maximum steady current: 0.003 A per populated physical transceiver;
- 100 nF local decoupling;
- no invented startup-current proxy;
- explicit forbidden proxies including output-short current, bus-fault rating, termination power, and data-rate rating.

A board graph can therefore instantiate this leaf as:

```yaml
contract: modbus_rtu_rs485/nonisolated_rs485/3V3_steady
count_basis: populated_physical_transceiver
quantity: <board configuration>
source_domain: 3V3
state: CLOSED_FOR_STEADY_BOUND
```

The graph should point to the exact manifest revision used. If the selected transceiver or its supply contract changes, every dependent subtotal/total/capacity check becomes stale until recalculated.

## 7. Stale handoff text is itself a graph-governance lesson

The current integration ownership handoff still says the RS-485 block is `MISSING_PUBLISHED_SUPPLY_DEMAND`, while the newer current RS-485 manifest now contains that contract.

This is not permission to teach the stale state. The actual current block file was inspected and takes precedence for the current reusable-block contract. The mismatch is `ENGINEERING_REVIEW_NEEDED` as integration metadata drift.

A dependency graph should reduce this class of drift by referencing a stable contract ID/revision and deriving closure state from the referenced contract, rather than copying a free-text status into multiple files.

Freeze:

**COPIED STATUS TEXT != LIVE CONTRACT STATE.**

## 8. Open parent contract: FPGA core

The core ownership document correctly defines what the reusable core must publish:

- `5V_CORE_IN` hot/steady operating current;
- bounded startup/inrush envelope;
- internal rail budgets sufficient to prevent double counting;
- startup assumptions;
- regression triggers tied to image/resources, PHY/USB population, rail voltage, clocks, and support circuitry.

But numerical closure remains intentionally open. Therefore any upstream aggregate requiring the complete core load remains incomplete.

The graph should make the dependency visible:

```text
TPS26633_ILIM_RELEASED
  <- CORE_24V_COMPLETE_LOAD
     <- 5V_MAIN_COMPLETE_LOAD
        <- FPGA_CORE_5V_CORE_IN_HOT        [OPEN]
        <- FPGA_CORE_5V_CORE_IN_STARTUP    [OPEN for startup graph]
        <- other board 5V consumers        [...]
```

This is more useful than a single `TBD` cell because it identifies the owner and every blocked claim.

## 9. Converter edges prevent double counting

Derived rails need explicit converter edges.

For steady state, a converter edge can carry:

- input domain;
- output domain;
- applicable voltage range;
- efficiency model/bound and evidence;
- quiescent current if not already represented;
- operating-mode applicability;
- thermal/capacity limits as separate checks.

Downstream loads aggregate on the output rail. Their demand is then referred through the converter edge once to the input rail. They do not also appear independently on the upstream aggregate.

For startup, the edge may require a different model. The FPGA-core authority explicitly warns that upstream startup cannot be derived by directly charging all downstream rail capacitance because the TPS62825 converters intervene.

Freeze:

**STEADY CONVERTER EDGE SEMANTICS MAY NOT BE VALID FOR STARTUP.**

## 10. Operating modes are graph inputs, not hidden spreadsheet assumptions

Each aggregate must identify the operating mode and simultaneity contract used.

Examples:

- `BOOT_CONFIG`;
- `IDLE_READY`;
- `MAX_ORDINARY_ACTIVITY`;
- `SERVICE_DIAGNOSTIC`;
- `BROWNOUT_RECOVERY`.

A load may be inactive, steady, pulsed, or startup-only depending on mode. If a mode excludes a load, the exclusion needs evidence: hardware sequencing, population option, or a frozen system contract. Convenience is not evidence of non-simultaneity.

## 11. Protection settings are downstream claims in the graph

Current machine-power authority intentionally keeps `logic_branch_current_limit_target_a` and `startup_inrush_a` open. That is correct because the reusable CORE contracts and remaining non-core low-voltage consumers are not all closed.

A TPS26633 release node should require, as applicable:

- complete CORE normal-demand aggregate;
- complete startup/inrush envelope;
- current-limit tolerance;
- dV/dt/load-capacitance interaction;
- source capability/impedance;
- reverse-blocking/eFuse SOA and thermal evidence;
- downstream branch/fault behavior;
- weakest verified connector/conductor/copper path;
- fault-coordination evidence.

The protection setting is not released merely because a known subtotal is below the device rating.

## 12. Physical-path qualification remains separate

Even a complete electrical load total does not prove the path carrying it.

Represent physical qualification as separate nodes for:

- source and connector contacts;
- mating harness conductors;
- board connector contacts;
- PCB copper/vias;
- return path;
- voltage drop;
- temperature rise;
- enclosure ambient;
- protection clearing path.

This separation is especially important for the current proportional field domain: machine-power has a 4.0-A five-channel command envelope and a 4.8-A six-channel envelope if PROP6 is populated, but upstream protection remains open pending weakest-path and fault-coordination evidence. A complete operating envelope is not yet a released fuse/breaker value.

## 13. Change invalidation

Every closed graph node needs regression triggers. At minimum, invalidate affected descendants when any of these changes materially:

- reusable block contract revision or selected variant;
- instance count or physical grouping;
- operating mode or simultaneity rule;
- rail voltage;
- converter part/topology/efficiency/startup behavior;
- configured FPGA image where power depends on resources/activity;
- connector/contact population;
- harness conductor;
- PCB copper/via geometry;
- source capability;
- protection device/setting;
- ambient/thermal boundary.

Do not simply mark the whole board `dirty` when a more precise dependency edge is available. Conversely, do not preserve a released parent claim when one of its required descendants changed.

## 14. Minimal machine-readable schema pattern

A future implementation can use any suitable serialization, but it should preserve semantics similar to:

```yaml
contracts:
  - id: rs485_3v3_steady
    owner: modbus_rtu_rs485
    revision: <source revision>
    state: CLOSED
    quantity_basis: populated_physical_transceiver
    source_domain: 3V3
    value:
      max_current_a: 0.003
    provenance: manufacturer_datasheet

aggregates:
  - id: rev1_3v3_max_ordinary
    mode: MAX_ORDINARY_ACTIVITY
    required_dependencies:
      - encoder_receiver_3v3
      - rs485_3v3_steady
      - digital_input_logic_3v3
      - digital_output_logic_3v3
    result_class: KNOWN_SUBTOTAL
    complete: false
    blockers:
      - digital_input_logic_3v3
      - digital_output_logic_3v3
```

Do not copy this example's placeholder revision or dependency set into production configuration. The point is the fail-closed structure, not the literal names.

## 15. Catalog stress-test result

The current catalog architecture supports dependency-graph accounting conceptually, but the stress test exposes two reusable-data defects:

1. power contracts do not yet share a uniform stable machine-readable contract-ID/revision/state shape across all blocks;
2. integration handoffs can copy closure status that later becomes stale, as demonstrated by the current RS-485 handoff text versus the newer RS-485 manifest.

These are catalog/governance defects, not reasons to hide missing information in the curriculum.

The technically justified future improvement is a shared power-contract schema with stable IDs, provenance, steady/startup separation, quantity basis, source domain, exclusions, and regression triggers, plus board aggregates that reference those IDs rather than copying their values/status.

No OpenPressBrake engineering file is changed by this lesson because the active board lane is currently changing the reusable-block/adapter/integration methodology and power contracts. The curriculum consumes current authority read-only.

## 16. Adversarial lab

Given a controller for a mill, lathe, plasma table, router, robot, press brake, or custom automation cell:

1. create stable IDs for every required reusable load contract;
2. instantiate physical quantities separately from logical channel quantities;
3. assign every load to exactly one source domain;
4. define at least three operating modes and evidence-backed simultaneity rules;
5. create explicit converter edges;
6. produce steady and startup graphs separately where their edge semantics differ;
7. calculate known subtotals without treating unresolved dependencies as zero;
8. request a complete source-domain total and return the exact blocker set if closure fails;
9. run capacity checks only against complete totals or explicitly labeled bounded subtotals where the claim permits it;
10. refuse to release a protection setting until all required electrical and physical dependencies close;
11. change one block revision, instance count, converter, or physical path and identify exactly which descendants become stale;
12. classify any missing reusable contract as a catalog defect owned by the reusable block, not a board-integration invitation to reverse-engineer it.

A passing lab may end with `KNOWN_SUBTOTAL` plus a precise blocker list. It must not promote that result to `COMPLETE_TOTAL`.

## 17. Safety boundary

This lesson concerns ordinary controller power accounting, availability, deterministic behavior, and fault containment. No dependency graph, LinuxCNC function, FPGA, watchdog, eFuse, ordinary I/O, or power-distribution result receives independent personnel-safety authority from this work. Safety-rated architecture and validation remain separate.

## 18. Compute policy

No new executable compute is justified for BD20. The current blockers are contract closure, metadata consistency, and physical qualification. If a configured-image power estimate, synthesis/activity input, startup model, or executable regression later becomes necessary, it must run only on `[self-hosted, openpressbrake]`. GitHub-hosted fallback is forbidden.

## Durable freezes

- `MISSING REQUIRED DEPENDENCY != ZERO LOAD`.
- `KNOWN_SUBTOTAL != COMPLETE_TOTAL`.
- `COMPLETE_TOTAL != CAPACITY_CHECK`.
- `CAPACITY_CHECK != RELEASED_PROTECTION_SETTING`.
- `COPIED STATUS TEXT != LIVE CONTRACT STATE`.
- `DERIVED-RAIL LOAD REFERRED THROUGH A CONVERTER IS COUNTED ONCE`.
- `STEADY CONVERTER EDGE SEMANTICS MAY NOT BE VALID FOR STARTUP`.
- `COMPLETE ELECTRICAL TOTAL != QUALIFIED PHYSICAL PATH`.
- `PROTECTION DEVICE CAPACITY != RELEASED PROTECTION SETTING`.
- `CHANGE TO A REQUIRED DEPENDENCY INVALIDATES AFFECTED DESCENDANTS`.

## Next lesson

BD21 should teach **adapter/interface block selection and qualification during board composition**, using the newly mandatory OpenPressBrake block/adapter/integration boundary. It should present intentionally incompatible but individually valid reusable interfaces and require the student/configurator to classify each boundary as `DIRECT_INTEGRATION`, `BLOCK_CONTRACT_DEFECT`, `ADAPTER_REQUIRED`, `BOARD_INTEGRATION_MAPPING`, or `UNRESOLVED`, while preserving connection blocks as board-specific molds rather than electrical adapters.