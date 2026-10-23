# 4400 — OEM press-brake ram restraint, maintenance LOTO, emergency rescue and manual-reference integrity
**Original source-reconciliation research | 2026-10-23 | DOCUMENTARY ONLY — not a selected-machine procedure, acceptance test or permission to operate.**

## Frozen engineering question
What does an actual hydraulic press-brake manufacturer's maintenance manual prove about **mechanical ram support**, **hydraulic pressure-zone verification**, **emergency entrapment rescue**, and **return to service**? Which statements become dangerous when copied into an unrelated LinuxCNC/OpenPressBrake retrofit? A second current manufacturer's public manual is used as an independent, differently scoped comparison.

## Exact inspected primary sources and provenance
| ID | Primary document, exact route | Scope and finding | Evidence |
|---|---|---|---|
| CI-2014 | Cincinnati Incorporated, *90–350 PROFORM+ Hydraulic Press Brake, Operation, Safety and Maintenance Manual*, EM-560 (N-06-14), copyright 2013, PDF pages 6–8 (printed 1-1 to 1-3), 50, 52–53 (printed 8-6 and 9-1/9-2). https://wwwassets.e-ci.com/PDF/Preinstallation/Press-Brakes/em-560-n-06-14-osmm-90-350-proform-plus.pdf | OEM model-specific manual with physical ram/cylinder/counterbalance identification, maintenance isolation, special entrapment release, and historical safe-speed footswitch discussion. | DOC-CONFIRMED, historical edition |
| HAAS-SAF | Haas Automation, *Haas Press Brake — Operator's/Service Manual*, section 3 Safety, online revision observed 2026-10-23. https://legacy-aem.haascnc.com/service/online-manuals/haas-press-brake---operator-s--service-manual/3---hpb---safety.html | For HPB 50-5 and 170-10, says trained staff, guard integrity, power lockout, complete standstill, and hydraulic-pressure relief. Does **not** specify a universal mechanical block or all hydraulic pressure zones. | DOC-CONFIRMED, web manual |
| HAAS-MAINT | Haas, same manual, section 6 Maintenance, revision A 07/2026. https://legacy-aem.haascnc.com/content/haascnc/en/service/online-manuals/haas-press-brake---operator-s--service-manual/6---hpb---maintenance-.html | Brief “POWER OFF” warning and maintenance intervals. A maintenance-summary page is not a complete machine-specific energy-control procedure. | DOC-CONFIRMED |
| OSHA-147 | OSHA 29 CFR 1910.147(d)(3)–(6), (f)(1): https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147 | Isolation, stored energy, verification, reaccumulation and temporary testing must be evaluated for the covered task. | DOC-CONFIRMED regulation; site applicability UNKNOWN |

No full 2022 ANSI B11.3 normative text, actual OpenPressBrake as-built drawing, machine inspection, physical test, or external competency oracle was obtained.

## Manufacturer-specific observations (do not transpose settings)
**CI-2014 printed 9-1** expressly limits its example LOTO procedure to typical energies of the specified PROFORM+ and says options/tooling/add-ons may add energy states. It begins with ram mechanically resting on closed tooling or appropriately selected supports **before** stopping drive, shutting down PC, padlocking main disconnect, and examining/managing residual hydraulic pressure at identified ports. Its printed support-capacity rule is **10% of this machine's rated capacity**, not 10% of ram weight and not a generic support sizing formula. It is *not* an acceptance criterion for another machine. [CI-2014 pp. 52–53]

**CI-2014 printed 9-1** specifies a particular main-manifold test port, counterbalance-manifold bleed features and waiting intervals for this model. The pressure observation at one named port does not establish all possible trapped volumes, accumulator gas-side energy, mechanical load holding or protection against reaccumulation on a different topology. The published bleed durations and gauge range are **historical OEM instructions only**, not generalized recommendations or steps for an unqualified technician. [CI-2014 p. 52; OSHA-147]

**CI-2014 printed 9-1/9-2** separates emergency entrapment release **with** and **without** electrical power. The no-power case calls for suitable external mechanical lifting/support and explicitly warns about high-pressure fluid/ejected fittings; it is not ordinary production reset, routine maintenance or a safe invitation to open an unidentified port. The power-available case relies on machine-specific control/ram-up operation. Rescue planning must address both availability states and must not require normal LinuxCNC/FPGA function as the only escape method. The listed model-specific ram masses are not generic lifting design data. [CI-2014 pp. 52–53]

