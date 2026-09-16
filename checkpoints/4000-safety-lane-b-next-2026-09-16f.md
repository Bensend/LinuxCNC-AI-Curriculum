# 4000 Safety Lane B Checkpoint — 2026-09-16f

## Completed

Added `safety-course/THREE_POSITION_ENABLING_DEVICE_SETUP_MAINTENANCE.md`.

Manufacturer evidence from Pilz PITenable and Rockwell 440J/MobileView/Guardmaster/application documentation now freezes the three-position enabling-device teaching contract: RELEASED=off, MIDDLE=conditional enabling permission, FULLY_DEPRESSED=off/protective response; full-squeeze-to-release traversal must not create a valid enable; pre-held enable at startup/mode transition is a foreseeable-defeat condition; enabling permission remains separate from a deliberate jog/motion request.

Frozen safety boundary: LinuxCNC/ordinary FPGA may request setup behavior and report state but must not become sole personnel-safety authority for guard suspension, enabling-device validity or safety rearm. The enabling device is also not a substitute for E-stop.

Human-factors review now explicitly treats taping/clamping, awkward grip, dropped-device behavior and workflows that predictably encourage bypass as design defects to address.

No compute consumed; authoritative documentation and engineering reasoning answered the current question.

## Next independent work

Study **whole-body access / trapped-person restart prevention** for fenced cells and large guarded spaces. Trace authoritative manufacturer architecture for presence sensing, escape/release, trapped-key/personnel-key approaches where applicable, reset location/visibility, and prevention of restart while a person can remain inside after the access guard is reclosed.

Keep `guard_closed`, `space_clear`, `personnel_key/accounted`, `reset`, `rearm`, and ordinary `start` as separate evidence/states. Do not invent detection coverage, safety distance, scanner field geometry, response time or required PL/SIL for a machine without design-specific evidence.
