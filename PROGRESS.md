# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T02 — task layer** are **GRADUATED at 1000 level**. **T03 — NML architecture and messages** is the highest-priority unblocked module and is active in **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

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

GitHub Actions workflow **`34182846956`** was automatically triggered from that exact implementation commit. At the latest observation in this lesson the run was still **in progress**; therefore no TEST-CONFIRMED claim is made and no duplicate run is launched.

## Exact resume checkpoint

Resume T03-020 from workflow **`34182846956`**; do not start a duplicate while its authoritative result exists or is still running.

1. Inspect that run's final workflow conclusion, job identity, repository-recorded `lab-results/LATEST*`, lab exit code, stdout, stderr and raw CSV.
2. Reconcile frozen Gates A-G unchanged. Decisive acceptance requires the negative case to show `echoed=true` together with matching semantic ERROR and independent operator-error evidence before any later serial.
3. If observability/timing fails, classify **HARNESS_INVALID** and improve observability without weakening the acknowledgement-versus-success boundary. If the echoed invalid command reports DONE/no rejection under the pinned fixture, classify **SUBSTANTIVE MISMATCH** and investigate source/runtime assumptions before rerun.
4. After accepted behavioral verification, finish the minimum 1000-level T03 work: adversarial exam, corrections if needed, fresh-AI handoff and graduation/counterfactual promotion audit.
5. Promote rather than silently generalize deeper libnml queue saturation/drop behavior, reconnect/TCP-loss behavior, multi-client remote ordering and version drift unless new evidence shows one is required to validate the core T03 teaching.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.

## Prior promotion queue retained

S04-S07 promotion items remain active in their graduated handoff artifacts, including device-specific stale-feedback semantics, transport/LLIO fault behavior, absolute-encoder restart provenance, and abnormal-process/HAL-lifetime corner cases.
