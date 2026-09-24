# BD62 — Connection-Contract Aggregation, Connector-Panel Allocation, and Collision Checking

## Purpose

BD61 established that a reusable block contract does not define a board connection. BD62 asks the next board-integration question: what happens when many individually reasonable connections must coexist on one controller?

`qualified connection contracts -> connector population/placement plan -> pin/contact/current aggregation -> shared field-power/return/shield resources -> FPGA/function bindings -> mechanical/label/access collisions -> harness-service review -> machine-readable board connector manifest -> whole-board consistency gate`

The governing rule is:

**INDIVIDUALLY VALID CONNECTIONS DO NOT PROVE A VALID CONNECTOR PANEL.**

A board release must prove that the aggregate population fits electrically, logically, physically, mechanically, and operationally without hidden resource conflicts or invented machine facts.

## Student-material readiness audit

Every repository file named below was opened and inspected in its CURRENT form during this run before use.

**VERIFIED_FOR_LESSON** for the bounded claims used:

- Curriculum `README.md` — evidence hierarchy, provenance, uncertainty, experiments, and safety boundary.
- Curriculum `WORK_SELECTION_POLICY.md` — autonomous work selection and evidence-gain rules.
- Curriculum `hardware/4000-board-design/BD61_CONNECTION_BLOCK_COMPLETENESS_SEMANTIC_ENDPOINT_IDENTITY_AND_HARNESS_CLOSURE.md` — board-specific connection ownership and closure requirements.
- Curriculum `hardware/4000-board-design/CHECKPOINT.md` as it existed when work was selected — board-design lane authority through BD61.
- OpenPressBrake `hardware/blocks/STATUS_RULES.md` — truthful maturity, primitive/shared-resource ownership, and integration-versus-qualification distinction.
- OpenPressBrake `hardware/blocks/BLOCK_ADAPTER_INTEGRATION_RULES.md` — reusable-block/adapter/board-integration ownership boundary.
- OpenPressBrake `hardware/blocks/lvdt_input/manifest.yaml` — current reusable valve-position-feedback interface and connector requirements.
- OpenPressBrake `hardware/blocks/lvdt_input/integration/REV1_RESOURCE_CONTRACT.yaml` — current machine-readable board resource handoff.
- OpenPressBrake `hardware/blocks/lvdt_input/STATUS_CHECKLIST.md` — current bounded status and unresolved release gates.

The LVDT-named block is not presented as production-proven. Its current Rev-1 implementation is a powered three-wire 0–12 V valve-position transducer interface and remains **SIMULATION-READY** with machine, CAD, board-integration, and qualification gates open.

## Learning objectives

A student must be able to:

1. aggregate many connection contracts without contaminating reusable blocks with board-specific population;
2. detect duplicate connector pins, semantic endpoints, FPGA resources, ADC/DAC channels, logical-function instances, and shared-resource claims;
3. aggregate contact current, field-power demand, returns, shields/chassis paths, and shared-resource capacity without mixing unlike domains;
4. distinguish electrical pin capacity from connector, copper, branch-protection, source, thermal, and simultaneous-load limits;
5. detect mechanical collisions involving connector bodies, mating plugs, cable bend/service space, board edges, fasteners, enclosure walls, labels, and access;
6. preserve unknown harness and machine facts as `VERIFY_AT_MACHINE` rather than declaring a false fit;
7. produce a machine-readable board connector manifest consumable by schematic/PCB, FPGA/HAL, harness, commissioning, and release workflows; and
8. reject a whole-board connector plan when any required collision remains unresolved.

## 1. Aggregation is a separate engineering layer

Reusable blocks answer: **what does one function require?**

Connection contracts answer: **how does this board expose one selected instance?**

The board connector manifest answers: **can all selected instances coexist?**

Do not solve aggregate conflicts by silently editing a reusable primitive. If ten valid connection contracts demand eleven available ADC channels, the primitive is not defective merely because the board allocation fails. The board must change population, shared-resource sizing, device selection, or architecture.

## 2. Required aggregation dimensions

### 2.1 Identity and pin uniqueness

For every populated connector and pin, prove:

