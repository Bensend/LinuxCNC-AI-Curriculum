# 4400 / 2580 — HYDAC SAF gauge topology, zero-reading trap and physical-witness scope

**Status:** public-source documentary investigation; NOT machine validation; not a certified safety design. **Study UTC:** 2026-10-22. **No test run.**

## Question and evidence decision

Can an indicated zero at a SAF-mounted hydraulic pressure gauge prove that the associated accumulator, downstream actuator and gravity load are all safe, and does an automatic bleed variant necessarily establish that state on loss of power?

**Answer:** No. The manufacturer's own fluid-side gas-precharge check intentionally ends with a sudden gauge drop to zero while the accumulator's *gas precharge* remains present. The gauge is a measurement of a particular connected **fluid-side** node, not a universal proof of gas-side depressurization, downstream cylinder pressure, ram holding or personnel-safe maintenance. The diagram identifies specific alternative paths, optional equipment and isolation boundaries. This is a product-family source trace, **not** an assertion about any installed press-brake hydraulic circuit.

## Exact sources and version scope

- **HYDAC Corporation**, *Accumulators — Operating and Installation Instructions*, PN#02068196, ACU1107-1367 / **09.11** (2011), PDF pp. 1, 3–4. Manufacturer-hosted PDF: https://betterfit-us.hydac.com/wp-content/uploads/Operating%20and%20Installation%20Instructions%20for%20HYDAC%20Accumulators.pdf . Page 3 §3.2 explicitly gives the fluid-side gauge method; page 4 Fig. 1 shows the block schematic. **DOC-CONFIRMED**. PDF figure inspected visually.
- **HYDAC International**, *Safety and Shut-off Block SAF/DSV*, document **E 3.551.18/04.09** (April 2009), PDF pp. 107–110 (PDF indices 0–3). Manufacturer-affiliated hosted copy: https://www.hydac.com.tw/upload-files/Machine_Tool/TMTS_2024_Products_pdf-files_Download/MT2024-70-HYDAC_Safety_shut_off_block_SAF_______________________________.pdf . Page 107 schematic and p.108 §1.3 ports, p.108 §1.5 variant definitions, p.110 model code. **DOC-CONFIRMED** for this historical revision, not present-day interchangeability.
- **HYDAC Technology Corporation**, catalog item **2205492**, `SAF20M16-N250A S12`, public product page: https://catalog.hydac.com/item/safety-and-shut-off-blocks/type-saf-safety---shut-off-blocks/2205492 . Lists `Model: Manual Discharge`, bleed-voltage/frequency `Manual`, and also the generic `Valve Type: Solenoid` field. **DOC-CONFIRMED** catalog conflict; exact installed variant is **UNKNOWN**.
- **OSHA**, 29 CFR 1910.147(d)(3)–(6), https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 . Isolation, stored energy, reaccumulation and worker verification are separate obligations when this regulation applies. **DOC-CONFIRMED** US regulatory text, jurisdiction/task applicability requires its own `BND/UNK` record.

## Figure-to-proposition source trace

The 2009 SAF/DSV p.107 circuit drawing explicitly labels: `S` accumulator port, `P` inline/pump port, `T` tank, `M1` test-gauge port, `M2` gauge connection. The shut-off valve (item 3) lies between `P` and `S`. A gauge (item 2) and test-gauge connection (item 5) are shown on the accumulator-side node. The pressure-relief element (item 1), manually operated discharge (item 4), and optional solenoid discharge (item 6) connect the accumulator-side node to return paths. An optional throttle (item 7) appears on the solenoid branch. The 2011 manual Fig. 1 independently depicts the same *functional family* (with different figure numbering).

**Important scope:** The 2009 drawing establishes a **published example topology**; it does not prove that a particular purchased block has a gauge, solenoid, throttle, monitor, correct hose/tank return, or any downstream actuator connection. The p.107 example is not an as-built schematic. Verify exact installed catalog/model, adapter, serial/revision, manual and field plumbing before using any connection claim.

| Named volume or path | Published figure evidence | What one fluid-side gauge can support | What remains unproved |
|---|---|---|---|
| `S` accumulator **fluid-side** node | p.107 figure, p.108 port list; 2011 p.3 §3.2 | Local pressure **if** installed gauge, tap and connecting passage are intact and connected | Gas-side pressure, independent gauge correctness, trapped sub-volumes |
| Accumulator **gas side** | 2011 pp.1–3 precharge instructions; separate gas valve | Fluid-side *trend* during manufacturer-specified precharge check can infer gas precharge immediately before sudden fall | Gas-side depressurization; gas remains a stored-energy source after oil-side zero |
| `P` system/pump/consumer-side node | 2009 p.108 port list and shut-off figure | Not necessarily represented by the `S` gauge after shut-off valve closes | Other sources, downstream pressure, actuator chambers, regenerative paths |
| `T` return/discharge | 2009 p.107–108; manual/optional solenoid bleed | Command/path exists in published family | Return line actually open, sufficient discharge, blockage, alternate pressure path |
| `M1` test and `M2` gauge | 2009 p.108 §1.3 | Documented connection names; actual tap topology must match installed product | Gauge installation, calibration, shutoff/plug state, instrument trust |
| Mechanical ram/gravity load | Not modeled by block catalog | None | Standstill, drift, holding force, independent mechanical restraint |

