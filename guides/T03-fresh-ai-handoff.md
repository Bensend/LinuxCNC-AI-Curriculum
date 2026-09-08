# T03 fresh-AI handoff — NML architecture and messages

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Core model

LinuxCNC's ordinary userspace control interface exposes multiple evidence surfaces that must not be collapsed:

1. **Command channel** — carries UI/client commands into Task, with serial/order semantics.
2. **Status channel** — exposes the current controller status snapshot, including the echoed command serial and aggregate DONE/EXEC/ERROR result.
3. **Error channel** — separately queued operator/error reporting; consumption and timing are independent of the status snapshot.
4. **Physical-machine truth** — actual actuator, feedback and energy state are outside mere NML acknowledgement.
5. **Safety truth** — functional-safety claims require the machine's validated safety architecture, not an NML success code.

The durable rule is: **a command serial being echoed proves acknowledgement/order progress, not successful execution. Preserve matching semantic DONE/ERROR evidence, and obtain physical/safety evidence from the appropriate independent domain.**

## Representative pinned flow

```text
Python/UI command
  -> linuxcnc.command()
  -> RCS_CMD_CHANNEL / emcCommand
  -> Task receives/plans/dispatches command
  -> Task publishes command serial as echo_serial_number
  -> Task independently derives aggregate RCS_STATUS
  -> RCS_STAT_CHANNEL / emcStatus
  -> stat.poll() / wait_complete()

Task/operator diagnostics
  -> emcError queued channel
  -> linuxcnc.error_channel().poll()
```

Pinned `emctaskmain.cc` assigns the current command serial to the Task/top-level echo fields before aggregate status is classified from planning/execution/subordinate errors. Therefore a planning failure can be echoed and still produce `RCS_ERROR`.

Pinned `emcmodule.cc` likewise separates `emcSendCommand()`'s serial/echo boundary from `wait_complete()`'s DONE/ERROR result logic.

## Independent verification — T03-020

Workflow `34182846956`, authoritative job `101925247534`, lab exit `0`, passed frozen Gates A-G.

The decisive negative case was independently placed in ESTOP and then sent `AUTO_STEP`:

- previous serial: `2`;
- new command serial: `3`;
- echoed serial after send: `3`;
- matching aggregate status: `3 == RCS_ERROR`;
- `wait_complete()`: `3 == RCS_ERROR`;
- error channel: `EMC_TASK_PLAN_STEP` could not execute until the machine was out of E-stop and turned on;
- recovery was withheld until the negative evidence was preserved at serial 3.

This is a direct runtime witness that **echoed = true** can coexist with **semantic_success = false**.

## Buffer-role boundary

The pinned stock `configs/common/linuxcnc.nml` gives different roles to the ordinary channels:

- `emcCommand`: queued, confirm-write, serial command traffic;
- `emcStatus`: status surface, not configured as a queue;
- `emcError`: separately queued reporting.

Do not therefore treat status as a replayable per-command journal or an empty error poll as a success acknowledgement.

Current LinuxCNC Python-interface documentation also warns that the error queue is consumed by the first reader; multiple error readers can race. That is a useful integration warning, but it remains separate from semantic command status.

## Novel scenario test

Scenario: an HMI sends AUTO STEP and lights a green SUCCESS indicator when `echo_serial_number >= sent_serial`. The machine is in ESTOP. The indicator lights even though LinuxCNC rejects the command.

**Expected reasoning:** this is an evidence/correlation defect in the HMI. The echoed serial only proves the Task/status command boundary advanced. The HMI must preserve the sent serial and require the matching semantic result to be DONE; matching ERROR must be presented as failure, with error-channel text as additional diagnostic context. If multiple command producers exist, the integration must also prevent later serial traffic from masking the earlier matching result. None of these software observations alone prove physical actuation or functional safety.

A fresh AI passes T03 when it diagnoses the false SUCCESS lamp as acknowledgement-versus-result confusion rather than a LinuxCNC ESTOP failure.

## Promotion queue / counterfactual audit

- Remote NML/TCP disconnect, reconnect and stale-status behavior — **2000, HIGH**. T03-020 is local and cannot establish reconnect semantics.
- Command/error queue saturation, overwrite/drop and `confirm_write` corner cases — **2000, HIGH**. Requires deeper libnml source and stress experiments.
- Multiple independent command producers and serial-result ownership races — **2000, HIGH**. The 1000-level model identifies the hazard but does not claim a universal arbitration design.
- Multiple error-channel consumers and message-loss-by-consumption timing — **2000, MEDIUM**. Current docs warn of first-reader consumption; robust multi-reader architecture needs dedicated study.
- Version drift beyond pinned SHA — **2000, MEDIUM**. Reverify implementation-specific serial/result behavior before transferring it to another revision.
- NML result versus physical feedback/safety proof — **outside T03's software transport claim**, carried forward as a standing machine-integration boundary rather than an implied NML guarantee.

Counterfactual test: even if later remote/reconnect, saturation, multi-client or newer-version behavior differs, none can reverse the accepted pinned result that command echo and semantic success are distinct or the engineering requirement to use the appropriate evidence domain. No critical uncertainty is hidden in a promotion item that could invalidate bounded 1000-level T03 graduation.

## 1000-level graduation audit

- Documentation baseline: PASS — official Python interface documents separate command/status/error interfaces and recommends checking status before sending state-inappropriate commands.
- Community/integration evidence: PASS — field material was used as hypothesis/risk evidence rather than authority over the pinned implementation.
- Pinned source analysis: PASS — `guides/T03-command-acknowledgement-boundary.md`, `guides/T03-buffer-transport-boundary.md` and `call-flows/T03-python-command-status-error-nml.md` trace the representative path and buffer roles.
- Function/call-flow documentation: PASS — command send/serial save, Task echo publication, independent aggregate status derivation, status polling/wait and error polling are documented.
- Independent laboratory verification: PASS — T03-020 workflow `34182846956`, job `101925247534`, exit `0`, frozen Gates A-G all PASS.
- Predeclared prediction checked: PASS — invalid ESTOP AUTO STEP was predicted to be echoed while semantically ERROR before harness implementation; result matched without gate weakening.
- Adversarial exam: PASS — `exams/T03-adversarial-exam.md`, 10/10.
- Fresh-AI competency transfer: PASS — novel false-SUCCESS-lamp scenario requires application of the evidence model, not recall of the lab serial values.
- Corrections: PASS — terminology corrected so echoed/"completed" is not treated as synonymous with succeeded; evidence scope explicitly narrowed.
- Promotion justification/counterfactual test: PASS.

**Decision: T03 GRADUATED at 1000 level.**

## Next dependency checkpoint

T04 — GUI integration boundaries is the next curriculum module in Phase 9. Before broadening into a later major module cluster, preserve the development-bank blind-feedback baseline required by `evaluation/BLIND_FEEDBACK_PROTOCOL.md`; do not contaminate a sealed challenge by exposing its answer to the learner before response precommitment.