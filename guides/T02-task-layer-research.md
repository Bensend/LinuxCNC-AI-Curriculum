# T02 — task layer research and source inventory

Status: **SOURCE/EXPERIMENT — documentation and community baseline reconciled**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Documentation baseline

LinuxCNC Code Notes describes EMCTASK as the coordinator between the motion controller and discrete I/O controller. At the coarse architecture level, the Task command handler/program interpreter translates program intent into messages and coordinates when motion and I/O actions are issued. The same documentation distinguishes non-realtime Task/interpreter from realtime motion execution.

The LinuxCNC remap documentation gives the behaviorally important Task/interpreter boundary: interpreter-generated canonical operations are queued; Task later consumes those operations; the interpreter can be far ahead of actual execution; and queue-busters return `INTERP_EXECUTE_FINISH` so Task drains required queued work and synchronizes the interpreter with the world model before read-ahead resumes. This independently supports the source-level distinction between interpreter progress, Task queue progress, and subordinate motion completion.

The LinuxCNC Python-interface documentation exposes `linuxcnc.stat().exec_state` as Task execution state and enumerates states including `EXEC_DONE`, `EXEC_WAITING_FOR_MOTION`, `EXEC_WAITING_FOR_MOTION_QUEUE`, `EXEC_WAITING_FOR_MOTION_AND_IO`, and `EXEC_WAITING_FOR_DELAY`. This is the direct observation surface selected for T02-019 rather than GUI animation or current-line inference.

The INI documentation further states that `[TASK] CYCLE_TIME` affects Task polling while waiting for motion completion and accepting UI commands. The stock `tests/linuxcncrsh/linuxcncrsh-test.ini` fixture at the pinned revision uses a 1 ms Task cycle and 1 ms servo period, which makes a ~5 ms status sampler conservative enough to observe a multi-second motion barrier and a 0.75 s dwell without claiming individual-cycle completeness.

These docs establish T02's boundary: **Task is an execution coordinator/state machine, not the realtime servo loop and not merely the G-code parser.**

## Community cross-check

Community reports are treated as field evidence, not authority over pinned source. They repeatedly expose the practical failure mode this lesson is designed to prevent:

- A November 2024 LinuxCNC forum discussion on M6 remap behavior distinguishes interpreter-time `(PRINT, ...)` effects from queued `(MSG, ...)`/`(DEBUG, ...)` effects and notes that read-ahead can ingest later program text before execution reaches it. The suggested diagnostic is an explicit queue-buster when an actual synchronized value is needed.
- An April 2025 remap discussion similarly reports Python-remap code being executed prematurely by read-ahead and uses `M66 L0 E0` as a synchronization boundary.
- A February 2025 field example reading HAL values from G-code reports that a queue-buster is required before logging a value intended to represent the current machine/world state.

These reports do **not** prove T02's exact internal state sequence. They do independently confirm that confusing interpreter/read-ahead progress with machine execution is a real integrator error, so T02-019 must pair Task's own `exec_state` with an independent motion oracle.

Community references consulted 2026-09-08 UTC:

- LinuxCNC Forum, “Remap of M6 not working correctly” (Nov 2024): https://www.forum.linuxcnc.org/10-advanced-configuration/54366-remap-
- LinuxCNC Forum, “Remap M6 in python” (Apr 2025): https://www.forum.linuxcnc.org/38-general-linuxcnc-questions/55879-remap-m6-in-python
- LinuxCNC Forum, “Hal-Pin - Werte aus dem Programm heraus in eine Datei schreiben lassen” (Feb 2025): https://forum.linuxcnc.org/42-deutsch/55385-hal-pin-werte-aus-dem-programm-heraus-in-eine-datei-schreiben-lassen

Documentation references consulted 2026-09-08 UTC:

- LinuxCNC Remap, “Task and Interpreter interaction, Queuing and Read-Ahead”: https://linuxcnc.org/docs/html/remap/remap.html
- LinuxCNC Python Interface, Task status / `exec_state`: https://linuxcnc.org/docs/html/config/python-interface.html
- LinuxCNC INI Configuration, `[TASK] CYCLE_TIME`: https://linuxcnc.org/docs/html/config/ini-config.html

