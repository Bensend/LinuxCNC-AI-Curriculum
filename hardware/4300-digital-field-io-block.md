# 4300 Digital Field I/O Block

Revision: 0.1 WORKING SCHEMATIC CONTRACT

## Identity
- Block: 4300-DIO24x16
- Function: 24 isolated industrial digital inputs + 16 protected sourcing outputs
- Primary interface: FPGA GPIO module -> LiteX-CNC/LinuxCNC HAL
- Reference architecture: Mesa 7I76/7I77/7I95 field-I/O practice + modern IEC digital-input/smart-switch parts
- Method: MIXED

## Inputs
### Count and electrical class
- 24 general discrete inputs.
- 24-VDC nominal machine controls.
- Working receiver: 12 x TI ISO1212 dual isolated digital-input receivers.
- Configure external networks for IEC 61131-2 24-V behavior; exact Type/current network to be calculated during schematic capture.
- Support sourcing or sinking field-input wiring using manufacturer-supported configurations.
- FPGA logic side: 3.3 V.

### Input semantics
`field state -> isolated receiver -> FPGA sampled bit -> sample generation -> transport VALID/FRESH -> HAL`

Electrical ON/OFF is not physical mechanism proof. Wire-break diagnostics are optional until explicitly implemented.

FPGA shall permit per-input digital debounce/filtering with a bypass/fast mode for probe/fault/event signals. Do not impose one slow hardware RC on all inputs.

## Outputs
### Count and electrical class
- 16 ordinary protected sourcing/high-side outputs.
- 24-V nominal load domain.
- Working driver: 4 x TI TPS4H160-Q1 A-class quad smart high-side switches.
- General-purpose target is sub-amp machine loads; exact programmable/current-limit value and simultaneous thermal envelope TBD by calculation.
- Larger/high-inrush loads may require interposing relay or separate high-current block.

### Command authority
`host request -> FPGA output register -> global FPGA watchdog/output-authority gate -> default-LOW digital isolation -> smart-switch input -> field output`

Every output must go OFF when FPGA global output authority is removed. Communications recovery alone must not re-enable stale ON commands; explicit rearm is required.

### Output diagnostics
Return at least package/group electrical fault state across isolation. Preserve command state and fault state separately. Driver diagnostics do not prove the external actuator moved.

## Isolation
- Inputs: isolation integrated in ISO1212 path.
- Outputs: grouped isolated field-side logic domain.
- Command isolators: all-forward quad digital isolator with explicit default-LOW loss behavior, ISO6740F/ISO7740F class.
- Fault return: isolated return path sized for four smart-switch package diagnostics.
- Output field-side logic requires a small isolated 3.3/5-V supply; exact DC/DC TBD.
- 24-V load power remains on field side.

## Reset/loss behavior
| Event | Output expectation | Input/diagnostic expectation | Recovery |
|---|---|---|---|
| FPGA reset | OFF | feedback marked invalid/reinitializing | explicit rearm |
| host/Ethernet loss | watchdog -> OFF | last values must become STALE, not current | explicit rearm |
| watchdog expiry | OFF independent of command register | watchdog fault reported when link returns | explicit clear/rearm |
| FPGA-side power loss | isolator default LOW -> OFF command | no valid host feedback | restart/rearm |
| field-side logic power loss | no normal ON authority; exact smart-switch truth table to verify | diagnostic may be unavailable | fault + rearm |
| 24-V field power loss | load power absent | power-loss state should be diagnosable if practical | restore + qualified rearm |
| external safety inhibit | ordinary outputs must not defeat external safety removal of hazardous energy | safety state is external authority | safety-system procedure |

## Protection/robustness
Inputs inherit ISO1212 reverse-polarity/high-voltage tolerance but still require connector/layout transient review.

Outputs inherit smart-switch short-circuit, thermal and inductive-load protections; final design must calculate current limit, dissipation and clamp-energy/load restrictions. Group field power should be fused/protected so one wiring fault cannot unnecessarily destroy the entire board.

## Diagnostics exposed to LinuxCNC
- each input bit;
- input sample generation/VALID/FRESH;
- each requested output;
- each effective gated output command;
- global output-authority/watchdog state;
- four output-driver group faults minimum;
- field-side logic/power-good if practical;
- rearm-required state.

## Safety boundary
This is robust ordinary machine I/O, not safety-rated I/O. Isolation, watchdog gating, smart-switch protection and diagnostics are fault-containment features. E-stop, guards, STO/contactors and other safety functions require the external safety architecture appropriate to the machine.

## Evidence
- Mesa production interfaces establish isolated 24-V field-I/O patterns, sourcing-output rationale and protected-output expectations.
- TI ISO1212 provides IEC 61131-2 isolated source/sink configurable industrial input behavior.
- TI TPS4H160-Q1 provides protected/diagnostic quad high-side switching.
- TI ISO674x/ISO774x F variants provide default-LOW isolated logic behavior.

Research:
- `research/4000-digital-field-io-first-pass-2026-09-15.md`
- `research/4000-digital-input-receiver-selection-2026-09-15.md`
- `research/4000-digital-output-driver-selection-2026-09-15.md`
- `research/4000-digital-output-isolation-architecture-2026-09-15.md`

## Before schematic freeze
1. calculate ISO1212 resistor networks for selected IEC input type;
2. select exact isolator suffix/package and isolated field-side DC/DC;
3. calculate TPS4H160 current limit, thermal worst case and inductive clamp envelope;
4. define field-power grouping/fusing/connectors;
5. verify driver behavior on field-side supply loss;
6. bench/integration test watchdog OFF, rearm, shorts, open load, input polarity/miswire and stale transport behavior.
