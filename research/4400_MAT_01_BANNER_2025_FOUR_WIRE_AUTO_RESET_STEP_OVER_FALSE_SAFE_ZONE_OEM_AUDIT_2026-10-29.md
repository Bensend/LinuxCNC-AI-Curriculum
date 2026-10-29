# 4400-MAT-01 — Pressure-sensitive safety mat: auto-reset re-enable, step-over, four-wire integrity and false PL transfer

**2026-10-29 | 4000 safety | original OEM source audit | NON-GRADUATED | NO physical testing**

## Question, novelty and prerequisites

Can a machine be made safe by placing a pressure-sensitive mat in front of the hazard, and what happens when the operator steps off it? The full current safety index, research plan, curriculum and progress were scanned for `safety mat`, `pressure-sensitive mat`, `floor`, `step over`, and `auto reset`. Existing 2530 E-stop, 2590 protective devices, 4400-GUARD-01 and RST-01 address general stop/reset and safeguarding, but no prior full original-OEM **four-wire mat plus auto-reset and step-over** source trace was found. This is a new implementation transfer, not a new scored competency.

## Direct authoritative evidence

1. **DOC-CONFIRMED** — Banner Engineering, *SM-xA-5A Safety Mat Monitoring Modules*, **p/n 122364 Rev F, 04-Nov-2025**, **12-page original manufacturer PDF**: https://info.bannerengineering.com/cs/groups/public/documents/literature/122364.pdf . Directly inspected pp.1–9 and troubleshooting, particularly p.1 functions/reset, p.2 four-wire warning and mat sensitivity, pp.3–4 bypass and stopping-distance discussion, pp.6–9 wiring, diagnostics, periodic checks and qualified validation.
2. **DOC-CONFIRMED** — Rockwell Automation, *MatGuard Control Units* product page: https://www.rockwellautomation.com/en-us/products/hardware/safety-products/safety-relays-mat.html . States four-wire open/short detection, optional auto/manual reset, two safety relays and a multi-mat monitored zone. This is **product-page evidence**, not inspection of Rockwell's full original installation manual.
3. **DOC-CONFIRMED** — ISO publisher catalog **ISO 13856-1:2013**, second edition April 2013, https://committee.iso.org/standard/57017.html : defines pressure-sensitive mat/floor design/testing scope, but explicitly leaves application dimensions, suitability and selected-machine PL allocation application-specific. **Only public catalog abstract inspected, not full normative clauses**.
4. **DOC-CONFIRMED** — Schmersal manufacturer mat family https://products.schmersal.com/en_US/safety-mats-1002145224 lists SMS4/SMS5 floor-mat constructions; does not establish interchangeability with Banner's selected four-wire controller.

## Exact original OEM findings

- **Auto reset is a re-enable event, not proof of zone clearance.** Banner Rev F p.1 says in auto-reset mode the module's output relays energize automatically after all sensors clear/faults corrected and power is applied. If the selected design uses this mode, the **machine's independent safety architecture must still prevent unexpected hazardous restart**. Manual reset at the module is one approach, but even it does not replace a separate fresh cycle start.
- **A person can step completely across a mat and disappear from its sensing surface while remaining in the danger zone.** Banner p.3 expressly requires supplemental safeguards or measures against unexpected start in this situation; at minimum manual reset and re-initiation of normal actuation. A mat is not a volumetric occupancy sensor.
- **A 4-wire monitoring module cannot simply accept any two-wire mat.** Banner p.2 explicitly disallows two-wire devices with or without resistors; the system monitors redundant conductive paths, interconnect failures and resistance. Rockwell separately advertises a four-wire system. The actual selected mat/controller pairing must be verified against the exact OEM manual.
- **Controller rating is not the assembled safety function rating.** Banner Rev F p.1 distinguishes its internal module's Category 4 design from Category 3 when a four-wire safety mat is connected, and warns that system integrity depends on sensors, wiring and final elements. No PL/SIL for a selected machine can be inferred from a controller catalog.
- **Safety mat as a START button is specifically prohibited in this OEM manual.** Banner p.2 warns against reverse/negative logic that enables hazardous motion when someone stands on a mat, including faults that could falsely enable. A mat should demand stop or inhibit unsafe start, not command motion.
- **Qualified validation is individual, not “one mat somewhere.”** Banner pp.8–9 says check each mat individually, including multi-mat series installations, and validate no automatic restart after removing the test piece. These are manufacturer procedures for qualified commissioning, **not authorization to step on or test an operating machine during this study**.

