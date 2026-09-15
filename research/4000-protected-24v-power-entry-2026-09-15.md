# 4000 protected 24-V controller power entry — first freeze

Status: ARCHITECTURE FROZEN; FINAL TVS/eFuse VALUES REQUIRE EMC TARGET
Date: 2026-09-15

## Why the prior 36-V buck candidate is not the preferred baseline
A nominal industrial 24-V rail is not a guarantee that a converter input will remain below 36 V during wiring transients or surge tests. TI's PLC-controller TIDA-03031 explicitly treats a 19.2–28.8-V source as needing reverse-polarity, over/undervoltage and surge protection, and demonstrates ±500-V IEC 61000-4-5 surge compliance at the system input. Therefore a 36-V buck can be used only behind a proven clamp; it should not be the default part chosen before the input-protection envelope is known.

## Working input chain
`24V_CTL_IN -> service fuse -> reverse-polarity / reverse-current protection -> TVS/clamp node -> EMI filter -> protected 24V_LOGIC -> local bucks`

Required witnesses:
- raw input present;
- protected input in valid UV/OV window;
- 5-V/3.3-V/1.1-V power-good;
- FPGA configured/clock-valid;
- LinuxCNC command freshness/watchdog healthy.

These are not interchangeable. A valid 24-V rail does not authorize outputs by itself.

## Converter direction change
Prefer **65-V-class input converters** for the first board rather than 36-V parts. This reduces dependence on a razor-thin TVS clamp while retaining a separate input protection network.

For the two high-current controller rails, **TLVM65030-class** 65-V/3-A synchronous buck modules are a strong working candidate because they cover the >=2.5-A 3.3-V and 5-V design targets with 3–65-V input capability. Their integrated-inductor module form also reduces first-board layout risk. This is a cost/layout trade, not a claim that modules are mandatory for later production optimization.

For lower-current branches, LMR36520-class 65-V/2-A devices provide 4.2–65-V operation and tolerate input transients up to 70 V; TI specifically positions the family for rugged industrial supplies and IEC 61000-4-5 surge-immunity designs. It is suitable where the actual rail budget remains below 2 A.

The 1.1-V FPGA core remains a downstream point-of-load rail from 3.3/5 V, not a separate 24-V conversion, so its converter can be optimized for low-voltage efficiency, sequencing and power-good.

## Protection rules for schematic generation
1. Do not connect nominal 24 V directly to a 36-V-max buck and call the board industrial.
2. Do not rely on the buck's absolute maximum as the surge clamp.
3. Reverse-polarity protection must not use a series diode by default if its loss materially heats the board; evaluate ideal-diode/eFuse topology first.
4. TVS stand-off, clamp voltage and pulse rating remain tied to the selected EMC/surge target and upstream cabinet impedance. Schematic AI must not invent them.
5. Place the TVS current loop and bulk/ceramic input energy path at the connector/protection boundary, not through FPGA/analog ground routing.
6. Field-output 24 V and proportional-coil 24 V remain separately protected/distributed actuator domains. The controller logic input fuse must not be assumed to protect field wiring groups.
7. Brownout/UVLO must result in deterministic FPGA/output inhibit; a recovering rail requires normal output-authority rearm.

## First-board preference
Use the higher-VIN margin even if it costs slightly more on revision A. Once actual cabinet transient measurements and EMC tests exist, later cost reduction may replace module converters with discrete 65-V bucks or a lower-voltage converter behind a proven clamp. Cost reduction must follow evidence rather than remove transient margin speculatively.

## Remaining exact-value work
- define target IEC 61000-4-5 test level and source impedance for the intended controller category;
- choose reverse-polarity/eFuse part and UV/OV thresholds;
- choose TVS from required stand-off, clamp at pulse current and converter margin;
- size fuse from worst-case steady input current plus inrush and downstream fault selectivity;
- perform conducted/radiated EMI layout review around both high-current bucks;
- verify thermal rise at 24 V nominal and minimum/maximum intended cabinet voltage.