- one physical reference designator and exact pin identity;
- one declared semantic endpoint or an explicitly justified shared node;
- no accidental reuse of reserved/DNP pins;
- no duplicate `connection_id` or machine endpoint;
- symbol pin number = footprint pad number = connector datasheet pin number; and
- aliases are explicit rather than inferred from similar names.

A duplicate pin assignment is a release blocker even if each connection file is internally correct.

### 2.2 Electrical class and contact envelope

Aggregate by compatible electrical domain, not by convenience. Check:

- voltage class and polarity;
- source/sink/contact/differential/analog semantics;
- expected continuous and transient current;
- connector/contact current rating and derating;
- branch protection and fault-clearing ownership;
- wire-size/contact compatibility;
- simultaneous-load assumption; and
- creepage/clearance or segregation where relevant.

A semiconductor's current ceiling is not a connector-panel rating. Likewise, a connector contact rating does not prove copper, source, protection, or thermal capacity.

### 2.3 Power and return aggregation

For each field-power domain, build a source-to-load ledger:

`source -> protection/distribution -> connector contact -> harness conductor -> load -> return conductor -> defined return/bond point`

Keep `LOGIC_GND`, quiet analog return, field return, coil/contactor return, shield/chassis, and protective earth distinct unless a current grounding authority explicitly joins them.

Do not naively sum currents across conversion boundaries. A 24-V field load and a 3.3-V logic load belong to different rail budgets even when one upstream supply ultimately feeds both.

### 2.4 FPGA and logical-function aggregation

Aggregate both physical and functional resources:

- package pin and I/O bank;
- I/O standard and bank voltage;
- differential pair/clock-capable restrictions;
- GPIO direction;
- ADC/DAC channel;
- SPI chip select/bus ownership;
- encoder/stepgen/PWM/serial function instance;
- LUT/register/BRAM/PLL budget where authoritative values exist; and
- watchdog/freshness/inhibit dependencies.

A board can have spare FPGA pins and still fail because the required logical function, bus capacity, bank compatibility, or shared peripheral capacity is exhausted.

### 2.5 Mechanical and service aggregation

A connector is not only its PCB footprint. The allocation must account for:

- body and mating-plug envelope;
- insertion/removal direction;
- latch/screw access;
- cable bend radius and strain relief;
- neighboring connector clearance;
- enclosure wall/opening alignment;
- board mounting hardware and keepouts;
- readable silkscreen after assembly;
- probe/test access where required; and
- serviceability without disconnecting unrelated hazardous or high-current wiring.

Unknown physical dimensions stay `TBD`/`VERIFY_AT_MACHINE`. A guessed enclosure fit is not evidence.

## 3. Worked OpenPressBrake stress test — two valve-position feedback channels

The current `lvdt_input` reusable contract is a useful aggregate test because its name carries history while its current Rev-1 electrical contract is explicit: one powered three-wire 0–12 V valve-position feedback channel per primitive. It requires `SENSOR_24V`, `SENSOR_RETURN`, and `POSITION_0_12V`, one shared ADS7953 channel, and no direct FPGA GPIO.

The current resource contract states:

- three field connector positions per instance;
- one ADS7953 channel per instance;
- one protected `SENSOR_24V` branch per instance;
- two first-machine instances as a board configuration fact, not part of the reusable primitive;
- sensor branch current limit remains `VERIFY_AT_MACHINE`;
- `SENSOR_RETURN`, `ANALOG_GND`, `LOGIC_GND`, chassis, and coil returns must not be merged without an explicit board grounding decision; and
- the shared ADS7953 acquisition network belongs once to `shared_adc_dac`, not once per channel.

Therefore the first-machine aggregation implies **six field connector positions, two ADC channels, and two protected sensor-power branches** before connector-family packing is chosen. It does **not** justify a six-position reusable LVDT block.

### 3.1 Why aggregation still cannot close the physical connector

The current manifest leaves the connector current rating parameterized because installed sensor current is unknown, and wire-size range remains `VERIFY_FROM_INSTALLED_HARNESS`. The status checklist independently leaves installed sensor endpoint/current, sensor-power branch protection, board integration, CAD/ERC/DRC, and bench validation open.

