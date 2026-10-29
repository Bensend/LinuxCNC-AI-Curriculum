# 4400 technician card — tactile safety edge contact, overtravel and automatic reset

**PAPER EXERCISE ONLY.** Use with [original manufacturer/ISO scope audit](../research/4400_TACTILE_SAFETY_EDGE_SENSOR_PRINCIPLE_AUTORESET_AND_OVERRUN_SOURCE_AUDIT_2026-10-24.md). No selected machine safety release, live fault injection, human contact/force test or independent fresh-AI score. Schmersal SE-304C source is the OEM **product catalogue**; indexed manual PDF could not be independently opened. Mayser family principle is manufacturer-indexed with a direct-fetch limitation.

## Required four-part trace

`exposed body part/closing edge geometry -> actual sensor/contact deformation and electrical fault detection -> independent safety controller/final element -> physical stop/reversal, residual compression/force and deliberate restart`.

Normal LinuxCNC/HMI/FPGA can display status and request ordinary motion, but cannot be the sole personnel-safety decision owner.

## Ten transfer scenarios (learner-visible, not a blind key)

| ID | Field condition | Defensible engineering disposition |
|---|---|---|
| TE-01 | Gantry uses a 'PL d safety edge' but continues moving after contact. | Product label is not a machine safe-state proof. Require selected sensor actuation/deformation, total response, measured physical overtravel/force and hazard geometry. No exposed operation until adequate. |
| TE-02 | Buyer replaces Schmersal SE40 optical profile with an 8.2 kΩ rubber edge. | Reject plug-and-play substitution. Schmersal SE40/70 uses an **IR transmitter/receiver** with matching evaluator; resistor-monitored contacts are a different sensing principle. Mark `CHG` and revalidate. |
| TE-03 | Electrician wires an ASO resistive edge to a bare LinuxCNC input, discarding evaluator. | Reject. Ordinary input lacks established wire-break/short monitoring and independent safety authority. Use matched OEM evaluation and safety final-element path. |
| TE-04 | Edge covers most of a sliding door but not the closing corners. | Sensing coverage is insufficient until hazard geometry and all pinch points are assessed; a successful middle-edge press is not proof. |
| TE-05 | Schmersal SE-304C uses auto-reset `A3/X2`; normal CNC has retained motion request. | Device auto-reset may restore a monitor output when edge clears. Require independent safety restart inhibit, cleared occupancy and fresh start; do not assume a specific machine auto-restarts without evidence. |
| TE-06 | Technician uses SE-304C `X2/X3` manual reset and claims this proves the gantry is stopped. | OEM `0-1-0` reset edge (100 ms–2 s) is a device-specific input window, not physical stop, safe separation or rearm proof. |
| TE-07 | The SE-304C signalling output reports 'healthy'; final contactor is welded. | Signalling output is distinct from qualified safety contact and physical final element. Hold release; verify independent feedback/stop. |
| TE-08 | A door's rubber edge gets clogged with chips; staff repeatedly bypasses it. | Treat this as maintainability/design failure. Select robust compatible profile and easy cleaning/replacement, accessible diagnostics and proper spare; never bless bypass. |
| TE-09 | Team claims ISO 13856-2 certificate proves this edge suits a fast press-brake point of operation. | ISO public abstract explicitly **does not establish particular application suitability**, effective sensing area or required PL. Physical machine hazard and safeguarding selection remain open. |
| TE-10 | Edge releases after a part is removed; controller is ready and a person remains inside the cell. | Release is not occupancy clearance, reset or fresh start. Require independent whole-body-access/restart protection and appropriate physical stopping/holding. |

## Minimal field worksheet

| Physical/safety proposition | Selected-machine evidence / UNKNOWN |
|---|---|
| Actual sensor principle (optical, monitored NO resistor/4-wire, NC chain), model/revision and matched evaluator | UNKNOWN |
| Hazardous contact points, corners, blind zones, direction/speed/geometry and body-part exposure | UNKNOWN |
| Selected profile actuation/deformation and allowed compression/overtravel/force data | UNKNOWN |
| Exact monitoring input, short/wire-break coverage, output role, fault response and controller authority | UNKNOWN |
| Qualified final elements, physical stop/reversal/hold, measured residual travel/force | UNKNOWN |
| Manual vs auto-reset, loss/return power, occupancy and fresh-start authorization | UNKNOWN |
| Cleaning, chip/oil resistance, spare part/repair access, defeat incentives | UNKNOWN |
| `CHG` after sensor/monitor/geometry/logic change and stale `VAL/PT` | UNKNOWN |

