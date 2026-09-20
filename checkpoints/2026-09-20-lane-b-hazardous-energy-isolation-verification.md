# Lane B checkpoint — hazardous-energy isolation verification — 2026-09-20

## Completed

Added `safety-course/HAZARDOUS_ENERGY_ISOLATION_VERIFICATION_REACCUMULATION_AND_TEST_POSITIONING_STUDY_2026-09-20.md`.

This lane was selected only after checking the current primary lane. Primary work is on press-brake hydraulic post-service acceptance evidence; Lane B intentionally used different files and a different evidence package.

## Durable result

Freeze the maintenance authority chain:

`ORDINARY CONTROL STOPPED != SAFETY STOP DEMANDED != PHYSICAL ENERGY ISOLATION COMPLETE != LOCKOUT/TAGOUT APPLIED != STORED/RESIDUAL/GRAVITY ENERGY CONTROLLED != ISOLATION VERIFIED != REACCUMULATION CONTROLLED != INTRUSIVE MAINTENANCE AUTHORIZED`.

On restoration:

`MAINTENANCE COMPLETE != AREA/PERSONNEL CLEAR != ENERGY RESTORATION AUTHORIZED != AFFECTED SAFETY FUNCTIONS REVALIDATED != SAFETY REARMED != FRESH ORDINARY START`.

OSHA 29 CFR 1910.147 and related OSHA guidance are SOURCE-CONFIRMED for the generic energy-control requirements. No OpenPressBrake-specific energy topology or acceptance threshold was inferred.

## Compute

No executable question justified compute. No GitHub-hosted runner and no self-hosted runner were used.

## Exact next Lane-B work

Trace an authoritative OEM multi-energy maintenance procedure, preferably hydraulic press/press brake or comparable gravity-loaded industrial equipment, that shows:

`energy inventory -> electrical isolation -> hydraulic/pneumatic isolation -> stored/gravity restraint -> physical verification -> reaccumulation handling -> controlled test/positioning re-energization if required -> re-isolation -> work completion -> personnel/tools clear -> restoration -> affected safety-function/final-element revalidation -> safety rearm -> fresh ordinary production start`.

Prioritize a source that explicitly combines physical blocking/support with pressure isolation and electrical isolation. Avoid duplicating the primary lane's component-specific holding/counterbalance-valve acceptance search.