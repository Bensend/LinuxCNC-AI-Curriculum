# S01 — E-stop and machine-enable source guide

Status: **SOURCE**  
Course level: 1000  
LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Purpose

Trace LinuxCNC's software E-stop and machine-enable boundary without confusing controller state with a validated functional-safety function.

## Core boundary

LinuxCNC exposes ordinary machine-control state across several layers:

1. an NML/Task state command requests `ESTOP`, `ESTOP_RESET`, `ON`, or `OFF`;
2. Task/iocontrol drives or samples HAL E-stop interface pins;
3. Task sends enable/disable commands to realtime motion;
4. realtime motion publishes `motion.motion-enabled` and downstream joint/amp-enable state;
5. an external circuit may consume or produce those signals, but its physical action and safety integrity are outside what these software states prove.

Every arrow below must be classified as **command**, **status**, **diagnostic**, or **external-interface state**.

## Pinned source inventory

| Path / symbol | Context | Role | Evidence |
|---|---|---|---|
| `src/emc/task/taskclass.cc::Task::iocontrol_hal_init()` | milltask/userspace, non-realtime | exports iocontrol HAL boundary | SOURCE-CONFIRMED |
| `Task::run()` | periodic Task cycle | samples external E-stop HAL input into I/O status | SOURCE-CONFIRMED |
| `Task::emcAuxEstopOn/Off()` | Task command handling | drives controller E-stop/enable intent toward HAL | SOURCE-CONFIRMED |
| `src/emc/task/emctask.cc::emcTaskSetState()` | Task/userspace | implements requested Task state transitions | SOURCE-CONFIRMED |
| `determineState()` | Task/userspace | synthesizes Task state from I/O E-stop and motion enabled status | SOURCE-CONFIRMED |
| `src/emc/task/taskintf.cc::emcTrajEnable/Disable()` | Task/userspace | sends `EMCMOT_ENABLE`/disable command through the Task-motion interface | SOURCE-CONFIRMED |
| `src/emc/motion/command.c` `EMCMOT_ENABLE`/disable handling | realtime motion command path | requests realtime enable-state transition | SOURCE-CONFIRMED |
| `src/emc/motion/motion.c` HAL export | realtime motion component | exports `motion.motion-enabled` | SOURCE-CONFIRMED |
| `src/emc/motion/control.c::output_to_hal()` | servo thread | publishes `GET_MOTION_ENABLE_FLAG()` to `motion.motion-enabled` | SOURCE-CONFIRMED |

## Iocontrol pins and polarity

Pinned `Task::iocontrol_hal_init()` exports:

- `iocontrol.0.user-enable-out` — HAL OUT;
- `iocontrol.0.emc-enable-in` — HAL IN;
- `iocontrol.0.user-request-enable` — HAL OUT.

Current official LinuxCNC documentation defines `emc-enable-in` as active-low for an external E-stop condition, `user-enable-out` as false when an internal E-stop condition exists, and `user-request-enable` as true when the user has requested E-stop clear.

The pinned implementation agrees with that behavior:

- `Task::run()` sets `emcioStatus.aux.estop = 1` when `emc-enable-in` reads false;
- `emcAuxEstopOn()` drives `user-enable-out = 0` and clears `user-request-enable`;
- `emcAuxEstopOff()` drives `user-enable-out = 1`, pulses `user-request-enable = 1`, and clears the local I/O E-stop status.

### Source-comment trap

`taskclass.hh` contains legacy comments whose wording suggests opposite polarity (`TRUE when EMC wants stop` / `TRUE on any external stop`). Do **not** use those comments as behavioral authority. Executable pinned source and current official pin documentation agree on the active-low external-input semantics above. This is a durable example of why symbol comments must be checked against implementation.

## External input -> Task state path

`Task::run()` executes periodically from Task and samples `iocontrol.0.emc-enable-in`.

- false -> `emcioStatus.aux.estop = 1`;
- true -> `emcioStatus.aux.estop = 0`, and a pending `user-request-enable` pulse is cleared.

`determineState()` then derives the high-level Task state:

- `io.aux.estop != 0` -> `EMC_TASK_STATE::ESTOP`;
- otherwise if trajectory is not enabled -> `ESTOP_RESET`;
- otherwise -> `ON`.

This is a **software status synthesis**, not a measurement of torque, contactor state, STO channel state, stopping distance, or safety integrity.

## Task state command -> motion path

