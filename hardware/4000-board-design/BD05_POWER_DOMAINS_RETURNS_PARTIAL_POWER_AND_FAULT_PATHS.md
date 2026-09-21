# BD05 — Power Domains, Returns, Partial Power, and Fault Paths

## Purpose

This is a **board-integration** lesson. A reusable block can be electrically sound and still be integrated incorrectly if board design collapses source domains, assumes a return that is not actually present, lets high-current load current flow through a quiet reference, or creates a back-power path when only part of the board is energized.

The design flow for this lesson is:

`source domain -> protection -> conversion/distribution -> load -> normal return -> fault-current return -> board-specific connector -> machine source/return`

The student must be able to trace that chain without relying on connector names, net names, or unwritten machine knowledge.

## Learning objectives

By the end of this lesson, the student can:

1. distinguish a reusable block's supply contract from a board-specific source assignment;
2. build source/load budgets without charging loads to the wrong upstream domain;
3. trace normal current and plausible fault current all the way back to their source;
4. distinguish logic reference, analog reference/return, switched field return, high-current field return, chassis, protective earth, and cable shield;
5. identify where a board-specific connection definition owns source/return pins and where the reusable block must remain machine-neutral;
6. challenge startup/inrush and simultaneous-use assumptions rather than summing only nominal currents;
7. analyze partial-power and back-power cases explicitly;
8. keep unresolved physical facts as `VERIFY_AT_MACHINE` or `TBD_ENGINEERING` rather than inventing them;
9. define verification gates before schematic/PCB release; and
10. preserve the boundary between ordinary controller power and independent personnel-safety authority.

## Student-facing worked-example audit

The following OpenPressBrake files were opened and inspected in their current `main` form before this lesson was finalized.

### `hardware/REV1_BOARD_INTEGRATION.yaml`

**Readiness: VERIFIED_FOR_LESSON — board-domain ownership and integration-boundary example only.**

The current Rev1 integration contract explicitly defines four non-collapsed machine-facing domains:

- `CORE_24V`, sourced from the DNC power connection and assigned to protected controller/core loads;
- `PROP_FIELD_24V`, a separate high-current proportional-driver field source;
- `PVR_SENSOR_24V`, a separately connected low-current PVR/sensor source that may share the upstream L6/L06 machine source with proportional field power but is not thereby an internal board bridge;
- `SWITCHED_IO_24V`, the legacy switched digital-I/O domain, with an explicit prohibition against bridging its return to the L06 return or feeding outputs from the unswitched domains.

The same integration file also separates layout zones: high-current field power is kept away from analog reference/position sensing, the analog zone requires a quiet return with no proportional-load current, and the switched-I/O zone preserves the machine's switched domain.

This is **not** evidence that every Rev1 power branch is production-qualified. The same file keeps field-power source/return/fuse coordination, analog-ground review, thermal/copper/connector derating, and multiple machine measurements as release gates.

### `hardware/blocks/machine_power/design/REV11_SENSOR_POWER_DOMAIN_RECONCILIATION.md`

**Readiness: VERIFIED_FOR_LESSON — source-domain correction and ownership example.**

This file is valuable because it documents a real catalog/integration defect instead of hiding it. An earlier reusable assumption placed sensor field power behind the protected logic path. Current Rev1 integration proved that wrong: valve-position sensor field power is separately sourced from the machine's L6/L06 side, while `CORE_24V` comes from L9/L06.

The correction therefore removes sensor field-loop current from the TPS26633 core-logic current-limit budget while retaining the 5-V-side TPS26612 bias as an indirect core-power load when that variant is instantiated.

The general lesson is:

> A semantic rail inside a reusable block does not have authority to overwrite the board's verified source-domain assignment.

The document also correctly leaves the actual core ILIM/dVdT aggregation and separate sensor-branch protection/current/drop budget open rather than guessing missing machine facts.

### `hardware/blocks/machine_power/STATUS_CHECKLIST.md`

**Readiness: VERIFIED_FOR_LESSON — maturity and release-gate example only.**

The current checklist says the machine-power block is **NOT YET SCHEMATIC-READY**. It records that the Rev1 source-domain conflict has been corrected, but still leaves these relevant gates open:

- aggregate core load and freeze TPS26633 ILIM;
- freeze dVdT from actual downstream capacitance/startup requirements;
- freeze the fault pull-up/receiver at board integration;
- prove populated powered-transmitter 5-V bias conditions;
- freeze the separate PVR sensor branch protection/drop/current budget;
- resolve `FIELD_GND` / `ANALOG_GND` / machine 0 V / chassis / PE relationships;
- complete board current-path/layout, thermal, fault-SOA, EMC and integration qualification.

