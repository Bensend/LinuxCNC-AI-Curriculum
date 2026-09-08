# T02 — task layer initial research and source inventory

Status: **RESEARCH**
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Documentation baseline

LinuxCNC Code Notes describes EMCTASK as the coordinator between the motion controller and discrete I/O controller. At the coarse architecture level, the Task command handler/program interpreter translates program intent into messages and coordinates when motion and I/O actions are issued. The same documentation distinguishes non-realtime Task/interpreter from realtime motion execution.

The remap documentation adds a behaviorally important Task responsibility: interpreter-generated canonical operations are queued, Task consumes those operations, and queue-busters use `INTERP_EXECUTE_FINISH` plus synchronization to stop/restart read-ahead around results that cannot be predicted.

These docs establish T02's initial boundary: **Task is an execution coordinator/state machine, not the realtime servo loop and not merely the G-code parser.**

## Pinned source inventory

Primary starting point: `src/emc/task/emctaskmain.cc`.

Source inspection already exposes three distinct responsibilities that T02 must keep separate:

1. **Immediate command dispatch** — `emcTaskIssueCommand(NMLmsg *cmd)` switches on message type and calls subordinate motion/I/O/task operations. Representative cases include trajectory probe/move-related commands, spindle/coolant/tool commands, state/mode commands, and abort handling.
2. **Queued interpreter work** — comments around `emcTaskCheckPreconditions()` explicitly distinguish commands on `interp_list` from immediate commands. Queued commands can require preconditions before they may be issued.
3. **Execution waiting/state** — the Task executor returns/uses `EMC_TASK_EXEC` states such as waiting for motion; completion of a subordinate action and readiness to issue the next queued command are therefore distinct from simply having a command in `interp_list`.

Representative pinned abort dispatch is especially useful for later failure analysis: `EMC_TASK_ABORT_TYPE` calls `emcTaskAbort()`, explicitly calls `emcMotionAbort()` before restoring interpreter state, calls `emcTaskStateRestore()`, aborts I/O and spindle activity, aborts MDI execution, and performs abort cleanup. This is ordinary controller sequencing and must not be misrepresented as an independent safety function.

## T01 inheritance / boundary

T01 graduated after proving the interpreter-to-canonical boundary. T02 inherits, but must not re-prove, the representative path ending in `interp_list`. T02 begins where T01 intentionally stopped: how Task decides when queued commands may issue, how it waits for subordinate completion, how command/state/precondition logic interacts, and how abort/error paths change the execution state.

## Research questions

1. What are the main Task plan/execute state machines and their exact pinned call relationships?
2. How does `emcTaskCheckPreconditions()` classify queued commands and choose `EMC_TASK_EXEC` wait states?
3. How does `emcTaskExecute()` transition among DONE, waiting-for-motion, waiting-for-I/O/delay/system-command, and error paths?
4. Where are `interp_list` items removed/issued, and what establishes that a prior command is complete enough for the next one?
5. How do AUTO, MDI and MANUAL paths differ at the Task layer?
6. What status/NML evidence can independently observe Task execution state without confusing it with physical completion?
7. Which abort/error paths are recoverable controller state transitions, and which uncertainties belong to safety architecture rather than Task?

## Exact next-work checkpoint

Trace pinned `emcTaskPlan()`/main-loop planning into `emcTaskExecute()`, then trace `emcTaskCheckPreconditions()` and one representative queued trajectory command from `interp_list` through a waiting-for-motion transition to completion. Produce a call-flow artifact and a Task execution-state matrix before freezing T02's first experiment. Do not start a Task lab until the observable state/oracle and failure criteria are source-defined.
