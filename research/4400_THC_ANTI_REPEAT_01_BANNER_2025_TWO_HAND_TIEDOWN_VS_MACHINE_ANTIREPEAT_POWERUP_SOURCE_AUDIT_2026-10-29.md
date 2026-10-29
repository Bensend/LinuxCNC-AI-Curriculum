# 4400-THC-ANTI-REPEAT-01 — Two-hand anti-tie-down is not machine anti-repeat; power sequencing and physical stop remain separate

**Source session:** 2026-10-29T03:37:24.384Z UTC. **Status:** original manufacturer/publisher/OSHA document audit; NON-GRADUATED; no installed-machine or test evidence. **Priority:** 4400 safety course; OpenPressBrake G0/G1 HOLD.

## The specific engineering trap

A builder installs a two-hand control module, observes that holding one button while cycling the other does not re-enable its safety output, and declares the machine single-cycle/anti-repeat protected. **This is an invalid inference.** The original Banner AT-FM-10K manual explicitly states that anti-repeat control **is not a function of this two-hand control safety module** (Rev L, printed p. 8, PDF p. 8; `Module Operation`). It separately describes *anti-tie-down*: after either hand is released, both inputs must be released and then newly operated within the required window. These two protections answer different questions.

- **Two-hand simultaneity:** were both independent hand actuators newly operated within the product's stated window? Banner specifies **≤500 ms** (Rev L, printed p. 4 and p. 8).
- **Anti-tie-down/release history:** after one input is released, does holding the other prevent a new output until *both* have been released? Banner says yes and supplies a direct checkout sequence (printed pp. 8, 17–18).
- **Machine anti-repeat:** after a completed single stroke/cycle, does a still-maintained two-hand request trigger another machine cycle? Banner expressly delegates this to the *machine's separate control architecture*. A qualified, separately validated anti-repeat function is required where the machine SRS demands it.
- **Physical stopping/holding:** does removing the protective output actually stop hazardous motion and hold a gravity-loaded axis? The two-hand module cannot establish that without the actual final elements and measured machine response.

**Original primary source:** Banner Engineering, *AT-FM-10K DUO-TOUCH Two-Hand Control Module Product Manual*, p/n 64137 Rev L, dated **28-Oct-2025**, PDF pp. 4, 7–9, 11–16, 17–18: https://info.bannerengineering.com/cs/groups/public/documents/literature/64137.pdf . This audit refers to that **exact model and revision**, not a generic Pilz or Fiessler product or installed OpenPressBrake device.

## Direct source evidence and claim classification

| Evidence | Classification | Engineering consequence |
|---|---|---|
| Rev L `Module Operation` cautions that machine anti-repeat is not supplied by the two-hand module. | **DOC-CONFIRMED** (original OEM PDF, printed p. 8) | A green output and a passed tie-down test do not demonstrate single-cycle non-repeat. |
| Both buttons must operate within **500 ms**; when one is released, both must be released before re-enabling. At power-up, already-held Run-state buttons cannot enable outputs until Stop→Run. | **DOC-CONFIRMED** (pp. 4, 7–9) | Simultaneity, full release and power-up state are *device* behavior; do not generalize the 500 ms to all devices or safety functions. |
| Rev L daily checkout: one held/other re-pressed must keep output OFF; delayed second hand >0.5 s must keep output OFF; broken Y1/Y2 feedback loop gives fault indication. | **DOC-CONFIRMED** (pp. 17–18) | Tests are *specific to this OEM module* and must be executed by authorized/qualified people with the machine protected; they do not demonstrate the physical final element. |
| OEM warns optical/electronic buttons and module must share the **same voltage source**; powering module before the hand devices can produce unintended output. | **DOC-CONFIRMED** (pp. 13–14) | Power restoration/UPS/24-V segmentation can invalidate an otherwise plausible two-hand input design. This is a product-specific integration requirement, not an invented OpenPressBrake power schematic. |
| Safety output contacts open within **35 ms** after input opens, with no intentional module delay. | **DOC-CONFIRMED** (printed p. 13) | 35 ms is a **module relay-response figure**, not total hydraulic stopping time or a safe reach distance. |
| OEM instructs against inserting a normal PLC/PC that can defeat the safety stop, and specifies monitored external MPCE contacts and suppressors **across MPCE coils, not safety contacts**. | **DOC-CONFIRMED** (pp. 14–16) | Normal LinuxCNC/HAL/FPGA cannot be credited as the safety authority; coil suppression and final-element monitoring are separate design decisions. |
| ISO 13851:2019 specifies two-hand device design/selection but explicitly does not choose which machine or distance; it protects only the person using it. | **DOC-CONFIRMED** ISO publisher abstract: https://www.iso.org/standard/70295.html | No automatic substitution for front/rear guards, bystander protection or gravity-load restraint. |
| ISO 13855:2024 covers placement of two-hand controls and has superseded 2010; OEM Rev L still references `ISO/DIS 13855:2022` and older EN 13855 distance language. | **DOC-CONFIRMED** ISO publisher: https://www.iso.org/standard/80590.html ; OEM printed pp. 11–12 | Do **not** copy draft/old formula or 250/550 mm factors as a current selected-machine calculation. Obtain applicable current standard, measured total stopping chain, geometry and qualified review. |
| OSHA 29 CFR 1910.217(a)(5) explicitly excludes press brakes. OSHA's press eTool nevertheless illustrates two-hand press-brake use. | **DOC-CONFIRMED** https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217 ; https://www.osha.gov/etools/machine-guarding/presses/two-hand-controls | Mechanical-power-press two-hand clauses are useful comparison, **not directly mandatory press-brake requirements**. Selected Type-C standard, risk assessment and jurisdiction govern. |
| Installed OpenPressBrake uses this Banner module; 500 ms, 35 ms, contact life, PL/SIL or response applies to its hydraulic ram. | **UNKNOWN / NOT TEST-CONFIRMED** | Do not make such a claim. |

