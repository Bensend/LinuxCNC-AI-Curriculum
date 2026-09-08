# T04 source note — QtVCP widget state ownership

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Why this matters

A GUI button's enabled/checked state can look like an authoritative statement that an action is currently legal. Pinned QtVCP source shows that it is actually local widget state driven by previously emitted status events plus widget policy.

## Representative pinned path

`lib/python/qtvcp/widgets/action_button.py` constructs global `STATUS = Status()` and `ACTION = Action()` references. `_hal_init()` connects widget behavior to `STATUS` signals.

Examples include:

- ESTOP button check state follows `state-estop` / `state-estop-reset` signals;
- machine-on/abort buttons enable or disable on ESTOP/reset and update check state on state-on/off;
- home/unhome and jog controls enable/disable on state/interpreter signals;
- run-related buttons derive enabled state from combinations of machine-on, homed, file-loaded, interpreter-running/idle/paused signals;
- pause/step controls are similarly driven by interpreter and machine-state events.

The source comment is unusually explicit: `STATUS` is used to synchronize buttons because other entities may change LinuxCNC state, and some buttons are enabled/disabled according to LinuxCNC state and possible actions.

## Ownership conclusion

The immediate owner of `button.isEnabled()` / checked state is the Qt widget. Controller status influences it through a userspace signal chain:

```text
Task/status
 -> linuxcnc.stat poll
 -> GStat cache/diff
 -> STATUS signal
 -> widget callback
 -> setEnabled()/setChecked()
```

If the status poll fails, T04's pinned `GStat.update()` branch does not merge new state or emit the corresponding state transition. A status-driven widget can therefore retain its previous enabled/checked value while controller state has changed.

That does **not** mean QtVCP is defective; retained state is a consequence of event-driven presentation unless the screen adds a freshness policy. `GStat.is_status_valid()` provides an explicit observation-health oracle that a custom screen can use to gray/blank/warn/fail-safe if stale presentation is unacceptable.

## Inherited command boundary

Even when a button is correctly enabled from fresh status, that is still a local policy decision. Between the enabling poll and command execution, controller state may change or another producer may act. Task remains the semantic authority that accepts/rejects the command.

Therefore:

```text
button enabled
!= command accepted
!= controller action completed
!= physical action proved
!= safe state proved
```

## T04 experimental implication

T04-021 tests the first inequality dynamically: a retained GUI presentation/cache can diverge from an independently observed controller state when the GUI observation path fails.

A possible second 1000-level experiment, only if needed after T04-021, would attach an actual `ActionButton` or equivalent lightweight status-driven listener and prove that its enabled/checked state remains stale across a forced poll failure. Do not run that merely to duplicate T04-021 if the adapter-level signal/presentation listener already establishes the mechanism with sufficient transfer evidence.
