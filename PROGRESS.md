# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T04 — GUI integration boundaries** are **GRADUATED at 1000 level**. **T05 — custom operator interface patterns** is the highest-priority unblocked module and is active in **RESEARCH** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

Repository artifacts, not chat history, remain authoritative.

## T03 retained boundary

T03-020 workflow `34182846956`, job `101925247534`, passed frozen Gates A-G. An ESTOP-invalid `AUTO_STEP` was assigned/echoed serial 3 while matching aggregate status and `wait_complete()` were `RCS_ERROR`, with independent operator-error evidence preserved before any later serial.

Retained rule: **command acknowledgement/order, semantic result, diagnostics, physical truth and safety truth are distinct evidence domains.**

## T04 graduated evidence

Durable artifacts:

- `guides/T04-gui-integration-research.md`
- `call-flows/T04-axis-and-qtvcp-gui-boundaries.md`
- `guides/T04-gui-freshness-oracle-note.md`
- `guides/T04-widget-state-ownership.md`
- frozen `experiments/T04-021-gui-status-freshness-plan.md`
- `lab-jobs/021-t04-gui-status-freshness.sh`
- accepted `experiments/T04-021-accepted-result.md`
- `exams/T04-adversarial-exam.md` — 10/10 PASS
- `guides/T04-fresh-ai-handoff.md`

T04-021 workflow **`34186879941`**, authoritative job **`101936899842`**, artifact **`10040862703`**, exit `0`, passed frozen Gates A-H.

The decisive runtime tuple was:

```text
independent controller state = STATE_ESTOP_RESET
GStat _status_active          = False
GStat cached state            = prior STATE_ESTOP
presentation state            = prior STATE_ESTOP
failed-cycle GUI event        = periodic only
```

Removing only the injected GUI poll failure made the next update set `_status_active=True`, update cache/presentation to `STATE_ESTOP_RESET`, and emit `state-estop-reset`.

Pinned QtVCP source predicts the behavior: `GStat.update()` sets status invalid and skips `merge()`/state signals when `stat.poll()` fails while keeping periodic scheduling alive. `GStat.is_status_valid()` exposes observation health. QtVCP `ActionButton` state is local widget state driven by previously emitted status signals. Pinned AXIS independently exhibits the same architecture class: periodic userspace status polling projects controller state into local Tk/redraw/presentation state.

Retained T04 rule: **a rendered GUI value is a presentation claim. Identify its source and freshness before treating it as current controller state; controller/HAL/physical/safety evidence remain separate.** A responsive GUI or enabled button is not a freshness, command-success, physical-action, or safety oracle.

T04 promotion queue includes full-screen/display-server failure behavior (2000 MEDIUM), GUI TOCTOU with competing command producers (2000 HIGH), multiple error consumers (2000 HIGH), remote GUI/NML reconnect (2000 HIGH), other-GUI implementation comparison (2000 MEDIUM), specialized safety-HMI design, and version drift (2000 MEDIUM).

**Decision: T04 GRADUATED at 1000 level.**

## T05 activation — custom operator interface patterns

Initial research artifact: `guides/T05-custom-operator-interface-research.md`.

Current official documentation confirms several supported custom-OI mechanisms: QtVCP `.ui` + Python handler/custom widgets/actions, HALUI translating HAL pins to NML commands, and direct Python command/status/error interfaces. T05 will identify reusable architecture patterns rather than catalogue every toolkit.

Initial pattern set:

1. one clear command owner/gateway where practical;
2. explicit status freshness contract;
3. advisory widget gating with controller/interlock enforcement below it;
4. semantic command result separated from diagnostic-channel presentation;
5. HAL used with traced pin/source ownership rather than as a presentation shortcut;
6. fail-defined startup, controller-not-ready, observation-invalid, reconnect and shutdown behavior.

## Exact next-work checkpoint

1. Trace pinned `src/emc/usr_intf/halui.cc` from representative HAL input pin -> NML command and controller status -> HAL output pin.
2. Trace QtVCP handler lifecycle/startup ordering relative to first valid `Status` observation and widget initialization.
3. Inspect one minimal direct-Python UI example for explicit command/status/error ownership.
4. Build a custom-OI responsibility matrix:

```text
operator intent | local UI owner | command transport | semantic result oracle |
status source | freshness rule | HAL/physical source | diagnostic owner | safe-state owner
```

5. Research community startup/reconnect/multi-producer custom-UI failures as hypothesis evidence.
6. Freeze T05's first experiment only after these source paths identify the highest-value fault case; current leading candidate is startup/freshness gating before first valid controller snapshot.

## Blind-feedback checkpoint

The development-bank blind baseline required after T03 remains due before leaving the current Phase-9 module cluster for a later major cluster. Preserve genuine evaluator/learner information separation; do not manufacture a contaminated score.

## Laboratory compute checkpoint

T03-020 and T04-021 repository metadata contain inner script timestamps, but `LAB_COMPUTE_LOG.md` requires authoritative Actions job start/end timestamps. The available job-list connector response did not expose those fields, so no invented compute values were recorded.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.