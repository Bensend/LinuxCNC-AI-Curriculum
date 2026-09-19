# Safety checkpoint — dual-brake unmasked physical proof

Date: 2026-09-19T07:38Z

## Completed

Created `safety-course/DUAL_BRAKE_UNMASKED_LOAD_PROOF_AND_RECOVERY_TRACE_2026-09-19.md` from current SEW-EURODRIVE and Siemens manufacturer evidence.

Freeze:

`SBC COMMAND/OUTPUT STATE != BRAKE MECHANICALLY APPLIED != BRAKE HOLDS MACHINE LOAD != MOTION WITNESS VALID != INDIVIDUAL BRAKE TEST PASS != ALL REQUIRED BRAKES TESTED/PASSED != START INHIBIT CLEARED != APPLICATION MOTION AUTHORITY`

SEW provides the important unmasked physical proof pattern: for two brakes, test each separately; during the passive load test STO removes motor torque, the machine's existing load torque loads the brake under test, actual movement is monitored, and the companion brake is released. The sequence is repeated for the other brake. This directly demonstrates that a companion retaining element must not be allowed to mask the tested element.

This is a cross-machine comparison architecture, not permission to infer the same hydraulic topology for OpenPressBrake.

No compute was required or consumed.

## Exact next work

Return to the primary hydraulic lane and seek authoritative press-brake/manifold/OEM evidence for an analogous unmasked retaining proof after a holding/safety-valve fault or replacement. Specifically seek `support/isolate/depressurize -> replace/service element -> remove companion masking path or otherwise prove tested element physically -> physical ram/load witness -> dynamic stopping re-proof -> safety rearm -> press-brake-specific production initiation`.

If authoritative public evidence still cannot expose an individual hydraulic retaining proof, preserve that UNKNOWN and rotate to another high-value safety branch rather than inventing a hydraulic test.
