# Lane B checkpoint — three-position enabling-device authority

Date: 2026-09-20

## Completed

Added `safety-course/THREE_POSITION_ENABLING_DEVICE_PANIC_RELEASE_SETUP_AUTHORITY_STUDY_2026-09-20.md`.

Primary lane was re-checked immediately before writing and was advancing hydraulic press-brake two-hand total stop-response / final hydraulic output tracing. Lane B selected a different device family and did not modify the primary lane's files.

## Durable freeze

`SETUP MODE SELECTED != SAFEGUARD SUSPENSION AUTHORIZED != ENABLING DEVICE VALID != DELIBERATE MOTION REQUEST != SAFETY-MONITORED MOTION CONSTRAINTS VALID != FINAL ELEMENT RESPONDED != PHYSICAL MOTION SAFE`

Both release and panic/full-squeeze remove enabling authority. Relaxing from full squeeze must not silently become fresh enable authority. Enabling authority remains separate from production authority and from LinuxCNC/HAL/FPGA ordinary motion commands.

## Evidence

- SOURCE-CONFIRMED: Pilz PITenable uses Off-On-Off three-position operation for danger-zone work with suspended safeguard effect; release or full depression invokes the protective state.
- SOURCE-CONFIRMED: Rockwell GripSwitch application note states center position closes safety contacts, release or further squeeze opens them, and release from fully squeezed does not re-close them; reduced-performance requirements come from risk assessment.
- TEST-CONFIRMED: none this run.
- COMMUNITY-REPORTED: none relied upon.
- UNKNOWN: OpenPressBrake application need, mode architecture, permitted motion, speed/direction/axis constraints, final elements, response/stopping values, hydraulic behavior, PL/SIL/category, and reset/requalification sequence.

## Compute

No executable verification was needed. No GitHub-hosted runner or hosted Actions minutes were used.

## Precise next work

Trace a complete professional implementation:

`mode selector -> safeguard suspension decision -> three-position enabling device evaluation -> separate deliberate jog/hold-to-run -> safety-monitored motion constraint -> release/full-squeeze fault challenge -> actual final element -> physical motion witness -> requalification -> safeguard restoration -> safety rearm -> fresh ordinary production start`

Prefer evidence explicitly covering full-squeeze-to-relax, held-at-power-up/mode-entry, channel fault, or stale motion-command behavior.