# M66 Q supervisory wait/timeout call flow — press-brake 4600 preparation

Date: 2026-09-11
Course context: dependency-safe 4600 press-brake preparation while F02 remains blocked
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

Trace the actual LinuxCNC execution path for a digital `M66 Pn Lx Qs` wait from interpreter conversion through Task completion and the eventual `#5399` result. The purpose is to decide what M66 can legitimately own in a press-cycle architecture and what must remain in faster realtime/fault layers.

This note does **not** claim that M66, Task, HAL logic, or ordinary LinuxCNC PC software is functional-safety rated.

## Evidence summary

- `DOC-CONFIRMED`: official M66 documentation says a timed wait stops further program execution until the requested event or timeout; timeout returns `#5399=-1`; the inputs are not monitored in realtime and should not be used for timing-critical applications.
- `SOURCE-CONFIRMED` at the pinned revision: M66 becomes an `EMC_AUX_INPUT_WAIT` command on the interpreter list, Task arms/polls the wait with userspace `etime()` and `emcStatus->motion.synch_di[]`, and the interpreter later materializes the result into `#5399`.
- `SOURCE-CONFIRMED`: timeout itself is not an interpreter error and does not automatically abort the NC program. It marks Task status so the later input read returns `-1`; program/cycle code must explicitly act on that result if timeout should fail the operation.
- `SOURCE-CONFIRMED bookkeeping + INFERENCE`: a timed-out input wait leaves `emcAuxInputWaitIndex`/wait-type bookkeeping uncleared in the inspected timeout branch, while ordinary dwell shares the same `WAITING_FOR_DELAY` state. This creates a plausible stale-wait interaction that requires an isolated executable regression test before being taught as behavior.

## Source inventory

| Path | Symbol / area | Role |
|---|---|---|
| `src/emc/rs274ngc/interp_convert.cc` | `Interp::convert_m()` | validates M66 words, calls canonical `WAIT()`, arms interpreter `input_flag` bookkeeping |
| `src/emc/task/emccanon.cc` | `WAIT()` | validates I/O index, flushes queued motion segments, appends `EMC_AUX_INPUT_WAIT` |
| `src/emc/task/emctaskmain.cc` | pre/postcondition selection, `emcTaskIssueCommand()`, `WAITING_FOR_DELAY` handling | waits for prior motion/I/O, arms timeout/input state, polls input/deadline, marks completion or timeout |
| `src/emc/task/emccanon.cc` | `GET_EXTERNAL_DIGITAL_INPUT()` | maps Task timeout status to `-1`; otherwise returns current synchronized digital input state |
| `src/emc/rs274ngc/rs274ngc_pre.cc` | `Interp::read_inputs()` | after queue synchronization, writes M66 result to parameter `#5399` and clears interpreter `input_flag` |
| `src/emc/task/emctask.cc` | `emcTaskAbort()` | aborts motion/Task execution, clears pending/interpreter queue state, resets plan/interpreter execution and queues resynchronization |
| `src/emc/nml_intf/canon.hh` | `WAIT_MODE_*`, `WAIT()` declaration | canonical wait mode contract |

## End-to-end call flow

### 1. Interpreter validates M66 and calls `WAIT()`

`Interp::convert_m()` handles modal-group-5 M66. For a digital input it:

1. rejects simultaneous `P` and `E` words;
2. rejects a non-immediate `L` wait with `Q <= 0`;
3. permits analog input only in immediate mode;
4. rejects missing/negative P/E input selection;
5. writes the current canonical state tag;
6. derives `type` from `L` or defaults to `WAIT_MODE_IMMEDIATE`;
7. derives timeout from positive `Q`, otherwise zero;
8. calls `WAIT(index, DIGITAL_INPUT, type, timeout)`;
9. treats only `WAIT() == -1` as the invalid-input interpreter error;
10. on accepted construction, sets `settings->input_flag`, `input_index`, and `input_digital` so a later synchronized interpreter pass knows to fetch the result.

Important distinction: `convert_m()` does **not** block in a realtime loop waiting for the pin. It emits a canonical command and records deferred result bookkeeping.

### 2. Canonical `WAIT()` is a queue-buster command constructor

Pinned `emccanon.cc::WAIT()` validates the selected index, constructs `EMC_AUX_INPUT_WAIT`, calls `flush_segments()`, fills `index`, `input_type`, `wait_type`, and `timeout`, then appends the message to `interp_list`.

That establishes a command/execution boundary: preceding queued motion is flushed and Task later owns completion of the wait. M66 is therefore not equivalent to a HAL realtime timer attached directly to the input.

### 3. Task waits for prior motion/I/O before issuing the input wait

`emctaskmain.cc` classifies `EMC_AUX_INPUT_WAIT_TYPE` with precondition `WAITING_FOR_MOTION_AND_IO`. Only after those preconditions are satisfied is the command issued.

This is why M66 is useful as a supervisory synchronization/queue-buster mechanism, but it also means its latency is governed by Task/status execution rather than the servo thread.

