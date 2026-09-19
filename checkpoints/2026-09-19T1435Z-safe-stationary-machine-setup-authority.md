# Checkpoint — setup-mode enabling + monitored-speed authority — 2026-09-19

## Completed

Created `safety-course/SAFE_STATIONARY_MACHINE_SETUP_MODE_COMPLETE_AUTHORITY_TRACE_2026-09-19.md` at commit `10b487ba2ef411120ae38f5c3aeb0942f35c637f`.

## Durable gain

SICK's professional Safe Stationary Machine example closes a large part of the Lane-B setup chain in one implementation: normal access is tied to detected standstill and guard locking; setup/maintenance uses reduced speed plus a three-position enabling device; enabling position 2 is not itself START; an additional control switch requests motion; actual speed is monitored by Drive Monitor FX3-MOC0; overspeed causes safety-side drive switch-off; positions 1/3 command stop.

Freeze:

`MODE SELECTED != SAFEGUARD SUSPENSION AUTHORIZED != SUBSTITUTE SAFETY FUNCTIONS VALID != ENABLING DEVICE VALID != SEPARATE MOTION REQUEST PRESENT != ACTUAL MOTION WITHIN SAFETY LIMIT != PHYSICAL STOP ON LOSS OF AUTHORITY != NORMAL SAFEGUARD RESTORED != PERSONNEL CLEAR != PRODUCTION AUTHORITY`.

Also `COMMANDED REDUCED SPEED != SAFELY MONITORED REDUCED SPEED` and `ENABLING DEVICE MID-POSITION != MACHINE START`.

SICK's machinery guide additionally establishes that multiple people inside while safeguards are disabled require an enabling device for each person, concurrently operated before hazardous functions can be initiated, and that return-to-normal-mode control should be outside the hazard zone so personnel-clear can be checked.

## Boundaries

No OpenPressBrake-specific setup speed/force, hydraulic truth table, stop distance/time, PL/SIL/category/DC/CCF, reset policy, or production-restart sequence was invented. This is a transferable professional architecture, not a press-brake design prescription.

No executable verification was justified and no compute was consumed.

## Precise next work

Seek a professional implementation that closes the return half:

`setup exit -> substitute safety function removed -> normal guard/interlock restored/proved -> personnel clear -> safety reset/rearm if required -> separate fresh ordinary START`.

Prefer a press brake or machine tool exposing actual final-element behavior. In parallel, primary hydraulic evidence remains the higher-value unresolved branch: serviced safety/holding valve -> unmasked retaining-function proof -> physical ram/load witness -> stopping-performance re-proof where applicable -> rearm -> fresh production initiation.
