# Checkpoint — press-brake valve fault to stopping re-proof

## Durable advance

Added `safety-course/PRESS_BRAKE_VALVE_FAULT_TO_STOPPING_REPROOF_AUTHORITY_TRACE_2026-09-19.md` from Lazer Safe PCSS-A v1.25 manufacturer documentation.

New bounded chain:

`individual monitored valve disagreement -> valve fault -> PCSS emergency-stop condition -> safety output off -> further press operation inhibited until problem resolved`

Separately, PCSS start-up testing establishes:

`required physical stopping test -> deliberately induced stop -> actual beam stopping distance/time measured -> failure causes emergency-stop reaction and blocks normal operation -> test repeated until pass -> normal operation may begin`

Important freeze:

`Valve Zero / monitor agreement != ram/load physically safe != stopping performance proved`.

`fault message cleared != valve repaired != valve switching state re-proved != physical hazard state proved != stopping performance re-proved != production authority`.

## Evidence boundary

Still UNKNOWN from reviewed public evidence:

- exact ram/load-safe hydraulic disposition for every individual valve fault;
- whether replacement of a monitored valve automatically forces the PCSS start-up/stopping tests;
- whether OEM service requires a separate static retaining/load proof after holding/safety-valve replacement;
- how a serviced retaining element is individually proved without a companion element masking it;
- exact press-brake-specific reset/rearm/fresh-cycle sequence after that service.

## Exact next work

Seek authoritative press-brake OEM/service evidence joining:

`holding/safety valve fault -> physical ram/load safe disposition -> support/isolate/depressurize -> repair/replacement -> unmasked individual retaining proof -> dynamic stopping re-proof -> safety rearm -> fresh production initiation`.

If unavailable, continue the dual-retaining-element service/re-proof branch rather than inventing the missing hydraulic behavior.

## Compute

No simulation/build/test compute used. Do not use GitHub-hosted runners. Any later justified compute must target `[self-hosted, openpressbrake]`.
