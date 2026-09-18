# Lane B checkpoint — three-position enabling-device authority

Date: 2026-09-18

## Durable work completed

Created `safety-course/THREE_POSITION_ENABLING_DEVICE_SETUP_MOTION_AUTHORITY_STUDY_2026-09-18.md` in commit `eaf4122e42ae25d65b21852903a90542c7443cd9`.

This branch is independent of the primary gravity-axis brake/retaining-proof work and of Lane B's preceding press-brake dynamic-muting trace.

## Frozen lesson

Do not collapse `SETUP MODE SELECTED`, `SAFEGUARD SUSPENSION AUTHORIZED`, `THREE-POSITION DEVICE VALID`, `SAFETY SETUP-MOTION PERMISSIVE`, `SEPARATE JOG/START INTENT`, `FINAL ELEMENT ACTUATED`, and `PHYSICAL HAZARDOUS MOTION` into one enable bit.

Manufacturer evidence supports Off-On-Off three-position behavior and, critically, that enabling-device actuation alone must not initiate machine start. Release and full squeeze are both protective transitions. SICK also documents that relaxation from position 3 toward position 2 must not itself restore enabling authority.

## Provenance status

- Pilz PITenable Off-On-Off behavior and danger-zone/setup use: DOC-CONFIRMED.
- SICK E100/Guide enabling behavior, separate start principle, 3->2 rule, manipulation concern: DOC-CONFIRMED.
- Rockwell 440J dual independent three-position implementation: DOC-CONFIRMED.
- LinuxCNC/HAL not being sole personnel-safety enabling authority: INFERENCE.
- OpenPressBrake mode, permissible setup motion, speed/force, stopping performance, hydraulic response, channel discrepancy behavior, reset/rearm and achieved PL/SIL/category/DC: UNKNOWN.
- TEST-CONFIRMED physical OpenPressBrake evidence: none.
- COMMUNITY-REPORTED evidence used: none.

## Compute

No simulation, synthesis, benchmark or executable verification was justified. No GitHub-hosted runner was used and no hosted Actions minutes were consumed.

## Parallel-work check

Immediately before the substantive write, current main still ended at Lane B checkpoint `75075f7`; after the substantive write, `eaf4122` was directly on top. No intervening overlapping file changed, so no reconciliation or branch switch was required.

## Precise next Lane-B work

Find a complete professional application/manual exposing:

`mode selection -> guard/protective suspension -> three-position enabling device -> safety evaluation -> separate jog/start -> safe-motion/final-element authority -> release/full-squeeze stop -> reset/rearm`.

Prefer evidence that also exposes enabling-channel disagreement, transition from position 3 back toward 2, manipulation/defeat prevention, and power-cycle recovery. Do not infer OpenPressBrake values or topology from the example. If the primary lane enters enabling/setup-mode work before the next Lane-B run, rotate to another independent open safety branch rather than duplicating it.