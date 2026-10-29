# 4400-ROPE-STOP-01 — Pull-wire emergency stop: cable tension, break detection, reset visibility and physical stop boundary

**2026-10-29 | 4000 safety course | original manufacturer-source audit | NON-GRADUATED | NO machine test**

## Question and novelty

What does a long emergency-stop rope actually detect, what does its green indicator mean, and when can a technician reset it without creating a new hazard? This is a **new exact device-mechanism and human-factors branch**, not another general 2530 E-stop lesson. Direct synonym review of the complete `safety-course/SAFETY_COURSE_INDEX.md`, `SAFETY_COURSE_RESEARCH.md`, `CURRICULUM.md` and `PROGRESS.md` found no rope/cable-pull safety audit. Nearest predecessors: 2530 E-stop span/reset, 2590 protective devices, 4400-GUARD-01 guarded access, and 4400-RST-01 fresh restart. Preserve their existing competencies; this is unscored transfer.

## Inspected original evidence and provenance

1. **DOC-CONFIRMED** — Rockwell Automation, *Lifeline 5 Cable-pull Safety Switch Installation Instructions*, publication **440E-IN008H-EN-P, February 2026**, 20-page original manufacturer PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/in/440e-in008_-en-p.pdf . Inspected pp.1–6, 18–19; p.2 model/ratings table; pp.4–6 safety-function and output-state tables, rope setup, diagnostic tension, inspection and reset. This edition supersedes August 2025 G. Model families include 5-pin/8-pin and single/dual-head variants; do not transfer a wiring/output assertion to an unverified variant.
2. **DOC-CONFIRMED** — Schmersal, *ZQ 700 Pull-wire Emergency Stop Switch Operating Instructions*, **573753-EN/C, September 2021**, six-page original manufacturer PDF: https://products.schmersal.com/media/documents/DOC_MAN_MEC_ace-mrl-zq700_SEN_AIN_V3.pdf . Inspected pp.1–5, especially p.2 §2.3 and p.5 §5.1–5.2. Device is mechanical and explicitly detects wire pull **or breakage**; NC contacts close only in correct tensioned run condition; manual latch/reset.
3. **DOC-CONFIRMED** — Schmersal manufacturer product family page https://products.schmersal.com/en_US/pull-wire-emergency-stop-switches-1000074527 distinguishes ZQ700 **up to 10 m** and ZQ900 **up to 75 m**; do not generalize the ZQ700 limit to other models.
4. **DOC-CONFIRMED (catalog scope, not full standard text)** — ISO official catalog for **ISO 13850:2015**, https://www.iso.org/standard/59970.html : E-stop is a functional design principle, not a standalone guarantee of physical braking, energy isolation or shielding. The manufacturer instructions additionally invoke IEC 60947-5-5. Full paid normative clauses of those standards were not inspected.

No LinuxCNC software is a component of these original safety-device internals. Normal LinuxCNC/HAL may monitor status and request ordinary stop, but it must not replace independent safety logic and final elements.

## Exact comparison: two distinct implementation families

| Proposition | Rockwell Lifeline 5 (electronic, selected manual) | Schmersal ZQ700 (mechanical, selected manual) | Design implication |
|---|---|---|---|
| Cable intentionally pulled | Safety outputs OFF; reset required | NC contacts open and latched | Both require downstream independent safety system and physical stop validation. |
| Cable cut / not tensioned | Safety outputs OFF; red status/amber tension flash in Table 6/7 | Pull/break activates stop, latch retained | A mere normally-open ordinary input is not equivalent to monitored rope integrity. |
| **Low or high but still tolerated tension** | **Safety outputs ON, status GREEN, tension amber flashes** (Table 6/7); manual calls for maintenance/adjustment | Manual requires correctly pre-tensioned run condition; no equivalent electronic pre-warning output is documented | **Key finding:** green is not proof of fully maintained cable margin. Separate maintenance warning from personnel-safety permissive. |
| Sensor setup | Requires manufacturer tension spring; special setup/reset sequence; output tables vary 5/8 pin | Proper pre-tension and central position indicator required | Do not remove spring, substitute arbitrary rope or guess tension. |
| Reset | Manual reset button; full cable-length visibility or qualified inspection before/after reset | Blue manual reset after determining cause; correct tension required | Reset only clears device latch, not machine zone occupancy or authorizes automatic cycle start. |
| Maximum length | Single-head 100 m / dual-head 200 m in February 2026 publication | ZQ700 maximum 10 m | Never copy length/force/timing from a different product family or selected installation. |

**Specific Rockwell manual nuance:** p.5 Table 6 and Table 7 show **green + amber tension flash with safety outputs ON** for marginal low/high tension. The amber condition is an early maintenance diagnostic, **not a protective trip** in that state. A design that maps only the two OSSDs to a green “rope perfect” lamp silently discards useful warning. Conversely, the warning output is not a substitute for safety-rated outputs.