### 4. Task arms the timed digital wait

When `emcTaskIssueCommand()` receives `EMC_AUX_INPUT_WAIT_TYPE`:

- immediate mode sets `task.input_timeout=0`, `emcAuxInputWaitIndex=-1`, and no timeout deadline;
- timed/event mode copies the wait type and input index into Task-static bookkeeping, sets `task.input_timeout=2` (armed/pending), and sets `taskExecDelayTimeout = etime() + timeout`.

The postcondition for both `EMC_AUX_INPUT_WAIT_TYPE` and ordinary `EMC_TRAJ_DELAY_TYPE` is `WAITING_FOR_DELAY`.

### 5. `WAITING_FOR_DELAY` polls both the deadline and synchronized digital-input status

On each Task execution pass the state handler computes remaining delay using userspace `etime()`.

If the deadline expires, Task sets execution `DONE`, zeroes `delayLeft`, changes nonzero `input_timeout` to `1` (timeout occurred), and enables eager Task processing.

If an auxiliary wait index is active, Task also examines `emcStatus->motion.synch_di[index]`:

- `HIGH`: complete when input is nonzero;
- `LOW`: complete when input is zero;
- `RISE`: first observe low, then internally change the wait type to `HIGH`; complete on a later high;
- `FALL`: first observe high, then internally change the wait type to `LOW`; complete on a later low.

On event/state success it clears `input_timeout` to zero, sets the auxiliary input index to `-1`, marks Task execution `DONE`, and clears `delayLeft`.

This is state sampling by Task, **not hardware edge capture**. The edge modes require Task to observe the prerequisite state and later the opposite state.

### 6. Timeout becomes `#5399=-1` only during synchronized result readback

After the queue-busting operation completes, `Interp::read_inputs()` handles the previously armed interpreter `input_flag`. It first requires the external queue to be empty, then calls `GET_EXTERNAL_DIGITAL_INPUT()`.

Pinned `GET_EXTERNAL_DIGITAL_INPUT()` returns:

- `-1` for an invalid index;
- `-1` when `emcStatus->task.input_timeout == 1`;
- otherwise the current `motion.synch_di[index]` state as 0/1.

`Interp::read_inputs()` stores that value in parameter `#5399` and clears `input_flag`.

Therefore the timeout path is:

`M66 Q` -> queued `EMC_AUX_INPUT_WAIT` -> Task deadline expires -> `task.input_timeout=1` -> interpreter resynchronizes/reads input -> canonical getter returns `-1` -> `#5399=-1`.

## What M66 timeout does **not** do

The timeout path is normal completion with a result value. It is not, by itself, an interpreter error, Task abort, motion fault, Y1/Y2 disagreement fault, or safety stop.

An upstream LinuxCNC VMC toolchange example demonstrates the intended supervisory pattern explicitly: execute `M66 ... Q...`, test `#5399`, and issue an `(abort, ...)` if the wait failed. In a press cycle, equivalent state-machine/G-code logic must explicitly consume timeout and choose the process response. Silent continuation after `#5399=-1` is possible if the program fails to check it.

Evidence classification: `SOURCE-CONFIRMED` for the result path; `DOC/EXAMPLE-CONFIRMED` for explicit program-side timeout handling.

## Timing and observability boundary

M66 is appropriate only when Task-cycle supervisory timing and the synchronized input status are sufficient evidence for the operation being waited on.

Do not use M66 as the primary detector for:

- fast Y1/Y2 differential error;
- per-joint following error;
- high-rate actuator command saturation;
- transport freshness/watchdog faults when a dedicated freshness witness exists;
- functional-safety input processing.

A GUI/TASK M66 timeout also cannot, from the selected boolean input alone, distinguish a legitimately unchanged process input from stale field I/O, a failed sensor, hydraulic non-response, or a logic/wiring fault. Those causes require layer-appropriate witnesses.

## Abort behavior

Pinned `emctask.cc::emcTaskAbort()`:

- calls `emcMotionAbort()`;
- clears the current pending Task command and `interp_list`;
- forces interpreter state IDLE and Task execution DONE;
- clears pause/line/call-level execution bookkeeping;
- queues a Task-plan synchronization command;
- closes/resets the plan and flushes unflushed segments.

Machine OFF, ESTOP_RESET, ESTOP, and AUTO/MDI mode transitions invoke Task abort through their respective state/mode paths.

### Important open bookkeeping question

The inspected `emcTaskAbort()` does not directly assign `emcAuxInputWaitIndex`, `emcAuxInputWaitType`, `taskExecDelayTimeout`, or `task.input_timeout`. A source-wide assignment search located explicit clearing of `emcAuxInputWaitIndex` on immediate M66 and successful wait completion, but not in the timeout branch or `emcTaskAbort()`.

Separately, `EMC_TRAJ_DELAY_TYPE` issuance sets only a new `taskExecDelayTimeout`; its postcondition shares `WAITING_FOR_DELAY`, whose input-check branch tests `emcAuxInputWaitIndex >= 0`.

