# Lane B checkpoint — rear-access presence sensing / restart interlock

Date: 2026-09-20T10:48Z

Completed independent safety-course work without overlapping the primary lane's final-element EDM/STO/hydraulic physical-witness package.

Durable artifact:
- `safety-course/PRESENCE_SENSING_REAR_ACCESS_RESTART_INTERLOCK_AUTHORITY_STUDY_2026-09-20.md`

Key freeze:
- `ACCESS FIELD CLEAR != HAZARD AREA PERSONNEL-CLEAR != RESTART INTERLOCK SATISFIED`
- `PROTECTIVE DEVICE RESET != SAFETY REQUALIFIED != MACHINE RESTART AUTHORIZED != FRESH ORDINARY START`
- `HAL SCANNER_CLEAR = TRUE != PERSONNEL CLEAR`

Evidence status:
- SICK restart-interlock/stand-behind/reset-location behavior: DOC-CONFIRMED.
- Pilz rear-access/current-location application guidance: SOURCE-CONFIRMED.
- OpenPressBrake sensing technology, geometry, safety distance, stopping performance, reset location, PL/SIL/category and final-element behavior: UNKNOWN; do not infer.

No executable verification was justified. No GitHub-hosted compute was used.

Precise next Lane-B work: find a complete professional accessible-cell presence-sensing commissioning/validation example showing protective-field geometry or blind-area analysis, deliberate stand-behind occupancy, reset location/visibility, stale-command challenge, actual safety-output/final-element response, and a separate fresh restart. Prefer an OEM/manufacturer validation procedure with diagrams and explicit test cases; do not return to generic restart definitions unless they materially close a physical validation gap.