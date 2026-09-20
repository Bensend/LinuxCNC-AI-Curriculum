# Lane B checkpoint — ESPE muting / override recovery — 2026-09-20

## Completed

Added `safety-course/ESPE_MUTING_OVERRIDE_RECOVERY_AUTHORITY_STUDY_2026-09-20.md`.

Primary lane was independently advancing Cincinnati AUTOFORM counterbalance drift localization/recheck and the post-replacement retaining-function proof gap. Lane B intentionally selected ESPE muting/override recovery and did not touch the primary hydraulic artifacts.

## Durable freeze

`MATERIAL PRESENT != VALID MUTING REQUEST != VALID MUTING SENSOR SEQUENCE != ESPE TEMPORARILY MUTED != MUTING REMAINS VALID != MUTING ENDED != ESPE PROTECTIVE FUNCTION RESTORED`

`MUTING ERROR != OVERRIDE REQUIRED != HAZARDOUS AREA VISUALLY CLEAR != OVERRIDE INTENTIONALLY REQUESTED != OVERRIDE ACTIVE != MATERIAL CLEARED != NORMAL ESPE PROTECTION RESTORED != SAFETY REQUALIFICATION COMPLETE != FRESH ORDINARY PRODUCTION START`

`LINUXCNC/HMI MUTED DISPLAY != SAFETY-EVALUATED MUTING STATE`

`OVERRIDE != GENERIC SAFEGUARD BYPASS`

## Evidence gained

- DOC-CONFIRMED: Pilz defines muting as automatic temporary ESPE suspension for material transport, using sensor arrangements intended to distinguish material transit and requiring a defined sequence/concurrence.
- DOC-CONFIRMED: SICK deTec4 only permits override from defined abnormal muting conditions, monitors/bounds override and limits consecutive overrides before lockout.
- DOC-CONFIRMED: SICK Flexi Classic requires override control placement with clear view of the entire hazardous area and requires muting components/sensors checked; repeated override demand triggers inspection/verification.
- DOC-CONFIRMED: SICK Flexi Compact explicitly requires visual hazardous-area inspection, no personnel present, and prevention of access while override is used.
- INFERENCE: normal LinuxCNC/HAL/FPGA conveyor/material control and diagnostics may participate operationally but cannot substitute for the independent safety evaluator deciding when ESPE suspension is valid.

No OpenPressBrake-specific muting need, geometry, sensor sequence/timing, safety performance, final-element topology, stopping distance or reset sequence was invented.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted runner compute used.

## Precise next work

Find a complete professional muting implementation/commissioning example with wiring/configuration and a tested abnormal path:

`material approach -> muting sensor geometry -> safety sequence/concurrence evaluation -> ESPE suspension -> transit -> muting termination -> ESPE restoration`

plus

`wrong sequence/timing/stuck sensor -> ESPE interrupted -> override required -> operator full-area visibility/personnel-clear -> deliberate bounded override -> material removal -> normal protection restored -> repeat-override inspection/lockout -> safety requalification -> stale ordinary-command challenge -> separate fresh production start`.

Prefer an OEM/system commissioning or validation procedure showing a failed muting sequence and recovery test. Avoid redundant generic muting definitions.