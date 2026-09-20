# Lane B checkpoint — operating-mode selection authority

Date: 2026-09-20

## Completed

Added `safety-course/OPERATING_MODE_SELECTION_ACCESS_AUTHORITY_AND_SAFE_TRANSITION_STUDY_2026-09-20.md` as an independent safety-curriculum lane.

Primary lane was advancing press-brake primary/secondary hydraulic stop physical-witness and periodic-integrity work. Lane B intentionally avoided those files/evidence and selected safety operating-mode selection/access/transition authority.

## Durable freeze

**ACCESS PERMISSION VALID != OPERATING MODE SAFELY SELECTED != EXACTLY ONE MODE VALID != MODE-SPECIFIC SAFEGUARDS VALID != SAFE TRANSITION COMPLETE != SAFETY FUNCTION READY != ORDINARY START REQUEST FRESH != HAZARDOUS MOTION AUTHORIZED.**

**HMI/LINUXCNC MODE DISPLAY != SAFETY-EVALUATED MODE STATE.**

**MODE CHANGE != START.**

## Evidence gained

Pilz: exclusive mode selection, selector-alone-must-not-start, safe evaluation/access permission, revalidation after configuration change.

Rockwell: no-mode and multiple-mode are explicit safety fault states; outputs remain inactive under Fault Present until conditions are corrected and a separate fault-reset transition occurs.

SICK: when safeguards are disabled for setup, automatic/linked motion is suppressed and hazardous motion requires sustained-action/reduced-risk controls; mode change should stop and require a new manual start.

## Compute

No simulation, synthesis, benchmark, or executable verification was justified. No GitHub-hosted runner was used. No self-hosted runner time was consumed.

## Unknowns preserved

OpenPressBrake mode set, selector/access hardware, safety evaluator, transition sequence, mode-dependent safeguards, setup-motion constraints, safe speed/path, PL/SIL/category/DC/CCF, hydraulic behavior, stopping performance, and production-start sequence remain UNKNOWN.

## Exact next Lane-B work

Trace a professional implementation/commissioning procedure through:

`authorized mode request -> exclusive safety-evaluated mode -> no/multiple-mode fault challenge -> motion-inhibited transition -> destination-mode safeguard/compensating-function proof -> stale ordinary-command challenge -> separate fresh deliberate motion request -> final element -> physical machine witness`.

Prefer cold-start and mode-input-fault evidence. Stay independent of whichever hydraulic/stop-path package the primary safety lane is advancing at the next run.