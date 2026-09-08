# T04 research — GUI integration boundaries

Status: **RESEARCH**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

T04 asks what a LinuxCNC GUI actually owns, what it merely observes, how operator actions cross into controller interfaces, and where a custom GUI can manufacture misleading state by caching, polling, consuming or presenting those interfaces incorrectly.

The core inheritance from T03 is that GUI presentation is not a new source of machine truth. A GUI is another userspace client unless a specific traced interface proves otherwise.

## Official documentation baseline

Current AXIS documentation describes AXIS as a graphical front-end and exposes a configurable `CYCLE_TIME` GUI response interval. It displays controller-derived position/status while also maintaining preview/backplot and local UI state. That alone establishes an important ownership split: rendered UI state is periodically refreshed presentation, not the realtime controller.

Current QtVCP documentation describes QtVCP as infrastructure for custom CNC screens/panels and documents a `Status` library that emits messages based on LinuxCNC's current state. Custom handler code and widgets can therefore add additional local state/logic around controller status.

Current Python-interface documentation preserves the lower boundary: UIs send NML messages to Task, poll the status structure and separately consume the error channel.

## Pinned source — QtVCP status path

`lib/python/qtvcp/core.py` defines QtVCP `Status` as a singleton subclass of `GStat`. It owns a single `linuxcnc.error_channel()` instance and uses a timer-driven `update()` inherited from `common.hal_glib.GStat`. The source explicitly provides `block_error_polling()` because MDI subprogram handling sometimes must be the only error-channel consumer.

Pinned `lib/python/common/hal_glib.py` shows the controller-to-GUI refresh path:

```text
GObject/GLib timer
  -> GStat.update()
  -> self.stat.poll()
  -> merge controller status into old/current presentation cache
  -> compare previous/current values
  -> emit GUI-facing signals such as
       command-running / command-stopped / command-error
       state-estop / state-on / state-off
       homed / unhomed / all-homed
       line-changed / current-position / overrides / spindle state
  -> widgets/handlers react and render
```

If `self.stat.poll()` raises, `_status_active` becomes false, only the generic `periodic` signal is emitted, and the method reschedules itself. Therefore a widget that retains its previous displayed value can outlive a successful controller poll. **A rendered value needs freshness/provenance if freshness matters.**

The same `merge()` combines fields from different sources: many values come from `linuxcnc.stat`, while others are read directly from HAL (`iocontrol.0.tool-prepare`, `spindle.0.speed-in`, `spindle.0.at-speed`, and `spindle.0.speed-out` in the CSS branch). A QtVCP screen is thus a presentation aggregator, not a single-state authority.

## Pinned source — QtVCP command path

`lib/python/qtvcp/qt_action.py` creates a `linuxcnc.command()` object inside `_Lcnc_Action`. Representative actions are thin userspace wrappers:

```text
GUI/widget callback
  -> QtVCP Action method
  -> linuxcnc.command() method
  -> NML command channel
  -> Task
```

Examples in pinned source:

- `SET_ESTOP_STATE()` -> `self.cmd.state(...)`
- `SET_MACHINE_STATE()` -> `self.cmd.state(...)`
- `SET_MACHINE_HOMING()` -> mode/teleop preparation -> `self.cmd.home(joint)`
- `CALL_MDI()` -> local guard `STATUS.is_auto_running()` -> mode change -> `self.cmd.mdi(code)`
- `CALL_MDI_WAIT()` -> `self.cmd.mdi()` -> `wait_complete()` -> separate `STATUS.ERROR.poll()`

This source immediately supplies an adversarial boundary: local GUI guards such as `STATUS.is_auto_running()` are decisions based on the GUI's most recently polled status. They improve UI behavior but do not make the GUI an arbiter of controller validity. Task can still reject a command because controller state changed, another producer acted, or the GUI observation was stale.

## AXIS inventory

Pinned `src/emc/usr_intf/axis/scripts/axis.py` identifies AXIS as a LinuxCNC front-end and imports the same public `linuxcnc` Python interface. It also imports HAL when present and owns substantial local UI/preferences/preview state. T04 should trace one concrete AXIS button/action and one AXIS status-refresh path rather than infer all AXIS behavior from QtVCP.

## Initial state-ownership matrix

