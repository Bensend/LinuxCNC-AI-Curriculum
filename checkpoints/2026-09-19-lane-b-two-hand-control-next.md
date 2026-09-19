# Lane B checkpoint — two-hand control authority

Date: 2026-09-19

## Durable work

Added `safety-course/TWO_HAND_CONTROL_SIMULTANEITY_ANTIREPEAT_RELEASE_AUTHORITY_STUDY_2026-09-19.md`.

Primary lane was advancing reset/EDM and physical standstill witness work; Lane B deliberately selected a different module/evidence package and did not modify the primary files.

## Frozen boundaries

`BUTTON A ACTIVE + BUTTON B ACTIVE != VALID TWO-HAND DEMAND`

`VALID TWO-HAND DEMAND != OPERATOR CANNOT REACH HAZARD`

`ONE BUTTON RELEASED THEN REPRESSED WHILE OTHER REMAINS HELD != VALID RESTART`

`TWO-HAND SAFETY OUTPUT TRUE != ORDINARY PROCESS COMMAND FRESH != FINAL ELEMENT RESPONDED != PHYSICAL MOTION SAFE`

Professional Rockwell and Schneider evidence supports transition-history, simultaneity, continuous-actuation/release, and anti-repeat distinctions. Rockwell additionally exposes separation between two-hand safety authority and an external process start in one implementation.

## Compute

No executable verification was justified. No GitHub-hosted or self-hosted compute was consumed.

## OpenPressBrake unknowns preserved

No two-hand-control requirement, timing, physical placement, safe distance, stop time/distance, final-element topology, reset policy, PL/SIL/category/DC/CCF, or press-brake-specific restart semantics were assigned.

## Precise next Lane-B work

Seek a complete professional press/press-brake or comparable hazardous-cycle implementation exposing `two-hand devices -> independent safety evaluator -> simultaneity/anti-repeat -> external final elements -> release during hazardous motion -> measured physical stopping/reach witness -> failed final-element or button diagnostic -> inhibited restart -> correction/re-proof -> machine-specific production reauthorization`.

Prefer OEM/manufacturer wiring plus validation evidence. If the physical stop/reach witness remains unavailable, preserve it as UNKNOWN and rotate to another independent open safety evidence gap rather than inventing values.
