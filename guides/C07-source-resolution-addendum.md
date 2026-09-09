# C07 — Source Resolution Addendum: Request Edges, Motion Enable, Homing Status

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Status: SOURCE-CONFIRMED. This addendum resolves the first C07 source questions that were still open when `guides/C07-state-machine-sequencing-research.md` was created.

## 1. HALUI request pins are edge-triggered at the pinned revision

Pinned `src/emc/usr_intf/halui.cc` initializes machine/estop request pins and matching `old_halui_data` values to zero. Its `check_bit_changed()` helper updates remembered state when a bit changes and returns the **new** boolean value. The polling loop sends machine-on/off, E-stop/reset, home-all, joint-home and many other UI commands only when that helper returns nonzero.

Therefore for these boolean request pins:

```text
0 -> 1  : change detected, helper returns 1, request sent
1 -> 1  : no change, no request
1 -> 0  : change recorded, helper returns 0, no request
0 -> 0  : no change, no request
```

A request source must return low before it can generate another request. Holding a request high is not a built-in retry strategy.

This also matches current official HALUI wording rechecked on 2026-09-09: HALUI connects HAL pins to NML commands and triggers an appropriate event when a change is noticed. The exact rising-edge behavior here is source-confirmed for the pinned revision rather than inferred from documentation wording alone.

## 2. Request generation and status publication are independent paths

`sendMachineOn()` constructs `EMC_TASK_SET_STATE`, sets `state=ON`, and calls `emcCommandSend()`. `sendHome(joint)` similarly constructs `EMC_JOINT_HOME` and sends it.

HALUI does not write its achieved-state outputs from those functions. `modify_hal_pins()` separately reads received `emcStatus` and publishes:

```text
halui.machine.is-on
    <- (emcStatus->task.state == ON)

halui.estop.is-activated
    <- (emcStatus->task.state == ESTOP)

halui.joint.N.is-homed
    <- emcStatus->motion.joint[N].homed
```

This is direct source evidence for the C07 architecture rule:

```text
request edge != achieved status
```

## 3. Machine ON has a deterministic realtime blocking prerequisite

Pinned Task `emcTaskSetState(ON)` calls `emcTrajEnable()`. Pinned `taskintf.cc` converts that into an `EMCMOT_ENABLE` command and writes it to Motion.

Pinned `src/emc/motion/motion.c` creates `motion.enable` as a `HAL_IN` boolean. Its initial value is TRUE so simple configurations can leave it disconnected.

Pinned `src/emc/motion/command.c` handles `EMCMOT_ENABLE` as follows:

```text
if motion.enable == false:
    report "can't enable motion, enable input is false"
    do not set emcmotInternal->enabling
else:
    emcmotInternal->enabling = 1
```

The comment says actual enable is deferred until the controller cycle.

Pinned `control.c` later completes the enable transition and sets `EMCMOT_MOTION_ENABLE_BIT`. Conversely, while motion is enabled, if `motion.enable` becomes false, fault checking reports `motion stopped by enable input` and clears the internal enabling request; the controller then clears the achieved motion-enable flag.

Task-side status conversion initializes trajectory `enabled=0` and sets it true only from the returned `EMCMOT_MOTION_ENABLE_BIT`. `determineState()` then derives Task ON from out-of-estop plus achieved trajectory enable. HALUI finally publishes that Task state as `halui.machine.is-on`.

So the end-to-end path is:

```text
HALUI machine.on edge
 -> NML Task ON request
 -> emcTaskSetState(ON)
 -> EMCMOT_ENABLE
 -> realtime checks motion.enable
 -> controller sets/does not set achieved enable flag
 -> Task receives trajectory enabled status
 -> determineState()
 -> HALUI machine.is-on status
```

This makes `motion.enable=false` a non-tautological blocked-transition injection seam for C07-047: it blocks LinuxCNC below the test sequencer rather than merely forcing the sequencer's own status variable.

## 4. Homing state is observed and configuration-dependent

Pinned `homing.h` explicitly defines:

```text
set_unhomed(-1, ...) -> unhome all joints
set_unhomed(-2, ...) -> unhome only joints with VOLATILE_HOME set
```

It also states that `get_allhomed()` returns true only if every active joint is homed, and that per-joint homing output pins are written at the end of each servo period from internal homing state.

Task OFF and ESTOP request `emcJointUnhome(-2)`, not universal unhome-all. HALUI publishes each joint's `is-homed` from returned motion status. Therefore:

```text
OFF/ESTOP command history != universal unhomed state
ON command history != homed state
actual joint homed status must be observed
```

The physical-truth boundary remains separate: a software homed flag is LinuxCNC's state estimate under its homing/configuration model. It is not independent proof that an axis did not move while feedback/control observability was compromised.

## 5. Community failure-pattern reconciliation

Current/recent community reports remain consistent with, but do not define, the source model:

- external button/toggle logic can become desynchronized from LinuxCNC state if it treats its own retained/toggle state as authoritative instead of using `halui.machine.is-on` feedback;
- users with external E-stop/drive disable have reported position-state problems when physical motion/drive behavior outruns LinuxCNC's software observation;
- `VOLATILE_HOME` is useful specifically because homing invalidation is a configured policy rather than a universal consequence of every fault/limit event.

These field reports are retained as adversarial scenario sources. The implementation contract taught by C07 comes from pinned source and experiment evidence.

## 6. Resolved experiment seam

The deterministic first experiment is now frozen in `experiments/C07-047-request-achieved-state-sequencing-plan.md`. Its key adversarial question is not merely whether LinuxCNC can turn on/off; it is whether a test sequencer correctly behaves when:

1. it issues a legitimate machine-on request;
2. LinuxCNC's realtime `motion.enable` prerequisite blocks achieved enable;
3. the prerequisite later becomes true but no fresh edge is sent;
4. only a fresh request produces achieved ON;
5. an active-state loss revokes achieved ON; and
6. restoration alone does not grant automatic resume.

That sequence directly tests state-machine integrity across the actual HALUI -> NML -> Task -> Motion -> status return path.

## Safety boundary

Nothing in this addendum turns `motion.enable`, HALUI, Task, Motion, or the planned lab sequencer into a safety-rated function. The experiment establishes software request/status and restart-policy behavior only.
