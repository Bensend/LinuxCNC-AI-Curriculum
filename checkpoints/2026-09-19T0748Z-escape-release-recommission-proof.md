# Safety checkpoint — escape-release recommission proof

Date: 2026-09-19T07:48Z

## Completed

Created `safety-course/ESCAPE_RELEASE_RECOMMISSION_FUNCTION_TEST_BOUNDARY_2026-09-19.md` from current Pilz operating-manual evidence.

New freeze:

`ESCAPE RELEASE RESTORED != STOP ACKNOWLEDGED != ESCAPE FUNCTION RE-PROVED != GUARD CLOSED != GUARD LOCKED != PERSONNEL CLEAR != HAZARDOUS FUNCTION AUTHORIZED != ORDINARY START`

Pilz PSEN ml DHM explicitly requires after escape-release use: restore the release, acknowledge the stop in the controller, and perform a qualified function test using the escape release. This establishes that escape-release use can create a formal recommission/re-proof obligation rather than merely requiring the gate to be reclosed.

Device variants differ in reset behavior; automatic-reset hardware does not imply automatic hazardous-machine restart authority.

No compute was required or consumed.

## Next work

Highest-value accessible-cell continuation: find a complete professional implementation composing `hazard ceased -> unlock -> bodily entry -> escape/restart prevention -> personnel-clear -> guard close/lock -> escape/guard function proof where required -> final-element proof -> safety rearm -> ordinary start`, preferably including a failed-lock or power-cycle recovery path.

Primary hydraulic individual-retention branch remains source-limited per `2026-09-19T0743Z-hydraulic-individual-retention-source-stop.md` and should not be filled with an invented test.
