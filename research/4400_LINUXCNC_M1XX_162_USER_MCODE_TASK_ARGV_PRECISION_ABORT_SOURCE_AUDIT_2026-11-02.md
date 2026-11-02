# 4000-LC-M1XX-162 — LinuxCNC user M-code dispatch, argument precision, Task completion and abort authority

**Date:** 2026-11-02. **Scope:** 3100 mills, 3200 lathes, 3300 plasma, 3400 routers, 3600 press brakes, 4000 controller integration. **Status:** NON-GRADUATED; SOURCE/DOC-CONFIRMED static; conditional behavior INFERENCE; all runtime acceptance NOT RUN.

## Question and predecessor check

When a postprocessor emits `M150 P... Q...`, is it a realtime or motion-synchronized operation, what numerical precision survives, what actually counts as completion, and what happens when an external helper fails or is aborted?

A direct full-text predecessor scan of `PROGRESS.md` and `LESSON_LOG.md` covered `M100`, `M101`, `USER_M_PATH`, `REMAP`, `M6`, `G10`, `TOOLDB`, and `M62/M63/M67`. Existing MILL-36 examines an M6 NGC remap, TOOL-71/72/73 tool database consistency, and earlier M62/M63/M67 investigations cover motion-synchronized I/O. None establishes this exact **M100–M199 external process dispatch → argv conversion → waitpid → abort** contract. This is a distinct cross-layer implementation trace, not a new safety course or a re-graduation.

## Pinned source inventory

Stable LinuxCNC `v2.9.10` = commit `86cdca76fa2a36274c432caa21952b23c267989a` (2026-07-02); development snapshot = `67437d8865e431a9a33f74cee912dbf891d3b4c5` (inspected 2026-11-02). Never silently transfer the conclusions to a different version.

