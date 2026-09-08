# T04-021 — GUI status freshness versus retained presentation

Status: **FROZEN BEFORE IMPLEMENTATION**  
Module: T04 — GUI integration boundaries  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question

Can a LinuxCNC GUI status adapter retain and continue exposing its last successfully polled controller state when the GUI's status poll fails, while an independent observer proves the underlying controller state has changed?

## Why this is T04-specific

T03 already proved that command acknowledgement and semantic result differ. T04-021 does not retest that result through a GUI wrapper. It tests a new boundary in `common.hal_glib.GStat`: periodic userspace polling, local cached presentation state, signal emission and freshness after poll failure.

Pinned source shows `GStat.update()` catches a failed `self.stat.poll()`, sets `_status_active=False`, emits only `periodic`, returns/reschedules, and does **not** call `merge()` or emit state-change signals for that cycle. The adapter therefore retains its prior `old[...]` cache until a later successful poll.

## Fixture

Use a pinned LinuxCNC simulation fixture with no physical hardware claim.

Inside one test process create:

1. **authoritative independent observer** — a plain `linuxcnc.stat()` object polled directly;
2. **command producer** — a plain `linuxcnc.command()` used only to cause a controlled Task-state transition;
3. **GUI adapter** — pinned `common.hal_glib.GStat` constructed with a proxy around its own independent `linuxcnc.stat()` object;
4. **presentation listener** — records the last GUI-facing state event/value and monotonic timestamp. It represents a widget that changes only when its status adapter emits a relevant state signal.

The proxy delegates all attributes and successful polls to the real status object, but has one test-only switch that deliberately raises on `poll()`. This injects a GUI-observation failure without changing LinuxCNC itself.

Do not use screenshots as an oracle.

## Predeclared sequence

### Phase A — provenance and baseline

1. Prove pinned source/runtime provenance.
2. Start LinuxCNC in a deterministic simulation state.
3. Establish `STATE_ESTOP` as the baseline using command completion plus the independent observer.
4. Successfully update the GUI adapter and record that its cached/presented state agrees with the independent observer.

### Phase B — break only GUI observation

5. Enable the proxy's deliberate poll failure.
6. Through the separate command producer request `STATE_ESTOP_RESET`; require semantic command completion and independently poll until the authoritative observer sees `STATE_ESTOP_RESET`.
7. Invoke the GUI adapter's update while its proxy poll is failing.
8. Record adapter `_status_active`, cached state, presentation-listener state/events and independent observer state at the same phase.

### Phase C — recovery

9. Disable proxy failure without otherwise changing controller state.
10. Invoke GUI adapter update again.
11. Require a successful refresh that brings adapter/presentation state to the independently observed controller state.

## Frozen prediction

During Phase B, after the controller has independently reached `STATE_ESTOP_RESET` but the GUI adapter's poll is forced to fail:

- independent observer = `STATE_ESTOP_RESET`;
- GUI adapter `_status_active = False`;
- GUI adapter cached/presented state remains the prior `STATE_ESTOP` value;
- no GUI state-reset/on/off transition generated from the failed poll cycle can be used to claim the new controller state.

After Phase C's successful poll, the GUI adapter cache/presentation catches up to `STATE_ESTOP_RESET` and `_status_active=True`.

## Frozen gates

### Gate A — pinned provenance

PASS only if the job proves curriculum commit, LinuxCNC pinned SHA and imported `common.hal_glib` path from that pinned runtime/build environment.

### Gate B — baseline agreement

PASS only if independent observer and GUI adapter/presentation agree on `STATE_ESTOP` after at least one successful GUI-adapter update.

### Gate C — controller transition independently proven

PASS only if the separate command producer's ESTOP-reset request obtains semantic success and the independent observer subsequently reports `STATE_ESTOP_RESET` before the decisive failed GUI update is graded.

Echo/serial progress alone is insufficient.

### Gate D — injected failure is GUI-observation-only

PASS only if the proxy records that its `poll()` deliberately raised during the decisive adapter update while the independent observer remains functional. Failure of the whole LinuxCNC runtime is HARNESS_INVALID.

### Gate E — stale presentation directly observed

PASS only if, in the same decisive phase:

```text
independent controller state == STATE_ESTOP_RESET
GUI adapter _status_active == False
GUI cached/presented state == prior STATE_ESTOP
```

The test must record all three rather than infer GUI staleness from source alone.

### Gate F — no false state-transition signal

PASS only if the presentation listener receives no `state-estop-reset`/`state-on`/`state-off` event attributable to the failed-poll update that would legitimately update it to the new controller state. Generic `periodic` activity does not count as fresh state evidence.

### Gate G — recovery

PASS only if removing only the injected poll failure allows a later adapter update to set `_status_active=True` and update cached/presented state to `STATE_ESTOP_RESET`, still agreeing with the independent observer.

### Gate H — bounded interpretation

PASS only if the result is reported as a GUI/status-adapter freshness result. It must not be generalized into NML packet-loss behavior, remote-network behavior, physical E-stop behavior or safety-rated state validation.

## Required raw evidence

Preserve a machine-readable trace with at least:

- monotonic timestamp;
- phase;
- command saved serial and matching semantic result where applicable;
- independent observer Task state;
- proxy blocked/unblocked flag and poll-attempt/result;
- GUI adapter `_status_active`;
- GUI adapter cached state;
- presentation listener state;
- GUI-emitted event name(s).

Also preserve stdout, stderr, job/result metadata and final exit code.

## Classification rules

- Any change to Gates A-H after implementation begins requires a new experiment ID unless it is purely editorial.
- If `GStat` cannot be instantiated headlessly because unrelated GUI/ZMQ/GLib initialization blocks the test, classify **HARNESS_INVALID** and isolate the same pinned `GStat.update()` code path without weakening Gates D-G.
- If the failed poll unexpectedly updates the cached/presentation state to the new controller state, classify **SUBSTANTIVE MISMATCH** and inspect hidden refresh paths before another run.
- Do not substitute a fake-only controller for the independent live LinuxCNC observer unless this experiment is explicitly reclassified as a source-level unit test under a new ID.

## Expected contribution

A passing result would establish a practical GUI rule: **a displayed controller-derived value is only as fresh as its last successful observation path. Continued GUI periodic activity is not proof that the displayed machine/controller state is current.**