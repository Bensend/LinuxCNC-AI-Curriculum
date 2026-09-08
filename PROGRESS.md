# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T03 — NML architecture and messages** are **GRADUATED at 1000 level**. **T04 — GUI integration boundaries** is now the highest-priority unblocked module and is active in **RESEARCH** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

Repository artifacts, not chat history, remain authoritative.

## T03 graduation evidence

T03-020 workflow `34182846956`, authoritative job `101925247534`, final lab exit `0`, passed frozen Gates A-G without gate weakening.

The decisive negative case was independently confirmed in ESTOP before `AUTO_STEP` was sent. The saved command advanced from serial 2 to serial 3, status echoed serial 3, matching aggregate status was `RCS_ERROR`, `wait_complete()` returned `RCS_ERROR`, and the independent error channel reported that `EMC_TASK_PLAN_STEP` could not execute until the machine was out of E-stop and turned on. No recovery serial was issued until this negative evidence had been preserved.

Durable accepted result: `experiments/T03-020-accepted-result.md`.

### T03 teaching retained

Ordinary userspace command/order acknowledgement, controller semantic result, operator-error reporting, physical-machine truth and safety truth are separate evidence domains.

Pinned `emctaskmain.cc` publishes the current command serial into Task/top-level `echo_serial_number` before independently deriving aggregate DONE/EXEC/ERROR status. Pinned `emcmodule.cc` similarly separates command send/serial-echo handling from `wait_complete()` result handling. Therefore **an echoed serial is not proof of command success**.

The pinned stock NML configuration also gives distinct roles to `emcCommand`, `emcStatus` and `emcError`; status must not be treated as a replayable per-command journal and an empty error poll is not a success oracle.

Current official Python-interface documentation describes `echo_serial_number` as the serial of the last "completed" command. T03's source plus accepted negative experiment constrain that wording: completed/echoed must not be interpreted as succeeded, because an echoed command can complete with `RCS_ERROR`.

T03 adversarial exam passed 10/10: `exams/T03-adversarial-exam.md`.

Fresh-AI transfer/counterfactual audit: `guides/T03-fresh-ai-handoff.md`.

**Decision: T03 GRADUATED at 1000 level.**

### T03 promotion queue

- remote NML/TCP disconnect, reconnect and stale-status behavior — 2000 HIGH;
- command/error queue saturation, overwrite/drop and `confirm_write` corner cases — 2000 HIGH;
- multiple independent command producers and serial-result ownership races — 2000 HIGH;
- multiple error-channel consumers and consumption timing — 2000 MEDIUM;
- version drift beyond pinned SHA — 2000 MEDIUM.

These items cannot reverse the bounded pinned conclusion that acknowledgement and semantic success are distinct; they refine transport/concurrency behavior.

## T04 activation — GUI integration boundaries

T04 is now RESEARCH. Its 1000-level task is to identify what a LinuxCNC GUI may legitimately infer from public controller interfaces and where GUI presentation/control state diverges from Task, motion, HAL, physical-device and safety truth.

Do not assume AXIS, QtVCP, Gmoccapy or another GUI owns machine truth merely because it displays it. Trace representative GUI actions down to their public command/status/HAL interfaces and trace displayed state back to its actual source.

### Exact next-work checkpoint

1. Establish the current official GUI/UI-programming documentation baseline and community failure modes for stale GUI state, multiple command producers and custom GUI integrations.
2. Inventory the pinned AXIS/Python integration entry points and one QtVCP or equivalent modern GUI path without attempting to document every widget.
3. Trace one representative operator action from GUI callback -> `linuxcnc.command()`/HAL/NML -> Task and one representative displayed status value from controller status -> GUI refresh/render path.
4. Build an explicit GUI-state ownership matrix distinguishing local widget state, controller status snapshot, HAL values, physical feedback and safety state.
5. Identify one behaviorally meaningful failure path (for example stale/unpolled status, command rejected after a GUI enables a control, or competing command producer) and freeze the first T04 experiment before implementation.
6. Preserve T03's serial/result distinction as an inherited prerequisite; do not retest it merely under a GUI skin unless the GUI introduces a new failure mechanism.

## Blind-feedback process checkpoint

The development-bank blind baseline required by `evaluation/BLIND_FEEDBACK_PROTOCOL.md` remains due after T03 graduation and before entering a later major module cluster. A genuinely blind evaluation must preserve answer sealing and learner precommitment; do not manufacture a "blind" score in the same context after exposing the answer. T04 remains in the same Phase-9 module cluster, so its source/research work can proceed without falsifying that control.

## Laboratory compute checkpoint

T03-020 repository metadata preserves inner lab timestamps `2026-09-08T03:14:59Z` to `03:18:25Z`, but `LAB_COMPUTE_LOG.md` requires authoritative Actions **job** start/end timestamps rather than script envelope time. Exact job timestamps were not exposed by the available job-list response, so the ledger remains deliberately unbackfilled rather than substituting the 206-second script interval.

## Study-process rules retained

- Short-session continuation: completing a single subtask is not by itself a reason to end a materially short lesson; continue useful unblocked work when available.
- Lab compute accounting: record every material authoritative Actions job from exact job timestamps; never invent compute time.
- Evidence discipline: process/UI/controller/physical/safety state remain separate unless a traced interface and appropriate independent evidence justify linking them.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.

## Prior promotion queue retained

S04-S07 and T01-T02 promotion items remain active in their graduated handoff artifacts, including device-specific stale-feedback semantics, transport/LLIO fault behavior, absolute-encoder restart provenance, abnormal-process/HAL-lifetime corner cases, dynamic queue-buster timing, nested MDI behavior and Task abort/pause races.