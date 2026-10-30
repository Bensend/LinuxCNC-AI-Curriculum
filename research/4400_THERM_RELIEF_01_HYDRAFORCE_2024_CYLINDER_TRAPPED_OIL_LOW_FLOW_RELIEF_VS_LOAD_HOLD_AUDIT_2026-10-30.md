# 4400-THERM-RELIEF-01 — A load-holding check can include a pressure-release path, but that path is not dynamic overpressure protection
**2026-10-30 | 4400 Safety / existing HOLD-01 and 2580 | ORIGINAL MANUFACTURER DOCUMENTS | NON-GRADUATED | NO MACHINE RELEASE**

## Exact engineering question and novelty audit
What happens when hydraulic oil is trapped in a cylinder-side chamber behind a check valve, then heats while the machine is stopped? Does a catalog label "load holding with thermal relief" establish dynamic pressure-spike protection, zero leakage, safe gravity-load holding, or maintenance isolation?

Direct review of the current canonical safety index, research plan, PROGRESS, HOLD-01, HYD-HOLD-01 and 2026-10-30 POC-PAIR/IH04 predecessors found prior pilot-check load transfer, shock relief, accumulator and maintenance isolation lessons. The **specific manufacturer-documented low-flow thermal-relief passage versus dynamic relief, its directional porting and load-holding tradeoff** were not indexed. Integrate this into existing HOLD-01, not a new scored competency or a proposed OpenPressBrake valve selection.

## Original manufacturer sources and exact edition
All four PDFs were directly opened from **HydraForce's own domain**; their printed product sheets identify **25SEP2024** and exact model. A catalog datasheet is a **component-level manufacturer claim**, not a selected circuit drawing, certificate or physical test.

