# 4400-FDI-01 — Siemens S210 dual-input discrepancy: error present while STO is not yet effective

**Evidence status:** DOC-CONFIRMED, exact original manufacturer PDF; 2026-10-26 research. **No selected-machine evidence, test, simulation or external score.** This is a *different* mechanism from the existing brake-fault/accumulator lessons. Do not transfer S210 firmware or settings to an unidentified drive.

## Original inspected document and scope

Siemens, *SINUMERIK MC Safety Integrated, Commissioning Manual*, **07/2021, A5E47011139B AC**, valid for SINUMERIK MC with SINAMICS S210, CNC software V1.15 / TIA Portal V17. Original manufacturer-hosted PDF: https://cache.industry.siemens.com/dl/files/295/109801295/att_1077953/v1/S210_MC_SI_commiss_man_0721_en-US.pdf. Directly inspected printed pp. **116–119, 127–129, 147–149, 308–311**; in particular **§9.3.2**. The separate Siemens application note 109810528 was indexed but its direct download returned 403; **no full-text assertion** from that note. Pilz's public [brake-control explanation](https://www.pilz.com/en-INT/support/lexicon/articles/072379) is independent conceptual context, **not** proof of S210 wiring or OpenPressBrake hardware.

## Exact OEM observations, without invented timing

1. **DOC-CONFIRMED (§9.3.2, printed pp. 309–310):** the S210's two F-DI monitoring channels use **0 = select** the safety function and **1 = deselect**. Parameter **p9651** is input debounce; **p9650** is permissible discrepancy; **p9658** is the F01611-to-STO transition; **p9652** is the SS1 delay when used. The manual says p9650 must be shorter than the shortest interval between two successive switching events, and p9658 must be at least p9652 (§9.3.1). These are *relationships*, not universal values.
2. **DOC-CONFIRMED (§9.3.2, initial both LOW, STO already active):** one F-DI goes HIGH; after debounce and discrepancy, **F01611/F30611** can be issued. Crucial OEM note: if the other F-DI also goes HIGH **before the p9658 transition expires**, STO **becomes inactive despite an internal event** and the motor can be switched on during that transition. Do not teach that the red fault indicator locks torque off immediately.
3. **DOC-CONFIRMED (§9.3.2, initial both HIGH):** one F-DI goes LOW; after debounce the converter initiates **SS1 if p9652 is nonzero, otherwise STO**, regardless of the other input. A persistent discrepancy later issues F01611/F30611; STO follows at the earlier of the SS1 delay or discrepancy-plus-transition timeout when applicable. The manual explicitly warns that the motor **can still be operated while a discrepancy fault is active and STO has not yet become active**. These two initial-state cases are **asymmetric**.
4. **DOC-CONFIRMED (§5.1.1, pp. 116–117):** STO removes motor torque-generating energy, **not galvanic isolation**; a motor already rotating can coast. Deselecting STO can restore “ready for switching on”; a separate **positive ON/OFF1 edge** is the drive's described restart mechanism. A selected machine still needs independent occupancy/rearm and fresh motion authority.
5. **DOC-CONFIRMED (§5.1.2/5.2.2, pp. 118–119/127–129):** SBC is enabled with p9602 and paired with STO in the examined variant. SBC commands the spring-applied motor holding brake, but **does not detect mechanical wear/defects**; brake cable faults may only be diagnosed on a switching event. Thus SBC active is not proof of a physically held gravity load.
6. **DOC-CONFIRMED (§5.2.6, pp. 147–149):** SBT deliberately applies **test torque against an engaged brake** and uses encoder-observed motion versus configured tolerance. The manual requires the axis to be at standstill in a safe position and NC controller/pulse enable; SBT is **not** a passive no-energy check and its category-2 diagnostic claim does not certify the machine's overall safety function.

## Two different fault paths, no fabricated timing chart

| Initial two F-DIs | Single channel changes | Manufacturer-described reaction | Hazardous assumption to reject |
| --- | --- | --- | --- |
| LOW/LOW, STO selected | One HIGH; later both HIGH before p9658 expires | Discrepancy/internal event can coexist with STO deselection; motor may be enabled | “Any F01611 permanently prevents torque” |
| HIGH/HIGH, STO deselected | One LOW; other remains HIGH | Immediate SS1 or STO after debounce according to p9652; discrepancy error and eventual STO may follow | “Fault LED means STO has already taken effect” |

**INFERENCE (architecture):** a normal LinuxCNC UI should display F-DI/drive diagnostics but must not be the sole stop/restart or gravity-holding authority. Independent safety logic must define whether any such transition can permit motion, require fresh deliberate rearm and verify the physical final element. Neither S210 status nor its motor encoder proves the load-side Y1/Y2 hydraulic beam is held. Do not treat a safety diagnostic flag as a physical state witness.

**UNKNOWN:** whether any S210, F-DI, SBC or SBT is installed on OpenPressBrake; firmware/parameter set; actual p9650/51/52/58; stop category; independent final element; physical Y1/Y2 stop/hold, residual pressure, access, PL/SIL, rearm, measured stopping distance. **No values inferred.**

## Practical design/evidence consequences

- Put a **four-state display** in the learner's architecture: **fault reported / stop requested / final energy path physically safe / rearm permitted**. Never collapse into one green/red lamp.
- Require selected product+firmware+input wiring, exact safety-parameter export, OEM behavior at both initial F-DI polarities, independent stop/hold proof, fresh-start policy and change control. Do not reproduce this source as a wiring diagram.
- Prefer captive guards, visible fault explanations, easy supervised reset and independent final elements to ad-hoc “clear the fault and jog” service workarounds. A too-frustrating reset workflow invites bypass and is a design defect.
- **No fault injection on a people-exposed machine.** If safe-to-operate threshold is unproven, G0/G1 HOLD; isolated/remote experimentation requires separate qualified authorization, exclusion and residual-risk plan.

## Evidence ledger

| Claim | Class | Source / unresolved gate |
| --- | --- | --- |
| Asymmetric two-input discrepancy sequences, p9650/51/52/58, F01611 and possible torque before STO | DOC-CONFIRMED | Siemens A5E47011139B AC §9.3.1–9.3.2, pp. 308–310 |
| STO not isolation; separate positive ON/OFF1 edge | DOC-CONFIRMED | Siemens §5.1.1 pp. 116–117 |
| SBC cannot identify mechanical brake defect | DOC-CONFIRMED | Siemens §5.1.2/5.2.2 pp. 118–119, 127–129 |
| SBT applies torque; requires safe position and pulse enable | DOC-CONFIRMED | Siemens §5.2.6 pp. 147–149 |
| Independent selected-machine final energy and fresh rearm required | INFERENCE/design requirement | To be validated against actual SRS, safety architecture and machine |
| Selected OpenPressBrake installed devices and physical safe state | UNKNOWN | Qualified restricted as-built evidence and physical witnesses needed |
| LinuxCNC source behavior newly traced / laboratory result / external evaluator | NONE | No SOURCE-CONFIRMED or TEST-CONFIRMED claim newly created |

**Safety restriction:** documentary investigation only. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 HOLD.** No GitHub-hosted or self-hosted compute, no physical test, no blind evaluation.
