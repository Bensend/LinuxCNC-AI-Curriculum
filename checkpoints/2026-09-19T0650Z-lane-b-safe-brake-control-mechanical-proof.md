# Lane B checkpoint — SBC versus mechanical brake proof

Date: 2026-09-19T06:50Z

## Completed

Created `safety-course/SAFE_BRAKE_CONTROL_MECHANICAL_BRAKE_PROOF_BOUNDARY_STUDY_2026-09-19.md` from Siemens and SEW-EURODRIVE manufacturer evidence.

Primary lane at selection time was working press-brake hydraulic startup-test/final-element masking. Lane B deliberately stayed in the drive/brake domain and did not edit the primary hydraulic artifacts or shared `PROGRESS.md`.

Freeze:

`SBC REQUESTED != BRAKE CONTROL ELECTRICALLY SWITCHED != BRAKE MECHANICALLY APPLIED != BRAKE HOLDS REQUIRED LOAD != LOAD PHYSICALLY RETAINED != BRAKE TEST PASSED != AXIS SAFE FOR PERSONNEL EXPOSURE`

Key evidence:
- Siemens states SBC does not detect mechanical brake defects and directs use of Safe Brake Test.
- Siemens acceptance-test material separately checks SBC wiring/hardware/parameterization/forced checking.
- SEW exposes individual testing of two brakes so the two credited retaining elements are not collapsed into one proof.
- SEW start inhibit is a distinct safety-option state around brake-test/parameterization/replacement recovery.

No OpenPressBrake brake topology, test torque, proof interval, PL/SIL/category/DC, stopping distance, hydraulic behavior, pressure, or service procedure was invented. No executable verification was needed; no compute was consumed.

## Exact next independent work

Find professional drive/gravity-axis evidence exposing:

`protective demand -> STO/SBC -> individual brake command -> physical brake application -> independent mechanical brake test -> physical load/motion witness -> failed-test start inhibit -> service/replacement -> re-test -> safety rearm -> application-specific ordinary motion reauthorization`

Prefer explicit failed mechanical brake-test disposition and post-replacement re-test. Continue to avoid the primary lane's hydraulic press-brake startup-test artifacts unless the primary lane has moved elsewhere and overlap is re-checked first.
