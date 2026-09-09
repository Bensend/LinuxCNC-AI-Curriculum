# C07 — State-Machine Sequencing — 1000-level Research / Source Entry

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: RESEARCH / SOURCE

## 1000-level objective
Build a source-grounded model of machine-state sequencing sufficient to design a generic capstone controller that does not confuse command requests with achieved state. Trace at least machine E-stop/reset/off/on, abort/reset effects, homing eligibility/state loss, and the boundary between a user/HAL sequencing layer and LinuxCNC Task/Motion state. The eventual experiment should demonstrate guarded sequencing and fault interruption without claiming functional-safety behavior.

## Official documentation findings

### HALUI is a command/status adapter, not the machine-state implementation
Current official HALUI documentation describes HALUI as a HAL-based UI that converts HAL pins to LinuxCNC NML commands. Relevant request/status surfaces include:

- `halui.estop.activate`
- `halui.estop.reset`
- `halui.estop.is-activated`
- `halui.machine.on`
- `halui.machine.off`
- `halui.machine.is-on`
- homing and program-control pins

The sequencing implication is that a capstone state machine must distinguish an input pulse/request from the later observed LinuxCNC state. A request pin becoming true is not itself evidence that Task/Motion reached the requested state.

Official homing/INI documentation also makes homing state configuration-sensitive. `VOLATILE_HOME=1` can cause a joint to become unhomed when machine power is off or E-stop is on. `HOME_SEQUENCE` controls Home-All ordering and can synchronize final moves when negative sequence numbers are used. Therefore C07 must not teach a universal `ESTOP -> always unhomed` or `machine ON -> homed` transition.

Official sources consulted/rechecked 2026-09-09:
- https://linuxcnc.org/docs/html/gui/halui.html
- https://linuxcnc.org/docs/stable/html/man/man1/halui.1.html
- https://linuxcnc.org/docs/stable/html/config/ini-config.html
- https://linuxcnc.org/docs/stable/html/config/ini-homing.html

## Community research leads

Community cases reinforce the distinction between a requested UI/HAL transition and synchronized achieved state:

1. External momentary machine-on/off button examples use `halui.machine.is-on` to synchronize toggle logic rather than assuming a button pulse changed state. A reported failure case showed a brief machine-on attempt after E-stop because the external toggle's state had not been synchronized to the actual LinuxCNC state. This is a useful sequencing-failure lead, not a normative implementation recipe.
2. E-stop discussions repeatedly distinguish LinuxCNC software state from external hardwired enable/energy-removal circuits. Community examples often require explicit operator reset and use external relays/drive enables rather than treating `halui.estop.*` alone as a safety function.
3. A field report about homing after E-stop shows why homed state cannot be assumed from command history; whether homing is invalidated depends on configuration and whether position may have been lost.

Representative threads:
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/45326-external-power-on-off-estop
- https://forum.linuxcnc.org/47-hal-examples/53533-hardwired-estop-reset-circuit
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/40287-no-unhoming-after-emergency-stop-or-limit-sw-trigger

Classification: COMMUNITY-REPORTED investigation leads until reconciled with source/experiment.

## Pinned source entry

### `src/emc/task/emctaskmain.cc`
The file's own operating notes establish the userspace Task loop:

```text
main loop
  -> emcTaskPlan()
       reads a new command and decides what to do based on Task mode/state
  -> emcTaskExecute()
       advances queued/interpreter commands through pre/postcondition states
```

Immediate commands can be sent directly to subsystems; queued interpreter commands advance under Task execution preconditions/postconditions. This is an important C07 boundary: machine-state requests are mediated through Task rather than being equivalent to arbitrary HAL sequencing state.

`EMC_TASK_SET_STATE_TYPE` dispatches to `emcTaskSetState(state)`.

### `src/emc/task/emctask.cc::emcTaskSetState()`
Pinned behavior is SOURCE-CONFIRMED:

#### `OFF`
- abort motion;
- abort spindles;
- disable trajectory/servos through `emcTrajDisable()`;
- abort I/O with `TASK_STATE_OFF` reason;
- force flood coolant off;
- abort Task/interpreter state;
- unhome only joints selected by the volatile-home path (`emcJointUnhome(-2)`);
- cleanup and resynchronize the interpreter/task plan.

