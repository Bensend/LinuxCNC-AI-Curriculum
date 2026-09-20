# 4000 safety checkpoint — Cincinnati one-servo-at-a-time hydraulic diagnostic

## Durable advance

New study: `safety-course/CINCINNATI_CBII_ONE_SERVO_AT_A_TIME_CHECK_VALVE_DIAGNOSTIC_TRACE_2026-09-20.md`.

CINCINNATI CB II OEM evidence now supplies a real press-brake example of preventing companion-path masking during a hydraulic diagnostic: in a special SETUP-mode test, flow is provided by one servo valve at a time to test the check valves associated with each side, and the control identifies the side that fails. The same manual calls the dump valve a safety valve for redundant ram-down control and monitors its spool-position sensor in both expected states, including the latent-danger case of a valve stuck closed while ordinary operation might otherwise appear normal.

Freeze:

- `AGGREGATE HYDRAULIC FUNCTION PASS != LEFT-SIDE CHECK PATH PROVED != RIGHT-SIDE CHECK PATH PROVED`.
- `PRESS MOVES NORMALLY != SAFETY DUMP VALVE PROVED ABLE TO OPEN != REDUNDANT DOWN-MOTION INHIBIT HEALTHY`.
- `ONE-SERVO-AT-A-TIME DIAGNOSTIC PASS != STATIC LOAD-RETENTION PROOF != STOPPING-PERFORMANCE PROOF != PRODUCTION AUTHORITY`.
- `RAM BLOCKED + POWER ISOLATED FOR SERVICE != REPLACEMENT VALVE FUNCTION PROVED AFTER REASSEMBLY`.

## Evidence boundary

This does **not** close the primary post-service retaining-function gap. The accessible OEM manual does not say that valve replacement triggers the special test, does not expose the cadence/event behind "occasionally," and does not provide a static ram/load-retention acceptance test for the serviced dump/check/counterbalance valve. Preserve these as `UNKNOWN`.

## Exact next work

1. Continue the primary search for a press-brake OEM/manifold service procedure connecting a **named serviced holding/safety valve** to an **individual retaining/load challenge** with companion-path masking controlled, a **physical ram/load witness**, explicit **pass/fail disposition**, any required **dynamic stopping re-proof**, **safety rearm**, and **fresh production initiation**.
2. Specifically search CINCINNATI service/supplement material for the trigger/cadence of the one-servo-at-a-time check-valve test and whether it is required after relevant hydraulic valve replacement.
3. Seek a press-brake example where A PASS / B FAIL produces a documented physical load-safe disposition and states whether A must be re-proved after B service. Do not infer degraded production authority.
4. If that source path reaches another information-gain stop, rotate to the highest-value open safety branch rather than manufacturing a synthetic lab.

## Compute

No simulation/build/test compute was justified or consumed. No GitHub-hosted runner was used.
