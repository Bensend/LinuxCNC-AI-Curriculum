# 4400 — HYDAC SAF selected-catalog qualification: what is and is not ready

**Status:** instructional application of `hardware/SO_FINAL_ELEMENT_IMPLEMENTATION_SPEC_TEMPLATE.md` and `hardware/SELECTED_SAFETY_BLOCK_QUALIFICATION_WORKSHEET.md`. Catalog part 2120394 is a **public example**, not a selected component for an actual machine. Engineering capture **NOT READY**. Machine validation **NOT RUN**.

## Identity and scope

- Family: HYDAC SAF accumulator safety and shut-off block.
- Public catalog example: part 2120394, code `SAF20E12Y1T330A`.
- Source: https://catalog.hydac.com/en-us/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2120394, consulted 2026-10-22.
- Product page describes manual + solenoid bleed, a normally-open WSM06020Y solenoid bleed configuration, main shut-off, relief valve and optional gauge. Exact manufacturer application/installation instructions and complete hydraulic schematic not obtained for this selected example.
- This is a manufacturer catalog description, not a safety-function certification or installation validation.

## Eight-field final-element witness record

| Field | Public evidence / required decision | Class / disposition |
|---|---|---|
| 1. Commanded safety action | Example may support an accumulator bleed demand; actual safety demand, authority, mode and energy consequences are unspecified. | UNKNOWN / SRS-AUTH BLOCKED |
| 2. Physical final element | Catalog identifies an `E` model and normally-open bleed-valve variant; actual installed valve, coil, manifold and port map not available. | DOC-CONFIRMED catalog identity; installed UNKNOWN |
| 3. Feedback target | No independent valve-position or pressure witness is established by the catalog model label; gauge is listed as optional. | UNKNOWN / PHY-VAL BLOCKED |
| 4. Legitimate proposition | A commanded bleed output proves only a command; verified physical discharge requires independently justified path and measurements. | INFERENCE; physical proof UNKNOWN |
| 5. Dependencies / CCF | Solenoid supply/reference, valve spool/seat, manual bleed, manifold return, blocked tap, relief arrangement, gauge supply/accuracy, common enclosure, pilot pressure and replacement variants. | DEP candidates, installed topology UNKNOWN |
| 6. Residual hazardous energy | Accumulator gas charge, isolated fluid volumes, cylinder chambers, pilot supply, gravity/external loads and thermal expansion may remain. | Potential paths; actual presence UNKNOWN |
| 7. Machine-level physical witness | Need a selected hydraulic zone map, valid gauge/test-port instrumentation, actual pressure/standstill/holding witnesses with machine acceptance criteria. | VAL NOT RUN |
| 8. Maintenance isolation / blocking | Lockable energy isolation, physical restraint where required, fluid-side discharge and reaccumulation verification independent of ordinary production stop. | SRS/PHY/VAL UNKNOWN |

## Conditional fault / replacement review

| Scenario | Narrow observation | Machine proposition and disposition |
|---|---|---|
| Solenoid output de-energized | Electrical state of command may be known | **UNKNOWN** whether actual bleed valve opens, fluid path is clear or load safe; exact product instructions and physical evidence required. |
| Manual `M` block substituted for `E` | Similar mounting/SAF family possible | Do not assume automatic discharge remains; open `CHG`, mark affected `SRS/ARC/VAL` STALE and block release. |
| Gauge omitted from order | Family feature list still shows optional gauge | No verified pressure witness; redesign for accessible approved measurement before maintenance entry. |
| Gauge at wrong port / blocked tap | Gauge may read low | Connected-zone truth UNKNOWN; cross-check topology and independent witness. |
| Bleed commanded, accumulator pressure remains | Command acknowledged | `PHY` NOT ESTABLISHED; no personnel-exposed rearm or service; investigate only with justified safe controls. |
| Relief valve functions as designed | Overpressure limitation may be supported | Does not establish drain path, mechanical holding or pressure absence in isolated chambers. |
| Retained normal motion command after safety reset | HMI may show ready | Independent restart inhibit and separate fresh ordinary start must be justified. |

## Freeze decision

**NOT READY FOR SCHEMATIC CAPTURE** for a personnel-safety function: exact installed variant, electrical compatibility, valve de-energized response, connection to all relevant pressure zones, diagnostic/restart ownership and physical acceptance criteria are missing. A generic conceptual schematic may be used for education only and must remain labeled NOT FROZEN. This decision is not a rejection of HYDAC equipment; it is a refusal to infer missing machine-level evidence from a product catalog.

## Human factors

A single compact block can simplify installation, but omission of the optional gauge, poor port labeling, or a guard that must be removed to inspect it may make correct maintenance verification impractical. The engineering response is to specify a serviceable witness arrangement and easy guard restoration, not to bypass protection or reclassify LinuxCNC as a safety controller.

**Provenance:** HYDAC catalog DOC-CONFIRMED; safety-package reasoning INFERENCE; installed system, exact valve response and all machine physical witnesses UNKNOWN; no TEST-CONFIRMED evidence.
