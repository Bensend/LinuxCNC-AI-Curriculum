# 4400-EDM-01 — Original OEM audit: feedback loop, reset edge, default configuration and final-element scope
**2026-10-25 | primary manufacturer documentation | documentary research only | NON-GRADUATED**

## Research question
Does a safety relay's READY/green indication, manual-reset button, or EDM feedback prove that hazardous motion cannot restart and that an attached hydraulic ram is physically safe? **No.** These are separate propositions, and the OEMs document materially different start/reset behaviors. This audit is generic; no selected OpenPressBrake part or circuit is known.

## Original sources inspected
1. **Pilz PNOZ s4 operating manual 21396-EN-14** (2015 edition, 36-page original): https://www.pilz.com/download/open/PNOZ_s4_Operat_Man_21396-EN-14.pdf — printed pp. 10–16, especially function description p.10, mode selector p.13, start/feedback diagram and automatic-restart warning p.15, operation p.16. Official publisher also lists later editions, including 21396-23 (2026); this audit does **not** establish identical behavior in those editions.
2. **OMRON G9SE-201/G9SE-401/G9SE-221-T instruction sheet**, original two-page manufacturer PDF: https://assets.omron.eu/downloads/latest/manual/en/4022078_g9se-201_g9se-221-t_instruction_sheet_en.pdf — printed sections 4–8, notably p.2 feedback/reset wiring, manual-reset edge, delayed-output restoration and PL/category limitation. The document's exact release date is not established here.
3. **SICK C4000 Palletizer Standard/Advanced / C4000 Fusion**, original operating instructions **8012249/YT69/2016-02-25** (124 pages): https://www.sick.com/media/docs/5/15/615/operating_instructions_c4000_palletizer_c4000_fusion_en_im0026615.pdf — printed pp. 28–30, 77–78 and 88. These findings are product/edition-specific, not claims about every SICK receiver.
4. **Pilz manufacturer's ISO 13850 interpretation**, accessed 2026-10-25: https://www.pilz.com/en-US/support/faq/standards/articles/180045 — releasing an actuated E-stop prepares for restart, does not itself initiate it. This is manufacturer standards commentary, **not** inspection of the paid normative text.

## Exact source-backed findings
| ID | Classification | Direct manufacturer evidence | What it does NOT prove |
|---|---|---|---|
| E01 | DOC-CONFIRMED | PNOZ s4 p.10 distinguishes **automatic**, simple **manual**, monitored **falling-edge** and monitored **rising-edge** start, plus startup-test mode. Falling-edge operation requires the start circuit to close and open; rising-edge requires closure after a waiting period. | A generic “manual reset” label does not establish stuck-button/bridged-start detection for an unverified mode. |
| E02 | DOC-CONFIRMED | PNOZ s4 p.15 explicitly warns that **automatic start or a bridged manual start contact** can re-enable the unit when a safeguard is restored; external measures must prevent unexpected restart. | Releasing E-stop cannot be assumed to remain latched off solely because the module is called a safety relay. |
| E03 | DOC-CONFIRMED | PNOZ s4 p.15 shows **with and without feedback loop** options; p.12 warns auxiliary 41–42 and semiconductor Y32 **must not** be used for safety circuits. | An HMI output/auxiliary contact is not a safety final element; a feedback option is not necessarily wired/enabled. |
| E04 | DOC-CONFIRMED | OMRON G9SE p.2 requires **forcibly guided contactors/relays** and NC feedback to T31–T32 for manual reset or T31–T33 for automatic reset in its illustrated category applications. Manual T32 input requires an **OFF→ON→OFF** sequence. | Substituting a generic PLC “contactor energized” bit for mechanically linked NC contacts is not the illustrated EDM architecture. |
| E05 | DOC-CONFIRMED | OMRON G9SE-221-T p.2 says when inputs recover during off-delay: **automatic mode** outputs switch off after delay and then turn back on immediately; **manual mode** waits for reset. | A timed stop does not necessarily imply a new manual rearm. The exact product, settings and safety-distance calculation matter. |
| E06 | DOC-CONFIRMED | OMRON p.2 explicitly says the component's up-to-PL e/category-4 applicability under specified example conditions **does not automatically confer** the same rating on the machine. | No selected-machine PL, PFHd or diagnostic coverage established. |
| E07 | DOC-CONFIRMED | SICK C4000 printed p.29 distinguishes **light-curtain internal reset** (can re-enable OSSDs) from **external machine restart interlock**; when both are implemented, two separately sequenced buttons are described. | Light-curtain green/OSSD re-enable is not evidence that the machine's physical motion path is safe or a fresh ordinary motion request exists. |
| E08 | DOC-CONFIRMED | SICK C4000 p.30 and p.77 describes EDM monitoring of contactor de-energization via **positively guided NC feedback**. The documented 300 ms EDM response criterion belongs to this exact device/edition. | NC contactor feedback does not directly measure hydraulic port flow, Y1/Y2 gravity holding, actual stop distance or isolated pressure. |
| E09 | DOC-CONFIRMED | SICK C4000 printed p.88 says factory default **internal restart interlock enabled**, **EDM disabled**. Printed p.78 warns replacement requires rechecking configuration; rewiring alone does not preserve an intentionally disabled reset function. | A replacement with matching connectors/green lamp does not establish retained safety behavior or diagnostic coverage. |
| E10 | DOC-CONFIRMED | SICK C4000 p.29 warns that if a person can pass the protective field and approach the hazard, disabling both restart interlocks creates serious risk; reset placement outside the hazard with visibility is required in its application guidance. | This is not a measured safe approach distance or proof of the selected guard's physical installation. |

