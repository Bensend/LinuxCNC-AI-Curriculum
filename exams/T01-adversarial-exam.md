# T01 — adversarial exam: interpreter architecture

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: DRAFTED DURING EXPERIMENT; answers source-checked, graduation still depends on T01-018 reconciliation and fresh-AI handoff.

## Questions

1. A debugger shows `Interp::execute_block()` has returned successfully for `G0 X25`. An engineer concludes the machine is already at X25. Identify the false premise and trace the minimum source path needed to disprove it.
2. Trace a representative AUTO rapid from Task into the interpreter and back out as queued controller work. Name the read/execute split and the canonical/queue boundary.
3. A malformed block is accepted by `Interp::read()` but later fails during semantic conversion. Where can the failure originate, how is it propagated to Task, and why must the operator-visible error not be described as a safety-rated stop?
4. Misleading premise: "Because canonical functions have names like `STRAIGHT_TRAVERSE`, they perform trajectory motion directly." Correct this using the pinned LinuxCNC implementation.
5. A Python remap toggles an external device immediately after a programmed move. On a real machine the side effect happens before the move physically finishes. Explain the mechanism and identify the interpreter return/synchronization concept that must be investigated when ordering requires execution to catch up.
6. Version-sensitive question: if a later LinuxCNC revision changes the internals of `Interp::_read()` but preserves the public Task/interpreter interface, which T01 claims can be carried forward only after source re-verification, and which architectural claims might remain plausible but still cannot be silently generalized?
7. Debugging scenario: standalone `rs274` prints a `STRAIGHT_TRAVERSE` for a valid file, but a Task-level remap still exhibits surprising timing. Why is the standalone test insufficient evidence for Task read-ahead timing?
8. Small modification task: you need to instrument every canonical rapid command before it is appended to the Task interpreter list, without modifying the parser. Identify a bounded source location where instrumentation could be placed and state what semantic information would and would not yet prove physical execution.
9. Failure-path control: why must the valid and invalid T01-018 fixtures run in separate interpreter invocations when the experiment's oracle asks whether malformed input generated successful canonical motion?
10. Novel scenario: an AUTO program has `G0 X10`, then a remapped M-code that reads an external sensor, then `G0 X20`. The remap's Python code observes the old physical sensor condition even though interpreter predicted position is already X10. Give two different explanations consistent with T01 and state what evidence would distinguish them.

## Source-checked answer key

1. Successful interpreter execution proves semantic translation, not physical completion. The minimum source chain is Task `emcTaskPlanRead()/emcTaskPlanExecute()` -> `Interp::read()/execute()` -> `execute_block()/convert_motion()` -> canonical `STRAIGHT_TRAVERSE()` -> `tag_and_send()` -> append to `interp_list`. The queued message is later consumed by Task/motion; physical feedback is a separate evidence domain.
2. Task calls `emcTaskPlanRead()` then `emcTaskPlanExecute()`; interpreter read/parse is separate from execution; rapid conversion reaches canonical `STRAIGHT_TRAVERSE`; Task-side `emccanon.cc` constructs a trajectory message and `tag_and_send()` appends it to `interp_list`.
3. Failure may arise during parsing/read or later execute/conversion. Interpreter error returns propagate through Task wrappers; `print_interp_error()` records/emits diagnostics. This is ordinary machine-control error handling and no independent safety integrity has been established.
4. In the pinned controller canonical implementation, `STRAIGHT_TRAVERSE()` transforms state and builds trajectory command data; `tag_and_send()` queues the message. It is not the realtime trajectory executor.
5. Interpreter read-ahead can execute remap/Python logic while earlier queued motion remains incomplete. `INTERP_EXECUTE_FINISH` is the key synchronization/queue-buster return that tells Task normal read-ahead cannot simply continue; exact remap behavior belongs to the relevant source path.
6. Any detailed claim about parsing branches, structures, exact return paths, or implementation ordering must be rechecked at the later SHA. Higher-level architecture may remain likely if public interfaces remain, but version discipline forbids silently carrying source-confirmed implementation claims across revisions.
7. Standalone `rs274` independently verifies interpreter-to-canonical semantics/error behavior, not the Task state machine's consumption/draining of `interp_list`, remap scheduling, or synchronization timing.
8. A bounded location is Task-side `STRAIGHT_TRAVERSE()` or immediately around `tag_and_send()` in `src/emc/task/emccanon.cc`. Instrumentation there can prove canonical command generation/queueing plus associated state/tag data, but not realtime start, actuator motion, or physical completion.
9. A mixed file could legitimately emit canonical output for earlier valid blocks before later malformed input fails. Separate invocations eliminate that ambiguity and make "no successful canonical motion for the invalid command" independently observable.
10. Explanation A: normal read-ahead allowed the remap side effect before queued X10 motion physically completed. Explanation B: the relevant sensor/device path itself is stale/delayed even if motion did complete. Distinguish them with Task/interpreter queue/synchronization evidence plus independent motion-position and sensor-freshness timestamps/oracles; interpreter predicted position alone distinguishes neither.

## Pass standard

A fresh learner must correctly reject parser/execution == physical execution, trace the representative source path, explain one failure path, identify the queue boundary and synchronization concept, preserve version and safety boundaries, and solve the novel scenario without treating interpreter predicted state as physical truth.
