# Lane B checkpoint — safety-input test pulses and cross-short diagnostics

Date: 2026-09-20

## Completed

Created `safety-course/SAFETY_INPUT_TEST_PULSE_CROSS_SHORT_DIAGNOSTIC_AUTHORITY_STUDY_2026-09-20.md` as an independent Lane-B evidence package.

Primary lane was re-read before selection and again immediately before writing. It is advancing CINCINNATI AUTOFORM energized hydraulic commissioning/post-service hydraulic evidence. Recent independent work also covers guard-interlock defeat/human factors. This checkpoint therefore uses different files and evidence: electrical safety-input pulse diagnostics and commissioning.

## Durable freeze

- `TWO WIRES PRESENT != TWO INDEPENDENT CHANNELS VALID`.
- `BOTH INPUT BITS ON != FIELD CIRCUITS HEALTHY`.
- `DUAL-CHANNEL LOGIC AGREES != SHORT BETWEEN CHANNELS EXCLUDED`.
- `TEST OUTPUT CONFIGURED != CORRECT TEST SOURCE WIRED != TEST PULSE OBSERVED != REQUIRED FAULT DETECTION PROVED`.
- `OSSD OUTPUT PULSES != SAFETY-CONTROLLER TEST PULSES`.
- `INPUT FILTER ACCEPTS OSSD TEST PULSES != REACTION-TIME EFFECT ACCOUNTED FOR`.
- `FAULT CLEARED != SAFETY REQUALIFIED != FRESH ORDINARY START`.

## Evidence added

Manufacturer documentation from Pilz, Rockwell and SICK establishes that test pulses can diagnose cross-shorts when wired/configured appropriately; active OSSD devices may perform their own diagnostic pulses; the safety-input mode/test source must match the field device; OSSD filtering can be necessary but delay must be included in reaction time; and fault detection still requires deliberate restart/fault-disposition design.

Evidence classifications are preserved in the study as DOC-CONFIRMED, INFERENCE, and UNKNOWN. No OpenPressBrake-specific wiring/performance fact is invented and no TEST-CONFIRMED claim is made.

## Compute

No executable verification was justified. No GitHub-hosted runner was used. No self-hosted runner time was consumed.

## Exact next work

Find a complete manufacturer commissioning/validation example with actual wiring and deliberate fault insertion exposing:

`FIELD DEVICE -> TWO CHANNELS/OSSDs -> TEST SOURCE OR DEVICE SELF-TEST -> SAFETY INPUT CONFIGURATION -> OPEN/CROSS-SHORT/SHORT-TO-SUPPLY CHALLENGE -> DIAGNOSTIC -> SAFE OUTPUT RESPONSE -> FAULT LATCH/RESET -> SAFETY REQUALIFICATION -> FRESH ORDINARY START`.

Prefer a fault-insertion table or commissioning procedure. Continue to avoid the primary lane's hydraulic commissioning/post-service files and the recent guard-defeat/human-factors package.