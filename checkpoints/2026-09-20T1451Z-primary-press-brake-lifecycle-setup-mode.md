# Primary checkpoint — press-brake stop-time lifecycle and setup-mode authority

Date: 2026-09-20T14:51Z
Active curriculum: 4000 safety course

## Durable work completed

1. `safety-course/PRESS_BRAKE_STOP_TIME_DETERIORATION_SAFEGUARD_REPOSITION_LIFECYCLE_TRACE_2026-09-20.md`
   - Rockford RHPS press-brake manual ties increased stopping time/distance to recalculation and outward safeguard repositioning as required.
   - Rockford lifecycle guidance identifies maintenance, brake wear and alterations as stop-performance revalidation triggers.
   - Persistent safety-related failure is not made acceptable for production by repeated reset.

2. `safety-course/SETUP_MODE_SAFE_SPEED_AUTHORITY_AND_ACCEPTANCE_TIMEOUT_TRACE_2026-09-20.md`
   - Siemens commissioning trial demonstrates guard-open commissioning motion being reduced to SLS rather than retaining unrestricted speed.
   - Guard reclosure requires safety acknowledgement before ordinary behavior resumes.
   - Siemens acceptance-test mode is time-bounded; timeout cancels the test rather than passing it.
   - Pilz independently demonstrates separate Setup and Automatic monitored-speed states.

## Evidence classes

Manufacturer claims: `DOC-CONFIRMED`.
Combined reusable acceptance ladders: `INFERENCE`.
OpenPressBrake-specific safe speeds, stop times, distances, timeouts, PL/SIL and hydraulic response values: `UNKNOWN` until designed/measured.

## Durable freezes

- `STOPPING TIME INCREASED != EXISTING SAFEGUARD POSITION STILL ACCEPTABLE`.
- `PREVENTIVE MAINTENANCE COMPLETE != SAFETY PERFORMANCE REVALIDATED WHEN THE WORK CAN AFFECT STOPPING PERFORMANCE`.
- `FAILURE RESETTABLE != FAILURE ACCEPTABLE FOR PRODUCTION`.
- `COMMISSIONING MODE SELECTED != UNRESTRICTED MOTION AUTHORITY`.
- `GUARD OPEN IN COMMISSIONING != NORMAL PRODUCTION SPEED PERMITTED`.
- `TEST TIMEOUT != TEST PASS`.
- `MODE SELECTED != PHYSICAL SPEED SAFE`.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Seek one integrated manufacturer setup/service acceptance sequence that combines access-controlled mode selection, a three-position enabling device, safe-speed physical challenge, abort/timeout behavior, exit from setup, safety rearm, stale-command rejection and a fresh production START. Reopen stop-time work only for a stronger all-in-one return-to-service checklist or genuinely new press-brake OEM evidence. If the integrated setup sequence remains source-limited, rotate to another physical safety-function acceptance witness rather than generic cataloging.