## Adversarial failure paths and their legitimate witnesses
**A. Bridged reset / stuck button.** A simple manual-start circuit may behave differently from monitored-edge start. **INFERENCE:** an application should require a deliberately fresh, appropriately monitored safety rearm and separately fresh ordinary motion command. Evidence: exact relay order code, mode selector/configuration, wiring, fault behavior and qualified review. A software UI reset does not replace this.

**B. Welded contactor.** Proper NC mechanically linked EDM can prevent re-enabling when a downstream contactor fails to drop. **DOC-CONFIRMED** SICK/OMRON illustrated behavior; **UNKNOWN** if selected machine has this circuit. EDM does not prove the motor contactor has physically interrupted every hazardous hydraulic path; backfeeds, accumulators, relief, gravity and valves remain separately mapped.

**C. Protective field clears during delayed stop.** G9SE-221-T automatic mode may re-enable after the off-delay when inputs have already recovered. **INFERENCE:** do not treat the presence of an off-delay as restart prevention. Physical stop/approach time must be independently engineered; no generic time is supplied.

**D. Safety receiver replacement.** SICK's documented factory defaults demonstrate configuration drift even with identical wiring. **INFERENCE:** preserve signed configuration identity plus as-built proof, independent EDM wiring witness, guard geometry and a controlled fresh-rearm acceptance. Never count CRC or indicator alone as functional proof.

**E. Two reset layers.** SICK internal reset may restore OSSDs while external machine restart still blocks motion. **INFERENCE:** design operator-facing prompts for clear sequencing; avoid a hidden second button that predictably leads to bypass. Keep reset stations outside hazard with complete sightline; use a separate verified presence-sensing/escape strategy if full visibility is impossible.

## Four distinct authority layers
1. **Ordinary LinuxCNC/HAL/FPGA:** motion requests, stop commands, normal diagnostics and UI. **Not** independent personnel-safety authority.
2. **Safety-related logic:** hazard-specific stop/restart interlock, EDM monitoring and fault latching, exact qualified components.
3. **Physical final elements:** contactor/drive/safety valve and actual electrical/hydraulic energy containment or removal; EDM may observe *one* final-element position, not every downstream hazard.
4. **Independent physical witness and maintenance:** Y1/Y2 actual stop and hold, guard access, pressure-zone isolation, mechanical restraint and deliberate rearm verification. Must be qualified per selected machine.

## Scope and unknowns
**SOURCE-CONFIRMED:** no new LinuxCNC source inspected in this audit. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied upon. **INFERENCE:** proposed architecture/acceptance and human-factors mitigations. **UNKNOWN:** selected OpenPressBrake safety relay/PLC, contactors, feedback loop, guard/light-curtain model, hydraulic final elements, modes, PL/SIL, stop distances, actual G0 evidence and evaluator score. The OEM manuals are not a substitute for a machine-specific SRS or validation. Do not energize a machine, defeat a guard, simulate a welded contactor on hardware, or permit personnel exposure from this paper audit.

## Next evidence
Qualified restricted G0 package: as-built exact part/firmware/manual edition, safety wiring, feedback-contact identity, reset button and sightline, configuration readback, power-return behavior, independent stop/hold/isolation final elements and fresh ordinary command. If absent, G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED. No software lab can resolve the selected-machine physical questions.
