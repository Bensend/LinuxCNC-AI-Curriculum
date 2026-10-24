# 4400 — Setup enabling switch, safe-speed and mode-transition authority: original OEM source audit
**2026-10-24 | SOURCE READING / NO MACHINE TEST / NOT A SELECTED DESIGN**

## Engineering question
When a guard is opened for setting or observation, does a three-position enabling switch plus a configured Safely-Limited Speed (SLS) drive automatically create a safe mode? **No.** The actual protective claim depends on exact product/mode, guard and enabling-switch inputs, SLS entry delay, overspeed reaction, physical stopping/holding, exclusive mode selection, occupancy and restart. Ordinary LinuxCNC jogging is a motion request, not the safety oracle.

## Original manufacturer documents inspected
1. **Rockwell Automation, Kinetix 6200/6500 Safe Speed Monitoring Safety Reference Manual, publication 2094-RM001C-EN-P, May 2013**, original 156-page PDF, Chapter 7, printed pp. 78–83, particularly pp. 80–82: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/2094-rm001_-en-p.pdf . This is a **historical product-specific edition**, not a current OpenPressBrake component identification.
2. **Siemens, SINAMICS G Safety Integrated Technical Overview, April 2021**, original 32-page PDF, pp. 14–15 and 19: https://cache.industry.siemens.com/dl/files/736/109808736/att_1099817/v1/Sinamics_G_SafetyIntegrated_app_man_en-US.pdf . Introductory scope: standard induction motor examples, not an application safety acceptance test.
3. **Pilz, PITenable three-stage enabling-switch product documentation**, manufacturer web page: https://www.pilz.com/en-GB/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch . Product page inspected; its large catalogue PDF was not opened. Product family has OFF–ON–OFF positions; an enabling switch must be evaluated in a suitable safety circuit, not wired as an ordinary software button.
4. **Rockwell Logix Designer SLS safety instruction documentation**, current manufacturer web documentation, https://www.rockwellautomation.com/en-fi/docs/studio-5000-logix-designer/37-00/contents-ditamap/instruction-set/drive-safety-instructions/sls.html . Exact controller scope Compact GuardLogix 5380 / GuardLogix 5580; the safety instruction depends on CIP safety drive feedback and SFX; its limit output is used to initiate an application-specific response. Do not equate this instruction to every drive's integrated SLS.

## Product-specific findings and causal traps
| Finding | Classification | Exact scope | Consequence for design |
|---|---|---|---|
| Three-stage PITenable has released OFF, middle ON, fully depressed OFF | DOC-CONFIRMED | Pilz PITenable family page | Both panic squeeze and release require an independent safe response; a standard jog button is not equivalent. |
| Kinetix configured SLS + Door Monitoring + Enabling Switch Monitoring uses ESM_In and DM_In | DOC-CONFIRMED | Rockwell 2094-RM001C, pp. 80–83 | Check both inputs and selected mode; no single generic "SLS on" proof. |
| Kinetix example unlocks door after SLS delay, safe speed detected and middle-position enabling | DOC-CONFIRMED | Rockwell p. 80 | Delay completion and speed detection are prerequisites in this example; do not assume a command immediately permits access. |
| **Kinetix ESM input is not monitored until door input DM_In is OFF while SLS active** | DOC-CONFIRMED | Rockwell p. 82 warning | A pre-door-open ESM indication is NOT evidence of continuous safety monitoring. Test exact state transition/authority. |
| Kinetix ESM release with door open produces ESM Monitoring fault and configured Stop Category | DOC-CONFIRMED | Rockwell pp. 81–82 | "Fault" is not the physical stop time or gravity-load holding proof; actual final elements remain separate. |
| Kinetix manual warns SLS_In must not return to normal while personnel remain in hazard zone | DOC-CONFIRMED | Rockwell p. 80 | Prevent another operator from changing mode during entry; closed door behind a person does not prove vacancy. |
| Kinetix example describes normal run resumption after exit, door closure, configured reset and enabling-switch release | DOC-CONFIRMED | Rockwell p. 80 | This is **manufacturer example sequence**, not permission to preserve an old LinuxCNC run request. Design an independent fresh-start interlock after safety rearm. |
| Siemens encoderless SLS example directly monitors induction motor speed only while motor is energized/sensed by converter | DOC-CONFIRMED | Siemens pp. 14–15 | Cannot extrapolate encoderless SLS monitoring to coasting, gravity-driven or unpowered motion; select separate appropriate holding/monitoring. |
| Siemens SLS overspeed reaction is configured STOP A coast or STOP B controlled braking | DOC-CONFIRMED | Siemens p. 19 | "SLS active" does not identify stopping behavior; physical stop must be qualified. |
| Rockwell GuardLogix SLS instruction offers automatic or manual restart/cold start, Check Delay and SFX feedback-not-ready fault | DOC-CONFIRMED | Exact manufacturer online instruction | Input reset, controller rearm, safety-function availability and fresh normal motion command are different. |
| A guard-open press brake can be made safe by setting a slow jog feed in LinuxCNC | **UNSUPPORTED / REJECTED** | No installed machine proof | Slow requested speed alone cannot prove independent physical safe state, access protection, gravity holding or qualified safe-speed monitoring. |

## State-transition adversarial review (not a machine truth table)
- **Normal -> setup requested:** Who holds a safety-rated mode-selection authority? Does the safety system confirm safe motion before releasing a guard? What happens if SLS request is lost or delayed?
- **Setup entry -> guard opened:** Is enabling monitoring active at this instant? Rockwell's historical mode explicitly changes monitoring behavior at DM_In OFF; an operator must not infer constant protection.
- **Guard open -> jog:** Ordinary CNC requests motion; independent safety layer supervises permitted movement, overspeed and unexpected directions, and commands verified final elements. Hold-to-run and enabling may be necessary but are not automatically sufficient.
- **Release or panic press:** Demand independent stop and verify actual deceleration, coasting, load holding and remaining exposed motion; never use human subjects for a test.
- **Door reclosed behind someone:** Guard-closed status alone does not prove that the hazard zone is empty. Mode selection and rearm must not grant unattended motion.
- **Fault, power cycle, encoder loss, controller restart:** State defaults to no authorization until independent safety prerequisites and deliberate reset/fresh-start conditions are met.
- **Maintenance:** SLS and enabling are NOT energy isolation, load restraint or proof of zero pressure/voltage.

## Human-factors design
Provide a comfortable correctly located enabling pendant, guarded/limited access for routine setup, readable mode state, low-nuisance verified sensing, and a clear rearm sequence. If ordinary tooling adjustment requires defeating guards, redesign fixtures and access rather than making bypass a standard operator task. A holder or storage location must not accidentally defeat a grip device. Treat two operators or rear-access entrants as independent occupancy hazards.

## Open machine-specific questions
**UNKNOWN:** OpenPressBrake has any safety-rated drive SLS, three-position switch, mode selector, guard-locking, Y1/Y2 safe-speed feedback, certified safe-stop outputs or independent gravity-load restraint. Its hydraulic architecture may not support the electric-drive examples. **No** numeric safe speed, response time, distance, PL/SIL or pressure/valve truth table is transferred. All physical VAL/PT NOT RUN; G0/G1 HOLD; G3/G4 NOT AUTHORIZED. No exposed operation.

## Bounded evidence next
Collect exact as-built device manuals, mode truth/configuration, safety output wiring and final elements; qualified engineer maps setup hazards and verifies state transitions without personnel exposed. No simulation can settle unmeasured Y1/Y2 hydraulic holding or occupied-zone safety. A fresh evaluator must use a genuinely unseen manufacturer/configuration and an independent oracle.
