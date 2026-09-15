# 4000 Colorlight core baseline — first source/hardware pass — 2026-09-15

Status: **FOUNDATION SOURCE PASS**

## Purpose

Establish whether the Colorlight family is a defensible known-good starting point for the reusable FPGA/Ethernet core rather than merely a cheap board with an FPGA.

## Pinned hardware evidence

Hardware reverse-engineering source: `q3k/chubby75` at commit `a1dcd4eb724a5f01fb3748b4d61d2f423b2b4d4b` (2025-05-30).

For Colorlight 5A-75B V8.0/V8.2 the documented architecture includes:

- Lattice ECP5-25 FPGA in BG256;
- SPI configuration flash;
- dual Gigabit Ethernet PHYs;
- SDRAM;
- 25 MHz clock;
- JTAG access;
- 3.3 V FPGA I/O domain and 1.1 V core supply;
- banks of 74HC245-class transceivers used for the original 5 V LED-panel interface.

The V8.0 reverse-engineering also exposes ECP5 sysCONFIG signals including PROGRAMN, INITN and DONE through resistor-accessible points, which is useful when designing deterministic configuration/reset supervision rather than treating FPGA configuration as an opaque event.

### Important non-copy warning

The stock Colorlight I/O transceiver arrangement exists for HUB75 LED-panel service. It is **not** automatically an industrial CNC field-I/O front end. The useful copy/adapt boundary is therefore the FPGA, clock, configuration, PHY and proven power-domain architecture; field I/O protection/isolation/receiver/driver circuits need their own machine-control contract.

## LinuxCNC-adjacent implementation evidence

`Peter-van-Tol/LiteX-CNC` is pinned here at `eee501c11d82862dce56d02aa57db4eb1fe5525f`. The project explicitly targets Colorlight 5A-75B/5A-75E among supported FPGA boards and provides LinuxCNC-facing GPIO, stepgen, encoder, PWM and watchdog-style modules over a LiteX/Etherbone architecture.

A pinned example configuration for 5A-75B V8.0 contains an explicit watchdog output plus mixed GPIO, stepgen/encoder/PWM resources. This is strong evidence that the ECP5 + Ethernet + open toolchain architecture is practical for CNC control, but LiteX-CNC is **not HostMot2**; its LinuxCNC driver/protocol architecture is different. The curriculum must not call a LiteX-CNC circuit or firmware path HostMot2 merely because the module concepts resemble HostMot2.

Community ColorCNC evidence independently reports LinuxCNC use of Colorlight 5A-75B/5A-75E with open-source Yosys/nextpnr firmware and Ethernet, including step generators, digital I/O and PWM. This supports the hardware family's practical LinuxCNC relevance while remaining community evidence rather than proof that any one firmware architecture should be copied wholesale.

## Core design decision after first pass

**Adopt Colorlight 5A-75B V8-class hardware as a primary reference architecture, not yet as a literal one-to-one schematic clone.**

Preserve first:

1. ECP5-25 class FPGA and open-source synthesis/place-route compatibility;
2. SPI configuration flash and accessible configuration/JTAG path;
3. 25 MHz clock / Ethernet PHY clocking architecture subject to PHY-specific review;
4. proven Gigabit Ethernet PHY-to-FPGA architecture;
5. 1.1 V core + 3.3 V I/O rail concept, with a new board-specific power/load calculation;
6. enough exposed FPGA I/O to support reusable machine-control blocks.

Do **not** blindly preserve:

- HUB75 connector pinout;
- output-only/bidirectional assumptions of the original 74HC245 arrangement;
- SDRAM unless the selected firmware architecture needs it;
- dual Ethernet PHYs unless a concrete redundancy/daisy-chain/use case justifies the second PHY;
- the original 5 V-only board input-power constraint if a better machine-controller power-entry architecture is selected.

## Firmware architecture remains an explicit fork decision

At least three concepts must remain distinct during 4000:

- upstream LinuxCNC HostMot2 architecture;
- ColorCNC/pluto-derived or other custom LinuxCNC FPGA firmware;
- LiteX-CNC's LiteX/Etherbone driver/firmware architecture.

The board can borrow proven Colorlight **hardware** without prematurely locking the firmware protocol. The next core pass should compare these firmware paths against requirements for LinuxCNC integration, watchdog behavior, latency/jitter, maintainability, open toolchain support and AI-generated board portability.

## USB-C implication

Colorlight's native baseline is JTAG/configuration plus Ethernet, not an integrated USB-C machine-control architecture. USB-C therefore should not be described as copied from Colorlight. Treat it as a separate service/programming/control-transport requirement whose role must be frozen before schematic design.

## Verification classification

- ECP5/PHY/flash/clock/power/JTAG architecture: `SOURCE-CONFIRMED` from pinned hardware reverse engineering.
- Colorlight LinuxCNC applicability: `SOURCE-CONFIRMED` for LiteX-CNC support plus `COMMUNITY-REPORTED` for ColorCNC field use.
- Suitability as the new board's core baseline: `ENGINEERING INFERENCE`, supported by open toolchain, inspectable hardware and multiple LinuxCNC-adjacent implementations.
- Industrial field-I/O suitability of stock Colorlight transceivers: **not assumed**.

## Next source task

Compare HostMot2-compatible/open FPGA firmware paths against LiteX-CNC/ColorCNC before freezing the FPGA register/protocol architecture. In parallel, extract the exact Colorlight V8 power/PHY/configuration circuit details needed for a copy/adapt schematic contract, then select whether one or two PHYs and whether SDRAM survive into the reusable board.