**Design rule:** Contact protection is not a substitute for preventing exposure when the residual travel/force cannot be made acceptable. Avoid adding awkward, fragile devices that people will bypass; choose a simple proven architecture that is easy to inspect and maintain. If a machine cannot meet the basic threshold, **do not operate with people exposed**; experiments only isolated/remote with people outside the danger zone and explicit residual risk.


## TE-11 — original OEM arithmetic and model-assumption challenge

**Paper only, unscored.** The [original Mayser 2025 PDF follow-up](../research/4400_EDGE_CALC_02_MAYSER_2025_ORIGINAL_PAGE_ARITHMETIC_ACTIVE_LENGTH_INSTALLATION_LIMITS_AUDIT_2026-10-29.md) now **directly confirms on printed p.17/28** that edition **080925 v2.13-RiA** prints `0.5×10×1.55=6.55 mm` and `s=7.86 mm`. The earlier [v2.11 catalogue excerpt audit](../research/4400_EDGE_CALC_01_MAYSER_NCII_OVERTRAVEL_EXAMPLE_ARITHMETIC_AND_SYSTEM_RESPONSE_AUDIT_2026-10-29.md) remains indexed-only. Recalculate the **stated** equation: `T=1.55 s`; `s1=7.75 mm`; `C×s1=9.30 mm`. The OEM's cited 12.4-mm profile overtravel exceeds 9.30 mm by **3.10 mm**, not the printed **4.54 mm**. Separately challenge whether a half-speed assumption represents a real detection delay plus braking; do not replace the OEM model with an unvalidated kinematic guess. OEM clarification and selected-machine force/stopping behavior remain UNKNOWN. No claim of OEM erratum, product failure or machine acceptance.

## TE-12 — original OEM active-length and mounting challenge

**Paper only, unscored.** A builder mounts a hypothetical **1000-mm Mayser SL NC II GP 48-2 NBR** edge along a closing surface and declares all 1000 mm protected. The [2025 original p.8/28](../research/4400_EDGE_CALC_02_MAYSER_2025_ORIGINAL_PAGE_ARITHMETIC_ACTIVE_LENGTH_INSTALLATION_LIMITS_AUDIT_2026-10-29.md) defines `L_WB = L_SL - 2×L_NE`, `L_NE=50 mm` per end for GP 48-2, yielding only **900 mm effective actuation length** under that formula; corners and angle remain separate. OEM p.8 also shows **NBR 60°** versus **EPDM 90°** effective angle, and p.6 excludes vertical installation position D and high-vibration/sealing use. A safe review needs exact orientation, corner/side-approach geometry, wiring protection, maintenance and qualified physical stop/hold/restart evidence. Do not use people as contact test objects; no exposed operation without independently established minimum safety threshold. G0/G1 HOLD.

## TE-13 — “two-wire monitored” does not waive protected cable routing

**Paper only, unscored.** A retrofit technician moves a Mayser SL NC II two-wire NC-chain cable outside its original protected conduit, splices both conductors through an exposed hinge, and argues that the OEM says its cables are constantly monitored. The [direct 2025 original p.4/7/11 fault-exclusion audit](../research/4400_EDGE_WIRE_01_MAYSER_2025_NC_FEEDBACK_PROTECTED_CABLE_FAULT_EXCLUSION_AND_PL_TRANSFER_AUDIT_2026-10-29.md) distinguishes feedback monitoring from **ISO 13849-2 Table D.4 fault exclusion** for short circuits in permanently installed, externally protected conductors. Mayser requires protected routing or separated sheaths where that is impossible; the published up-to-PL-d premise cannot be carried across the change without evidence. A short bypass is **topology-dependent INFERENCE**, not a proven machine failure. Record exact suffix/return topology, as-built cable protection, fault exclusions, independent safety logic/final elements, physical stop and restart as separate `CHG/DEP/VAL/PT` items. Do not short live wiring, defeat the edge, or use ordinary LinuxCNC GPIO as personnel-safety authority. G0/G1 HOLD.
