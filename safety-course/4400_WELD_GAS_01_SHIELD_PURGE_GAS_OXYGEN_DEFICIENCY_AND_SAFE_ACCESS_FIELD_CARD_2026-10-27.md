# 4400-WELD-GAS-01 — welding cell: arc stopped, but is the air safe?

**Technician/qualified-reviewer module | 2026-10-27 | PUBLIC PAPER ONLY / UNSCORED | NO TESTS OR MACHINE RELEASE**

## The deceptively safe-looking situation
A robot or CNC weld sequence ends. The arc is off, motion is stopped and the gate opens. A worker reaches into a large fabrication to retrieve a purge dam. Shielding/purge gas may still be escaping from a hose, trapped inside the fabrication or collecting in a nearby low pit. **Arc OFF is not gas isolation or breathable-air evidence.** HSE documents gas entry through weld roots, leaks and low-area migration; NIOSH FACE 88-20 documents a fatal argon-leak investigation. [Source audit](../research/4400_WELD_GAS_01_SHIELDING_GAS_OXYGEN_DEFICIENCY_SCREEN_VENTILATION_AND_RESCUE_SOURCE_AUDIT_2026-10-27.md).

## Five different controls, five different questions

| Control boundary | Useful physical question | What cannot answer it |
|---|---|---|
| Robot/arc motion | Is hazardous movement/arc generation physically prevented during access? | A normal M-code, program pause or `weld-done` bit alone |
| Shield/purge gas | Is every relevant supply/purge branch isolated and downstream gas handled? | A gas solenoid command alone |
| Breathable atmosphere | Are the actual workpiece/low pit/entry zones assessed and monitored as required? | Arc OFF, fan ON, or a single remote oxygen sensor |
| Extraction and fire | Does ventilation/capture actually work, and are spark/duct/hot-work hazards addressed? | Fan output bit; a universal E-stop fan policy |
| Access/restart/rescue | Is the person protected against unplanned motion, atmosphere changes and unsafe rescue? | Reset or guard-closed indication alone |

**Do not confuse legal scopes.** US [29 CFR 1910.146](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146) defines oxygen-deficient atmosphere below **19.5%** in its permit-space framework. That is **not** a universal proof that 19.5% or any single reading makes all machine access safe. [29 CFR 1910.252](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-Q/section-1910.252) separately addresses welding ventilation, arc-ray screens, fire watch and confined-space conditions. Its **30-minute minimum fire-watch** clause, where applicable, is **not** an atmosphere-clearance timer.

## Make the safe workflow easier
Use remote viewing and retrieval tools rather than reaching into gas-purged cavities; put isolation and status where maintainers can actually reach and understand them; route gas services away from accessible pits where feasible; keep welding screens effective **without obstructing necessary ventilation**. Show distinct **ARC STOPPED / GAS ISOLATED / ENTRY CLEARED / FIRE WATCH** states, not one green READY light. A guard that must be defeated to inspect a weld is a design problem to fix, not an acceptable routine.

## Desk-only adversarial review (NOT RUN, not scored)
A technician says: *“The E-stop dropped the welding contactor, so the gas leak is gone and I can enter.”* A competent reviewer should **reject the inference** and request actual gas-path/isolation, atmosphere, ventilation/fire, entry and restart evidence. No live leak creation, gas release, confined-space entry or simulated rescue is authorized by this module. The correct physical witness depends on the selected cell and qualified site assessment.

## Source and boundary
Original [UK HSE welding-asphyxiation guidance](https://www.hse.gov.uk/welding/asphyxiation-hazards.htm), [NIOSH FACE 88-20](https://stacks.cdc.gov/view/cdc/164574) and US [eCFR 1910.252](https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XVII/part-1910/subpart-Q/section-1910.252) directly reviewed; [Miller OEM manual](https://www.millerwelds.com/files/owners-manuals/o264152a_mln.pdf) manufacturer-indexed excerpt only (direct PDF unavailable). Existing [MWF](../research/4400_MWF_01_02_NIOSH_HSE_OSHA_MIST_SKIN_MICROBIAL_EXPOSURE_SOURCE_AUDIT_2026-10-27.md) and [laser air](../research/4400_LASER_AIR_02_NIOSH_TRUMPF_CAPTURE_VS_FILTER_AND_RADIATION_INDEPENDENCE_SOURCE_AUDIT_2026-10-26.md) work addresses related extraction but not gas-displacement entry. This is **new gas-specific physical hazard**, not new personnel-safety authority for LinuxCNC.

**Installed equipment, gas, atmosphere, physical validation and independent evaluator: UNKNOWN/NOT RUN.** No new public case bank, no scored exam, no simulation, no machine test. OpenPressBrake **G0/G1 HOLD**; no personnel-exposed hazardous operation.