| Evidence/display item | Immediate owner/source | Refresh/transport | What it proves | What it does not prove |
|---|---|---|---|---|
| Qt widget enabled/disabled | GUI/widget logic | local event logic | current presentation policy | controller will accept command |
| QtVCP `STATUS.stat.*` | last successful `linuxcnc.stat.poll()` | NML status poll | observed controller snapshot | freshness after poll failure; physical truth |
| QtVCP `command-*` signals | GStat diff of aggregate status | timer poll -> signal | observed status transition | per-widget command ownership unless correlated |
| QtVCP HAL-derived fields | HAL read in merge/update | userspace HAL access | observed HAL value | field device truth/provenance unless traced |
| error popup/message | separately consumed error queue or local `STATUS.emit` | error poll/local signal | a diagnostic was presented | semantic success/failure by itself |
| preview/backplot | GUI/interpreter/presentation logic | local rendering | intended/path-history visualization according to source | physical tool position |
| displayed actual position | controller status source rendered by GUI | periodic poll/render | controller-reported feedback position at observation | guaranteed fresh encoder/device truth or safety |

## Community findings retained as hypothesis/risk evidence

Community QtVCP discussions reinforce several integration failure classes without overriding pinned source:

1. custom panels often instantiate `linuxcnc.stat()`, `linuxcnc.command()` and `linuxcnc.error_channel()` directly, so a customization can create extra consumers/producers;
2. QtVCP customization failures can be lifecycle/configuration problems in handler/widget setup rather than controller faults;
3. users routinely bridge desired machine state into GUI/HAL presentation, which makes source ownership and pin direction important;
4. reported MDI/GUI race fixes are a reminder that GUI sequencing must be verified at the relevant version rather than assumed from appearance.

## Failure hypotheses for the first experiment

Candidate A — **stale displayed controller state after polling is deliberately blocked/broken**. Demonstrate that GUI-local presentation can retain its prior value while the underlying controller state changes or status becomes unavailable. This is attractive because it directly tests freshness rather than merely re-running T03 in a GUI.

Candidate B — **GUI local enable guard versus controller rejection**. Capture a state where a GUI's previously polled snapshot permits an action but Task rejects it after the authoritative state changes. This directly joins T03's result semantics with a new GUI-staleness failure mechanism.

Candidate C — **error-channel consumer competition**. Run a second reader and show first-consumer semantics can make one GUI miss a diagnostic. This is highly relevant but overlaps T03's promoted multi-consumer error-channel question; keep it 2000 unless needed to validate a GUI-specific 1000-level claim.

## Preferred first experiment direction

Prefer A or B. The experiment should not grade success from widget appearance. It must record:

- GUI-local displayed/enabled state and its monotonic timestamp;
- last successful controller poll timestamp or equivalent freshness indicator;
- independent controller status from a second observer;
- command serial/result if an action is sent;
- error channel separately if applicable.

A GUI mismatch is TEST-CONFIRMED only if local presentation and independent controller state are sampled separately. A screenshot alone is not a sufficient oracle.

## Exact next checkpoint

1. Finish pinned AXIS action + refresh trace so T04 is not QtVCP-only.
2. Locate QtVCP/`GStat` timer initialization and define the exact poll-freshness boundary, including what widgets do when `_status_active` becomes false.
3. Decide between Candidate A and B based on which can be reproduced deterministically in the pinned headless/virtual-display fixture.
4. Write a predeclared T04 experiment plan with immutable gates before harness implementation.
5. Keep error-consumer races, broad QtVCP widget taxonomy and remote GUI/NML transport behavior promoted unless they become necessary to validate the first bounded GUI-state claim.

## Sources

Official/current documentation:

- LinuxCNC AXIS GUI: https://linuxcnc.org/docs/html/gui/axis.html
- LinuxCNC QtVCP: https://linuxcnc.org/docs/html/gui/qtvcp.html
- LinuxCNC QtVCP libraries / Status: https://www.linuxcnc.org/docs/master/html/en/gui/qtvcp-libraries.html
- LinuxCNC Python interface: https://www.linuxcnc.org/docs/master/html/en/config/python-interface.html

Pinned source:

- `src/emc/usr_intf/axis/scripts/axis.py`
- `lib/python/qtvcp/core.py`
- `lib/python/common/hal_glib.py`
- `lib/python/qtvcp/qt_action.py`

Community examples used only as field evidence/hypothesis input:

- https://forum.linuxcnc.org/qtpyvcp/49600-creating-custom-hal-pin-in-qtpyvcp
- https://www.forum.linuxcnc.org/qtvcp/34895-qtvcp-issues
- https://forum.linuxcnc.org/qtvcp/50477-qtdragon-hd-with-mdi-issue
