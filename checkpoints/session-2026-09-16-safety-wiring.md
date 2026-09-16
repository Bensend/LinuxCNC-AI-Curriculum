# Safety wiring research session — 2026-09-16

- Latest continuation start UTC: `2026-09-16T21:33:49Z`
- Latest continuation end UTC: `2026-09-16T21:36:30Z`
- Actual elapsed: `2.7 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — prior checkpointed safety session ended 2026-09-16T19:38:54Z.
- Compute: `NONE`; authoritative documentation/source research only. No GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED — safety course remains active.

## Durable work completed

- `safety-course/PROFESSIONAL_SAFETY_WIRING_REFERENCE_STUDY_01.md` established final-element/energy-boundary tracing using Pilz, SICK, Siemens and HAWE references.
- `safety-course/CROSS_MACHINE_SAFE_MOTION_AND_CELL_REFERENCE_2026-09-16.md` extends the study to servo/safe-motion machinery and an automated robot/turntable cell.
- `safety-course/PIRANHA_200_COMPLETE_ENERGY_BOUNDARY_TRACE_2026-09-16.md` adds the first publicly inspectable OEM press-brake manual in this study containing operating behavior, electrical drawings and hydraulic drawings in one document.
- `safety-course/COMPLETE_MACHINE_SAFETY_TRACE_WORKSHEET.md` converts the evidence method into a reusable two-trace worksheet for all machine classes.
- `safety-course/RESET_RESTART_EDM_REARM_PROFESSIONAL_PATTERN_2026-09-16.md` separates demand clearing, final-element proof, safety reset/restart interlock, fault acknowledgment/rearm, and the later normal machine start command using SICK and Siemens manufacturer documentation.

## Key evidence gained this continuation

1. SICK explicitly defines reset as restoring the protective device to monitoring readiness; reset must not itself create motion or danger, and machine start is a separate subsequent command.
2. SICK EDM examples prove downstream contactor state using positively guided auxiliary contacts and prevent restart when a contactor is fused/stuck or otherwise fails to reach the expected state.
3. SICK recommends locating the reset control outside the hazardous area, inaccessible from inside, with full visual command of the protected area. This directly supports the curriculum's human-factors rule.
4. Siemens Safety Integrated documentation treats safety-fault acknowledgment as a separate state transition; removing the fault cause and restoring/deselecting a safety function does not erase the need for defined acknowledgment where required.
5. The curriculum now forbids collapsing these concepts into one generic RESET bit: safety demand cleared -> final elements proven -> safety reset/restart-interlock release -> fault acknowledgment where applicable -> separate normal start -> ordinary actuator authority.
6. OpenPressBrake consequence: LinuxCNC/FPGA may observe safety-ready/fault state and must default safe in normal control, but ordinary software recovery must not silently reset the personnel-safety restart interlock.

## Exact next work

1. Find a newer CNC press-brake OEM drawing pair exposing safety controller + redundant/monitored hydraulic safety/holding valves + pump contactor in one machine implementation; do not invent the missing truth table.
2. For that machine, trace reset/restart/EDM together with the physical hydraulic energy boundary and determine exactly which final-element states are proved before restart.
3. Apply `COMPLETE_MACHINE_SAFETY_TRACE_WORKSHEET.md` to one modern servo machine tool and one automated cell with complete final-element drawings.
4. Study loss-and-restoration cases (24 V, mains, safety-controller power, LinuxCNC/FPGA reboot, network recovery) specifically for unintended automatic restart paths.
5. Preserve the ordinary LinuxCNC/FPGA boundary: monitoring and normal requests are allowed; personnel-safety authority remains independent.

## LESSON_LOG safe-append status

Required timing is preserved above. `LESSON_LOG.md` remains too large for a complete fetch through the available connector, while the available write action is whole-file replacement rather than atomic append. Per repository governance, the log was **not overwritten from incomplete content**. Append this row when an atomic/safe append path becomes available:

`| 2026-09-16 | Safety course — professional reset/restart/EDM/rearm pattern | 2026-09-16T21:33:49Z | 2026-09-16T21:36:30Z | 2.7 | RESET/RESTART/EDM STATE MODEL INTEGRATED | Modern CNC press-brake reset + hydraulic final-element proof trace | No overlap; no compute. |`
