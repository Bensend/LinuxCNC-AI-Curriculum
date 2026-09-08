# T03 — NML architecture and messages: research baseline

Status: **SOURCE — first experiment frozen**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Documentation baseline

LinuxCNC's Python-interface documentation states the user-interface contract directly: UIs control LinuxCNC by sending NML messages to the Task controller, monitor results through the LinuxCNC status structure, and receive operator/error reporting through an error channel. The documented usage pattern is to establish command/status/error NML connections, poll status, and check whether a requested command is valid for the current controller state before sending it.

LinuxCNC Code Notes gives the larger architecture: Task coordinates motion and discrete I/O, with interpreted program actions becoming messages sent to the appropriate controller at the appropriate time.

The NML-message documentation describes `src/emc/nml_intf/emc.hh` as the vocabulary/type reference. The INI documentation exposes `[EMC] NML_FILE`, whose default is the installed `linuxcnc.nml`, as the configuration boundary for the channel/buffer setup.

Documentation consulted 2026-09-08 UTC:

- Python interface / NML command-status-error model: https://www.linuxcnc.org/docs/master/html/en/config/python-interface.html
- Code Notes architecture: https://linuxcnc.org/docs/html/code/code-notes.html
- NML message list: https://www.linuxcnc.org/docs/2.9/html/de/code/nml-messages.html (content language differs, message vocabulary is code-derived)
- INI `[EMC] NML_FILE`: https://linuxcnc.org/docs/devel/html/en/config/ini-config.html

## Pinned source inventory

### Message vocabulary — `src/emc/nml_intf/emc.hh`

The pinned header assigns explicit NML type identifiers across major domains:

- operator/general messages (`EMC_OPERATOR_*`, `EMC_SET_DEBUG`, system command);
- joint/jog status and commands;
- trajectory motion commands and status;
- motion aggregate messages;
- Task commands and Task status;
- tool, auxiliary, spindle, coolant and I/O status;
- aggregate `EMC_STAT_TYPE`.

It also declares the Task mode/state/exec/interpreter enums consumed by status clients. These numeric values are wire/interface details for the pinned build, not universal constants to memorize across versions.

### Message classes — `src/emc/nml_intf/emc_nml.hh`

Message classes derive from `RCS_CMD_MSG` or `RCS_STAT_MSG`, construct themselves with a specific NML type and size, and provide `update(CMS*)` methods for NML/CMS serialization. Examples include operator messages, jog commands, trajectory messages and aggregate status classes.

This is an important architectural boundary: **a NML type identifier is not the behavior itself.** It selects a message class/serialization path; a receiving process must still interpret and act on the message.

### Format dispatch — `src/emc/nml_intf/emc.cc`

Pinned `emcFormat(NMLTYPE type, void *buffer, CMS *cms)` switches on the NML type and invokes the concrete message's `update(cms)`. The file describes itself as handling update functions and routing messages to the correct buffer/process serialization path.

Therefore `emcFormat` is a format/serialization dispatcher, not the Task semantic command switch. T02's `emcTaskIssueCommand()` is a separate receiving-side behavior dispatch.

### Task's channel ownership — `src/emc/task/emctaskmain.cc`

Task holds three distinct NML channel objects:

- `RCS_CMD_CHANNEL *emcCommandBuffer`
- `RCS_STAT_CHANNEL *emcStatusBuffer`
- `NML *emcErrorBuffer`

During initialization Task opens named channels `emcCommand`, `emcStatus`, and the error buffer using the configured NML file and `emcFormat`/error format functions. Its main cycle calls `emcCommandBuffer->read()` to detect a new command and gets the command message at the channel address. Separately, after updating its aggregate world/status model, Task calls `emcStatusBuffer->write(emcStatus)`.

Operator error/text/display helpers create the corresponding message and write it through `emcErrorBuffer`, establishing a separate reporting stream rather than overloading normal status.

### UI/Python boundary — `src/emc/usr_intf/axis/extensions/emcmodule.cc`

The Python `linuxcnc` module wraps the NML interfaces rather than bypassing them. Representative command flow:

- a method such as `command.state(...)` constructs an `EMC_TASK_SET_STATE` message;
- helper `emcSendCommand()` calls the wrapped command channel's `write(&cmd)`, saves `cmd.serial_number`, and waits for status echo to reach that serial or later;
- `command.wait_complete()` separately polls status for the saved serial and returns matching DONE/ERROR, or treats a later echo serial as DONE, with a default five-second timeout;
- `stat.poll()` checks/peeks the status channel and copies the aggregate `EMC_STAT` when available;
- `error_channel().poll()` calls NML `read()` on the error channel and decodes the operator/error message type.

This establishes a crucial boundary: command send/echo acknowledgement, aggregate command status, and operator/error reporting are distinct observations.

### Task serial acknowledgement

