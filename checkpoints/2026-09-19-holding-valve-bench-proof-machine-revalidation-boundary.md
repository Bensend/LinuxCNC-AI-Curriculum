# Primary safety checkpoint — holding-valve individual proof vs machine revalidation

Date: 2026-09-19

## Completed

Created `safety-course/HOLDING_VALVE_BENCH_PROOF_VS_MACHINE_RETENTION_REVALIDATION_BOUNDARY_STUDY_2026-09-19.md` and advanced `PROGRESS.md`.

## Durable result

Terex Utilities Tech Tip 38 provides professional non-press-brake evidence for a genuinely individual holding-valve challenge: support the load and control trapped pressure before removal; put the valve in a dedicated test block; apply pressure at the load-holding side; verify manufacturer-specified opening/reset behavior; lock the adjustment; repeat verification.

Freeze:

`LOAD PHYSICALLY SUPPORTED FOR VALVE REMOVAL != TRAPPED PRESSURE CONTROLLED != INDIVIDUAL VALVE BENCH-CHALLENGED != VALVE SETTING/RESET PROVED != VALVE CORRECTLY REINSTALLED != MACHINE STATIC RETENTION PROVED != DYNAMIC STOPPING PERFORMANCE PROVED != SAFETY REARM != FRESH PRODUCTION START`

This closes a conceptual masking gap at component level but does not close the press-brake machine-level gap.

## Evidence discipline

- DOC-CONFIRMED: professional component-level off-machine individual proof pattern.
- INFERENCE: dedicated bench proof can remove companion machine retaining paths from the component question.
- TEST-CONFIRMED: none for OpenPressBrake.
- COMMUNITY-REPORTED: none relied upon.
- UNKNOWN: actual OpenPressBrake valve/topology/settings/test limits; OEM permission for this method; machine static retention procedure; replacement-triggered stop test; safety rearm/production-release chain.

## Compute

No executable test was justified. No GitHub-hosted or self-hosted compute used.

## Exact next primary work

Seek press-brake/manifold-specific OEM evidence connecting a named serviced holding/safety valve to post-reassembly machine static retention and failed-test disposition. Then determine whether that service also invokes stopping/start-up testing, safety rearm, and fresh production initiation. Preserve Terex only as a comparison model; do not transplant its procedure or values into OpenPressBrake.
