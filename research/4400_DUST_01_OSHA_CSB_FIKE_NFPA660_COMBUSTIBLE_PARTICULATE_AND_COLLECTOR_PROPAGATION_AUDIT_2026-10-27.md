# 4400-DUST-01 — Combustible particulate, collector propagation, and ordinary-CNC authority boundary

**Study date:** 2026-10-27 UTC. **Status:** documentary source audit, NON-GRADUATED. **Applicability:** conditional to any machine producing/handling potentially combustible fine dust (wood routers/sanders, some metal grinding/powder operations, plastics, additive manufacturing). **OpenPressBrake applicability UNKNOWN:** do not assume it generates combustible dust or has an extractor. This is **4000 safety** cross-machine work, not a reopened 3000 specialization.

## Selection/novelty check

The complete 978-line canonical `safety-course/SAFETY_COURSE_INDEX.md` was inspected before choosing this work. No `dust explosion`, `combustible dust`, `dust collector`, `NFPA 660`, or `deflagration` module appears there. Existing `LASER-ENC/AIR` addresses optical/airborne contamination, `FLUID-FIRE` addresses hydraulic aerosol ignition, `PANEL/BOND` addresses electrical energy, `BLACKOUT` addresses egress; none establishes combustible-particulate collector isolation. This is a **new causal mechanism**, not a claim that fire, extraction or machine isolation was previously unknown.

## Original evidence and scope

| ID | Primary original source, publication/version and inspection | What it establishes | What it does NOT establish |
|---|---|---|---|
| DUST-S01 | OSHA *Combustible Dust: An Explosion Hazard* overview, official web-indexed 2026-10-27; direct open returned 403: https://www.osha.gov/combustible-dust | **DOC-CONFIRMED, indexed-only:** finely divided combustible materials, including some wood/metal/plastic dust, may be explosible; large stock-material behavior is not a reliable screen. | No measured explosibility of a selected machine's actual dust. |
| DUST-S02 | OSHA *Hazard Communication Guidance for Combustible Dusts*, official indexed text; direct open returned 403: https://www.osha.gov/publications/3371combustible-dust | **DOC-CONFIRMED, indexed-only:** fuel, oxidizer, ignition, dispersion and confinement; a primary event can resuspend deposits and cause secondary explosions. Mentions MIE, MEC and Kst as material-specific parameters. | No values for a selected dust, and no safe generic housekeeping thickness or collector design. |
| DUST-S03 | OSHA Revised Combustible Dust National Emphasis Program, CPL 03-00-008, **effective 2023-01-30**, indexed official directive/PDF: https://www.osha.gov/enforcement/directives/cpl-03-00-008 | **DOC-CONFIRMED, indexed-only:** agency inspection program includes wood, metal, plastics and other dusts; directive is an enforcement/inspection program. | Not a standalone universal equipment certification or an automatic legal requirement that every machine use a particular collector. |
| DUST-S04 | HSE *Fire and explosion* woodworking guidance, updated **2024-10-22**, **directly read**: https://www.hse.gov.uk/woodworking/fire.htm | **DOC-CONFIRMED, direct:** wood dust can burn/explode; extraction-system ignition is a design issue. Page cites 60 g/m³ for **wood flour** as an illustrative MEC. | **Not** a universal MEC, not transferable to another wood/material or machine; UK guidance not automatically binding US law. |
| DUST-S05 | US Chemical Safety Board Imperial Sugar investigation release **2009-09-24**, **directly read**: https://www.csb.gov/final-csb-report-on-imperial-sugar-disaster-concludes-inadequate-equipment-design-maintenance-and-housekeeping-led-to-massive-sugar-dust-explosions/ | **DOC-CONFIRMED, direct incident finding:** primary event likely inside enclosed conveyor, ignition by overheated bearing, secondary dust explosions; 14 killed, 36 injured reported in release. Confinement change and accumulations were causal factors. | Not evidence that a CNC dust collector shares the same failure geometry. |
| DUST-S06 | US CSB Hoeganaes fatal flash fires, final case study released **2012-01-05**, **directly read**: https://www.csb.gov/hoeganaes-corporation-fatal-flash-fires/ | **DOC-CONFIRMED, direct incident record:** three combustible-dust events at a powdered-iron facility over six months, five fatalities. | Not proof all metal chips are explosible; actual particle form/process matters. |
| DUST-S07 | Fike *Dust Collector Explosion Protection*, original manufacturer application explanation, **directly read 2026-10-27**: https://www.fike.com/explosion-protection/applications/dust-collectors/ | **DOC-CONFIRMED, direct OEM:** distinguishes collector-vessel venting/suppression from **inlet/outlet/connected-equipment isolation**, and passive versus active protective elements. Its manufacturer example includes ignition sources such as embers and electrostatic discharge. | Does not qualify a selected Fike model, response time, vent direction, duct length, dust properties, reliability, or an installed collector. |
| DUST-S08 | NFPA *NFPA 660 Standard Development* official current-edition catalogue, indexed **2026-10-27**; direct browser returned no readable lines: https://www.nfpa.org/codes-and-standards/nfpa-660-standard-development/660 | **DOC-CONFIRMED, publisher-indexed metadata only:** NFPA 660:2025 is active and consolidates NFPA 61, 484, 652, 654, 655, 664. | **Normative clauses NOT inspected**; no invented mandatory dust-hazard-analysis trigger, vent design, numerical acceptance limit, or legal adoption claim. |
| DUST-S09 | OSHA *Combustible Dust—Standards* official indexed page; direct open returned 403: https://www.osha.gov/combustible-dust/standards | **DOC-CONFIRMED, indexed-only:** federal OSHA points to multiple existing rules and General Duty Clause rather than one universal machine-specific dust rule. | Does not settle state/local adoption, fire-code edition, insurer conditions or a selected machine's jurisdiction. |

