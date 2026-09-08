# T02 fresh-AI handoff — Task layer

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Core model

LinuxCNC Task is an execution coordinator between interpreted/canonical work and subordinate motion/I/O. Do not collapse these evidence domains:

1. **Interpreter/read-ahead** — program blocks can be read and converted ahead of machine execution.
2. **Task queue selection and executor state** — `interp_list` work is selected, checked against preconditions, issued, then governed by postconditions.
3. **Subordinate motion/I/O status** — trajectory and I/O can still be busy after Task has issued a command or selected a later queued command.
4. **Physical device truth** — controller status does not by itself prove actual actuator/encoder/transport truth.
5. **Safety state** — Task pause/abort/error handling is ordinary control logic, not an independently safety-rated function.

The durable rule is: **program-line progress, Task command selection, command issue, subordinate completion, physical completion, and safe state are different claims and need evidence from the appropriate domain.**

## Representative pinned flow

`Task main loop -> emcTaskPlan() -> AUTO interpreter/canonical work -> interp_list -> emcTaskExecute() -> emcTaskCheckPreconditions() -> emcTaskIssueCommand() -> emcTaskCheckPostconditions() -> subordinate motion/I/O status -> next executor transition`

For the representative pair studied in T02:

- queued `EMC_TRAJ_LINEAR_MOVE` has `WAITING_FOR_IO` as its precondition and `DONE` as its Task postcondition, permitting Task to continue feeding trajectory work without waiting for that move's endpoint;
- queued `EMC_TRAJ_DELAY` has `WAITING_FOR_MOTION_AND_IO` as its precondition and `WAITING_FOR_DELAY` after issue, so the delay is held until prior subordinate work is complete.

## Independent verification

T02-019 workflow `34179865160` passed all frozen Gates A-G at lab exit `0`.

The accepted 2,110-sample trace observed:

- actual motion with `inpos=0`;
- `EXEC_WAITING_FOR_MOTION_AND_IO` while motion was independently incomplete;
- `current_line=4` and `read_line=4` already identifying the dwell during that incomplete-motion interval;
- no `EXEC_WAITING_FOR_DELAY` while `inpos=0`;
- `EXEC_WAITING_FOR_DELAY` only after `inpos=1`;
- a `0.748012 s` observed delay-state span for frozen `G4 P0.75`;
- clean completion with zero error-channel messages.

This directly demonstrates why a line number cannot be used as a motion-completion oracle.

## Mode and lifecycle semantics

### MANUAL

Manual jog/home and applicable machine commands use a distinct planning/immediate-command path rather than AUTO file read-ahead. Do not transfer AUTO `interp_list` pre/postcondition assumptions to a manual command without tracing its ingress path.

### AUTO

AUTO is the representative program/read-ahead path studied dynamically. Interpreter line state, Task executor state, and motion completion can diverge in time.

### MDI

MDI is interpreter-backed but has its own planner branch and MDI execution/nesting bookkeeping. It is not simply AUTO with one line.

### Pause/resume

A queued Task pause waits behind a motion+I/O precondition. Issuing pause pauses trajectory and preserves/restores interpreter resume state. Resume lets controller execution continue; neither operation proves physical or safety prerequisites outside LinuxCNC have been satisfied.

### Abort/error

Abort/error handling halts/aborts subordinate controller work, clears/resets pending Task/interpreter work and synchronizes controller state as appropriate. It is ordinary controller recovery behavior, not a safety-rated stop function.

## Queue-buster/read-ahead rule

When an interpreter result depends on machine/world state that cannot safely be predicted under read-ahead, LinuxCNC uses synchronization/queue-buster mechanisms such as `INTERP_EXECUTE_FINISH` for applicable operations. Treat that as an interpreter/Task synchronization boundary. It does not eliminate the need for independent evidence when making a physical-device or safety claim.

## Novel scenario test

