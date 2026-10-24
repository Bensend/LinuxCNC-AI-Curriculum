# 4400-DCB-01 — Common DC bus, regeneration and independent safety boundaries
**2026-10-24 | SOURCE-READING MODULE | NOT GRADUATED**

## Learning objective and prerequisites
A fresh engineer should distinguish **(1) ordinary bus supply/drive readiness, (2) independent safety-related motion authority, (3) physical electrical isolation for service, (4) qualified proof of energy absence, and (5) separate gravity/kinetic safe-state control** for a multi-axis system. Prerequisites: 2520 safety-function derivation, 2530 E-stop, 2540 final elements, 2570 STO, 25E0 evidence integrity, 4400-RET-01 and the existing STO/DC-bus energy study.

## Source-reading route
1. Read [ABB/Rockwell original OEM source audit](../research/4400_COMMON_DC_BUS_REGENERATION_REENERGIZATION_AND_ISOLATION_OEM_AUDIT_2026-10-24.md). Trace `MOTION-AT007B` shared DC bus and capacitor topology to `3AUA0000102301C` isolation/PM regeneration cautions.
2. Solve [14 technician scenarios](4400_COMMON_DC_BUS_BACKFEED_AND_ISOLATION_TECHNICIAN_CARD_2026-10-24.md) **on paper**. Treat published instructor cues as non-blind.
3. Populate [blank physical witness](4400_COMMON_DC_BUS_ENERGY_BOUNDARY_BLANK_FIELD_WITNESS_2026-10-24.md) only from an authorized selected-machine evidence package, leaving UNKNOWNs open.
4. Compare with [STO/contactor/DC-bus earlier boundary](STO_CONTACTOR_DC_BUS_STORED_ENERGY_BOUNDARY_STUDY_2026-09-17.md); state precisely what is newly learned: shared-bus cross-feed, optional DC feeder/external storage, PM generation, ready-bit semantics, and precharge topology.

## Architecture proposition
```
ordinary LinuxCNC/FPGA --(motion commands/status)--> drives and bus controls
independent safety-related control --(validated stop/hold demands)--> selected safety final elements
lockable source isolation --(qualified OEM/site procedure)--> electrical service boundary
independent physical witness --(measured/inspected evidence)--> task-specific release decision
```
No arrow from ordinary FPGA `bus_ready` or `STO_status` to a personnel `SAFE_TO_SERVICE` authority. A validated motion safety function may leave the bus energized; a de-energized bus does not prove a gravity load held. Maintenance isolation is a distinct task-specific physical operation.

## Representative fault chains
- **Common-bus cross-feed:** local AC input disconnected; remote supply or stored bus remains connected; status on local controller misinterpreted; exposure risk remains.
- **Generator re-energization:** mechanically driven PM motor can energize its electrical circuit; motor type and path must be established.
- **Operational ready-bit misuse:** Regeneration OK / Precharge Complete treated as voltage sensor; incorrect service release.
- **Stored-energy extension:** new capacitor module added; previous isolation map or discharge assumptions stale.
- **Restart coupling:** electrical service complete, retained CNC motion demand; independent rearm and fresh start required.

## Evidence and graduation gate
**DOC-CONFIRMED:** ABB 2023 and Rockwell 2022/2023 manufacturer-specific claims. **INFERENCE:** hazard transfers to a given topology. **UNKNOWN:** actual OpenPressBrake drive/bus/motor/feeder topology, physical isolation/voltage proof, mechanical holding, stop/restart, integrity target and physical validation. **TEST-CONFIRMED:** none. No lab justified: source question resolved; selected physical question requires as-built evidence and qualified independent witness, not simulation. A fresh-AI transfer assessment using a *novel* bus topology remains to be administered/scored independently, followed by retention. **NOT GRADUATED**. Counterfactual promotion test fails for any claim that the selected machine is safe, because unknown topology and physical evidence could overturn it.

**Transfer:** press brake Y1/Y2 only if applicable; mill vertical Z; lathe spindle; robot gravity axes; multi-drive feeder; plasma motion versus plasma source isolation. Do not assume all these machines share a DC bus. No personnel-exposed hazardous operation authorized.