**Source-status discipline:** No source or product-specific claim is TEST-CONFIRMED. No LinuxCNC SOURCE-CONFIRMED claim is newly established in this audit. The Fike page is evidence that industrial protection architectures exist, **not** that a generic dust collector has those functions. No COMMUNITY-REPORTED assertions are needed. Manufacturer/standards metadata is not machine validation.

## Causal model: two distinct propagation paths

1. **Primary event:** combustible fines in a duct/collector/vessel + sufficient suspension/oxidizer + ignition and confinement. The exact material, size distribution, moisture, concentration, ignition susceptibility and geometry are **UNKNOWN** for an unselected machine.
2. **Secondary event:** a primary event can disperse accumulated dust in the room or propagate through connected ducts; the hazard can expand beyond the CNC enclosure or collector. The CSB Imperial Sugar investigation is an industrial example, **not** a CNC test.
3. **Normal controls:** CNC spindle/fan start/stop, filter differential-pressure indication, dust-extraction HMI, and ordinary PLC/FPGA I/O can control production and indicate maintenance conditions. **INFERENCE:** none of those signals independently proves that the dust is nonexplosible, an explosion is contained, or a protected duct path is isolated.
4. **Safety-related mitigation:** qualified collector protection, explosion vent direction/exclusion zone, appropriate isolation of connected ducts, fire/ignition management, approved material-specific collection, and inspection are separate physical functions to be engineered by competent personnel. A filter-efficiency percentage is not an explosion-isolation claim.
5. **Maintenance and human factors:** a collector that requires frequent hard-to-access cleaning, bypassed airflow alarms, compressed-air blowdown, or re-routing a duct for convenience invites predictable defeat. Redesign access, visible deposit inspection, approved cleaning, and convenient safe isolation. Never use normal CNC power-off alone as evidence that a collector is safe to open.

## Adversarial failure paths and false equivalences

| Counterexample | Unsafe inference to reject | Correct evidence needed |
|---|---|---|
| Dust-extractor fan is ON; filter gauge green | 'Dust explosion is prevented.' | Material-specific hazard characterization, ignition/accumulation review, protection design, maintenance status. |
| Collector has a vent panel | 'Flame cannot travel through the inlet duct.' | Selected duct isolation architecture and qualified design; vent location/discharge exclusion-zone analysis. |
| Router spindle stops when extraction faults | 'The collector is now physically safe.' | Separate collector residual ignition/smoldering, dust, pressure and maintenance isolation proof. |
| A shop vac works for wood dust | 'It is safe for combustible metal fines too.' | Material-specific collection/ignition compatibility and qualified equipment; no casual substitution. |
| Airborne exposure monitor looks good | 'No combustible dust hazard.' | Deposited/hidden dust, collector/duct and material-specific explosion evidence. |
| Dust has not burned before | 'The dust is noncombustible.' | Actual representative material evidence; absence of incident is not proof. |
| E-stop cuts normal machine power | 'Fire/explosion is suppressed or contained.' | Independent physical mitigation and safe response, not merely a CNC output state. |
| Enclosure is sealed to improve capture | 'Confinement always improves safety.' | Review confinement/venting and credible ignition/propagation effects; CSB conveyor example. |

## Cross-machine transfer and non-transfer

- **Routers/woodworking:** fine sawdust from sanding/routing, collectors, duct deposits and combustible accumulations are plausible; actual species/particle properties and collector layout still need assessment.
- **Grinding/metals:** metal dust hazards can be severe; distinguish fine dry powders from bulk stock or coarse chips. Do not mix materials or substitute wet/dry collection methods without qualified compatibility assessment.
- **Plasma/laser:** optical shielding, fumes/respiratory capture and combustible particulate fire/explosion are different propositions; assess the actual process and materials, not the machine label.
- **Mills/lathes/robots/automated cells:** only apply when the actual process creates/handles relevant combustible particulates; do not claim every machine has a dust hazard.
- **OpenPressBrake:** actual particulate-generating operations, dust extraction, collection, environment and protective devices remain **UNKNOWN**. This documentary module does not change the selected press-brake G0/G1 HOLD or its independent Y1/Y2 stop/hold/guard/hydraulic release priorities.

## No-lab decision and reopening evidence

No simulation or test is justified: the general dust explosion and propagation mechanisms are established by authoritative documents, while any unresolved values are **physical material/process-specific**. Do not attempt to create dust clouds, ignition or explosion experiments on the panel PC or in an occupied workshop. Reopen only on a real machine/process inventory with competent material test data, collector/duct layout, exact protection products, adopted standards/jurisdiction and safe commissioning/maintenance plan. Qualified verification must be performed under a controlled, isolated protocol; no personnel-exposed operation until independent machine safety gates are satisfied.

**State:** all documentary cases NOT RUN; physical `PHY/VAL/PT` UNKNOWN/NOT RUN; no machine release, no safety performance rating, no simulated or physical evidence.
