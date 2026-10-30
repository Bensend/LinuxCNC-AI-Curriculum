# 4400-TK-03 source-depth — Fortress commissioning, service interval and override custody
**2026-10-30 | DIRECT ORIGINAL OEM OPERATING INSTRUCTIONS | NON-GRADUATED | NO MACHINE TEST**

## Predecessor reconciliation — important correction
**SOURCE-CONFIRMED:** [2026-10-25 Fortress TK-03 original manual audit](4400_FORTRESS_LOK_LOCK_MONITOR_VS_PROCESS_ONLY_AND_ESCAPE_CONTACT_VARIANTS_AUDIT_2026-10-25.md) already established PTU/PTL, monitored versus unmonitored contacts, SR/ZR/LR versus SE/LE escape contact changes, and OEM warning that LOK is not a mains isolator/E-stop/mechanical stop. **Those are NOT new findings here.** This addendum independently rechecks them and adds the original **printed p.15 commissioning sequence** and **p.16 5,000-cycle / at-least-twice-annually maintenance guidance**, plus override-key custody as a concrete technician maintenance check. Do not create another scored module.

## Exact source and product scope
Fortress Safety, **amGardpro LOK "Operating Instructions: Interlocks with Locking"**, original OEM PDF hosted in 2025 path: https://fortress-safety.com/app/uploads/2025/04/Interlocks-with-Locking-Operating-Instructions.pdf . Directly inspected printed pp.1–5, 8–9, 15–16. This document covers **configurable amGardpro LOK** modules; its detailed behavior must not be transferred to all mGard mechanical key systems, all Fortress products, or an unknown installed OpenPressBrake guard.

## Source-confirmed contrasts
| Proposition | Original OEM evidence | Engineering consequence |
|---|---|---|
| **Power-to-unlock (PTU)** | Printed pp.1–2 describe PTU LOK and example **SL411** as suitable for guard locking. | An unlock signal is a *permission mechanism*, not proof that the downstream machine has stopped or is safely held. |
| **Power-to-lock (PTL)** | Printed p.2 lists **SL461** with unmonitored solenoid safety circuits, no manual release, suitable for **process protection**. | Do not swap a PTL process-protection variant into a personnel guard design merely because it has a locking bolt. Exact option and monitored circuits matter. |
| **External auxiliary/emergency release** | Printed pp.4, 8–9: auxiliary key tool or emergency knob can unlock without ordinary solenoid command; associated contacts change state. OEM explicitly warns not to leave the auxiliary release key in place and to secure it under management control. | Override is an intentionally available defeat/recovery path requiring physical access control, logging, independent stop function and qualified revalidation. A contact opening commands a stop; it does **not** prove the ram or spindle has physically stopped. |
| **Inside escape release** | Printed p.8–9: SR/ZR/LR escape release opens NC head contacts; SE/LE variant opens NC solenoid contacts; LED behavior differs. The OEM calls for monitoring and a risk-assessed reset procedure. | A person trapped inside needs an accessible escape route. Do not treat a generic LED color or one contact name as equivalent across options. Escape release must not silently rearm. |
| **Commissioning** | Printed p.15: check locked/unlocked states, actual trapped-key/actuator sequence, contact and LED transitions, manual/escape release and return. | These are *device checks*, not a complete physical stop/hold or safe-distance validation. Perform only under a qualified isolation plan; no owner-run live test is authorized. |
| **Service** | Printed p.16: OEM recommends inspection every **5,000 cycles or at least twice annually**, more often if application requires. | Contamination, actuator wear, loose mounting, emergency-release seal, key wear and lost spare-key controls are maintenance hazards, not just cosmetic issues. |

**DOC-CONFIRMED** for this manual's stated options and procedures. **INFERENCE** for cross-machine failure-path consequences. **UNKNOWN** exact chosen part number, whether any selected machine has these devices, contact wiring, independent final-element response, escape geometry, physical safety performance. **TEST-CONFIRMED none.**

## Failure-path worksheet (paper-only)
1. **Supply disappears**: which *exact* PTU/PTL option is installed? What is its locked state without power? What remains physically dangerous? Do not infer actual safe access from the name alone.
2. **Auxiliary key left in place**: opening is possible without the intended controlled unlock. How does the independent safety path detect it, and who controls/records overrides?
3. **Escape used**: contact transition differs by SR/ZR/LR versus SE/LE. What does the actual safety receiver detect, what stops/holds the machine, and what deliberate reset follows?
4. **Wrong spare or duplicate key**: the key chain can be circumvented. What prevents casual replacement, misplaced code reuse or improvised duplication?
5. **Sticking gate actuator**: contacts and LEDs may change, but key retention and guard geometry must be mechanically inspected.
6. **Run-down mismatch**: a timed release from a 2020 OEM brochure is not a universal physical standstill signal. A selected stop-time or zero-motion function needs qualified verification under actual worst-case load and failure conditions.

## Human-factors design constraint
Choose robust keyed/guard hardware that is easy to close, align, clean and reset from outside the danger zone; make a protected jam-clearing path convenient. Keep emergency egress intuitive, reachable and documented. If the design forces technicians to leave an override key in place to do routine work, redesign the access/recovery process. Treat override and spare-key control as engineered requirements, not a warning label.

## OpenPressBrake gate
An OEM PTU/PL e/Cat 4 suitability statement for a **component in an appropriately designed system** is not a machine-level performance rating. Actual independent hydraulic/electrical/mechanical stop and ram support remain UNKNOWN; Stage A A–G and independent 2520–25F0 evaluator remain OPEN, G0/G1 HOLD, no personnel-exposed operation. No compute, tests, simulation or machine operation.
