# 4400 TOOL-LOAD-03 — Tool capacity is local, not machine-nameplate tonnage
**2026-10-26 | Distinct 4400 safety rotation | OEM documentary audit | No selected-machine calculation or test**

## Research question
Can a press brake whose nameplate says 170 tons safely press any shorter punch at 170 tons? **No generic inference is supported.** Tool, segment length, load distribution, holder, and press all impose distinct constraints. A short segment can be overloaded despite a press-wide force below nameplate capacity. Tool-fracture and released workpiece hazards are separate from TOOL-RET-01 gravity retention and TOOL-RET-02 ordinary M6 completion.

## Direct original manufacturer evidence
1. **WILA, “Learn about WILA tools and load capacity”**, https://www.wilatooling.com/en-us/knowledge-innovation/knowledge-articles/learn-about-wila-tools-and-load-capacity/ , retrieved 2026-10-26. **DOC-CONFIRMED:** tool loads expressed in kN/m; example 100-mm segment rated 1,000 kN/m has capacity 100 kN **when evenly distributed**; the holder or press can be the limiting factor even if the tool is capable. Head-load vs shoulder-load variants differ. This is WILA's illustrative arithmetic, **not** an OpenPressBrake rating or permission to load a segment with a point force.
2. **WILA BIU-025 exact product**, https://www.wilatooling.com/en-us/products/press-brake-tooling/new-standard-tooling/new-standard-premium/biu-025/ . **DOC-CONFIRMED:** max load label **130 ton/m** for this exact family, not a machine-wide limit. The page states parts below 12.5 kg have Safety-Clicks and heavier parts fixed safety keys with horizontal loading. Do not equate maximum forming load with retention load or convert the label without unit definition.
3. **WILA BIU-022 exact product**, https://www.wilatooling.com/en-us/products/press-brake-tooling/new-standard-tooling/new-standard-premium/biu-022/ . **DOC-CONFIRMED:** max load label **80 ton/m** for a different tool of similar 163-mm working height. Similar appearance does not imply same allowable forming load.
4. **WILA, “Tool height”**, https://www.wilatooling.com/knowledge-innovation/knowledge-articles/tool-height/ . **DOC-CONFIRMED:** tool height, ram stroke and open height affect usable handling clearance; text states a BIU-031 515-mm-long tool “has Safety-Clicks and must be changed horizontally.” This is an important **documentary nuance** against the naive rule “Safety-Click always permits vertical change.” The reason for this specific example is **not explained** in the webpage; exact variant/geometry/manual must resolve it. Do not silently correct the manufacturer.
5. **WILA 2023 GB catalog**, https://catalog.wilatooling.com/WILA-Catalog-GB/ , pages 42–43 list distinct Safety-Click, Safety-Pin, HD Safety-Pin and E2M weight categories. **DOC-CONFIRMED** family differences, not selected-machine installation.
6. **Haas HPB-170-10 product specification**, https://www.haascnc.com/machines/fab-machines/press-brakes/hpb-170-10.html , states a **170-ton** press-wide machine capacity. **DOC-CONFIRMED** exact Haas product nameplate claim, not evidence that a 100-mm segment can sustain 170 tons and not an OpenPressBrake rating.

## Limiting-element reasoning (INFERENCE from OEM capacity distinctions)
For a *selected and validated* bend, independently evaluate `machine available force`, `holder rated load under the actual load path`, `tool local rated load over actual engaged length`, `workpiece contact distribution`, `adapter and extension capacity`, `off-center/partial-width loading`, `workpiece motion`, and `physical guarding`. **No generic minimum-of-numbers formula is sufficient** without consistent units, load distribution, geometry, OEM derating, machine structural limits and exact tool specification.

A tool's `130 ton/m` label does not imply that 130 tons can be applied to a 100-mm segment. WILA's explicit example demonstrates proportional **uniform** load for a different 1,000 kN/m tool: 0.100 m × 1,000 kN/m = 100 kN. Do not apply that example as a proof for a concentrated or edge-loaded case. Avoid assuming machine total tonnage, per-meter tool rating and hydraulic pressure are interchangeable.

## Adversarial failure paths
| Scenario | Dangerous assumption | Documentary discriminator | Status |
|---|---|---|---|
| A 170-ton machine runs a short 100-mm punch | “Machine rated 170 tons, so tooling is safe” | Actual tool kN/m rating, engaged segment, distribution, holder, adapter and press | OEM product capacities DOC-CONFIRMED; machine application UNKNOWN |
| Two 163-mm-height WILA punches are swapped | “Same height means same force capacity” | BIU-022 80 ton/m versus BIU-025 130 ton/m exact variant | DOC-CONFIRMED exact OEM |
| Horned/offset die contacts only one corner | “Uniform-load rating applies to point contact” | Selected manufacturer application/derating and actual contact load | INFERENCE; actual force UNKNOWN |
| Operator changes tall 515-mm punch vertically because it has Safety-Click | “Safety-Click guarantees vertical removal” | WILA tool-height BIU-031 example requires horizontal handling; selected manual and geometry | DOC-CONFIRMED nuance, reason UNKNOWN |
| Controller reports simulated bend within machine force | “Normal software prediction certifies tooling” | Independent tool/holder load validation and physical safety analysis | INFERENCE; no simulation performed |
| A damaged tool is reused because the pressure setpoint is unchanged | “No alarm means no fatigue/fracture hazard” | Exact inspection, condition, application, replacement criteria | UNKNOWN selected condition |

## Physical/safety authority
LinuxCNC/FPGA may estimate commanded force, plan bend, select tool and display capacity warnings, but ordinary software is **not a safety-rated load limiter**. Even an independent safety function cannot replace proper physical tooling selection, guard geometry and qualified load calculation. Any proposed load-limiting safety function requires a selected SRS, suitable sensors/final elements and validation; none is asserted here.

## Evidence and change control
The original WILA pages prove different product ratings and a **specific uniform-load example**, not actual OpenPressBrake tooling or any fracture threshold. No physical test, computed actual load, machine pressure, tool fatigue life, PL/SIL or stopping distance. Add tool capacity/segment/adapter/height to restricted Stage B TOOL-RET evidence if selected machine has such tooling; preserve model suffixes and revisions. Tool substitution, extender, segment-length change, off-center job, press capacity upgrade, software recipe change or new material requires CHG review.

**Decision:** G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; no personnel-exposed hazardous operation. Zero GitHub-hosted and local compute.