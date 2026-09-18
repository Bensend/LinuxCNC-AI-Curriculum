# Safety checkpoint — hydraulic press-brake physical stop proof and periodic validation

Date: 2026-09-18

## Completed

Created `safety-course/HYDRAULIC_PRESS_BRAKE_STOP_PROOF_PERIODIC_VALIDATION_RESCUE_BOUNDARY_TRACE_2026-09-18.md` and updated `PROGRESS.md`.

## Governance/current-state reconciliation

START_HERE and current governance were re-read. Repository state confirms 1000, 2000 and 3000 are closed and the 4000 safety course is primary. The newest parallel Lane-B checkpoint concerned muting/material-flow override authority, so this run advanced the independent primary hydraulic physical-stop evidence gap rather than duplicating Lane B.

## Frozen result

`PROTECTIVE-DEVICE DEMAND != SAFETY OUTPUT CHANGED != HYDRAULIC FINAL ELEMENT REACHED SAFE POSITION != RAM STOPPED/RETRACTED AS REQUIRED != MEASURED STOP PERFORMANCE VALID != ACCESS SAFE`.

`INITIAL STOP-TIME ACCEPTANCE != LIFETIME STOP-PERFORMANCE PROOF`.

`PUMP OFF / MOTOR STO != STORED HYDRAULIC ENERGY ABSENT != GRAVITY LOAD RESTRAINED`.

`RESCUE MOTION AUTHORITY != RESET/REARM AUTHORITY != PRODUCTION CYCLE AUTHORITY`.

A real BAYKAL APH hydraulic press-brake manual exposes protective-device stop/retract behavior, hydraulic safety/directional final elements, periodic stop-time measurement, finished-machine functional checks, and a distinct entrapment-rescue motion. Current HAWE documentation independently keeps reliable beam holding, switching/overtravel behavior, function monitoring and temporarily stored hydraulic energy as physical hydraulic concerns.

## Evidence limits

The BAYKAL manual is an older machine-specific source. Its numerical stop time/safety distance, valve designations and rescue implementation are not adopted as OpenPressBrake values. Complete diagnostic coverage, valve-spool feedback, redundant topology, failed-retaining-element disposition, post-service re-proof sequence and PL/SIL/category remain UNKNOWN.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Find an OEM/manufacturer implementation exposing `protective stop demand -> redundant hydraulic final elements -> valve/final-element feedback -> direct ram/pressure/motion witness -> failed disagreement latch/inhibit -> physical load-safe disposition -> repair -> required stop/restraint re-proof -> safety rearm -> separate fresh production initiation`.

Prefer a documented injected fault or commissioning/service procedure. Do not invent degraded production after one failed retaining element.
