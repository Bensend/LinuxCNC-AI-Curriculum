# 4000 isolated digital-input receiver selection — 2026-09-15

Status: WORKING SELECTION

## Selection

Use **TI ISO1212** as the working base-board receiver for ordinary 24-V discrete inputs.

Manufacturer evidence makes it unusually well matched to the project:
- dual-channel isolated industrial digital-input receiver;
- IEC 61131-2 Type 1/2/3 24-V input characteristics;
- configurable sourcing or sinking input wiring;
- +/-60-V input tolerance with reverse-polarity protection;
- accurate input-current limiting rather than optocoupler CTR-dependent threshold design;
- no field-side power supply required for the input receiver;
- 2.25-5.5 V logic-side supply, directly compatible with 3.3-V FPGA logic;
- up to 4-Mbps data rate / 150-ns-class pulse capability, far above ordinary limit/probe/drive-fault needs;
- isolation and high CMTI are integrated;
- wire-break detection reference architecture exists for later optional diagnostics.

Manufacturer reference: https://www.ti.com/product/ISO1212

## Architecture consequence

Twenty-four inputs require twelve dual-channel devices. That is more ICs than a shared optocoupler bank, but it eliminates a separate isolated field-side input supply and gives defined industrial thresholds/protection/isolation per pair of channels. For a reusable controller whose purpose is to survive mixed CNC field wiring, this is a better baseline than optimizing solely for BOM count.

The input connector grouping should permit either sourcing or sinking field wiring according to the ISO1212 reference circuits. Exact resistor values and Type 1/2/3 selection are a schematic calculation task; the board should target the common 24-V Type-3-style low-power behavior unless a machine compatibility requirement argues otherwise.

## Semantic boundary

ISO1212 isolation and IEC input characteristics prove an electrical input state, not the external mechanism's truth.

Preserve:
`field current/voltage -> ISO1212 state -> FPGA input bit -> input sample generation -> host VALID/FRESH`

Examples:
- a welded proximity sensor can remain electrically ON while the mechanism moved away;
- a broken wire can look OFF unless explicit wire-break circuitry is implemented;
- a stale Ethernet read can repeat the last FPGA bit while the field state has changed.

Therefore input validity/freshness remains a system property above the receiver.

## Input filtering

Do not add slow RC filtering to every input by default. The receiver is fast enough for probe/drive-fault/event inputs, while switch debounce/noise qualification can be parameterized in FPGA logic where appropriate. Any analog input filter must be justified against required pulse capture and IEC threshold behavior.

For hard EMI environments, connector-edge transient protection and layout still matter even though the receiver has robust input tolerance. Exact TVS/filter choices remain PCB-stage work.

## Safety boundary

The ISO1212 is an isolated industrial input receiver and has functional-safety documentation available from the manufacturer, but this project does **not** thereby claim a safety-rated input subsystem. The board's FPGA, firmware, architecture, diagnostics and external safety function are not being certified as a safety channel.

## Verification

- DATASHEET/REFERENCE: threshold, isolation, reverse-polarity, current-limit and source/sink configuration.
- CALCULATION: external resistor values and dissipation for the selected 24-V IEC input type.
- BENCH: 0/1 thresholds across supply/temp-representative voltages, reverse-polarity/miswire checks, pulse capture.
- INTEGRATION: FPGA debounce/bypass modes and transport VALID/FRESH fault injection.

## Result

The ordinary input side no longer needs a generic optocoupler architecture search. ISO1212 gives a modern, current-production, industrially specified path. The remaining DIO architecture problem is the output-side isolation/power/diagnostic return arrangement around the selected smart high-side switches.
