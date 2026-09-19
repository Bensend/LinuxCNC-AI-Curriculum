# Lane B checkpoint — E-stop span of control / reset / restart authority

Date: 2026-09-19

## Durable result

Added `safety-course/EMERGENCY_STOP_SPAN_OF_CONTROL_RESET_RESTART_AUTHORITY_STUDY_2026-09-19.md`.

Primary lane was re-read before selection and immediately before the substantive write. Its newest durable work remains press-brake post-replacement hydraulic test/restraint monitoring; no overlapping file or evidence package changed during this Lane-B write.

Freeze:

**E-STOP PRESSED != ALL ENERGY ISOLATED != STORED ENERGY CONTROLLED != SAFE TO SERVICE.**

**E-STOP DEVICE RELEASED != SAFETY RESET COMPLETE != FINAL ELEMENT PROVED != HAZARD AREA CLEAR != PRODUCTION AUTHORITY.**

**SAFETY RESET ACCEPTED != ORDINARY START.**

**REMOTE HMI ACKNOWLEDGEMENT != INTENTIONAL RESET AT THE DEVICE THAT INITIATED THE E-STOP COMMAND.**

## Evidence status

DOC-CONFIRMED from current Pilz ISO 13850 guidance: E-stop is complementary protection, need not remove all machine power, device reset is intentional/local at the initiating device, and reset must not itself restart the machine.

DOC-CONFIRMED independently from Rockwell GuardLogix ESTOP documentation: dual-channel state, manual circuit-reset transition, held-reset detection, disagreement faulting, and warning that automatic reset needs other means to prevent unintended start.

TEST-CONFIRMED: none. OpenPressBrake machine-specific E-stop topology and physical response remain UNKNOWN.

## No-compute decision

No executable verification was justified. The remaining questions are physical machine/architecture facts, so no GitHub Actions compute was used.

## Exact next Lane-B work

Trace a professional multi-zone or multi-machine implementation exposing:

`specific E-stop device -> documented span of control -> independent safety evaluator -> actual final elements -> physical stop/safe-state witness -> local release/reset of initiating device -> area-clear/restart interlock where required -> safety rearm -> separate fresh ordinary START`.

Prefer a commissioning case that proves one E-stop does not accidentally claim the wrong zone, or that stale/held ordinary START cannot become motion on reset. Keep OpenPressBrake zone boundaries, stop category, hydraulic reaction, stopping performance, reset locations and physical-safe-state criteria UNKNOWN until directly documented or tested.