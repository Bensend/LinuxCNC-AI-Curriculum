# Checkpoint — demand freshness frozen; rotate safety branch

## Completed
Authoritative PlantPAx evidence now shows that command-source transfer can deliberately retain/track state for bumpless transfer. Therefore authority change is not a generic sanitization event and cannot be assumed to create a fresh production demand.

Added:
- `safety-course/ROCKWELL_COMMAND_SOURCE_BUMPLESS_TRANSFER_RETAINED_DEMAND_AND_STALE_START_BOUNDARY_2026-09-21.md`
- `safety-course/25C0_DEMAND_FRESHNESS_AUTHORITY_TRANSITION_REVIEW_EXERCISE_2026-09-21.md`

`PROGRESS.md` now treats demand freshness as a separate state-machine review property.

## Freeze
- COMMAND SOURCE NOT SELECTED != ITS SETTINGS ERASED.
- BUMPLESS TRANSFER != FRESH START.
- AUTHORITY TRANSITION != STATE SANITIZATION.
- SAFETY RESET != START COMMAND.
- AUTHORITY RESTORED != OLD MOTION DEMAND FRESH.

## Exact next work
Rotate away from generic PlantPAx internals. Select the highest-value open 25C0/25E0 professional safety implementation that exposes a different return-to-service, validation, diagnostic, maintenance-bypass, or restart human-factors failure surface. Prefer complete machine/OEM implementation evidence over another isolated component tutorial.

Preserve independent safety authority and do not invent machine-specific performance criteria.

## Compute
No executable question justified compute; no GitHub-hosted runner used.