**CI-2014 printed 8-6** describes a three-position hold-to-run footswitch for selected close-proximity/safe-speed applications and cites **ANSI B11.3-2012**. That historical reference is edition-scoped; the publisher currently lists B11.3-2022. It does not prove selected safe speed, actual stop performance or an independent safety function. [CI-2014 p. 50; https://www.b11standards.org/current-standards]

**HAAS-SAF / HAAS-MAINT:** the 2026 online HPB pages identify high pressure, ram crush hazard, lockout and pressure relief, but their public maintenance summary is not a hydraulic circuit-specific isolation/physical ram restraint design. “Press POWER OFF” is an ordinary interface action, not a complete maintenance energy-isolation witness. The two OEM manuals differ in detail and model scope; neither supplies a reusable OpenPressBrake hydraulic truth table.

## Newly observed OEM manual-reference inconsistency — safety-significant retrieval hazard
Cross-reading CI-2014's own figure legends against printed section 9 gives a concrete **DOC-CONFIRMED text/legend mismatch**, not a speculative fault:
- Printed 9-1 LOTO step 4 cites Figure **1-2 item 13** for the main disconnect; Figure 1-2 legend identifies **item 9** as main disconnect and lists only items 1–9.
- Printed 9-1 return-to-service step 7 cites Figure **1-2 item 8** for the main disconnect; the same legend identifies item 8 as the electrical enclosure, item 9 as the disconnect.
- Printed 9-1 drive stop cites Figure **1-3 item 8**; Figure 1-3 legend identifies item 6 as the main drive START/STOP, item 8 as UNCLAMP.
- Printed 9-1 drive start cites Figure **1-1 item 9**, and RAM UP cites **Figure 1-1 item 10**; the Figure 1-1 legend instead calls item 9 PENDANT ARM and item 10 CROWNABLE FILLER BLOCK. Figure 1-3 legend identifies RAM UP as item 3.
- The no-power entrapment subsection's prose says support but do not raise until “step 5,” while its numbered steps refer to raising before the continuous-support step. Treat the sequencing reference as **ambiguous**; do not silently fix or use it as an operational rescue script.

**Method lesson:** a manufacturer document is authoritative for its declared product scope but not immune to internal editorial mistakes. Where an instruction's cross-reference is contradictory, quarantine that locator, inspect the actual labeled hardware/approved latest OEM revision, and obtain qualified clarification before work. Do not reinterpret a control location by guessing from an inconsistent item number. The PDF screenshot attempt timed out, so this mismatch is established by the **extracted legends and procedure text**; actual visual/physical verification remains UNKNOWN.

## Physical-proposition / authority allocation
| Proposition | Ordinary LinuxCNC/HMI may show | Independent physical/safety evidence still needed |
|---|---|---|
| STOP | stop requested, velocity trend | selected safety-function response and actual hazardous ram stop in relevant modes |
| HOLD | position appears stationary | mechanically credible ram restraint under fault/power-loss, verified load path and supports |
| ENERGY | motor off, one gauge zero | actual isolation points, every exposed fluid/gas/pilot zone, stored/reaccumulating energy |
| ACCESS/ESCAPE | guard closed, E-stop active | physical clearance, egress under power loss, occupied-zone release and trapped-person rescue plan |
| RESTART | software reset or safety output healthy | separately authorized deliberate fresh start after clearance and restoration of all protection |
| MAINTENANCE | maintenance mode selected | qualified machine-specific LOTO, residual-energy control and no exposed-person hazardous motion |

**INFERENCE:** a software-maintained “support installed” checkbox can be a maintenance checklist aid, but must not replace inspection of load-bearing geometry, capacity, stability and actual engagement. A padlocked disconnect does not prove the ram cannot descend if its gravity/hydraulic support path is unknown.

## Design-for-use / adversarial review
1. **Block convenience:** Provide a designed, labeled, reachable storage/mounting position for approved ram restraints, with clear visual witness and minimal tools; otherwise workers will be tempted to skip them. Mechanical load-bearing rating and safe placement must come from the selected design, not this document.
2. **Service reach:** Guard/access design should let technicians isolate and inspect pressure zones without reaching beneath an unsupported ram or defeating protection. Make a guard easy to reinstall and ensure reinstallation is verified.
3. **Rescue:** The rescue plan is a separate emergency competence, equipment and access question; never require an injured/trapped person to operate a control, and never assume an E-stop or power-off creates upward clearance.
4. **Ambiguous manual:** When a numbered figure points at the wrong device, stop using that locator. Resolve with model/serial/revision evidence, manufacturer clarification and qualified inspection, not memory or a copied internet procedure.
5. **Transfer counterexample:** A 2014 model-specific 10%-capacity support example, 5-second bleed example or 2026 Haas “POWER OFF” label cannot be combined into a universal 2026 OpenPressBrake commissioning specification.

## Required selected-machine intake and release gate
Before any personnel-exposed operation or live proof: obtain actual machine ID/serial, revision, current OEM/service bulletins, ram mass and load cases, physical restraint design and capacity, ram/bed load path, die/tooling and extra axes, hydraulic drawings with pressure-zone/accumulator/pilot/bleed/test-port identification, power-isolating devices, guarding and egress, rescue resources and competent reviewers. Map to existing `IN-01..10`, `PHY-STOP/HOLD/ACCESS/ESCAPE/ENERGY/RESTART`, `SRS/ENE/VAL/PT/RR` artifacts. All remain **UNKNOWN/NOT RUN**; G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD. If minimum safeguards cannot be demonstrated, keep people out of the danger zone; development motion only isolated/remote under a separately reviewed residual-risk plan.

## Evidence / uncertainty
- **DOC-CONFIRMED:** the precise Cincinnati and Haas wording, model scope, publication/revision labels and CI figure-reference inconsistencies described above.
- **INFERENCE:** human-factors bypass incentives and transfer-failure paths; these are design hypotheses requiring review, not field observations.
- **SOURCE-CONFIRMED:** no new LinuxCNC source claim in this branch.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none used.
- **UNKNOWN:** selected machine's stop/hold/energy/escape/restart behavior, mechanical support strength, hydraulic topology, standard-specific compliance, independent validation, and the unviewed PDF figures as images.

**No compute or physical lab justified:** source and editorial contradictions are answerable from authoritative documentation. Physical truth requires as-built selected hardware and qualified review; no synthetic simulation can supply it. Exact historical archive backlog remains **6/85** pending original bytes. External 2520–25F0 competency gates OPEN.
