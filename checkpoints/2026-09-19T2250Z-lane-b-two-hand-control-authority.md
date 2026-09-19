# Safety-course Lane-B checkpoint — two-hand control authority

Date: 2026-09-19

## Parallel-lane check

Before selection, Lane B re-read the standing curriculum authority files, current progress, recent commits, and the newest primary-lane checkpoint. Primary work is on reset/restart/cold-start/stale ordinary command authority plus the still-open hydraulic post-service proof bridge. Lane B therefore selected a separate evidence family and new file: two-hand control, anti-tiedown, and multi-operator concurrence.

## Durable work

Added `safety-course/TWO_HAND_CONTROL_ANTI_TIEDOWN_MULTI_OPERATOR_AUTHORITY_STUDY_2026-09-19.md`.

Freeze:

**ONE BUTTON ACTIVE != TWO HANDS VALID != SIMULTANEITY VALID != ANTI-TIEDOWN SATISFIED != ALL REQUIRED OPERATORS VALID != SAFETY FUNCTION ENABLED != PHYSICAL HAZARD SAFE != PRODUCTION AUTHORITY.**

**TWO-HAND OUTPUT TRUE != ORDINARY LINUXCNC START FRESH != FINAL ELEMENT RESPONDED != HAZARDOUS MOTION SAFE.**

**ONE OPERATOR VALID != EVERY EXPOSED OPERATOR PROTECTED.**

## Evidence state

- SICK: DOC-CONFIRMED one two-hand device protects one person; multi-operator exposure requires separate operator controls/concurrence; release demands stop; synchronism and defeat-resistant placement are part of the protective architecture.
- SICK Flexi Soft: DOC-CONFIRMED Multi operator logic and cycle-request release requirement; Reset/Restart remain independent.
- Rockwell GuardLogix THRS: DOC-CONFIRMED tie-down detection and both-buttons-safe cycling before a new valid result.
- Rockwell Machinery Safebook: DOC-CONFIRMED concurrent operation, continuous actuation during hazardous condition, release stop, and anti-tiedown release-before-restart concept.
- Pilz PNOZsigma: DOC-CONFIRMED dedicated safety monitoring hardware with dual-channel/simultaneity behavior.

No OpenPressBrake two-hand-control requirement, station geometry, safety distance, stop time, hydraulic response, PL/category/SIL, or multi-operator arrangement was inferred.

## Compute

No executable verification was justified. No hosted compute was used.

## Precise next Lane-B work

Find a complete professional press implementation exposing `operator station(s) -> dual-channel two-hand inputs -> simultaneity/anti-tiedown evaluator -> multi-operator concurrence if applicable -> independent safety output -> actual press final element -> physical release/stop witness -> both-controls-released requalification -> separate fresh production initiation`, preferably with a commissioning/fault procedure.