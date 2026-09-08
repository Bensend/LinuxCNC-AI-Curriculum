# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T02 — task layer** are **GRADUATED at 1000 level**. **T03 — NML architecture and messages** is the highest-priority unblocked module and is active in **SOURCE**, with its first experiment frozen before implementation at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

## T02 graduation evidence

Durable artifacts:

- `guides/T02-task-layer-research.md`
- `guides/T02-task-execution-state-matrix.md`
- `guides/T02-mode-pause-abort-semantics.md`
- `call-flows/T02-interp-list-to-motion-gated-delay.md`
- frozen plan `experiments/T02-019-task-motion-gated-delay-plan.md`
- harness `lab-jobs/019-t02-task-motion-gated-delay.sh`
- attempt-1 classification `experiments/T02-019-attempt-1-harness-invalid.md`
- accepted result `experiments/T02-019-run-34179865160-accepted.md`
- `exams/T02-adversarial-exam.md`
- `guides/T02-fresh-ai-handoff.md`

T02-019 workflow `34179865160`, authoritative Actions job `101916590952`, final lab exit `0`, passed frozen Gates A-G on materially similar attempt 2/3. The accepted trace preserved 2,110 samples. It directly observed `EXEC_WAITING_FOR_MOTION_AND_IO` while motion was independently incomplete, observed no `WAITING_FOR_DELAY` while incomplete, then measured `0.748012 s` in `WAITING_FOR_DELAY` for frozen `G4 P0.75` before clean completion.

The adversarial result is especially important: interpreter/read-ahead reached beyond the dwell while the preceding move was still incomplete. Therefore line/read-ahead progress is experimentally disproven as a motion-completion oracle for the representative pinned path.

The accepted-result draft contained one metadata typo in the job ID; it was corrected from `101916753555` to the authoritative workflow job `101916590952` without changing any technical evidence or conclusion.

### T02 graduated teaching

Task is a non-realtime execution coordinator. Interpreter/read-ahead progress, Task queue selection, Task command issue/postcondition, subordinate motion/I/O completion, physical device truth and safety state are distinct evidence domains.

Representative pinned path:

`Task main loop -> emcTaskPlan() -> AUTO interpreter/canonical work -> interp_list -> emcTaskExecute() -> precondition -> issue -> postcondition -> subordinate status -> next executor state`

A queued linear move may leave Task free to process later queued commands, while a following queued delay is held behind `WAITING_FOR_MOTION_AND_IO` and enters `WAITING_FOR_DELAY` only after subordinate completion.

T02 adversarial exam: **10/10 PASS**. Fresh-AI handoff and counterfactual promotion audit: **PASS**. Decision: **T02 GRADUATED at 1000 level**.

### T02 promotion queue

- Direct dynamic `INTERP_EXECUTE_FINISH` / remap queue-buster drain timing — **2000, HIGH**.
- Nested MDI/subroutine execution-level behavior — **2000, MEDIUM**.
- Feed-hold versus queued Task pause under blended motion — **2000, MEDIUM**.
- Abort during toolchange/system-command/I/O wait races — **2000, HIGH** for recovery specialization.
- Version-drift audit beyond pinned SHA — **2000, MEDIUM**.

Counterfactual audit: none can invalidate the bounded pinned T02 source path, accepted motion→delay experiment or the requirement to separate interpreter, Task, subordinate, physical and safety evidence.

## T03 current evidence

Durable artifacts now include:

- `guides/T03-nml-architecture-research.md`
- `call-flows/T03-python-command-status-error-nml.md`
- `guides/T03-command-acknowledgement-boundary.md`
- frozen plan `experiments/T03-020-nml-ack-vs-semantic-result-plan.md`

### Documentation/community baseline

Official LinuxCNC documentation establishes the UI-facing command/status/error NML model, `linuxcnc.stat()` status surface and `[EMC] NML_FILE` configuration boundary. Community field reports about `wait_complete()`, serial/echo handling, concurrent HALUI/Python command producers and state-invalid `EMC_TASK_PLAN_STEP` behavior were reconciled as supporting field evidence rather than authority over pinned source.

