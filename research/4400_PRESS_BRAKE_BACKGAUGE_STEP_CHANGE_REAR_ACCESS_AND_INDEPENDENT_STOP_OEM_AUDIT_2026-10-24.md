# 4400-BG-01 — Backgauge automatic step change is a separate personnel hazard

**Original OEM/regulatory source audit | 2026-10-24 | DOC-CONFIRMED where specified; INFERENCE/UNKNOWN separated | NO PHYSICAL TEST | NOT GRADUATED**

## Exact evidence and scope

1. **Primary original manufacturer manual, directly inspected:** TRUMPF, *TruBend Series 2000 (B35), Operator's manual*, **B1161en 2023-05-01**, 114-page original manufacturer PDF, https://www.trumpf.com/filestorage/TRUMPF_US/user_upload/PIM_TruBend_Serie_2000_B35_us_V3.pdf . PDF pages **10, 13–14, 18, 20–24** (printed 1-11, 1-14/15, 1-19, 1-21–25). This is a **specific B35 manufacturer architecture**, not a LinuxCNC/OpenPressBrake safety circuit.
2. **Second original manufacturer product page, directly inspected:** AMADA America, *EGBe Series*, https://www.amada.com/america/egbe-compact , section **Backgauge**. Describes high-speed multi-axis positioning, independent L/L-shift servo drives and double-clamp fingers. Product marketing confirms the existence of the motion architecture, **not** safety-function behavior, protective distance or certification.
3. **Official OSHA, directly indexed but page fetch returned 403:** OSHA 1997 directive CPL 02-01-025, *Guidelines for Point of Operation Guarding of Power Press Brakes*, https://www.osha.gov/enforcement/directives/cpl-02-01-025 . Search-indexed official text distinguishes point-of-operation from other hazards and requires feasible guarding of hazards elsewhere; full directive **not re-read directly this session**. OSHA 1910.212 machine guarding text: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212 . This is legal applicability context, not a backgauge design prescription.
4. **Cross-machine safety bulletin, manufacturer-independent analogy only:** OSHA SHIB *Cabinet Press Pinch Point Hazard*, https://www.osha.gov/publications/shib071603 , indexed official page, direct fetch 403. Describes a cabinet-press **return** motion hazard after a stop/cancel command; this is **not a press-brake backgauge case**. Use solely to challenge the false assumption that every stop/cancel command necessarily prevents a different axis from automatically returning.

## Primary OEM observations (DOC-CONFIRMED)

| ID | Exact manual passage | Safety interpretation | What it does NOT prove |
|---|---|---|---|
| BG-O1 | Printed **1-11**: backgauge can move unexpectedly at high speed; operator should wait until it reaches next position, not reach over bend line; extra fingers and Z travel can collide. | Backgauge and accessory fingers have their own hazard envelope, not merely ram Y1/Y2. | No selected safe-speed limit or access detection. |
| BG-O2 | Printed **1-14/15**: mispositioned sheet may strike gauge finger; loaded tooling may collide with X/R finger positions. | Part, tooling, gauge fingers and axis sequencing interact. | No transferable X/R limit or collision envelope. The OEM's example numerical tool-clearance instruction is **not** a universal criterion. |
| BG-O3 | Printed **1-19**: automatic backgauge step change can trap a person between tooling and backgauge during bending-foil handling; OEM instructs use of E-stop before that task. | Legitimate nonproduction work can coincide with an automatic axis transition. | E-stop is not maintenance energy isolation; no guarantee of selected physical holding. |
| BG-O4 | Printed **1-21/22**: monitored rear door and side doors have different described reactions; E-stop stops **all backgauge axes** and OEM states drives remain supplied while STO prevents torque. | Different safeguards can have different authority and consequences; energized drive electronics may coexist with STO. | STO is not electrical isolation, physical zero motion, or ram gravity restraint; no selected topology. |
| BG-O5 | Printed **1-23/24**, Table 1-9: a manual next-index strategy can defer backgauge movement until **START** or the **PRESS BEAM DOWN** footswitch after beam upper dead point. | The **same stored next-position request** may execute on a later operator input; the trigger is mode/configuration-dependent. | The excerpt does not establish all available strategies, controller implementation, safety integrity or OpenPressBrake sequence. |
| BG-O6 | Printed **1-25**: manufacturer safety labels separately identify backgauge crush/impact from tooling/workpiece crush. | Machine hazard inventory must not collapse these to one point-of-operation row. | Warning labels alone are not a protective function. |

**Edition guard:** the B35 manual states its USA model/edition; do not generalize its side-door response, STO configuration, footswitch or backgauge step behavior to another B35 revision or any OpenPressBrake retrofit. An earlier 2019 mirror has different text; this audit uses **only the original 2023 OEM manual** as the authoritative edition for the observations above.

