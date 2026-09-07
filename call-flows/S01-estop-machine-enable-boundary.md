# S01 call flow — E-stop / machine-enable software boundary

LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## A. External E-stop condition reported into LinuxCNC

```text
external circuit / simulated HAL source
  |
  | external-interface state: FALSE means external E-stop condition
  v
iocontrol.0.emc-enable-in   [HAL IN, non-realtime Task/iocontrol]
  |
  | Task::run(): hal_get_bool()
  v
emcioStatus.aux.estop = 1    [software status]
  |
  | determineState()
  v
EMC_TASK_STATE::ESTOP        [synthesized software status]
  |
  | subordinate synchronization / emcTaskSetState actions
  +--> emcMotionAbort()      [software command]
  +--> emcTrajDisable()      [software command toward realtime motion]
  +--> emcAuxEstopOn()
         |
         +--> iocontrol.0.user-enable-out = 0      [external-interface command intent]
         +--> iocontrol.0.user-request-enable = 0  [external-interface reset request state]

realtime motion receives disable
  |
  v
motion internal enable flag = false [realtime controller state]
  |
  | control.c::output_to_hal()
  v
motion.motion-enabled = FALSE        [HAL status output]
```

The final HAL state is not a measurement of physical torque, STO, contactors, brakes, hydraulic energy, or stopping distance.

## B. User/software E-stop command

```text
GUI / halui / API / other command producer
  |
  | command: EMC_TASK_SET_STATE(ESTOP)
  v
NML Task command channel
  |
  v
Task command dispatch
  |
  v
emcTaskSetState(ESTOP)
  +--> motion abort
  +--> spindle abort
  +--> emcAuxEstopOn()
  |      `--> user-enable-out = 0
  +--> emcTrajDisable()
  +--> coolant/task/I/O abort & cleanup
  `--> motion disable path -> motion.motion-enabled = 0
```

This is a software-originated E-stop state transition. Its name does not turn the command channel into a safety-rated emergency-stop function.

## C. Reset / re-enable sequence distinction

```text
EMC_TASK_SET_STATE(ESTOP_RESET)
  |
  v
emcAuxEstopOff()
  +--> user-enable-out = 1
  +--> user-request-enable = 1  (reset-request edge)
  `--> local io.aux.estop cleared

periodic Task::run()
  |
  +-- if emc-enable-in remains FALSE --> io.aux.estop becomes 1 again
  `-- if emc-enable-in is TRUE -------> io.aux.estop remains 0; request pulse clears

separate EMC_TASK_SET_STATE(ON)
  |
  v
emcTrajEnable()
  |
  v
EMCMOT_ENABLE -> realtime motion enable transition
  |
  v
motion.motion-enabled = TRUE
```

Important distinction: **resetting the LinuxCNC E-stop state and commanding Machine ON are separate controller operations**. Neither action proves an external safety device reset permissibly, nor that physical hazards are controlled.

## D. Evidence-label table

| Edge / object | Classification | What it means | What it does not mean |
|---|---|---|---|
| NML `EMC_TASK_SET_STATE` | command | requested Task state | physical safe state |
| `iocontrol.0.emc-enable-in` | external-interface state/status input | external source reports permissive/E-stop condition to LinuxCNC | certified external circuit actually performed required risk reduction |
| `emcioStatus.aux.estop` | status | Task's sampled I/O E-stop state | STO/contactor/brake feedback unless separately wired and validated |
| `iocontrol.0.user-enable-out` | external-interface command intent | LinuxCNC requests enable/not-estop condition | physical actuator state |
| `iocontrol.0.user-request-enable` | command/request pulse | reset request from controller | permission to automatically restart machinery |
| `EMCMOT_ENABLE` / disable | command | Task asks realtime motion to enable/disable | field output delivery or torque state |
| realtime motion enable flag | controller state | motion subsystem enable state | machine safety integrity |
| `motion.motion-enabled` | status output | HAL-visible reflection of motion enable flag | safe torque off or zero stored energy |

## E. Debugging order for a fresh AI

When a machine appears not to leave E-stop, locate the first boundary that disagrees rather than treating all “E-stop” names as one signal:

1. Is `iocontrol.0.emc-enable-in` actually true?
2. Does Task's I/O E-stop/status agree?
3. Was `ESTOP_RESET` requested and did the request pulse occur?
4. Was `ON` separately requested?
5. Did realtime motion accept/reflect enable (`motion.motion-enabled`)?
6. Only after the controller path is understood, inspect the **separate physical safety/drive circuit** under its own engineering evidence.

If LinuxCNC says disabled but the machine remains energized, that is not evidence LinuxCNC's state is wrong; it can indicate a broken downstream control or safety boundary and must be treated accordingly.
