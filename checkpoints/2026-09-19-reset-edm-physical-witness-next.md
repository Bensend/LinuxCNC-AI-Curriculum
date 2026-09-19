# Safety checkpoint — reset/EDM/fresh-start to physical witness

Date: 2026-09-19

## Durable work completed

- `safety-course/MONITORED_RESET_EDM_FRESH_START_COMPLETE_IMPLEMENTATION_TRACE_2026-09-19.md`
- `safety-course/PHYSICAL_STANDSTILL_WITNESS_RESET_AUTHORITY_TRACE_2026-09-19.md`

## New frozen boundaries

`PROTECTIVE CONDITION RESTORED != EXTERNAL FINAL ELEMENT PROVED DE-ENERGIZED != RESET ACTUATOR HEALTHY != VALID RESET TRANSITION != SAFETY CIRCUIT REARMED != ORDINARY PROCESS START`

`WELDED CONTACTOR -> EDM/FEEDBACK NOT READY -> RESET REFUSED`

`RESET HELD/TIED DOWN -> MONITORED RESET REFUSED`

`EDM/CONTACTOR FEEDBACK SAFE != ACTUAL MOTION SAFE`

`STOP COMMAND ISSUED != DECELERATION MONITORED != STANDSTILL THRESHOLD REACHED != TRUE ZERO SPEED != STANDSTILL MAINTAINED`

Rockwell professional implementations now provide the complete reset/EDM/fresh-process-start separation and a separate actual-speed/position standstill witness with deliberate standstill-violation validation.

## Compute

No simulation, synthesis, build, benchmark or executable test was justified. No GitHub-hosted or self-hosted compute was consumed.

## Primary remaining evidence gap

Continue authoritative press-brake OEM/manifold search for:

`specific holding/safety valve fault or service -> ram/load physically secured -> isolate/depressurize -> repair/replacement -> individual retaining-function challenge without companion masking -> physical ram/load witness -> pass/fail disposition -> dynamic stopping-performance re-proof where applicable -> safety rearm -> press-brake-specific production initiation`.

Do not invent this sequence if the machine/manifold documentation does not expose it.

## Branch rotation if source-limited

If the hydraulic individual-retention path remains public-source-limited, continue into a professional physical brake/load-retention or accessible-cell implementation that joins final-element fault, physical hazard witness, repair/replacement, functional re-proof, rearm and fresh ordinary start. Preserve machine-specific differences.
