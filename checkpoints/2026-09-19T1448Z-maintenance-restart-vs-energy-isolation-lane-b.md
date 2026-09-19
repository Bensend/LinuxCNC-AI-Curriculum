# Checkpoint — Lane B maintenance restart prevention vs energy isolation — 2026-09-19

## Completed

Created `safety-course/MAINTENANCE_RESTART_PREVENTION_VS_ENERGY_ISOLATION_BOUNDARY_STUDY_2026-09-19.md` at commit `8d252147069d2f561f4514b474753ec5049ac10b`.

## Parallel-work check

Immediately before the substantive commit, current `main` ended at `ab9a7b38650d2f66f5e0e8a52fee67437ddfc6a2`; the primary lane's newest substantive work was `2ea1b50705d300754726cb3b9ed541509fcca203`, `PRESS_BRAKE_TOOL_SETUP_MUTING_SAFE_SPEED_AUTHORITY_TRACE_2026-09-19.md`. Lane B used different files and evidence and did not modify the primary setup/muting artifacts or shared `PROGRESS.md`.

## Durable gain

Pilz professional evidence cleanly separates an electronic personnel-retention/restart-prevention architecture from hazardous-energy isolation. Key-in-pocket retains each entrant in a safety-controller list and prevents productive release until all have signed out; large/blind installations may additionally require a blind-spot check. Pilz separately describes LOTO as physical control/isolation of electrical, mechanical, hydraulic and other hazardous energy for repair/maintenance.

Freeze:

`RESTART PREVENTION != HAZARDOUS-ENERGY ISOLATION`

`PERSONNEL RETENTION != ZERO ENERGY`

`SAFE LIST EMPTY != PERSONNEL CLEAR != SAFETY FUNCTION REVALIDATED != PRODUCTION AUTHORITY`

`ORDINARY LINUXCNC/FPGA DISABLE != PERSONNEL-SAFETY AUTHORITY`

An electronic maintenance safeguard may be a valid restart-prevention function in its documented application; that does not universally replace task-specific physical energy isolation.

## Boundaries

No OpenPressBrake retention architecture, isolation points, accumulator/trapped-pressure behavior, discharge time, safe pressure, ram-blocking method, personnel-clear procedure, PL/SIL/category/DC/CCF, or return-to-service sequence was invented. No executable verification was justified and no compute was consumed.

## Precise next work

Seek a professional implementation exposing:

`personnel entry/retention -> safety-side restart prevention -> task-specific physical energy isolation where required -> stored-energy verification -> maintenance -> controlled energy restoration -> retained-person/blind-area clear -> affected safety-function/final-element re-proof -> safety rearm -> separate fresh ordinary production initiation`.

Prefer an abnormal recovery case such as lost credential, incomplete sign-out, power cycle during maintenance, or attempted restart while one entrant remains retained. Keep this independent of the primary setup/muting/safely-monitored-speed lane and the unresolved press-brake holding-valve service proof.