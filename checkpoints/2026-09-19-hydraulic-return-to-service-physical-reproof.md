# Checkpoint — hydraulic return-to-service / physical re-proof — 2026-09-19

## Completed

Created `safety-course/HYDRAULIC_PRESS_BRAKE_RETURN_TO_SERVICE_PHYSICAL_REPROOF_TRACE_2026-09-19.md` at commit `fcbe4a4d3bd5bc9a12a287f5a086fc33461d089b`.

## Evidence gain

Official CINCINNATI 60 AUTOFORM service documentation exposes a real press-brake sequence separating ram support, main-drive stop, padlocked electrical isolation, trapped-pressure measurement/bleed, post-maintenance closure of bleed paths, energy restoration, deliberate drive start and deliberate RAM UP motion. The same machine identifies a safety dump valve and a separate dumping-valve safety switch. Its counterbalance procedure requires checking both sides and rechecking both after cycling.

This closes part of the previous gap between monitored-valve disagreement and physical return-to-service proof without pretending that controller state or one valve switch proves pressure/load/motion safety.

## Durable freeze

`FAULT CLEARED IN SOFTWARE != FAILED HYDRAULIC ELEMENT REPAIRED != STORED PRESSURE CONTROLLED != RAM/LOAD PHYSICALLY SECURED != REQUIRED HYDRAULIC PROPERTY RE-PROVED != SAFETY FUNCTION REVALIDATED != SAFETY REARMED != FRESH PRODUCTION START`.

`FINAL-ELEMENT SWITCH AGREEMENT != PHYSICAL PRESSURE PROOF != RAM/LOAD-SAFE PROOF`.

No OpenPressBrake hydraulic topology, threshold, stop time, PL/SIL/category/DC, proof interval, or degraded-production mode was invented.

## Compute

No executable question justified compute. No GitHub-hosted or self-hosted compute was consumed.

## Precise next work

Find a same-machine modern press-brake/OEM/service implementation that exposes the remaining chain:

`individual monitored valve disagreement -> exact physical ram/load-safe disposition -> latched fault -> component repair/replacement -> exact valve/restraint/stop-performance re-proof -> safety reset/rearm -> separate fresh production initiation`.

Prioritize a source that explicitly states the test/examination required after replacement of a safety-affecting hydraulic component. If that exact evidence remains unavailable, rotate to the two-retaining-element post-service proof branch or safety-network physical-final-element branch rather than inventing the missing sequence.
