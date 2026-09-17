# Lane B safety checkpoint — reset visibility / restart authority — 2026-09-17

- Status: CHECKPOINTED — safety course remains active.
- Parallel-work status: independent of the primary lane's asymmetric power-restoration retained-state work at session start.
- Compute: NONE. Documentation/source-tracing only; no GitHub-hosted Actions minutes and no self-hosted runner work because executable verification was not justified.

## Durable work completed

Added `safety-course/RESET_DEVICE_LOCATION_VISIBILITY_AND_RESTART_AUTHORITY_STUDY_2026-09-17.md`.

The study freezes the distinction:

`PROTECTIVE DEVICE CLEAR != HAZARD ZONE VERIFIED CLEAR != RESET ACCEPTED != SAFETY AUTHORITY AVAILABLE != ORDINARY CONTROL REARMED != START COMMAND != MOTION`.

It converts manufacturer restart-interlock guidance into a practical architecture/failure-path worksheet covering reset location, line of sight, stand-behind conditions, operation from inside the danger zone, reset input edge/stuck-state behavior, shared/multi-zone reset span, HMI/remote reset, maintenance personnel, and stale LinuxCNC/HAL/FPGA commands.

## Evidence status

- DOC-CONFIRMED: SICK deTec4/C4000 restart-interlock guidance separates reset from machine START and places reset outside the hazardous area; C4000 guidance requires full visual command of the hazardous area from the reset position.
- DOC-CONFIRMED: Pilz muting guidance requires visibility of the danger zone/muting station from reset/override controls and clearance before operation.
- DOC-CONFIRMED: Pilz E-stop guidance separates release/reset from restart and identifies visibility/span as a risk-assessment issue.
- INFERENCE: OpenPressBrake should treat reset physical placement and visibility as part of the complete safety-function interface, while ordinary LinuxCNC/HAL/FPGA reset/rearm remains separate from personnel-safety authority.
- UNKNOWN: actual OpenPressBrake reset locations, hazard-zone visibility, rear/side access, guard/light-curtain geometry, reset span, edge semantics, and presence-sensing requirements.

## Main re-read / overlap check

Immediately before durable write, `main` ended at `5175d195` (`checkpoint: finalize asymmetric power restoration timing`). Immediately after the study commit, `main` ended at Lane-B commit `6465ad11` directly above `5175d195`; no overlapping primary-lane commit appeared during the write.

## Precise next work

Find a complete professional machine/cell package exposing `protective demand -> stop -> stand-behind/presence condition -> reset location/visibility -> safety reset -> separate ordinary START -> physical final-element re-enable`. Prefer OEM drawings/manuals that expose the physical reset station and final elements together. If the primary lane reaches that evidence package first, rotate to trapped-person/presence-sensing restart prevention or multi-zone reset-span validation rather than duplicating it.
