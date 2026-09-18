# Checkpoint — Lane B emergency-stop span-of-control authority

Date: 2026-09-18

## Durable work

Created `safety-course/EMERGENCY_STOP_SPAN_OF_CONTROL_ADJACENT_HAZARD_AUTHORITY_STUDY_2026-09-18.md` in commit `c5038db55360ae75297ec0114559ccb2f74134e5`.

## Parallel-lane check

Before selection, current durable work showed the newest adjacent lane on CIP Safety replacement/recommissioning and the primary safety emphasis on gravity-axis retaining proof plus accessible-cell entry/restart. This Lane-B artifact uses different files and a separate safety function: emergency-stop span of control and adjacent-hazard behavior.

Immediately before the substantive write, `main` ended at `7b35d49cde565d848a4a04c719095e04f55c510b`. Immediately after the write, `c5038db55360ae75297ec0114559ccb2f74134e5` was directly above it. No intervening overlapping write was observed. `PROGRESS.md` was intentionally not rewritten in this lane because the newest primary/network lane had just updated that shared file; this independent checkpoint carries the durable Lane-B state without risking a shared-file collision.

## Freeze

`E-STOP DEVICE ACTUATED != EVERY MACHINE STOPPED != CORRECT SPAN OF CONTROL SELECTED != ADJACENT HAZARDS CONTROLLED != HAZARDOUS ENERGY ABSENT != RESET PERMITTED != RESTART AUTHORIZED.`

`ONE ZONE E-STOP ACTIVE != ANOTHER ZONE'S E-STOP FUNCTION MAY BE DISABLED.`

`LINUXCNC/HAL E-STOP INDICATION != PERSONNEL-SAFETY E-STOP AUTHORITY.`

## Evidence result

SOURCE-CONFIRMED evidence establishes that whole-machine span is the normal emergency-stop baseline; multiple spans are an exception requiring clear identification, hazard association, adjacent-hazard consideration, and independence such that one span cannot prevent emergency-stop initiation in another. Manufacturer evidence also preserves the distinction between emergency stop and complete power removal.

No OpenPressBrake-specific span, stop category, final element, hydraulic behavior, stopping time/distance, PL/SIL/category/DC, or zone mapping was inferred.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Exact next independent work

Find a complete professional linked-machine/cell implementation exposing:

`E-stop device/location -> identified span of control -> safety evaluator -> outputs/final elements in that span -> adjacent-zone behavior -> physical witness -> latched stop -> deliberate reset/rearm -> separate fresh ordinary START`.

Prefer two overlapping/different spans and an explicit commissioning/failure case. Preserve UNKNOWN wherever public evidence stops.
