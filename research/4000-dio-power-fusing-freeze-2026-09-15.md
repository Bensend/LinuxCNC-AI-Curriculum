# 4000 DIO power / isolation / fusing freeze — 2026-09-15

Status: WORKING HARDWARE FREEZE

## Input side

Keep 12 x ISO1212 for 24 isolated inputs. TI specifies IEC 61131-2 Type 1/2/3 operation, 2.2–2.47 mA Type-3 current limiting, ±60 V input tolerance/reverse polarity and no field-side supply requirement. Therefore the input bank does **not** need an isolated DC/DC solely to operate the field input receivers.

Freeze Type-3 as the default low-power input personality unless a machine-specific requirement calls for Type 1/2. Exact external resistor values must come from the ISO1212 datasheet equation/table during capture, not a guessed generic 24-V optocoupler resistor.

## Output isolation

Keep default-LOW quad digital isolators in the FPGA -> output direction. ISO7740F-class remains acceptable; TI lists 100 Mbps, ~10.7 ns typical propagation, reinforced/basic variants and explicit default-low options.

Use one isolated logic supply for the output-side isolators/diagnostic return circuitry; do not create one converter per output. Working allocation is **one isolated 5-V, >=1-W DC/DC per 8-output group**, followed by local 3.3-V regulation if the exact isolator/diagnostic interface requires 3.3 V. Two independent 8-output groups limit the blast radius of a field-side logic fault.

Exact converter MPN is procurement-dependent and remains open until creepage/isolation rating and load budget are calculated.

## Output drivers

Retain 4 x TPS4H160-Q1 for 16 sourcing outputs. TI currently lists 3.4/4-to-40 V operating range, 160 mOhm typical RDS(on), adjustable 0.25–7 A current limit, short/thermal/inductive-load protection and diagnostics.

Working general-output current limit: **0.5 A/channel nominal**. This is deliberately much lower than the silicon maximum and fits PLC-class solenoids/relays/lamps while reducing connector/fuse/fault energy. Loads needing >0.5 A continuous or large inrush belong on an interposing relay or dedicated high-current block unless specifically qualified.

At 0.5 A, ideal per-channel conduction dissipation using 160 mOhm typical RDS(on) is 0.04 W; four simultaneously loaded channels are ~0.16 W typical before temperature/max-RDS margin. Final thermal signoff must use datasheet maximum RDS(on), ambient, copper area and package thermal impedance.

## Field-power grouping and fusing

Freeze four 4-output power groups aligned to the four smart-switch packages.

Per group:
`24V_FIELD -> replaceable/serviceable 2 A fuse or resettable protection -> TPS4H160 package -> four outputs`

A 2-A group protection target supports four 0.5-A-class channels without allowing one wiring fault to remove all 16 outputs. Final fuse time-current/inrush choice must be coordinated with the TPS4H160 electronic current limit; do not assume a fuse is fast semiconductor protection.

Provide field-power-present sensing per 8-output bank if pin/ADC budget permits. Package fault remains separate from field-power-good.

## Connector allocation

Prefer removable industrial terminal blocks. Keep each 4-output package/group physically adjacent to its fused 24-V feed and return reference. Do not route high-current field paths through FPGA/logic ground areas.

## Fault semantics

Separate:
- requested output;
- effective watchdog-gated output command;
- smart-switch electrical fault;
- field-power-present;
- isolated-logic-power-good;
- physical actuator feedback when available.

A healthy smart-switch output is not proof that a valve/contactor moved.

## Verification

Before release:
1. derive ISO1212 Type-3 networks from exact datasheet revision;
2. calculate isolated DC/DC current with exact isolators and diagnostic return devices;
3. set TPS4H160 current-limit resistor from datasheet equation for 0.5-A nominal target;
4. thermal calculation at all 16 channels commanded at rated current;
5. coordinate 2-A group fuse/PTC curve with expected loads/inrush;
6. test short-to-ground, open load, field-power loss, isolated-logic loss, FPGA reset and Ethernet/watchdog expiry;
7. verify communications recovery cannot replay stale ON commands.

No simulation is justified yet; these are datasheet/power/thermal/protection calculations followed by bench fault injection.