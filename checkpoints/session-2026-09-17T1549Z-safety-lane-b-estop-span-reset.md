# Safety curriculum checkpoint — Lane B E-stop span/reset/restart boundary

Date: 2026-09-17

## Parallel-work check

Read current governance/progress and recent commits before selection. Primary newest durable work at session start was `f1e5008` covering robot-zone authority plus pneumatic safe-exhaust/load-holding proof, with hydraulic load-holding/blocking-valve proof as its precise next branch. Lane B deliberately did not take robot-zone, pneumatic, or hydraulic load-holding work.

Immediately before checkpointing, current main was re-read. `a80ba211` (this lane's artifact) was still directly above `f1e5008`; no intervening primary-lane or overlapping-file change appeared.

## Durable work

Commit `a80ba211` adds `safety-course/EMERGENCY_STOP_SPAN_OF_CONTROL_RESET_RESTART_BOUNDARY_STUDY_2026-09-17.md`.

Evidence gain:
- SOURCE-CONFIRMED Pilz guidance preserves the emergency-stop boundary as a complementary protective measure and separates E-stop from complete emergency switching-off / energy isolation.
- SOURCE-CONFIRMED Pilz guidance, citing DIN EN ISO 13850, states that the actuated E-stop device is intentionally reset at that device and that reset must not itself restart the machine.
- SOURCE-CONFIRMED Schmersal product documentation provides an inspectable example where different safety demands intentionally produce different enabling-path shutdown behavior, supporting hazard-specific response reasoning without inventing an OpenPressBrake span of control.
- Frozen state distinction: `E-STOP DEVICE RELEASED != SAFETY FUNCTION RESET != ORDINARY CONTROL REARMED != START COMMAND != HAZARDOUS MOTION`.
- Added a machine-specific span-of-control evidence matrix and ten failure-path challenges, including ambiguous span, stale LinuxCNC/HAL/FPGA commands, reset-as-start, HMI acknowledgement overclaim, invisible restart area, energy-state overclaim, cross-zone common cause, and misuse of E-stop as servicing isolation.

## Deliberate UNKNOWNs

No OpenPressBrake E-stop placement/span, safety logic, final elements, STO behavior, hydraulic behavior, ram behavior, reset location, stopping value, pressure threshold, PL/SIL/DC or acceptance threshold was invented.

## Compute

None. Source/documentation work resolved the question; no executable verification was justified. No GitHub-hosted Actions compute was used.

## Precise next independent work

Trace protective-device demand versus E-stop demand in one complete professional machine/cell implementation: identify where guard/light-curtain response legitimately differs from E-stop, which final elements differ, and how reset/restart remains separated. Prefer an OEM/manufacturer package exposing the complete chain. If the primary lane enters that subject first, rotate to safety-function status/diagnostic annunciation and prevention of a single HMI `SAFE` indication from overclaiming multiple physical safety states.