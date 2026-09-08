# T02 call flow — queued trajectory work through Task preconditions

Status: **SOURCE-CONFIRMED; experiment pending**

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Trace one behaviorally significant Task-layer path after T01's interpreter/canonical boundary. The representative sequence is a queued `EMC_TRAJ_LINEAR_MOVE`, followed by a queued `EMC_TRAJ_DELAY` (for example a G1 move followed by G4 dwell). It demonstrates why "interpreter has advanced" and "Task has selected the next line" are not equivalent to "motion is complete."

## Main-loop relationship

Pinned `src/emc/task/emctaskmain.cc` states and implements the cyclic relationship:

1. `emcTaskPlan()` accepts UI/NML work and, in AUTO, performs interpreter read/execute/read-ahead that appends canonical NML commands to `interp_list`.
2. `emcTaskExecute()` consumes queued commands according to `emcStatus->task.execState`.
3. The main loop calls `emcTaskPlan()` and then `emcTaskExecute()` before refreshing subordinate motion/I/O status for subsequent cycles.

`INTERP_EXECUTE_FINISH` is a separate queue-buster path: planning sets the interpreter wait flag and queues a synchronization command, preventing further read-ahead until outstanding queued work drains.

## Executor queue-selection path

When `execState == EMC_TASK_EXEC::DONE`, `emcTaskExecute()`:

1. refuses another queued issue while motion's trajectory queue is full or interpreter state is paused;
2. if no command is pending, obtains one with `interp_list.get()`;
3. records the list line number as `task.currentLine` and updates the motion id;
4. if the motion queue became full, enters `WAITING_FOR_MOTION_QUEUE`; otherwise calls `emcTaskCheckPreconditions(pending)`;
5. on a later executor cycle, once the precondition state returns to `DONE`, issues the pending command with `emcTaskIssueCommand()`;
6. issue failure moves Task to `ERROR`; success sets `execState = emcTaskCheckPostconditions(command)` and clears the pending command.

Thus dequeue/selection, issue, subordinate acceptance/execution, and physical completion are distinct events.

## Representative linear move

For `EMC_TRAJ_LINEAR_MOVE_TYPE`:

- **precondition:** `emcTaskCheckPreconditions()` returns `WAITING_FOR_IO`, not `WAITING_FOR_MOTION`. This permits successive trajectory moves to feed the motion queue while prior motion is still executing, provided I/O is done.
- **issue:** `emcTaskIssueCommand()` calls `emcTrajUpdateTag()` and `emcTrajLinearMove(...)`.
- **postcondition:** `emcTaskCheckPostconditions()` returns `DONE`.

This is deliberate queueing behavior. Task does not wait for the physical end of each ordinary linear move before it can issue subsequent blendable motion.

## Representative motion-gated delay

For `EMC_TRAJ_DELAY_TYPE`:

- **precondition:** `WAITING_FOR_MOTION_AND_IO`.
- In that executor state, Task remains blocked until both `emcStatus->motion.status` and `emcStatus->io.status` are `RCS_STATUS::DONE`; either subordinate `ERROR` moves Task to `ERROR`.
- **issue:** `emcTaskIssueCommand()` sets `taskExecDelayTimeout = etime() + delay`.
- **postcondition:** `WAITING_FOR_DELAY`.
- `WAITING_FOR_DELAY` publishes decreasing `task.delayLeft`; expiration changes `execState` to `DONE`.

Therefore a dwell following queued motion cannot begin its dwell timer merely because the interpreter has parsed the dwell or because Task has selected it from `interp_list`; its issue is gated on subordinate motion and I/O completion.

## Failure branch

`WAITING_FOR_MOTION`, `WAITING_FOR_IO`, and `WAITING_FOR_MOTION_AND_IO` explicitly promote subordinate `RCS_STATUS::ERROR` to Task `EMC_TASK_EXEC::ERROR`. The executor's ERROR branch aborts Task/I/O/spindles/MDI work, closes/resets planning, clears the pending command and `interp_list`, resets interpreter/executor state, and queues a synchronization command. This is controller error handling, not an independent safety function.

## Observable evidence surface

`EMC_TASK_STAT::execState` is part of NML status. The LinuxCNC Python interface exposes it as `linuxcnc.stat().exec_state`, including `EXEC_DONE`, `EXEC_WAITING_FOR_MOTION`, `EXEC_WAITING_FOR_MOTION_QUEUE`, `EXEC_WAITING_FOR_IO`, `EXEC_WAITING_FOR_MOTION_AND_IO`, `EXEC_WAITING_FOR_DELAY`, and other states. A lab may therefore sample Task's own published state without inferring it from GUI animation.

For the representative experiment, `exec_state` must be paired with an independent motion oracle (`stat.inpos` and position/motion status) and wall-clock timestamps. `current_line` alone is not a motion-completion oracle.

## Evidence boundary

This trace proves pinned software sequencing. It does not prove drive motion, feedback truth, or safety-rated stopping. A simulated `inpos`/motion DONE state is evidence about LinuxCNC's simulated motion subsystem only.
