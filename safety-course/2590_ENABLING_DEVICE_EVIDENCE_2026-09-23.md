# 2590 — Enabling-device evidence note

## Why this exists

Enabling devices are often misunderstood as a maintenance bypass button. This note bounds the proposition with current manufacturer evidence.

## Three-position behavior

`DOC-CONFIRMED`: Pilz PITenable documentation describes a three-level enabling switch with `Off-On-Off` behavior. Its middle position enables the defined function while the protective effect of movable guards is suspended; releasing it or fully pressing it returns to a protective state and brings the machine to a standstill under the documented application architecture.

`DOC-CONFIRMED`: Rockwell Guardmaster 440J documentation describes an enabling switch as a manually operated device used with a start control. Continuous actuation allows machine operation; non-actuation initiates a stop command. Its three-position mechanism opens both when the operator relaxes and when the operator contracts/squeezes through the middle position. The 440J uses two independent three-position switches and is presented as part of the conditions for safe work inside a machine guard.

Teaching consequence: the meaningful proposition is not `button held = safety bypass`. It is a deliberately maintained, monitored enabling state within a separately defined restricted operating mode.

## Mode selection boundary

`DOC-CONFIRMED`: Pilz operating-mode guidance states that where different modes/control sequences require different safety levels, each selector position should exclusively enable one operating mode; operating the selector alone must not initiate machine operation; and the selected mode overrides other control functions except emergency stop/off.

Therefore the enabling device does not itself establish:

- which operating mode is active;
- what motion, speed, force or energy is permitted in that mode;
- that the operator has visibility/control of all hazards;
- that other persons are excluded;
- that a separate start/jog command is valid;
- maintenance energy isolation.

Exact machine-specific setup speeds, forces, motion envelopes and integrity targets remain `UNKNOWN` until the applicable machine/product standard and risk assessment establish them.

## Defeat and human factors

A three-position device is designed to respond to both release and over-squeeze, but this does not make defeat impossible. Adversarial review must include taping/clamping the device in the middle position, confusing or tiring ergonomics, a second person entering the zone, an unrestricted jog command, mode-selection faults, retained commands, and recovery after power interruption.

Freeze: **ENABLING MIDDLE POSITION != UNRESTRICTED MOTION AUTHORITY.**

Freeze: **THREE-POSITION DEVICE != COMPLETE SETUP-MODE SAFETY FUNCTION.**

Freeze: **MODE SELECTED != MOTION START AUTHORIZED.**

## Evidence provenance

- Pilz, `PITenable` enabling switch product/application page, surfaced 2026-09-23: three-level Off-On-Off behavior and use where movable-guard protection is suspended.
- Rockwell Automation, `440J Grip Enabling Switches` and `Emergency Stop Devices Technical Data` (440-TD001), surfaced 2026-09-23: dual three-position grip construction, mid-position contact behavior, release/over-squeeze behavior and use with start control.
- Pilz, operating-mode selector guidance, surfaced 2026-09-23: exclusive mode selection, selector alone not initiating operation, and mode-priority boundary.
