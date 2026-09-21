# 25E0 — Machine-tool Safe-Limited-Speed Access and Return

Session start: 2026-09-21T23:38:49Z

## Purpose
Close the open machine-tool-oriented supported-exception evidence gap without importing robot-teach semantics into CNC machinery.

## Evidence classes

### DOC-CONFIRMED — Rockwell Kinetix safe-speed access architecture
Rockwell Automation publication 2094-RM001C-EN-P documents **Safe Limited Speed with Door Monitoring and Enabling Switch Monitoring**. The documented access sequence is: request SLS; wait through the SLS monitoring delay; once safe speed is detected, hold the enabling switch in its middle position; only then does the drive unlock the door. The operator continues holding the enabling device while opening the door, entering the hazard area and performing maintenance.

The documented return sequence is also useful: leave while holding enabling; hold enabling until the door is closed and SLS input has been returned to its normal/closed state; perform reset if manual reset is configured; then release enabling. Rockwell warns that SLS selection must be protected against another user changing mode while personnel remain in the machine area.

Source: Rockwell Automation, *Kinetix 6200 and Kinetix 6500 Safe Speed Monitoring Safety Reference Manual*, publication 2094-RM001C-EN-P, May 2013, ch. 7, p.80. Public manufacturer URL: https://literature.rockwellautomation.com/idc/groups/literature/documents/rm/2094-rm001_-en-p.pdf

### DOC-CONFIRMED — Rockwell machine assist/production example
Rockwell Safety Application Example SAFETY-AT025A-EN-P documents a machine with keyed **assist** and **production** modes. In assist mode personnel may access the machine; limited-speed motion is permitted only with an enabling device, while a safety-rated MSR57P monitors motor speed and supplies safety-rated status to the safety controller. In production the gate must be closed/locked for acceleration beyond the configured standstill criterion. The document explicitly leaves the actual safe-speed values to machine risk assessment.

Source: Rockwell Automation, *Using the MSR57 in a Safety Architecture to Monitor Machine Motor Speed*, SAFETY-AT025A-EN-P, March 2010. Public manufacturer URL: https://literature.rockwellautomation.com/idc/groups/literature/documents/at/safety-at025_-en-p.pdf

### DOC-CONFIRMED — Siemens SINUMERIK machine-tool safety functions
Siemens SINUMERIK Safety Integrated documents SLS as safe monitoring of configurable velocity limits, with setup given as an example, plus SSM, SOS, STO, SLP, SBC and cyclic SBT. This is machine-tool-specific evidence that a CNC platform can carry safety-rated motion-monitoring functions distinct from ordinary CNC speed commands.

Source: Siemens, *SINUMERIK 828D Glossary*, May 2023, Safety Integrated extended functions.

## Architecture extracted

A supported machine access/setup exception is not `guard bypassed = true`. The evidence supports a layered state:

`authorized mode selection -> independently monitored reduced motion -> enabling-device condition -> controlled access -> task motion authority -> guarded return sequence -> reset when configured -> normal-mode eligibility`

Normal CNC/LinuxCNC motion commands remain ordinary-control demands. They do not become personnel-safety evidence merely because their numeric speed command is low.

## Hard freezes
- **SLS REQUESTED != SAFE SPEED PROVED.**
- **SAFE SPEED PROVED != DOOR ACCESS AUTHORIZED unless the designed access conditions are also satisfied.**
- **ENABLING DEVICE VALID != ORDINARY MOTION COMMAND.**
- **ORDINARY CNC VELOCITY LIMIT != SAFETY-RATED ACTUAL-SPEED MONITORING.**
- **DOOR CLOSED != PRODUCTION RETURN COMPLETE.**
- **RESET, WHEN REQUIRED, != FRESH CYCLE START.**
- **MACHINE-TOOL SETUP EXCEPTION != ROBOT TEACH MODE merely because both may use an enabling device.**

## Human-factors result
Rockwell's keyed assist/production mode and warning against another user changing mode while a person is inside expose an important practical design obligation: the person performing the task must not depend on a remote operator merely remembering not to restore full-performance mode. Mode ownership/retention is part of the usable safety architecture.

For OpenPressBrake/LinuxCNC teaching, a service workflow that requires defeating a guard because legitimate adjustment cannot otherwise be performed should trigger redesign of the supported exceptional mode. The replacement protection must be explicit and validated; an HMI speed override is not enough.

## UNKNOWN / not imported
- No generic safe speed is imported from these examples.
- No Rockwell reset semantics are asserted for unrelated drives/controllers.
- No universal held-Cycle-Start electrical behavior is inferred.
- No PL/SIL claim is transferred to OpenPressBrake.
- No press-brake hydraulic safe-state or stopping-distance claim is inferred from servo-drive evidence.

## Curriculum consequence
This closes the immediate public-evidence gap for a non-robot machine access/setup architecture. The next high-value branch is proposition-specific revalidation after an exceptional state changes/replaces a physical witness: sensor replacement, brake work, valve work, encoder/configuration change, or temporary simulation/force. `exception ended` must not stand in for re-proving the proposition whose evidence was invalidated.
