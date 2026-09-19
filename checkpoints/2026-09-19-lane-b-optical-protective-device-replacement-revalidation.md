# Lane B checkpoint — optical protective-device replacement/revalidation

Date: 2026-09-19

## Completed

Created `safety-course/OPTICAL_PROTECTIVE_DEVICE_REPLACEMENT_ACCEPTANCE_REVALIDATION_BOUNDARY_STUDY_2026-09-19.md`.

Primary lane was re-read before selection and again after the substantive write. Its newest durable package remains CINCINNATI/BAYKAL/Lazer Safe hydraulic valve service, retention, and stopping-performance proof. Lane B used different device, source, and artifact families.

## Durable freeze

`REPLACEMENT DEVICE INSTALLED != CONFIGURATION/IDENTITY CORRECT != PROTECTIVE FIELD GEOMETRY VALID != DETECTION FUNCTION PHYSICALLY PROVED != RESTART INTERLOCK VALID != MACHINE STOP FUNCTION VALID != SAFETY ACCEPTANCE COMPLETE != PRODUCTION AUTHORITY`

Also preserve `FIELD CLEAR != PERSONNEL CLEAR` and `DIAGNOSTIC/NETWORK DATA VALID != SAFETY FUNCTION VALIDATED`.

## Evidence status

- DOC-CONFIRMED: SICK S3000 documentation requires configuration transfer and qualified safety acceptance when the system plug is replaced.
- DOC-CONFIRMED: SICK S300 documentation distinguishes restart interlock from start interlock and shows that controller integration determines where restart interlock must be implemented.
- DOC-CONFIRMED: scanner guidance requires restart interlock where personnel can leave the protective field toward the hazard or cannot remain detectable throughout the hazard area.
- INFERENCE: device/network health alone is insufficient return-to-service evidence after replacement.
- TEST-CONFIRMED: none newly claimed.
- COMMUNITY-REPORTED: none relied upon.
- UNKNOWN: all OpenPressBrake-specific scanner/light-curtain selection, geometry, response time, safety distance, test method, stop criteria, reset policy, PL/SIL/category/DC/CCF, hydraulic response, and acceptance thresholds.

## Compute

No executable verification was justified. No runner was launched and no GitHub-hosted compute was used.

## Exact next Lane-B work

Find a professional ESPE replacement/commissioning procedure exposing:

`replacement -> configuration/identity restoration -> physical field/detection acceptance test -> independent safety evaluator -> actual final element -> physical machine stop/safe-state witness -> restart-interlock/personnel-clear challenge -> failed-test disposition -> correction -> renewed acceptance -> safety rearm -> fresh ordinary production start`.

Prefer a documented wrong-configuration, altered-mounting, failed test-piece, or restart-interlock fault case. Do not enter the primary lane's hydraulic valve-service evidence package.