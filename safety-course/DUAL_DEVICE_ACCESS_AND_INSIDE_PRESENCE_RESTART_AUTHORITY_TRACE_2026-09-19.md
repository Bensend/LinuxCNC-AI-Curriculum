# Dual-Device Access + Inside-Presence Restart Authority Trace — 2026-09-19

## Why this continuation exists
The preceding Lane-B study closed a professional scanner -> safety evaluator -> contactor -> motor-power-removal -> physical-stop-validation -> fault/recovery -> separate-Start chain, but exposed a rear-access gap: an entrance/access field becoming clear is not proof that a person has left the hazard area.

A second authoritative implementation was therefore sought in the same session rather than ending at that information boundary.

## Authoritative implementation
SICK S200 operating instructions, official current-hosted PDF, point-of-operation guarding example:
https://www.sick.com/media/docs/8/58/858/Operating_instructions_S200_Safety_Laser_Scanner_en_IM0018858.PDF

SICK explicitly depicts a fenced machine/system with two distinct protective roles:
1. a light curtain at the access/opening provides the primary protective function that stops dangerous movement;
2. an S200 safety laser scanner monitors the interior/hazard area and prevents starting/restarting while a person/object remains in its protective field.

SICK specifically calls out interiors that are difficult or impossible to see from outside. In this example the scanner is **not** the stop-triggering access device; it is the restart-prevention presence device.

Pilz current area-monitoring guidance independently describes the same architectural idea: protection against encroachment from behind can supplement a safety gate/light grid at the entrance; a 2D safety laser scanner detects a person inside the danger zone and prevents hazardous movement from restarting while anyone remains in the protected field.

Pilz source:
https://www.pilz.com/en-US/products/applications/area-guarding/area-monitoring

## Architecture lesson
This closes an important conceptual gap with positive professional evidence:

`ACCESS PROTECTIVE DEVICE -> STOP DEMAND`

and separately

`INSIDE-AREA PRESENCE DEVICE -> RESTART INHIBIT`

are legitimate distinct safety roles.

Freeze:

**ENTRANCE FIELD CLEAR != INSIDE AREA CLEAR.**

**ACCESS DEVICE RESTORED != RESTART-PREVENTION DEVICE CLEAR.**

**HAZARDOUS MOTION STOPPED != PERSONNEL HAVE EXITED.**

**INSIDE PRESENCE DETECTED -> RESTART AUTHORITY REMAINS WITHHELD.**

This is stronger than relying only on an operator remembering that someone entered, and it is directly aligned with the curriculum's human-factors rule that the safer architecture should be easier to use correctly than to bypass.

## Relationship to the Rockwell SafeZone complete-stop example
The two professional examples establish complementary propositions without pretending to be one identical machine:

- Rockwell SAFETY-AT137 establishes a complete access scanner -> independent safety relay -> redundant contactors -> motor power removal -> physical stopping validation -> final-element feedback/fault retention -> reset -> separate Start chain.
- SICK S200 establishes that a separate inside-area scanner can have the specific safety role of **preventing restart** while a person remains in a hard-to-see machine interior, while another protective device performs the initial stop function.

**INFERENCE:** a robust accessible-cell design can deliberately separate `stop on entry` from `prevent restart while occupied`, then require both functions to be satisfied before safety rearm. The exact implementation must be validated for the real machine.

## Commissioning / adversarial validation pattern
For any design that uses this two-role pattern, validate the propositions separately:

1. Person crosses the access protective device while hazardous motion exists -> independent safety function commands the required stop reaction.
2. Verify physical final-element state and actual hazard cessation using evidence appropriate to the machine; do not infer stop solely from the access sensor bit.
3. Person moves beyond the entrance device into the machine interior -> entrance device may become clear, but restart remains inhibited because the inside-area presence device remains occupied.
4. Issue ordinary Start while inside-area presence remains -> hazardous motion remains inhibited.
5. Clear only the inside-area detector while entrance device is still violated -> do not infer complete restart authority from one clear device.
6. Challenge inside-area scanner obstruction, misalignment, field-selection error, wiring fault or diagnostic fault -> verify the actual safety design fails safe rather than silently treating diagnostic loss as `area clear`.
7. After both access and inside-area safeguarding conditions are valid, perform the required deliberate reset/rearm procedure.
8. Verify reset/rearm itself does not command hazardous motion.
9. Require a separate fresh ordinary Start after safety authority is restored.
10. Hold an ordinary Start-like request throughout the interruption -> verify it cannot become a fresh start merely because the safety conditions later become valid.

## Human-factors / minimum-operate consequence
Where a person can bodily enter and disappear from the entrance protective field, a design that relies only on that entrance field becoming clear is not sufficient personnel-clear evidence. Positive inside-area presence detection, trapped-key/personnel-retention, or another validated safety-side method should be considered according to the actual hazard and geometry.

If a required occupied-area condition cannot be reliably detected or otherwise retained by the safety architecture, do not operate with people exposed to the hazard. Experimental operation must be isolated/remote with people outside the danger zone and residual risk explicit.

## LinuxCNC/OpenPressBrake boundary
Ordinary LinuxCNC/HAL/FPGA may consume and display states such as `access device clear`, `inside presence clear`, `safety ready`, or fault diagnostics. It must not collapse those distinct propositions into an ordinary software Boolean that becomes the sole personnel-safety authority.

A useful ordinary-control interface can expose them separately so troubleshooting is easy without transferring safety authority:
- access protective-device status;
- inside-area/restart-prevention status;
- safety reset/rearm required;
- final-element feedback valid;
- safety fault/lockout;
- safety permission to ordinary control.

## Evidence classification
- SICK light curtain provides primary stop function in the depicted example: **SOURCE-CONFIRMED**.
- SICK inside-area scanner prevents starting/restarting while presence remains: **SOURCE-CONFIRMED**.
- Application is specifically useful where machine interiors are difficult/impossible to see from outside: **SOURCE-CONFIRMED**.
- Pilz independently documents entrance safeguarding plus rear-access area monitoring that prevents restart while a person remains in the protected field: **SOURCE-CONFIRMED**.
- Combining this role separation with the exact Rockwell AT137 contactor architecture on one machine: **INFERENCE**, not claimed as a manufacturer-supplied combined system.
- OpenPressBrake needs a scanner, light curtain, or this exact arrangement: **UNKNOWN**.
- Required field geometry, reset location, stop time/distance, hydraulic reaction, PL/SIL/category/DC and diagnostic coverage: **UNKNOWN**.

## Next evidence target
The remaining Lane-B target is no longer merely proof that inside-area detection exists. Seek a complete professional implementation exposing the **joined** chain on one machine/cell:

`entry device demand -> physical hazard stop -> inside-area presence remains after entrance clears -> restart inhibit -> inside-area clear/personnel-clear proof -> deliberate reset -> final-element proof -> safety rearm -> separate fresh ordinary Start`

Highest-value additions are a documented inside-area sensor fault/blocked field, failed final-element feedback, power restoration, or a personnel-clear mechanism that cannot be defeated simply by stepping around the active field.

## Compute
No simulation/build/synthesis/benchmark/test-suite compute was justified. No GitHub-hosted or self-hosted runner compute was used.
