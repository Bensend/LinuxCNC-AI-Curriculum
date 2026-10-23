# 4400 safety — HYDAC SAF accumulator block variant audit and false discharge proof

**Status:** independent manufacturer-product comparison, documentary only. No selected machine, hydraulic test, safe-state certification or schematic freeze. 2026-10-22 UTC.

## Engineering question

Does specifying a compact accumulator "safety and shut-off block" guarantee automatic discharge, an installed gauge, safe hydraulic holding or an independently validated stop? **No.** The manufacturer catalog distinguishes manual versus solenoid-operated discharge, optional gauges and exact valve variants. The label **safety block** names a product family, not a complete machine safety function.

## Two inspectable HYDAC catalog configurations

| Exact catalog entry | DOC-CONFIRMED scope | Consequence |
|---|---|---|
| HYDAC Technology Corp. part **2076241**, code **SAF20M16-N350C S60**, https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2076241 | Catalog says **Manual Discharge** and basic `M` model has a manually operated bleed valve. Family features include pressure-relief valve, main shut-off, manual bleed, **optional** gauge and **optional** solenoid bleed. | The generic family illustration/list does not establish that this specific `M` model has an automatic solenoid bleed or an installed gauge. |
| HYDAC Technology Corp. part **2120394**, code **SAF20E12Y1T330A**, https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2120394 | Catalog says **Solenoid Operated and Manual Discharge**; lists a 2-way bleed-valve function as **Normally Open (Standard) (WSM06020Y)** for this selected entry. It also lists an optional gauge and a factory-set/wire-sealed DB12 relief valve for this catalog configuration. | Product-specific electrical/power-loss behavior must be verified from the exact valve/coil manual and installed circuit, not inferred solely from the word `E` or the family image. No machine pressure decay or personnel-safe state is proved. |

The manufacturer describes SAF blocks as combining pressure relief, main shut-off, manual bleed and optional solenoid bleed, with connections for gauge and return. The product pages state the `E` variant adds solenoid-operated bleed to the `M` base and distinguish old 2SV5 and new WSM coil compatibility. **DOC-CONFIRMED manufacturer catalog claims.** The catalog also lists `Valve Type: Solenoid` on the 2076241 manual model's generic specification table while identifying its bleed operation as manual. Treat that generic field as **source-data ambiguity**, not evidence of an installed solenoid bleed. A selected bill of materials, valve code and as-built diagram are required to resolve it.

## Four independent safety propositions

1. **Relief valve installed and set correctly:** overpressure-protection proposition, not proof of discharge or mechanical holding.
2. **Shut-off valve correctly operated and locked where required:** isolation proposition at the specific ports, not proof of pressure absence on either side.
3. **Manual/solenoid bleed actually opens and provides a viable discharge path:** discharge-path proposition; not proof that the accumulator, cylinder chambers and pilot volumes have all reached an accepted pressure state.
4. **Gauge/test port reads a valid pressure in the required zone:** point-specific physical measurement; not proof that the load is mechanically restrained or other zones are safe.

**Freeze:** BLOCK LABEL != CONFIGURED OPTIONS != ACTUAL VALVE ACTUATION != VERIFIED PHYSICAL SAFE STATE.

## Replacement / change-control attack

A technician replaces a failed `E` block with a physically similar `M` model, or changes a normally open bleed element to a normally closed variant. The controller and HMI still indicate "accumulator discharged" from the output command alone. This is a **hypothetical** scenario, not a claim that any machine has done so.

Required disposition: record the exact installed code and revision; open `CHG-*`; mark affected `SRS/AUTH/ARC/DEP/PHY/VAL/PT` evidence STALE; verify electrical/solenoid default state, fluid ports, relief arrangement, gauge presence and independent pressure witness before any release. Reassess whether the change defeats a power-loss discharge function or a protective-cycle energy requirement. Do not automatically assume de-energize-to-bleed or de-energize-to-hold. If a safe-to-operate proposition is unproved, block personnel-exposed operation; diagnose only under isolated/remote controls with people outside the danger zone.

## Human-factors design insight

A compact block may reduce plumbing, but an **optional gauge omitted from procurement** can leave a technician unable to verify the intended zone without intrusive fittings. This is an **INFERENCE/design review question**, not a claim about the two catalog examples' actual installed accessories. A clear part-code and gauge-option checklist, visible labeled pressure points, and service procedures that do not require guard defeat are more robust than a green HMI status and verbal instructions.

## Integration with existing safety package

Use the canonical eight-field `SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md` and selected-block worksheet. Capture exact catalog code and options in `ARC`; distinguish relief/isolation/discharge in `SRS/PHY`; model shared solenoid power/return, valve body, gauge port and pilot path in `DEP`; define separate `VAL/PT` physical witnesses; track human access incentives in `HF`; retain unknown installed port topology in `UNK`. Do not promote product catalog characteristics into a machine PL/SIL claim.

**Evidence classes:** DOC-CONFIRMED for exact HYDAC product-page descriptions; INFERENCE for hypothetical substitution and human-factors risk; UNKNOWN for installed system, selected wiring, bleed response, physical pressure and machine safe state; TEST-CONFIRMED none. No simulation or Actions compute was justified.
