# Safety Checkpoint — Presence Monitoring / Automatic-Restart Authority Boundary — 2026-09-19

## Completed

Created `safety-course/PRESENCE_MONITORING_AUTOMATIC_RESTART_AUTHORITY_BOUNDARY_2026-09-19.md`.

## Evidence gained

Pilz's real Weidplas robot/injection-moulding cell joins gate/light-curtain safeguarding with three PSENradar sensors and PNOZmulti 2 in-cell monitoring. Gate opening/access causes a robot safe stop; radar then monitors the cell interior; safeguards/robot are reactivated only after no movement is detected for a defined period. Pilz states that the robot then automatically travels to its start position and production can continue.

SICK's 2025 sBot Speed instructions provide a useful opposite architecture: its cited manual-restart validation keeps the robot stopped until fields are clear, safety is manually reset, and the robot is manually restarted. SICK separately constrains automatic-restart use to applications where the protective field cannot be walked behind, no people can remain in the hazardous area during/after reset, and hazardous-area entry requires crossing the protective field.

## Curriculum correction

Preserve:

`ACCESS DEVICE CLEAR != INSIDE AREA CLEAR != PERSONNEL CLEAR != RESTART AUTHORITY.`

Replace any universal cross-machine reading of `safety rearm -> always separate manual ordinary START` with:

`PROTECTIVE DEVICE CLEAR != RESTART AUTHORITY. RESTART AUTHORITY MUST COME FROM THE MACHINE'S VALIDATED SAFETY-FUNCTION DESIGN.`

Professional machine designs may legitimately use either manual reset/restart or a risk-assessed automatic-restart/continuation architecture. Automatic restart in a validated robot cell is not transferable evidence for a press brake.

For OpenPressBrake, continue to require conservative separation of safety reset/rearm and fresh production initiation unless authoritative press-brake-specific evidence and the machine risk assessment establish otherwise. LinuxCNC/HAL/ordinary FPGA remains outside personnel-clear authority.

## Compute

None. This question was resolved from authoritative manufacturer evidence; no simulation/build/test was justified and no GitHub-hosted Actions minutes were used.

## Exact next work

Primary hydraulic lane remains highest priority: find OEM/service evidence exposing `individual monitored hydraulic valve disagreement -> physical ram/load-safe disposition -> fault retention -> repair/replacement -> required valve/restraint/stop-performance re-proof -> safety reset/rearm -> press-brake-specific production initiation`.

Accessible-cell lane: seek a complete implementation exposing the safety output/final-element/standstill side together with retained-person presence proof and the documented risk-assessment condition selecting manual versus automatic restart. Do not impose a universal restart pattern across machine classes.
