# Lane B Checkpoint — Safety Configuration Signature / Revalidation — 2026-09-19

## Completed
Created `safety-course/SAFETY_CONFIGURATION_SIGNATURE_CHANGE_REVALIDATION_AUTHORITY_STUDY_2026-09-19.md` at commit `111125bed1f2c75a87b6187a98bc955670c9ff9d`.

This branch is independent of the newest access-stop/inside-area restart-prevention work and did not modify its files or shared `PROGRESS.md`.

## Durable freeze
`DOWNLOAD SUCCEEDED != VALIDATED SAFETY APPLICATION`.

`SAFETY SIGNATURE PRESENT != EVERY EXTERNAL DEVICE CONFIGURATION VERIFIED`.

`SIGNATURE MATCH != PHYSICAL SAFETY FUNCTION PROVED AFTER A RELEVANT CHANGE`.

Safety configuration identity/integrity, safety-device configuration identity, functional safety validation, physical final-element response, and fresh ordinary START authority remain separate propositions.

## Evidence
Rockwell GuardLogix current documentation source-confirms safety-signature scope, element-level change signatures, download/restore comparison, revalidation after mismatched/unsigned changes, and safety-I/O configuration signatures. SICK Flexi documentation independently source-confirms configuration readback/report verification, loss of verified status after safety-related changes, and separate verification responsibility for connected configurable devices.

No machine-specific OpenPressBrake safety platform or validation values were inferred.

## Main re-read / overlap check
Immediately after substantive commit, current main HEAD was `111125bed1f2c75a87b6187a98bc955670c9ff9d`; prior HEAD remained `a88c0787e72546c60d4181fc3ca211e65440827e`. No intervening primary-lane write or overlapping-file change appeared. Shared `PROGRESS.md` was intentionally left untouched.

## Compute
No executable verification was justified. No GitHub-hosted runner and no self-hosted runner compute were used.

## Precise next Lane-B work
Seek one professional implementation joining:

`approved safety configuration/signature -> intentional safety edit or configurable safety-device change -> signature/checksum/verified state changes -> production authority withheld -> change impact identified -> affected safety function functionally tested through final element and physical hazard -> new approved signature/checksum/report archived -> deliberate safety reset/rearm -> separate fresh ordinary START`.

Prefer a scanner, drive/STO, or safety-I/O example where controller-project verification and the connected device's own configuration verification are both visible. If the primary lane begins this exact configuration-management branch, rotate Lane B to a different open safety lifecycle/failure path rather than duplicating it.