## Pinned source inventory

Primary source: `src/emc/task/emctaskmain.cc`.

Source inspection exposes three distinct responsibilities that T02 must keep separate:

1. **Immediate command dispatch** — `emcTaskIssueCommand(NMLmsg *cmd)` switches on message type and calls subordinate motion/I/O/task operations. Representative cases include trajectory probe/move-related commands, spindle/coolant/tool commands, state/mode commands, and abort handling.
2. **Queued interpreter work** — comments around `emcTaskCheckPreconditions()` explicitly distinguish commands on `interp_list` from immediate commands. Queued commands can require preconditions before they may be issued.
3. **Execution waiting/state** — the Task executor returns/uses `EMC_TASK_EXEC` states such as waiting for motion; completion of a subordinate action and readiness to issue the next queued command are therefore distinct from simply having a command in `interp_list`.

Representative pinned abort dispatch is especially useful for later failure analysis: `EMC_TASK_ABORT_TYPE` calls `emcTaskAbort()`, explicitly calls `emcMotionAbort()` before restoring interpreter state, calls `emcTaskStateRestore()`, aborts I/O and spindle activity, aborts MDI execution, and performs abort cleanup. This is ordinary controller sequencing and must not be misrepresented as an independent safety function.

## Pinned fixture observations used by T02-019

At revision `8bf4605ae81042248add031e94c77300406e0413`, `tests/linuxcncrsh/linuxcncrsh-test.ini` specifies:

- `DISPLAY = linuxcncrsh -n RuntimeTestMachine`
- `TASK = milltask`
- `CYCLE_TIME = 0.001`
- `SERVO_PERIOD = 1000000`
- `NO_FORCE_HOMING = 1`
- X/Y/Z simulated joints with wide travel limits.

Its `lcncrsh_sim.hal` loops each `joint.N.motor-pos-cmd` directly back to `joint.N.motor-pos-fb`, so `stat.actual_position`/`inpos` are valid **simulation-subsystem** evidence for whether LinuxCNC's motion layer considers the move complete. They remain explicitly invalid as evidence about a physical drive, encoder, transport, or safety function.

## T01 inheritance / boundary

T01 graduated after proving the interpreter-to-canonical boundary. T02 inherits, but must not re-prove, the representative path ending in `interp_list`. T02 begins where T01 intentionally stopped: how Task decides when queued commands may issue, how it waits for subordinate completion, how command/state/precondition logic interacts, and how abort/error paths change the execution state.

## Research questions and disposition

1. **Main Task plan/execute call relationship?** Source-confirmed in the T02 call-flow artifact.
2. **How are queued preconditions selected?** Source-confirmed in the execution-state matrix.
3. **How do wait states transition?** Source-confirmed; T02-019 is the independent runtime verification.
4. **When is a prior command complete enough for a following delay?** Source predicts `WAITING_FOR_MOTION_AND_IO` until subordinate motion and I/O report DONE; experiment pending.
5. **AUTO vs MDI vs MANUAL differences?** 1000-level scope requires the representative AUTO queued path; a broader comparative matrix is promotable if it changes engineering decisions.
6. **Independent observation surface?** `stat.exec_state` + monotonic time + `stat.inpos`/position, with line fields retained only as anti-circular evidence.
7. **Safety boundary?** Task abort/error sequencing is controller logic, not an independently safety-rated function.

## Current experiment checkpoint

T02-019 is frozen and its first attempt was launched from `lab-jobs/019-t02-task-motion-gated-delay.sh`. Preserve Gates A–G unchanged. Reconcile the workflow's own exit code, stdout/stderr, and raw trace. If the sampler does not capture `WAITING_FOR_MOTION_AND_IO` during independently incomplete motion, classify the run HARNESS_INVALID and improve observability without weakening Gate D. If the run passes, perform adversarial exam, fresh-AI handoff, promotion audit, and graduation review before changing T02 state.
