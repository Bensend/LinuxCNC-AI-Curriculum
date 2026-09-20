# Next safety-course checkpoint — energized hydraulic test authority

Date: 2026-09-20

## Durable state

1000/2000/3000 remain GRADUATED/CLOSED. 4000 safety remains primary.

New studies:
- `safety-course/MAINTENANCE_ENERGY_ISOLATION_VS_CONTROL_SAFETY_AUTHORITY_TRACE_2026-09-20.md`
- `safety-course/CONTROLLED_ENERGY_DIAGNOSTIC_AND_SETUP_MODE_AUTHORITY_TRACE_2026-09-20.md`

Professional evidence now separates fully isolated maintenance from deliberately bounded energized setup/diagnostic work. Special mode is not a safety bypass; professional examples retain task-specific safety functions, physical preconditions, enabling/hold-to-run authority, bounded motion, and explicit return-to-normal sequencing.

Key freezes:

`NORMAL STOP != SAFETY STOP != ENERGY ISOLATION`.

`ENERGIZED DIAGNOSTIC REQUIRED != NORMAL PRODUCTION MODE PERMITTED`.

`MAINTENANCE MODE SELECTED != MOTION AUTHORIZED`.

`REDUCED SPEED COMMAND != SAFELY LIMITED SPEED PROVED`.

`INTERNAL PRECONDITION BIT TRUE != PHYSICAL PRECONDITION WITNESS PROVED`.

`MANUAL VALVE COMMAND PERMITTED != PRODUCTION CYCLE PERMITTED`.

## Exact next evidence target

Find an authoritative hydraulic press-brake OEM/service/commissioning procedure in which hydraulic energy intentionally remains present to test/adjust/measure a valve, pressure path, stopping path, or redundant final element. Capture:

1. physical ram/load restraint or personnel exclusion;
2. selected operating/service mode;
3. which pump/valve action remains permitted;
4. how unintended normal production motion is suppressed;
5. measurement/test point and physical witness;
6. abort/release behavior;
7. whether a companion hydraulic path is deliberately prevented from masking the element under test;
8. pass/fail disposition;
9. return to isolation or production, including revalidation/reset/fresh start.

Prefer OEM/manifold documentation. Do not invent pressures, speeds, force limits, BDC assumptions, PL/SIL/category, or OpenPressBrake hydraulic states.

The post-replacement holding/counterbalance-valve static-retention path remains source-limited unless genuinely new evidence appears.

## Compute

No simulation/build/test compute is justified by the current evidence question. Do not use GitHub-hosted runners. Use `[self-hosted, openpressbrake]` only if a later concrete unresolved runtime question warrants it.
