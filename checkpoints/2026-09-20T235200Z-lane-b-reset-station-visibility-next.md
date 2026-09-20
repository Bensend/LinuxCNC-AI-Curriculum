# 4000 safety checkpoint — Lane B reset-station visibility and blind-area authority

UTC checkpoint: 2026-09-20T23:52:00Z

## Durable advance

Added `safety-course/RESET_STATION_VISIBILITY_BLIND_AREA_AND_RESTART_AUTHORITY_STUDY_2026-09-20.md`.

SICK and Rockwell manufacturer guidance independently requires reset/restart controls used for personnel-clear acknowledgement to be outside the hazardous area and positioned so the operator can view the hazardous area. SICK further separates protective-device reset from the external machine-controller restart action. Rockwell says supplemental safeguarding is needed where the entire accessible hazardous area cannot be viewed. Pilz independently provides a blind-spot-check/personnel-list pattern for areas without overall visibility.

## Frozen distinctions

- PROTECTIVE FIELD CLEAR != HAZARDOUS AREA PERSONNEL-CLEAR.
- RESET CONTROL ACCESSIBLE != RESET CONTROL SAFELY LOCATED.
- RESET ACCEPTED / OSSD ON != MACHINE RESTART AUTHORIZED.
- PARTIAL VIEW OF THE HAZARD AREA != ACCEPTABLE FULL-VIEW RESET BASIS.
- RESET CIRCUIT UNCHANGED != RESET-STATION VISIBILITY EVIDENCE UNCHANGED when physical layout changes can create blind areas.

## Parallel-lane reconciliation

Before selection, current main and the newest primary checkpoint were re-read. The primary lane is advancing change-impact/partial revalidation and seeking machine-level hydraulic/mechanical or safeguard-geometry evidence. Lane B deliberately selected a different evidence package: human reset-station location, visibility, blind-area disposition, and reset-versus-restart authority. No primary module or evidence file was modified.

Main was re-read immediately after the Lane-B study commit. No intervening primary commit or overlapping file change appeared; no reconciliation rewrite was required.

## OpenPressBrake boundary

No OpenPressBrake reset-station location, cell geometry, personnel-clear technology, PL/SIL/category/DC/CCF, stopping performance, hydraulic threshold/truth table, or safeguard distance was inferred. Those remain UNKNOWN until actual machine design/risk assessment/validation establishes them.

LinuxCNC/HAL/ordinary FPGA/HMI may display status and enforce ordinary command freshness, but this study does not establish any ordinary software, camera, remote HMI, or network command as personnel-clear safety authority.

## Exact next Lane-B work

Seek a complete OEM/manufacturer commissioning sequence for an accessible high-energy machine or cell demonstrating:

`person deliberately retained in blind/stand-behind area -> reset/restart inhibited -> blind-area/personnel-clear mechanism completed -> reset accepted -> stale START/JOG remains ineffective -> separate fresh production START -> actual final-element/machine response`.

Prefer deliberate challenge of the blind-area mechanism or presence-detection/restart-inhibit path. If public authoritative evidence stops at generic reset-location guidance, mark this sub-branch source-limited and rotate rather than inventing a clear-zone procedure.

## Compute

No executable verification was genuinely needed. No GitHub-hosted runner was used and no hosted Actions minutes were consumed. The self-hosted `[self-hosted, openpressbrake]` runner was therefore not invoked.