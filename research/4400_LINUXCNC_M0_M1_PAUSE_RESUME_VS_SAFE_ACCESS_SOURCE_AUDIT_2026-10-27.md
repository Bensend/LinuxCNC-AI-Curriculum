# 4400-PAUSE-01 — M0/M1 program pause, optional stop and resume are not safe access

**Session:** 2026-10-27T08:32:56.346Z. **Source:** LinuxCNC development `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7`; stable comparison `v2.9.10`. **Status:** SOURCE-CONFIRMED normal execution-path audit, NON-GRADUATED safety transfer. No tests or machine-specific claims.

## Novelty / prior art

The complete [learner index](../safety-course/SAFETY_COURSE_INDEX.md) and [research plan](../SAFETY_COURSE_RESEARCH.md) already cover E-stop, safe restart, feed/motion authority, M62/M63 queued output, M6 tool change and guarding. Neither has a dedicated source trace for **M0/M1 program pause** and the fact that it is not a spindle/coolant stop, access-control or physical safe-state command. This is a new **exact normal-control source mechanism** and integration with existing safety doctrine, not a new safety function or scored competency.

## End-to-end source chain

1. [Interpreter `Interp::convert_stop`, lines 5456–5482](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/rs274ngc/interp_convert.cc#L5456-L5482): `M0` invokes `PROGRAM_STOP()`; `M1` invokes `OPTIONAL_PROGRAM_STOP()`; `M60` invokes `PALLET_SHUTTLE()` then `PROGRAM_STOP()`. This branch does **not** call `STOP_SPINDLE_TURNING`, `MIST_OFF` or `FLOOD_OFF`. **SOURCE-CONFIRMED default interpreter path.**
2. [Canonical implementation, `emccanon.cc` lines 3415–3453](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/task/emccanon.cc#L3415-L3453): `PROGRAM_STOP` queues `EMC_TASK_PLAN_PAUSE`; optional stop queues `EMC_TASK_PLAN_OPTIONAL_STOP`; resume is a separate normal command. **SOURCE-CONFIRMED.**
3. [Task handler, `emctaskmain.cc` lines 2455–2493](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/task/emctaskmain.cc#L2455-L2493): M0 invokes `emcTrajPause`, changes interpreter state to PAUSED and `task_paused=1`; M1 does so **only if** optional stop is ON. Resume calls `emcTrajResume`, restores interpreter state and clears pause flag. **SOURCE-CONFIRMED.**
4. [Task-to-motion interface, `taskintf.cc` lines 1427–1460](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/task/taskintf.cc#L1427-L1460) sends `EMCMOT_PAUSE` / `EMCMOT_RESUME`; [motion `command.c` lines 1309–1340](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/motion/command.c#L1309-L1340) invokes `tpPause` / `tpResume` and updates normal motion paused status. **SOURCE-CONFIRMED.**
5. **Contrast:** [`convert_stop` M2/M30 branch lines 5487–5640](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/rs274ngc/interp_convert.cc#L5487-L5640) explicitly calls `STOP_SPINDLE_TURNING`, `MIST_OFF`, `FLOOD_OFF` and `PROGRAM_END`. Even this program-end behavior is normal control, not personnel-safety energy isolation. **SOURCE-CONFIRMED.**

**Official documentation:** [LinuxCNC M0/M1 reference](https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/docs/src/gcode/m-code.adoc#L39-L90) states both are temporary program pauses, remain in Auto mode and resume on operator command; M1 depends on the optional-stop switch. The M2/M30 section separately lists spindle and coolant OFF. **DOC-CONFIRMED.**

**Stable cross-check:** directly inspected `v2.9.10` [`convert_stop` lines 4594–4627](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc#L4594-L4627) and [`PROGRAM_STOP` / optional stop lines 2443–2483](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L2443-L2483). The examined pause-versus-program-end split is consistent; not a guarantee about remapped M-codes or every release.

## Failure-path analysis and physical propositions

| Human action or software event | What is supported | What must not be inferred |
|---|---|---|
| Operator inserts `M0` before opening an enclosure | Normal trajectory/interpreter pause. | Spindle stopped, hydraulic beam held, electrical/air energy isolated, interlock safely released, safe access established. |
| `M1` is present but optional stop disabled | Normal program need not pause at all. | That the programmer's comment 'inspection stop' creates a protective function. |
| Operator presses Resume | Task and motion resume normal execution; source does not require independent personnel-safety rearm in this path. | Guard occupancy checked, gravity load safe, protective field cleared, independent reset/EDM complete. |
| `M2/M30` ends the program | Normal spindle/coolant commands are sent OFF. | Actual spindle standstill, drive isolation, retained pneumatic/hydraulic pressure absent, load held or safe maintenance access. |

**Cross-machine applicability:** On a mill or lathe, a program pause may leave spindle/coolant running; on a press brake, an ordinary pause cannot qualify AKAS muting, Y1/Y2 load support or a die-change safe state; on a robot cell, pausing path execution cannot prove occupancy or prevention of restart. Actual selected-machine behavior depends on HAL, hardware, remaps, safety PLC and physical final elements. These are **INFERENCE** transfer boundaries, not observed faults.

**Human-factor design requirement:** label normal `Pause/Resume` distinctly from **Protective Stop / Safe Access / Energy Isolate**. Provide an easy, predictable guarded inspection and setup workflow with independent interlock/stop, deliberate rearm, and maintenance lockout/restraint when needed. If a legitimate operator must bypass a guard to avoid losing cycle state, fix the workflow while preserving the independent protective function; do not recast M0 as a safety device.

## Evidence / disposition

**SOURCE-CONFIRMED:** default interpreter/canonical/Task/motion pause chain and M2/M30 contrast at pinned revisions. **DOC-CONFIRMED:** official M0/M1 and M2/M30 scope. **TEST-CONFIRMED:** none. **COMMUNITY-REPORTED:** none relied on. **INFERENCE:** possible continuing spindle/coolant and hazard exposure on a selected machine, absent a separately configured stop path. **UNKNOWN:** actual machine remaps/HAL, stop/hold/energy isolation, guard behavior, stop time, safe access, restart/occupancy proof and external evaluator.

No local or hosted compute is warranted for the documented default control path; physical selected-machine validation remains the real gate. Reuse [safety package](../safety-course/SAFETY_DESIGN_PACKAGE_TRACEABILITY_TEMPLATE.md) and [restricted OPB Stage A](../safety-course/4400_AKAS_M_01_RESTRICTED_PILZ_MUTING_OVERRUN_EVIDENCE_DELTA_2026-10-27.md). **G0/G1 HOLD. No personnel-exposed hazardous operation.**


**Stable Task implementation corroboration:** directly inspected [`v2.9.10` `emctaskmain.cc` lines 2312–2350](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc#L2312-L2350). It likewise invokes `emcTrajPause` for M0, conditionally for M1 only with optional stop ON, and `emcTrajResume` on normal Resume. **SOURCE-CONFIRMED** stable default Task path; this is additional version corroboration, not a runtime test or selected-machine protective stop proof.
