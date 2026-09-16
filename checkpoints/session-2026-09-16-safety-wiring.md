# Safety wiring research session — 2026-09-16

- Latest continuation start UTC: `2026-09-16T18:38:46Z`
- Latest continuation end UTC: `2026-09-16T18:41:46Z`
- Actual elapsed: `3.0 min`
- Overlap status: `NO EVIDENCE OF OVERLAP` — prior checkpointed safety session ended 2026-09-16T15:34:19Z.
- Compute: `NONE`; documentation/source research only. No GitHub-hosted Actions minutes consumed.
- Status: CHECKPOINTED — safety course remains active.

## Durable work completed

- `safety-course/PROFESSIONAL_SAFETY_WIRING_REFERENCE_STUDY_01.md` established final-element/energy-boundary tracing using Pilz, SICK, Siemens and HAWE references.
- `safety-course/CROSS_MACHINE_SAFE_MOTION_AND_CELL_REFERENCE_2026-09-16.md` extends the study to servo/safe-motion machinery and an automated robot/turntable cell.
- Cross-machine matrix now distinguishes press-brake hydraulic/gravity hazards, servo-drive torque/inertia/gravity hazards, and multi-zone automation-cell hazards.

## Key evidence gained

1. Professional safe motion may intentionally permit guarded access while motion remains, but only under an independently safety-rated function such as SLS/SDI/SOS; `guard open` does not universally mean `all actuator power removed`.
2. Pilz documents SS1 as controlled braking followed by STO and separately documents safe restart interlock; reset need not itself release STO.
3. SICK's Flexi Soft cell example combines E-stops, interlocked service door, light-beam devices and safe-position switches. The protective response can be zone/context dependent while remaining owned by the safety controller.
4. This strengthens the curriculum boundary: LinuxCNC/HAL/ordinary FPGA logic may coordinate normal machine state and diagnostics but cannot inherit personnel-safety authority merely by reproducing the same Boolean logic.
5. Maintenance isolation remains a separate physical-energy-control problem from STO, SLS, guard interlock or hydraulic run inhibition.

## Exact next work

1. Continue searching for a publicly inspectable complete OEM press-brake electrical + hydraulic drawing pair. Do not invent the missing valve/contact truth table.
2. Find a complete servo machine-tool electrical diagram that exposes guard/E-stop -> safety logic -> drive STO/SS1/contactor/brake and mark what remains electrically energized.
3. Find a complete automated-cell safety schematic exposing safety PLC outputs, zone final elements and feedback/EDM; pair it with the physical actuator energy paths.
4. Convert these examples into a reusable safety-course worksheet: safety demand -> safety logic -> final element -> hazardous-energy interruption/control -> feedback proof -> reset/rearm -> maintenance isolation.
5. Preserve practical human factors: engineered setup/safe-motion modes should reduce incentives to bypass guards, but do not invent safe speeds, stopping distances or safety performance levels.

## LESSON_LOG safe-append status

The required timing is preserved here. `LESSON_LOG.md` was only partially returned by the available connector and the connector exposes whole-file replacement rather than an atomic append action. Per repository governance, do not overwrite the large log from incomplete content. Append this timing only when a safe complete-file/atomic append path is available.
