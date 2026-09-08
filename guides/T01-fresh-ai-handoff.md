# T01 fresh-AI handoff — G-code interpreter architecture

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Core model

Do not collapse interpretation into execution. T01 separates at least four evidence domains:

1. **Read/parse state** — `Interp::read()` obtains and parses a block.
2. **Interpreter execution/conversion state** — `Interp::execute()` / `execute_block()` performs semantic conversion such as `convert_motion()`.
3. **Canonical/Task queue state** — canonical calls such as `STRAIGHT_TRAVERSE()` become controller messages and are appended to Task's `interp_list` through `tag_and_send()`.
4. **Machine execution/physical state** — queued work must still be consumed and executed; realtime motion, actuators and physical feedback are separate evidence.

Representative pinned call flow:

`Task emcTaskPlanRead()/emcTaskPlanExecute() -> Interp::read()/execute() -> execute_block() -> convert_motion() -> STRAIGHT_TRAVERSE() -> tag_and_send() -> interp_list`

The durable rule is: **interpreter predicted state or canonical output is not proof of physical completion.**

## Independent verification

T01-018 workflow `34172719263` built the pinned standalone `rs274` executable and ran separate fixtures. The valid `G0 X1 Y2` invocation exited `0` and emitted `STRAIGHT_TRAVERSE(1.0000, 2.0000, ...)`. The malformed `G0 X[1+]` invocation exited `1`, emitted a number-format conversion diagnostic, and emitted no successful traversal corresponding to the malformed command. Frozen Gates A-E all passed.

This verifies the bounded interpreter-to-canonical success/error boundary. It intentionally does not verify Task read-ahead timing or physical execution.

## Read-ahead and queue-buster rule

LinuxCNC's documented architecture allows the interpreter to run ahead because canonical operations are queued for Task. When a result cannot be predicted safely for continued interpretation, queue-buster behavior uses `INTERP_EXECUTE_FINISH`; Task drains the necessary queued work, synchronizes the interpreter/world model, and later resumes read-ahead. Examples documented by LinuxCNC include M66 reads, tool changes, and probing.

Treat that as a Task/interpreter synchronization mechanism, not as a functional-safety guarantee.

## Error/debugging rule

When debugging a G-code failure, distinguish:

- parse/read failure,
- semantic/conversion failure,
- canonical command generation,
- Task queueing/consumption,
- realtime motion execution,
- physical feedback.

A successful earlier canonical command in the same file must not be mistaken for successful execution of a later malformed block. That is why T01-018 used separate valid and invalid interpreter invocations.

## Novel scenario test

Scenario: an AUTO program contains `G0 X10`, then a remapped M-code that reads an external device and records a timestamp, then `G0 X20`. During a run, the remap observes the old device state even though the interpreter's predicted X position is already 10. An engineer says, "X10 completed because the interpreter already thinks it is at X10, so the device must be faulty."

**Expected reasoning:** reject that conclusion. Interpreter predicted position can be ahead of physical execution because canonical operations are queued. At least two explanations remain possible: the remap/device side effect occurred under read-ahead before X10 physically completed, or the device/measurement path itself was stale even after motion completed. Distinguish them with independent Task/queue synchronization evidence, motion/feedback timing, and device freshness/provenance. Interpreter predicted position alone proves neither explanation.

A fresh AI passes T01 when it separates these domains, identifies the queue/read-ahead mechanism, and asks for independent physical/freshness evidence rather than inferring completion from interpreter state.

## Promotion queue / counterfactual audit

- Dynamic Task/remap queue timing and direct observation of `INTERP_EXECUTE_FINISH` drain/synch behavior — **T02 / 2000, HIGH**. Useful because T01-018 stops at the interpreter/canonical boundary. Non-blocking because pinned source plus official documentation establish the architecture and T01 explicitly does not claim dynamic Task timing was tested.
- Detailed parser grammar internals and modal/error corner cases beyond the representative rapid/error path — **2000, MEDIUM**. Non-blocking because a different corner-case result would not invalidate the read/execute/canonical/physical boundary.
- Version-drift audit on interpreter internals after the pinned SHA — **2000, MEDIUM**. All implementation-level claims must be reverified before carrying them to another revision.

Counterfactual promotion test: even if future Task timing, a parser corner case, or a later revision differs, the 1000-level claim remains bounded to the pinned representative source path and accepted standalone experiment. None of the promoted uncertainties weakens the explicit safety boundary.

## 1000-level graduation audit

- Documentation/community baseline: PASS — official read-ahead/remap documentation plus community behavior reports were reconciled with source rather than treated as primary authority.
- Source mechanism: PASS — representative Task -> interpreter -> conversion -> canonical -> `interp_list` path traced at the pinned SHA.
- Independent verification: PASS — T01-018 workflow `34172719263`, final lab exit `0`, frozen Gates A-E all PASS.
- Representative failure behavior: PASS — deliberately malformed expression followed the interpreter error path with nonzero exit and no false traversal for the invalid command.
- Predeclared prediction checked: PASS — experiment criteria were frozen before implementation.
- Adversarial exam: PASS — `exams/T01-adversarial-exam.md` covers misleading premises, failure paths, version sensitivity, debugging and modification reasoning.
- Fresh-AI competency: PASS — novel scenario above requires separating predicted interpreter state from Task/motion/device truth.
- Critical uncertainty promoted: NONE.
- Promotion justification/counterfactual test: PASS.

**Decision: T01 GRADUATED at 1000 level.**
