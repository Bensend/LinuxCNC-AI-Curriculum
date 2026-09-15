# 4000 core PHY / clock / power BOM — 2026-09-15

Status: WORKING BOM FREEZE; exact PCB values still require datasheet/ERC/layout review.

## Ethernet PHY

Working exact family: **RTL8211FI-CG**, industrial-temperature RGMII Gigabit PHY, QFN40.

Reasons:
- preserves the proven Colorlight RTL8211F-family architecture;
- industrial-temperature variant is preferable for a machine controller;
- RGMII directly fits the ECP5/LiteX-CNC direction;
- supports 3.3/2.5/1.8/1.5 V RGMII signalling;
- supports a 25 MHz external crystal or oscillator and provides the MAC-side clocking needed by RGMII;
- integrated internal core regulator means the board does not need to create a separate external PHY 1.0/1.1 V rail merely because older/reference implementations expose one.

Do not substitute another RTL8211 package/variant without rechecking straps, pinout, internal-regulator mode, reset and RGMII voltage.

## Clock plan

Freeze a **dedicated 25.000 MHz, 3.3 V CMOS oscillator** as the board master/reference clock class rather than deriving FPGA clock from PHY CLKOUT.

Required oscillator envelope:
- 25.000 MHz;
- 3.3 V CMOS output;
- <= ±50 ppm over operating range (prefer ±25 ppm or better if BOM-neutral);
- -40 to +85 C or better;
- low-jitter part appropriate to FPGA/Ethernet reference use.

The RTL8211F datasheet allows external 25/50 MHz clock and specifies 40–60% duty cycle and 200 ps maximum broadband peak-to-peak jitter. The exact oscillator MPN remains a procurement/lifecycle selection, not an architectural unknown.

Clock ownership rule: FPGA operation and watchdog authority must not disappear merely because the Ethernet PHY is held in reset. Feed the dedicated clock to the FPGA and derive/distribute the PHY reference deliberately; do not reproduce Colorlight's PHY-dependent FPGA clock ownership cycle.

## FPGA rails

Retain **1.1 V ECP5 core** and **3.3 V I/O/logic**. Omit SDRAM-only/reference rails unless later bank/peripheral allocation creates a real requirement.

Working regulator class: modern synchronous bucks with >=2 A design capability for 1.1 V core and >=2 A for 3.3 V logic, with explicit power-good/enable where practical. Do not copy TLV62565-class devices by footprint alone. Final exact MPN is held until the whole-board 3.3-V load budget includes FPGA I/O, isolator logic, Ethernet PHY, ADC and driver logic.

The ECP5 evaluation-board evidence shows ampere-class core rails; therefore the design must calculate rail load from the selected ECP5-25 package/gateware and not size from quiescent current.

## PHY reference implementation details to carry forward

An inspectable RTL8211F-CG production schematic (Rock 4 SE) uses:
- 25 MHz crystal reference;
- 22-ohm series damping on a MAC clock path for 3.3-V RGMII;
- local decoupling called out by PHY pin groups;
- explicit magnetics/connector and strap networks.

These are topology evidence, not permission to blindly copy every value. The selected RTL8211FI datasheet/reference design controls strap, magnetics, termination, reset and decoupling values.

## Power-entry boundary

Do not feed 24-V machine power into Colorlight-style low-voltage rails directly. Required chain remains:

`24 V machine logic supply -> reverse/transient/fuse protection -> logic pre-regulator -> 3.3 V + 1.1 V point-of-load rails`

Field-output power and logic power remain separately fused/observable domains even if sourced from the same cabinet 24-V supply.

## Verification before schematic freeze

1. Whole-board 3.3-V current budget.
2. ECP5-25 1.1-V current estimate using actual LiteX build/utilization.
3. RTL8211FI strap/reset/internal-regulator reference circuit from the exact datasheet revision.
4. RGMII bank voltage and ECP5 pin allocation.
5. Oscillator fanout/loading; add a clock buffer only if required by the chosen topology.
6. Controlled-impedance RGMII/MDI layout rules and uninterrupted reference planes.
7. Power sequencing/PG behavior must leave outputs inhibited until FPGA watchdog/output authority is explicitly armed.

## Sources checked

- Realtek RTL8211F(I)/RTL8211FD(I) datasheet: 25/50-MHz external oscillator support; ±50-ppm frequency tolerance; 40–60% duty; 200-ps broadband p-p jitter; RGMII and MDIO semantics.
- Rock 4 SE RTL8211F-CG schematic: inspectable 25-MHz crystal, RGMII damping and PHY support circuitry.
- Lattice ECP5 evaluation-board schematic: confirms ampere-class FPGA core rail design rather than tiny logic-regulator assumptions.

No simulation is justified for this digital core. Verification is schematic/ERC, clock/reset/power-budget review, PCB SI/layout review and hardware bring-up.