This yields a concrete falsifiable hypothesis:

> After a timed-out event-mode M66, a subsequent G4 dwell may still see the stale auxiliary-wait index/type during the shared WAITING_FOR_DELAY state. If the old input happens to satisfy that stale condition, the dwell could complete before its own deadline.

Classification: bookkeeping facts are `SOURCE-CONFIRMED`; the premature-G4 consequence is **INFERENCE / UNVERIFIED**. Do not teach it as observed behavior until an executable regression test confirms or falsifies it.

A bounded web/community search on 2026-09-11 found no direct report resolving this exact stale-wait/G4 hypothesis. Absence of a report is not evidence that the behavior is absent.

## Failure-ownership matrix for generic press-brake architecture

| Condition | Primary detector / timing class | Operation/fault owner | Minimum useful witness | Role of M66 |
|---|---|---|---|---|
| Lost/frozen Y1 or Y2 scale | realtime feedback-integrity + motion/sync layer | joint/sync fault path; press-cycle responds to fault | physical-side feedback freshness/plausibility plus joint state | none as primary detector |
| Per-side following error | LinuxCNC motion/joint realtime path | motion/joint layer | joint ferror/error/enable state | none |
| Y1/Y2 differential mismatch | realtime synchronization layer | sync/fault layer | independent Y1, Y2 and differential error | none as primary detector |
| Final side-command saturation | control/allocation layer at servo rate | synchronization/control fault policy | **final** per-side command plus pre-limit controller state | none as primary detector |
| Pressure not achieved by process deadline | process state machine if supervisory timing is sufficient; faster protection belongs lower/safety-specific | press-cycle operation owner | pressure-qualified/ready witness plus state/deadline | may supervise a qualified boolean if Task timing is acceptable; must check `#5399` |
| Pedal/operator release | ordinary cycle intent path plus separate safety architecture where required | process state machine for ordinary intent; safety system for safety function | explicit pedal/authorization state | possible supervisory input only when timing/safety requirements permit |
| Process input absent | press-cycle state owner | press-cycle | qualified input + explicit timeout/failure state | appropriate for non-time-critical waits; timeout must be consumed explicitly |
| Program wait timeout | Task/interpreter result path | calling program/cycle logic | `#5399=-1` | this is M66's native timeout result; **not an automatic abort** |
| Field-I/O communication loss | transport/watchdog/freshness layer | communication/fault layer, then cycle inhibition/abort | transport error/watchdog/freshness generation | M66 value alone cannot prove freshness |
| Functional-safety chain removal | external/validated safety architecture | safety function | safety-system state appropriate to the machine | ordinary M66 is not a substitute |

## Adversarial checks

1. **“Q5 means the input is checked continuously for exactly five seconds.”** False. Source shows userspace Task-cycle polling against `etime()` and a synchronized status value; the docs explicitly call the input monitoring non-realtime.
2. **“M66 timeout stops the program with an error.”** False. Timeout is converted into `#5399=-1`; program logic must choose to abort/branch.
3. **“RISE/FALL catches a hardware edge.”** Too strong. Task implements edge semantics by observing one state, changing its internal wait mode, then observing the opposite state.
4. **“If a process input does not change, M66 tells us why.”** False. It proves only that the selected status condition was not observed before the Task deadline. It does not diagnose stale transport, sensor failure, hydraulics, wiring, or machine mechanics.
5. **“Task abort explicitly clears every M66 wait variable.”** Not established. The main Task queue/execution is cleared, but the inspected static auxiliary-wait bookkeeping is not directly reset there. The resulting stale-state hypothesis must be tested rather than asserted.

## Frozen next experiment — M66-TIMEOUT-001

Before inspecting runtime behavior, preserve this prediction:

- P0: `M66 P0 L3 Q0.20` with input held low times out and produces `#5399=-1`.
- P1: immediately execute a measurable `G4 P0.50` while changing/holding the same input so it satisfies the stale prior wait type.
- Primary discriminator: does the post-timeout G4 last its intended Task-level dwell interval, or can the stale M66 input condition terminate `WAITING_FOR_DELAY` early?
- Control: repeat G4 in a fresh LinuxCNC process without a preceding timed-out M66.
- Retain: Task/debug timestamps or an independent monotonic userspace witness, the input state transition, M66 result, and subsequent dwell completion timestamp.
- Verdicts: `STALE-WAIT INTERACTION CONFIRMED`, `HYPOTHESIS FALSIFIED`, or `HARNESS INVALID`.
- Do not change Task-cycle time, Q/P values, or input transition sequence after inspecting a result merely to force the predicted effect. If the first harness is invalid, correct only the harness defect and preserve the behavioral contract.

## Course consequence

Even if M66-TIMEOUT-001 falsifies the stale-wait hypothesis, the main press-brake architecture result stands: **M66 is a supervisory Task/interpreter wait primitive whose timeout must be explicitly consumed by the operation owner. It is not a realtime synchronization/fault primitive and is not a functional-safety mechanism.**
