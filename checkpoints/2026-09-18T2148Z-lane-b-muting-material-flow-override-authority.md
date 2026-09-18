# Safety checkpoint — Lane B muting / material-flow / override authority

Date: 2026-09-18

## Completed

Created `safety-course/MUTING_MATERIAL_FLOW_OVERRIDE_RESTART_AUTHORITY_STUDY_2026-09-18.md` in substantive commit `b08575f53cb20ed4542a10d68375a30640d65b67`.

## Parallel-lane reconciliation

Before selection, current main and recent commits showed the primary safety lane had just advanced `MULTIPERSON_TRAPPED_KEY_BLIND_SPOT_RESTART_AUTHORITY_TRACE_2026-09-18.md` and requested physical-hazard/final-element integration next. Lane B therefore selected a separate safeguarding branch—ESPE/light-curtain muting and recovery override—and did not modify the primary lane's evidence package, module, checkpoint, or shared `PROGRESS.md`.

Immediately after the substantive commit, main was re-read. `b08575f5` was HEAD with no intervening primary-lane change, so no reconciliation or branch switch was necessary.

## Frozen result

`PROTECTIVE FIELD CLEAR != VALID MUTING REQUEST != VALID MATERIAL SEQUENCE != MUTING ACTIVE != PERSON EXCLUDED != HAZARD SAFE`.

`MUTING ACTIVE != BYPASS/OVERRIDE AUTHORIZED`.

`OVERRIDE AUTHORIZED != NORMAL PRODUCTION AUTHORITY`.

`MUTING SEQUENCE COMPLETE != RESET COMPLETE != FRESH START/JOG/CYCLE INTENT`.

Manufacturer evidence from Pilz, Rockwell and SICK separates material recognition/sequence, muting, invalid-sequence fault handling, bounded recovery override, reset, and ordinary production control. A LinuxCNC/HAL workpiece-present bit is not by itself personnel-safety muting authority.

## Evidence limits

No OpenPressBrake ESPE choice, muting need, sensor geometry/count, timing/concurrence values, direction, override method, stopping performance, hydraulic state, pressure/force, PL/SIL/category/DC/CCF, or type-C-standard applicability was invented. Those remain UNKNOWN until application evidence exists.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Find a complete professional material-transfer implementation exposing `material detection -> muting sensor geometry -> safety-side sequence validation -> ESPE mute -> physical final element/hazard behavior -> invalid sequence or stalled material -> bounded recovery override -> protective-function restoration -> reset/rearm -> separate ordinary production command`, preferably with a stuck-sensor, wrong-sequence, timeout, or override failure path.

If the primary lane advances muting before the next Lane-B run, switch to another independent open safeguarding/failure-analysis branch rather than duplicate it.