A student may therefore calculate the required semantic positions and shared-resource count, but may not claim that a particular six-position connector, terminal family, contact, wire gauge, branch fuse/current limit, or enclosure location is accepted without evidence.

### 3.2 Return-path collision test

The two sensor channels share an architectural need for quiet feedback returns, but that does not authorize arbitrary daisy-chaining through high-current returns. The manifest says `SENSOR_RETURN` is the return for sensor power and position signal and must be kept out of proportional-coil and contactor current paths.

A connector-panel review must therefore trace both outgoing `SENSOR_24V` branches and both `SENSOR_RETURN` paths through the final grounding plan. If a connector allocation would force the feedback return through a coil-return terminal or an undocumented chassis bond, classify it as `RETURN_PATH_CONFLICT` rather than accepting it because the signal pins fit.

### 3.3 Shared ADC collision test

Each populated primitive consumes one ADS7953 channel. The shared ADC owns the acquisition network. A whole-board manifest must allocate unique ADC channel IDs and prove total shared-ADC capacity and scan schedule elsewhere. Assigning both valve-position connections to the same ADC channel is a `RESOURCE_COLLISION`; inventing an extra ADC channel is not allowed.

## 4. Collision taxonomy

Use explicit machine-readable failure classes rather than prose-only review notes:

- `DUPLICATE_CONNECTION_ID`
- `DUPLICATE_PHYSICAL_PIN`
- `SEMANTIC_ENDPOINT_COLLISION`
- `ELECTRICAL_CLASS_CONFLICT`
- `CONTACT_RATING_UNRESOLVED`
- `FIELD_POWER_CAPACITY_EXCEEDED`
- `RETURN_PATH_CONFLICT`
- `SHIELD_CHASSIS_CONFLICT`
- `FPGA_PIN_COLLISION`
- `FPGA_BANK_CONFLICT`
- `LOGICAL_FUNCTION_COLLISION`
- `SHARED_BUS_CAPACITY_CONFLICT`
- `ADC_DAC_CHANNEL_COLLISION`
- `MECHANICAL_ENVELOPE_COLLISION`
- `MATING_ACCESS_COLLISION`
- `LABEL_AMBIGUITY`
- `HARNESS_DESTINATION_UNKNOWN`
- `STALE_CONNECTION_CONTRACT`
- `VERIFY_AT_MACHINE_BLOCKER`

The exact enum may evolve, but conflicts must remain queryable and release-relevant.

## 5. Machine-readable board connector manifest

A minimum aggregate artifact can look like:

```yaml
board_variant: REV1
connector_manifest_revision: 1
connections:
  - connection_id: CONN.Y1_POSITION
    contract_revision: TBD
    connector_ref: TBD
    pins: [TBD, TBD, TBD]
    block_instance: lvdt_input.0
    machine_endpoint: VALVE_Y1_POSITION
    shared_resources:
      adc_channel: TBD
      sensor_24v_branch: TBD
  - connection_id: CONN.Y2_POSITION
    contract_revision: TBD
    connector_ref: TBD
    pins: [TBD, TBD, TBD]
    block_instance: lvdt_input.1
    machine_endpoint: VALVE_Y2_POSITION
    shared_resources:
      adc_channel: TBD
      sensor_24v_branch: TBD
aggregate_requirements:
  field_positions: 6
  ads7953_channels: 2
  protected_sensor_24v_branches: 2
collisions:
  - id: INSTALLED_SENSOR_CURRENT
    class: VERIFY_AT_MACHINE_BLOCKER
    effect: blocks_contact_and_branch_protection_closure
release_state: BLOCKED_UNKNOWN
```

This is intentionally incomplete. It teaches truthful aggregation without inventing connector or harness facts.

## 6. Whole-board consistency gate

Before promoting a connector manifest, prove:

