# Checkpoint — exceptional-state persistence / fresh-start boundary

Session start: 2026-09-21T06:33:07Z

## Durable work completed
- Added `safety-course/ROCKWELL_PLANTPAX_BYPASS_AGGREGATION_AND_PRODUCTION_GATE_BOUNDARY_2026-09-21.md`.
- Added `safety-course/ROCKWELL_PLANTPAX_MAINTENANCE_OWNERSHIP_PERSISTENCE_AND_FRESH_START_BOUNDARY_2026-09-21.md`.
- Added `safety-course/25C0_PERSISTENT_MAINTENANCE_STATE_REBOOT_HANDOFF_EXERCISE_2026-09-21.md`.
- Updated `PROGRESS.md`.

## Key evidence gained
Rockwell PlantPAx exposes runtime bypass summary state and explicit maintenance/bypass/physical-mode command semantics. Most importantly, relevant PlantPAx process-instruction documentation states that Maintenance acquired/released state persists through controller powerup and PROG-to-RUN. Reboot is therefore not a defensible generic commissioning-state cleanup procedure.

## Branch decision
The search for a single public universal aggregate `production_clean` implementation is now source-limited. Public evidence supports composing machine-readable ordinary-control evidence, but not claiming a vendor universal cross-class gate. Do not keep searching generic force/bypass tutorials.

## Exact next work
Rotate to a different high-value 25C0/25E0 branch. First preference: authoritative machine/controller examples that distinguish **exception cleanup** from **fresh start/restart authority** after maintenance/service/test mode. Seek evidence that clearing bypass/releasing maintenance/restoring physical mode does not itself become hazardous-motion authority. Preserve the distinction between ordinary production start and independent safety reset/rearm.

If that narrow source path is exhausted, rotate again to another open human-factors/validation branch rather than inventing a universal sequence.

## Compute
No executable lab question justified compute. No GitHub-hosted runner used. `LAB_COMPUTE_LOG.md` unchanged.
