# Lane-B Safety Checkpoint — Safety Release / Process-Command Freshness — 2026-09-19

## Completed

Created `safety-course/SAFETY_RELEASE_PROCESS_COMMAND_FRESHNESS_STUDY_2026-09-19.md` as an independent ordinary-control/safety-interface study.

Primary lane was advancing press-brake stopping-performance re-proof triggers and hydraulic final-element questions. Lane B did not modify those files or evidence packages.

## New durable freeze

`SAFETY INPUT HEALTHY != SAFETY RESET VALID != SAFETY OUTPUT AUTHORITY != ORDINARY PROCESS COMMAND PRESENT != FRESH PROCESS COMMAND != HAZARDOUS MOTION AUTHORIZED.`

`E-STOP DEVICE RELEASED != E-STOP SAFETY FUNCTION RESET != FRESH START/JOG/CYCLE INTENT.`

`AUTOMATIC SAFETY RESET PERMITTED BY AN APPLICATION != PERMISSION TO RETAIN A STALE ORDINARY MOTION COMMAND.`

## Evidence gained

- Siemens safety-programming guidance explicitly recommends that a safety shutdown reset/interlock ordinary process control so a new switch-on signal is required; safety reset must not itself restart the machine.
- Siemens Safety Integrated documentation separately prohibits automatic motor restart after Emergency Stop while acknowledging that automatic restart after some other safety-function recoveries can be valid depending on risk analysis.
- Rockwell Guardmaster documentation distinguishes automatic, manual, and monitored manual reset behavior and keeps external-device monitoring in the reset/monitor path.
- Pilz independently distinguishes automatic, manual-edge, and monitored-edge start/reset behavior.

This resolves an important curriculum nuance: do not teach a universal `every safeguard recovery requires a manual production START` rule. Instead trace the validated restart policy for the specific safety function and mode, while ensuring a safety-release edge cannot accidentally resurrect stale ordinary control intent.

## Compute

None. Documentation answered the question; no GitHub-hosted or self-hosted compute was needed.

## Concurrency check

Immediately after the substantive Lane-B commit, current `main` showed that commit directly above the prior timing request and primary stopping-reproof checkpoint. No overlapping file had changed, so no reconciliation or branch switch was required.

## Exact next Lane-B work

Find a complete professional implementation exposing:

`active ordinary motion request -> safety demand -> safety output/final-element safe reaction -> ordinary process request invalidated -> safety condition restored -> reset/rearm according to validated function/mode -> stale command cannot resurrect motion -> fresh ordinary command -> physical motion`.

Prefer a machine-tool, press, drive/STO, or safety-PLC implementation showing both the safety program and standard-control interlock. Preserve the distinction between E-stop no-automatic-restart requirements and application-specific restart policy for other protective functions.