# 4400-LEAK-01 — OFF command is not necessarily an electrically inactive load
**2026-10-26 | Original manufacturer-document inspection | NOT selected-machine evidence**

## Question and novelty
Can an ordinary controller's **OFF** command leave an electrically held contactor closed, even without a welded safety contact? **Yes, conditionally for the exact Rockwell IntelliVAC control interface documented below.** The prior 4400 RST/EDM/OUT/PULSE material addresses reset, contactor feedback, safety outputs and diagnostic pulses; this audit isolates a different failure mechanism: **residual current through an apparently open control output**. It does not claim this hardware is fitted to OpenPressBrake.

## Original sources inspected
1. Rockwell Automation, *IntelliVAC Contactor Control Module (Series C and later), Bulletin 1503VC*, publication **1503-UM052D-EN-P, June 2013**, original PDF https://literature.rockwellautomation.com/idc/groups/literature/documents/um/1503-um052_-en-p.pdf . **PDF printed pp. 3-12 to 3-14 (PDF pp. 25–27, zero-based 24–26)**; p. 3-12 and p. 3-13 were visually inspected, not just indexed. Exact section **Control with Solid-State Devices** and **Two-Wire Control**.
2. Rockwell Automation, *PointMax I/O 5034-OW4I/OW4IXT Details — Surge Suppressors*, https://www.rockwellautomation.com/en-pl/docs/technical/i-o/current/5034-pointmax/_online/pointmax-i-o-modules-details-ditamap/digital---standard-i-o-modules/5034-ow4i-ow4ixt-details/use-surge-suppressors.html ; live OEM HTML read 2026-10-26. This is **ordinary I/O documentation**, not a safety output qualification.

## Manufacturer-confirmed mechanism
**DOC-CONFIRMED — IntelliVAC, p. 3-12:** transistor/triac OFF outputs have finite impedance; RC snubbers wired **across opening relay contacts** can conduct when contacts are open. IntelliVAC's high-impedance CLOSE input can be triggered by that leakage or residual terminal voltage, causing unintended contactor operation or persistence of the closed state after the controller command is removed. The manufacturer specifically proposes checking source-output leakage against the exact input specifications; where incompatible, it illustrates an **interposing relay** in Fig. 3.6. That figure is a product-specific wiring example, **not** a universal personnel-safety circuit.

**DOC-CONFIRMED — IntelliVAC, p. 3-13:** maintained two-wire CLOSE input can be present at energization. The manual identifies a configurable **Power-Up Safety** feature, warns that disabling it can create unsafe conditions, and identifies a product-specific recovery sequence requiring a CLOSE-command removal after fault. These are not an acceptable substitute for independent deliberate restart.

**DOC-CONFIRMED — IntelliVAC, pp. 3-11–3-14:** for E-stop applications requiring power removal, the manufacturer shows a separate control-power rung; the **time-delay undervoltage (TDUV)** feature can defer opening until its programmed interval. The delay must be accounted for in a real stop-function assessment. Do not generalize the example into an OpenPressBrake wiring design or assume its E-stop circuit is independently safety-rated.

**DOC-CONFIRMED — PointMax online instructions:** inductive loads can shorten contact life without suitable suppression. For the **5034-OW4I standard relay output** the manufacturer recommends appropriately rated suppression **across the load coil, close to the load**, and explicitly warns against RC suppressors with triac outputs in its table footnote. This is not a blanket prohibition on RC suppression; it is an interface- and product-specific compatibility constraint.

## Failure chain and diagnostic discriminators
1. Normal LinuxCNC/FPGA sets command OFF. **SOURCE-CONFIRMED new LinuxCNC: none**; this is a hypothetical normal-command path.
2. A switching device opens, but its **parallel RC path or semiconductor off-state leakage** may remain conductive. A meter reading or command bit alone does not determine downstream current.
3. The high-impedance CLOSE input may still interpret residual voltage as ON. **DOC-CONFIRMED for exact IntelliVAC interface**, not any arbitrary coil/PLC.
4. Final contactor state, load energy, ram stopping and gravity holding must be separately observed by qualified independent means. **INFERENCE** for system architecture; no physical witness.
5. A power cycle or replacement output module may change the initial command/retention behavior; fresh restart must be deliberately reauthorized, never inferred from a software reset.

**Distinct failure classes:** (A) OFF-state leakage / residual CLOSE voltage; (B) welded power contact; (C) stale ordinary status; (D) deliberately retained TDUV; (E) hydraulic stored pressure/gravity load. Fixing A does **not** prove B–E absent.

## Safe design/validation boundary
A qualified designer should select a compatible output–input pair using **both** manufacturer electrical specifications (off leakage, input thresholds, wiring/suppression, operating range), retain independent safety-related final-element authority and diagnostic feedback, and perform a **no-exposure** functional validation after change. Never teach technicians to bypass a protective device, remove suppression indiscriminately, bridge an input, or use a generic resistor value as a safety cure. An interposing relay adds its own failure/feedback and rating requirements; it does not automatically upgrade ordinary LinuxCNC control into a safety function.

**UNKNOWN:** actual OpenPressBrake switching technology, contactor model, coil, snubber placement, current/voltage, input thresholds, power-up configuration, TDUV, actual Y1/Y2 stop/hold, hydraulic isolation, guarding and PL/SIL. No numerical threshold or stopping-time claim is made. **TEST-CONFIRMED none**; no live test, simulation or Actions dispatch. **G0/G1 HOLD**.
