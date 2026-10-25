# 4400-ACC-NORM-01 — Shutdown vent OR isolate; special stored-energy exception; PED scope

**Status:** standards-scope source reconciliation, 2026-10-25, NON-GRADUATED. This is a **documentary boundary correction**, not a full licensed normative audit, legal opinion or selected-machine design approval. It addresses the difference between a Parker BA manual's automatic-fluid-discharge instruction and general hydraulic-system requirements.

## Sources and evidence quality

1. **ISO 4413:2010**, publisher record https://www.iso.org/standard/44781.html (English publication; alternate ISO publisher view https://www.iso.org/ru/standard/44781.html), **PUBLISHER-CONFIRMED scope/status**: 2010 edition addresses hydraulic systems/components, assembly, maintenance, reliable operation and hazards. Full paid normative clauses **NOT obtained**.
2. **EN ISO 4413:2010 / ISO 4413:2010 §5.4.3.2**, publicly viewable standards-preview excerpt https://www.iteh.us/catalog/standards/cen/43f4449e-0adc-46e7-8a01-e77ffdbdc389/en-iso-4413-2010 (also https://standards.theiteh.com/catalog/standards/iso/f9ba1fad-2f05-4239-a554-fe2835c08ceb/iso-4413-2010). **INDEXED PREVIEW-TEXT ONLY, NOT FULL LICENSED NORMATIVE INSPECTION** (direct iTeh open returned HTTP 502). The search-indexed excerpt distinguishes **automatic liquid-pressure venting OR positive accumulator isolation** at shutdown, and identifies special cases where pressure is needed after shutdown or the energy is not hazardous. Its exact applicability/edition and any national adoption must be confirmed against the controlled licensed standard during real design signoff.
3. **Parker HY10-2300-M1, BA bladder accumulator manual**, original PDF directly inspected: https://www.parker.com/content/dam/Parker-com/Literature/Accumulator---Cooler-Division---Americas/Catalogs---Bulletins/HY10-2300-M1_Bladder_Accumulators_Maintenance_and_Installation_Manual.pdf , printed p.17. **DOC-CONFIRMED for Parker BA installation guidance:** manufacturer asks for automatic hydraulic discharge on equipment OFF and attributes a safety-block requirement to EU PED 2014/68/EU. This is a **manufacturer instruction**; it is not by itself proof that every hydraulic system must use automatic venting in every mode.
4. **Directive 2014/68/EU**, EU-OSHA official scope summary https://osha.europa.eu/is/legislation/directive/directive-201468eu-pressure-equipment and official EUR-Lex legal text https://eur-lex.europa.eu/eli/dir/2014/68/oj . **Official EU-OSHA scope DOC-CONFIRMED**: pressure-equipment design, manufacture and conformity assessment with scope thresholds/essential requirements. Direct EUR-Lex reading was blocked by anti-bot JavaScript, so **no claim that the full Directive was inspected** or that it literally mandates a specific SAF valve or universal auto-bleed behavior.
5. **EN 14359:2017** publisher/seller scope https://www.nen.nl/en/nen-en-14359-2017-en-232909 : requirements for common gas-loaded accumulator pressure envelopes, safety equipment and documentation; this is not a press-brake safety-function validation.

## Reconciliation

**A — A machine-specific manufacturer instruction remains important.** Parker BA installation instructions call for automatic hydraulic discharge. Designers using that exact product must obtain the latest correct manual and resolve it with their full application, applicable rules and competent authority.

**B — General hydraulic design is not reducible to “always dump.”** The search-indexed ISO 4413:2010 §5.4.3.2 preview excerpt describes **venting or positive isolation** on shutdown and expressly contemplates special cases involving retained pressure. That does not mean retained pressure is automatically safe: hazard analysis, physical guarding/holding, clear isolation/maintenance instructions and appropriate residual-energy controls remain mandatory design questions. Do not apply the exception as a convenient excuse to leave dangerous pressure exposed.

**C — PED and ISO 4413 have different scopes.** PED concerns pressure equipment/assemblies and conformity; ISO 4413 concerns hydraulic system safety design. A vendor's attribution to PED does not substitute for checking the actual Directive, harmonized standards, and the installed machine's national requirements. Neither grants LinuxCNC/FPGA safety authority.

**D — E-stop, shutdown and servicing are different states.** An accumulator may support a protective stop, rescue movement or clamp function, but service isolation must still control all hazardous stored energy, including gas vessel, trapped cavities and gravity load. Any retained-pressure exception must have a separately justified SRS and a clear qualified maintenance path.

## Adversarial source questions

- What is the **exact** machine lifecycle state (protective stop, ordinary shutdown, maintenance LOTO, fire)? A general shutdown rule does not prove all four.
- Is the accumulator hazardous stored energy, protective energy, or both? Which physical event would fail if discharged?
- Does the selected circuit **positively isolate** the retained energy, and can it be safely discharged under individual maintenance control?
- What does the exact OEM product manual require, and which edition is installed?
- Is a quoted standards excerpt a **preview** or a controlled full normative copy? Do not self-certify from search snippets.

## Provenance / status

**DOC-CONFIRMED:** ISO publisher scope/status, EU-OSHA PED scope, Parker exact manual. **STANDARDS-INDEXED-PREVIEW ONLY (direct 502):** ISO 4413 §5.4.3.2 vent-or-isolate and exception language; not a full normative signoff. **INFERENCE:** lifecycle-specific SRS, positive isolation and qualified service design. **SOURCE-CONFIRMED new LinuxCNC:** none; **TEST-CONFIRMED:** none; **COMMUNITY-REPORTED:** none relied on. **UNKNOWN:** selected OpenPressBrake accumulator, actual retained-energy purpose, legal applicability, safety integrity, pressure zones, Y1/Y2 stop/hold and external evaluation. **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** No physical tests, compute or personnel-exposed operation.
