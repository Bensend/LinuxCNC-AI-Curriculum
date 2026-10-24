# 4400 — HYDAC RBE 710028: opposite closing-flow direction in two official manufacturer sources

**Adversarial source reconciliation, 2026-10-24 UTC. Status: UNRESOLVED OEM DOCUMENT CONFLICT; no physical installation, test or release.** This corrects any temptation to treat a catalogue's port arrows as a universal valve-family fact.

## Why this is a safety-critical discovery

Two currently accessible **HYDAC-controlled** sources identify **the same catalogue part number 710028 / RBE-R1/2-X-75** but describe **opposite excess-flow closure directions**. A cylinder-mounted hose-break fuse installed on the wrong flow side may fail to close during the intended gravity-driven hose rupture. An engineer must not resolve this by choosing whichever source looks newer, translating port numbers by intuition, or running an uncontrolled live burst test.

### Direct manufacturer source A — HYDAC Technology Corporation US product catalogue

- **URL:** https://catalog.hydac.com/item/cartridge-valves/valves--hose-break-check/710028
- **Identity:** Part Number **710028**, `RBE-R1/2-X-75LPM (STD. SET)` — not merely a vaguely similar RB valve.
- **Page description:** rupture closes on excess flow **2 → 1**; specification calls **1 → 2 free**, **2 → 1 free until above preset**; additional information says the valve opens by pressure at connection **1**.
- **Edition:** online product page, no publication/revision date displayed. Inspected 2026-10-24. **DOC-CONFIRMED as text on that exact official US page**, not verified as installed-device truth.

### Direct manufacturer source B — HYDAC International / HYDAC Australia technical PDF

- **URL:** https://www.hydac.com.au/media/productattach/e/n/en5174_rbe_1.pdf?20250824=
- **Printed publication identifier:** **EN 5.174.14/10.21**, four-page manufacturer technical datasheet.
- **Page 1 (PDF p.1):** explicitly says excess flow closes and blocks **1 → 2**; its hydraulic symbol and cutaway label the **consumer being protected as port 1** and port **2** on the other side.
- **Page 2 (PDF p.2):** standard models table explicitly lists **`RBE-R1/2-X-75` / part 710028**, matching the US part identity. The PDF does not merely describe a different SAE-thread model.
- **Edition:** October 2021 indicated by `10.21`; original PDF page visually inspected, not just search snippets. **DOC-CONFIRMED for that exact original PDF**, not a machine test.

### Cross-check — HYDAC Australia public product page

- https://www.hydac.com.au/direct-acting-flat-seat-valve-cartridge-rbe-1-4-3-4.html
- Describes **1 → 2** closure, consistent with its own PDF, but is not independent of HYDAC International. No exact physical unit inspected.

## Reconciliation table

| Evidence dimension | US official product 710028 | International 2021 PDF |
|---|---|---|
| Manufacturer | HYDAC Technology Corporation | HYDAC International, hosted by HYDAC Australia |
| Same part number | **710028** | **710028**, page 2 |
| Same model family/size | **RBE-R1/2-X-75** | **RBE-R1/2-X-75** |
| Claimed excess-flow closing direction | **2 → 1** | **1 → 2** |
| Opposite-flow opening statement | Pressurize port 1 | Cutaway/diagram identifies protected consumer at port 1; PDF text does not supply same US reopening claim |
| Publication date | UNKNOWN | EN 5.174.14/10.21 |
| Source quality | Original current online catalogue | Original dated OEM technical PDF with illustrated internal construction |
| Which is physically correct for a selected installed valve? | **UNKNOWN** | **UNKNOWN** |

**Important nuance:** the US catalogue also lists SAE-thread `RBE-SAE...` variants with its 2→1 language, but **this particular conflict is stronger**: its `710028 RBE-R1/2` listing conflicts with the 2021 PDF's **same part number**. It might be a catalogue data/template error, revision difference, diagram convention or physical redesign, but **none of those explanations is confirmed**. The original PDF's symbol/cutaway is a stronger design-specific depiction than a generic catalogue paragraph, but still **not sufficient to authorize installation** without exact manufacturer clarification and selected as-built verification.