1. every required machine endpoint has exactly one intended board connection or an explicitly justified fanout;
2. every populated physical pin is uniquely allocated and electrically compatible;
3. every connection's return/reference path is closed and agrees with the grounding authority;
4. aggregate field-power/current and protection allocations fit their sources and simultaneous-use assumptions;
5. all ADC/DAC, FPGA pins/banks, buses, and logical-function instances are uniquely/capably allocated;
6. reusable shared resources are instantiated once at the correct scale rather than duplicated per primitive;
7. connector footprints, mating envelopes, access, labels, and enclosure interfaces do not collide;
8. harness destinations and machine-side identities are evidenced or explicitly blocked as `VERIFY_AT_MACHINE`;
9. schematic/PCB, FPGA/gateware, LinuxCNC/HAL, harness, commissioning, and release consumers all reference the same stable connection identities; and
10. the safety boundary remains separate from ordinary controller authority.

Any unresolved required gate fails closed.

## 7. Lab — aggregate and attack a connector panel

Given at least four connection contracts from two or more reusable block types:

1. build a connector population table;
2. allocate physical pins and semantic IDs;
3. aggregate field-power, return, shield/chassis, and contact-current requirements;
4. allocate FPGA physical and logical resources plus shared buses/ADC/DAC resources;
5. define placement, mating, cable, service, and label envelopes;
6. run the collision taxonomy;
7. inject at least three faults: duplicate pin, duplicate ADC/FPGA resource, and return/power conflict;
8. show that the manifest rejects each fault without modifying the reusable blocks;
9. mark unsupported machine facts `VERIFY_AT_MACHINE`; and
10. produce a release disposition with exact blockers.

Repeat the exercise for a different machine class—mill, lathe, plasma table, router, robot, or automation cell—to demonstrate that the aggregation method is reusable even though the connector population changes.

## 8. Catalog stress-test result

The current OpenPressBrake LVDT/valve-position artifacts demonstrate a strong per-instance resource handoff, including explicit first-machine population, shared ADC ownership, connector-position count, and unresolved sensor-current facts. They also expose the next integration-infrastructure need: a first-class machine-readable **board connector manifest** that aggregates all connection contracts and performs uniqueness/capacity/collision checks across physical pins, electrical classes, field power/returns/shields, shared resources, FPGA/logical functions, placement/access, harness destinations, and unresolved machine facts.

This is **ENGINEERING_REVIEW_NEEDED** infrastructure. It is not evidence that the reusable `lvdt_input` primitive should become a two-channel or six-terminal machine-specific block.

A secondary audit finding is that the current `lvdt_input/STATUS_CHECKLIST.md` evidence list does not name the newly current `integration/REV1_RESOURCE_CONTRACT.yaml`. Its bounded status remains useful, but the evidence-discovery surface has status/index drift and should be reconciled by the active engineering lane rather than silently treated as complete.

## 9. Safety boundary

Connector completeness and collision-free ordinary control wiring do not establish personnel-safety performance. LinuxCNC/FPGA status, feedback, watchdogs, inhibits, and interfaces to independent safety hardware receive zero personnel-safety credit here. Independent Pilz/AKAS/SICK authority remains outside this board-design lesson unless separately safety-rated and validated.

## 10. Completion criteria

A student passes BD62 when they can produce and defend a board connector manifest that:

- aggregates connection contracts without changing reusable primitives for convenience;
- proves unique semantic and physical allocations;
- accounts for power, return, shield/chassis, contact/current, shared-resource, FPGA/function, and mechanical/service constraints;
- detects deliberate collision injections;
- preserves unsupported machine facts as explicit blockers;
- remains machine-readable for downstream schematic/PCB, FPGA/HAL, harness, commissioning, and release consumers; and
- does not overclaim production or personnel-safety qualification.

## Durable next work

BD63 should develop **board-wide power-domain, return-current, shield/chassis, and fault-containment closure**:

`connector manifest + block power contracts -> source/protection tree -> per-domain load/current ledger -> startup/inrush/simultaneity -> return-current tracing -> shield/chassis bonds -> partial-power/backfeed states -> fault containment -> machine-readable power/ground manifest -> whole-board release gate`

Stress that a set of individually protected blocks can still fail as a board because of shared-source limits, return coupling, wrong bond topology, startup/inrush, back-power paths, or fault propagation.

## Compute

No simulation, synthesis, place-and-route, timing run, or other executable engineering verification was required for BD62. No GitHub-hosted compute was used. Future executable verification, when justified, must use `[self-hosted, openpressbrake]` only.
