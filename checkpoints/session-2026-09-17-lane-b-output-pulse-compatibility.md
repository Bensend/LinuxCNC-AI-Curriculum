# Session Checkpoint — Lane B Safety Output Test-Pulse Compatibility

Date: 2026-09-17
Overlap status: primary lane latest durable work remained personnel-retention/restart authority; no same-file overlap observed before Lane-B commit. Main was re-read after the study commit and no intervening primary commit appeared.

## Durable work

- Added `safety-course/SAFETY_OUTPUT_TEST_PULSE_ACTUATOR_COMPATIBILITY_STUDY_2026-09-17.md`.
- Evidence package uses Rockwell MSR57P output pulse-test guidance, Rockwell contactor application guidance, SICK S3000 OSSD timing/load requirements, and Pilz test-pulse purpose documentation.
- No simulation/build/test compute was justified or consumed. No GitHub-hosted runner was used.

## Frozen rule

`SAFETY OUTPUT HIGH != CONTINUOUS HIGH`.

`TEST PULSE GENERATED != RECEIVER COMPATIBLE != FINAL ELEMENT UNAFFECTED != DIAGNOSTIC COVERAGE PRESERVED`.

Output diagnostic behavior and receiver/final-element behavior are one safety interface contract. Disabling pulse tests to solve incompatibility can change diagnostic coverage and therefore requires the complete safety-function claim to be re-evaluated rather than silently retaining the previous claim.

## OpenPressBrake boundary

Selected safety output hardware, STO inputs, contactors, hydraulic safety interfaces, pulse timing, load/cable limits, PL/SIL/category and acceptance thresholds remain `UNKNOWN`. No values were invented.

## Precise next independent work

Trace one complete professional safety output chain exposing `diagnostic pulse -> receiving safety input/actuator compatibility -> physical final element -> EDM/feedback -> detected-fault recovery`. Prefer a drive STO or safety-contactor implementation with explicit pulse tolerance/filter data. If the primary lane reaches that evidence package first, rotate to safety-output short-circuit/backfeed detection or interposing-relay failure analysis.