Students may use this file to learn how incompleteness should be represented. They must not treat it as a finished power-tree design.

## 1. Domain identity is more than voltage

Two nets are not the same domain merely because both measure approximately 24 V relative to some point.

For every domain, record at least:

| Field | Question |
|---|---|
| source authority | Where does this energy actually enter? |
| positive conductor | Which connector/pin/net carries it? |
| intended return | Which connector/pin/net closes normal load current? |
| upstream switching | Is it always present, contactor-switched, relay-switched, or separately enabled? |
| local protection | Fuse, eFuse, current limiter, reverse protection, TVS, branch element? |
| consumers | Which block instances are actually downstream? |
| simultaneity | Which consumers can be active together? |
| startup behavior | Capacitance, inrush, soft-start, sequencing? |
| fault return | Where does short/transient/flyback energy actually flow? |
| reference relationship | Is this return intentionally joined to logic/analog/chassis/PE, isolated, or unresolved? |
| evidence class | datasheet, calculation, board configuration, machine verification, test, or unknown? |

**Freeze:** `SAME NOMINAL VOLTAGE != SAME POWER DOMAIN`.

## 2. Build budgets from actual downstream ownership

A current budget is a graph problem before it is arithmetic.

For each source/protection element:

1. enumerate only loads actually downstream of it;
2. identify each load's steady, peak/inrush, and duty/simultaneity evidence;
3. convert loads across DC/DC boundaries using a justified efficiency bound rather than equating output current with input current;
4. include quiescent/bias loads when material;
5. keep separately sourced field loads out of a logic-branch budget;
6. carry unknown machine loads as unknowns.

A reusable block may publish equations and per-instance demand. Board integration owns the populated instance count and source assignment. Machine configuration owns installed loads that require physical confirmation.

## 3. Trace the normal current loop

For every externally powered function, draw a complete loop:

`source + -> branch protection -> board conductor -> load/device -> intended return conductor -> source -`

Do not stop at `GND`.

Ask:

- Does the return connector have enough pins and ampacity for the aggregate load?
- Is a high-current return accidentally sharing copper/vias with ADC/reference current?
- Does a switched positive domain have the intended switched return/reference behavior?
- Is a field return being silently joined to a logic return because both were called `0V`?
- Does the harness provide the return that the board contract assumes?

## 4. Trace fault current separately

Normal-current routing does not prove fault containment.

For each credible fault, trace energy to a physical sink/source. Examples:

- output short to its field return;
- positive field supply short to chassis;
- reverse-polarity connection;
- inductive turnoff/clamp current;
- surge current through a TVS;
- failed load short that drives an eFuse/current limiter;
- one domain injected into another through a protection diode or I/O structure.

Record which component, trace, connector, return conductor, fuse/eFuse, clamp, or chassis path carries the event and what evidence supports its rating.

**Freeze:** `PROTECTED DEVICE PRESENT != FAULT CURRENT PATH QUALIFIED`.

## 5. Returns, chassis, PE, and shields are different design objects

Do not use `ground` as a sufficient engineering description.

A board may contain:

- digital logic reference;
- analog reference/quiet return;
- switched field return;
- high-current actuator return;
- isolated-side return;
- chassis bond;
- protective earth;
- cable shield termination.

For each pair, the design must state one of:

- intentionally joined here;
- intentionally isolated;
- joined elsewhere by machine architecture;
- capacitively/EMI-coupled by a defined network;
- `VERIFY_AT_MACHINE`;
- `TBD_ENGINEERING`.

Silence is not an acceptable connection rule.

## 6. Partial-power/back-power matrix

For every interface crossing two power domains, challenge at least these states:

| Domain A | Domain B | Required analysis |
|---|---|---|
| OFF | OFF | de-energized state |
| ON | OFF | injection/back-power path A -> B |
| OFF | ON | injection/back-power path B -> A |
| ON | ON | normal behavior |
| brownout | ON | threshold/default-state behavior |
| ON | brownout | threshold/default-state behavior |

Inspect level translators, isolators, op-amps, ADC/DAC pins, FPGA I/O, protection diodes, pull-ups, enable pins, open-drain fault lines, USB/Ethernet service interfaces, and field devices that can source a signal into an unpowered board.

A signal being logically `OFF` does not prove that its unpowered interface cannot source current into another rail.

**Freeze:** `DOMAIN OFF != NO ENERGY ENTERS DOMAIN`.

