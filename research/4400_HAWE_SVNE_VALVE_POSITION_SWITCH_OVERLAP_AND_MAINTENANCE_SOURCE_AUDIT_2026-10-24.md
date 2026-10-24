# 4400 — HAWE SVNE/SVSE monitored seated valve: what a switch does and does not prove
**2026-10-24 | DIRECT ORIGINAL OEM PDF | DOC-CONFIRMED for named product variants | NOT SELECTED-MACHINE VALIDATION**

## Source and scope
HAWE Hydraulik SE, **D 6354/1, Directional seated valve type SVNE, SVSE**, 06-2026 revision 1.1 EN, 26-page original PDF, generated 2026-07-02: https://productfinder.hawe.com/downloads/D6354_1-en.pdf . Directly inspected printed pp. 4–7, 11–13, 20–23, including the original graphical **§6.1 Functional diagram SVNE..U** on printed p. 23 (PDF page index 22). This is a *component example*, not a verified mapping of any OpenPressBrake valve.

## Evidence ledger
| Page | Product-specific finding | Classification | Boundary |
|---|---|---|---|
| p. 4, §1 | The **..U** versions have inductive **idle-position** monitoring; other listed variants do not necessarily provide that monitoring. | DOC-CONFIRMED | A monitored idle-position switch does not by itself establish flow isolation, load holding or a safe machine. |
| pp. 5–7, §2 | Ordering codes distinguish R/RU, S/SU and other variants, plus optional manual override on a particular S/S2 family. | DOC-CONFIRMED | Do not treat a replacement with a similar body/coil as equivalent without full exact code and wiring review. |
| pp. 12–13, §3.5 | Monitored variants use a **24 V DC PNP** sensor circuit with complementary NO/NC outputs on pins 2 and 4; the **pin assignment differs by RU/R2U versus SU/S2U variant**. | DOC-CONFIRMED | Two complementary outputs from one sensing assembly are not two independently proven physical channels; 'two wires' does not establish redundant diagnostics. |
| p. 23, §6.1 | The manufacturer **draws a switching range and overlap stroke separately from the final zero-leakage closed region**. | DOC-CONFIRMED from inspected original diagram | A changed switch state must not be asserted to prove exact seat contact or zero leakage without manufacturer-defined tolerance, hydraulic context and qualified physical verification. |
| p. 21, §5.2.1 | Coil replacement is specifically not available on the monitored SVNE..U version. | DOC-CONFIRMED | Generic coil-swap field procedure may invalidate monitoring and product identity. |
| pp. 20–22, §5 | Maintenance requires hydraulic depressurization; contamination (including assembly debris, hose particles and aged oil) can impair function; even newly supplied oil may require filtration. | DOC-CONFIRMED | An electrical feedback pass does not exclude sticking, leakage, incorrect pressure or trapped accumulator energy. |

## Adversarial interpretation of the §6.1 diagram
The plotted **PIN2/PIN4** switching transitions occur across a *mechanical switching range* while the drawing separately labels **overlap stroke** and **closed with zero leakage**. Therefore the learner must distinguish:
- **electrical signal:** sensor output changed;
- **mechanical inference:** monitored member is within a specified displacement band;
- **hydraulic proposition:** a particular seat is actually closed with adequate sealing under load;
- **machine proposition:** both Y1/Y2 ram halves are safely stopped and held under credible faults.

Only the first two are directly supported for the stated variant; the latter two need system-specific physical and fault evidence. Do not infer that complementary NO/NC means separate redundant transducers. Nor does the diagram alone quantify diagnostic coverage, achieved PL, response time or leakage at the selected machine.

## Failure paths and discriminating evidence
1. **Wrong ..U variant/pinout:** two input lamps can appear plausible but map to opposite contact functions. Require full part code, as-wired pin map and independently reviewed input logic.
2. **Shared sensor or 24 V return failure:** complementary signals may fail together or become misleading; determine actual electrical fault detection and common-cause provisions from the selected safety controller and installation. **INFERENCE, not a demonstrated failure.**
3. **Sticking or contamination:** electrical switching and fluid isolation may diverge. Use qualified hydraulic physical checks, never hands-in fault injection.
4. **Field replacement:** monitored version cannot simply be serviced like a generic removable-coil valve. Replacement changes are CHG events with updated safety evidence.
5. **No physical test:** valve-seat closure, residual pressure and ram movement remain **UNKNOWN** for OpenPressBrake.

## Transfer and stop rule
Do not use the SVNE diagram to synthesize a universal hydraulic safety truth table. For any selected valve: capture exact OEM revision and variant, output semantics, permissible switch band, safety controller input diagnostics, supply/return topology, qualified stop/hold mechanism, and nonhazardous physical verification. If these cannot be established, do not authorize personnel exposure. No compute was justified by this documentary question.
