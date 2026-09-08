# T03 — NML architecture and messages: research baseline

Status: **RESEARCH / SOURCE**  
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
- helper `emcSendCommand()` calls the wrapped command channel's `write(&cmd)` and records the command serial number;
- `stat.poll()` checks/peeks the status channel and copies the aggregate `EMC_STAT` when available;
- `error_channel().poll()` calls NML `read()` on the error channel and decodes the operator/error message type.

This is the first T03 source-grounded UI→NML→Task and Task→NML→UI boundary.

### `emcsvr` remote-server boundary — `src/emc/task/emcsvr.cc`

The optional NML server process loads `[EMC] NML_FILE`, then creates:

- `RCS_CMD_CHANNEL(emcFormat, "emcCommand", "emcsvr", ...)`
- `RCS_STAT_CHANNEL(emcFormat, "emcStatus", "emcsvr", ...)`
- `NML(nmlErrorFormat, "emcError", "emcsvr", ...)`

and runs the NML server infrastructure. This demonstrates that the named channel/buffer model is also the boundary used for remote NML access; it must not be confused with LinuxCNC realtime motion transport or HAL pins.

## Community research disposition

Community material about NML often mixes historical RCS/NML implementation details, UI API use, and remote-network access. For 1000-level T03, informal reports are useful for identifying compatibility and remote-access pain points, but exact channel names, type values and serialization behavior will be taken from the pinned source plus a reproducible pinned-build experiment.

A community-focused follow-up should specifically seek failure reports involving:

- mismatched `linuxcnc.nml`/process names;
- command serial/acknowledgement misunderstandings;
- remote NML configuration and server behavior;
- stale status versus new command assumptions.

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

- that successfully writing a command proves Task accepted it semantically;
- that a status sample is causally the response to the most recently sent command without serial/state evidence;
- that an error-channel message is equivalent to Task status becoming ERROR;
- that NML IPC is the realtime servo transport;
- that command/status communication establishes physical or safety truth.

## Highest-value source questions

1. How do RCS command serial numbers and status `echo_serial_number` establish command acknowledgement/order?
2. What exactly do `RCS_CMD_CHANNEL::write()` and `RCS_STAT_CHANNEL` add over generic `NML`?
3. What are the local/shared-memory vs remote NML transport boundaries selected by the configuration file?
4. How does Task decide a newly read command is new versus a repeated buffer value?
5. What does status polling guarantee about freshness, and what does it not guarantee?
6. How are error-channel messages queued/overwritten, and can a client miss them if it polls slowly?
7. Which failures are represented as channel validity/read/write failure versus semantic controller status/error messages?

## Next checkpoint

Trace the command acknowledgement loop at pinned source:

`linuxcnc.command().state(...) -> EMC_TASK_SET_STATE -> emcSendCommand()/RCS_CMD_CHANNEL::write -> Task emcCommandBuffer->read -> command serial handling -> Task semantic dispatch -> emcStatus->echo_serial_number/status write -> linuxcnc.stat().poll/wait_complete`

Then trace `error_channel().poll()` separately so T03 does not confuse error-report messages with command acknowledgement. Build a command/status/error evidence matrix and freeze a pinned experiment that sends one accepted command and one state-invalid/rejected command while sampling serial numbers, Task state, status channel and error channel independently.
