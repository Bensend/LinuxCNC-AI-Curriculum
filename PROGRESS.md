# Curriculum Progress

Status values: `PLANNED`, `RESEARCH`, `SOURCE`, `EXPERIMENT`, `EXAM`, `CORRECTIONS`, `GRADUATED`.

## Current critical-path state

All modules through **T03 — NML architecture and messages** are **GRADUATED at 1000 level**. **T04 — GUI integration boundaries** is the highest-priority unblocked module and is active in **EXPERIMENT** at pinned LinuxCNC revision `8bf4605ae81042248add031e94c77300406e0413`.

Repository artifacts, not chat history, remain authoritative.

## T03 graduation evidence retained

T03-020 workflow `34182846956`, authoritative job `101925247534`, exit `0`, passed frozen Gates A-G. In the decisive negative case, ESTOP was independently established before `AUTO_STEP`: serial 3 was echoed as 3 while matching aggregate status and `wait_complete()` were `RCS_ERROR`; the independent error channel reported the machine-state prerequisite failure before any later serial was issued.

Durable artifacts:

- `experiments/T03-020-accepted-result.md`
- `exams/T03-adversarial-exam.md` — 10/10 PASS
- `guides/T03-fresh-ai-handoff.md`

T03's retained rule is: **command acknowledgement/order, controller semantic result, operator diagnostics, physical-machine truth and safety truth are separate evidence domains.** Echoed/completed must not be interpreted as succeeded.

T03 promotion queue remains remote reconnect/stale-status behavior (2000 HIGH), queue saturation/drop and confirm-write corner cases (2000 HIGH), multiple command producers/serial ownership races (2000 HIGH), multiple error consumers (2000 MEDIUM), and version drift (2000 MEDIUM).

## T04 durable evidence

Current artifacts:

- `guides/T04-gui-integration-research.md`
- `call-flows/T04-axis-and-qtvcp-gui-boundaries.md`
- frozen plan `experiments/T04-021-gui-status-freshness-plan.md`
- implementation `lab-jobs/021-t04-gui-status-freshness.sh`

### Source-grounded GUI model

Current official AXIS documentation identifies AXIS as a graphical front-end with a configurable userspace `CYCLE_TIME`. Current QtVCP documentation identifies its `Status` layer as an event/signal wrapper around LinuxCNC state. The public Python interface remains the lower UI boundary: commands go through NML to Task, status is polled, and errors are consumed separately.

Pinned QtVCP source establishes:

```text
GLib timer -> GStat.update() -> stat.poll() -> merge cache -> diff -> GUI-facing signals
```

If `stat.poll()` raises, `GStat.update()` sets `_status_active=False`, emits only generic `periodic`, skips `merge()`/state-change signals and reschedules. Cached presentation state can therefore survive a failed observation cycle.

Pinned QtVCP `qt_action.py` constructs `linuxcnc.command()` and wraps controller requests with local GUI policy/guards. Those guards are userspace decisions based on observed status; they are not guarantees that Task will later accept the command.

Pinned AXIS source independently shows the same architectural boundary with a different framework. `LivePlotter.update()` periodically polls its own `linuxcnc.stat()`, projects the snapshot into Tk variables/redraw caches, and returns on poll error. Helpers such as `manual_ok()`, `ensure_mode()` and `set_motion_teleop()` poll status, apply local policy, issue `linuxcnc.command()` requests and optionally wait/poll again. AXIS also owns substantial local preview, notification, preference and redraw state.

The cross-GUI rule is therefore: **rendered GUI state is a periodically refreshed projection plus local policy, not an independent source of controller, physical or safety truth.**

### T04-021 frozen experiment

T04-021 was frozen before implementation with Gates A-H. It uses a live pinned LinuxCNC simulation plus:

1. an independent plain `linuxcnc.stat()` observer;
2. a separate command producer;
3. pinned `common.hal_glib.GStat` around its own status object via a test-only proxy that can deliberately fail only the GUI adapter's `poll()`;
4. a presentation listener that updates only from GUI state signals.

Frozen prediction: after baseline agreement in `STATE_ESTOP`, block only the GUI adapter poll, independently transition the controller to `STATE_ESTOP_RESET`, then invoke the failed GUI update. At that decisive point require:

```text
independent controller state == STATE_ESTOP_RESET
GStat _status_active == False
GStat cached/presented state == prior STATE_ESTOP
no state-reset/on/off signal from failed update
```

After removing only the injected observation failure, the next successful GUI update must catch the cache/presentation up to `STATE_ESTOP_RESET` and mark `_status_active=True`.

Implementation commit `8b7ad745f9bf286981620b42ea3f9166711e68ed` automatically launched LinuxCNC Lab Runner workflow **`34186879941`**. At this checkpoint it was queued/running; do not launch a duplicate.

## Exact next-work checkpoint

1. Inspect workflow **`34186879941`** and its authoritative job when complete. Preserve stdout/stderr/raw trace and exact result provenance.
2. Reconcile frozen T04-021 Gates A-H unchanged. Workflow success alone is not behavioral evidence.
3. If GStat cannot be instantiated headlessly because unrelated GI/ZMQ/HAL setup blocks the test, classify **HARNESS_INVALID** and isolate the same pinned `GStat.update()` branch without weakening independent-controller versus retained-presentation Gates D-G.
4. If the failed poll unexpectedly updates GUI cached/presented state to the new controller state, classify **SUBSTANTIVE MISMATCH** and inspect hidden refresh paths before any rerun.
5. If accepted, document the runtime freshness rule, perform a T04 adversarial transfer test, and decide whether a second GUI command-rejection/stale-guard experiment is necessary for 1000-level graduation.
6. Do not duplicate T03 by treating serial/result semantics as the T04 experiment result; the new claim is GUI observation freshness.
7. Keep error-consumer races, remote GUI/NML transport and broad widget taxonomy promoted unless required to validate the bounded T04 model.

## Blind-feedback process checkpoint

The development-bank blind baseline required by `evaluation/BLIND_FEEDBACK_PROTOCOL.md` remains due after T03 graduation and before entering a later major module cluster. Do not manufacture a "blind" score in the same context after exposing the answer. T04 remains within the same Phase-9 module cluster, so source/experiment progress may continue without falsifying the blind-control requirement.

## Laboratory compute checkpoint

T03-020 repository metadata preserves inner script timestamps `2026-09-08T03:14:59Z` to `03:18:25Z`, but the ledger requires authoritative Actions **job** start/end timestamps. The available job-list response did not expose those exact fields, so `LAB_COMPUTE_LOG.md` remains deliberately unbackfilled rather than substituting script envelope time. Apply the same rule to T04-021.

## Study-process rules retained

- Completing one short subtask is not a reason to end a materially short lesson when useful unblocked work remains.
- Record material lab compute only from authoritative job timestamps; never invent it.
- UI/controller/HAL/physical/safety state remain distinct unless a traced interface and appropriate independent evidence justify linking them.

## Session-recovery / overlap note retained

A prior marker beginning `2026-09-08T02:11:10.538872Z` was left OPEN despite durable activity through `02:35:41Z`; later sessions explicitly recorded that uncertainty rather than fabricating an end time. Canonical timing rows live in `LESSON_LOG.md`.