# Safety replacement/equivalence checkpoint — 2026-09-17

## Durable result

Created `safety-course/SAFETY_REPLACEMENT_PART_EQUIVALENCE_VALIDATION_WORKSHEET.md` in commit `6f3859368e5309724fbc010f01e268d925b0a939`.

Frozen principle: **replace by safety function and verified behavior, not by connector fit or nominal electrical rating.**

The worksheet covers safety contactors/relays, hydraulic/pneumatic safety valves, drives/STO/safe motion, safety I/O/controllers, protective devices, safety sensors/encoders, and safety/control power supplies. It separates manufacturer-declared successor/engineering replacement status from application-level equivalence and requires configuration identity plus physical final-element/energy-path revalidation.

Authoritative evidence used: SICK requires validation after component replacement; Flexi Soft automatic configuration recovery is scoped to devices of the same type and does not erase separate device verification; Rockwell product lifecycle pages explicitly label some successor safety contactors as `Engineering Replacement`; Pilz PNOZ s30 documents device-version configuration compatibility/upgrade behavior and CRC change.

No machine-specific PL/SIL/DC, response time, stopping distance, pressure, hydraulic truth table, or diagnostic coverage was invented.

## Compute

NONE. No GitHub-hosted runner and no self-hosted runner were used; source/documentation reasoning answered the current question.

## Next work

Reconcile this replacement worksheet with `SAFETY_CONFIGURATION_BASELINE_AND_ROLLBACK_INTEGRITY_WORKSHEET.md` and the periodic latent-failure plan into a maintenance lifecycle flow: **validated baseline -> periodic proof/challenge -> anomaly/change trigger -> controlled replacement/change -> scoped revalidation -> new validated baseline**. Keep ordinary LinuxCNC/FPGA control outside personnel-safety authority and preserve explicit UNKNOWN/NOT CLEARED states.