## Physical hazard path and why a “quick test” is unacceptable

`Manufacturer direction mismatch` → `installed fuse oriented/ported for wrong flow` → `rupture outflow may be in the unprotected/free-flow direction` → `no closure despite apparently correct part number` → `gravity-driven hazardous ram motion` → `personnel exposure`.

This is a **plausible failure path / INFERENCE**, not a demonstrated installed failure. Both sources describe flow-operated protection, but the exact port labels determine which chamber-to-line flow is protected. Do not infer actual Y1/Y2 chamber geometry, fuse presence, PL/SIL, stop time, trip threshold, drift or pressure from these documents.

The HYDAC US page includes a method involving intentionally opening a hydraulic line to measure rupture flow. That is a **hazardous manufacturer application-test description**, not a curriculum exercise. **No person-exposed or improvised line-opening test is authorized.** Qualified physical verification, if ever justified, needs a separately approved isolated/remote containment design, positive mechanical support, pressure-zone controls, independent motion/pressure instrumentation and all people outside the hazard zone.

## Resolution gate — documentary first, physical only after engineering approval

1. **Documentary identity:** obtain the actual component's stamped full part number, model code, manufacturing batch/date, assembly revision, body/cavity/port markings and installed orientation; retain photographs only when safely accessible without hazard exposure. `UNKNOWN` until obtained.
2. **Manufacturer clarification:** ask HYDAC engineering to reconcile **710028** between the US catalogue and **EN 5.174.14/10.21**, including which end is **consumer/cylinder**, which end is **line**, the protected flow direction, and whether revisions/batches differ. Obtain an official written answer/drawing tied to the selected device, not an informal generic sales description.
3. **As-built hydraulic trace:** independently reconcile cylinder chamber, actual port-to-hose mapping, line break locations, bypass/check/relief paths, second cylinder and mechanical load support. Do not open fittings or enter danger zones to “trace” a live system.
4. **Safety allocation:** independent `SF/PHY/SRS/AUTH/DEP/ARC` for stop, hold, hose injection, energy isolation and restart. Normal LinuxCNC/FPGA is not a safety-rated direction verifier.
5. **Validation freeze:** `VAL/PT NOT RUN` until the conflicting documents, installed identity, isolation/remote plan and independent witnesses are reconciled. A simulation of a chosen arrow cannot decide which physical part is correct.

## Claims ledger

| Claim | Class | Provenance | Status |
|---|---|---|---|
| US HYDAC part 710028 catalogue says 2→1 closes | DOC-CONFIRMED | Official US part page, description/specification | Confirmed *document text*, not physical behavior |
| HYDAC EN 5.174.14/10.21 part 710028 says 1→2 closes | DOC-CONFIRMED | Official Australia-hosted original PDF pp. 1–2; symbol/cutaway | Confirmed *document text and diagram*, not physical behavior |
| Both sources identify part 710028 / RBE-R1/2-X-75 | DOC-CONFIRMED | Same two original manufacturer sources | Same nominal part, edition difference unresolved |
| Installed 710028 actually closes in a given direction | **UNKNOWN** | Contradictory OEM sources; no selected part or independent test | **BLOCKING safety evidence gap** |
| Wrong assumed direction could defeat gravity-rupture protection | INFERENCE | Mechanism plus opposing port assignments | Preserve as high-consequence design hazard |
| Any OpenPressBrake fuse exists or is safe | UNKNOWN | No Y1/Y2 as-built | No personnel-exposed release |

**Counterfactual graduation test:** if either source is wrong, the **teaching conclusion remains**: a part number and generic web catalogue do not establish the physical protected direction; require manufacturer clarification and as-built/physical proof. The conflict itself is **not promotable as a resolved design fact**. This audit is documentary research only and does not graduate 4400-HY-01 or close 2520–25F0 external evaluations.
