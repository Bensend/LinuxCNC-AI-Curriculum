# 4400 — Parker TDP/TEP “fail-safe” pilot dependency and D3DW manual-scope trap
Date: 2026-10-23 UTC | Original manufacturer-source audit | Status: DOC-CONFIRMED wording and product boundaries, INFERENCE safety review, actual machine UNKNOWN. No lab.

## Why this branch was opened

The [counterbalance/pilot investigation](4400_COUNTERBALANCE_PILOT_THERMAL_RELIEF_AND_MOTOR_BRAKE_BOUNDARY_2026-10-23.md) raised a more general safety-design question: **when a manufacturer calls a valve's power-loss position “fail safe,” what exactly is physically established?** A product may have a spring-return state, an actively controlled main poppet, a pilot-pressure dependency, a separate monitored shut-off cartridge, or a hydraulic load that can move after the valve reaches its expected position. The label alone does not qualify the machine safe state.

## Direct primary documents

- **Parker manufacturer product page**, *2-Way High-Response Valve — Series TDP*, [official listing](https://ph.parker.com/us/en/tdp-proportional-throttle-valve). The features list contains both a power-down “fail safe position” claim and the statement that **pilot pressure is required to ensure the closed position**. These phrases need configuration/failure-path reconciliation; they are **not** a standalone claim that the installed hydraulic circuit isolates a load on simultaneous loss of electrical and pilot pressure.
- **Parker**, *2-Way Servo Proportional Valves with VCD-Technology, Series TDP/TEP, Operation Manual*, bulletin MSG11-5715-697/UK, copyright 2024, [official PDF](https://www.parker.com/content/dam/Parker-com/Literature/Industrial-Systems-Division-Europe/Manuals-UK/PDF/TDP_TEP-5715-697-UK.pdf). Printed pp. 5–6 distinguish TDP (proportional valve with LVDT) from TEP (proportional valve **with shut-off valve and LVDT**), with a separate monitored shut-off valve order-code field. Printed p. 6 footnote states that if valves with onboard electronics are used in safety-related control parts, the electronics supply must be switched off by a suitable reliable switching element when safety is requested. The hydraulic table identifies external pilot supply **X** and drain **Y**, and pilot pressure requirement relative to system pressure.
- **ISO**, *ISO 4413:2010*, [official catalog scope](https://www.iso.org/standard/44781.html), confirms it remains published/current after 2021 review and covers hydraulic fluid-power machine systems, installation, modification, operation, maintenance and cleaning. **Only public catalog scope was reviewed**, not paid normative clauses.

## Product/paragraph provenance ledger

| ID | Evidence class | Observed statement | Allowed inference / forbidden transfer |
|---|---|---|---|
| TP-01 | **DOC-CONFIRMED** | TDP product page uses both “fail safe position” and “pilot pressure required for closed position.” | A product-page fail-safe adjective is insufficient to define a power-loss **load-holding** safety function. The exact conditions under which the selected poppet reaches/retains closed position remain **UNKNOWN**. |
| TP-02 | **DOC-CONFIRMED** | 2024 TDP/TEP manual differentiates TDP and TEP order-code functions; TEP includes additional shut-off/position control. | Do **not** assume a TDP order code contains TEP's monitored shut-off stage, or that the monitored stage establishes physical ram restraint. |
| TP-03 | **DOC-CONFIRMED** | Manual technical data identifies pilot supply X and drain Y, plus electrical supply and onboard electronics. | A controller status bit or zero flow command does not prove pilot and drain pressures or the selected valve's physical state. |
| TP-04 | **DOC-CONFIRMED** | Manual footnote requires a suitable reliable switching element for onboard-electronics supply when included in safety-related control. | This does **not** establish the safety category, PL/SIL, architecture, final-element performance or independent physical witness of an installation. |
| TP-05 | **DOC-CONFIRMED with scope caveat** | Later printed pp. 20–23 of the *same PDF* contain a section expressly discussing **D3DW** (injection-molding shut-off valve): spring-centered return on power failure, monitored position and an injection-molding restart requirement. | **REJECTED transfer:** do not attribute D3DW's spring-return/position-control text to the ordinary TDP main proportional poppet, simply because the PDF cover says TDP/TEP. Determine which component/subassembly the paragraph actually describes. |
| TP-06 | **UNKNOWN** | Actual response of a selected TDP/TEP assembly to loss of electronics, loss of pilot X, blocked drain Y, common 24 V fault, stuck poppet or mechanically disconnected load. | Requires exact part, full hydraulic schematic, manufacturer confirmation as necessary and independent machine physical evidence. No default “closed and safe” claim. |

## Three adversarial failure-path questions

**A. Product-page ambiguity:** The machine loses power and pilot pressure simultaneously. Which *exact* valve part returns where, what pressure or spring provides that action, and which load/pressure zone remains dangerous? “Fail-safe” and “controller disabled” are not answers.

**B. D3DW paragraph trap:** A designer copies the spring-centered power-loss statement from printed p. 20 of the combined TDP/TEP manual and uses it to justify a **TDP** hydraulic safe-state diagram. The adjacent text explicitly names **D3DW**, a distinct shut-off device. The source citation is real but its transfer is invalid. Require exact product identity and function.

**C. Monitored shut-off feedback trap:** A TEP-like architecture has a monitored shut-off position and a separate main proportional valve. If the monitored stage reports expected state while the beam moves or trapped pressure remains, physical evidence wins. The selected valve-state witness is not a substitute for ram restraint or service pressure isolation.

## Engineering allocation for a selected machine

1. `IN-03/IN-04`: record exact TDP versus TEP part, shut-off stage and D3DW (if any), firmware/electronics, 24 V safety cut, X/Y pilot supply/drain, actual hydraulic load path and independent physical holding mechanism.
2. `SRS/ARC/DEP`: separate normal LinuxCNC/FPGA proportional-flow control, independent safety demand, selected shut-off/final-element authority, pressure/pilot common causes and actual physical energy isolation.
3. `PHY-STOP/HOLD/ENERGY`: define independent ram/load-motion and task-specific pressure-zone witness; do not use a position monitor as a blanket proof of stopping or isolation.
4. `VAL/CHG/HF`: validate selected variants and failure cases with qualified personnel and safe remote exclusion only after as-built evidence and acceptance basis exist. Make recovery from a valve fault and restoration of service guards straightforward without unsafe bypass.

**Release:** IN-01..10 and all PHY propositions remain UNKNOWN; VAL/PT NOT RUN. No machine-specific hydraulic truth table, pressure threshold, stop time or PL/SIL assigned. Do not operate with people exposed unless the selected machine's minimum safety threshold is independently demonstrated. This paper does not authorize energized fault tests.

## Evidence stop and next question

The documentary *wording/provenance* ambiguity is now established; a machine-level resolution is impossible without the exact TDP/TEP/D3DW assembly and the manufacturer-approved as-built safety circuit. If unavailable, rotate to another open safety module rather than inventing a simulated hydraulic truth table.
