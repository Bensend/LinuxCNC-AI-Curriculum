# Lane B Checkpoint — Access Stop + Inside-Presence Restart Authority — 2026-09-19

## Session result
Continued from the newest Lane-B area-scanner checkpoint and completed two evidence-gain steps:

1. `safety-course/SAFEZONE_CONTACTOR_STOP_VALIDATION_REAR_ACCESS_GAP_TRACE_2026-09-19.md`
   - Rockwell SAFETY-AT137 closes a professional scanner -> independent safety relay -> redundant contactors -> motor power removal -> physical stop validation -> contactor-feedback fault -> fault-clear/reset -> separate external Start chain.
   - It also exposes the boundary that this complete stop chain does not by itself prove a retained/blind area is personnel-clear.

2. `safety-course/DUAL_DEVICE_ACCESS_AND_INSIDE_PRESENCE_RESTART_AUTHORITY_TRACE_2026-09-19.md`
   - SICK S200 provides positive professional evidence for distinct safety roles: an entrance light curtain performs the primary stop function while an inside-area safety scanner prevents starting/restarting while presence remains in a difficult-to-see interior.
   - Pilz independently documents the same entrance-safeguarding + rear-access area-monitoring pattern.

## Frozen architecture
`ACCESS DEVICE CLEAR != INSIDE AREA CLEAR != PERSONNEL CLEAR != RESTART AUTHORITY.`

`SAFETY OUTPUT OFF != FINAL ELEMENT SAFE != PHYSICAL HAZARD STOPPED != STOP PERFORMANCE VALID.`

`FAULT REMOVED != FAULT LATCH CLEARED != SAFETY RESET/REARM != FRESH ORDINARY START.`

`STOP ON ENTRY` and `PREVENT RESTART WHILE OCCUPIED` may be distinct safety functions and should be validated as distinct propositions.

## Boundary
Do not infer that OpenPressBrake needs this exact scanner/light-curtain/contactor arrangement. Machine geometry, hydraulic reaction, stop performance, separation distance, reset location, PL/SIL/category/DC and personnel-clear method remain machine-specific UNKNOWNs until established by risk assessment and validation.

LinuxCNC/HAL/ordinary FPGA may expose diagnostics and consume safety permission but must not become sole personnel-retention/restart-prevention authority.

## Compute
None. No executable question justified compute. No GitHub-hosted runner or self-hosted runner compute used.

## Precise next Lane-B work
Find a **single complete professional machine/cell implementation** exposing the joined chain:

`entry protective-device demand -> physical hazard stop witness -> person moves beyond entry field and remains inside -> inside-area/personnel-retention mechanism keeps restart inhibited -> personnel-clear/inside-area clear proof -> deliberate reset -> final-element feedback/proof -> safety rearm -> separate fresh ordinary Start`.

Prefer an implementation with one adversarial case: inside-area scanner blockage/misalignment/field-selection fault, failed final-element feedback, power restoration, or a retained-person mechanism that cannot be defeated merely by stepping around the active field.

If that joined implementation reaches an information-gain stop, rotate to the primary hydraulic lane's documented open target rather than manufacturing redundant scanner research.
