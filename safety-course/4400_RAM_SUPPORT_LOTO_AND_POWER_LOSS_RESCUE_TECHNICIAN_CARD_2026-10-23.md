# 4400 technician exercise — ram restraint, energy isolation and rescue are different propositions
**Open-book training card | 2026-10-23 | paper-only; NOT a work instruction, emergency-response script or machine release.**

Read the [OEM source audit](../research/4400_CINCINNATI_PROFORM_RAM_RESTRAINT_LOTO_RESCUE_MANUAL_ERRATA_AUDIT_2026-10-23.md) and the selected-machine physical-witness intake. Do not operate, bleed, lift or enter a hazardous machine as part of this exercise.

## Six propositions, six separate questions
**STOP:** Is hazardous ram motion actually stopped? **HOLD:** Is the load physically restrained against gravity/pressure loss? **ENERGY:** Have all relevant electrical, hydraulic, pneumatic, stored and reaccumulating energy sources been controlled and verified? **ACCESS:** Can a person reach a hazardous zone? **ESCAPE:** Can a trapped person be freed even if electrical power is absent? **RESTART:** Does restoration require a deliberate new authorization and start rather than automatic motion?

## Adversarial paper cases
| Case | Technician statement | Required reasoning and disposition |
|---|---|---|
| 1 | “The pump is off and the PC says E-stop, so we can service below the ram.” | **REJECT.** Normal controls and motor state do not prove mechanical load holding, full isolation or stored-pressure control. |
| 2 | “A Cincinnati manual says supports need 10% of press capacity; use that rule on our retrofit.” | **REJECT.** Product-specific OEM instruction; different ram mass, geometry, load cases and support paths require selected engineering. Do not substitute ram weight for press capacity. |
| 3 | “The gauge at the main manifold reads zero, so all cylinder and accumulator zones are safe.” | **REJECT.** Identify and verify each exposed hydraulic/gas/pilot zone and potential reaccumulation. |
| 4 | “The manual says Figure 1-2 item 13 is the disconnect; go to item 13.” | **STOP/ESCALATE.** Figure legend only has items 1–9 and calls item 9 the disconnect. Resolve actual equipment/revision before action. |
| 5 | “A different manufacturer says POWER OFF before maintenance; that's our complete LOTO.” | **REJECT.** An HMI command is not a complete isolation, support and verification procedure. |
| 6 | “Emergency entrapment with no power is just the normal RAM UP command.” | **REJECT.** Rescue requires an independent planned means and trained personnel; a control command may be unavailable. |
| 7 | “We can use the 2014 model's published bleed duration on any hydraulic press brake.” | **REJECT.** No selected circuit/pressure zone, valve variant or independent confirmation. |
| 8 | “The safety output reenabled, so the ram may automatically resume.” | **REJECT.** Reenable and deliberate restart are separate. Verify people clear, protections restored and authorized new start. |
| 9 | “The ram is supported, so no need to isolate hydraulics before opening the circuit.” | **REJECT.** Physical support does not remove stored fluid pressure or injection hazards. |
| 10 | “We need to remove the guard for frequent maintenance, so let's leave it off.” | **REJECT.** Redesign for convenient access, captive/reinstallable guard, visibility and suitable safe setup/maintenance mode without bypassing independent protection. |
| 11 | “The OEM's no-power rescue section mentions high-pressure fitting work; we'll try it during a class.” | **REJECT.** Emergency rescue text is not a novice exercise or a universal procedure. Paper review only; qualified responders and actual equipment-specific plan required. |
| 12 | “The ram is visibly motionless; a service technician can reach underneath.” | **REJECT.** Static appearance does not prove gravity load restraint or isolation under a fault. |

## Learner task (no hidden answers)
For any two cases, fill in **(a)** hazard and exposure; **(b)** exact source and edition; **(c)** missing physical proposition; **(d)** normal-control versus safety versus mechanical authority; **(e)** lowest-friction safeguard improvement; **(f)** witness/competent reviewer needed; **(g)** evidence class. Explain why a different OEM's maintenance note is not an acceptance oracle. This is an **open-book, non-blind** exercise, not an external 2520–25F0 competency score.

## Practical minimum release rule
Do not operate with people exposed if physical stop/hold/energy/access/escape/restart safety requirements are unproven. Isolated/remote experimental operation requires its own risk review and people outside the hazard zone. Selected-machine `IN-01..10` and all `PHY-*` remain UNKNOWN; `VAL/PT` NOT RUN. No pressure, support, stop-time or PL/SIL value is supplied here.


## OEM option and mode-change follow-on (open-book, paper only)

| Case | New scenario | Correct discriminator |
|---|---|---|
| 13 | “A red GUARD OFF lamp means the ram is now safe for a helper.” | **REJECT.** It reports muting; require separately qualified alternative protection and actual physical stop/safe-motion/access evidence. |
| 14 | “Two selected footswitches guarantee both operators are out of danger.” | **REJECT.** Step-selectable pedal logic is not two-hand safeguarding or personnel detection. |
| 15 | “An OEM default ADI plug must be safe to substitute for our connected third-party device.” | **UNKNOWN/DO NOT SUBSTITUTE.** Need exact installed wiring, pinout, safety-function allocation and approved configuration. No claim that the plug inherently bypasses safety. |
| 16 | “Main ram circuit isolated means die clamps and Auto Crown cannot contain energy.” | **REJECT.** Installed hydraulic options require separate energy-zone and mechanical load-path inventory. |
| 17 | “The manual lists optional rear guarding, therefore it is present on this serial number.” | **REJECT.** Verify installed guards and accessible rear/side/helper zones. |

Read [OEM options source audit](../research/4400_PROFORM_OPTIONAL_MUTING_ADI_PLUG_FOOTSWITCH_AND_HYDRAULIC_ADDON_AUDIT_2026-10-23.md). These are learner-visible non-blind exercises; no physical testing, no evaluator scoring and no safety authorization.
