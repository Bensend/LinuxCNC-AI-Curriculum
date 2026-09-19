# Safety-course checkpoint — reset/restart/stale-command authority

UTC checkpoint: 2026-09-19T22:51Z

## State

1000, 2000, and 3000 remain graduated/closed. Primary active work remains the 4000 safety course.

The primary hydraulic post-service source trace remains open and source-limited at the same bridge: named press-brake retaining/safety valve service -> unmasked individual retaining challenge -> installed physical ram/load witness -> disposition -> stopping-performance re-proof where applicable -> safety rearm -> fresh production initiation.

This session rotated rather than inventing that missing test and added `safety-course/RESET_RESTART_COLD_START_AND_STALE_COMMAND_AUTHORITY_STUDY_2026-09-19.md`.

## New durable freeze

- HAZARD DEMAND CLEARED != SAFETY RESET PERMITTED != SAFETY RESET COMPLETED != SAFETY FUNCTION READY != ORDINARY START REQUEST FRESH != HAZARDOUS MOTION AUTHORIZED.
- POWER RESTORED != COLD-START SAFETY RESET SATISFIED != ORDINARY CONTROL STATE TRUSTWORTHY != STALE START ABSENT != PRODUCTION AUTHORITY.
- Safety reset must not be treated as an ordinary START command unless a validated architecture explicitly establishes otherwise.
- Ordinary LinuxCNC/FPGA/HMI retained command state must not silently regain hazardous-motion authority when safety is restored.

## Evidence state

SICK: DOC-CONFIRMED reset is part of the safety function; reset must not initiate movement and a separate start is required; reset location must support checking the hazard zone.

Pilz: DOC-CONFIRMED E-stop reset prepares restart and must not itself restart machinery.

Rockwell: DOC-CONFIRMED application architecture separates safety reset from subsequent Start; current safe-motion instructions expose restart type and cold-start type as separate policy choices.

No machine-specific OpenPressBrake reset implementation, timing, PL/category, or stale-command qualification was inferred.

## Next work

1. Briefly retry authoritative press-brake OEM/manifold evidence for the hydraulic post-service bridge.
2. If still source-limited, trace professional commissioning/recommissioning examples that explicitly challenge stale START, power restoration, safety-controller restart, and mode transition.
3. Keep physical final-element proof separate from reset logic and ordinary command-state proof.
4. Do not run compute unless a concrete unresolved question requires it; self-hosted `[self-hosted, openpressbrake]` only.
