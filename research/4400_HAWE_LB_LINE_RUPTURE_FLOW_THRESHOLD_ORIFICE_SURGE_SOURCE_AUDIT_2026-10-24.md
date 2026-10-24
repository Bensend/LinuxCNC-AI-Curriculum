# 4400 — Hydraulic line-rupture protection: flow threshold, bypass orifice and nuisance-trip trap
**2026-10-24 | DIRECT ORIGINAL OEM PDF | DOC-CONFIRMED for HAWE LB only | NO SELECTED MACHINE / PHYSICAL TEST**

## Question
Does adding a 'hose burst valve' prove that a vertically loaded hydraulic axis cannot descend dangerously after *any* leak or line failure? What happens when a valve closes only after a defined flow threshold, includes an orifice, or is exposed to normal decompression surges?

## Original manufacturer source
Directly inspected HAWE Hydraulik SE, **D 6990, Line rupture protection valve type LB, 10-2022 revision 1.3 EN**, 25-page original PDF, generated 2022-11-07: https://productfinder.hawe.com/downloads/D6990-en.pdf . Printed pp. 4–10, 13–14, 19–24; especially §1, §§2.3–2.5, §3.4, §5.3.2 and §6.1. This is a *separate lifting/industrial component example*, **not** a claim that the LB valve is installed on HAWE ePRAX or OpenPressBrake.

## Evidence ledger
| OEM printed page | Product-specific observation | Evidence and limitation |
|---|---|---|
| p. 4, §1 | A flow-driven plate closes when flow exceeds a selected trigger. The OEM describes mounting near a cylinder and protection of a line/hose segment. | **DOC-CONFIRMED.** A small leak below trigger is **not shown** to close it. |
| pp. 5, 8 | Standard and orifice-bore variants are distinct. Some versions deliberately permit low flow in the locking direction through an orifice. | **DOC-CONFIRMED.** 'Tripped' is not necessarily zero-flow or full load holding. |
| pp. 9–10 | Response-flow settings are variant-specific; the '-0' configuration requires user adjustment. | **DOC-CONFIRMED.** Never assume factory setting or copy flow values to a different cylinder/load. |
| pp. 13–14, §3.4 | Characteristic graphs describe the trigger and additional orifice flow. OEM notes actual response flow includes the orifice contribution. | **DOC-CONFIRMED.** Trip condition depends on hydraulic state, not just a broken-hose Boolean. |
| pp. 23–24, §5.3.2 | OEM describes false trips from normal decompression surges, and discusses an additional outlet orifice in a line section outside the protected rupture zone. | **DOC-CONFIRMED.** Such an orifice cannot be moved into a protected segment or copied without engineering the actual hydraulic circuit. |
| p. 24, §6.1 | Example diagrams distinguish the **line cross section at risk** from the valve and other lowering/counterbalance elements. | **DOC-CONFIRMED.** Coverage depends on placement and flow direction; no generic whole-machine coverage. |
| pp. 19–20 | Before disassembly, shut down and depressurize; OEM warns of unexpected actuator movement, especially around accumulators. | **DOC-CONFIRMED.** A tripped LB is not a maintenance isolator or proof of zero pressure. |

## Counterexamples to the shortcut 'hose-burst valve = safe ram'
1. **Subthreshold leak (INFERENCE):** if loss flow never reaches the configured response, a purely flow-triggered valve may not close. A gradual ram drift could still be hazardous; qualified physical holding verification remains required.
2. **Orifice-bore variant (DOC-CONFIRMED + INFERENCE):** the OEM intentionally permits restricted bypass flow, so a tripped valve cannot be assumed to produce zero leakage or indefinite load hold.
3. **Wrong location (INFERENCE):** protection of a particular line section is not protection of every hose, cylinder port, seal or accumulator path. Require as-built schematic and vulnerable-segment map.
4. **Normal decompression surge (DOC-CONFIRMED):** an ordinary control transition can generate a high transient flow that trips protection. A bypass/removal 'fix' is a foreseeable human-factor failure; redesign the hydraulic sequence or selected OEM solution instead.
5. **Service reset (UNKNOWN):** after a trip, do not assume trapped pressure is relieved or that clearing a controller fault restores a safe physical state.

## Distinct functions
- **Line rupture protection:** mitigate a particular high-flow break within a known segment and product envelope.
- **Counterbalance/load holding:** prevent gravity-driven uncontrolled descent under specified load/pressure; exact circuit required.
- **Independent safety stop:** bring hazardous motion to a validated safe state on demand or fault.
- **Maintenance isolation:** physical isolation, mechanical support and verification of all stored energy.
- **Ordinary LinuxCNC/FPGA:** may request motion and display diagnostics, but is not automatically safety-rated.

None substitutes for the others. Do not derive selected-machine valve flow thresholds, orifice sizes, stopping distance, performance level, diagnostic coverage or hydraulic truth tables from D 6990.

## Human factors and verification gate
A protection valve that nuisance-trips repeatedly can invite field adjustment, unplugging or removal. Provide a documented, easy qualified inspection route with accessible labeling, correct spares, guarded pressure/position witnesses and clear 'do not bypass' status. Before operation with personnel exposed, qualified engineers must verify exact installed part/variant, trigger basis, orifice path, protected segment, other failure paths, Y1/Y2 physical hold, residual energy and restart. **Selected OpenPressBrake device presence UNKNOWN; G0/G1 HOLD, G3/G4 NOT AUTHORIZED.** No experiment justified by this source-only question.
