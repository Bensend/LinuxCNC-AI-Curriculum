# 4000 safety checkpoint — Lane B pressure-sensitive mat occupancy/restart authority

Date: 2026-09-20

## Parallel-work check

Immediately before this checkpoint, current `main` showed the primary lane advancing final-element physical feedback: electrical contactor EDM followed by drive STO/status feedback and hydraulic valve/spool monitoring. Lane B therefore selected a different protective-device/occupancy evidence family and did not modify the primary lane's evidence files.

## Completed

Added `safety-course/PRESSURE_SENSITIVE_MAT_OCCUPANCY_RESET_AND_RESTART_AUTHORITY_STUDY_2026-09-20.md` using current Rockwell MatGuard/Guardmaster and SICK reset/restart evidence.

## Durable freeze

`MAT NOT ACTUATED != HAZARD AREA PERSONNEL-CLEAR`.

`PERSON STEPPED OFF MAT != RESTART AUTHORIZED`.

`MAT CLEAR != SAFETY RESET COMPLETE != FRESH ORDINARY START`.

`MAT INPUT HEALTHY != MAT COVERAGE/PLACEMENT VALID != REQUIRED SEPARATION DISTANCE VALID`.

`MAT SAFETY RELAY OUTPUT OFF != HAZARDOUS MOTION PHYSICALLY CEASED`.

LinuxCNC/HAL/ordinary FPGA status remains diagnostic/operational information, not personnel-safety authority.

## Exact next Lane-B work

Find a professional machine implementation exposing the complete pressure-sensitive-mat chain: physical approach path -> mat coverage -> dual-channel/cross-fault evaluation -> safety demand -> machine stopping function -> occupied state -> clearance -> manual reset with area visibility -> safety requalification -> stale-command challenge -> separate fresh ordinary START.

Prefer evidence that also documents seams/dead zones, multiple mats, or deliberate fault insertion. Do not duplicate the primary lane's current EDM/STO/hydraulic-final-element comparison.

## Compute

No executable verification was justified. No GitHub-hosted compute was used. If a later concrete executable question requires compute, only `[self-hosted, openpressbrake]` is permitted.