### Pinned source model

T03 currently distinguishes three ordinary userspace evidence streams:

```text
Python/UI command -> RCS_CMD_CHANNEL "emcCommand" -> Task semantic planning/dispatch
Task world/status  -> RCS_STAT_CHANNEL "emcStatus" -> stat.poll()/wait_complete()
operator reporting -> NML "emcError" -> error_channel().poll()
```

`emcFormat()` provides message serialization/type dispatch, not Task machine-control semantics. Task and Python clients each open the named channels from the configured NML file; optional `emcsvr` exposes the same channel model for remote NML service rather than replacing it with a realtime motion protocol.

### Serial acknowledgement boundary — source-confirmed

Pinned `emcmodule.cc` shows:

- `emcSendCommand()` writes the command, saves its `serial_number`, and waits until status echo reaches that serial or later;
- `wait_complete()` polls for the saved serial, returning matching aggregate DONE/ERROR, treating a greater echo serial as DONE, and timing out to UNINITIALIZED after the requested/default interval;
- default timeout is five seconds and nominal poll delay is 10 ms.

Pinned `emctaskmain.cc` shows:

- Task treats the command as new while command serial differs from status echo;
- at cycle end Task copies the command serial into top-level/task echo fields;
- aggregate status is independently derived from planning/execution/subordinate state;
- therefore Task can echo a command whose semantic planner result is ERROR.

Central T03 teaching already source-confirmed: **NML transport/echo acknowledgement is not semantic acceptance, controller completion, physical completion, or safety truth.**

## T03-020 frozen experiment

`experiments/T03-020-nml-ack-vs-semantic-result-plan.md` freezes two cases:

1. valid `STATE_ESTOP_RESET`: require new client serial, echoed serial, `wait_complete()==RCS_DONE`, and independent Task-state observation;
2. invalid while ESTOP `command.auto(AUTO_STEP)`: pinned Python maps this to `EMC_TASK_PLAN_STEP`; require a new serial and echoed acknowledgement **but** matching aggregate `RCS_ERROR`/`wait_complete()==RCS_ERROR` plus an independently captured operator error saying the command is prohibited by E-stop/machine state.

Gates A-G and raw evidence requirements are frozen. No later command may be issued until the negative case's matching ERROR evidence is captured, preventing a later greater serial from masking the exact result.

## Current checkpoint / exact resume point

Resume **T03-020 implementation** without changing the frozen plan.

1. Build `lab-jobs/020-t03-nml-ack-vs-semantic-result.sh` against the pinned stock simulation/RIP build.
2. Preserve exact executable/Python-module/source SHA provenance.
3. Capture raw monotonic serial/echo/status/state/wait-complete/error-channel evidence for both cases.
4. Run the harness once and preserve the workflow/job identity, lab exit code, stdout/stderr and raw trace.
5. Reconcile Gates A-G unchanged. The decisive negative result must be `echoed=true` together with `semantic_success=false` and independent operator-error evidence.
6. If the matching status/error transition is missed because of polling or error-drain timing, classify HARNESS_INVALID and materially improve observability; do not weaken the acknowledgement-vs-success boundary.
7. After accepted behavioral verification, continue the NML library/transport inventory, error-buffer queue/overwrite semantics, remote failure boundaries, adversarial exam, fresh-AI handoff, promotion audit and T03 graduation review.

## Session-recovery note

A prior session marker beginning `2026-09-08T02:11:10.538872Z` remained `OPEN` even though durable commits through `2026-09-08T02:35:41Z` had already completed T02 graduation artifacts and begun T03. Those artifacts were recovered as authoritative repository state rather than duplicated. That prior session's exact end timestamp is unavailable, so no fabricated timing row is being added for it; the current session records the uncertainty explicitly in its own timing/overlap note.

## Prior promotion queue retained

S04-S07 promotion items remain active in their graduated handoff artifacts, including device-specific stale-feedback semantics, transport/LLIO fault behavior, absolute-encoder restart provenance, and abnormal-process/HAL-lifetime corner cases.
