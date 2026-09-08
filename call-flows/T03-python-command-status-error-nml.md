# T03 call flow — Python command/status/error through NML

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Representative command path

### 1. Python UI constructs a typed command

In `src/emc/usr_intf/axis/extensions/emcmodule.cc`, a Python call such as:

```python
c = linuxcnc.command()
c.state(linuxcnc.STATE_ON)
```

enters the binding's `state(...)` method. The binding constructs an `EMC_TASK_SET_STATE` message, validates the requested enum, and passes the typed `RCS_CMD_MSG` through the common send helper.

### 2. `emcSendCommand()` writes the RCS command channel

The common helper calls:

```text
s->c->write(&cmd)
```

where `s->c` is the UI's `RCS_CMD_CHANNEL`. On successful write the binding stores the command's `serial_number` in the Python command-channel object.

Important boundary: a successful channel write proves only that the client-side NML/RCS write succeeded. It does **not** prove Task accepted the command for the current machine state or that any subordinate action completed.

### 3. Task owns and reads `emcCommand`

Pinned `emctaskmain.cc` constructs:

```text
RCS_CMD_CHANNEL(emcFormat, "emcCommand", "emc", emc_nmlfile)
```

and obtains the command structure with `get_address()`. Each Task cycle calls:

```text
emcCommandBuffer->read()
```

A nonzero result means a new command was read and Task clears prior plan/execute error flags before running its planning/execution cycle.

### 4. Message type and serial enter Task planning/dispatch

The message's `_type` selects Task planning/issue behavior. For `EMC_TASK_SET_STATE`, T02 already traced the semantic Task state path. T03's concern is the IPC boundary: the message is typed and serialized through NML, then interpreted by the receiving Task process.

The command `serial_number` is therefore part of command identity/order evidence; message type alone is insufficient to identify which invocation a later status sample acknowledges.

## Representative status path

### 5. Task publishes aggregate status separately

Task constructs a distinct:

```text
RCS_STAT_CHANNEL(emcFormat, "emcStatus", "emc", emc_nmlfile)
```

After updating the controller world/status structures during the cycle, Task writes the aggregate `EMC_STAT` through:

```text
emcStatusBuffer->write(emcStatus)
```

Status is therefore not the return value of the command-channel write. It is a separately published controller snapshot.

### 6. Python `stat.poll()` reads/copies `EMC_STAT`

The Python binding's status object checks the status channel, peeks for `EMC_STAT_TYPE`, obtains the buffer address, and copies the aggregate `EMC_STAT` into the Python status object.

A status sample can expose Task state, execution/interpreter state, trajectory status and command acknowledgement fields. The client still needs the correct serial/state predicate to decide whether the sample corresponds to the requested command's completion boundary.

## Representative error/reporting path

### 7. Task writes operator messages to `emcError`

Task also owns a generic NML error/reporting buffer. Helpers such as `emcOperatorError()`, `emcOperatorText()` and `emcOperatorDisplay()` construct typed operator messages and write them through:

```text
emcErrorBuffer->write(...)
```

This is a third evidence stream, distinct from command transport and aggregate status.

### 8. Python `error_channel().poll()` reads the reporting stream

The Python error-channel poller calls the wrapped NML channel's `read()`. A zero type means no new message; recognized operator message types are decoded into `(type, text)` tuples.

Important boundary: “no error-channel tuple was observed” does not by itself prove a command succeeded. Conversely, an operator error message does not necessarily mean the Task executor's aggregate `exec_state` is `ERROR`; the channels report related but different facts.

## Format/serialization layer

All EMC command/status message classes carry explicit NML type IDs declared in `emc.hh` and classes defined in `emc_nml.hh`. Pinned `emcFormat(type, buffer, cms)` switches on the type and calls that concrete class's `update(CMS*)` routine.

Therefore:

```text
message class / type
    -> emcFormat serialization dispatch
    -> RCS/NML channel/buffer
    -> receiver read
    -> receiver semantic dispatch
```

Do not collapse `emcFormat()` into `emcTaskIssueCommand()`: the first formats/transfers typed data; the second determines machine-control behavior after Task receives it.

## Remote boundary

`emcsvr.cc` opens the same named `emcCommand`, `emcStatus`, and `emcError` channels as an NML server process using the configured `NML_FILE`, then runs the NML server infrastructure. Remote access therefore reuses the NML channel/message contract; it is not a new realtime motion protocol.

## Evidence matrix

| Observation | Establishes | Does not establish |
|---|---|---|
| command-channel `write()` succeeds | client NML write succeeded | semantic acceptance, command completion, physical action |
| Task `read()` sees command | Task received a channel update | requested operation is legal or complete |
| matching acknowledgement serial in status | Task status has acknowledged that command identity/order boundary | subordinate/physical completion unless the command's semantics define it |
| status state reaches requested value | controller world/status model reached that state | independent physical/safety truth |
| error-channel tuple | a typed operator/error report was emitted and observed | necessarily Task `exec_state==ERROR` |
| no error tuple | client saw no new report in that poll | command success |
| `emcsvr` channel is valid | NML server connected to configured buffers | realtime determinism or physical communication health |

## Next source checkpoint

Trace `RCS_CMD_MSG::serial_number`, `RCS_STAT_MSG::echo_serial_number`, `command.wait_complete()`, and Task's update of the echoed serial at the pinned revision. Then freeze T03's first experiment around one valid command and one semantically invalid/state-inappropriate command while independently recording:

- client command serial;
- status echo serial;
- Task state/status;
- `wait_complete()` outcome;
- error-channel messages.

The experiment must not equate channel write success with semantic success.
