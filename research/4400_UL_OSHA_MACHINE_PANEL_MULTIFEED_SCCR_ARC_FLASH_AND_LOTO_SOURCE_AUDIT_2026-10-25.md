# 4400-PANEL-01 — Original UL/OSHA multi-feed panel SCCR, arc-flash and isolation source audit
**2026-10-25 | 4400 safety | NON-GRADUATED | documentary research, NOT a selected-machine approval**

## Question and source method
When a LinuxCNC/OpenPressBrake retrofit adds a panel PC, separate auxiliary supply, drive, 24 V controller or a second cabinet, which *different* engineering propositions must be checked before a person opens or services the electrical enclosure? Do not equate a CNC E-stop, a safety STO, a lockable handle, a breaker rating, a panel SCCR label or an arc-flash label.

Sources were reviewed 2026-10-25. The two UL Solutions original publisher pages were opened and inspected directly; the OSHA original regulatory pages and interpretation were checked from official indexed text (direct page-open returned 403 in this session). Thus UL claims are **DOC-CONFIRMED (direct)**; OSHA claims are **DOC-CONFIRMED (official indexed, full page retrieval limited)**. Neither establishes a selected installation.

## Primary-source ledger
| ID | Source and specific location | Narrow source-supported proposition | Limits |
|---|---|---|---|
| UL-1 | UL Solutions + Eaton Bussmann, *Determining Short-Circuit Current Rating (SCCR) for Machinery*, FAQ under 2021 NFPA 79; https://www.ul.com/resources/determining-short-circuit-current-rating-sccr-machinery | Multiple machine supply sources require knowing available fault current at **each** supply disconnect; applicable panel/machine SCCR must be adequate for that available current. | 2021-edition FAQ, not proof of a specific machine or adopted edition. |
| UL-2 | Same FAQ, questions on multi-panel nameplates and 24 VDC | Multiple control panels and their supply paths must be accounted for. A 24 VDC panel with **only control circuits** is treated differently for SCCR than one with a power circuit. | Do not convert “24 V control-only SCCR not required” into “24 V cannot injure” or “no isolation required.” |
| UL-3 | Same FAQ, series ratings/current-limiting devices | Simply adding a current-limiting fuse or breaker does **not** automatically establish acceptable SCCR; listed combination/conditions or qualified engineering evaluation are needed. | No field retrofit value or shortcut is supplied. |
| UL-4 | UL Solutions, *Short Circuit Current Ratings for Combination Motor Controller Components*, General/Use; https://www.ul.com/resources/short-circuit-current-ratings-combination-motor-controller-components | UL 508A Supplement SB is an accepted panel SCCR method; published combination ratings apply only with the **specified components** and conditions of acceptability. | A single device's interrupting rating is not automatically the assembled panel SCCR. |
| OSHA-1 | OSHA 29 CFR 1910.333(b)(2)(ii)(B)–(D), (iv)(A)–(B), (v); https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.333 | Control switches/interlocks are not the sole means of deenergizing; account for stored energy; qualified verification tests exposed parts and checks unrelated backfeed; deliberate reenergization includes tools/jumpers/personnel-clear review. | OSHA electrical-work scope and qualifications apply; no generic live-test authorization. |
| OSHA-2 | OSHA 29 CFR 1910.303(b)(4)–(5); https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.303 | Interrupting capability and coordinated fault clearing are installation concerns, not merely ordinary control status. | Does not give available fault current at OpenPressBrake. |
| OSHA-3 | OSHA 29 CFR 1910.335(a)–(b); https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.335 | Electrical PPE, insulated tools, shields/barriers and warning/access controls depend on task and exposure. | No PPE category, incident-energy number or approach boundary determined here. |
| OSHA-4 | OSHA 2006-11-14 interpretation; https://www.osha.gov/laws-regs/standardinterpretations/2006-11-14 | The **historical Subpart S** interpretation says OSHA had no specific arc-flash warning-label provision in that rule, while electrical hazard warnings and protective practices still apply; NFPA 70E has separate consensus-standard provisions. | Do **not** infer that no current code, adopted standard, employer policy or equipment label requirement exists. |
| OSHA-5 | OSHA Electric-Arc Flash Hazards; https://www.osha.gov/electrical/flash-hazards | Arc-flash risk exists even at nominally low voltage; current and clearing time matter. | This educational page does not establish a particular panel's incident energy. |

