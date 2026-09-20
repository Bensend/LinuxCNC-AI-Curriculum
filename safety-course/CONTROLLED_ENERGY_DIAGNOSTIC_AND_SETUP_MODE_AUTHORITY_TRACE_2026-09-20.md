# Controlled-energy diagnostic and setup-mode authority trace

Date: 2026-09-20

## Purpose

The preceding maintenance-isolation study established that ordinary controls, interlocks, and safety-related stop functions are not automatically hazardous-energy isolation. This study addresses the complementary question: what does a professional architecture look like when a legitimate setup, diagnostic, cleaning, or maintenance task actually requires controlled motion/energy to remain available?

The answer is not "maintenance mode bypasses safety." Professional examples replace the normal production safeguarding assumption with a deliberately constrained safety function and task-specific authority.

## Evidence 1 — SICK Safe Stationary Machine commissioning sequence

Source: SICK, *Safe Stationary Machine* operating instructions, commissioning checklist, Annex 9.
URL: https://www.sick.com/media/docs/9/59/059/operating_instructions_safe_stationary_machine_en_im0075059.pdf

**DOC-CONFIRMED:** Service mode is a separately selected operating mode. The commissioning sequence requires Reset, then the enabling switch held, then a separate Start before reduced-speed motion begins.

**DOC-CONFIRMED:** Releasing the enabling switch causes SS2. During an E-stop recovery challenge, enabling + Start before the required Reset produces no motion; only the prescribed Reset -> enabling -> Start ordering restores reduced-speed operation.

**DOC-CONFIRMED:** The source therefore provides a physical/commissioning witness that retained or prematurely asserted ordinary start intent does not automatically become motion authority after a safety demand.

## Evidence 2 — Rockwell Safe Limited Speed with door/enabling monitoring

Source: Rockwell Automation, PowerFlex 750-Series Safe Speed Monitor reference manual, Safe Limited Speed modes.
URL: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/750-rm001_-en-p.pdf

**DOC-CONFIRMED:** A documented SLS procedure allows a person to enter a hazard area while maintaining an enabling switch under a configured safe-limited-speed condition. The procedure warns that the SLS input must not be allowed to transition back to the normal condition while a person remains in the hazard area.

**DOC-CONFIRMED:** Return to normal operation is a sequence: leave the hazard area while holding the enabling switch, keep it held until the door is closed and the SLS condition is removed, perform reset if manual reset is configured, then release the enabling switch.

This is not equivalent to unrestricted energized maintenance. The remaining motion authority is bounded by a safety function and a deliberate human control.

## Evidence 3 — Rockwell three-position enabling switch

Source: Rockwell Automation, 440J Grip Enabling Switches.
URL: https://www.rockwellautomation.com/en-us/products/hardware/safety-products/440j-grip-switches.html

**DOC-CONFIRMED:** The device is intended as part of the conditions for safe work inside a machine guard and provides dual independent three-position enabling channels. This supports the human-factors property that both releasing the device and panic/over-squeeze behavior can remove enable authority when implemented in the validated safety architecture.

## Evidence 4 — Pilz setup/maintenance safe motion

Sources: Pilz, *Safe motion monitoring*; Pilz PITenable enabling switch; Pilz Safety Compendium safe-control example.
URLs:
- https://www.pilz.com/en-SG/products/applications/safe-motion-monitoring
- https://www.pilz.com/en-IE/products/operating-and-monitoring/control-and-signal-devices/pitenable-enabling-switch
- https://www.pilz.com/mam/pilz/content/editors_mm/safety_compendium_en_2017_12_low.pdf

**DOC-CONFIRMED:** Pilz describes safe speed monitoring as protection for operating/maintenance employees and explicitly discusses working with a safety gate open at safely limited setup speed.

**DOC-CONFIRMED:** PITenable is a three-level Off-On-Off enabling device intended for work in a machine danger zone when the normal protective device must be suspended for the task.

**DOC-CONFIRMED:** The Pilz compendium gives the architecture pattern explicitly: if drives must operate at reduced speed with the gate open for installation/maintenance, the enabling switch, setup-mode monitoring, gate protection, and E-stop remain part of the safety logic. Opening the gate does not simply disable safety.

## Evidence 5 — press-specific manual valve diagnostic authority

Source: Rockwell Automation, Studio 5000 metal-form instruction `Maintenance Manual Valve Control (MMVC)`.
URL: https://www.rockwellautomation.com/en-gb/docs/studio-5000-logix-designer/38-00/contents-ditamap/instruction-set/metal-form-instructions/mmvc.html

**DOC-CONFIRMED:** MMVC is specifically intended to drive a press valve manually during maintenance, but only when its permissive conditions are met. The documented permissive set includes a key switch enabled, flywheel stopped, slide at bottom-dead-center, and Safety Enable input true.

