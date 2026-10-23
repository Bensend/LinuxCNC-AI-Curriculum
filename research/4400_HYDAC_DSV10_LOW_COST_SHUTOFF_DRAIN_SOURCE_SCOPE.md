# 4400 — Historical DSV10 combined shut-off/discharge: low-cost pattern, not a machine safety proof

**Status:** manufacturer historical architecture research only. HYDAC SAF/DSV brochure `E 3.551.17/08.03`, printed pp.10–11, https://www.hydac.com.au/pub/media/Ourcompanies/s/a/safetyvalveblocks.pdf. Do not infer current product availability, current regulatory compliance or selected-machine compatibility.

## Source-confirmed architecture

The historical HYDAC DSV10 is described as a **lower-cost three-way alternative** to SAF10. The manufacturer explains that switching the changeover ball valve shuts off the pump connection while simultaneously discharging the accumulator to tank. It identifies pump `P`, accumulator `S`, tank `T`, gauge `M`, a pressure-relief element and an optional solenoid-operated discharge. The manual distinguishes `DSV10 M`, `DSV10 EY` and `DSV10 EZ`, including opposite de-energized valve states for the two solenoid variants. The document also states that the three ports are momentarily interconnected during changeover (negative switching overlap).

These statements are **DOC-CONFIRMED only for the named historical document**. They establish a *real manufacturer architecture family* rather than a speculative sketch, but do not establish what happens in a press brake's cylinder/holding circuit or the physical outcome of switching under load.

## Safety review questions before treating compactness as a benefit

1. Does the selected hydraulic circuit tolerate the documented transition in which `P`, `S` and `T` can momentarily interconnect? What happens to pilot pressure and load holding? **UNKNOWN**.
2. Does the accumulator supply any required protective-cycle energy that a combined shut-off/discharge would prematurely remove? **UNKNOWN**.
3. Can the selected service procedure lock the valve in a correct isolating position and independently verify all downstream trapped volumes and gravity loads? **UNKNOWN**.
4. Does the actual installed product have the specified gauge, relief arrangement, port topology and independent physical witnesses? **UNKNOWN**.
5. Is a currently supported DSV10 variant available with up-to-date installation, pressure, temperature, reliability and applicable conformity evidence? **UNKNOWN; do not assume from a 2003 brochure**.

## Human-factors benefit and boundary

A combined shut-off/discharge mechanism may simplify plumbing and reduce the number of manual steps for a *suitable* circuit, potentially reducing maintenance error and bypass incentives. This is **INFERENCE**, not a parts-cost comparison or risk-reduction guarantee. A simplified control that creates uncontrolled motion or cannot be verified is not a safety improvement. Before proposing a real retrofit, use a fresh manufacturer catalog/manual and the machine's SRS, then independently validate pressure-zone witnesses, stop/hold behavior, lockout, restart and service access.

**No personnel-exposed operation, schematic freeze or simulation is authorized.** No PL/SIL, pressure, leakage or stopping-time value is inferred.
