# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T01 — G-code interpreter architecture** are **GRADUATED at 1000 level**. **T02 — task layer** is now the highest-priority unblocked module and is active in **RESEARCH** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

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

Official LinuxCNC documentation independently describes queued canonical operations, interpreter read-ahead, and queue-buster synchronization through `INTERP_EXECUTE_FINISH`. T01-018 intentionally stopped at the standalone interpreter/canonical boundary rather than pretending to dynamically verify Task timing.

### T01 promotion queue

- Dynamic Task/remap queue timing and direct `INTERP_EXECUTE_FINISH` drain/synch observation — **T02 / 2000, HIGH**. Non-blocking for T01 because the dynamic Task timing claim was explicitly not made.
- Detailed parser grammar/modal/error corner cases — **2000, MEDIUM**.
- Version-drift audit beyond pinned SHA — **2000, MEDIUM**.

Counterfactual audit: none of these promoted uncertainties can invalidate the bounded pinned T01 source path or accepted standalone experiment, and none weakens the explicit safety boundary.

## T02 current evidence

Initial research artifact: `guides/T02-task-layer-research.md`.

Documentation baseline: EMCTASK coordinates motion and discrete I/O; Task/interpreter is non-realtime relative to the realtime motion controller. Remap documentation identifies Task as consumer/coordinator of queued interpreter canonical work and describes queue-buster synchronization.

Pinned `src/emc/task/emctaskmain.cc` inspection has already separated:

1. immediate message dispatch through `emcTaskIssueCommand()`;
2. queued interpreter commands on `interp_list`, whose preconditions are classified by `emcTaskCheckPreconditions()`;
3. execution wait/state handling in `emcTaskExecute()` using `EMC_TASK_EXEC` states such as waiting for motion.

Representative pinned abort dispatch also shows Task explicitly sequencing Task abort, motion abort, interpreter-state restore, I/O/spindle/MDI abort, and cleanup. This is ordinary controller behavior, not independent functional safety.

## Current checkpoint / exact resume point

Resume **T02 — task layer** without repeating T01's interpreter lab.

1. Trace pinned Task main-loop planning into `emcTaskExecute()` and document the exact plan/execute relationship.
2. Trace `emcTaskCheckPreconditions()` and one representative queued trajectory command from `interp_list` through a waiting-for-motion transition to completion.
3. Build a Task execution-state/precondition matrix covering immediate versus queued commands, relevant `EMC_TASK_EXEC` wait states, completion/error conditions, and observable status/NML evidence.
4. Only after the state/oracle definitions are source-grounded, freeze T02's first experiment before implementation. Candidate behavior: a deterministic queued motion followed by a command whose issue is gated on motion completion, with independent Task-state and motion-state evidence.
5. Preserve the T01 promotion item for dynamic read-ahead/`INTERP_EXECUTE_FINISH` timing and incorporate it only if the T02 experiment can test it without conflating interpreter progress with physical execution.

Safety boundary remains unchanged: Task state transitions and abort sequencing are ordinary LinuxCNC machine-control behavior, not evidence of a safety-rated function.

## Prior promotion queue retained

S04-S07 promotion items remain active in their graduated handoff artifacts, including device-specific stale-feedback semantics, transport/LLIO fault behavior, absolute-encoder restart provenance, and abnormal-process/HAL-lifetime corner cases.
