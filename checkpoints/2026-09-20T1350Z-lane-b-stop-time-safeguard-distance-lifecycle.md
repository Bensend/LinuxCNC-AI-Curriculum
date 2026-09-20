# Lane B checkpoint — stop-time measurement and safeguard-distance lifecycle

Date: 2026-09-20T13:50Z
Active curriculum: 4000 safety course

## Durable work completed

Created `safety-course/STOP_TIME_MEASUREMENT_SAFEGUARD_DISTANCE_LIFECYCLE_ACCEPTANCE_STUDY_2026-09-20.md`.

Primary evidence:
- Pilz overrun-measurement procedure: physical safeguard interruption at high machine speed, measured hazardous-motion overrun, ten repetitions, worst value used, then installed safeguard distance checked against the result.
- SICK stop-time measurement guidance: physical stop measurement is required before initial commissioning and after significant or expected usage-related changes such as brake wear.
- Pilz ISO 13855:2024 summary: measured overall response time is an input to the safeguard-distance calculation; the highest of ten measurements is used in the cited method and additional geometry/approach terms remain necessary.

Evidence classification: manufacturer statements are `DOC-CONFIRMED`; reusable acceptance ladder is `INFERENCE`; actual machine results become `TEST-CONFIRMED` only with preserved setup/instrumentation/conditions/results. OpenPressBrake-specific values remain `UNKNOWN`.

## Durable freezes

- `SAFETY OUTPUT OFF != HAZARDOUS MOVEMENT PHYSICALLY STOPPED`.
- `NOMINAL STOP TIME != MEASURED STOP TIME`.
- `ONE STOP MEASUREMENT != WORST-CASE STOPPING PERFORMANCE`.
- `MEASURED STOP TIME != REQUIRED SAFEGUARD DISTANCE BY ITSELF`.
- `CALCULATED REQUIRED DISTANCE != INSTALLED PHYSICAL DISTANCE VERIFIED`.
- `DISTANCE VALIDATED AT COMMISSIONING != DISTANCE VALID FOREVER`.
- A relevant brake/drive/hydraulic/control/safeguard change does not silently inherit old stop-time evidence.

## Parallel-work check

Immediately before committing, current main showed the primary lane advancing SLS overspeed physical acceptance and stale/fresh-start evidence. This Lane-B artifact uses separate files and a separate evidence family: physical stopping-performance measurement as an input to safeguard placement and lifecycle revalidation. No primary-lane file was overwritten.

## Compute

No executable verification was justified. No GitHub-hosted runner or self-hosted runner compute was consumed.

## Precise next Lane-B work

Seek an authoritative OEM/manufacturer return-to-service or periodic-inspection procedure connecting a specific machine change or wear condition to repeated physical stop measurement, worst-case disposition, installed safeguard-distance check, failed-test lockout/correction, successful revalidation, and production release. Prefer a press/press-brake or other high-energy machine example. Do not infer OpenPressBrake stopping values from another machine.

Generic safety-distance formula searching is now information-gain limited unless it adds a physical acceptance/failure-disposition sequence.
