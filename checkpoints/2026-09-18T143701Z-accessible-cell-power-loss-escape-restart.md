# Checkpoint — accessible-cell power-loss / escape / restart authority

Session: 2026-09-18T14:36:00Z to 2026-09-18T14:37:01Z (1.02 min)

## Durable result

Created `safety-course/ACCESSIBLE_CELL_POWER_LOSS_ESCAPE_RESTART_AUTHORITY_TRACE_2026-09-18.md`.

New freeze: **POWER RESTORED != GUARD READY != GUARD CLOSED != GUARD LOCKED != PERSONNEL CLEAR != SAFETY RESET != PRODUCTION START.**

New freeze: **ESCAPE RELEASE RESTORED != PERSONNEL-CLEAR PROOF.** Closing and locking must not automatically restart hazardous motion; authoritative EUCHNER instructions require a separate start command.

EUCHNER BiState evidence adds a useful power-cycle distinction: loss of power does not imply one universal lock state. Bistable guard locking can preserve the previous state, preventing an already locked guard from being released while also avoiding accidental trapping when the machine loses power with the door open. Commissioning therefore must challenge power loss from both states.

Pilz evidence remains independent corroboration for restart prevention while personnel remain registered inside. Do not represent the cited EUCHNER and Pilz products as one certified system.

## Compute

No simulation, build, synthesis, benchmark or test-suite compute used. No GitHub-hosted runner used. `TIMING_APPEND_REQUEST.txt` was updated to invoke the repository's race-safe append workflow, which targets `[self-hosted, openpressbrake]`.

## Overlap

Prior Lane-B accessible-cell/guard-locking work existed. This run extended it with power-loss-state and escape-restoration authority rather than overwriting the existing artifact.

## Exact next work

Find a complete professional accessible-cell implementation exposing `safe-entry proof -> unlock -> bodily entry -> restart prevention -> escape behavior -> personnel clear -> close/relock -> safety reset/rearm -> separate fresh production START`, including power-cycle recovery where public documentation exposes it. Preserve machine-specific safe-state/energy-discharge UNKNOWN. If source gain stops, rotate to the two-retaining-element failure-disposition branch.
