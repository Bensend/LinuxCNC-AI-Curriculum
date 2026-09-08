# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T01 — G-code interpreter architecture** are **GRADUATED at 1000 level**. **T02 — task layer** is now the highest-priority unblocked module and is active in **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

## T01 graduation evidence

Durable artifacts:

- `guides/T01-interpreter-source-guide.md`
- `call-flows/T01-task-to-canonical-rapid.md`
- frozen plan `experiments/T01-018-interpreter-canonical-and-error-plan.md`
- lab harness `lab-jobs/018-t01-interpreter-canonical-error.sh`
- accepted result `experiments/T01-018-run-34172719263-accepted.md`
- `exams/T01-adversarial-exam.md`
- `guides/T01-fresh-ai-handoff.md`

Pinned source-confirmed representative path:

`Task emcTaskPlanRead()/emcTaskPlanExecute() -> Interp::read()/execute() -> execute_block() -> convert_motion() -> STRAIGHT_TRAVERSE() -> tag_and_send() -> interp_list`

T01-018 workflow `34172719263` completed with final committed lab exit `0`. The valid `G0 X1 Y2` invocation exited `0` and emitted `STRAIGHT_TRAVERSE(1.0000, 2.0000, ...)`; the separate malformed `G0 X[1+]` invocation exited `1` with a number-format conversion diagnostic and no successful traversal corresponding to the malformed command. Frozen Gates A-E all passed.

Central graduated teaching: interpreter read/execute state, canonical/Task queue state, realtime execution, and physical machine state are distinct evidence domains. Canonical output or interpreter predicted position does not prove physical motion has started or completed.

### T01 promotion queue

- Dynamic Task/remap queue timing and direct `INTERP_EXECUTE_FINISH` drain/synch observation — **T02 / 2000, HIGH**. Non-blocking for T01 because the dynamic Task timing claim was explicitly not made.
- Detailed parser grammar/modal/error corner cases — **2000, MEDIUM**.
- Version-drift audit beyond pinned SHA — **2000, MEDIUM**.

Counterfactual audit: none of these promoted uncertainties can invalidate the bounded pinned T01 source path or accepted standalone experiment, and none weakens the explicit safety boundary.

## T02 current evidence

Durable artifacts:

- `guides/T02-task-layer-research.md`
- `guides/T02-task-execution-state-matrix.md`
- `call-flows/T02-interp-list-to-motion-gated-delay.md`
- frozen plan `experiments/T02-019-task-motion-gated-delay-plan.md`

Documentation baseline: EMCTASK coordinates motion and discrete I/O; `[TASK] CYCLE_TIME` is the non-realtime Task polling cadence. The Python status interface exposes Task `exec_state`, giving T02 a direct NML/status oracle rather than requiring inference from GUI activity.

Pinned source now establishes the main plan/execute relationship and the representative queue path:

1. the main Task loop calls `emcTaskPlan()` then `emcTaskExecute()` cyclically;
2. AUTO planning can continue interpreter read-ahead while `interp_list` remains below its configured bound;
3. executor `DONE` removes the next `interp_list` item, records its line/motion id, and evaluates `emcTaskCheckPreconditions()`;
4. once preconditions become `DONE`, `emcTaskIssueCommand()` issues the retained command and `emcTaskCheckPostconditions()` selects the next executor state;
5. issue failure becomes Task `ERROR`.

Representative source-confirmed distinction:

- queued `EMC_TRAJ_LINEAR_MOVE` has precondition `WAITING_FOR_IO` and postcondition `DONE`, so Task may keep feeding trajectory moves without waiting for each move's physical completion;
- queued `EMC_TRAJ_DELAY` has precondition `WAITING_FOR_MOTION_AND_IO`; only after both subordinate statuses are DONE is the delay issued, after which its postcondition is `WAITING_FOR_DELAY`.

This yields a strong experiment surface: a slow linear move followed by dwell should expose a Task motion/I/O barrier before the dwell timer begins. The source also proves that `currentLine`, interpreter read-ahead, Task executor state, and motion completion are separate progress domains.

Failure behavior is source-grounded: motion/I/O `RCS_STATUS::ERROR` in the relevant wait states drives Task to `ERROR`; the Task error branch aborts subordinate work, clears pending/interpreter queues, resets planning/interpreter state, and queues synchronization. This remains ordinary controller error handling, not an independent safety function.

## Current checkpoint / exact resume point

Resume **T02 — task layer** at frozen experiment **T02-019**. Do not alter Gates A-G after observing runtime results.

1. Implement a reproducible pinned-build lab harness for `experiments/T02-019-task-motion-gated-delay-plan.md` using a stock simulation configuration.
2. The sampler must record raw monotonic timestamps plus direct `linuxcnc.stat().exec_state`, interpreter/Task line fields, `inpos`, and position/motion evidence. Reject line number as a motion-completion oracle.
3. Execute once and preserve workflow/job ID, exit code, stdout/stderr and raw trace. Do not launch a duplicate while the first run is active.
4. Reconcile frozen Gates A-G. In particular require `EXEC_WAITING_FOR_MOTION_AND_IO` before dwell issue and prohibit `EXEC_WAITING_FOR_DELAY` while independent motion evidence says the preceding move is incomplete.
5. Only after accepted independent verification proceed to T02 adversarial exam, corrections, fresh-AI handoff, promotion counterfactual audit and graduation decision.
6. Dynamic direct observation of `INTERP_EXECUTE_FINISH`/remap read-ahead remains a T01 promotion item; incorporate it only if it adds distinct information without expanding T02-019 after freeze.

Safety boundary remains unchanged: Task state transitions, waits, queueing and abort sequencing are ordinary LinuxCNC machine-control behavior, not evidence of a safety-rated function.

## Prior promotion queue retained

S04-S07 promotion items remain active in their graduated handoff artifacts, including device-specific stale-feedback semantics, transport/LLIO fault behavior, absolute-encoder restart provenance, and abnormal-process/HAL-lifetime corner cases.
