# ALARM-NOISE-01 adversarial source reconciliation — does a warning ever displace LOTO?
**2026-10-26 | case-law/source-scope research, not legal advice or a machine exemption**

## Why this follow-up was necessary
A simplistic statement that "an audible warning can *never* matter to the scope of hazardous-energy regulations" would misstate an inspectable court decision. Conversely, copying the decision as permission to install a buzzer instead of isolating a press brake would be dangerous. This is a **new exact authority/scope reconciliation**, not a new generic warning or LOTO lesson.

## Three distinct original-source findings
1. **DOC-CONFIRMED direct court text hosted by OSHA:** [Reich v. General Motors / Delco, 89 F.3d 313, Sixth Circuit, decided 1996-07-18](https://www.osha.gov/etools/lockout-tagout/case-law/gm), §§I–III. The court affirmed vacating citations **on the specific findings** that interlocked gates stopped machines and an eight-to-twelve-step conspicuous restart sequence provided sufficient advance warning for servicing personnel to leave the danger zone. Audible/visual cues were **part** of that evidence, not a standalone horn qualification. The decision concerns the word "unexpected" in the scope of 29 CFR 1910.147.
2. **DOC-CONFIRMED official OSHA indexed interpretation (direct page HTTP 403):** [OSHA 1999-10-05 LOTO issues letter](https://www.osha.gov/laws-regs/standardinterpretations/1999-10-05) explicitly distinguishes Delco's shut-down-for-servicing facts from servicing during energized/normal production. OSHA states the limited minor-servicing exception requires effective alternative protection and that merely shutting off a machine is not recognized safeguarding. This interpretation and Delco address **different fact patterns**; neither supplies a generic buzzer exemption.
3. **DOC-CONFIRMED official OSHA indexed rule:** [29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147) still requires hazardous-energy control for covered servicing, including stored-energy hazards. A warning does not remove hydraulic pressure, electrically isolate conductors, or physically hold a gravity-loaded ram.

## Adversarial transfer
| Tempting assertion | Correct engineering/source boundary |
|---|---|
| "The Sixth Circuit said audible alarms replace LOTO." | **False generalization.** Delco involved interlocked gates, extensive visible restart sequences, and fact-specific findings; scope and jurisdiction differ. |
| "A ten-second LinuxCNC prestart chime means maintenance is safe." | **Not established.** Worker reception/egress, unexpected energy, stored pressure, ram hold, independent safeguarding and applicable servicing rules remain unresolved. |
| "Because a warning cannot physically stop a machine, no court could ever credit it." | **Also overbroad.** Delco credited a complete specific advance-notice architecture in interpreting *unexpected* startup, not the horn as a safety final element. |

## Decision gate
Do not design OpenPressBrake service access around a hypothetical Delco-style exception. Treat covered service as requiring applicable isolation, verification and positive gravity-load support; only a qualified jurisdiction/task-specific reviewer may assess a narrow legal exception **after** actual as-built safeguards, exposure, restart and stored-energy behavior are established. Ordinary LinuxCNC/FPGA/HMI warnings never acquire independent safety-rated stopping authority from this case. No machine-specific legal conclusion or physical test. **G0/G1 HOLD**.

**Evidence labels:** DOC-CONFIRMED exact 1996 court text; DOC-CONFIRMED indexed OSHA 1999 interpretation/1910.147 with direct-open 403; INFERENCE conservative engineering gate; UNKNOWN installed OpenPressBrake controls and jurisdiction-specific applicability; SOURCE-CONFIRMED LinuxCNC none; TEST-CONFIRMED none.
