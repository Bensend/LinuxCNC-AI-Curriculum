> **CORRECTION (PLASMA-202, 2026-11-04):** This lesson correctly describes *M66 L1* rising-edge Task behavior, but incorrectly applies it to QtPlasmaC's `M66 P3 L3 Q1`. **L3 is HIGH-level wait, not RISE**; an already-high input can satisfy L3. All QtPlasmaC held-high timeout implications in this document are superseded by [PLASMA-202](3300_LINUXCNC_PLASMA_202_M66_L3_HIGH_AND_5399_RESULT_CORRECTION_2026-11-04.md). No runtime test performed.

# PLASMA-201 — M66 rising-edge and Task timeout semantics (LinuxCNC 2.9.10)

Status: **SOURCE-CONFIRMED narrowly; NOT TEST-CONFIRMED**. Non-graduated 3300 plasma / interpreter implementation research. No machine or workflow execution.

## Source provenance
- LinuxCNC v2.9.10 peeled commit `86cdca76fa2a36274c432caa21952b23c267989a`.
- [emctaskmain.cc at pinned revision](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/emc/task/emctaskmain.cc), specifically `getPreconditions()`, `emcTaskIssueCommand()`, `EMC_TASK_EXEC_WAITING_FOR_DELAY` in the Task executor. Inspect code at revision rather than trusting line numbers on a moving branch.
- Prior local [PLASMA-200](3300_LINUXCNC_PLASMA_200_M190_M66_MATERIAL_HANDSHAKE_SOURCE_TRACE_2026-11-04.md) traced development QtPlasmaC M190 and material-change UI; this lesson traces **stable 2.9.10 Task**, not an asserted identical development implementation.
- Historical M66-140 lab evidence is a **separate prior runtime variant**, not proof for the scenarios below. Before any runtime test, inspect `LAB_COMPUTE_LOG.md`, `lab-jobs/079-pb-m66-timeout-stale-dwell.sh` and retained run 34593401753-1 to avoid duplicate work.

## Actual Task state transitions
1. `getPreconditions()` assigns `EMC_AUX_INPUT_WAIT_TYPE` the `EMC_TASK_EXEC_WAITING_FOR_MOTION_AND_IO` precondition; a program wait is not an unsequenced background poll.
2. `emcTaskIssueCommand()` captures `wait_type` and `index`, sets `task.input_timeout=2` (pending), and sets `taskExecDelayTimeout=etime()+timeout` for non-immediate waits. Immediate mode clears the index and timeout.
3. In `EMC_TASK_EXEC_WAITING_FOR_DELAY`, elapsed deadline sets `execState=DONE`, `delayLeft=0`, and (if nonzero) `input_timeout=1`. **The timeout branch does not itself assign `EXEC_ERROR`.** Thus the wait completing is not proof of successful material selection.
4. For `WAIT_MODE_RISE`, Task first waits to *observe low* and only then switches to `WAIT_MODE_HIGH`; that mode completes when the input is high, clearing `input_timeout=0`, index=-1 and marking DONE. An input already high when the wait begins does **not** immediately satisfy a rising-edge wait.
5. The low-to-high transition must be observed across Task polls. A brief pulse that starts and ends between polls may be missed. No polling-period numerical guarantee is established here.
6. In the inspected loop the deadline check precedes the input-state check, and the latter can also set DONE/clear timeout in the same iteration. Exact deadline-edge outcome and whether an old index persists after timeout deserve executable verification. Avoid claiming deterministic priority from source ordering alone.

## Practical QtPlasmaC integration implications
- `M190 P...` and `M66 P3 L3 Q1` form a **protocol**, not an atomic success assertion. The Task wait's timeout is a status result; postprocessor authors must not treat interpreter progress as confirmation that the requested material was accepted.
- A readiness line held high before M66 starts can cause the rising-edge wait to time out. A producer must provide a deliberately sequenced low→high acknowledgment with adequate observation duration; do not add a blind output pulse without checking QtPlasmaC's actual handler protocol.
- An explicit guard using the documented M66 result variable (typically `#5399`) should be evaluated against the target interpreter/version and QtPlasmaC program conventions before recommending a production postprocessor change. **No claim is made here that the upstream conversational producer currently has such a guard.**
- No physical machine may use a proposed M66 timeout guard as an independent personnel-safety interlock.

## Disconnected reproducible verification matrix (NOT RUN)
A. Input starts HIGH and remains HIGH: expect no immediate rising-edge success; timeout candidate.
B. Input starts LOW, remains LOW across a Task poll, then HIGH: success candidate with timeout cleared.
C. Input toggles HIGH→LOW→HIGH while waiting: success candidate if both relevant levels sampled.
D. Narrow LOW/HIGH pulse entirely between polls: missed edge candidate.
E. LOW→HIGH at exact deadline: record status and `#5399`; do not pre-score priority.
F. Timeout then second M66 or G4: inspect stale index/delay interaction, compare to existing historical M66-140 runtime before deciding whether a new version-specific test is justified.

Capture pinned binary version, HAL input trace, Task state/status, actual G-code progression, `#5399`, timestamps and full output. Never count source predictions as runtime evidence. Only run on verified isolated `[self-hosted, openpressbrake]` if justified; never hosted Actions.

## Evidence / next
Confirmed: Task precondition, timeout status assignments, rising-edge low-then-high state machine, source ordering. Unverified: actual QtPlasmaC timing, precise boundary races, runtime status propagation and CAM postprocessor behavior. Next inspect canonical interpreter M66 result publication and whether the QtPlasmaC program consumes it, then consider an openly licensed CAM postprocessor if an inspectable implementation is available. Graduated and blind gates unchanged.