## Five separate propositions (do not collapse)
1. **SCCR adequacy** — selected assembly's rated ability to withstand the available short-circuit fault current under its specified protection/combination. **Not** a shock/arc-flash exposure calculation.
2. **Interrupting/coordination** — the installed protective devices actually interrupt the prospective fault and coordinate with downstream equipment; do not borrow a fuse's rating for the whole cabinet.
3. **Electrical isolation** — identify *all* sources (facility feed, auxiliary supply, external powered PC/UPS, DC link, cross-fed I/O, retained capacitor energy) and qualified verification at the parts to be touched. The listed examples are **possible topology questions**, not installed OpenPressBrake facts.
4. **Arc-flash/shock task exposure** — identify who opens which enclosure, which live parts could be exposed, incident-energy/approach/PPE requirements as determined by qualified assessment; SCCR alone cannot answer this.
5. **Machine mechanical safety** — removing electrical energy can change a gravity/hydraulic load state. The independent Y1/Y2 stop/hold/energy/guard/rescue safety functions require their own physical witnesses. LinuxCNC, FPGA, a panel PC and an HMI alarm are not personnel-safety authority.

## Adversarial failure-path examples (INFERENCE, not machine findings)
| Condition | Why a superficially reassuring observation is insufficient | Required evidence |
|---|---|---|
| Main disconnect OFF, separate PC/auxiliary feed ON | An unrelated feed/backfeed may still energize exposed conductors. | As-built supply/terminal topology, all isolation points and qualified absence-of-voltage verification. |
| Safety STO asserted and E-stop lamp red | Torque command inhibited does not physically isolate incoming electrical conductors or discharge capacitors. | Separate lockable energy-isolating device and residual-energy evidence. |
| Main breaker “65 kA” but downstream panel “5 kA” | Interrupting rating, combination rating, panel SCCR and available fault current are different quantities. | Qualified assembly SCCR calculation/marking and site fault-current comparison. |
| New fuse added upstream | A different fuse or conductor may not be an approved current-limiting combination. | Exact part/combination instructions and re-evaluated SCCR. |
| Panel 24 VDC, motor outputs present | UL FAQ's control-only exception may not apply. | Circuit classification and qualified panel assessment. |
| Arc-flash label present, service technician removes dead front | Label does not remove shock/arc hazard; task/exposure changes. | Electrical safe-work plan, task-specific assessment, isolation and access control. |
| Main AC removed, ram remains raised | Electrical safe state does not establish gravity load support. | Separate qualified hydraulic/mechanical holding witness. |
| Power returns after electrical service | Old foot/run request or temporary jumper could create unexpected motion. | Independent safety reset/rearm and fresh intentional start, plus tool/jumper removal and people-clear check. |

## Provenance / unresolved evidence
- **SOURCE-CONFIRMED:** no new LinuxCNC source trace in this study; existing normal-control paths remain distinct from physical safety.
- **DOC-CONFIRMED:** UL-1..4 directly inspected; OSHA-1..5 official indexed original material, direct open access limited. Distinguish publisher guidance from actual normative text.
- **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none used.
- **INFERENCE:** five-proposition model and failure-path analysis.
- **UNKNOWN:** selected OpenPressBrake supplies, panel SCCR, fault current, interrupting ratings, protective coordination, UPS/auxiliary feed, exposed live parts, incident energy, task qualifications, DC discharge, Y1/Y2 holding, physical validation and adopted editions.
- **STOP:** no arc-flash calculation, PPE class, current rating, voltage-absence test, breaker/fuse substitution, or energized experiment is authorized by this document. A qualified electrician/safety engineer must establish actual values and safe work conditions.

## Distinct value / information-gain stop
The previous TOOL-01/02 branch is source-limited without selected tooling. This electrical-panel branch adds a previously underrepresented machine-wide hazard, not another 3000 specialization or controller-board design task. Documentary study is complete for these propositions; reopen with restricted as-built power diagrams, utility fault-current evidence, panel labels/BOMs, exact protective-device combinations and a qualified independent review. No proprietary details belong in this public repo.
