# Session Checkpoint — Lane B Contactor / EDM / Backfeed Boundary

Date: 2026-09-17
Lane: independent safety curriculum Lane B

## Parallel-work check

At selection time `main` ended at `57ad6ef4` (`checkpoint: safety STO release and pulse receiver contract`). That primary checkpoint explicitly selected monitored hydraulic safety-valve/fall-protection evidence as its next branch. Lane B therefore avoided hydraulic/fall-protection files and selected the independent external-contactor/EDM/backfeed boundary.

Immediately before the durable Lane-B write, main was re-read and still ended at `57ad6ef4`. After the study commit, main ended at `65498b32` directly above that primary checkpoint; no intervening overlapping commit appeared.

## Durable work

Added:

- `safety-course/INTERPOSING_CONTACTOR_EDM_BACKFEED_FAILURE_BOUNDARY_STUDY_2026-09-17.md`
- commit `65498b3297b6a5570b06310a16a2bb901413fe43`

Manufacturer evidence used:

- Pilz myPNOZ application note 1005677-EN-02: external contactor N/C feedback, restart inhibition, two-actuator example, safety-output short-to-24-V detection/second shutdown route, periodic semiconductor off-tests.
- SICK Flexi Soft Safety Designer 8014519/T157/2025-07-30: EDM block controls external contactors, compares feedback against command, faults on failed/inconsistent switching.
- Pilz PNOZ 16S 1003518-EN-12: explicit feedback/start-loop short-circuit diagnostic blind spot and protected/separate installation requirement.
- Pilz PNOZ 1 21114-EN-06: safety-contact versus auxiliary-contact boundary and output-contact protection requirements.

Frozen:

`SAFETY OUTPUT OFF != COIL DE-ENERGIZED != MAIN CONTACTS OPEN != HAZARDOUS ENERGY REMOVED`

`EDM CORRECT != ALL HAZARDOUS ENERGY ABSENT`

`TWO CONTACTORS != TWO INDEPENDENT SHUTDOWN PATHS`

`OUTPUT COMMAND LOW != OUTPUT NODE ELECTRICALLY LOW`

## Evidence discipline

No OpenPressBrake contactor/relay, monitoring-contact type, EDM timing, cable routing, pulse behavior, suppressor, PL/SIL/category/DC, stopping behavior, hydraulic state or acceptance threshold was invented. OpenPressBrake implications are labeled INFERENCE; actual implementation remains UNKNOWN.

## Compute

No simulation/build/test was justified. No GitHub-hosted Actions compute and no self-hosted runner compute were used.

## Precise next independent work

Find a complete manufacturer/professional wiring example exposing `electronic safety output -> two external contactors/relays -> monitoring contacts/EDM -> output-short or backfeed fault behavior -> restart inhibition -> physical hazardous-energy interruption`.

If the primary lane reaches that package first, rotate to one of these independent branches:

1. monitoring-contact physical-proof study: mirror/positively driven contacts versus ordinary auxiliary indication;
2. safety-output backfeed/common-supply fault-injection worksheet;
3. interposing-relay suppressor/common-cause analysis.

Do not enter the primary monitored-hydraulic/fall-protection branch unless it becomes explicitly free.