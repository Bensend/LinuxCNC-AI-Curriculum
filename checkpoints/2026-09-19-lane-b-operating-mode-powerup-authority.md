# Lane B checkpoint — operating-mode selection / power-up authority — 2026-09-19

## Completed

Created `safety-course/OPERATING_MODE_SELECTION_POWERUP_TRANSITION_AUTHORITY_STUDY_2026-09-19.md` at commit `a7f8672f26568f1c1ac6d5aade0fbb8743612723`.

This lane intentionally stayed independent of the primary lane's newest HAWE ePrAX NSV replacement / hydraulic return-to-service evidence package.

## Durable freeze

`MODE REQUESTED != MODE SAFELY SELECTED != MODE TRANSITION COMPLETE != REQUIRED SUBSTITUTE SAFETY FUNCTIONS VALID != SAFEGUARD BYPASS AUTHORIZED != ENABLING DEVICE VALID != MOTION COMMAND PRESENT != HAZARDOUS MOTION AUTHORIZED != PHYSICAL MOTION SAFE`.

Also preserve `POWER RESTORED != PREVIOUS MODE SAFE TO RESUME != SAFETY FUNCTIONS REVALIDATED != PRODUCTION AUTHORITY`, `MODE SELECTOR CHANGED != MACHINE START`, and `ENABLING DEVICE MID-POSITION != MACHINE START`.

## Evidence added

- Pilz operating-mode guidance: one exclusive mode per selector position; selector operation alone must not start the machine.
- Pilz PIT m4SEU: safety-related deliberate mode selection, multiple-selection detection, one active mode output, and explicit configured power-up mode behavior.
- SICK Guide for Safe Machinery: setup/maintenance enabling only with other risk-reducing measures; enabling-device actuation alone is not START; three-position release/overtravel removes authority; position 3 -> position 2 must not simply recreate enabling authority.
- SICK E100 and Pilz PITenable independently confirm physical Off-On-Off three-position enabling behavior.

Evidence classes are preserved in the study as DOC-CONFIRMED, INFERENCE, and UNKNOWN. No OpenPressBrake machine-specific mode, safe speed/force, hydraulic behavior, stopping performance, PL/SIL/category/DC/CCF, reset timing, or restart policy was invented.

No executable verification was justified; no hosted or self-hosted compute was consumed.

## Parallel-work reconciliation

Immediately before writing, main HEAD was `ea60de2f6ff70806583e427e2889d947e6e9a784`, whose primary-lane work concerned HAWE NSV service/replacement. Immediately after the substantive Lane-B commit, main HEAD was `a7f8672f26568f1c1ac6d5aade0fbb8743612723`; no intervening overlapping write appeared. Shared `PROGRESS.md` was deliberately left untouched to avoid parallel-write collision.

## Precise next work

Find a complete professional implementation exposing:

`invalid/multiple mode request -> safety-side rejection -> deliberate valid mode selection -> normal safeguard suspension -> substitute reduced-risk safety function -> three-position enabling device -> separate sustained motion command -> release/overtravel stop through actual final element -> mode exit -> normal safeguard restoration/proof -> safety rearm as required -> application-specific production initiation`.

Prefer a machine tool, press/press brake, or robot cell with function diagrams and a documented power-up or invalid-mode commissioning test.