# 4000 safety checkpoint — final-element physical feedback

Date: 2026-09-20

## Completed

Closed the bounded generic safety-input multi-fault/restart search with `safety-course/SAFETY_INPUT_MULTI_FAULT_SAFE_OUTPUT_AND_RESTART_DISPOSITION_STUDY_2026-09-20.md`.

Rotated immediately to final-element feedback and added `safety-course/EXTERNAL_DEVICE_MONITORING_WELDED_CONTACTOR_PHYSICAL_FEEDBACK_STUDY_2026-09-20.md`.

## Durable freeze

`SAFETY OUTPUT COMMANDED OFF != EXTERNAL CONTACTOR DE-ENERGIZED != POWER CONTACTS PHYSICALLY OPEN`.

`EDM FEEDBACK CLOSED != ALL HAZARDOUS ENERGY REMOVED`.

`RESET REQUESTED != EDM HEALTHY != RESTART AUTHORIZED`.

## Exact next work

Compare manufacturer architectures for three different final-element witnesses: electrical contactor EDM, drive STO/status feedback, and hydraulic valve/spool monitoring. For each, explicitly identify command, physical feedback, failure disposition, restart inhibition, and the physical facts that remain unproved. Do not infer safety authority from ordinary LinuxCNC/HAL/FPGA status bits.

No executable lab is currently justified. Do not use GitHub-hosted compute. If a later concrete executable question emerges, only the self-hosted `[self-hosted, openpressbrake]` runner is permitted.