## Causal hazard trace (INFERENCE, not tested)

**Normal path:** program contains a next backgauge position -> LinuxCNC or another ordinary controller may queue axis X/R/Z/L motion -> a configured step trigger is reached -> backgauge/fingers traverse a physical volume -> operator/helper/rear maintainer may occupy that volume. Normal position feedback and motion completion help with process control, **not personnel-safety permission**.

**Failure A — delayed step after apparently completed bend:** operator reaches to adjust foil or retrieve a sheet after ram stops; a later START/footswitch or automatic phase transition moves the gauge. Prevent exposure with independent protective measures and explicit mode/task hazard boundaries; do not rely on the last visible ram state.

**Failure B — wrong accessory envelope:** additional finger/tool or support changes collision space without corresponding motion-envelope review. A normal soft limit is not a safety-rated guard.

**Failure C — rear guard opened but normal UI remains enabled:** the ordinary LinuxCNC interface may still display a valid target or READY. Only the selected independent safety system/final elements can establish the required protective response. An HMI indicator is a diagnostic, not proof of safe torque removal.

**Failure D — E-stop/reset/power return with queued gauge move:** resetting a safety device can restore eligibility while the normal controller retains a command. Safety rearm must be distinct from a deliberate fresh machine start, and restart prevention must address the gauge as well as the ram.

**Failure E — stop command becomes return command:** OSHA's cabinet-press example demonstrates the general design trap, but **does not establish this behavior in a press brake**. For a selected gauge, inspect its exact stop/abort/recovery implementation rather than assuming it returns, or assuming it stays.

## Proposed architecture: separate four layers (INFERENCE)

| Layer | Permitted function | Prohibited shortcut |
|---|---|---|
| Normal LinuxCNC / FPGA | X/R/Z/L trajectory, targets, program step timing, motion sequencing, soft travel limits, UI prompts. | Do not grant personnel-safety authority merely because the servo thread is realtime or the axis is stopped in software. |
| Diagnostics | Axis actual/target/fault, step queued/armed/executing, guard status as *reported*, timestamps, per-guard identification. | Green READY, encoder stationary or servo-disabled bit is not physical proof. |
| Independent safety-related control | Hazard-specific protective-device evaluation, appropriately designed drive stop/STO/other required safety function, reset/restart prevention and safe access decisions. | Do not route all safety through an ordinary M-code, FPGA watchdog or HMI stop. |
| Physical energy removal/containment | Actual final-element torque removal, appropriate isolation for servicing, physical rear/front/side barriers, ram gravity-load restraint and stored-energy control. | STO does not isolate electrical energy or hold a gravity-loaded hydraulic ram. |

The actual integrity target, stop method, stopping distance, access geometry, electrical/hydraulic state and permissible setup mode are **UNKNOWN** until machine-specific engineering and qualified measurement.

## Human factors: easiest correct workflow

Make the intended gauge movement visible and predictable: a clear **next gauge movement pending** indication, a physically accessible protected setup route, easy-to-reinstall side/rear guards, robust finger mounting and a nonhazardous method to verify tooling clearance. Ask operators which tasks create pressure to reach behind the bend line and change the workflow before relying on warnings. Do not make recovery require a jumper or removal of a hard-to-align guard. Ordinary warning/status indicators improve usability but are never the protective stop.

## Minimum selected-machine evidence and disposition

Inventory axes and moving appendages, drive/STO safety function and exact device variant, footswitch/START step-change triggers, program phase behavior, all front/rear/side access and helper locations, guarding and physical final elements, tooling/finger clearance, stop/hold and power-return behavior. Trace **BND/HAZ/ENE -> SF/SRS/PHY -> AUTH/ARC/DEP -> VAL/PT -> HF/CHG/RR/UNK**. Only a qualified, protected test plan with people outside the danger zone may validate actual stop/hold and restart; no hazardous physical test is authorized by this paper.

**Evidence ledger:** SOURCE-CONFIRMED (LinuxCNC source): **none new**. DOC-CONFIRMED: exact TRUMPF/AMADA passages and OSHA official indexed context with access limitation. TEST-CONFIRMED: **none**. COMMUNITY-REPORTED: **none used**. INFERENCE: four-layer architecture and A–E failure paths. UNKNOWN: selected OpenPressBrake gauge axes, trigger implementation, guard/STO circuit, stop time, PL/SIL, physical stopping and safe access. **G0/G1 HOLD, G2 NOT RUN, G3/G4 NOT AUTHORIZED, G5 independent evaluation OPEN**. No personnel-exposed hazardous operation.
