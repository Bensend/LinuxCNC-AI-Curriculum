# 4000 Colorlight V8 core copy/adapt contract

Status: WORKING HARDWARE BASELINE — 2026-09-15

## Reference

Primary reverse-engineering reference: q3k/chubby75 Colorlight 5A-75B V8.0/V8.2 family. This is a proven board topology reference, not permission to copy unrelated LED-panel I/O assumptions.

## Copy/adapt directly

### FPGA

- Lattice ECP5-25, V8-class reference package BG256 (`LFE5U-25F-*BG256*`).
- Preserve the ECP5 sysCONFIG/JTAG concept and open-toolchain compatibility.
- Preserve explicit JTAG access: TCK/TMS/TDI/TDO plus nearby 3.3 V reference and GND.
- Preserve accessible PROGRAMN, INITN and DONE behavior/test points; V8.0 reverse engineering shows these pulled up to 3.3 V.

### Configuration flash

- Proven reference: Winbond W25Q32JVSIQ, 32 Mbit SPI NOR at 3.3 V.
- Preserve direct ECP5 sysCONFIG SPI topology: CS# N8, SO T7, SI T8, clock on the ECP5 CCLK/MCLK pin N9; WP# and HOLD# high.
- Keep programming/recovery access independent of the LinuxCNC Ethernet transport.

### Ethernet PHY

- Use **one** Gigabit Ethernet PHY in the RTL8211F/FD/FP family or a currently available pin/function-equivalent chosen after BOM lifecycle review.
- Preserve RGMII-class FPGA/PHY interface and MDIO/MDC/reset management concept from the proven V8 architecture.
- Do **not** populate the second Colorlight PHY merely because the LED receiver card has redundant/cascade Ethernet. LinuxCNC control needs one dedicated interface; the second PHY has no current requirement.
- Magnetics, termination, strap resistors, reset timing and decoupling must follow the selected PHY datasheet/reference design, not reverse-engineered values by guess.

### Clock — adapt, do not copy literally

The V8.0 reference derives/distributes a 25 MHz clock from PHY1 to PHY0 and FPGA and explicitly warns not to reset the PHY if gateware depends on that clock.

For the CNC controller, **do not make the FPGA system clock depend on a PHY remaining out of reset**. Use a dedicated oscillator/clock source suitable for ECP5/LiteX and feed the PHY reference as required by the selected PHY architecture. This removes a needless ownership cycle between communication reset and FPGA clock availability.

### Power rails

Colorlight V8.0 demonstrates the basic ECP5 rails using small synchronous buck converters compatible with TLV62565/6-class parts:

- 1.1 V FPGA core;
- 3.3 V FPGA I/O and board logic;
- V8.0 also has a 1.0 V reference/SDRAM-related rail.

Our controller SHALL retain only rails actually required by the selected FPGA/PHY/logic. With SDRAM omitted, do not automatically copy the V8.0 1.0 V rail. Final rail sequencing, capacitance and current margin must be checked against ECP5 and PHY datasheets.

The Colorlight board accepts a low-voltage ~5 V input. Our industrial controller may have a higher machine-side input domain; therefore the Colorlight 5 V entry is **not** the machine power-entry design. If the board accepts 24 V field power, create a separate protected 24 V -> logic pre-regulator domain before the copied/adapted low-voltage FPGA rails.

## Explicitly omit from baseline

### SDRAM

Omit the ESMT M12L64322A SDRAM by default. The current LinuxCNC realtime register/control architecture does not establish a need for framebuffer-style external memory. Removing it reduces routing, rail/load and firmware complexity. Re-add only for a concrete feature with a memory budget.

### Second PHY

Omit. Re-add only if a defined architecture requires network redundancy, daisy-chain switching, isolated service networking, or another measured need. Do not infer CNC safety from the Colorlight display card's dual-port redundancy feature.

### HUB75 / 74HC245 front end

Do not copy as CNC field I/O. The V8 reverse engineering notes that the output transceivers are powered from 5 V while ECP5 I/O is not 5-V tolerant and warns about protection assumptions. Industrial inputs/outputs require their own voltage, transient, isolation/protection and fault contracts.

## Working core architecture

`protected logic supply -> 3.3 V + 1.1 V rails -> ECP5-25`

`dedicated oscillator -> ECP5 / PHY clock architecture`

`SPI NOR <-> ECP5 sysCONFIG`

`JTAG/service header -> ECP5`

`one GbE PHY <-> magnetics/RJ45 <-> dedicated LinuxCNC NIC`

`ECP5 fabric -> watchdog/output-authority gate -> machine-facing I/O blocks`

The watchdog/output-authority gate is architectural. Machine-facing blocks must not rely only on host software deciding to write zero.

## Firmware implication

The current working firmware choice is LiteX-CNC, subject to freshness/output-gating hardening recorded in `research/4000-firmware-protocol-comparison-2026-09-15.md`. This makes one PHY and no SDRAM the minimum sensible baseline.

## USB-C role

Freeze USB-C as **service/program/debug power/data only for now**, not the realtime LinuxCNC control transport. Realtime machine control remains dedicated Ethernet. USB-C may later expose JTAG/UART/DFU/service functions through a deliberate interface circuit, but it must not create a second implicit command-authority path.

## Open items before schematic freeze

1. Select the exact currently procurable RTL8211 variant or equivalent and reproduce its datasheet reference circuit.
2. Select the dedicated oscillator frequency compatible with the chosen LiteX/ECP5/PHY clock plan.
3. Calculate ECP5/PHY rail currents and select current-production regulators rather than copying TLV62565-class parts solely by footprint.
4. Define protected machine power entry and separation between logic and field/output power.
5. Define hardware-level watchdog/output-enable distribution into every output-producing block.
6. Complete FPGA bank-voltage/pin allocation after encoder, step/dir, GPIO, PWM/analog and proportional-current interface counts are frozen.

## Verification

No circuit simulation is justified for this copied digital core. Verify with schematic/ERC review, datasheet rail/clock/reset checks, power-budget calculation, signal-integrity/layout rules for RGMII and hardware bring-up tests. Reserve simulation for genuinely uncertain analog/current/transient behavior.
