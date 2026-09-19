# Lane B Checkpoint — Area Scanner Rear-Access / Restart Authority — 2026-09-18

## Completed
Created `safety-course/AREA_SCANNER_REAR_ACCESS_RESTART_INTERLOCK_AUTHORITY_STUDY_2026-09-18.md` as an independent safety-curriculum lane.

Primary lane newest durable work at selection time was hydraulic return-to-service physical re-proof (`fcbe4a4...`, checkpoint/log through `57832a74...`). Lane B therefore stayed on protective-device/restart authority and did not modify hydraulic artifacts or shared `PROGRESS.md`.

## Frozen architecture
`PROTECTIVE FIELD CLEAR != HAZARD AREA PERSONNEL CLEAR != RESTART INTERLOCK SATISFIED != RESET ACCEPTED != SAFETY OUTPUT RESTORED != EXTERNAL FINAL ELEMENT PROVED != HAZARDOUS MOTION AUTHORIZED != FRESH ORDINARY START.`

Also preserve:
- warning field != protective field;
- reset != start;
- raw protective-field status != OSSD/restart-interlock state;
- LinuxCNC/HAL/ordinary FPGA diagnostics/permissives do not become personnel-safety authority.

## Evidence gained
SICK source material confirms restart interlock is needed where a person can leave the protective field toward the hazard or cannot be detected throughout the hazard area; reset does not itself start the machine. S300 integration evidence shows that if a safety controller consumes raw protective-field status instead of OSSD status, scanner-local restart interlock does not automatically protect the controller path and must be implemented in the safety controller. microScan3 evidence separately exposes EDM lockout on missing external-device feedback. Pilz independently documents warning/protective field distinction and rear-access protection preventing restart while a person is in a difficult-to-see danger zone.

No machine-specific OpenPressBrake geometry, stopping performance, hydraulic facts, scanner requirement, or PL/SIL/category/DC was asserted.

## Compute
None. No executable verification was justified; no hosted runner used.

## Concurrency check
After the substantive commit, main was re-read. `d66c29bd...` was HEAD directly above `57832a74...`; no intervening primary-lane or overlapping-file change occurred. Shared `PROGRESS.md` was intentionally not edited.

## Precise next Lane-B work
Find a complete professional stationary machine/cell implementation exposing:

`protective-field intrusion -> independent safety evaluator -> safety output -> physical final element -> physical stop witness -> person leaves field but remains in/re-enters retained area -> restart remains inhibited -> personnel-clear/rear-access proof -> deliberate reset -> EDM/final-element proof -> safety rearm -> separate fresh ordinary START`.

Prefer documented scanner/field-set mismatch, failed EDM/contact feedback, power restoration, scanner blockage/misalignment, or an integration where raw field status requires explicit safety-controller restart interlock.
