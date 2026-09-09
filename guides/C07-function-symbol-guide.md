# C07 — State-Machine Sequencing — Function / Symbol Guide

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Evidence class: SOURCE-CONFIRMED unless stated otherwise.

## `src/emc/usr_intf/halui.cc`

### `check_bit_changed(bool halpin, bool &oldpin)`
**Purpose:** Edge detector for many HALUI command inputs.  
**Context:** HALUI userspace polling loop.  
**Behavior:** If the current value differs from the stored prior value, updates the stored value and returns the current boolean. Consequently a 0->1 transition returns true and triggers callers; a 1->0 transition records the fall but returns false. Holding true creates no additional transition.  
**C07 consequence:** HALUI state/home command inputs at this revision are rising-edge request surfaces, not level-retried commands.

### `sendMachineOn()` / siblings
**Purpose:** Convert HALUI request edges into NML Task commands.  
**Behavior:** `sendMachineOn()` constructs `EMC_TASK_SET_STATE`, sets `state=EMC_TASK_STATE::ON`, and sends via `emcCommandSend()`. OFF, ESTOP, and ESTOP_RESET use the same Task-state command family.  
**C07 consequence:** the HAL pin does not directly switch realtime motion state.

### `modify_hal_pins()`
**Purpose:** Publish received LinuxCNC status back to HALUI output pins.  
**Important outputs:** `halui.machine.is-on = (emcStatus->task.state == ON)` and `halui.estop.is-activated = (emcStatus->task.state == ESTOP)`, plus homing/fault/program status.  
**C07 consequence:** request and achieved-state evidence are explicitly separate paths.

## `src/emc/task/emctaskmain.cc`

### Task main-cycle architecture
The file's operating notes state that Task cyclically runs `emcTaskPlan()` then `emcTaskExecute()`. Planning reads a command and decides behavior based on current mode/state; execution advances queued commands through pre/postconditions. `EMC_TASK_SET_STATE_TYPE` dispatches to `emcTaskSetState()`.

**C07 consequence:** Task is a stateful mediation layer. An upstream sequencer must not infer success merely because it emitted an NML command.

## `src/emc/task/emctask.cc`

### `emcTaskSetState(EMC_TASK_STATE state)`
**Purpose:** Issue subsystem actions corresponding to requested machine state.  
**Important branches:**
- `ON`: `emcTrajEnable()`; coolant off.
- `OFF`: motion/spindle abort, trajectory disable, I/O/Task abort, volatile-home unhome, cleanup/sync.
- `ESTOP_RESET`: auxiliary-estop reset request plus Task/I/O/spindle abort and synchronization.
- `ESTOP`: motion/spindle abort, auxiliary estop on, trajectory disable, I/O/Task abort, volatile-home unhome, cleanup/sync.

**Failure/semantic boundary:** `ON` is a request into motion enable; this function itself does not prove the motion controller actually enabled.

### `emcTaskAbort()`
**Purpose:** Abort motion and clear Task/interpreter execution state.  
**State cleared:** pending Task command, interpreter list, interpreter/exec state, paused state, motion/read line bookkeeping, command text, call level, single-step state; then queues a plan synchronization and closes/resets the plan.  
**C07 consequence:** restart after a Task abort must not assume the pre-fault interpreter/sequencer execution state remains valid.

### `determineState()`
**Purpose:** Derive the Task state from actual subsystem status.  
**Inputs:** I/O auxiliary E-stop status and trajectory enabled status.  
**Mapping:**
```text
IO estop active                     -> ESTOP
out of estop + trajectory disabled  -> ESTOP_RESET
out of estop + trajectory enabled   -> ON
```
**C07 consequence:** achieved Task state is derived from status, not just the last requested enum.

## `src/emc/task/taskintf.cc`

### `emcTrajEnable()` / `emcTrajDisable()`
**Purpose:** Task-to-motion command interface.  
**Behavior:** Set `emcmotCommand.command` to `EMCMOT_ENABLE` or `EMCMOT_DISABLE` and call `usrmotWriteEmcmotCommand()`.  
**Execution boundary:** userspace Task writes a command for the realtime motion command handler.

