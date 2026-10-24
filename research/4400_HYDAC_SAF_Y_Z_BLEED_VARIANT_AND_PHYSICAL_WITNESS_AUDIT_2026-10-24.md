# 4400 — HYDAC SAF Y/Z bleed-valve variants: part code is a safety-critical interface
**2026-10-24 | Manufacturer catalog-indexed and part-page evidence | no physical validation**

## Precise new discriminator
A HYDAC SAF safety/shut-off block is not a universal 'power off = accumulator discharged' device. **The manufacturer catalog distinguishes a normally-open Y poppet from a normally-closed Z poppet**, and manual-only M from solenoid-plus-manual E. The exact installed ordering code, hydraulic return, isolation and discharge witness determine whether an intended power-loss response is even plausible.

## Manufacturer provenance and access limitation
- HYDAC *Accumulator Technology — Product Catalogue*, **EN 3551.25/05.24**, SAF model-code section, manufacturer PDF indexed at https://www.hydac.com/download/accumulator-technology-product-catalogue-1000443492-en.pdf . Search-indexed manufacturer excerpt explicitly lists **M = manual discharge; E = solenoid-operated and manual discharge; Y = normally open (WSM06020Y); Z = normally closed (WSM06020Z, only up to 350 bar)**. **DOC-CONFIRMED from manufacturer-indexed excerpt, full original PDF open returned HTTP 403 in this session**. Do not claim direct PDF page inspection.
- HYDAC official product page for **part 2206132**, exact code `SAF20E16Y1-T210A`, https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2206132 . Manufacturer-indexed page identifies a normally-open WSM06020Y bleed valve, a main shutoff, manual bleed, pressure-relief valve and **optional** pressure gauge. Full page open was not available in the reader; indexed content only.
- Existing curriculum audit [HYDAC SAF selected-catalog gate](4400_HYDAC_SAF_EXACT_CATALOG_SELECTED_BLOCK_GATE.md) used different exact part 2120394, code `SAF20E12Y1T330A`; do not silently treat these codes as identical.

## Distinct functions in the same compact block
| Function | What the catalog identifies | Invalid inference |
|---|---|---|
| Main shutoff | Physical isolation of identified supply connection | Every downstream/cylinder volume isolated |
| Manual discharge | Operator-actuated fluid-side bleed provision | Automatically discharged on power loss |
| Solenoid bleed (E only) | Electrical actuation path for discharge | Valve physically opened, return unobstructed |
| Y vs Z | Different de-energized valve state by catalog type | All SAF variants fail to the same state |
| Pressure relief | Excess-pressure limiting element | Maintenance depressurization or gravity hold |
| Optional gauge | A possible local pressure witness | Gas side, every pilot/cylinder chamber or uninstrumented segment proven safe |
| Optional lock/position accessories | Variant-specific physical/feedback features | Safety integrity, independent redundancy or machine stop time |

**Crucial distinction:** even where Y is catalogued normally open, power removal is only a **valve-state design expectation**. It does not prove oil can actually reach tank, that the connected accumulator volume is exhausted, that return pressure is acceptable, or that releasing pressure will not destabilize a gravity load. Conversely, substituting Z for Y may reverse the expected de-energized bleed action. These are architecture consequences, not selected-machine test results.

## Change-control trap
A maintainer orders an apparently equivalent SAF block with the same nominal port size but different M/E, Y/Z, locking, monitoring, gauge or connector variant. **CHG/STALENESS trigger:** hold the affected safety function and maintenance-isolation release pending exact OEM part-code verification, as-built port and electrical reconciliation, independent safety-function review, and physical validation. A new part's presence or a good configuration checksum is not enough.

## Adversarial failure pathways
1. Y bleed coil de-energized; accumulator tap still reads pressure: suspect blocked return, wrong tap, spool defect, cross-feed, or installation mismatch; do not claim discharge.
2. M manual-only substitution: an existing automatic bleed output no longer has the intended final element.
3. Z substituted for Y: a power-loss demand may leave a bleed closed; the selected SRS must be re-evaluated.
4. Gauge removed as an optional item: the original verification method no longer exists.
5. Relief valve opens: overpressure mitigation is not evidence that service pressure is zero.
6. Bleed opens while a load is held hydraulically: uncontrolled descent may be introduced; the required safe-state design must distinguish hold, discharge and mechanical restraint.
7. One manifold contains two connected accumulators: a single gauge/valve cannot be credited for both without a proven zone map.

## Transfer and evidence classifications
**DOC-CONFIRMED (manufacturer-indexed, limited access):** exact catalog family options, part 2206132 listed features. **INFERENCE:** fault propagation and change-control consequence. **UNKNOWN:** exact selected block, return pressure, valve fault tolerance, safety performance, cylinder holding and physical stop. **TEST-CONFIRMED:** none. **SOURCE-CONFIRMED LinuxCNC:** none. This is not a certification of any HYDAC part or evidence of its installation on OpenPressBrake.

A source-availability stop is local: full 2024 HYDAC PDF could not be directly opened; the separately and directly inspected Parker service PDF provides independent, complementary gas/fluid service evidence.

## Independent direct original OEM cross-revision check (same session)
**DOC-CONFIRMED directly inspected:** HYDAC Australia-hosted original *Safety and Shut-off Block SAF/DSV*, **E 3.551.17/08.03** (2003 edition), 21-page manufacturer PDF: https://www.hydac.com.au/pub/media/Ourcompanies/s/a/safetyvalveblocks.pdf . This older edition is not a substitute for the current selected part manual.

- PDF p. 3 (index 2), §1.2–1.5: distinct pressure relief, main shutoff, manual pressure release and **optional** solenoid pressure-release path; identifies S accumulator, P pump, T tank, M1 test gauge and M2 gauge connections for this edition.
- PDF p. 5 (index 4), §2: **M = manual discharge; E = solenoid + manual; Y = open when de-energised (2SV5E2Y); Z = closed when de-energised (2SV5E2Z)**. This independently corroborates the *semantic* Y/Z difference from the 2024 manufacturer-indexed catalog, but the older valve hardware identifier **2SV5E2** is **not** the 2024 indexed **WSM06020** identifier. Do not assume coil/plug or service-parts interchangeability across editions.
- PDF p. 9 (index 8), §4: the spare-parts table explicitly identifies a blanking-plug assembly **converting E to M**. This is a concrete maintenance modification that can remove automatic discharge even when the same external block remains installed.
- PDF p. 10 (index 9), §5.1: DSV10 is a **different three-way safety-block family** with M, EY and EZ models. Do not silently transfer a DSV valve or truth table to an SAF manifold.
- Manufacturer document includes pressure/flow/switching information under **2003 edition-specific conditions**; no numbers are copied into a selected-machine SRS.

**Cross-edition conflict/limit:** 2003 PDF directly inspected, 2024 catalog only indexed (403 on direct open). The functional Y/Z coding aligns; the named valve subassembly differs. Exact current installed model, OEM revision and service kit are **UNKNOWN**. Treat substitution as `CHG` and require renewed physical validation, not a parts-store equivalence assumption.