### Novelty / predecessor check

The existing [two-pedal AND versus two-hand audit](4400_TWO_PEDAL_AND_VS_TWO_HAND_SAFETY_FUNCTION_BOUNDARY_2026-10-23.md) already establishes that foot-pedal concurrence does not establish hand protection. The existing [RST-01](../safety-course/4400_RST_01_POWER_RETURN_RESET_EDM_AND_FRESH_START_MODULE_2026-10-24.md) already separates reset, EDM, rearm and fresh normal start. Existing [COIL-DECAY-01](4400_COIL_DECAY_01_SUPPRESSION_DROPOUT_TIME_VS_CONTACT_LIFE_SOURCE_AUDIT_2026-10-28.md) covers output coil release timing. **This audit adds a new exact-OEM causal discriminator:** *anti-tie-down can be fully functional while machine anti-repeat is entirely absent*; plus a manufacturer-documented common-source power-up hazard and explicit 2025-manual/current-2024-ISO placement edition mismatch. This is **exact manufacturer/edition evidence + transfer/integration**, not a new graduated competency.

## Architecture and adversarial fault paths (INFERENCE, not installed truth)

```text
Two separate hand actuators -> selected qualified two-hand monitor
                                   | 500 ms, release history, internal faults
                                   v
                           safety-rated protective demand/permission
                                   v
                     selected independent safety logic and final elements
                                   v
                         physically verified hazardous-motion stop
Normal LinuxCNC/FPGA:  request cycle; display status; record diagnostics
Separate machine-cycle logic: ensure completed single cycle does not repeat
Physical protection:    guarding/reach geometry; rear access; workpiece sweep;
                        hydraulic/gravity holding; energy isolation for service
```

**Do not wire the protective stop through a normal PLC/PC as the only final authority.** The two-hand module's safety output is not itself a hydraulic valve, brake, mechanical support or proof of stopped Y1/Y2.

| Adversarial scenario | What a good-looking input LED could hide | Discriminator before accepting any safety credit |
|---|---|---|
| One button tied down; second newly pressed | Boolean AND mistakenly treated as anti-tie-down | Exact selected module's release-history behavior, qualified no-energy verification and correct field wiring. |
| Both buttons remain pressed after first stroke ends | Two-hand output stays permitted; normal control starts a second cycle | Separate **anti-repeat** machine-cycle function and independently witnessed no-repeat behavior. |
| One button released and re-pressed while other stays held | New actuation may be misread as a fresh pair | Selected two-hand release-history test; do not infer from two green inputs. |
| 24-V buffered module wakes before unpowered electronic buttons | Different power epochs create unsafe input/output interpretation | Exact supply architecture and OEM same-source requirement; avoid power-sequencing shortcuts. |
| Operator releases button; module contacts open in 35 ms | Ram may still move or fall due to final-element/energy behavior | Qualified whole-chain stop-time and gravity-load hold evidence, not relay-response arithmetic. |
| Both buttons pass tests; second person stands behind machine | Two-hand protection applies only to operating person's hands | Independent rear/side guarding, personnel presence and workpiece sweep assessment. |
| Two-hand bar is moved closer for convenience | Original separation evidence becomes stale | Recompute using current applicable ISO 13855 edition and measured machine response; fix/secure accessible bar position. |
| Feedback Y1/Y2 bridged to make faults disappear | Module output may energize without meaningful MPCE feedback | Exact installed EDM wiring and qualified final-element/physical witness; bypass is unacceptable. |

## Practical design to make correct use easier than bypass

Use robust, well-guarded but comfortable actuators, stable workstation placement, clear feedback on which hand was late/stuck, straightforward recovery that requires full release, and a dedicated safe way to position a workpiece without asking an operator to defeat the hand controls. Do not force an operator to hold a heavy sheet with both hands and simultaneously require two-hand buttons: that is a foreseeable defeat incentive. If workholding requires hands near the die, choose an appropriate alternative validated protective method rather than calling the hand buttons sufficient.

A useful operator indication separates `HANDS READY`, `PROTECTIVE OUTPUT PERMITTED`, `NORMAL CYCLE ARMED`, and `RAM PHYSICALLY STOPPED/HELD (QUALIFIED WITNESS ONLY)`. None is a substitute for the independent safety function. No source here establishes that a particular OpenPressBrake mode uses two-hand control.

## Validation and current gate

A qualified engineer must identify the actual selected module/revision and actuators, 24-V sources, safety-controller configuration, mode selection, anti-repeat owner, feedback wiring, final elements, physical stopping/holding, actual access paths and all affected persons. Any future validation must be performed under an independently approved safe test plan, with people outside hazardous exposure until the machine meets its minimum safe-to-operate threshold. **No live actuation, simulation, self-hosted lab or physical measurement was performed here.**

**G0/G1 HOLD; G2 NOT RUN; G3/G4 NOT AUTHORIZED; G5 HOLD. 2520–25F0 independent evaluator OPEN.** No PL/SIL, stop distance, valve truth table, 35-ms physical stop, or OpenPressBrake two-hand installation is claimed.
