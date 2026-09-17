# Presence-Sensing Reset / Restart Professional Trace — 2026-09-17

Session start recorded before substantive curriculum write: **2026-09-17T21:38:39Z**.

## Question

What must be proven between a protective-field demand and renewed hazardous motion when a person can enter or remain in a safeguarded space?

This trace follows manufacturer evidence far enough to separate field clearance, safety reset, ordinary restart, presence/stand-behind risk, and physical motion. It does **not** infer undocumented final-element hardware.

## Evidence

### SICK S300 safety laser scanner — reset placement and two-stage restart

**DOC-CONFIRMED** — SICK S300 operating instructions (8010948/ZD09/2024-09-12) require a restart/reset control outside the hazardous area, inaccessible from inside it, and positioned so the operator has a full view of the hazardous area. With internal restart interlock enabled, reset with the protective field clear returns the scanner OSSDs to ON; if an external machine restart interlock is also present, the machine still does not restart until the machine-controller restart control is operated.

**DOC-CONFIRMED** — the same manual labels universal I/O as non-safe and explicitly says it is unsuitable for safety-relevant functions.

Source: SICK, *S300 Safety Laser Scanner Operating Instructions*, 8010948/ZD09/2024-09-12, sections 7.10–7.11.

### SICK sBot Speed — physical challenge, retained standstill, manual reset, manual robot restart

**DOC-CONFIRMED** — SICK's sBot Speed commissioning checklist physically challenges warning and protective fields. Protective-field infringement must stop the robot. Releasing both fields does not itself restart the robot: it remains stopped until the fields are free, the safety system is manually reset, and a manual restart is executed on the robot.

**DOC-CONFIRMED** — for the documented automatic-restart case, SICK separately requires that it not be possible to walk behind the scanner protective field. This makes stand-behind/presence geometry a prerequisite, not a software preference.

Source: SICK, *sBot Speed Operating Instructions*, 8022412/1LE5/2023-10-12, commissioning checklist and automatic-restart requirements.

### Pilz — large/no-overall-view areas

**DOC-CONFIRMED** — Pilz's Key-in-pocket access-management architecture records personnel entering a protected plant and requires personnel to sign out before productive mode can be enabled. Pilz also describes an additional blind-spot check for large plants without an overall view before restart.

Source: Pilz, *Access management for your plant and machinery*, current manufacturer application guidance accessed 2026-09-17.

## Frozen proof chain

`PROTECTIVE DEMAND`
→ `HAZARDOUS MOTION STOPS`
→ `PROTECTIVE FIELD / GUARD BECOMES CLEAR`
→ `PRESENCE / STAND-BEHIND CONDITION SATISFIED`
→ `AUTHORIZED RESET FROM A VALID LOCATION`
→ `SAFETY OUTPUT AUTHORITY MAY RETURN`
→ `SEPARATE ORDINARY START / REARM`
→ `PHYSICAL MOTION`

The following inequalities are curriculum requirements:

`FIELD CLEAR != ZONE CLEAR`

`ZONE CLEAR != RESET`

`RESET != START`

`SAFETY OUTPUT ON != ORDINARY COMMAND FRESH`

`ORDINARY START != PROOF THAT NO PERSON REMAINS IN AN UNSENSED SPACE`

## Failure-path table

| Failure / misuse | What can look normal | Why restart is unsafe or unproven | Required design response |
|---|---|---|---|
| Person walks behind a light curtain/scanner field | field clears after entry | sensor no longer observes the person | prevent stand-behind by geometry or add suitable presence/restart-prevention architecture |
| Reset button reachable from inside hazard | field/guard clear | trapped person can reset without clearing zone | place reset outside and prevent operation from inside |
| Reset station has blind area | reset is deliberate | operator cannot establish zone clearance | reposition station, remove blind spot, or add a validated blind-spot/presence procedure/system |
| HMI offers remote reset | HMI shows all green | camera/network/HMI state may not establish physical clearance | do not treat ordinary remote HMI as sole personnel-safety reset authority |
| Protective device self-resets | OSSD returns ON | machine may receive authority while person remains in accessible zone | use restart interlock where risk assessment requires it; do not infer automatic restart suitability |
| LinuxCNC START bit remained TRUE through safety trip | safety system later resets | stale ordinary command can be mistaken for new intent | require fresh ordinary rearm/start semantics after safety recovery |
| FPGA watchdog recovered | outputs become available | watchdog recovery proves controller freshness, not zone clearance | keep FPGA recovery separate from safety reset and start |
| Multiple access points share one reset | reset station sees only one area | unseen entrant may remain in another zone | validate reset span/visibility or use zone-specific/personnel-presence architecture |
| Maintenance person carries key/token in protected zone | gate can physically close | ordinary gate state alone misses occupied zone | retained-person/key-in-pocket architecture can inhibit productive enable until all personnel sign out |

## OpenPressBrake transfer

**INFERENCE** — LinuxCNC/HAL and the normal FPGA may display protective-device, reset-required and safety-permissive status, but they must not become the sole authority deciding that a person is absent from the press-brake hazard zone.

**INFERENCE** — if the installed press brake permits a person to pass beyond a front protective field or access rear/side areas, simple `field clear -> reset -> run` logic is inadequate until stand-behind and visibility are resolved.

**UNKNOWN** — installed OpenPressBrake front/rear/side safeguarding geometry, whether a person can stand behind a protective field, reset-station locations and sight lines, rear/side access interlocks, presence-sensing coverage, multi-zone reset span, maintenance-person retention method, and exact safety final elements.

These UNKNOWN items are commissioning/design inputs, not values to invent in the curriculum.

## Practical human-factors rule

A reset architecture that requires an operator to perform an awkward walk, defeat a guard to see the zone, rely on a distant HMI, or repeatedly bypass a nuisance interlock is badly designed even if the schematic can be made logically correct. Put the correct reset/inspection action where it is easy to perform correctly. For large or occluded zones, add a deliberate occupancy-clearing mechanism rather than teaching operators to assume the area is empty.

## Minimum-safe-to-operate consequence

If a person can enter a hazard zone and become invisible to the credited safeguard, and the machine has no validated method preventing restart with that person present, the machine should **not** be operated with people exposed to that hazard. Experimental operation must keep people outside the danger zone / use isolation or remote operation appropriate to the experiment until the restart-prevention gap is closed.

## Next evidence branch

Find a complete machine/cell implementation exposing presence/restart prevention **and** final-element re-enable, or trace a key-in-pocket / trapped-person implementation into its safety-controller logic and physical enable path. Preserve manufacturer-specific PL/SIL/timing values as source facts only; do not transfer them to OpenPressBrake without design evidence.