## Fault-path matrix (source/document versus application inference)

| Credible event | Hazardous shortcut | Required independent discriminator | Evidence |
|---|---|---|---|
| Person crosses mat into cell and steps off | Assume mat clear = cell empty | Whole-body access prevention, zone-clear strategy, manual reset and fresh start | Banner DOC-CONFIRMED, selected machine UNKNOWN |
| Auto-reset module sees mat clear after power return | Feed relays directly to run command | Independent deliberate start and physical final-element safety architecture | Banner DOC-CONFIRMED; exact selected wiring UNKNOWN |
| Two-wire mat connected to four-wire monitor | “Works in a bench continuity check” | Exact OEM compatible wiring and fault coverage, no resistor substitution | Banner DOC-CONFIRMED |
| Mat wiring damaged or resistance rises | Ignore fault LEDs or short channels | Correctly monitored open/short and qualified resistance/coverage validation | Banner DOC-CONFIRMED |
| Mat covered by chips, platform or rigid bridging plate | Assume person weight reaches sensing layer | Inspect physical surface, bypass route, contact sensitivity, environmental suitability | INFERENCE; site UNKNOWN |
| Mat mounted too close to hazard | Treat catalog relay response time as stopping distance | Application-specific measured total stop time and validated separation geometry | ISO catalog scope + Banner DOC-CONFIRMED; machine UNKNOWN |
| Controller has “Category 4” on brochure | Declare entire mat-to-motor system PL e | Selected sensor/controller/output/final-element architecture, CCF and full validation | Banner DOC-CONFIRMED controller-vs-system distinction |
| Technician uses mat as “hold to run” pedal | Reverse logic to enable ram motion | Do not use mat as positive machine start; select appropriate separately evaluated enabling device | Banner explicit DOC-CONFIRMED |

## Practical human factors and cross-machine transfer

A floor mat may be an affordable, low-setup guard supplement for robot cells, loaders, conveyors, feeders, punching or woodworking zones **when the geometry and risk assessment justify it**. Keep it visible, easy to clean, replaceable and hard to bridge with stock or debris; choose cable routing and edge trim that survive the environment. For whole-body access, use complementary guard/entry/clearance measures so stepping off cannot create false “all clear.” Keep independent safety controller and physical energy-removal/holding functions separate from LinuxCNC/HAL/FPGA status. A press brake's point-of-operation hazards cannot be considered solved merely by a mat at the operator's feet.

## Claims and release

**DOC-CONFIRMED:** original Banner manual p/n/edition, Rockwell product description, ISO publisher abstract and Schmersal family page. **SOURCE-CONFIRMED:** no LinuxCNC source claim in this audit; ordinary control is explicitly not the personnel-safety authority. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none. **INFERENCE:** bypass and site layout failure chains. **UNKNOWN:** selected device, floor geometry, real sensor sensitivity, stopping distance, physical final elements, actual reset/zone-clear behavior, installed safety performance and worker exposure.

No machine actuation, physical validation, simulator, build, workflow or compute. Qualified physical verification would require a separately approved energy-controlled plan, not ad hoc walking on a live mat. OpenPressBrake Stage A A–G and independent 2520–25F0 evaluator still OPEN; **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD; no personnel-exposed hazardous operation.**