### trajectory status update
The Task-side motion-status conversion initializes `stat->enabled=0` and sets it true only when the returned realtime `emcmotStatus.motionFlag` contains `EMCMOT_MOTION_ENABLE_BIT` (with joint-enabled handling in the status conversion).  
**C07 consequence:** this supplies the achieved trajectory-enabled condition later used by Task state derivation.

## `src/emc/motion/motion.c`

### `motion.enable`
**Purpose:** External realtime enable prerequisite.  
**HAL contract at pinned revision:** `motion.enable` is a `HAL_IN` boolean created with default value TRUE so simple machines may leave it disconnected.  
**C07 consequence:** because it is a real prerequisite checked by the motion command handler, deliberately driving it false creates a source-grounded blocked-transition seam for a deterministic C07 test.

## `src/emc/motion/command.c`

### `EMCMOT_ENABLE` case
**Purpose:** Accept/reject Task's realtime motion-enable command.  
**Behavior:** If `motion.enable` is false, reports `can't enable motion, enable input is false` and does not set the internal enabling request. If true, sets `emcmotInternal->enabling=1`; actual enable is deferred to the controller cycle.  
**C07 consequence:** `EMC_TASK_STATE::ON` can be requested while realtime achieved enable remains false. This directly proves why sequencing must wait for status.

### `EMCMOT_DISABLE` case
Sets `emcmotInternal->enabling=0`; the controller cycle honors the disable.

## `src/emc/motion/control.c`

### `emcmotController()`
**Purpose:** Main servo-cycle controller. The file explicitly says it runs every servo period and invokes input processing, fault checks, operating-mode transitions, homing, command generation, HAL output, and status update.  
**C07 importance:** this is where the deferred motion-enable request becomes achieved realtime state.

### `check_for_faults()`
When motion is currently enabled, a false `motion.enable` input reports `motion stopped by enable input` and sets `emcmotInternal->enabling=0`. Joint amplifier faults, following errors, limit faults, spindle faults, and configured miscellaneous faults can also revoke the enabling request.  
**C07 consequence:** achieved enable can be revoked asynchronously relative to a higher-level sequencer's prior request history.

### enabling/disable transition in controller state logic
When `emcmotInternal->enabling` becomes false while the motion-enable flag is true, the controller clears planners/interpolators as needed and clears `EMCMOT_MOTION_ENABLE_BIT`. Conversely, when enabling is requested and the motion-enable flag is false, the controller performs enable-transition setup and eventually sets `EMCMOT_MOTION_ENABLE_BIT`, clearing outstanding motion errors on successful entry.

**End-to-end status loop:**
```text
HALUI machine.on rising edge
 -> NML EMC_TASK_SET_STATE(ON)
 -> Task emcTaskSetState(ON)
 -> emcTrajEnable()
 -> EMCMOT_ENABLE command
 -> realtime command handler checks motion.enable
 -> controller-cycle enabling transition
 -> EMCMOT_MOTION_ENABLE_BIT
 -> Task-side traj.enabled status
 -> determineState() derives ON
 -> HALUI publishes halui.machine.is-on
```

If `motion.enable=false`, the chain stops at the realtime command handler and the final `halui.machine.is-on` confirmation must not appear merely because the request was issued.

## Homing / volatile-home boundary
`emcTaskSetState(OFF)` and `ESTOP` call `emcJointUnhome(-2)`, documented in the source comments as applying only to joints configured `volatile_home`. Therefore loss of homed state is policy/configuration-dependent. A C07 sequencer must observe actual homing status and must not infer it universally from OFF/ESTOP command history.

## Diagnostic retrieval rules

```text
request edge != achieved state
Task ON request != realtime motion enabled
motion enabled != homed
homed status != independent physical-position proof after an unobserved physical disturbance
fault clear != cause removed
prior READY state != post-fault restart authorization
```

## Next symbols / experiment hooks
- HALUI `sendHome()` and homed-status publishing path.
- `emcJointUnhome(-2)` and motion homing API handling of `volatile_home`.
- A simulation configuration where `motion.enable` can be driven deterministically for blocked-enable testing.
- Status sampling of request pin, `motion.enable`, `halui.machine.is-on`, E-stop state, homing state, and the sequencer phase in one ordered observation stream where practical.
