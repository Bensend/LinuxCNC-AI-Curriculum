# 4000 whole-board power budget — first engineering freeze

Status: WORKING DESIGN BUDGET, NOT FINAL MEASURED CONSUMPTION
Date: 2026-09-15

## Purpose
Turn the reusable block contracts into rail allocations large enough to select regulators without pretending that FPGA dynamic power is known before final gateware, clock rates, I/O toggle rates and PCB loading are frozen.

## Domain rule
Machine 24 V, controller logic rails, isolated DIO field-side rails and VFD-derived analog rails are separate power authorities. Do not add them into one fictitious board-current number.

## Controller-logic working allocations

### 3.3 V rail
| Load | Working allocation | Basis / status |
|---|---:|---|
| ECP5-25 VCCIO/auxiliary 3.3-V domains | 0.75 A | conservative DESIGN ALLOCATION pending Lattice power-calculator result and final bank usage |
| RTL8211FI PHY 3.3-V-facing domain + clock/magnetics-side support | 0.30 A | conservative allocation; exact rail split/current must be checked against final Realtek design data |
| four AM26LV32E encoder receiver packages | 0.068 A max | TI lists 17 mA max supply current per quad receiver |
| FPGA-side digital isolator logic | 0.10 A | allocation; ISO674x is ~1 mA/channel DC typ and ~1.6 mA/channel at 1 Mbps typ, but actual channel count/toggle rate remains to be pinned |
| ADS7953 digital/analog interface contribution + reference/support | 0.05 A | allocation; ADC itself is only ~11.5–14.5 mW typical depending conditions |
| SPI NOR, oscillator, reset/supervision, JTAG/service pullups/LEDs | 0.15 A | conservative aggregate allocation |
| four INA240 current-sense amplifiers if powered from 3.3 V | 0.011 A max | 2.4–2.6 mA max class each |
| miscellaneous FPGA-side logic / comparator reporting / margin | 0.20 A | design reserve |
| **Subtotal allocation** | **1.63 A** | not a prediction |
| **Regulator design target** | **>=2.5 A continuous** | leaves ~53% headroom over allocated subtotal |

### 1.1 V FPGA core rail
Final ECP5 dynamic power depends strongly on utilization and clock/toggle activity. Until the Lattice power estimator is run against representative LiteX-CNC gateware, allocate **1.5 A** to VCC core and require a regulator capable of **>=2.0 A continuous** with power-good/sequencing visibility. This is an engineering envelope, not a claim that the FPGA normally draws 1.5 A.

### 5 V controller-side rail
This rail primarily serves six-axis differential STEP/DIR transmitters and gate-driver/analog support where required. Working allocation: **1.5 A**, regulator target **>=2.5 A continuous**. Exact MAX3042B dynamic current must be entered after the final transmitter count, termination assumptions and switching duty are frozen. Do not derive it from quiescent current alone.

## Isolated / field-derived domains

### DIO output-isolator banks
Two independent eight-output field-side logic banks remain. Budget each bank at **0.25 W minimum delivered capacity**, with **0.5 W preferred design capacity** to preserve startup and diagnostic margin. Exact isolated DC/DC selection waits for creepage/clearance, input rail and EMC decisions. The smart high-side output load current itself comes from protected 24-V field power and is not supplied by these converters.

### VFD analog channels
Each VFD channel remains locally powered from that VFD's nominal 10-V reference through its TPS7A2450-class 5-V LDO. It is explicitly excluded from controller 3.3/5-V budgets and must not be back-powered across the isolation barrier.

### Proportional-current power stage
Coil energy comes from protected machine 24 V and is excluded from logic-rail current. Logic-side current sense, ADC, comparator and gate-driver support are included in controller allocations. Clamp energy remains `TBD_L_RAIL` until physical coil L/current-decay measurements exist.

## Regulator architecture working selection

1. **24 V -> 5 V:** LMR51430-class 36-V, 3-A synchronous buck is a viable current-production candidate. TI specifies 4.5–36 V input and 3 A continuous output. Do not call it frozen until 24-V machine surge/transient protection is defined; a nominal 24-V cabinet can exceed 36 V during disturbances.
2. **24 V -> 3.3 V:** same LMR51430-class family is electrically plausible for the >=2.5-A target, subject to thermal/EMI calculation and the same input-transient caveat.
3. **3.3 V -> 1.1 V:** use a >=2-A synchronous point-of-load buck with power-good. TPS6213x-class adjustable 3-A parts are a candidate family; final exact suffix/topology must support 1.1 V and sequencing. Do not use the fixed-5-V TPS62133 suffix by mistake.
4. FPGA reset/output authority must remain inhibited until required rails and clocks are valid. Regulator power-good is a power witness, not proof of configured FPGA or valid LinuxCNC command freshness.

## Evidence notes
- TI AM26LV32E: 3.3-V quad RS-422 receiver, 17 mA max supply-current class.
- TI ISO674x: ~1 mA/channel DC typical, ~1.6 mA/channel at 1 Mbps typical; F-suffix provides default-LOW option.
- TI ADS7953: 12-bit 1-MSPS 16-channel SAR, ~11.5 mW typical product-page figure; datasheet conditions also show ~14.5 mW at 1 MSPS for 5-V analog/3-V digital operation.
- TI INA240: 2.4 mA max stated in description (product table gives 2.6-mA max class), 2.7–5.5-V supply.
- TI LMR51430: active 4.5–36-V, 3-A synchronous buck.

## What is deliberately not frozen
- exact ECP5 current consumption before representative gateware power estimation;
- exact RTL8211FI rail currents until final PHY reference data is captured;
- exact 5-V STEP/DIR dynamic current until transmitter/termination duty is frozen;
- machine-24-V surge suppressor and whether 36-V-input bucks have enough transient margin;
- isolated DC/DC MPNs before barrier/EMC geometry is defined.

## Next evidence action
Perform ECP5 BG256 bank/pin-budget reconciliation. That pin map determines VCCIO bank loading and is a prerequisite to replacing FPGA rail allocations with a real power-estimator run.
