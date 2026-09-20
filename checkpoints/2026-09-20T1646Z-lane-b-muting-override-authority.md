# Lane B checkpoint — muting / override authority

Date: 2026-09-20T16:46Z

## Completed

Added `safety-course/MUTING_OVERRIDE_MATERIAL_PERSONNEL_DIFFERENTIATION_AUTHORITY_STUDY_2026-09-20.md`.

Selection was made only after reading the required curriculum state and the newest primary-lane durable commits. Primary work had moved through enabling-device acceptance and ABB/Siemens post-replacement revalidation, so this lane deliberately chose a different protective-function family and different files.

## Durable result

Freeze the following distinctions:

- `ESPE MUTED != SAFETY SYSTEM BYPASSED`.
- `MATERIAL PRESENT != VALID MUTING SEQUENCE`.
- `MUTING SENSOR ACTIVE != PERSON EXCLUDED`.
- `MUTING ERROR != OVERRIDE AUTHORIZED`.
- `OVERRIDE REQUESTED != AREA CLEAR`.
- `OVERRIDE ACTIVE != UNBOUNDED MOTION AUTHORITY`.
- `FAULT CLEARED != MUTING REQUALIFIED != ORDINARY RESTART AUTHORIZED`.
- LinuxCNC/HAL/FPGA may request/display ordinary state but do not gain personnel-safety authority from a software `mute` bit.

Manufacturer evidence used: Rockwell 450L/GuardLogix muting documentation, SICK Flexi Soft override documentation, and Pilz muting guidance. Evidence provenance is preserved in the study.

## Compute

No executable verification was justified. No GitHub-hosted runner was used. No self-hosted runner job was necessary.

## Exact next work

Seek one complete manufacturer/OEM acceptance procedure that physically demonstrates valid material muting, invalid/person-like sequence rejection, a stranded-material fault, bounded hazard-visible override, override termination, a new complete muting cycle, reset/requalification, and separate ordinary restart. Prefer actual final-element/machine response and deliberate fault insertion. If authoritative evidence stops at configuration/architecture, mark this branch source-limited and rotate to another independent safety branch.

Before any continuation, re-read current `main` and the primary safety lane's newest durable work; if it has entered muting/override, switch branches rather than duplicate it.