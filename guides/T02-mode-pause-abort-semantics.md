# T02 — mode, pause/resume, and abort semantics

Status: **SOURCE**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Why this artifact exists

T02's 1000-level graduation criteria require more than a single AUTO queue trace. A competent AI must distinguish Task semantics across MANUAL, AUTO, and MDI and must explain pause/resume/abort without treating any of them as an independent safety function.

This note records the bounded source-level distinctions needed for that criterion. It does not claim exhaustive coverage of every command accepted in every state/mode.

## Common Task architecture

The pinned `emctaskmain.cc` header documents the controlling architecture directly:

1. the main loop calls `emcTaskPlan()` and `emcTaskExecute()` cyclically;
2. `emcTaskPlan()` dispatches according to machine state and mode (`MANUAL`, `AUTO`, `MDI`);
3. many commands are issued immediately to motion/I/O;
4. AUTO invokes the interpreter and canonical operations append NML commands to `interp_list`;
5. `emcTaskExecute()` consumes `interp_list` commands through precondition/postcondition states;
6. immediate commands do not receive those queued pre/postconditions.

That last distinction is the transferable rule: **mode and ingress path matter as much as NML command type when reasoning about ordering.**

## MANUAL

In machine state ON, the pinned planner has a dedicated `EMC_TASK_MODE::MANUAL` branch. Manual-origin commands such as jog/home and applicable machine commands are handled through the plan/issue command logic rather than by running an AUTO G-code file through interpreter read-ahead.

A representative restriction is explicit: `EMC_JOINT_OVERRIDE_LIMITS` is issued only when Task mode is MANUAL.

Engineering consequence: do not infer AUTO `interp_list` ordering for a manual jog/home simply because both ultimately affect motion. Manual commands can take the immediate-command path, for which `emcTaskCheckPreconditions()` / `emcTaskCheckPostconditions()` are not the ordering mechanism.

## AUTO

AUTO is the program-run/read-ahead path. In ON/AUTO, Task branches further on interpreter state (`IDLE`, `READING`, `PAUSED`, and related states). While reading, the interpreter can execute ahead and append canonical NML work to `interp_list`; `emcTaskExecute()` separately drains that list.

This is the mode exercised by T02-019. It is why `readLine`, `currentLine`, executor `execState`, and motion completion can differ.

Changing away from AUTO is deliberately constrained: pinned source rejects a mode switch away from AUTO while the interpreter is not IDLE. The mode transition therefore is not just a display flag change.

## MDI

MDI is its own ON-mode planner branch. It uses interpreter execution for the submitted command (`emcTaskPlanExecute(command, 0)`) and tracks MDI nesting/execution level. It is therefore interpreter-backed, but it is not identical to AUTO file read-ahead.

The pinned code separately tracks MDI execution level and has dedicated abort cleanup for MDI. This matters for integrations that assume “anything interpreted behaves exactly like AUTO.” That assumption is too broad.

1000-level claim boundary: T02 establishes that MDI has a distinct Task path and interpreter-execution bookkeeping. Exhaustive nested-MDI/subroutine behavior remains deeper study unless an engineering decision requires it.

## Pause

There are two related but different paths to keep straight.

### Queued pause from interpreter/canonical flow

For queued `EMC_TASK_PLAN_PAUSE`, `emcTaskCheckPreconditions()` returns `WAITING_FOR_MOTION_AND_IO`. Pinned source comments explicitly state that a pause on `interp_list` is queued and therefore waits until outstanding motion/I/O are done before the queued pause command is issued.

### Issuing pause

`emcTaskIssueCommand(EMC_TASK_PLAN_PAUSE)` calls `emcTrajPause()`, preserves the previous interpreter state in `interpResumeState` when appropriate, sets interpreter state to `PAUSED`, and marks Task paused state.

Thus “pause requested,” “queued pause reaches its synchronization boundary,” and “trajectory is paused / interpreter state is PAUSED” are distinct observations.

## Resume

`EMC_TASK_PLAN_RESUME` calls `emcTrajResume()`, restores the interpreter state from `interpResumeState`, clears Task's paused flag, clears trajectory single-stepping, and resets Task stepping bookkeeping.

Engineering consequence: resume is a state transition that allows normal controller execution to continue. It is not evidence that the physical machine is in a safe or otherwise validated state; external prerequisites remain the responsibility of the machine/control/safety design.

## Abort

Pinned Task abort handling is intentionally broader than pause:

- Task abort sequencing stops/aborts subordinate motion;
- resets/restores Task state as appropriate;
- aborts I/O/spindle-related work;
- aborts MDI execution bookkeeping;
- closes/resets interpreter/planning work and clears pending/interpreter-list state in the error/abort paths;
- queues synchronization needed to rebuild the controller's internal world model.

The exact path depends on where the abort originates, but the conceptual boundary is stable: **abort changes controller execution state and clears/halts work; it is not an independent safety-rated stop function.**

## Pause versus abort

| Question | Pause | Abort |
|---|---|---|
| Intent | Temporarily stop/suspend execution with a resumable state | Cancel current/pending execution and reset/clear relevant controller work |
| Interpreter state | Saved and changed to PAUSED; resume restores it | Planning/interpreter state is reset/aborted rather than merely suspended |
| Trajectory action | `emcTrajPause()` / later `emcTrajResume()` | motion abort path |
| Queue semantics | A queued pause has an explicit motion+I/O precondition | abort/error cleanup clears pending/list work |
| Safety claim | None by itself | None by itself |

## Failure-state relevance

The separate T02 executor matrix shows that errors reported while waiting on subordinate motion/I/O drive executor state to `ERROR`; its cleanup then performs abort/reset/clear/synchronize behavior. Therefore, a failure can change Task's ability to accept or execute further queued work even though the interpreter had previously read more lines.

## What T02-019 verifies and what this source note supplies

T02-019 directly tests the AUTO queued motion→dwell ordering boundary because that is where a timing trace adds independent value. This source note supplies the distinct MANUAL/MDI and pause/resume/abort semantics required for 1000-level architectural competence without pretending the one AUTO experiment tested those other paths dynamically.

Promotion candidates if needed later:

- nested MDI/subroutine execution-level behavior;
- feed-hold versus Task pause under queued/blended motion;
- abort during I/O/toolchange/system-command wait states;
- state/mode transitions under fault races;
- version-drift comparison beyond the pinned SHA.
