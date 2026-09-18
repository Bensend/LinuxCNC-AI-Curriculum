# Lane B checkpoint — safety input test-pulse and cross-fault diagnostics

Date: 2026-09-18
Substantive commit: `110f223f2fd1936ac930481d53f7a33222ac498c`

## Completed

Added `safety-course/SAFETY_INPUT_TEST_PULSE_CROSS_FAULT_DIAGNOSTIC_COVERAGE_STUDY_2026-09-18.md`.

Primary lane was advancing monitored hydraulic final-element disagreement and physical hazard witness, so this lane stayed on the independent safety-input/field-wiring side.

Frozen distinctions:

- CONTACTS CLOSED != FIELD WIRING HEALTHY != TEST PULSE OBSERVED CORRECTLY != CHANNELS IN AGREEMENT != SAFETY FUNCTION VALID != FINAL ELEMENT SAFE != PHYSICAL HAZARD ABSENT.
- DUAL CHANNEL != AUTOMATIC CROSS-FAULT DETECTION.
- TEST PULSE ENABLED != EVERY SHORT CIRCUIT DETECTABLE.
- INPUT DIAGNOSTIC CLEAR != FRESH ORDINARY MOTION AUTHORITY.

Key durable evidence: Rockwell explicitly documents that pulse-tested safety inputs can diagnose shorts to positive and between signal lines, but a channel-to-channel short can be missed when both channels use the same test output. Pilz confirms test pulses detect shorts across contacts when wired appropriately. SICK warns that cross-circuit/routing can impair fault detection and calls for protected/separate wiring in the cited tested-sensor arrangement.

No executable verification was justified; no hosted or self-hosted compute was used.

## Main re-read / overlap check

Immediately after the substantive write, `main` HEAD was `110f223f2fd1936ac930481d53f7a33222ac498c`, directly above primary/log commit `7aca52184f770a49e477449751f578876e48a939`. No intervening overlapping write appeared. Shared `PROGRESS.md` was intentionally left untouched to avoid collision.

## Precise next work

Find a complete professional wiring/commissioning example exposing:

**two physical safety contacts/sensors -> distinct test sources -> safety inputs -> cross-short/short-to-supply/discrepancy diagnosis -> defined/latched fault recovery -> safety output/final element -> physical safe-state witness -> deliberate reset/rearm -> separate fresh ordinary START**.

Prefer an example that explicitly shows a diagnostic lost by wrong test-source assignment, inappropriate shared wiring, or defeated cable separation. Preserve SOURCE-CONFIRMED / DOC-CONFIRMED / TEST-CONFIRMED / COMMUNITY-REPORTED / INFERENCE / UNKNOWN labels and do not invent OpenPressBrake-specific safety performance.