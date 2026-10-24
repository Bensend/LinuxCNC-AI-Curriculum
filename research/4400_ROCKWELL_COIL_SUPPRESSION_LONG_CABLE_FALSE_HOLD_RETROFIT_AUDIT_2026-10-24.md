# 4400 — Safety contactor retrofit: coil suppression, long control-cable capacitance, and false hold

**Original source independently inspected:** Rockwell Automation **Low-Voltage Switchgear and Controlgear — An Application Guide**, **LVSAM-RM003A-EN-P**, November 2012, manufacturer-hosted 174-page PDF: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/lvsam-rm003_-en-p.pdf . Examined printed §§5.3.3.1–5.3.5, pp. **5-5 to 5-10**, web PDF pages 156–161; original text and tables. This is general **industrial switchgear** guidance, **not** a press-brake safety design or an installed-device manual. The newer product-specific contactor datasheet remains mandatory.

## The unresolved retrofit question

Can a seemingly benign replacement of a contactor coil suppressor, relay output, or control-cable route **delay physical dropout or even leave a contactor energized after the command opens**? The manufacturer's original document supports **yes, under specified circuit conditions**. A green PLC or an OFF software bit is insufficient to establish that a contactor has physically opened.

## Three separate OEM findings

| OEM location | Exact narrow result | Safety consequence / limitation |
|---|---|---|
| §5.3.3.1, printed p.5-6, table 5.3-1 | For DC coil protective circuits, a **diode** extends drop-out time; a **bidirectional Z-diode** gives a smaller extension; RC/varistor have other suppression characteristics. | A replacement suppressor can change the final-element reaction time. No universal delay value or ranking across all products can be inferred. |
| §5.3.4.1, p.5-7 | Long control lines and low control voltages can cause voltage drop sufficient to prevent reliable contactor pull-in; the OEM notes possible main-contact welding. | A changed harness can affect both ability to energize and reliability of the eventual stop path. Product data and actual wiring required. |
| §5.3.4.2, pp.5-8–5-9 | With **AC control**, long-line capacitance can be in parallel with an opened controlling contact; in a specified topology, enough current may flow to prevent contactor drop-out. | **A commanded open contact is not always proof of physical de-energization.** The OEM example is AC-specific and depends on topology, coil holding demand and cable properties. |
| §5.3.5, pp.5-9–5-10 | Very low-current control/PLC circuits require appropriate contact material and reliability; contaminants and inappropriate contact selection can impair operation. | A replacement ordinary relay/contact in an EDM or control loop needs actual ratings and contact design, not visual similarity. |

The manual explicitly states its technical guide is not a comprehensive or current product specification. **Do not** use its illustrative cable-length equations as a selected machine acceptance calculation without actual cable capacitance, coil, supply, topology and manufacturer design data. The figure in §5.3.4.2 describes an AC coil/control arrangement; it does **not** establish that the same capacitive hold applies to a DC output or every modern electronic contactor.

## Failure-path distinctions

1. **Normal command opened, contactor still energized:** possible under the documented AC long-cable/capacitance topology. This is a **DOC-CONFIRMED OEM example**, not a selected-machine failure.
2. **Contactor drops out later after suppression change:** documented DC coil suppressor-dependent drop-out effect; **actual delay UNKNOWN**.
3. **Feedback contact changes state but hazardous ram remains uncontrolled:** EDM/mirror contacts describe a narrower contactor physical state, not hydraulic pressure, gravity holding or all axis stopping. This latter transfer is **INFERENCE** requiring machine-specific evidence.
4. **Two series contactors share supply, cable and suppressor mistakes:** common-cause failure must be analyzed; simply counting contactors does not establish independence. **INFERENCE**.
5. **New FPGA receives PLC SAFE bit but controls the only contactor coil:** independent safety authority may be absent; use the [cutover continuity worksheet](../safety-course/4400_CNC_RETROFIT_SAFETY_FUNCTION_CONTINUITY_AND_ISOLATION_WORKSHEET_2026-10-24.md). **INFERENCE**.

## Before/after retrofit evidence request

For each **actual** contactor/relay/safety final element, require model and coil type (AC/DC/electronic), operating voltage and rated hold/drop-out thresholds, cable topology/length/capacitance and return path, suppressor type and installed orientation, output interface type, actual contactor and mirror/feedback contacts, safety output-to-coil wiring, and whether physical output withdrawal remains independent of ordinary LinuxCNC/FPGA. Record old/new `CHG`, independent physical witness and fault cases. Treat any change in suppressor, contactor, supply, long harness, coil drive or safety output as potentially invalidating earlier stopping evidence until qualified review.

## Practical human-factor response

Prefer an exact part-number replacement kit with documented suppressor and terminal map; keep safety harnesses identifiable and protected from accidental interchange. Put the required model/coil/suppressor/cable identity on a visible service checklist. Make a wrong diode or a long, convenient reroute **harder** than replacing the documented part correctly. Do not improvise a resistor/diode modification or test a live contactor to see if it holds. Any physical validation must be designed by qualified personnel using independent restraint and personnel exclusion.

## Source labels and stop

- **DOC-CONFIRMED:** Rockwell 2012 original sections and examples, not a current selected device datasheet.
- **INFERENCE:** possible retrofit common-cause and safety-boundary consequences.
- **UNKNOWN:** whether selected OpenPressBrake has any such contactor/cable/suppressor arrangement; exact stop reaction, cable capacitance, coil current, safety PLC output and physical hold.
- **TEST-CONFIRMED:** none. No simulation, bench or live experiment performed or needed for the documentary question.
- **Release:** `VAL/PT NOT RUN`, `G3/G4 NOT AUTHORIZED`. Never use a software OFF bit, PLC LED or mirror-contact indication alone as proof of a gravity-loaded hydraulic press-brake's safe physical state.

**Freeze:** `CONTACTOR COMMAND OFF != CONTACTOR PHYSICALLY OPEN`; `COIL SUPPRESSOR REPLACED != DROP-OUT TIME UNCHANGED`; `AC CABLE CAPACITANCE EXAMPLE != UNIVERSAL DC FAILURE CLAIM`.