## 7. Connection-block ownership

A reusable block owns its electrical supply/interface requirements. It must not silently contain machine connector names or machine wire numbers.

The board-specific connection definition owns the physical mold:

- connector family and exact pin numbering;
- source and return pins;
- board location/orientation;
- label and silkscreen;
- harness/machine destination;
- required wire/current/voltage envelope;
- which reusable block interface it feeds;
- board-specific logical/FPGA mapping where applicable.

If the connection definition cannot say where power enters and returns, the board is not ready merely because the reusable block is mature.

## 8. Startup and inrush are board-level interactions

Per-block startup evidence must be aggregated at board level.

Check:

- simultaneous converter startup;
- aggregate input capacitance behind eFuses/current limiters;
- sequencing between 24 V, 5 V, 3.3 V and isolated rails;
- downstream capacitance versus dV/dt programming;
- fault/reset behavior during brownout;
- whether a field supply appears before logic or vice versa;
- whether connector/source impedance creates a startup dip that changes enable state.

Do not select an upstream current limit from nominal steady current alone.

## 9. Verification gates

Before schematic release, require evidence for:

1. every source and return connection;
2. every intentional domain join/isolation boundary;
3. source/load budget with unknowns visible;
4. startup/inrush assumptions;
5. partial-power matrix for cross-domain interfaces;
6. fault-current paths for credible faults;
7. connector ampacity/voltage and return-pin adequacy;
8. no hidden high-current path through quiet analog/reference copper;
9. chassis/PE/shield policy;
10. unresolved physical-machine facts explicitly blocked from release.

Before PCB release, add copper/via/current-density, thermal, placement/creepage/clearance where applicable, physical connector, EMC, and layout-return evidence.

## 10. Adversarial lab — power-tree slice

Choose one small controller slice, not an entire machine. A useful slice might be:

`24-V source -> protected logic branch -> 5-V converter -> one receiver/sensor interface`

or

`switched field source -> output block -> external load -> field return`.

Produce:

1. a domain table;
2. a source/load budget with evidence tags;
3. normal-current loop drawing;
4. at least three fault-current traces;
5. a partial-power/back-power matrix;
6. return/chassis/PE/shield relationship table;
7. connection-block requirements;
8. startup/inrush ledger;
9. verification matrix; and
10. release blockers.

Then perform the adversarial review:

- Move one load to a separately sourced domain. Does the reusable block contract survive without editing machine-specific assumptions into it?
- Remove one return conductor. Does the documentation fail closed or silently assume another `GND`?
- Power the field side while logic is off. Where can current flow?
- Power logic while the field side is off. Can an output/interface back-power the dead domain?
- Short a load. Which exact physical path carries current until protection acts?
- Replace `0V`, `GND`, and `return` with explicit domain names. Does any hidden join become visible?

If the answer requires unwritten knowledge, record a catalog/integration defect. Do not patch the lesson with tribal knowledge.

## 11. Transfer across machine classes

The method is not press-brake-specific.

- **Mill/VMC:** servo I/O, spindle command, probe/tool-changer I/O, encoder and auxiliary 24-V domains.
- **Lathe:** spindle/axis interfaces, turret/collet/chuck auxiliaries, encoder and coolant domains.
- **Plasma:** noisy torch/height-control interfaces, isolated I/O, machine control power and shield/chassis strategy.
- **Router:** drive control, spindle/VFD interfaces, limit/probe and accessory power.
- **Robot/custom automation:** distributed actuator/sensor domains, isolated interfaces and service-power sequencing.

The reusable block should remain recognizable across all of them. The connection definitions and populated board resource plan change.

## 12. Safety boundary

This lesson concerns ordinary controller-board power architecture. Good power-domain separation, deterministic de-energized behavior, watchdog qualification, STO/enable interfacing, and diagnostics are important engineering, but they do not make the LinuxCNC/FPGA board the independent personnel-safety authority.

Do not claim safety credit for ordinary controller rails, watchdogs, output inhibits, or power-good logic unless a separate safety-rated design and validation actually supports that claim.

## Exit criteria

The student passes BD05 when they can take a small board slice and demonstrate, with evidence:

- where energy comes from;
- where normal current returns;
- where fault current flows;
- what happens under partial power;
- which joins are intentional;
- which facts belong to reusable blocks versus board connection/integration;
- which physical facts remain unknown; and
- what must be proved before schematic and PCB release.

The student fails if the explanation depends on `all grounds are the same`, connector names as proof of electrical behavior, device maximum ratings as board ratings, or guessed machine values.