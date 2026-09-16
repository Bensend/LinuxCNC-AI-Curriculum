# Safety wiring research session — 2026-09-16

- Latest continuation start UTC: `2026-09-16T19:37:48Z`
- Latest continuation end UTC: `2026-09-16T19:38:54Z`
- Actual elapsed: `1.1 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — prior checkpointed safety session ended 2026-09-16T18:41:46Z.
- Compute: `NONE`; documentation/source research only. No GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED — safety course remains active.

## Durable work completed

- `safety-course/PROFESSIONAL_SAFETY_WIRING_REFERENCE_STUDY_01.md` established final-element/energy-boundary tracing using Pilz, SICK, Siemens and HAWE references.
- `safety-course/CROSS_MACHINE_SAFE_MOTION_AND_CELL_REFERENCE_2026-09-16.md` extends the study to servo/safe-motion machinery and an automated robot/turntable cell.
- `safety-course/PIRANHA_200_COMPLETE_ENERGY_BOUNDARY_TRACE_2026-09-16.md` adds the first publicly inspectable OEM press-brake manual in this study containing operating behavior, electrical drawings and hydraulic drawings in one document.
- `safety-course/COMPLETE_MACHINE_SAFETY_TRACE_WORKSHEET.md` converts the evidence method into a reusable two-trace worksheet for all machine classes.

## Key evidence gained this continuation

1. Piranha's historical 200-ton press-brake manual explicitly states E-stop removes power from the hydraulic power-unit drive motor and base-machine controls.
2. Its electrical drawing exposes the physical motor-power boundary: low-voltage E-stop/start chain -> R1/M1 authority -> M1 starter coil -> three M1 power contacts -> hydraulic pump motor.
3. The upstream main supply is a distinct boundary; maintenance instructions require lockout at the safety disconnect rather than treating E-stop as electrical isolation.
4. The same OEM manual instructs service personnel to block the ram and turn power off before hydraulic service. This is direct evidence that pump-power removal is not treated as sufficient protection against the gravity/mechanical ram hazard.
5. The complete-machine worksheet now requires two independent traces: (a) protective-device/safety-logic/final-element control chain and (b) physical energy source/interruption/residual-energy chain. It also forces explicit recording of what remains energized.
6. This legacy architecture is retained as historical implementation evidence only; no current PL/SIL/category or modern compliance is inferred from it.

## Exact next work

1. Find a newer CNC press-brake OEM drawing pair exposing safety controller + redundant/monitored hydraulic safety/holding valves + pump contactor in one machine implementation; do not invent the missing truth table.
2. Apply `COMPLETE_MACHINE_SAFETY_TRACE_WORKSHEET.md` to that modern press brake and to one servo machine tool.
3. Trace a servo machine tool guard/E-stop -> safety logic -> SS1/STO/contactors/brake -> motor, explicitly marking mains/DC-bus states.
4. Continue seeking an automated-cell drawing that exposes safety PLC outputs, zone final elements and EDM/feedback.
5. Preserve the ordinary LinuxCNC/FPGA boundary: monitoring and normal requests are allowed; personnel-safety authority remains independent.

## LESSON_LOG safe-append status

Required timing is preserved above. `LESSON_LOG.md` is too large for a complete fetch through the available connector: even a bounded fetch returns a truncated response, while the available write action is whole-file replacement rather than atomic append. Per repository governance, the log was **not overwritten from incomplete content**. Append this row when an atomic/safe append path becomes available:

`| 2026-09-16 | Safety course — Piranha complete press-brake energy-boundary trace | 2026-09-16T19:37:48Z | 2026-09-16T19:38:54Z | 1.1 | COMPLETE OEM ELECTRICAL/HYDRAULIC PAIR INTEGRATED | Modern CNC press-brake monitored hydraulic safety-valve trace, then servo-machine complete trace | No overlap; no compute. |`