**Interpretation of zero:** The 2011 HYDAC manual p.3 §3.2 prescribes charging the fluid side, closing the main shutoff, slowly discharging through the manual bleed and watching the fluid gauge. It explicitly says the reading *immediately before* the abrupt drop to zero corresponds to gas precharge. Thus a zero **after** this operation is compatible with a still-precharged gas chamber. This is a manufacturer-prescribed diagnostic sequence, **not** permission to carry it out on an unknown machine or to service a pressurized vessel.

## Variant and source conflict

The 2009 p.108 §1.5 states basic `M` models have **manual** release; `E` models add solenoid-operated 2-way release, with a normally open on de-energization **standard** version. The p.110 model code explicitly distinguishes `Y` open-when-de-energized from `Z` closed-when-de-energized. The catalog page for exact 2205492 simultaneously describes `Manual Discharge` and a generic `Valve Type: Solenoid`; the specific model code and manual-only bleed fields favor a manual configuration but **the catalog contradiction is not silently repaired**. Confirm via exact product drawings/manufacturer before selection. A de-energized `Z` variant cannot be treated as `Y`; even an established `Y` state does not prove a clear return path or physical machine safe state.

**Two diagram-key differences:** In the 2011 instructions, item `6` is the optional thermal fuse cap. In the 2009 SAF brochure, item `6` is the optional solenoid discharge, and item `7` is throttle. Numbered figure keys are **document-specific**; merging them would misidentify a final element. The 2026 catalog illustration also uses a different figure key. Always cite document revision and figure.

## Failure-path / adversarial review

| Credible contradiction (hypothesis, not observed fault) | Plausible but inadequate evidence | Physical proposition at risk | Required engineering disposition |
|---|---|---|---|
| S-side gauge zero, gas still precharged | Gauge 0 after fluid bleed | Accumulator completely de-energized | Keep gas-side energy separate; servicing rules/product manual govern |
| S-side gauge zero, P-side isolated/trapped | Main shutoff closed | All hydraulic circuits depressurized | Map every pressure zone, independent test points and isolation states |
| Valve position monitor says closed but main seal leaks | Position bit healthy | Energy flow actually isolated | Distinguish spool/handle position from sealing and pressure witness |
| Gauge zero due disconnected/blocked tap | HMI pressure channel zero | Actual S-node pressure zero | Prove sensor path and instrument trust; do not assume plausible equals correct |
| Bleed solenoid electrically off but return blocked | Command/off state healthy | Fluid discharge achieved | Confirm actual product, outlet path and physical pressure trend |
| Gas migration into fluid circuit from failed bladder | Fluid gauge reading alone | No stored compressible energy | Examine selected accumulator failure mechanisms and separate volumes |
| S-node pressure falls but ram drifts under gravity | Valve feedback/pressure normal | Beam safely held | Independent motion/holding/restraint witness required |
| Powered test re-energizes circuit after prior lockout | Old verification record | Servicing remains safely isolated | New isolation and verification before exposed work resumes |
| Automatic bleed would remove protective-cycle energy | 'fail-safe' valve chosen by label | Controlled protective stop achievable | Resolve SRS stop/hold energy budget **before** selecting variant |
| Lockable valve secured in open position | Padlock present | Source isolation | Verify actual shut-off state; do not use lock presence as witness |

These are **INFERENCE** failure challenges derived from known physics and source topology, not TEST-CONFIRMED faults. No frequency, detection coverage, stopping distance, pressure threshold or PL/SIL is claimed.

## Architecture/authority boundary

1. **Normal LinuxCNC / FPGA:** motion demand, display, logging, ordinary fault request; no sole personnel-safety authority.
2. **Monitoring/diagnostics:** gauges, pressure transducers, valve position, status; evidence only for their own verified targets.
3. **Independent safety-related control:** evaluates required protective demands, drives selected safety final elements and enforces qualified rearm under the machine SRS; selection/rating remain machine-specific.
4. **Physical final elements:** shutoff, controlled discharge, independent holding/restraint and actual energy removal where designed; a single SAF component does not automatically implement all four.
5. **Maintenance isolation:** lockable energy isolation, stored-energy disposition, reaccumulation checks and each exposed worker's protection remain separate from the production safety function.

## Acceptance gate and information-gain stop

The documentary question is resolved: a single SAF fluid-side zero cannot establish gas-side, P-side or ram safe state. No lab is justified to reproduce a documented gauge behavior. **Machine-specific** acceptance remains blocked pending: as-built hydraulic diagram and exact installed model; verified pressure-zone/port map; actual valve fail state and return line; gauge/test-point calibration/connectivity; independent beam position/holding and restraint evidence; SRS protective stop energy requirements; and maintenance procedure/competent personnel. Do not operate with people exposed while the minimum physical safe-state proposition is unproved. Remote/isolated experiments only with people outside the danger zone, after site-specific hazard review.

## Learning-method note

A manufacturer procedure that deliberately produces a zero gauge reading while retaining another energy form is a stronger transfer exercise than repeatedly restating 'zero pressure is not safe'. Use *what the instrument actually observes* and *what the source says happens at the transition* to expose the invalid inference. Keep source-figure keys and variant-specific truth separate; one ambiguous catalog field is not a reason to invent product behavior or dispatch compute.
