# C07 — HALUI -> NML -> Task Machine-State Request / Status Call Flow

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence class: SOURCE-CONFIRMED unless explicitly marked otherwise.

## Why this flow matters
C07 needs a sequencing primitive that distinguishes **request** from **achieved state**. Pinned HALUI source makes that distinction concrete: command pins generate NML state requests on an input activation edge, while separate output pins are refreshed from received Task status.

## HALUI input edge behavior

`src/emc/usr_intf/halui.cc` exports separate HAL inputs for:

- `halui.machine.on`
- `halui.machine.off`
- `halui.estop.activate`
- `halui.estop.reset`
- `halui.home-all`
- per-joint home/unhome requests

At initialization HALUI explicitly sets the command input pins and their local previous-value copies to zero.

The polling path copies current HAL data to a local snapshot and calls `check_bit_changed(current, old)`. The helper updates the remembered value when it changes and returns the new pin value. Callers send commands only when that return value is nonzero. Therefore these command pins are **rising-edge-triggered request inputs** at this pinned revision: a 0->1 transition emits the command; holding the pin high does not continuously resend it; the 1->0 transition updates remembered state but does not emit the request.

Relevant dispatch examples:

```text
rising edge halui.machine.on
  -> sendMachineOn()

rising edge halui.machine.off
  -> sendMachineOff()

rising edge halui.estop.activate
  -> sendEstop()

rising edge halui.estop.reset
  -> sendEstopReset()

rising edge halui.home-all
  -> sendHome(-1)
```

This means a sequencer must return a request pin low before a later request can generate a fresh rising edge.

## NML state-command construction

Pinned `halui.cc::sendMachineOn()` constructs an `EMC_TASK_SET_STATE` message, assigns `EMC_TASK_STATE::ON`, and sends it with `emcCommandSend()`.

The sibling request functions use the same state-command family for OFF/ESTOP/ESTOP_RESET. HALUI is therefore a userspace UI adapter: it is not directly enabling realtime motion hardware from the HAL input pin.

## Task dispatch

Pinned `src/emc/task/emctaskmain.cc` states that the Task main program repeatedly calls `emcTaskPlan()` and `emcTaskExecute()`. `emcTaskPlan()` reads commands and decides behavior from current machine mode/state.

For an NML message of type `EMC_TASK_SET_STATE_TYPE`, Task dispatch casts to `EMC_TASK_SET_STATE` and calls:

```text
emcTaskSetState(state_msg->state)
```

Pinned `src/emc/task/emctask.cc::emcTaskSetState()` then performs the requested transition actions:

- ON -> `emcTrajEnable()` plus coolant-off side effect;
- OFF -> motion/spindle abort, trajectory disable, I/O abort, Task abort, volatile-home unhome, cleanup/sync;
- ESTOP_RESET -> auxiliary E-stop reset request plus Task/I/O/spindle abort/cleanup/sync;
- ESTOP -> motion/spindle abort, auxiliary E-stop on, trajectory disable, Task/I/O abort, volatile-home unhome, cleanup/sync.

## Status return is a different path

HALUI separately exports:

- `halui.machine.is-on`
- `halui.estop.is-activated`
- joint homed/fault status pins and other Task/Motion-derived outputs.

Pinned `halui.cc::modify_hal_pins()` refreshes status outputs from received `emcStatus`, for example:

```text
halui.machine.is-on
    = (emcStatus->task.state == EMC_TASK_STATE::ON)

halui.estop.is-activated
    = (emcStatus->task.state == EMC_TASK_STATE::ESTOP)
```

Thus the same component explicitly embodies two directions:

```text
HAL request input edge
   -> HALUI NML command
   -> Task dispatch/actions

Task/Motion/IO achieved status
   -> NML status received by HALUI
   -> separate HAL status output
```

## Derived C07 sequencing invariant

A generic capstone state machine must not do this:

```text
set halui.machine.on = 1
state = MACHINE_ON        # invalid self-confirmation
```

It should instead do this:

```text
emit a fresh rising-edge request
request pin -> 0 after pulse
wait until halui.machine.is-on == true
only then advance to the state whose prerequisite is Task ON
```

Likewise, an E-stop-reset request should not immediately unlock a subsequent machine-on/homing transition merely because the request pulse was emitted. The sequencer should wait for the corresponding achieved state and any additional readiness predicates.

## Failure/adversarial implications

1. A command may be rejected, delayed, or prevented by subsystem state; request history is not outcome evidence.
2. Holding a HALUI command pin high is not a retry mechanism because requests are rising-edge-triggered at the pinned revision.
3. If an external toggle retains stale state through E-stop, it can generate an unintended later edge/request; external state should synchronize to achieved-state feedback where appropriate.
4. Task ON is only one readiness predicate. It does not imply homed joints, healthy HostMot2 transport/watchdog state, independent physical position truth, or safety-rated enable.
5. Recovery logic should use fresh achieved-state observations and a fresh explicit restart authorization rather than resuming from the sequencer's pre-fault internal state.

## Next source boundary

Trace `emcTrajEnable()` / `emcTrajDisable()` through the userspace-to-motion command interface and locate the motion status field(s) that feed `determineState()`. Then trace homing request/status so the C07 experiment can test at least one blocked transition without relying only on Task-level labels.
