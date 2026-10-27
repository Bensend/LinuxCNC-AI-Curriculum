# 4400-CLEAN-COMPOSE-01 — compressed-air blow-off + solvent residue + hot machine + queued normal output
2026-10-27 | Integrated documentary/source safety analysis | NON-GRADUATED; no new scored scenarios or physical tests.

## Distinct predecessor mechanisms, not new duplicates
- [AIR-CLEAN-01 OSHA nozzle/chip/worker audit](../research/4400_AIR_CLEAN_01_OSHA_DEADEND_CHIP_GUARD_MWF_NOISE_SOURCE_AUDIT_2026-10-27.md): static dead-ended cleaning nozzle <30 psi under OSHA 1910.242(b) scope, chip guarding and PPE, but no proof of aerosol or ignition control.
- [SOLVENT-CLEAN-01 official chemical/vapor audit](../research/4400_SOLVENT_CLEAN_01_OSHA_HSE_AQUEOUS_IGNITION_VAPOR_SOURCE_AUDIT_2026-10-27.md): flammable vapor/mist, skin/inhalation, contaminated waste and hot-work ignition are separate physical hazards.
- [Pinned LinuxCNC M62/M63 source/abort trace](../research/4400_AIR_CLEAN_01_LINUXCNC_PINNED_M62_M63_QUEUED_AIR_OUTPUT_SOURCE_TRACE_2026-10-27.md): normal output OFF is queued until next motion, and inspected tpAbort clears pending commands rather than proving a physical air dump.
- [MWF-MIST-01](4400_MWF_MIST_01_SPINDLE_STOP_VS_BREATHING_ZONE_CLEARANCE_FIELD_MODULE_2026-10-27.md): residual airborne aerosol after motion stop is a separate exposure route.

## Additional official source boundary
[OSHA shipyard chemical-removers eTool](https://www.osha.gov/etools/shipyard/ship-repair/surface-preparation/chemical-removers) states that even higher-flashpoint liquids can present fire/explosion risk when applied as a fine mist; **this is shipyard guidance, not a general-industry numeric rule**. [HSE dangerous-substances guidance](https://www.hse.gov.uk/fireandexplosion/about.htm) identifies flammable gases, mists and vapors. [HSE solvent vapor degreasing EIS47](https://www.hse.gov.uk/pubns/eis47.pdf) warns that manual spray-lance turbulence can increase vapor emissions in the equipment it addresses; no universal exposure/ventilation value is imported. These are **DOC-CONFIRMED in the stated source scopes**. The exact ignition behavior of an actual cleaner and process remains UNKNOWN.

## Coupled failure-path model (INFERENCE, not a simulated or observed event)
1. A worker cleans a solvent-wet component or machine cavity with compressed air because the sealed/aqueous cleaner is inconvenient. The nozzle may even meet the **dead-end pressure** criterion and have a chip shield.
2. The air jet disperses droplets/vapor into a nearby enclosure or low area. Neither nozzle pressure nor chip shielding measures the flammable or toxic atmosphere.
3. If an ordinary CNC output is wired to an air solenoid, an M62 ON can apply at motion start and an M63 OFF without a subsequent motion can remain queued. This exact LinuxCNC control semantics is **SOURCE-CONFIRMED at the pinned revision**; actual machine HAL/valve wiring is UNKNOWN.
4. E-stop or a normal CNC program stop can remove commanded motion without establishing that all hot surfaces, stored pneumatic energy, electrical ignition sources, vapor or contaminated waste are safe. A normal fan-ON status also cannot prove adequate capture or fan suitability in a potentially flammable atmosphere.
5. An operator opens a guard or a technician begins hot work believing 'machine stopped / air off / fan on' implies safe access. The missing independent chemical/ignition/energy witnesses create the hazard.

No numeric concentration, temperature, pressure, ventilation flow, stop time or machine safety PL/SIL is inferred. Do **not** claim OpenPressBrake uses solvent cleaning or automatic air blast.

## Four independent acceptance propositions
| Proposition | False evidence | Required selected-system evidence |
|---|---|---|
| Motion/guard safe for access | M5/E-stop/HMI | Independent physical stop/hold/guard/restart design and validation |
| Cleaning air physically safe | M63/M65/M9/HAL OFF | Selected nozzle dead-end pressure/chip/bystander protections plus actual air isolation/bleed for exposed service |
| Vapor/ignition/exposure controlled | No visible cloud, fan request ON | Exact chemical/SDS, physical release/ignition inventory, compatible rated ventilation and qualified exposure/flammability assessment |
| Maintenance and restart authorized | Reset bit, dry-looking part | Actual energy isolation, spill/waste control, hot-work approval where applicable, guards restored and deliberate fresh command |

## Human factors / lowest-friction controls
Make low-hazard contained/aqueous cleaning and a convenient waste/parts-wash station easier than improvised compressed-air solvent blow-off. If air drying is unavoidable, select a process compatible with the chemical and fire/exposure assessment, contain the discharge, maintain chip shielding, keep people out of the release path, and provide readily accessible physical isolation. Make a damaged/tampered nozzle easy to replace. Do not use a normal LinuxCNC bit or non-rated fan as a shortcut for independent safety design.

## Adversarial review, all documentary NOT RUN
A1: nozzle passes dead-end pressure but worker inhalation not assessed. A2: chip shield protects operator but solvent mist travels to a hot cabinet. A3: M63 queued OFF after last move, no selected HAL trace. A4: E-stop stops ram but not hot resistor. A5: ventilation fan status true but no airflow or ignition-suitability witness. A6: substitution to aqueous cleaner ignores electrical/corrosion compatibility. These are **unscored transfer prompts**, not six new graded cases or six new validation gates. Existing AIR-CLEAN 12/12 and SOLVENT-CLEAN 8/10 totals unchanged.

**Evidence:** DOC-CONFIRMED source-specific physical hazards, SOURCE-CONFIRMED normal LinuxCNC queue semantics, INFERENCE combined sequence, UNKNOWN selected machine, TEST-CONFIRMED none. No physical or local/hosted compute. G0/G1 HOLD; independent 2520–25F0 evaluation NOT RUN.


**M2/M30 misconception:** [Pinned LinuxCNC M2/M30 source countercheck](../research/4400_AIR_CLEAN_01_LINUXCNC_PINNED_M62_M63_QUEUED_AIR_OUTPUT_SOURCE_TRACE_2026-10-27.md) shows that program end explicitly stops spindle/coolant but does **not** explicitly reset motion DIO in inspected handlers. A machine-specific remap/PLC may do something else; no physical air-ON claim is made. Program end is not a universal air-energy isolation or solvent-ignition safe state.
