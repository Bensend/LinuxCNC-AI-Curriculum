# T04-021 — accepted result

Status: **TEST-CONFIRMED / ACCEPTED**  
Module: T04 — GUI integration boundaries  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`  
Harness/source commit: `8b7ad745f9bf286981620b42ea3f9166711e68ed`  
Workflow run: `34186879941`  
Authoritative job: `101936899842`  
Artifact: `10040862703`  
Lab exit: `0`

## Frozen prediction

T04-021 predicted that a live LinuxCNC controller could transition from `STATE_ESTOP` to `STATE_ESTOP_RESET` while only the GUI adapter's `stat.poll()` path was deliberately failed, leaving the GUI adapter invalid and retaining the old ESTOP cache/presentation. Removing only the injected observation failure was predicted to make the next successful GUI poll catch up to ESTOP_RESET.

Gates A-H were frozen before implementation and were not weakened.

## Authoritative observations

The workflow artifact preserved exit `0`, empty substantive stderr, pinned provenance, and the decisive trace:

```text
baseline-after-successful-gui-update:
  observer_state=1
  gstat_active=1
  gstat_cached_state=1
  presentation_state=1

controller-reset-proven-before-failed-gui-update:
  producer_serial=2
  semantic_result=1 == RCS_DONE
  observer_state=2 == STATE_ESTOP_RESET
  proxy_blocked=1
  gstat_cached_state=1
  presentation_state=1

decisive-failed-gui-update:
  observer_state=2 == STATE_ESTOP_RESET
  proxy_attempts=3
  proxy_failures=1
  gstat_active=0
  gstat_cached_state=1 == prior STATE_ESTOP
  presentation_state=1 == prior STATE_ESTOP

recovered-gui-update:
  observer_state=2
  proxy_blocked=0
  gstat_active=1
  gstat_cached_state=2
  presentation_state=2
```

The independent event trace was:

```text
0.111249,state-estop,1
0.111353,periodic,1
0.151673,periodic,1
0.152189,state-estop-reset,2
0.152224,periodic,2
```

So the failed GUI update emitted generic `periodic` activity but no state-reset/on/off signal. After polling recovered, the `state-estop-reset` event appeared and the presentation caught up.

## Gate reconciliation

### Gate A — PASS

The lab checked out pinned LinuxCNC SHA `8bf4605ae81042248add031e94c77300406e0413` and proved the `linuxcnc` executable, Python module, and `common.hal_glib` module came from the pinned runtime tree.

### Gate B — PASS

After semantically establishing ESTOP, the independent observer, `GStat` cache, presentation listener, and `_status_active` all agreed on fresh `STATE_ESTOP`.

### Gate C — PASS

The separate producer requested ESTOP reset and `wait_complete()` returned `RCS_DONE`. Before the decisive GUI failure was graded, the independent observer reported `STATE_ESTOP_RESET`. Serial progress alone was not the oracle.

### Gate D — PASS

Only the GUI adapter's wrapped status poll was blocked. The proxy recorded exactly one deliberate poll failure on the decisive update while the independent observer continued functioning and still read `STATE_ESTOP_RESET`.

### Gate E — PASS

The decisive tuple directly matched the frozen prediction:

```text
independent state = STATE_ESTOP_RESET
gstat_active      = False
gstat cache       = prior STATE_ESTOP
presentation      = prior STATE_ESTOP
```

This is direct runtime evidence of stale retained presentation relative to the controller snapshot observed independently.

### Gate F — PASS

The failed update emitted `periodic` only. It emitted no controller-state transition capable of legitimately updating the presentation to ESTOP_RESET.

### Gate G — PASS

Removing only the injected observation failure made the next `GStat.update()` succeed, set `_status_active=True`, update cache/presentation to `STATE_ESTOP_RESET`, and emit `state-estop-reset`.

### Gate H — PASS

The result is bounded to the pinned userspace GUI/status-adapter observation path. It is not reported as remote NML loss behavior, physical E-stop validation, device-feedback freshness, or functional-safety evidence.

## Source reconciliation

Pinned `common.hal_glib.GStat.update()` predicts the result exactly:

```text
stat.poll() succeeds -> _status_active=True -> merge -> diff -> state signals
stat.poll() fails    -> _status_active=False -> periodic only -> return/reschedule
```

`GStat.is_status_valid()` exposes `_status_active` as an explicit observation-health indicator.

Pinned QtVCP widgets consume these emitted status signals to update local enabled/checked state. Pinned AXIS uses a different implementation but the same architectural class of boundary: periodic `linuxcnc.stat()` polling projects controller state into local Tk/redraw/presentation state, and a failed poll does not magically create a fresh controller snapshot.

## Correction / durable terminology

Do not call a GUI value simply “the machine state” when freshness matters. More precise terms are:

- **current GUI presentation** — what the widget currently renders;
- **last successfully observed controller state** — the snapshot the GUI last acquired;
- **status-valid/fresh observation path** — whether the GUI adapter's current poll path succeeded;
- **physical-device state** — requires appropriate field feedback/provenance;
- **safety state** — requires the independent validated safety architecture as applicable.

A custom GUI may intentionally continue displaying a last-known value during communication/status failure, but it should not silently represent that retained value as current where that could mislead an operator. QtVCP's `is_status_valid()` or an equivalent explicit freshness policy can be used to gray, blank, annotate, inhibit, or otherwise distinguish stale presentation according to the application's requirements.

## Adversarial implication

A blinking clock, periodic callback, responsive GUI, or enabled button is not proof that controller-derived fields are fresh. T04-021 observed generic periodic GUI activity while the state display was stale relative to an independent controller observer.

Likewise, a fresh enabled button remains a UI policy decision, not proof that Task will accept a later command. T03's matching DONE/ERROR boundary still applies below the GUI.

## Evidence boundary

T04-021 does not establish:

- remote GUI/network/NML reconnect behavior;
- exact failure behavior of every AXIS/QtVCP/Gmoccapy/custom widget;
- multi-reader error-channel semantics beyond documented warnings;
- physical actuator/encoder truth;
- safety-rated HMI behavior.

Those are separate or promoted questions and cannot be inferred from this accepted test.