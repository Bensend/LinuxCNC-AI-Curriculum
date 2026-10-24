# 4400 — HAWE ePRAX gravity, hydraulic valve and stored-energy technician exercise

**2026-10-24. Open-book paper-only, NOT a physical test or blind evaluation.** Primary source: [HAWE B 6340 ePRAX source trace](../research/4400_HAWE_EPRAX_2026_GRAVITY_VALVE_ACCUMULATOR_SAFETY_SOURCE_TRACE_2026-10-24.md).

## Ten adversarial field cases

| Case | Fault/misleading statement | Minimum correct disposition |
|---|---|---|
| HW-F01 | "Our Y-axis motor speed command is zero, so the ram cannot descend." | **Reject.** In the documented OEM FAST DOWN mode gravity assists movement and active speed control contributes to hydraulic throttling. Require independent stop/final-element and physical beam witness. |
| HW-F02 | "The motor drive went inactive; its status bit is the protective stop." | **Reject.** OEM warns about beam acceleration if speed control is inactive. Check safety-related valve authority and actual motion, not only drive status. |
| HW-F03 | "There are two servomotors, so we have redundant personnel safety." | **Reject.** Separate Y-axis normal drives are not proof of independent safety final elements or common-cause resilience. |
| HW-F04 | "All hydraulic coils dropped; the ram is physically held." | **Reject.** OEM IDLE/stop descriptions are commanded architecture. Require actual valve/holding/beam evidence and fault coverage. |
| HW-F05 | "Linear scales are on the CNC, so we can do all overspeed safety in LinuxCNC." | **Reject.** The manufacturer assigns safety-related speed monitoring to a safety-related control function; ordinary CNC readback is not equivalent. |
| HW-F06 | "Pump power is off; no hydraulic energy can raise the beam." | **Reject.** Optional Slow Up accumulators can retain energy; first establish installed option and trapped-energy isolation. |
| HW-F07 | "Use HAWE's factory orifice as-is with our different cylinder and beam." | **Reject.** OEM requires checking flow limitation against actual geometry, weight and pressure. No borrowed velocity criterion. |
| HW-F08 | "The pressure coupling is open but the factory restriction guarantees safety." | **Reject.** OEM restriction is conditional; opening any pressurized port is a hazard. Do not perform an improvised live test. |
| HW-F09 | "A safety switch was jumpered for maintenance and can stay that way because the HMI says SAFE." | **Reject.** Remove/verify the bypass and perform change-controlled safety function revalidation before return to service; redesign access and diagnosis to remove bypass incentives. |
| HW-F10 | "HAWE's product declaration makes our retrofit safe." | **Reject.** The manual treats the drive as a component/partly completed machinery; machine-level safeguarding, safety controller and validation remain separate. |

## Required trainee answer

For each case provide (1) exact **OEM/variant/source page**, (2) normal-control proposition, (3) independent safety demand/final element, (4) physical energy/motion/holding witness, (5) fault path that escapes a healthy status bit, (6) what would falsify the conclusion, (7) UNKNOWNs, and (8) return-to-service gate.

### Human-factors redesign prompt

A technician can reach a valve connector in seconds but needs 20 minutes to install the ram support and another 20 minutes to find the accumulator service point. Propose a redesign that makes the correct isolation/support/verification routine the easiest action: retained and labeled supports, safe access to test points, legible drawings and fault-state display, short but robust reset sequence, no hidden bypass switches. Record `HF` finding, `CHG` corrective action, `ARC` ownership and `VAL/PT` revalidation. **Do not** invent a 20-minute actual installation time; it is a hypothetical scenario.

**Disposition:** all `HW-F01..10` paper-only; selected `PHY/VAL/PT NOT RUN`, no machine approval.


## Additional option-code traps (D 6340 07-2026)

| Case | Misleading statement | Required disposition |
|---|---|---|
| HW-F11 | "The manifold looks like the monitored version, so its four valve switches must exist." | **Reject.** D 6340 p. 11 distinguishes cylinder-module `S` monitoring option from a no-monitoring order code. Obtain the actual installed nameplate, wiring and controller evidence. |
| HW-F12 | "The product brochure shows a Slow Up accumulator, so every ePRAX has one." | **Reject.** D 6340 p. 12 codes `X` for no Slow Up and `A/B` for optional variants. Confirm actual Y1/Y2 installed codes and physical accumulator/energy zones. |
| HW-F13 | "The 04-2026 operating manual and 07-2026 datasheet must have identical circuits." | **Reject.** Distinct editions; reconcile selected serial/revision and drawing identity before transferring pin/valve claims. |

All `HW-F11..13` remain paper-only, `VAL/PT NOT RUN`.
