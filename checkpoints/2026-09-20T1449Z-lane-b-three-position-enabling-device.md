# Lane B checkpoint — three-position enabling-device recovery authority

Date: 2026-09-20
Durable work: `safety-course/THREE_POSITION_ENABLING_DEVICE_RELEASE_SQUEEZE_AND_REENTRY_AUTHORITY_STUDY_2026-09-20.md`
Commit: `d62543ac2291b1d68bc5fa3bcbf951bc2f2ef3a4`

## Parallel-lane disposition

Immediately before selection, current main showed the primary lane advancing press-brake stop-time lifecycle and setup-mode safe-speed/acceptance-timeout evidence. Lane B did not edit those files. This checkpoint isolates a different evidence artifact: the three-position enabling device's human-held off-on-off transition/recovery state machine.

## Durable freezes

- **ENABLING DEVICE PRESENT != VALID MIDDLE POSITION != MOTION COMMAND PRESENT != HAZARDOUS MOTION AUTHORIZED.**
- **POSITION 3 -> POSITION 2 != RE-ENABLE.**
- **POSITION 1 -> POSITION 2 != MACHINE START BY ITSELF.**
- **RELEASED ENABLE != ORDINARY SAFEGUARD RESTORED != SETUP MODE EXITED != PRODUCTION AUTHORITY.**
- **LINUXCNC/HAL ENABLE BIT != PERSONNEL-SAFETY AUTHORITY.**

## Evidence gained

Manufacturer material from SICK and Pilz confirms off-on-off behavior, release/full-squeeze protective behavior, SICK's explicit prohibition on reactivation while returning from position 3 through position 2, separation of enabling permission from machine start, and the multiple-person enabling-device requirement where multiple people occupy the hazard zone.

No OpenPressBrake speed, stopping time, guard bypass, hydraulic behavior, safety performance level, or other machine-specific physical fact was invented.

## Compute

No executable verification was justified. No GitHub-hosted compute was used.

## Exact next work

Seek a complete manufacturer/OEM acceptance sequence that physically challenges release, panic/full-squeeze, 3->2 non-reactivation, and a held jog/inch command, then demonstrates deliberate recovery, setup exit, safeguard restoration/requalification, and separate production restart. If the primary lane begins the same evidence package, switch Lane B to another open safety branch rather than duplicating it.