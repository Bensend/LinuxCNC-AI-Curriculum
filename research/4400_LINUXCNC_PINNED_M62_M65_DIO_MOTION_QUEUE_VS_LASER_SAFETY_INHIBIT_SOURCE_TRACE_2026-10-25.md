# 4400-LASER-02 — LinuxCNC M62–M65 digital-output path is ordinary motion control, not a laser interlock
**2026-10-25 | SOURCE-CONFIRMED code-reading only | pinned development 062dc7c and 2.9 a33293f | no runtime test**

## Question
If a CNC laser retrofit uses a LinuxCNC motion digital output to request beam ON/OFF, can an M63 or M65 command guarantee personnel-safe beam isolation at an access-door opening? **No such guarantee is established by the inspected code.** The trace establishes normal output scheduling and version-specific error handling; it cannot establish a physical optical final element.

## Pinned source path (inspectable)
- `src/emc/rs274ngc/interp_convert.cc` at [dev 062dc7c](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/rs274ngc/interp_convert.cc) and [2.9 a33293f](https://github.com/LinuxCNC/linuxcnc/blob/a33293f/src/emc/rs274ngc/interp_convert.cc): M62 invokes `SET_MOTION_OUTPUT_BIT`; M63 invokes `CLEAR_MOTION_OUTPUT_BIT`; M64/M65 invoke `SET_AUX_OUTPUT_BIT`/`CLEAR_AUX_OUTPUT_BIT`. Requires valid P word; cutter compensation restrictions are present. This is an interpreter-to-canonical command path, not a safety evaluator.
- `src/emc/task/emccanon.cc` [dev](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/task/emccanon.cc) and [2.9](https://github.com/LinuxCNC/linuxcnc/blob/a33293f/src/emc/task/emccanon.cc): `MOTION_OUTPUT_BIT_` appends `EMC_MOTION_SET_DOUT` to interpreter list after `flush_segments()`, with `now=0` for M62/M63; auxiliary M64/M65 use `now=1`. Start/end values are equal in these canonical functions.
- `src/emc/task/taskintf.cc` [dev](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/task/taskintf.cc): `emcMotionSetDout` populates `EMCMOT_SET_DOUT` including `now`, output index and start/end values and writes to motion.
- `src/emc/motion/command.c` [dev](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/motion/command.c): `EMCMOT_SET_DOUT` branches on `now`. Immediate -> `emcmotDioWrite`; synchronized -> `tpSetDout` for trajectory planner. It rejects index `out >= numDIO` with `EMCMOT_COMMAND_INVALID_PARAMS` in inspected dev revision. [2.9 a33293f](https://github.com/LinuxCNC/linuxcnc/blob/a33293f/src/emc/motion/command.c) has the same immediate-vs-TP branch but **does not show the same explicit `numDIO` guard at that case**. Do **not** infer that an out-of-range 2.9 output succeeds; other checks and behavior not exhaustively traced.
- `src/emc/tp/tp.c` [dev](https://github.com/LinuxCNC/linuxcnc/blob/062dc7c097693bb68e76192516cd92878dd5ecdf/src/emc/tp/tp.c) and [2.9](https://github.com/LinuxCNC/linuxcnc/blob/a33293f/src/emc/tp/tp.c): `tpSetDout` marks `syncdio.anychanged`, sets bit in `dio_mask`, and stores +1 or -1 in `dios[index]`. A later setting for the same index can replace the pending state; no independent safety input is evaluated in this function.
- LinuxCNC [official M-code manual](https://linuxcnc.org/docs/html/gcode/m-code.html) confirms M62/M63 wait for subsequent motion; M64/M65 are immediate ordinary outputs, not motion synchronized.

## Narrow claims ledger
| Claim | Classification | Limit |
|---|---|---|
| M62/M63 canonical commands use `now=0`; M64/M65 use `now=1` | SOURCE-CONFIRMED | both pinned branches |
| Dev `EMCMOT_SET_DOUT` immediate vs TP dispatch | SOURCE-CONFIRMED | exact development revision |
| Pending `tpSetDout` uses a mask/one value per channel, not a safety queue | SOURCE-CONFIRMED | exact function |
| Dev checks invalid DIO index in command.c; 2.9 case differs | SOURCE-CONFIRMED | narrow source comparison, no runtime verdict |
| M63 can guarantee immediate beam-off upon guard opening | **REJECTED** | no subsequent motion means pending output may not change; no safety guarantee |
| M65 ensures beam physically extinguished or shutter closed | **NOT ESTABLISHED** | ordinary output path has no optical or final-element witness |
| Real retrofit wiring, shutter/PSU behavior, laser emission or restart | UNKNOWN | no machine evidence |
| Runtime behavior/fault injection | TEST-CONFIRMED **none** | not executed |

## Consequence for architecture
The **normal** path may be G-code -> interpreter -> Task/canonical message -> motion output -> HAL -> process laser request. A separately qualified **independent safety-related guard/laser isolation path** must physically inhibit hazardous accessible radiation without relying on G-code scheduling, HAL, the normal FPGA or an M-code being executed. Independently verify the selected final element and actual optical containment. Keep axis motion, extraction, coolant, fire and electrical stored-energy functions separate.

## Adversarial transfer
A builder uses M63 in an abort macro but has no subsequent motion. The pinned documentation/source explains why the ordinary output transition may not occur; this is **not** an instruction to add motion after an E-stop. The correct safety conclusion is that a guard-open optical stop must be independent of that macro. Another builder uses M65 but a power-stage relay welds closed: command semantics alone cannot prove the optical safe state. Do not assign safety PL/SIL, output timing or optical density from this trace.

**No simulations, Actions workflows, laser tests or physical experiments were run.** This is source evidence, not a certified laser interlock implementation.

## 2026-10-29 source-depth crosslink — reverse traversal does not invert consumed outputs

The original LASER-02 lesson covers normal pending M62/M63 scheduling and why it is not independent laser isolation. The later [REVERSE-DIO-01 pinned v2.9.10 TP source composition](4400_REVERSE_DIO_01_LINUXCNC_2910_M52_REVERSE_DOES_NOT_INVERT_ONE_SHOT_M62_M63_OUTPUT_SOURCE_COMPOSITION_2026-10-29.md) adds a distinct reverse-trajectory question: `tpToggleDIOs` consumes a segment's `syncdio.anychanged` once, while reverse queue stepping does not automatically synthesize inverse ON/OFF requests. This does **not** establish a particular live beam state or accident. Ordinary output state, physical optical emission and independent guard/isolation remain separate. SOURCE-CONFIRMED code, INFERENCE conditional process behavior, physical TEST-CONFIRMED none.
