# T04 call flow — AXIS and QtVCP GUI boundaries

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Document representative operator-command and controller-status paths in two LinuxCNC GUI implementations without assuming that either GUI is the controller or a physical-state authority.

## AXIS status refresh path

Pinned `src/emc/usr_intf/axis/scripts/axis.py` defines `LivePlotter.start()` with its own `linuxcnc.stat()` object and a separate `positionlogger(linuxcnc.stat(), ...)`. `LivePlotter.update()` performs:

```text
Tk timer (`after(update_ms, self.update)`)
  -> self.stat.poll()
  -> inspect controller snapshot
  -> update local Tk variables / redraw conditions
       exec_state
       interp_state
       task_mode / task_state
       motion_mode
       actual_position / joint_actual_position
       homed / limits
       spindle / overrides
       active G/M/F/S codes
  -> request redraw / update idle tasks
  -> schedule next userspace refresh
```

If `self.stat.poll()` raises `linuxcnc.error`, AXIS prints the error, deletes that `stat` object and returns from the update. No successful poll means no new controller snapshot for that update path.

AXIS also has explicit local presentation state and caches: Tk variables, preferences, current/highlighted line, `last_position`, `last_homed`, `last_*` redraw caches, notification widgets, preview/backplot data and temporary "blackout" windows used to avoid slider/status feedback immediately overwriting locally initiated override changes.

Therefore `AXIS display value` and `current LinuxCNC controller value` are not synonymous claims. The display is a periodically refreshed projection plus local presentation policy.

## AXIS action/guard path

Representative helpers show the opposite direction:

```text
operator/UI event
  -> AXIS local guard/helper
       running()/manual_ok()/ensure_mode()/set_motion_teleop()
  -> s.poll() where helper chooses to refresh first
  -> c.<command>()
  -> optional c.wait_complete()
  -> optional s.poll()
  -> NML command/status path inherited from T03
```

Examples:

- `set_motion_teleop(value)` checks `running()`, updates local `vars.teleop_mode`, calls `c.teleop_enable(value)`, waits complete, then polls status.
- `manual_ok()` polls by default, then permits user action only when Task is ON and interpreter state/MDI queue conditions meet its local policy.
- `ensure_mode()` polls, sends `c.mode(m)` if needed, waits complete and polls again.

These are useful UI guards, but they remain userspace observations and policy. A guard result is not a guarantee that a later command will be accepted if authoritative controller state changes after the poll.

## QtVCP status path

Pinned `lib/python/qtvcp/core.py` subclasses `common.hal_glib.GStat` as a singleton `Status` object. `GStat` constructs a `linuxcnc.stat()` and `linuxcnc.command()`, keeps an `old` cache, and schedules periodic `update()` calls.

```text
GLib timer
  -> GStat.update()
  -> stat.poll()
  -> merge current controller/HAL observations into local cache
  -> compare previous cache with new cache
  -> emit GObject signals
  -> QtVCP widgets / handlers render or react
```

On `stat.poll()` exception:

```text
_status_active = False
emit('periodic')
return True  # keep timer alive
```

`merge()` and state-difference signals are skipped on that failed cycle. Existing cached values remain unless some other local widget logic changes them. This is the source branch frozen for T04-021.

QtVCP's status aggregation is also multi-source: most values derive from `linuxcnc.stat`, while selected values are read directly from HAL. The GUI therefore aggregates different observation domains into one screen.

## QtVCP action path

Pinned `lib/python/qtvcp/qt_action.py` constructs `self.cmd = linuxcnc.command()` and wraps it with higher-level UI actions:

```text
widget/handler
  -> Action method
  -> optional local STATUS guard/mode preparation
  -> self.cmd.<NML command>()
  -> optional wait_complete()/STATUS.stat.poll()/error poll
  -> Task/controller
```

Representative examples:

- `SET_ESTOP_STATE()` -> `self.cmd.state(...)`
- `SET_MACHINE_STATE()` -> `self.cmd.state(...)`
- `SET_MACHINE_HOMING()` -> mode/teleop preparation -> `self.cmd.home(joint)`
- `CALL_MDI()` -> local `STATUS.is_auto_running()` guard -> mode preparation -> `self.cmd.mdi(code)`
- `CALL_MDI_WAIT()` -> MDI -> `wait_complete()` -> separate `STATUS.ERROR.poll()`

The last case directly inherits T03's evidence split: command semantic result and diagnostic error queue are separate surfaces even when a GUI helper packages them into one method.

## Cross-GUI architecture conclusion

AXIS and QtVCP differ substantially in framework and presentation, but the representative pinned flows converge on the same boundary:

```text
local GUI state / event policy
      <-> periodically observed LinuxCNC status and/or HAL
      -> linuxcnc.command() for controller requests
      -> Task / motion / I/O below the GUI
```

Neither GUI's rendered button state, highlighted line, notification, preview or cached status becomes authoritative merely because the user sees it.

## Freshness rule

For any GUI-derived engineering assertion, ask:

1. **What source produced the displayed value?** status, HAL, local cache, preview/interpreter, preference, or computed presentation state?
2. **When was that source last successfully observed?**
3. **What happened on observation failure?** stale retention, blanking, disable, reconnect, or silent retry?
4. **Is the claim about controller state, physical state or safety state?**
5. **Is there independent evidence appropriate to that claim?**

T04-021 freezes a direct experiment for item 2/3 on QtVCP/GStat while retaining AXIS as corroborating architecture evidence rather than claiming identical failure handling in every GUI.

## Evidence boundary

This trace proves source architecture at the pinned SHA. It does not yet prove a runtime stale-screen mismatch; that is the purpose of T04-021. It also does not establish remote NML transport behavior, physical feedback freshness, functional safety or correctness of every custom handler/widget.