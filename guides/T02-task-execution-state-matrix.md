# T02 — Task execution-state and precondition matrix

Status: **SOURCE**
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Core state model

Pinned `src/emc/nml_intf/emc.hh` defines these Task executor states: `ERROR`, `DONE`, `WAITING_FOR_MOTION`, `WAITING_FOR_MOTION_QUEUE`, `WAITING_FOR_IO`, `WAITING_FOR_MOTION_AND_IO`, `WAITING_FOR_DELAY`, `WAITING_FOR_SYSTEM_CMD`, and `WAITING_FOR_SPINDLE_ORIENTED`.

The Task executor is a non-realtime coordinator. The configured `[TASK] CYCLE_TIME` governs its polling cadence while waiting for motion, pauses, and UI commands; this is separate from the realtime servo period.

## Command/precondition matrix

| Representative queued command | Precondition | Postcondition | Meaning |
|---|---|---|---|
| `EMC_TRAJ_LINEAR_MOVE` / circular move | `WAITING_FOR_IO` | `DONE` | May feed motion queue without waiting for prior physical motion to finish. |
| `EMC_TRAJ_SET_VELOCITY/ACCELERATION/TERM_COND` | `WAITING_FOR_IO` | `DONE` | Ordered against I/O, but not a full motion-drain barrier. |
| `EMC_TRAJ_SET_OFFSET/G5X/G92/ROTATION` | `WAITING_FOR_MOTION` | `DONE` | Coordinate/offset change waits for prior motion completion. |
| probe / rigid tap / clear probe / aux-input wait | `WAITING_FOR_MOTION_AND_IO` | probe/rigid-tap generally `DONE`; aux wait becomes `WAITING_FOR_DELAY` | Prevents inappropriate blending and creates an explicit synchronization boundary. |
| tool load/unload, spindle start/stop/orient, coolant | `WAITING_FOR_MOTION_AND_IO` | usually `DONE` | Waits for prior coordinated work before discrete machine action. |
| tool prepare / set number | `WAITING_FOR_IO` | `DONE` | Ordered on I/O completion. |
| plan pause/end/synch/execute | `WAITING_FOR_MOTION_AND_IO` | `DONE` | Queued plan operations execute only after outstanding subordinate work drains. |
| `EMC_TRAJ_DELAY` | `WAITING_FOR_MOTION_AND_IO` | `WAITING_FOR_DELAY` | Dwell timer starts only after prior motion and I/O are done. |
| `EMC_SYSTEM_CMD` | `WAITING_FOR_MOTION_AND_IO` | `WAITING_FOR_SYSTEM_CMD` | External process is launched only after prior subordinate work drains, then Task polls child completion. |
| synchronized analog/digital output with `now=true` | `WAITING_FOR_MOTION` | `DONE` | Immediate-style synchronized output requires motion completion first. |

## Executor-state transition matrix

| State | Exit condition | Error path | Observable consequence |
|---|---|---|---|
| `DONE` | select pending command or issue it once preconditions are satisfied | issue failure -> `ERROR` | `stat.exec_state == EXEC_DONE`; may immediately advance again when eager. |
| `WAITING_FOR_MOTION_QUEUE` | `motion.traj.queueFull == false` | subordinate errors are handled elsewhere/main loop | pending command remains retained rather than discarded. |
| `WAITING_FOR_MOTION` | motion status `DONE` | motion status `ERROR` -> `ERROR` | Task blocks on motion subsystem completion. |
| `WAITING_FOR_IO` | I/O status `DONE` | I/O status `ERROR` -> `ERROR` | Task blocks on I/O completion. |
| `WAITING_FOR_MOTION_AND_IO` | both statuses `DONE` | either relevant status `ERROR` -> `ERROR` | explicit drain/synchronization barrier. |
| `WAITING_FOR_DELAY` | timeout expiry or configured input condition | invalid wait-mode reports operator error; timeout is exposed through input-timeout state | `delayLeft` is updated. |
| `WAITING_FOR_SYSTEM_CMD` | child process exits 0 | wait/identity/nonzero-exit failures -> `ERROR` | child process lifetime becomes Task gating state. |
| `WAITING_FOR_SPINDLE_ORIENTED` | orient complete/none | timeout/fault -> `ERROR` | publishes `delayLeft`; operator error on timeout/fault. |
| `ERROR` | executor performs abort/reset/clear/synch sequence then returns to `DONE` | n/a | pending command and interpreter list are cleared; return value signals failure. |

## Immediate versus queued commands

A crucial pinned-source distinction is that `emcTaskCheckPreconditions()` and `emcTaskCheckPostconditions()` apply **only** to commands on `interp_list`. Commands that `emcTaskPlan()` sends directly through `emcTaskIssueCommand()` bypass this queued pre/postcondition state machine. Therefore command type alone is insufficient to infer synchronization semantics; the ingress path matters.

## Plan/read-ahead relationship

In AUTO, planning can repeatedly read and execute interpreter blocks while `interp_list` remains below the configured maximum. On `INTERP_EXECUTE_FINISH`, planning sets a wait condition and queues `EMC_TASK_PLAN_SYNCH`; read-ahead resumes only after the list is empty, no pending Task command exists, and executor state is `DONE`.

This yields three independent progress indicators:

1. interpreter/read-ahead progress (`readLine`, interpreter state),
2. Task queue/execution progress (`currentLine`, `execState`, pending/list state),
3. motion execution progress (motion status, queue, `inpos`, actual/commanded position).

No one of these should be used as a proxy for the other two.

## Source-confirmed failure behavior

When Task sees motion or I/O error while in the corresponding wait state, it enters `ERROR`. Its error branch aborts Task, I/O, spindles and MDI, closes/resets the plan, clears the pending command and interpreter list, resets interpreter/executor state, and queues a synchronization command. This is recovery/control sequencing, not a safety-rated mechanism.

## Experiment oracle requirement

The first T02 lab must independently sample:

- Task `exec_state`;
- Task/interpreter line state;
- motion completion (`inpos` plus position/status evidence);
- monotonic timestamp.

A valid test must reject the circular oracle "the next line became current, therefore prior motion completed."
