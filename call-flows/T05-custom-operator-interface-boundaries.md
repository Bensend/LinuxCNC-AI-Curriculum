# T05 call flow — custom operator-interface boundaries

Status: **SOURCE-CONFIRMED baseline**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## 1. HALUI: physical/HAL intent -> NML command

Representative path: `halui.machine.on`.

```text
HAL signal/pin transition
  -> halui main loop
  -> check_hal_changes()
  -> copy_hal_data()
  -> check_bit_changed(new.machine_on, old.machine_on)
  -> sendMachineOn()
  -> EMC_TASK_SET_STATE{ON}
  -> emcCommandSend(...)
  -> Task/controller semantic processing
```

`check_hal_changes()` is edge-oriented for these momentary command pins: it compares the current HAL snapshot with `old_halui_data` and sends the command when the input changes to true. This is not a persistent command-state ownership model.

Representative jog functions add local prechecks from the most recently received `emcStatus` (for example Task must be ON and trajectory mode must match), but these local checks are not the final semantic authority; Task/controller state can still change after the observation.

## 2. Controller status -> HALUI output

```text
NML status
  -> updateStatus()
  -> emcStatus snapshot
  -> modify_hal_pins()
  -> hal_set_*()
  -> halui.* status output pin
```

Examples include:

- `halui.machine.is-on <- (emcStatus->task.state == ON)`;
- `halui.estop.is-activated <- (task.state == ESTOP)`;
- mode pins from Task/trajectory mode;
- `halui.joint.N.is-homed <- emcStatus->motion.joint[N].homed`;
- commanded/feedback axis positions from trajectory status.

The main loop sleeps about 20 ms and then calls `updateStatus()`. Therefore a HALUI status pin is a userspace projection of the latest status snapshot HALUI has received, not a realtime or safety-rated truth source.

Startup is deliberately ordered: HAL component/pins are created, safe pin defaults are initialized, NML is connected, one `updateStatus()` occurs, and only then does the repeating `check_hal_changes() -> modify_hal_pins() -> sleep -> updateStatus()` loop begin. This avoids treating uninitialized NML memory as controller truth, but does not convert HALUI into a safety function.

## 3. QtVCP startup lifecycle

Pinned `qtvcp.py` orders startup approximately as:

```text
create HAL component
 -> construct VCPWindow
 -> load handler extension
 -> build widgets
 -> handler.pre_hal_init__() [optional]
 -> build widget HAL pins
 -> handler.initialized__() [optional]
 -> user override hooks
 -> set default jog rates
 -> STATUS.forced_update()
 -> STATUS.setTimer(CYCLE_TIME)
 -> optional HAL file
 -> halcomp.ready()
 -> show window
 -> postgui HAL
 -> handler.before_loop__() [optional]
 -> Qt event loop
```

The critical T05 finding is that **handler `initialized__()` runs before QtVCP's forced controller-status update**. A custom handler that enables an operator action in `initialized__()` based only on widget defaults, constructor-time cache, or an assumption that status has already been validated can expose a startup window before the framework's explicit synchronization point.

T04 already established that a failed `GStat` poll sets status invalid and suppresses state merging/signals. T05 therefore treats `initialized__()` as construction-time logic, not proof of fresh controller state.

`Status` is a singleton wrapper around `GStat`. It also owns one `linuxcnc.error_channel()` instance for QtVCP and explicitly blocks/unblocks polling when another operation must become the sole consumer. This is source evidence that diagnostic ownership is a design concern rather than a broadcast guarantee.

## 4. Direct Python ownership pattern

LinuxCNC's own examples/screens instantiate the three interfaces explicitly:

```text
linuxcnc.command()       command producer
linuxcnc.stat()          status observer
linuxcnc.error_channel() diagnostic consumer
```

A direct custom UI should therefore define correlation/freshness policy itself. Merely possessing all three objects does not correlate a diagnostic with a command, prove `wait_complete()` for commands issued by another producer, or make the status snapshot current.

## 5. Community failure hypotheses

Community reports are hypothesis evidence, not source truth.

- A 2019 HALUI MDI report described the first HALUI MDI command apparently failing until another GUI action changed mode; the debugging recommendation was to observe actual LinuxCNC status rather than infer mode from the button/UI path.
- A 2024 discussion on Python-interface race conditions notes that `wait_complete()` cannot wait for commands issued by a different producer such as HALUI; QtVCP instead uses mode/idle checks around its own MDI path. This directly supports explicit command ownership/correlation.
- An experienced LinuxCNC developer explained that LinuxCNC historically supports multiple GUIs and that momentary set-on/set-off plus status-read patterns avoid one GUI pretending to own global controller state. UI-local selection state remains a harder multi-producer problem.

## 6. Custom-OI responsibility matrix

| Operator intent | Local UI owner | Command transport | Semantic result oracle | Status source | Freshness rule | HAL/physical source | Diagnostic owner | Safe-state owner |
|---|---|---|---|---|---|---|---|---|
| Machine ON | QtVCP/direct UI | NML command | matching command result/status; not button state | `linuxcnc.stat`/GStat | require successful current observation before advisory enablement | controller/HAL evidence separately | one deliberate error consumer/fan-out | controller + external safety architecture |
| Physical Machine ON button | HAL wiring/HALUI | HALUI -> NML | controller status/result; HAL input edge is only intent | HALUI projected NML status | account for userspace update age | physical input pin + downstream machine state | HALUI has no magical diagnostic correlation | external safety architecture/controller interlocks |
| Jog | UI/HALUI gateway | NML jog command | Task/motion acceptance + motion evidence | status snapshot | state/mode observation must be current enough for advisory gating | motion/HAL feedback separately | designated consumer | realtime/controller limits plus external safety functions |
| MDI | one command owner where practical | NML MDI | owner's matching completion/result | Task/interpreter status | do not infer completion from another producer | resulting motion/I/O separately | designated error consumer | controller semantics + machine safety system |
| State lamp | presentation owner | none | n/a | controller status projection | invalid/stale must be visible or fail-defined | use independent HAL/physical signal when the claim requires it | n/a | lamp is not safety owner |

## 7. 1000-level design rule

A custom operator interface should be designed as a set of explicit ownership boundaries:

**intent capture -> command producer -> semantic result -> status observation/freshness -> physical evidence -> diagnostics -> safety authority**.

Do not collapse these into one green button.

## Evidence ledger

- HALUI edge detection and NML dispatch: **SOURCE-CONFIRMED**.
- HALUI status projection from `emcStatus`: **SOURCE-CONFIRMED**.
- QtVCP `initialized__()` precedes `STATUS.forced_update()`: **SOURCE-CONFIRMED**.
- QtVCP has a singleton error channel with explicit polling arbitration: **SOURCE-CONFIRMED**.
- Cross-producer completion/race concerns: **COMMUNITY-REPORTED**, consistent with T03 source semantics.
- GUI gating is advisory, not safety-rated enforcement: **SOURCE/DESIGN INFERENCE bounded by curriculum safety policy**.

## Next experiment target

Freeze a startup experiment around the lifecycle fact above. Compare a deliberately default-enabled custom action with a freshness-gated action while the first status poll is forced to fail. The decisive claim is not that QtVCP itself is unsafe; it is that custom handler code can expose operator actions before a valid observation unless the handler defines a freshness contract.