Scenario: a custom integration watches `linuxcnc.stat().current_line` and wants to trigger a camera after a slow `G1` reaches its endpoint. The next line is a dwell. During execution the integration sees the dwell line selected and triggers the camera, but the captured part is visibly still moving.

**Expected reasoning:** the integration used the wrong evidence domain. T02-019 experimentally demonstrated the exact possibility: Task/read-line state can already identify the dwell while the prior motion remains incomplete and Task is still in `WAITING_FOR_MOTION_AND_IO`. The integration must sequence the camera through a controller mechanism with defined execution ordering or independently verify the relevant motion/feedback completion state. If image timing is safety-critical, ordinary Task status is not a substitute for a suitable safety architecture.

A fresh AI passes T02 when it diagnoses this as an ordering/oracle defect rather than a mysterious camera or trajectory bug.

## Promotion queue / counterfactual audit

- Direct dynamic observation of `INTERP_EXECUTE_FINISH` drain/synchronization during remap/M66/probing — **2000, HIGH**. Source/docs establish the mechanism and T02-019 independently establishes Task-vs-motion timing; lack of this additional experiment does not invalidate the bounded 1000-level Task model.
- Nested MDI/subroutine execution-level behavior — **2000, MEDIUM**. The 1000-level distinction that MDI has its own interpreter-backed Task path remains valid even if deeper nesting semantics expose corner cases.
- Feed-hold vs queued Task pause during blended motion — **2000, MEDIUM**. Could refine operator-control behavior but cannot reverse the source-confirmed pause precondition or T02-019 delay result.
- Abort during toolchange/system-command/I/O wait races — **2000, HIGH** for fault-recovery specialization. The 1000-level claim is bounded to ordinary Task abort/error sequencing and explicitly makes no independent safety claim.
- Version-drift audit beyond the pinned SHA — **2000, MEDIUM**. Reverify implementation-specific behavior before applying it to another revision.

Counterfactual test: even if a later remap timing experiment, nested MDI case, pause corner case, abort race, or later LinuxCNC revision differs, none can invalidate the accepted pinned motion→delay experiment or the architectural requirement to keep interpreter, Task, subordinate, physical, and safety evidence separate. No critical uncertainty remains hidden in a promotion item.

## 1000-level graduation audit

- Documentation/community baseline: PASS — official Task/read-ahead/status documentation and community field reports were reconciled with pinned source.
- Commands traced from Task into motion requests: PASS — `call-flows/T02-interp-list-to-motion-gated-delay.md` and the execution-state matrix trace selection, preconditions, issue, postconditions, subordinate waits, and error transitions.
- AUTO/MDI/MANUAL semantics distinguished: PASS — `guides/T02-mode-pause-abort-semantics.md` maps the different planning/ingress paths.
- Pause/resume/abort mapped: PASS — source-level pause precondition, issue, resume and abort/error cleanup are documented with explicit safety boundary.
- Queue-busting/look-ahead boundary: PASS — inherited interpreter architecture plus official documentation and T02-019's line-ahead anti-circular observation establish why read-ahead and Task/motion state differ; deeper dynamic queue-buster timing is explicitly promoted.
- Failure-relevant Task state transitions: PASS — `guides/T02-task-execution-state-matrix.md` covers motion/I/O error transitions and Task ERROR cleanup.
- Independent verification: PASS — T02-019 workflow `34179865160`, final lab exit `0`, frozen Gates A-G all PASS.
- Predeclared prediction checked: PASS — T02-019 was frozen before implementation; attempt 1 was rejected as HARNESS_INVALID without weakening criteria; corrected attempt 2 passed unchanged gates.
- Adversarial exam: PASS — `exams/T02-adversarial-exam.md`, 10/10.
- Fresh-AI competency: PASS — novel scenario above requires diagnosing a real ordering/oracle defect rather than recalling state names.
- Critical uncertainty promoted: NONE.
- Promotion justification/counterfactual test: PASS.

**Decision: T02 GRADUATED at 1000 level.**
