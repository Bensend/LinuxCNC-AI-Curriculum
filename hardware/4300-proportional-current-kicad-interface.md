# 4300 proportional-current driver — KiCad / schematic-AI interface contract

Status: FIRST DRAWABLE CONTRACT; clamp and a few passive values intentionally parameterized.

## Channel multiplicity
Draw one canonical channel as a reusable hierarchical sheet. Working base-board allocation: **4 proportional-current channels**, each 0–1.1 A nominal / 1.5 A engineering ceiling. Make channel count a top-level population parameter so a 2-channel base or higher-current daughterboard does not require redesigning the control contract.

Reason for four-channel working allocation: it is enough to cover a paired left/right proportional hydraulic function plus two additional proportional outputs while keeping the expensive analog/power circuitry bounded. This is a packaging working decision, not a claim that every machine needs four.

## Canonical sheet ports
Inputs:
- `FIELD_24V`
- `AGND_FIELD`
- `DGND_CTRL`
- `PWM_REQ`
- `CHANNEL_AUTH`
- `REARM_REQ`
- `ADC_SAMPLE_CLK/CS` as required by shared ADC architecture

Outputs:
- `COIL+`
- `COIL-`
- `ISENSE_ADC`
- `OC_FAULT`
- `CHANNEL_FAULT`

## Required functional chain
`FIELD_24V -> 50mR Kelvin shunt -> COIL+ -> external coil -> COIL- -> 80V-class N-MOSFET drain -> source -> field return`

`Kelvin shunt -> INA240A1-class current sense -> anti-alias/settling network -> shared ADS7953-class ADC -> FPGA`

`FPGA PWM + FPGA channel authority -> logic gate / deterministic gating -> UCC27511A-class gate driver -> MOSFET gate`

`current-sense analog -> independent fast comparator -> SET-dominant fault latch -> hard gate-driver inhibit`

`COIL- switching node <-> CLAMP_FAST network <-> FIELD_24V/return as selected by final decay topology`

## Non-negotiable drawing rules
- Show Kelvin shunt sense traces as distinct named nets from load-current copper.
- Place comparator/latch shutdown path outside the FPGA control dependency.
- Gate pulldown must hold MOSFET OFF if driver is absent/unpowered.
- Driver input truth table must make UVLO, floating logic, FPGA reset/watchdog and latched OC all converge on gate LOW.
- Do not label current command as hydraulic flow or spool position.
- Do not merge field power ground, analog measurement return, shield/chassis and FPGA digital return casually; show their intended connection boundary explicitly.
- Keep TVS/clamp part and voltage marked `TBD_L_RAIL` until measurements bound them.
- Provide test points for `ISENSE_ADC`, `COIL-`, `GATE`, field 24 V and field return.

## Working component classes
- MOSFET: 80-V avalanche/SOA-qualified N-channel, CSD19502Q5B class; final part TBD.
- Gate driver: UCC27511A class, 4.5–18 V, UVLO/floating-input LOW, split outputs.
- Shunt: 50 mOhm Kelvin, >=0.25 W.
- Current sense: INA240A1 class, gain 20 V/V.
- ADC: shared ADS7953 class, 12-bit / 1-MSPS / 16-channel SAR.
- Comparator: TLV3201-class fast comparator or equivalent.
- Fault latch: SET-dominant hardware latch whose default/power-up state cannot create gate authority; implementation part TBD.
- Clamp: elevated fast-decay TVS/Zener/active-clamp family, exact topology/value TBD after coil/rail measurements.

## FPGA-visible register contract per channel
Command: current setpoint, enable request, command generation/age, explicit rearm.

Feedback: measured current, ADC generation/age/VALID, PWM duty, saturation, raw/latched overcurrent, open-load/no-current, watchdog/channel authority and rearm state.

## Schematic-AI acceptance checks
A generated schematic is rejected if any of these occur:
1. MOSFET can remain ON when FPGA/watchdog authority is absent.
2. OC comparator only reports to FPGA and cannot directly inhibit the gate.
3. Flyback is silently replaced with an ordinary diode without documenting the slower decay consequence.
4. Shunt Kelvin taps are merged into load-current routing.
5. ADC/current-sense stale validity is omitted from the control contract.
6. Fault clear automatically follows communication recovery.
7. A 250-V MOSFET is reintroduced without a measured transient/clamp reason.
8. Clamp voltage/TVS part is invented before coil inductance and rail envelope are known.

## Physical data needed for final values
Owner measurement package: cold/hot R, L or current-rise time, current fall time with known clamp if available, actual supply high limit/transients, and desired hydraulic current response. These values convert this interface contract into a final-valued schematic.
