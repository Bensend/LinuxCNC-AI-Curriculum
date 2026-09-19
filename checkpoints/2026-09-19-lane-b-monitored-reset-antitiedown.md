# Lane B checkpoint — monitored reset anti-tiedown / restart authority

Date: 2026-09-19

## Durable work completed

Created `safety-course/MONITORED_RESET_ACTUATOR_ANTITIEDOWN_RESTART_AUTHORITY_STUDY_2026-09-19.md` at commit `00b5b243a16201581bb092a6e3d33a610c69b1fa`.

Lane selection was intentionally independent of the primary lane's newest safety-related component replacement, hydraulic retention, stopping-performance, and machine-level revalidation work. No shared primary safety artifact was edited.

## Frozen lesson

`PROTECTIVE CONDITION RESTORED != RESET ACTUATOR HEALTHY != VALID RESET TRANSITION OBSERVED != SAFETY OUTPUTS REARMED != FINAL ELEMENT PROVED != HAZARD AREA CLEAR != ORDINARY START AUTHORITY`

`RESET HELD/TIED DOWN != VALID MONITORED RESET`

`RESET ACCEPTED != START COMMAND`

Rockwell, Pilz, and Schneider manufacturer evidence confirms that monitored reset/start semantics deliberately require an edge/change-of-state rather than treating RESET as a static Boolean permission. Rockwell specifically identifies the change of state as protection against a bypassed/blocked/tied-down reset actuator and distinguishes this from unmonitored manual reset.

## Compute

No simulation, synthesis, benchmarking, or executable verification was justified. No GitHub-hosted or self-hosted runner compute was consumed.

## Explicit UNKNOWNs

OpenPressBrake reset topology, device, edge semantics, timing, location, personnel-clear requirement, EDM/final-element topology, automatic-reset permissions, PL/SIL/category/DC/CCF, hydraulic state, pressure and stopping performance remain UNKNOWN.

## Precise next Lane-B work

Find a complete professional implementation or commissioning procedure exposing:

`protective demand -> safety outputs off -> external switching/final-element feedback -> reset held/tied down or shorted -> monitored reset refuses rearm -> fault corrected -> deliberate valid reset transition -> safety outputs rearm -> physical final-element/safe-state witness -> application-specific fresh ordinary START`.

Prefer a source that visibly distinguishes reset anti-tie-down from EDM and ordinary process start and includes a stuck/shorted reset fault-injection test.