Pinned `emcTaskPlan()` treats command-buffer data as new only while `emcCommand->serial_number != emcStatus->echo_serial_number`. At the end of the cycle Task copies the current command serial into top-level and Task `echo_serial_number` fields, derives aggregate `RCS_STATUS` from planning/execution/subordinate state, and writes the aggregate status channel.

Because Task publishes the command serial even when planning returned an error, **echoed serial is not proof of semantic success**. This is documented in `guides/T03-command-acknowledgement-boundary.md`.

### `emcsvr` remote-server boundary — `src/emc/task/emcsvr.cc`

The optional NML server process loads `[EMC] NML_FILE`, then creates:

- `RCS_CMD_CHANNEL(emcFormat, "emcCommand", "emcsvr", ...)`
- `RCS_STAT_CHANNEL(emcFormat, "emcStatus", "emcsvr", ...)`
- `NML(nmlErrorFormat, "emcError", "emcsvr", ...)`

and runs the NML server infrastructure. This demonstrates that the named channel/buffer model is also the boundary used for remote NML access; it must not be confused with LinuxCNC realtime motion transport or HAL pins.

## Community reconciliation

Community material is treated as field evidence, not authority over pinned source.

Findings consulted 2026-09-08 UTC:

- A July 2023 forum explanation of Python `wait_complete()` describes it as tied to the caller's serialized command ID and notes that other command producers such as HALUI can complicate ordering. This is consistent with the pinned `serial_diff` implementation.
- An April 2023 QtVCP discussion suggests comparing the Python command serial with status echo to implement non-blocking acknowledgement semantics.
- A 2024 field report warns that `wait_complete()` has a default timeout and is not safely interpreted as generic physical-action proof. Pinned source confirms the five-second default and controller-status semantics.
- A July 2026 custom-UI investigation reports `EMC_TASK_PLAN_STEP` can write/echo in an invalid MANUAL context and then produce an asynchronous error report. That provides a useful adversarial field example of the same transport/semantic split T03 will verify independently.

Relevant forum threads:

- https://forum.linuxcnc.org/38-general-linuxcnc-questions/49445-python-command-wait-complete-does-not-wait-for-c-halui-commands
- https://forum.linuxcnc.org/qtvcp/48859-mdi-calls-from-qtvcp
- https://forum.linuxcnc.org/9-installing-linuxcnc/53638-python-nc-routine-just-stops-executing
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/58953-is-there-a-public-nml-status-signal-for-completion-of-one-emc-task-plan-step

## Initial engineering model

Treat NML as **typed inter-process communication with distinct command, status and error/reporting semantics**:

```text
UI/client
  command() -> RCS_CMD_CHANNEL "emcCommand" -> Task read/semantic dispatch

Task/controller world model
  -> RCS_STAT_CHANNEL "emcStatus" -> stat.poll()/other clients

Task/operator reporting
  -> NML "emcError" -> error_channel().poll()/other clients
```

Do not infer:

- that successfully writing or echoing a command proves Task accepted it semantically;
- that a status sample is causally the response to the most recently sent command without serial/state evidence;
- that an error-channel message is equivalent to Task status becoming ERROR;
- that `wait_complete()` is a universal cross-producer transaction barrier;
- that NML IPC is the realtime servo transport;
- that command/status communication establishes physical or safety truth.

## Highest-value source questions and disposition

1. **How do serial and echo establish acknowledgement/order?** Source-traced; see `guides/T03-command-acknowledgement-boundary.md`.
2. **What does `wait_complete()` actually wait for?** Source-traced exactly, including greater-serial behavior and timeout.
3. **What exactly do RCS command/status channels add over generic NML?** Still open for deeper library-level source inventory; not required before the first behavioral experiment.
4. **What are local/shared-memory vs remote NML transport boundaries?** Initial `emcsvr` boundary identified; transport internals remain open.
5. **How does Task identify new versus repeated command-buffer contents?** Source-confirmed by serial-vs-echo comparison.
6. **What does status polling guarantee about freshness?** Open for a later freshness/loss experiment; a poll yields a controller snapshot but physical freshness is explicitly not inferred.
7. **How are error-channel messages queued/overwritten?** Still open; first experiment will characterize ordinary observed behavior without overgeneralizing queue-depth semantics.

## Current experiment checkpoint

T03-020 is frozen in `experiments/T03-020-nml-ack-vs-semantic-result-plan.md` before implementation.

Next work:

1. implement T03-020 without changing Gates A-G;
2. run it once against the pinned build;
3. preserve the exact workflow/job identity, raw serial/status/error trace and final exit code;
4. require the negative ESTOP + `AUTO_STEP` case to prove `echoed=true` while semantic result is ERROR and the error channel independently reports the rejection;
5. if observability fails, classify HARNESS_INVALID rather than weakening the acknowledgement-vs-success distinction.

After accepted verification, continue the NML library/transport inventory, error-buffer semantics, adversarial exam, fresh-AI handoff and T03 graduation audit.
