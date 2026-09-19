# Safety Checkpoint — Press-Brake Stopping-Performance Re-Proof Trigger — 2026-09-19

## Completed

Created `safety-course/PRESS_BRAKE_STOPPING_PERFORMANCE_REPROOF_TRIGGER_TRACE_2026-09-19.md` from the official Lazer Safe Sentinel press-brake guarding manual.

## New durable evidence

The Sentinel/PGS-2 measures stop time and stop distance whenever the beam stops. Its start-up sequence requires a deliberate high-speed overrun test that tests emergency-stop outputs and assesses actual press-brake stopping performance. The test repeats at every power-up, every 24 hours of continuous operation, after a slow-speed start-up before returning to high speed, and when significant stopping-performance deterioration is detected.

Freeze:

`INITIAL STOPPING TEST PASS != LIFETIME STOPPING-PERFORMANCE PROOF.`

`DETECTED STOPPING-PERFORMANCE DETERIORATION -> RE-PROOF REQUIRED BEFORE NORMAL HIGH-SPEED AUTHORITY.`

`PRESS RESET != REPAIR != PHYSICAL RE-PROOF.`

The same system defines EDM as valve/solenoid monitoring, reinforcing that switching-state evidence and measured stopping performance are separate evidence objects.

## Limits

The source does not establish that replacing a particular hydraulic valve itself triggers the overrun test, does not expose the exact hydraulic load-safe disposition for each valve disagreement, and does not establish post-replacement proof for a retaining valve. Those remain UNKNOWN.

## Compute

None; authoritative documentation answered the question. No GitHub-hosted Actions compute was consumed.

## Exact next work

Primary hydraulic target remains: `specific monitored hydraulic valve disagreement/replacement -> physical ram/load-safe disposition -> fault retention -> repair -> required valve/restraint/stopping-performance re-proof -> safety reset/rearm -> press-brake-specific production initiation`.

Preserve the newly corrected cross-machine restart rule from the preceding checkpoint: protective-device clear never creates restart authority by itself, but validated manual versus automatic restart policy is machine/application specific rather than universally requiring a manual ordinary START on every machine class.
