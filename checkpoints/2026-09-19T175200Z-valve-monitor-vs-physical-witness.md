# Safety Curriculum Checkpoint — Valve Monitor vs Physical Witness

UTC checkpoint: 2026-09-19T17:52:00Z

## Completed

Added `safety-course/PRESS_BRAKE_VALVE_MONITORING_VS_PHYSICAL_STOP_WITNESS_BOUNDARY_2026-09-19.md` from current Lazer Safe PCSS-A v1.25 evidence.

Key durable result:

**VALVE COMMAND/MONITOR AGREEMENT != HYDRAULIC LOAD RETENTION PROVED != RAM PHYSICALLY STOPPED != STOPPING PERFORMANCE PROVED != PRODUCTION AUTHORITY.**

The PCSS independently exposes holding/safety-valve contact monitoring and actual beam stopping-distance/time tests. These are separate witnesses for separate properties. Stopping-test success does not isolate or prove an individual holding valve's static retaining capability.

## Still UNKNOWN

Public evidence has not yet established:

`specific serviced/replaced holding or safety valve -> mandatory machine-specific post-service stopping/start-up test and/or static retention test -> individual unmasked retaining challenge -> physical ram/load witness -> pass/fail disposition -> safety rearm -> fresh production initiation`.

Do not invent this chain.

## Exact next work

1. Search press-brake OEM/service documentation rather than generic safety-controller manuals for a component replacement/recommissioning procedure that identifies the required physical tests after holding/safety-valve service.
2. Prefer a complete machine implementation with two retaining elements where the serviced element is challenged without a healthy companion masking failure.
3. If that source path remains exhausted, rotate to final-element repair/replacement re-proof or accessible-cell recovery rather than manufacturing a synthetic hydraulic test.
4. No compute is currently justified; continue source/documentation work. Any later justified compute must target `[self-hosted, openpressbrake]` only.
