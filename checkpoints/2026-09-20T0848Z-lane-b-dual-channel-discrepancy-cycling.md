# Lane B checkpoint — dual-channel discrepancy, cycling, and recovery

Date: 2026-09-20
Lane: independent safety curriculum Lane B

## Completed

Created `safety-course/DUAL_CHANNEL_DISCREPANCY_CYCLING_AND_FAULT_RECOVERY_AUTHORITY_STUDY_2026-09-20.md`.

Primary safety work was rechecked before selection and again before checkpoint. The primary lane remains on its own session/energized hydraulic path; no overlapping primary module/file was overwritten.

## Durable freezes

- `CHANNEL A HEALTHY + CHANNEL B HEALTHY != DUAL-CHANNEL TRANSITION VALID`.
- `BOTH CHANNELS EVENTUALLY AGREE != DISCREPANCY TIME SATISFIED`.
- `DISCREPANCY FAULT CLEARED != INPUT PAIR REQUALIFIED`.
- `INPUTS CURRENTLY ACTIVE != REQUIRED INPUT CYCLING COMPLETED`.
- `INPUT FILTER/DEBOUNCE != DISCREPANCY TIME`.
- A displayed/configured `0 ms` must be interpreted from the exact product manual; it must never be assumed to mean zero tolerated discrepancy.
- `SAFETY INPUT REQUALIFIED != SAFETY OUTPUT/FINAL ELEMENT REQUALIFIED != FRESH ORDINARY START`.

## Evidence status

Rockwell Guard I/O dual-channel discrepancy behavior, cycle-input behavior, and restart/cold-start separation: **DOC-CONFIRMED** for the cited product/instruction families.

SICK UE440/UE470 discrepancy timing and filter/discrepancy relationship: **DOC-CONFIRMED**.

OpenPressBrake discrepancy time, filter, restart/cold-start policy, field device and safety evaluator: **UNKNOWN**.

No machine-specific timing, stopping distance, hydraulic truth table, PL/SIL/category/DC/CCF, or acceptance threshold was invented.

No executable verification was justified. No GitHub-hosted runner was used and no self-hosted compute was consumed.

## Precise next work

Find a complete professional manufacturer commissioning/fault-insertion example exposing:

`PHYSICAL DEVICE -> CHANNEL A/B -> FILTER/TEST CONFIGURATION -> DISCREPANCY EVALUATION -> ONE-CHANNEL LATE/STUCK CHALLENGE -> FAULT -> REQUIRED INPUT CYCLING -> RESET/REQUALIFICATION -> SAFETY OUTPUT -> ACTUAL FINAL ELEMENT -> PHYSICAL HAZARD WITNESS -> FRESH ORDINARY START`.

Prefer a wiring diagram plus explicit fault-insertion/commissioning table. Stay outside the primary lane's hydraulic evidence package and avoid redoing Lane B's completed test-pulse/cross-short study.
