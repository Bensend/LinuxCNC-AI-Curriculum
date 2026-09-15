# 4000 ECP5-25 BG256 FPGA pin budget — first pass

Status: CAPACITY PASS COMPLETE; EXACT BALL/BANK PLACEMENT STILL OPEN
Date: 2026-09-15

## Device baseline
Working device remains LFE5U-25F BG256, preferably industrial-temperature suffix for the controller variant. Public device summaries identify **197 single-ended user I/O** for the BG256 package. The Colorlight 5A-75B V8 reference uses this same ECP5-25/BG256 class and demonstrates RGMII Ethernet, SPI flash, JTAG and a large external I/O population on the package.

## Required FPGA-facing signals
This count is intentionally conservative and counts each ordinary FPGA pad, not external connector conductors.

| Interface | FPGA pins | Notes |
|---|---:|---|
| one RGMII PHY | 15 | TXD[3:0], TX_CTL, TXC = 6; RXD[3:0], RX_CTL, RXC = 6; MDC, MDIO, PHY_RESET = 3. PHY interrupt optional/not counted. |
| four encoder channels A/B/Z | 12 | receiver outputs only; differential pairs terminate in external AM26LV32E receivers |
| six-axis STEP/DIR | 12 | STEP + DIR logic per axis; differential conversion occurs in external transmitters |
| 24 digital inputs | 24 | conservative one FPGA input per isolated field input |
| 16 digital outputs | 16 | one watchdog-gated command per smart high-side output before isolation |
| generic PWM/PDM | 4 | minimum frozen allocation |
| four proportional-current gate commands | 4 | current-loop actuator command to gate-driver authority logic |
| four proportional-current hardware-fault witnesses | 4 | independent OC latch/status returned to FPGA; hardware trip itself does not depend on FPGA |
| shared ADS7953 SPI | 4 | SCLK, MOSI, MISO, CS; optional busy/alarm/GPIO not counted |
| board health / rail / watchdog witnesses | 6 | working reserve for PG/reset/fault/configuration observations |
| service UART | 2 | TX/RX |
| spare expansion GPIO | 8 | deliberate reserve, not yet connectorized |
| **Application subtotal** | **111** | conservative working count |

### Dedicated configuration/service resources
JTAG TCK/TMS/TDI/TDO and SPI configuration pins must be reconciled against dedicated/dual-purpose package pins and are **not** blindly added to the 111 application subtotal. The Colorlight V8 evidence shows JTAG and SPI flash coexist on BG256. Exact board ball assignment must preserve configuration-mode requirements and avoid consuming pins needed during boot.

## Capacity conclusion
Against 197 user I/O, the 111-pin application budget leaves a nominal **86-user-I/O capacity margin (~44%)** before exact bank/dual-purpose restrictions. Therefore raw package pin count is **not presently a blocker**.

This does **not** prove routability or legal bank placement. The next placement pass must check:
- RGMII clock/data pins against timing-capable bank resources and LiteX platform constraints;
- all VCCIO bank voltages;
- dedicated clock inputs for the independent 25-MHz oscillator;
- configuration/JTAG dual-purpose behavior;
- simultaneous-switching-output concentration, especially STEP/DIR and DIO command banks;
- PCB escape/routing from 14-mm BG256;
- whether any desired FPGA-native differential resource is actually required (present encoder/STEP interfaces convert externally, so they do not consume FPGA differential pairs).

## Bank-voltage direction
Keep FPGA-facing ordinary logic at **3.3-V LVCMOS** wherever the selected external parts permit it. This includes encoder-receiver outputs, isolator logic sides, STEP/DIR transmitter inputs and SPI control. RGMII PHY I/O voltage must be frozen from the exact RTL8211FI strapping/reference design before bank placement; do not assume its bank voltage merely because other logic is 3.3 V.

A single-voltage 3.3-V field-facing logic strategy reduces bank fragmentation, but it is subordinate to the PHY electrical contract and ECP5 bank rules.

## Colorlight evidence reused, not copied blindly
The V8 board demonstrates one ECP5-25 BG256 connected simultaneously to two RGMII PHYs, 32-bit SDRAM, SPI flash and many HUB75 outputs. Our controller removes the SDRAM and second PHY, so the package has substantially less high-speed pin pressure than the reference. That is strong feasibility evidence, but exact Colorlight ball assignments should be copied only for the retained PHY/configuration functions when compatible with our dedicated-clock change.

## Promotion to exact placement
Before schematic generation, produce a machine-readable pin-allocation table containing:
`net | FPGA ball | bank | VCCIO | direction | IO standard | clock-capable? | boot/config conflict? | external device pin | notes`

Do not let schematic AI assign arbitrary FPGA balls. Pin placement is an engineering input to schematic generation, not an aesthetic cleanup step.