**DOC-CONFIRMED:** Rockwell warns that the instruction is for maintenance only, never press operation, and additionally requires a visual check that the slide is physically at BDC and the flywheel is actually stopped before the keyswitch/manual-valve function is enabled.

This is especially valuable curriculum evidence because it separates a diagnostic command path from production authority and combines logic permissives with a physical witness rather than trusting internal state alone.

## Authority model

Professional controlled-energy work can therefore be represented as:

`TASK REQUIRES ENERGY/MOTION`

`-> SPECIAL MODE / AUTHORIZATION SELECTED`

`-> NORMAL PRODUCTION AUTHORITY SUPPRESSED`

`-> SAFETY FUNCTION FOR THE TASK ESTABLISHED`

`-> PHYSICAL PRECONDITIONS VERIFIED`

`-> DELIBERATE HOLD-TO-RUN / ENABLING / MANUAL TEST REQUEST`

`-> ONLY BOUNDED MOTION/ENERGY PERMITTED`

`-> RELEASE / LIMIT VIOLATION / SAFETY DEMAND CAUSES DEFINED SAFE RESPONSE`

`-> PERSON EXITS / TASK COMPLETES`

`-> MODE-SPECIFIC RESET/REQUALIFICATION`

`-> SEPARATE FRESH PRODUCTION START`.

### Durable freezes

**ENERGIZED DIAGNOSTIC REQUIRED != NORMAL PRODUCTION MODE PERMITTED.**

**GUARD OPEN FOR SETUP != SAFETY FUNCTION BYPASSED.**

**MAINTENANCE MODE SELECTED != MOTION AUTHORIZED.**

**ENABLING DEVICE HELD != UNRESTRICTED MOTION AUTHORIZED.** The validated setup safety function can still constrain speed, direction, stop behavior, axes, force, or other task-specific hazards.

**REDUCED SPEED COMMAND != SAFELY LIMITED SPEED PROVED.** Ordinary LinuxCNC velocity limiting is not automatically a safety-rated SLS function.

**INTERNAL BDC/STOPPED BIT TRUE != PHYSICAL BDC/STOPPED WITNESS PROVED.** Rockwell's press example explicitly adds visual physical confirmation before manual valve authority.

**MANUAL VALVE COMMAND PERMITTED != PRODUCTION CYCLE PERMITTED.**

**DIAGNOSTIC TASK COMPLETE != PRODUCTION AUTHORITY RESTORED.** Personnel exit/clearance, safeguard restoration, reset/requalification, and fresh start remain separate steps according to the actual validated architecture.

## OpenPressBrake implications

**INFERENCE:** A future OpenPressBrake energized diagnostic facility should be task-specific, not a generic "maintenance bypass." Examples might eventually include measuring a hydraulic response, jogging an axis for setup, or validating a final element. But each such function needs its own hazard/precondition/authority contract.

Normal LinuxCNC/FPGA can provide the requested diagnostic command, UI, logging, and measurement orchestration. Personnel-safety permission must remain with the independent safety architecture where the task depends on a safety function.

If the only way to test a safety-related hydraulic element is to energize part of the machine, the curriculum should seek a professional procedure defining physical restraints/exclusion, safe operating mode, allowed command, final-element witness, abort behavior, and return-to-service sequence before proposing an OpenPressBrake implementation.

## Human factors

The professional examples solve a practical problem: forcing technicians to choose between an unusable full-isolation state and an informal bypass encourages defeat of safeguards. A deliberately engineered setup/diagnostic mode can make the safer path easier while preserving a safety function appropriate to the task.

This does **not** make every energized service task acceptable. If no validated bounded-energy method exists, the machine remains isolated for maintenance; if a necessary experiment cannot meet a basic minimum safe-to-operate threshold with people exposed, conduct it isolated/remotely with people outside the danger zone.

## UNKNOWN / do not invent

- Which OpenPressBrake diagnostics actually require energized hydraulics or motion.
- Whether the target press can support a validated reduced-speed/reduced-force service mode.
- Required safe speed, force, pressure, stopping distance, axis set, direction, or response time.
- Whether a three-position enabling device is appropriate for a particular press-brake task.
- Exact hydraulic states/permissives for manual valve testing.
- Whether BDC is safe for a specific hydraulic test on the target press.
- Any PL/SIL/category or diagnostic-coverage claim for OpenPressBrake without the required risk assessment and component architecture.

## Next evidence target

Trace a hydraulic press-brake OEM service/commissioning example where energized hydraulic testing is explicitly performed. Capture the physical exclusion/restraint, operating mode, permitted valve/pump action, measurement point, abort behavior, and return-to-service sequence. Prefer an example that tests one redundant final element without a companion path masking it. If that source path is unavailable, rotate to another machine class and compare how controlled-energy setup authority differs rather than fabricating press-specific values.

No simulation is justified by this study; the open questions are architectural and machine-specific and should be closed from authoritative evidence first.