1. [PC10-38 pilot-operated check with thermal relief, 25SEP2024, pp.1–3](https://www.hydraforce.com/globalassets/2.-products/product-pdf-files/pc10-38_25sep2024_16-37.pdf): pp.1–2 describe 3:1 pilot-operated load-holding check, flow **2→3** permitted, reverse **3→2** normally blocked, and a *small* 3→2 thermal-relief flow above the selected thermal setting. Explicitly **not for dynamic pressure limiting**. Published internal leakage maximum 0.25 mL/min at specified 241 bar; this is a component rating, not zero machine drift. p.3 lists multiple relief-setting options; none selected here.
2. [CV10-28 check with thermal relief, 25SEP2024, pp.1–3](https://www.hydraforce.com/globalassets/2.-products/product-pdf-files/cv10-28_25sep2024_16-40.pdf): free flow **1→2**, normally blocked **2→1**, small thermal relief **2→1** above setting. Explicitly **not dynamic pressure limiting**. This is not the same port numbering as PC10-38.
3. [TR04-B20 thermal relief, 25SEP2024, pp.1–3](https://www.hydraforce.com/globalassets/2.-products/product-pdf-files/tr04-b20_25sep2024_16-43.pdf): a *separate* thermal-relief cartridge intended for temperature-induced cylinder pressure intensification; expressly **not a general relief valve or load-induced spike protector**. p.1 says port-2 pressure is additive to the relief setting and port 2 should not exceed 34.5 bar above port 1. This is **specific to TR04-B20**; do not transfer the numeric limit to PC10/CV10 or the press.
4. [DC10-40 dual pilot check, 25SEP2024, pp.1–3](https://www.hydraforce.com/globalassets/2.-products/product-pdf-files/dc10-40_25sep2024_16-44.pdf): thermal relief is an **option**, described specifically **from port 4 to 3**. The existence of a thermal option in a product family does not prove a particular ordered valve includes it. Catalog check-seat and thermal leakage figures are distinct.

The source descriptions refer to *temperature-induced pressure intensification*, not a measured temperature/pressure trajectory on any installed machine. No PDF hashes, serial numbers, selected setting, certificate, circuit, or laboratory data are claimed.

## Four physical propositions that must not be collapsed
| Proposition | What the OEM establishes | What remains unproved |
|---|---|---|
| A. Normal load-holding check | A stated direction is blocked except leakage and optional relief paths; PC10-38 includes pilot release | Installed orientation, leakage over time, actuator-side hose integrity, sustained ram holding under fault |
| B. Slow trapped-fluid thermal overpressure | PC10/CV10 integrated relief and TR04 offer small/low-flow release paths above a selected threshold | Whether an actual trapped zone can discharge into a suitable lower-pressure path, selected setting, temperature history |
| C. Dynamic load-induced overpressure | OEM explicitly excludes low-flow thermal function as dynamic protection | Appropriately sized/rated relief for pressure spikes, intensification, cylinder/circuit strength and transient validation |
| D. Personnel-protective stop, hold and service isolation | **Not claimed** by any of these catalog pages | Independent safety logic, valve final elements, mechanical support, energy isolation, trapped-pressure verification, restart prevention |

**Failure path F1 — heat while stopped (DOC + INFERENCE):** pump OFF and normal directional valve centered; a cylinder-side volume is trapped; temperature rises and pressure may intensify. A thermal-relief path *could* pass a small volume above its selected setting, but the return side may itself be isolated or pressurized. The exact resulting pressure and movement are **UNKNOWN**. A main system pressure gauge or HMI "pump off" does not identify every isolated cylinder chamber.

**F2 — pressure spike (DOC-CONFIRMED limitation):** a load-induced shock occurs faster than a low-flow thermal passage can be assumed to relieve. PC10-38/CV10-28/TR04-B20 manufacturer language specifically excludes dynamic-pressure protection. Never substitute thermal relief for qualified dynamic pressure protection.

**F3 — load-holding tradeoff (INFERENCE):** an intentionally opening thermal path can release oil from a load-bearing chamber. Whether this causes ram drift depends on actual geometry, circuit paths, gravity, load, valve leakage and independent support. Do **not** assert that a listed valve necessarily drops a press ram; equally do **not** assert zero displacement from its check-valve label.

**F4 — wrong port/variant (DOC + INFERENCE):** PC10-38 3→2 relief, CV10-28 2→1 relief and optional DC10-40 4→3 relief are not interchangeable. Wrongly identifying a port, ordered option or return-pressure condition can leave a trapped zone without intended thermal relief or create an unintended release path. No generic hydraulic truth table or numeric relief setting is justified.

**F5 — service false zero (INFERENCE):** pump shutdown, one gauge reading, a thermal-relief cartridge or a check-valve symbol do not prove all stored hydraulic energy is dissipated. Physical restraint and qualified isolation/verification remain separate from protective stopping and from normal control.

## Practical no-energy review for qualified engineer
Use only existing restricted as-built documents; **do not open a hydraulic fitting, energize a valve, heat a trapped chamber, induce a shock, or stand under a ram** to answer these paper questions:
1. Identify each actual isolated volume on both Y1/Y2 cylinders, the installed check/holding elements and *exact* part/variant/ports; identify any thermal relief path and its destination, including the possibility that the destination is also blocked.
2. Separately document the **thermal overpressure** protection, **dynamic shock** protection, **sustained load holding**, **independent protective stop**, **gravity support** and **service zero-energy** requirements. One check valve cannot be credited for all six without appropriate evidence.
3. Record which pressure indications actually observe each trapped zone; label uninstrumented zones **UNKNOWN**, not zero. Do not infer pressure from a normal FPGA input or a main-line gauge.
4. For a two-cylinder press, review asymmetric relief, redistribution and pressure intensification alongside [POC-PAIR-01](4400_POC_PAIR_01_BOSCH_REXROTH_PAIRED_CYLINDER_PILOT_CHECK_LOAD_TRANSFER_OEM_AUDIT_2026-10-30.md). Do not assume these HydraForce products are fitted to OpenPressBrake.
5. Make the compliant maintenance path usable: captive guards, documented support points, clearly labeled isolation zones, accessible safe diagnostics and a qualified return-to-service procedure; investigate bypass incentives as engineering defects.

## Five public UNSCORED transfer cases
1. A stopped machine warms after shutdown. The main pump gauge reads zero; the cylinder-side port has a check valve. Which pressure proposition is still UNKNOWN, and why?
2. A supplier offers PC10-38 as "load holding with thermal relief." Why can it not replace an appropriately engineered dynamic shock relief function?
3. A schematic reviewer copies the CV10-28 port direction into PC10-38. Which exact directional mistake would that make?
4. A DC10-40 BOM lists the family but not the ordered variant. May the reviewer credit thermal relief? What missing artifact settles this?
5. A technician says thermal relief guarantees that the gravity-loaded ram will never drift. What physical and safety evidence would falsify that assertion?

These are **public open-book practice**, not blind 2520–25F0 evaluation or proof of machine performance.

## Adversarial interpretation and evidence ledger
- **DOC-CONFIRMED:** exact HydraForce 2024 product sheets, port direction, low-flow purpose, dynamic-exclusion language, optional variant, stated leakage and TR04 port-2 backpressure statement.
- **SOURCE-CONFIRMED:** current curriculum's HOLD-01 and POC-PAIR/IH04 predecessor contracts only. No new LinuxCNC or installed OpenPressBrake code behavior established.
- **INFERENCE:** thermal pressure may rise in isolated fluid; intentional release could affect load holding; a return path may be blocked; a single gauge can miss isolated zones. These require circuit-specific assessment.
- **UNKNOWN:** actual OpenPressBrake valve family/ports, thermal relief existence, circuit pressures, temperatures, relief settings, fluid compressibility, load sharing, movement, stop/hold performance, independent safety PLC and PL/SIL.
- **TEST-CONFIRMED:** none. No lab, physical validation, simulation, hosted/self-hosted workflow, independent evaluator or field test. Manufacturer documentation adequately answers this *component-classification* question; a simulation would add no valid selected-machine proof.
- **COMMUNITY-REPORTED:** none used.

**Counterfactual:** even if the installed machine has no thermal relief or no isolated cylinder volume, the teaching that catalog thermal relief ≠ dynamic shock protection ≠ physical holding remains correct. Application to Y1/Y2 remains conditional and is **NOT GRADUATED**. G0/G1 **HOLD**, G2 **NOT RUN**, G3/G4 **NOT AUTHORIZED**, G5 **HOLD**. No personnel-exposed hazardous operation.

**Next:** qualified restricted Stage A A–G evidence and independent 2520–25F0 evaluator first; high-priority PI500 upstream maintainer review remains open. If blocked, select a distinct 4400 safety source, not another generic hydraulic checklist.
