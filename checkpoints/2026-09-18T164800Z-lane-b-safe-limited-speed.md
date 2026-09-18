# Checkpoint — Lane B safe limited speed / setup-motion authority

Date: 2026-09-18

## Durable work

Created `safety-course/SAFE_LIMITED_SPEED_SETUP_MODE_MOTION_AUTHORITY_STUDY_2026-09-18.md` in commit `df0b124773fa4ab4afbbc56ce458a6c3f5db038b`.

## Parallel-work check

Before selection, the newest primary durable work was the linked-line E-stop span/propagation/final-element witness branch (`b75702197c99541285de4f44ee3fc626b94291a9`, with later log append `b38839b2b905bba4a3c3b5b3ced6cc4164c9129a`). Lane B deliberately selected a different module/evidence package and a new file: safe limited speed and setup-motion authority.

Immediately after the substantive commit, current main was re-read. `df0b1247` was directly above `b38839b2`; no intervening overlapping write appeared. Shared `PROGRESS.md` was deliberately not rewritten in order to minimize collision risk.

## Evidence gain

Manufacturer evidence from Pilz, Rockwell, and SICK supports separating SLS, standstill/SOS, STO/SS1, direction monitoring, ordinary motion command, and the physical final-element reaction. It also supports an architecture where safety-relevant speed evaluation is independent of the ordinary machine-motion controller.

## Freeze

`SETUP MODE SELECTED != SLS ACTIVE/VALID != ACTUAL SPEED WITHIN LIMIT != SAFE DIRECTION/POSITION ESTABLISHED != MOTION COMMAND AUTHORIZED != PHYSICAL MOTION SAFE.`

`ORDINARY LINUXCNC VELOCITY LIMIT != SAFELY LIMITED SPEED.`

`SLS LIMIT VIOLATION DETECTED != HAZARD ALREADY ABSENT != FINAL ELEMENT REACTED != SAFE STATE PROVEN != RESET/REARM AUTHORIZED != FRESH ORDINARY START.`

## Provenance status

Manufacturer behavior is tagged SOURCE-CONFIRMED in the study. OpenPressBrake-specific safety speed, sensing, stop reaction, hydraulic/gravity behavior, performance level and timing remain UNKNOWN. No TEST-CONFIRMED claim was created.

## Compute

No executable verification was justified. No GitHub-hosted runner and no self-hosted compute were consumed.

## Exact next work

Find a professional press/press-brake or comparably hazardous setup-mode implementation exposing:

`mode selection -> safeguard reduction/suspension -> enabling/jog intent -> independent SLS/SDI/SOS witness -> safety evaluator -> limit violation -> safe stop/reaction -> physical final-element witness -> fault latch -> reset/rearm -> separate fresh motion intent`.

Prefer a source with an overspeed, sensor-disagreement, or invalid-motion-witness commissioning test. Preserve UNKNOWN wherever public evidence stops.