| Source / symbol | Stable blob | Development blob | Relevant region |
| --- | --- | --- | --- |
| [`interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/interp_convert.cc), `Interp::convert_m` | `f01a359652d588d59c9e210fa441a99d2ee19598` | `379b21eaba65840ce4160e7ea70df60c12fad9ff` | stable ~3688–3700 |
| [`emctask.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctask.cc), `emcTaskInit` and `user_defined_add_m_code` | `ef96ceb4de247a96a1ff64309850383864d05179` | `c9772a266db9a71a6073435003de5a6097877211` | stable ~38–40, 87–110, 123–207; development ~110–122, 182–208 |
| [`emctaskmain.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctaskmain.cc), `argvize`, `emcSystemCmd`, `emcTaskCheckPreconditions`, `emcTaskExecute` | `7292a172023a5b42b023447c2458cb766c93fc9b` | `049c640f1af1b21c18161d6c065ff6f3e35fd83b` | stable ~280–356, 1493–1512, 1669–1671, 2437–2439, 2549–2559, 2793–2862; dev ~305–375, 3106–3165 |
| [Official M100–M199 documentation](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/src/gcode/m-code.adoc) | `bd388ccd0da40c9a2df2910037ce34de1e47c820` | `5495864386f88238ede66940affaf44c90b1e5e7` | stable ~701–751 |
| [Actual M110 script](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/nc_files/ngcgui_lib/mfiles/M110) and [INI example](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/xhc-hb04/mm_base.inc) | `41cbb28abd0dd2235731d4541e9e2b8c315fc7fa` / `adef14d1b4eb12ff3aa0503cf0188b5a16814793` | M110 same blob | `USER_M_PATH`, executable naming, nonzero-exit convention |

## Execution path — where the boundaries actually lie

1. **Startup discovery, not dynamic file lookup.** `emcTaskInit` builds a search list with `[DISPLAY]PROGRAM_PREFIX` (or default `nc_files`) first and up to five `[RS274NGC]USER_M_PATH` directories after it. For each M100–M199 number it looks for exactly `M1%02d`, requires the owner's executable bit (`S_IXUSR`), registers the first qualifying match, and stops searching for that number. Adding a file after Task startup does not register it; restart the LinuxCNC Task/application. A duplicate in `PROGRAM_PREFIX` takes precedence over a duplicate in `USER_M_PATH`.
2. **Interpreter dispatch.** `Interp::convert_m` group 10 checks `USER_DEFINED_FUNCTION[index-100]` and rejects an unregistered command as unknown. It enqueues the M-code number and `block->p_number` / `block->q_number` through `enqueue_M_USER_COMMAND`. This is not a realtime HAL callback.
3. **Motion barrier and text formatting.** `user_defined_add_m_code` calls `FINISH()` to flush linked motions, then constructs a text command by appending `" %f %f"` to a stored `directory/M1%02d` format. C `%f` defaults to **six digits after the decimal point**. Both inspected versions use this format. Therefore a nominal P=0.0000004 is represented as `0.000000`, while P=0.0000006 is represented as `0.000001` (standard formatting inference; executable acceptance pending). A sub-micrometre or high-resolution parameter must **not** be assumed to survive this interface losslessly.
4. **Task ordering.** `EMC_SYSTEM_CMD` enters the Task interpreter list. `emcTaskCheckPreconditions` requires prior motion and IO completion; the executor then forks the helper and moves to `WAITING_FOR_SYSTEM_CMD`. The queue does not advance through the barrier while the child is running. This is a **program-order barrier**, not a deterministic servo-period trigger.
5. **No shell expansion.** `argvize` splits the command string on whitespace, recognizes double-quote delimiters, and `emcSystemCmd` calls `execvp(argv[0], argv)` directly. There is no shell in this path. Since the path constructed by `user_defined_add_m_code` is **not quoted**, a directory with spaces is split into separate argv tokens even if startup `stat` found its executable. Do not rely on shell substitutions, redirections, pipes or globbing. This is source-confirmed parsing, not an executed path-with-spaces test.
6. **Completion and failure.** Task polls the direct child with `waitpid(pid, ..., WNOHANG)`. Only exit status 0 yields `DONE`; nonzero exit, signal termination or wait failure yields `ERROR`. The official M-code manual says a nonzero exit stops G-code execution. A child exit 0 proves only the helper's exit, **not** a downstream device's achieved state. The wait state contains no per-M1xx timeout: a helper that hangs can block progress until an operator/program abort or external intervention.
7. **Abort is not a process-tree kill.** When Task leaves the waiting state with an outstanding child, it sends `SIGINT` to the recorded **child PID** and clears that PID. There is no process-group kill in this inspected path. Whether a script's spawned descendants continue depends on their own process/signal behavior; treating the entire helper process tree as cancelled is unsupported. No physical STOP authority is inferred.

### Version comparison

The inspected development version preserves the same `%f %f` formatting, discovery order, `argvize`/`execvp` mechanism, child wait and signal-abort structure. It refactors Task classes/logging and uses a dynamically allocated `EMC_SYSTEM_CMD`. This audit does **not** assert bit-for-bit identical scheduling or runtime behavior. A new revision must be rechecked.

## Claims and falsifiers

| Claim | Evidence | Confidence / falsifier |
| --- | --- | --- |
| Startup scans exact executable `M1xx` names, PROGRAM_PREFIX first | SOURCE + official DOC | SOURCE-CONFIRMED; a matching registered command appearing without Task restart would contradict the inspected startup-only path |
| P/Q lose precision at six decimals | SOURCE format `%f`; standard C formatting | SOURCE-CONFIRMED format; exact child argv output NOT RUN |
| Preceding motion/IO completes before helper starts; following queued commands wait for child | SOURCE Task preconditions and wait state | SOURCE-CONFIRMED path; exact scheduling latency UNKNOWN |
| Child success does not verify physical peripheral completion | SOURCE waitpid + absence of peripheral witness | INFERENCE from observed contract; do not equate to physical state |
| Nonzero/signal child exit is Task error | SOURCE + DOC | SOURCE/DOC-CONFIRMED; disconnected Q7 acceptance NOT RUN |
| Abort kills all descendants | No supporting source; direct PID only | **REJECTED**; descendant behavior UNKNOWN |
| M1xx is suitable for synchronized plasma torch/ram timing | Task userspace fork/wait, not motion DIO | **REJECTED** for deterministic timing; use appropriate motion-synchronized I/O and independently engineered process/safety control |

## Practical machine-class implications

- **3100/3200 mill/lathe:** a helper may log a tool-change transaction or request a non-realtime peripheral operation, but tool-in-spindle/lock confirmation must be explicitly checked before helper returns success. Native M6/Task and spindle-sync semantics are not replaced.
- **3300 plasma:** do not use M1xx for precise torch switching at a trajectory point. Use motion-synchronized output semantics where applicable, while preserving process-controller readiness and independent safety.
- **3400 router:** a bounded external dust/extraction service request is plausible; Task waiting for script exit is not proof of airflow.
- **3600 OpenPressBrake:** a CAM-generated M1xx may perform *offline job metadata* exchange or read-only logging; never treat it as a synchronized bend, ram-enable, G0/G1 release or personnel-safety permission. Existing OpenPressBrake HOLD stays unchanged.
- **4000 web/ROS2:** use a typed, versioned service or HAL bridge with explicit acknowledgement, freshness and timeout when parameters require precision or ongoing state. M1xx can be an orchestration adapter but is not a realtime transport.

## Disconnected reproducible evidence ladder

See [M1XX-162 guide](../guides/3100-3400-3600-4000-linuxcnc-m1xx-task-dispatch-commissioning-2026-11-02.md) and [fixture](../examples/4000_m1xx_162/README.md). Run only on independently qualified physically disconnected `[self-hosted, openpressbrake]` compute, not a connected machine or hosted Actions runner. A–J acceptance cases are **NOT RUN**. Check `stdout/stderr`, interpreter error, Task execState, source revision, startup search order and actual process exit; never promote a prediction to TEST-CONFIRMED without retained raw evidence.

## Uncertainty / promotion

- **HIGH:** demonstrate bounded Task M1xx startup, child wait and failure handling with real LinuxCNC simulation and retained logs; physical peripheral completion separately UNKNOWN.
- **MEDIUM:** compare command-path precision and path quoting with development version under the same frozen fixture.
- **MEDIUM:** confirm abort behavior for a direct child and a deliberately spawned descendant in a *strictly isolated software* fixture; no unbounded subprocesses or machine I/O.
- **LOW:** inspect current upstream M1xx test coverage before adding a dedicated regression. Search negatives alone do not establish absence.

**No tests, builds, GUI execution, HAL execution, external evaluation, physical machine or Actions compute occurred.** Existing blind feedback and compute ledgers unchanged. Graduated levels remain CLOSED; independent personnel-safety authority and OpenPressBrake G0/G1 HOLD unchanged.

## Same-session GUI preview continuation — M1XX-162B: visible M-code is not an executable M-code

**New causal discriminator:** the **Axis preview interpreter and live Task do not use the same M1xx registration table**.

Pinned stable [`gcodemodule.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/rs274ngc/gcodemodule.cc) blob `d2416b217e4b161512dd56957bc99d7dff18d83e` ~568–575 and ~745–747 sets `USER_DEFINED_FUNCTION[i] = user_defined_function` for **all** 100 M1xx indices in the preview interpreter, regardless of whether an executable exists. The callback forwards the M-code and P/Q to a Python preview object. Pinned [`glcanon.py`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/lib/python/rs274/glcanon.py) blob `bff5024e7f191124846022cabb98f58cd50e73b7` ~336–339 appends an M1xx **preview marker**; it does **not** run the external helper. [Axis `axis.py`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/usr_intf/axis/scripts/axis.py) blob `ccb7ebe5939d3ea76b1244772ce650c95309b49a` ~1291 invokes `load_preview` and ~1576–1589 uses a dummy M199 callback to evaluate expressions.

By contrast, live Task's `emcTaskInit` registers **only** executable M1xx files found at startup and `Interp::convert_m` checks that live registration. Therefore an M150 **can be represented in stock Axis preview despite being absent or non-executable at Task startup**, then fail as `Unknown M-code` when executed. Similarly a helper that exits 7 can be previewed normally but fail at execution. These are **SOURCE-CONFIRMED architectural differences / conditional preview-vs-runtime INFERENCE**, not a measured GUI mismatch. This is especially relevant when validating CAM-generated process codes: **preview acceptance is not execution acceptance**.

Add [K–L preview-vs-Task acceptance cases](../guides/3100-3400-3600-4000-linuxcnc-m1xx-task-dispatch-commissioning-2026-11-02.md#same-session-gui-preview-discriminator-kl-not-run) to the disconnected run card. No GUI, LinuxCNC or helper execution was performed.
