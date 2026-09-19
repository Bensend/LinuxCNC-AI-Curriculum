# Safety Curriculum Checkpoint — OEM Stop-Time Maintenance Trace

UTC checkpoint: 2026-09-19T19:48:00Z

## Completed

Added `safety-course/PRESS_BRAKE_OEM_STOP_TIME_MAINTENANCE_AND_INITIAL_REVALIDATION_TRACE_2026-09-19.md` and updated `PROGRESS.md`.

A BAYKAL APH OEM manual now supplies machine-specific evidence that hydraulic safety-valve elements exist in the press-brake architecture, initial machine testing includes a real test-run of emergency/safety/limit-switch function and leakage checks, and stopping performance is a recurring maintenance property with six-month stop-time control and a specified measurement connection.

Durable boundary:

**HYDRAULIC VALVE REPLACED != MACHINE FUNCTIONAL TEST PASSED != STOPPING PERFORMANCE MEASURED != SAFEGUARD DISTANCE STILL VALID != PRODUCTION AUTHORITY.**

**TEST RUN SHOWS SAFETY SWITCH RESPONSE != INDIVIDUAL HYDRAULIC FINAL ELEMENT PROVED.**

**STOP-TIME PASS != STATIC LOAD-RETENTION PASS.**

The public manual does not state that replacement of a named safety valve automatically triggers stop-time measurement, nor does it expose an unmasked individual static load-retention test. Those remain UNKNOWN.

No compute was justified or used.

## Exact next work

Continue seeking machine-specific OEM/service or manifold-integration evidence for:

`specific holding/safety valve replacement -> required post-repair test selection -> unmasked individual retaining-function challenge -> physical ram/load witness -> pass/fail disposition -> stopping-performance re-proof where applicable -> safety rearm -> fresh ordinary START`.

If that exact source path remains exhausted, rotate to another open professional safety implementation gap rather than inventing test parameters.
