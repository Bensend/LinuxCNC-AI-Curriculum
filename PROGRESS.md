# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T02 — task layer** are **GRADUATED at 1000 level**. **T03 — NML architecture and messages** is the highest-priority unblocked module and remains active in **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413` pending reconciliation of its completed laboratory result.

Repository artifacts, not chat history, remain authoritative. Detailed graduation evidence for earlier modules is preserved in their guides, call flows, experiments, exams, handoffs, accepted-result records, and Git history.

## T02 graduated teaching retained

T02-019 workflow `34179865160`, authoritative Actions job `101916590952`, final lab exit `0`, passed frozen Gates A-G with 2,110 samples and a measured `0.748012 s` WAITING_FOR_DELAY span for `G4 P0.75`.

Task is a non-realtime execution coordinator. Interpreter/read-ahead progress, Task queue selection, Task issue/postcondition state, subordinate motion/I/O completion, physical device truth and safety state are distinct evidence domains. The accepted experiment directly disproved line/read-ahead progress as a motion-completion oracle for the representative pinned path.

T02 adversarial exam, fresh-AI handoff and counterfactual promotion audit passed; T02 is GRADUATED at 1000 level.

T02 promotion queue remains: direct dynamic queue-buster timing (2000 HIGH), nested MDI/subroutine execution levels (2000 MEDIUM), feed-hold versus queued pause under blending (2000 MEDIUM), abort during toolchange/system/I/O races (2000 HIGH), and version drift beyond pinned SHA (2000 MEDIUM).

## T03 durable evidence

Current artifacts include:

- `guides/T03-nml-architecture-research.md`
- `call-flows/T03-python-command-status-error-nml.md`
- `guides/T03-command-acknowledgement-boundary.md`
- `guides/T03-buffer-transport-boundary.md`
- frozen plan `experiments/T03-020-nml-ack-vs-semantic-result-plan.md`
- implementation `lab-jobs/020-t03-nml-ack-vs-semantic-result.sh`

### Source-grounded model

T03 distinguishes three ordinary userspace evidence streams:

```text
Python/UI command -> RCS_CMD_CHANNEL "emcCommand" -> Task semantic planning/dispatch
Task world/status  -> RCS_STAT_CHANNEL "emcStatus" -> stat.poll()/wait_complete()
operator reporting -> NML "emcError" -> error_channel().poll()
```

Pinned `emcmodule.cc` establishes that `emcSendCommand()` writes the command, saves its serial and waits for status echo to reach that serial or later. `command.serial` and `stat.echo_serial_number` are directly exposed to Python. `wait_complete()` separately waits for matching DONE/ERROR, while a greater echo serial is treated as DONE for the older saved command boundary.

Pinned `emctaskmain.cc` establishes that Task publishes the command serial into status even when semantic planning fails, while aggregate status is derived separately. Therefore **serial echo/acknowledgement is not semantic acceptance, controller completion, physical completion, or safety truth.**

The pinned stock `configs/common/linuxcnc.nml` further distinguishes buffer roles: `emcCommand` is configured with `queue confirm_write serial`, `emcError` with `queue`, and `emcStatus` without `queue`. This supports the 1000-level rule that command identity/order, status snapshots, and queued operator reports are distinct observability surfaces. Exact saturation/drop/reconnect and remote-loss behavior remain unclaimed pending deeper libnml work.

### T03-020 frozen experiment and implementation

The unchanged frozen experiment has two cases:

1. valid `STATE_ESTOP_RESET`: require a new client serial, echoed serial, `wait_complete()==RCS_DONE`, independently observed requested Task state and no attributable operator rejection;
2. invalid while ESTOP `command.auto(AUTO_STEP)`: require a new serial and echoed acknowledgement **but** matching `RCS_ERROR`/`wait_complete()==RCS_ERROR` before any later command, plus independent operator-error evidence preserving the ESTOP/machine-state cause.

