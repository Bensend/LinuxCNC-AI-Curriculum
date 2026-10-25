# 4400-TOOL-02 — Automatic press-brake tool changer compatibility and false capture proof
**2026-10-25 | DISTINCT safety branch | manufacturer source | NON-GRADUATED**

## Question
Can an automatic tool changer use a “WILA ATC” tool merely because it fits a gripper, and can a Safety-Click position signal prove safe physical tool transfer? **No.** Product generation, adapter, gripper, mechanical engagement, transfer support and independently validated safety authority are separate.

## Manufacturer evidence (accessed 2026-10-25)
- **WILA Premium NS ATC Tooling:** https://www.wilatooling.com/en-us/products/smart-bending/tooling-for-atc/wila-ns-atc-new/ — manufacturer's product page explicitly says NS ATC tooling is **only suitable for the WILA NS ATC ToolGripper** and **incompatible with the classic G-Series ATC Gripper**. Front, back or dual-side Safety-Click operation is a **configuration variant**, not automatic equivalence. **DOC-CONFIRMED indexed manufacturer text**; page load timed out during full open, so exact selected manual still needed.
- **WILA ATC Components:** https://www.wilatooling.com/en-us/products/smart-bending/atc-components/ — original manufacturer page directly inspected. NS ToolGripper handles compatible top/bottom tools; optional rear/both-side pick; dual unit accommodates tools up to **515 mm length**; optional **Safety-Click position detection** described as improving process control; docking pins are separate storage interfaces. **DOC-CONFIRMED.** The length is a specific dual-gripper capability, not a mass/load/safety rating.
- **WILA Automatic Tool Change:** https://www.wilatooling.com/en-us/knowledge-innovation/our-innovations/automatic-tool-change/ — pneumatic gripper, storage rails/docking pins, and BendSense tool identification/position/foreign-object detection. **DOC-CONFIRMED manufacturer functionality; not independently safety-rated.**
- **WILA BIU-026 ATC classic product:** https://www.wilatooling.com/en-us/products/smart-bending/tooling-for-atc/wila-g-series-atc-classic/biu-026-atc/ — exact classic part page says pieces **<12.5 kg** use Safety-Clicks for vertical change; other parts have fixed safety pins and **horizontal-only** change. **DOC-CONFIRMED exact product text.** This strict '<' is not identical to the generic WILA ≤12.5 kg product-family statement. Do not decide boundary behavior for exactly 12.5 kg without selected manufacturer instruction.

## Failure-chain decomposition
| Transition | Required independent evidence | Wrong shortcut |
|---|---|---|
| Storage -> gripper | Correct tool ID/generation/adapter, physical engagement and storage release conditions | Name says “WILA ATC” |
| Gripper -> transfer | Exact pneumatic gripper retention under selected fault/power-loss behavior; safe zone and physical support | Position sensor reports closed |
| Transfer -> holder | Compatible tool, capture/seat, independent holder engagement | Robot position reached |
| Holder -> release gripper | Physical holder capture and safe handoff; no single common sensor/air supply assumption | BendSense tool ID or Safety-Click sensor alone |
| Production rearm | Guard/cell occupancy and independent safety final elements, fresh cycle start | Normal PLC/LinuxCNC ATC cycle complete |

**Adversarial counterexample:** new NS ATC tool is loaded into an old G-Series gripper by matching dimensions, while a process-position signal reads plausible. Manufacturer declares generation incompatibility. A green process signal cannot override incompatible mechanical retention. **HOLD** and identify exact mating hardware. This is not a tested failure of an actual machine.

**Common cause:** gripper actuation, Safety-Click operation, and process sensors may share pneumatic supply, wiring, software or fixture reference. A plausible correlated status does not establish independent physical retention. Exact diagnostic architecture and safety-rated capability **UNKNOWN**.

## Source ledger and boundaries
**DOC-CONFIRMED** generation incompatibility, optional pickup orientations, dual length capability, process-detection feature, classic part vertical/horizontal split. **INFERENCE** multi-stage transfer SRS and independent physical witness. **SOURCE-CONFIRMED** no new LinuxCNC source; normal robot/CNC ATC sequencing remains non-safety authority. **TEST-CONFIRMED none; COMMUNITY-REPORTED none. UNKNOWN** selected tool changer, gripper fail state, pneumatic safe-state, sensor integrity, physical retention, safety performance, independent evaluator. No selected WILA ATC on OpenPressBrake is asserted.

## Information-gain stop
OEM exact part/adapter manuals and a qualified selected-cell design are needed to determine gripper behavior under air loss, detection limits, storage support and safe release ordering. No synthetic simulation can establish these physical facts; no lab justified. A robot/cell must not run with people exposed to the transfer zone without verified independent safeguards.
