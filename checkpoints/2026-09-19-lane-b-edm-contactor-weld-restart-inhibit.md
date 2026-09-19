# Lane B checkpoint — EDM / contactor weld / restart inhibit

Date: 2026-09-19

## Durable work completed

Created `safety-course/EDM_FORCIBLY_GUIDED_CONTACTOR_WELD_RESTART_INHIBIT_STUDY_2026-09-19.md` at commit `f369391eea4bb494ad023b82265e576f8c571957`.

Lane selection was intentionally independent of the primary lane's newest durable escape-release recommission work and its hydraulic individual-retention source branch. No shared safety module or primary evidence artifact was edited.

## Frozen lesson

`SAFETY OUTPUT OFF != CONTACTOR COIL DE-ENERGIZED != CONTACTOR MAIN POLES OPEN != HAZARDOUS POWER REMOVED != PHYSICAL HAZARD SAFE`

`FORCIBLY GUIDED CONTACTS != FAULT PREVENTION`

`EDM / FEEDBACK LOOP HEALTHY != PHYSICAL STOP PERFORMANCE PROVED`

`RESET REQUEST != EDM VALID != SAFETY OUTPUT RE-ENERGIZED != ORDINARY MOTION AUTHORITY`

Manufacturer evidence from Omron and Schneider supports external-device feedback/self-monitoring and restart inhibition after detected switching-device faults while preserving the distinction between feedback state and actual physical hazardous-energy disposition.

## Compute

No simulation, synthesis, benchmarking, or executable verification was justified. No GitHub-hosted or self-hosted runner compute was consumed.

## Explicit UNKNOWNs

OpenPressBrake contactor topology, credited energy-isolation function, reset policy, proof interval, diagnostic coverage, PL/SIL/category/DC/CCF, and physical stop behavior remain UNKNOWN and must not be inferred from manufacturer examples.

## Precise next Lane-B work

Find a complete professional implementation or validation procedure exposing:

`protective demand -> safety output OFF -> redundant external switching elements -> individual/meaningful feedback -> deliberate welded/stuck-device fault -> restart inhibited -> repair/replacement -> feedback/function re-proof -> physical hazardous-energy or motion witness -> safety rearm -> application-specific ordinary production command`.

Prefer evidence that explicitly injects a welded contactor or feedback fault and documents the required post-replacement return-to-service proof.