#### `ON`
- calls `emcTrajEnable()`;
- forces flood coolant off.

The compact ON branch is deliberately important: entering Task ON does not itself prove homing, program readiness, external-drive readiness, safe physical state, or recovery of a prior fault.

#### `ESTOP_RESET`
- requests auxiliary E-stop off (`emcAuxEstopOff()`);
- coolant off;
- aborts Task state;
- aborts I/O with ESTOP_RESET reason;
- aborts spindles;
- cleanup and plan synchronization.

#### `ESTOP`
- aborts motion and spindles;
- requests auxiliary E-stop on;
- disables trajectory;
- coolant off;
- aborts Task and I/O;
- unhomes only volatile-home joints;
- cleanup and plan synchronization.

### `src/emc/task/emctask.cc::determineState()`
The source comments define Task's derived machine state from subsystem state, not merely the most recent command request:

```text
traj disabled + IO estop       -> ESTOP
traj enabled  + IO estop       -> ESTOP
traj disabled + out of estop   -> ESTOP_RESET
traj enabled  + out of estop   -> ON
```

This is a strong C07 design rule: capstone sequencing should observe achieved state/status and use commands as transition requests, rather than using command-edge history as the authoritative state variable.

## Initial state-machine model for the capstone

The first generic model is intentionally conservative and must be source/experiment refined:

```text
ESTOP
  request estop-reset
    -> wait for observed ESTOP_RESET/out-of-estop state

ESTOP_RESET / MACHINE-OFF
  request machine-on
    -> wait for observed ON

ON / NOT-READY
  if current machine policy requires homing:
      request home
      -> wait for all required joints actually homed
  else:
      proceed only when required readiness predicates are true

READY
  permit cycle start only while all readiness predicates remain true

ANY ACTIVE STATE
  transport/watchdog/motion/task/IO fault or E-stop request
    -> revoke cycle permission immediately in the capstone state machine
    -> issue the appropriate LinuxCNC abort/off/estop request for the tested scenario
    -> wait for achieved state before offering recovery

RECOVERY
  clear only the fault that has actually been diagnosed/removed
  -> re-observe Task/Motion/HAL state
  -> re-establish homing/readiness as required
  -> require a fresh explicit start authorization rather than continuing from stale pre-fault state
```

This is an engineering model to be tested, not a functional-safety state machine.

## Non-equivalences carried forward from graduated prerequisites

```text
request machine-on != observed machine-on
request estop-reset != proof external E-stop/safety circuit is reset
Task ON != homed
Task ON != drive/actuator physically ready
fault pin cleared != root cause removed
transport/watchdog recovery != machine restart authorization
commanded position == reported feedback != independent plant-state proof
ordinary HAL/Task sequencing != functional-safety certification
```

## Source questions for next pass

1. Trace the NML path by which HALUI machine/estop/home request pins become Task commands, including edge behavior of HALUI request pins.
2. Trace `emcTrajEnable()`/`emcTrajDisable()` into the motion command/status boundary and identify the externally visible achieved-state pins/fields appropriate for an experiment.
3. Trace `emcTaskAbort()` effects far enough to explain what state is invalidated versus preserved across OFF, ESTOP_RESET, and ESTOP.
4. Reconcile homing state loss for `VOLATILE_HOME` with the pinned motion/task path; distinguish configuration policy from physical position truth.
5. Identify a deterministic simulation seam for a C07 experiment that exercises request -> achieved-state wait -> fault interruption -> guarded recovery without physical hardware.
6. Freeze the experiment before implementation; include an adversarial case where a command request is issued but the expected achieved state is blocked, proving the capstone state machine does not advance merely from its own output pulse.

## Safety boundary
C07 studies ordinary LinuxCNC sequencing/state integrity. It does not make `halui`, Task, Motion, ClassicLadder, a custom HAL component, or a simulated capstone state machine into a safety-rated controller. Physical safe-state, external E-stop architecture, output-energy removal, reset policy, and automatic-restart restrictions require separate machine-specific safety engineering.