Gates A-G remain frozen. The implementation records pinned executable/Python provenance and emits a raw CSV containing monotonic time, case/phase, saved serial, echo serial, aggregate status, Task state/mode/execution/interpreter state, wait result and error tuples. No recovery command is issued until the negative matching ERROR and operator-error evidence are preserved.

Implementation commit: `0877652c3fe82722d99d81616c07a864ac3ae418`.

GitHub Actions workflow **`34182846956`**, authoritative job **`101925247534`**, completed successfully. Repository `lab-results/LATEST.exit_code.txt` is `0`. This is not yet a TEST-CONFIRMED claim: the next curriculum session must inspect stdout/stderr/raw CSV and apply frozen Gates A-G before accepting the result.

## Study-process changes now active

Three process changes are now operational rather than advisory:

1. **Blind external-feedback baseline:** after T03 reaches defensible 1000-level graduation, run the first development-bank blind challenge before starting the next major module cluster. Record the immutable precommitment, external score, confidence, solve time, error class, and study/compute exposure in `evaluation/FEEDBACK_SCORE_LOG.md`. Follow the cadence in `evaluation/BLIND_FEEDBACK_PROTOCOL.md`; do not expose sealed answers to the learner.
2. **Short-session continuation enforcement:** if a session has less than about 15 minutes of substantive work, a completed subtask, launched/waiting experiment, module graduation, or checkpoint is not sufficient reason to stop. Explicitly look for another useful unblocked task and continue unless the documented human/safety/context/overlap exceptions apply.
3. **Laboratory compute accounting:** `LAB_COMPUTE_LOG.md` is now the cumulative ledger. Record actual authoritative Actions job runtime for every material curriculum lab, including failed, cancelled, timeout, duplicate and harness-invalid attempts. Historical runtime should be backfilled only from authoritative timestamps; never invent it.

The purpose of these changes is to let later analysis compare blind competency, substantive lesson time, actual lab cost, transfer, retention and evidence quality rather than measuring repository activity alone.

## Exact resume checkpoint

Resume T03-020 from completed workflow **`34182846956`** / job **`101925247534`**. Do not launch a duplicate merely because the result has not yet been reconciled.

1. Inspect repository-recorded `lab-results/LATEST*`, stdout, stderr and raw CSV from this exact run. Exit `0` and workflow success are necessary provenance, not sufficient behavioral evidence.
2. Reconcile frozen Gates A-G unchanged. Decisive acceptance requires the negative case to show `echoed=true` together with matching semantic ERROR and independent operator-error evidence before any later serial.
3. Record authoritative T03-020 job runtime in `LAB_COMPUTE_LOG.md` when exact job timestamps are available; do not substitute lesson time or an invented estimate.
4. If observability/timing fails, classify **HARNESS_INVALID** and improve observability without weakening the acknowledgement-versus-success boundary. If the echoed invalid command reports DONE/no rejection under the pinned fixture, classify **SUBSTANTIVE MISMATCH** and investigate source/runtime assumptions before rerun.
5. After accepted behavioral verification, finish the minimum 1000-level T03 work: adversarial exam, corrections if needed, fresh-AI handoff and graduation/counterfactual promotion audit.
6. **Immediately after defensible T03 graduation, perform the first blind development-bank baseline evaluation before entering the next major module cluster.** Do not let the studying learner inspect the hidden answer or later case resolution before committing its response.
7. Promote rather than silently generalize deeper libnml queue saturation/drop behavior, reconnect/TCP-loss behavior, multi-client remote ordering and version drift unless new evidence shows one is required to validate the core T03 teaching.
8. If the current thread is waiting/blocked and the lesson is still materially under the 15-minute target, continue another unblocked source/evaluation/reconciliation task rather than ending solely because one task is complete or waiting.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.

## Prior promotion queue retained

S04-S07 promotion items remain active in their graduated handoff artifacts, including device-specific stale-feedback semantics, transport/LLIO fault behavior, absolute-encoder restart provenance, and abnormal-process/HAL-lifetime corner cases.
