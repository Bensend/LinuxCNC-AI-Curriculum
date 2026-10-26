# ACC-SEQ-02 — Emergency stored-energy reserve versus automatic pressure release: stop order is design-specific
**4400 safety architecture research; 2026-10-26; NON-GRADUATED.** Distinct from ACC-GAS-01 vessel-service hazard: this branch concerns **operating-state safety functions and the sequence of stopping, load support and bleed-down**. No installed OpenPressBrake hydraulic truth table is known.

## Sources inspected
- Parker Hannifin **HY10-2300-M1 (2026)**, BA Series manual p.3, original https://www.parker.com/content/dam/Parker-com/Literature/Accumulator---Cooler-Division---Americas/Catalogs---Bulletins/HY10-2300-M1_Bladder_Accumulators_Maintenance_and_Installation_Manual.pdf : identifies **maintaining fail-safe power to complete a safety cycle after pump/electric loss** as a possible accumulator purpose. This is a product application category, not proof of any particular circuit.
- Parker **AP piston accumulator product description**, official https://ph.parker.com/us/en/ap250em040h2k : emergency energy storage may complete an operation/hydraulic cycle on primary-source failure. Product family not established as installed.
- HYDAC **SAF catalog**, official exact-model page https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2203622 : type M manual bleed; type E adds optional solenoid-operated bleed; main shut-off, relief, manual bleed, optional gauge are distinct. Manufacturer notes recommend SAF with solenoid bleed when stored hazardous energy is present. **Recommendation is not a universal certified safety function.**
- HYDAC **PN 02068196 09/2011** original PDF https://betterfit-us.hydac.com/wp-content/uploads/Operating%20and%20Installation%20Instructions%20for%20HYDAC%20Accumulators.pdf p.4 shows SAF hydraulic schematic and optional features.
- OSHA 1910.147(d)(5)–(6), official indexed text https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 : covered servicing requires stored energy controlled and isolation verified; official direct fetch 403 this session.

## Evidence and critical contrast
| Proposition | Classification | What it does **not** prove |
|---|---|---|
| Accumulator **can** be designed to supply a safe completion cycle after pump loss | DOC-CONFIRMED Parker application | Does not mean an OpenPressBrake accumulator exists, that motion will be safe, or that capacity is sufficient |
| HYDAC SAF **M** is manually bled; **E** includes solenoid-operated bleed option | DOC-CONFIRMED exact manufacturer model family | Does not mean a fitted E valve is safety-rated, correctly wired, fail-safe on power loss or proven to discharge every trapped zone |
| Automatic bleed may reduce stored energy during shutdown | DOC-CONFIRMED OEM intended function | Does not establish physical safe state or timing under failed valve, blocked drain, shared supply or elevated gravity load |
| Dumping accumulator **before** a controlled safe-stop finishes could remove hydraulic energy that the selected architecture needs for its safe completion | INFERENCE from two documented, potentially competing intended uses | Actual dependency and timing require **selected schematic and qualified analysis**; no universal order |
| Maintaining stored energy indefinitely could allow unexpected actuation or hazardous service exposure | INFERENCE / covered LOTO principle | Exact exposure and response require circuit analysis |
| Pump off, CNC E-stop, bleed coil off and pressure switch low are not proof of ram physically stopped and supported | INFERENCE with existing course authority boundary | Must have independent physical witnesses |

## Failure-path matrix — documentary, NOT machine truth
1. **Power fails during a hazardous descent.** Does an accumulator intentionally supply a safe stop/return, or does its isolation/bleed prevent motion? **UNKNOWN**. Never presume either.
2. **E-stop commands pump off and bleed open immediately.** If a machine relies on reserve pressure for a protective transition, this sequence may be wrong; if the reserve can cause motion, retaining it may be wrong. Freeze both hypotheses until the actual safety requirement and fluid path are known.
3. **Solenoid-operated bleed loses its coil.** A de-energized coil is not evidence of spool position, unobstructed tank return, actual flow, or safe Y1/Y2 support. Independent diagnostics and physical proof required.
4. **Two accumulators share one SAF.** A gauge or bleed may not cover an isolated second branch. Enumerate all pressure zones and check/selector valves.
5. **Pressure falls but ram creeps.** Safe-stop command, hydraulic pressure, mechanical support and actual position are separate. No exposure.
6. **Maintenance bypass holds an accumulator charged.** Establish positive service isolation, durable bypass indication, access interlock, work permit and reset/rearm; never use ordinary LinuxCNC state as the sole interlock.
7. **Restoration of power while pedal remains pressed.** Require an independently validated deliberate fresh-start boundary; do not infer safe from pump-off or software reset.

## Design-review decision worksheet (all fields UNKNOWN until private qualified intake)
Record for each mode: hazard/people, energy zones and pressure sources, intended safe-state **physical** proposition, whether pressure is needed during transition, independent final element(s), mechanically restrained load, exact valve make/part and de-energized state, pressure-port locations, single-fault/CCF review, measured or design-proven response, reset/rearm and change-control. Separate **stop phase** from **safe retained state** and **maintenance isolation**. A sequence is not approved by merely selecting an E-stop category or drawing a LinuxCNC HAL net.

## Practicality
Choose proven correctly documented isolation/bleed hardware, accessible lockable maintenance isolation, readable pressure-zone labels and qualified proof ports; make safe service straightforward and bypass costly/inconvenient to sustain. Do not add a second PLC output that shares the same unproven power/valve as the supposed independent safety function.

**SOURCE-CONFIRMED LinuxCNC:** none new. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **UNKNOWN:** installed topology, valve fail positions, gravity support, PL/SIL, pressure/time/stopping performance. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.**
