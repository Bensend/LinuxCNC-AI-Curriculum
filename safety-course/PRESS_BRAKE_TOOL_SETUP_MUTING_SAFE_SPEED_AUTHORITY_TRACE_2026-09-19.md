# Press-brake tool-setup muting / safe-speed authority trace

Date: 2026-09-19

## Purpose

Connect the generic setup-mode authority model to an actual press-brake safeguarding implementation without inventing OpenPressBrake-specific values or treating muting as equivalent to safety removal.

## Lazer Safe Sentinel Plus / Defender evidence

**DOC-CONFIRMED.** Lazer Safe's Sentinel Plus press-brake guarding manual documents a Tool Set-up Mode in which the laser remains on but optical protection is disabled/muted. The manual explicitly warns that this is not optical protection. It nevertheless retains a separate speed-monitoring boundary: if the machine is capable of high-speed closing in Tool Set-up Mode, speed monitoring is disabled only while the sensors are clear; an obstruction immediately re-enables speed monitoring. The operator-training section requires this distinction to be explained.

The same manual's Restricted Mode distinguishes machines that cannot provide the normal dual-speed behavior. The operator must reduce closing speed below the system's documented restricted-mode criterion when setting the mute point; this numerical value belongs to that Lazer Safe configuration and is **not transferable** to another press brake.

Lazer Safe's Defender manual independently states that where a machine cannot close at safe speed, a condition that requires safe speed causes an overspeed error and E-stop; restricted options prohibit conditions that would otherwise rely on safe-speed closing until the tools are opened and the forcing condition is cleared.

Lazer Safe's current Sentinel Plus product material describes AutoSense as monitoring machine control commands, motion, direction, speed, and stopping performance in real time, reinforcing that the safeguarding system does not treat a normal control command as sufficient proof of physical motion behavior.

Sources:
- Lazer Safe, `Sentinel Plus Press Brake Guarding System Operation Manual`, LS-CS-M-073, rev. 1.10, released 2021-09-03.
- Lazer Safe, `Defender Press Brake Guarding System Operation Manual`, LS-CS-M-069.
- Lazer Safe, Sentinel Plus product page / AutoSense description.

## Authority decomposition

The press-brake evidence supports:

`TOOL SET-UP MODE SELECTED != OPTICAL PROTECTION ACTIVE`

`OPTICAL PROTECTION MUTED != ALL SAFETY MONITORING MUTED`

`SENSORS CLEAR != HIGH-SPEED CLOSING UNIVERSALLY SAFE`

`SAFE-SPEED REQUIREMENT PRESENT != NORMAL CONTROL COMMAND CAN OVERRIDE IT`

`COMMAND REQUESTS LOW SPEED != ACTUAL RAM SPEED PROVED WITHIN LIMIT`

`MUTING CONDITION CLEARED != STOPPING PERFORMANCE CURRENTLY VALID != PRODUCTION AUTHORITY`

The important architecture lesson is that **muting is function-specific**. A validated system may intentionally suspend one protective function while retaining or conditionally reasserting another safety function. Treating a single `safety_bypass` bit as authority to defeat all safety functions would erase this distinction.

## Failure-path lesson

In the documented Lazer Safe behavior, inability to satisfy the required safe-speed condition is not converted into permission to proceed at ordinary speed. The Defender restricted-mode description instead produces overspeed/E-stop or prohibits the condition that would require safe-speed closing. This is a strong fail-safe design pattern:

**REQUIRED SUBSTITUTE SAFETY CONDITION UNAVAILABLE -> REMOVE/REFUSE MOTION AUTHORITY, NOT SILENTLY DEGRADE TO NORMAL CONTROL.**

## Boundary to ordinary LinuxCNC / FPGA control

**INFERENCE.** LinuxCNC or an ordinary FPGA may participate in requested ram speed, tool-setup sequencing, or diagnostics, but personnel-protection authority for optical muting, safe-speed enforcement, stopping-performance acceptance, and protective stop must remain in the validated independent safety architecture. A normal-control request for reduced speed cannot itself prove safe reduced speed.

This does not prescribe Lazer Safe hardware for OpenPressBrake and does not claim its numerical thresholds, muting geometry, timing, stopping distance, PL/SIL/category/DC, or hydraulic architecture apply to another machine.

## Human factors

Tool setup is exactly the kind of task in which a safeguard that constantly obstructs legitimate setup work invites defeat. A designed setup mode can make the safer path easier by providing explicit, bounded muting while retaining substitute monitoring. The UI must make the loss of optical protection unmistakable; a lit laser is not evidence that optical protection is active.

## Durable freeze

**TOOL-SETUP MODE != OPTICAL PROTECTION. MUTING ONE SAFETY FUNCTION != MUTING ALL SAFETY FUNCTIONS. COMMANDED SAFE SPEED != PHYSICALLY MONITORED SAFE SPEED. SUBSTITUTE SAFETY FUNCTION UNAVAILABLE != PERMISSION TO CONTINUE UNDER ORDINARY CONTROL.**

Also preserve:

**LASER ON != OPTICAL PROTECTION ACTIVE.**

## Remaining UNKNOWN

The public evidence used here does not establish a complete post-tool-setup return sequence through normal optical-field restoration, personnel-clear proof, safety reset/rearm, and fresh production initiation. It also does not answer the separate hydraulic service question concerning unmasked proof of an individual retaining valve after replacement.

## Next work

Continue the return-to-normal lane with an authoritative implementation exposing setup/muting exit -> optical/guard protective function restored and proved -> required stop-performance state valid -> safety rearm -> fresh ordinary production initiation. Keep the hydraulic retaining-valve service/re-proof lane primary when new OEM evidence is available.

No executable lab was justified. No GitHub-hosted or self-hosted compute was used.