`emcTaskSetState()` implements the control actions:

- `ESTOP`: abort motion/spindles, call `emcAuxEstopOn()`, disable trajectory, turn coolant off, abort Task/I/O work, and perform cleanup/unhome actions;
- `ESTOP_RESET`: call `emcAuxEstopOff()` and reset/abort subordinate activity, but it does not by itself command trajectory enabled;
- `ON`: call `emcTrajEnable()`;
- `OFF`: abort and disable trajectory without asserting the same I/O E-stop semantics as `ESTOP`.

`emcTrajEnable()` creates an `EMCMOT_ENABLE` command and writes it through the userspace motion-command interface. Realtime motion processes that command and changes its internal enable state. `output_to_hal()` publishes that state as `motion.motion-enabled`.

Therefore:

`Task ON` -> **command intent** -> motion enable request -> **realtime controller state** -> `motion.motion-enabled` **status output**.

It does not mean: `Task ON` -> certified physical energization.

## Representative failure path

External E-stop input falls false while motion is enabled:

1. `Task::run()` observes `emc-enable-in = 0` and sets `io.aux.estop`;
2. Task state becomes ESTOP and subordinate-state synchronization disables trajectory / aborts activity;
3. realtime motion processes disable state and ultimately publishes `motion.motion-enabled = 0`;
4. downstream HAL logic may command amp/drive enable false.

What is proven by source: LinuxCNC requests/records a disabled controller state.

What remains unproven: that the external circuit opened, STO channels transitioned, torque disappeared, hydraulic energy was removed, motion stopped within any time, or a required PL/SIL/category was achieved.

## Documentation reconciliation

Current official `iocontrol` documentation explicitly says the component is non-realtime and describes these pins as I/O/control signals. LinuxCNC's broader safety documentation warns against relying on software alone for machinery safety. The source trace is consistent with that boundary: the code implements controller state and an external interface, not a certification mechanism.

## Community reconciliation

Experienced LinuxCNC community guidance commonly uses an external safety circuit to establish the safe physical condition and reports its state into LinuxCNC. This is useful integration practice evidence, not a universal standards determination. Community claims about a particular wiring scheme being “compliant” must not be promoted to a course-wide safety claim without machine-specific analysis.

## Evidence ledger

| Claim | Class | Scope |
|---|---|---|
| `emc-enable-in=0` becomes I/O E-stop status | SOURCE-CONFIRMED + DOC-CONFIRMED | pinned implementation/current docs |
| `user-enable-out=0` is LinuxCNC internal E-stop/disable intent | SOURCE-CONFIRMED + DOC-CONFIRMED | pinned implementation/current docs |
| `user-request-enable` is a reset request pulse | SOURCE-CONFIRMED + DOC-CONFIRMED | pinned implementation/current docs |
| `motion.motion-enabled` mirrors realtime motion enable flag | SOURCE-CONFIRMED | pinned revision |
| LinuxCNC software state alone proves physical torque removal | **REJECTED** | no evidence |
| A HAL E-stop loop has a PL/SIL/category because it is called E-stop | **REJECTED** | no evidence |
| Exact applicable standards/performance target can be generalized from LinuxCNC source | **REJECTED / machine-specific** | safety engineering required |

## Experiment decision

A bounded simulation is useful **only** to independently verify the software-state transition. It should inject an external-style `emc-enable-in` false condition from an enabled baseline and observe Task/motion/iocontrol state. It must explicitly state that it proves no physical emergency-stop performance.

Predeclared prediction: from an enabled software baseline, forcing the external E-stop input false will cause LinuxCNC to enter software ESTOP/disable behavior and `motion.motion-enabled` to fall false; clearing the input alone will not be treated as proof of a safe physical reset or machine-specific restart authorization.

## Higher-level promotion

- Task-cycle-to-motion-disable latency distribution: 2000 / HIGH; not needed to teach the state boundary, and cannot establish physical stop time anyway.
- Combined software E-stop with communication loss/stale feedback/watchdog faults: S03/S04/S06/2000 / HIGH.
- Physical E-stop/STO/brake/contactor reaction and stopping time: commissioning/safety / CRITICAL.
- Applicable law/standard, required PL/SIL/category, validation plan: machine-specific safety engineering / CRITICAL.

Counterfactual check: none of these promoted items can make the central S01 teaching (“software controller state is not a validated physical safety function”) false. They can only add machine-specific physical/safety evidence.