**Mechanical failure chain:** a rope pulled at a difficult-to-reach location, a cut/slack cable, an obstructed pulley, an anchor that yields, an incorrect spring, excessive friction, or temperature-induced tension drift can each affect accessibility/actuation or reliability. OEMs specify mounting and inspection. A visible intact cable does **not** independently prove that every segment can be actuated within the required force/travel envelope. Rockwell explicitly requires all pull directions along the installed length to be functionally verified during commissioning; this is **qualified future physical validation**, not an instruction to test an operating machine now.

## Four authority boundaries

1. **Input/accessibility:** rope placement must actually be reachable from foreseeable exposure points; a distant mushroom button does not cover an inaccessible conveyor side. Cable snagging, fouling and personnel access are layout-specific.
2. **Safety logic:** use the selected device's appropriate safety channels, fault detection, reset behavior and interface. The Rockwell 8-pin tension indication is diagnostic; the Schmersal NC contact is not by itself a full safety system.
3. **Final elements and physics:** independent safety logic must act through verified motor/drive/contactors/brakes/valves; a software stop, a released switch latch, or a green lamp does not prove zero motion, gravity load retention or removal of stored energy.
4. **Maintenance isolation:** E-stop does not replace qualified hazardous-energy lockout for work inside the hazard. A worker may be out of sight when a rope is reset; visible or verified zone clearance and fresh deliberate restart remain separate.

## Adversarial design review — paper only

| Fault / shortcut | Unsafe shortcut | Correct design/verification question | Status |
|---|---|---|---|
| Broken cable | Treat unpulled rope as healthy | Does selected switch fail to safe output on loss of tension and is this monitored downstream? | OEM device behavior DOC-CONFIRMED; installed wiring UNKNOWN |
| Green with amber tension flash | Hide amber, display “ALL GOOD” | Does maintenance UI expose pre-trip tension warning and make repair easy without bypass? | Rockwell diagnostic DOC-CONFIRMED; installed UI UNKNOWN |
| Cable not visible at reset | Reset from cabinet without inspection | How is full rope span and danger zone checked before/after reset, per selected OEM and risk assessment? | OEM DOC-CONFIRMED; site UNKNOWN |
| Two long zones share one reset | Assume reset means both zones clear | Are hazard span, visibility, independent permissions and fresh start defined for each zone? | INFERENCE; selected SRS UNKNOWN |
| Cable obstructed by stock | Bypass switch to finish production | Can cable be rerouted, supported, protected and reached without adding defeat incentive? | INFERENCE human factors |
| Conveyor stops electrically but inertia persists | Assume OSSD OFF equals safe access | What independent stopping/guard/hold physical witness is required for the hazard? | Machine physics UNKNOWN |
| E-stop used during maintenance | Substitute rope for lockout | What physical energy isolators, stored-energy control and individual LOTO protection apply? | Safety methodology DOC-CONFIRMED; selected site UNKNOWN |

## Practical implementation decision

For a long conveyor, feeder, material-handling line or other distributed hazard, a properly selected rope switch can be a practical low-complexity way to provide accessible **complementary emergency stopping**. It is **not a guard** against nip points, entanglement or ejected material. Prioritize fixed guards at contact points, independent stop logic, accessible/maintainable rope routing, physical energy isolation for service, conspicuous diagnostic tension indicators, and reset locations with a credible visibility/inspection method. On a press brake, rope placement must not displace point-of-operation guarding or independent Y1/Y2 stop/hold functions. No specific OpenPressBrake rope is claimed installed.

## Verification gates and status

- **Source/documentary:** two original OEM manuals and official ISO catalog inspected; edition-specific claims above are DOC-CONFIRMED. No invented PL/SIL, cable force, machine stopping time, stopping distance, or hydraulic valve truth table.
- **TEST-CONFIRMED:** none. No simulation, build, workflow, lab or machine actuation. No hosted or self-hosted compute.
- **UNKNOWN:** selected switch and firmware, exact rope routing, tension/thermal margin, downstream safety logic, final elements, safety integrity, maintenance accessibility, qualified functional proof, machine stopping/holding, and actual operator bypass behavior.
- **Release:** OpenPressBrake Stage A A–G still unverified; **G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD.** Independent 2520–25F0 evaluation OPEN. No personnel-exposed hazardous operation authorized.

## Precise next work

Qualified site reviewer should first obtain documentary equipment identification and passive rope/guard layout evidence if a selected machine actually uses a rope switch. A qualified, separately approved, energy-controlled validation plan may later define safe functional checks with people outside the hazard zone; no ad hoc pulling or rearming of a live machine. If no rope exists on the selected machine, retain this as cross-machine safety teaching, not a new OpenPressBrake hardware requirement.
