# T03 — command acknowledgement, completion, and error evidence

Status: **SOURCE / COMMUNITY RECONCILED**  
Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

## Question

What does a Python `linuxcnc.command()` serial number and `linuxcnc.stat().echo_serial_number` actually prove, and how is that different from semantic acceptance, controller completion, physical completion, and an error-channel report?

## Pinned Python send path

`src/emc/usr_intf/axis/extensions/emcmodule.cc` stores, per Python command object:

- an `RCS_CMD_CHANNEL *c` for `emcCommand`;
- an `RCS_STAT_CHANNEL *s` for `emcStatus`;
- the last command `serial` written by that Python command object.

`emcSendCommand()` first calls the command channel's `write(&cmd)`. If the write succeeds it records `cmd.serial_number` in `s->serial`, then polls the status channel until `EMC_STAT.echo_serial_number - s->serial >= 0` or the five-second send timeout expires.

Therefore even the normal Python command method does more than enqueue bytes and immediately return: it waits for status publication to catch up to the written serial. But the condition is an **acknowledgement/order boundary**, not a general machine-action completion predicate.

## `wait_complete()` exact pinned semantics

Pinned `emcWaitCommandComplete()` polls the Python command object's status channel at nominal 10 ms intervals. For the command object's saved serial:

1. if status echo serial is **greater** than the saved serial, it returns `RCS_STATUS::DONE`;
2. if status echo serial **equals** the saved serial and top-level status is `DONE` or `ERROR`, it returns that status;
3. otherwise it continues polling until timeout, then returns `RCS_STATUS::UNINITIALIZED`.

This creates an important adversarial case: a later command serial from some producer can cause `wait_complete()` for an earlier saved serial to return DONE merely because the global status stream has advanced beyond it. The function is useful within its intended command-stream context, but it is not a universal transaction or physical-completion protocol across all concurrent NML command producers.

## Task-side serial handling

Pinned `emcTaskPlan()` decides whether the command buffer contains new work by comparing:

`emcCommand->serial_number != emcStatus->echo_serial_number`

If they differ, the command's NML type is treated as new and passed through Task's state/mode-specific semantic planning path. If equal, local `type` is zero and the previous command is not re-planned merely because its buffer contents remain present.

At the end of each Task cycle, after planning/execution and subordinate status updates, Task explicitly writes both:

- `emcStatus->task.echo_serial_number = emcCommand->serial_number`
- top-level `emcStatus->echo_serial_number = emcCommand->serial_number`

and then derives aggregate `RCS_STATUS`:

- `ERROR` if planning/execution or subordinate error conditions are present;
- `DONE` only when Task executor, motion and I/O are done, MDI/interpreter queues are empty, no retained Task command remains, and interpreter is idle;
- otherwise `EXEC`.

It then publishes `EMC_STAT` through `emcStatusBuffer->write(emcStatus)`.

### Consequence

The echo serial is copied from the currently read command even when semantic planning reports an error. Thus:

**echoed serial != semantic success.**

For a matching serial, `status == ERROR` is the relevant negative completion evidence available to `wait_complete()`. The separate operator/error channel can additionally carry the human-readable reason.

## State-invalid command path selected for laboratory use

Task's OFF/ESTOP/ESTOP_RESET branch allows only a bounded set of command types. An unsupported command reaches the default branch, emits:

`command (<type>) cannot be executed until the machine is out of E-stop and turned on`

and returns `-1`. Main-loop code records `taskPlanError=1`, publishes the command's serial as the echo serial, and sets aggregate Task/top-level status to `ERROR` for that cycle.

This is ideal for T03 because it proves, with one command, that:

1. the NML write can succeed;
2. Task can receive and echo the command serial;
3. semantic planning can still reject it;
4. aggregate status can report ERROR for the matching serial;
5. the error channel can independently carry the operator diagnostic.

The laboratory should choose a Python-exposed command whose exact type is source-confirmed as rejected in ESTOP and which has no dangerous real-world meaning in the software-only fixture. `AUTO_STEP`/`EMC_TASK_PLAN_STEP` is a strong candidate because the Python API maps AUTO STEP to `EMC_TASK_PLAN_STEP`, community field evidence reports the same write/echo-then-error distinction in inappropriate modes, and the stock simulation can remain motion-disabled during the negative case.

## Command/status/error evidence matrix

| Observation | Establishes | Does **not** establish |
|---|---|---|
| command method returned after `emcSendCommand()` | channel write succeeded and status echo reached that serial or later within send timeout | semantic success; Task DONE; physical action |
| `command.serial == N` | last serial saved by that Python command object | global ownership of serial N; no competing producer |
| `status.echo_serial_number == N` | Task published status echoing command-buffer serial N | command was semantically accepted |
| `status.echo_serial_number > N` | global Task status has advanced beyond N | which later producer caused advance; completion of physical effect of N |
| matching echo + `status == EXEC` | command identity has been acknowledged but aggregate controller work remains active | command's final success/failure |
| matching echo + `status == DONE` | controller aggregate completion predicate is satisfied for the current world model | physical feedback truth or functional safety |
| matching echo + `status == ERROR` | Task/controller aggregate error was published for that command boundary | exact human-readable cause without further evidence |
| error-channel operator tuple | an operator/error report was emitted and observed | necessarily that it belongs to the client's latest serial unless causally correlated |
| no error tuple | no new report was observed by that poll | semantic success |

## Community reconciliation

Community reports are consistent with the pinned source, but are not treated as authority over it.

- A July 2023 LinuxCNC forum explanation describes `wait_complete()` as tied to the serialized ID of the calling Python command stream and warns that commands from another producer such as HALUI can complicate ordering. This matches the pinned `serial_diff` implementation.
- An April 2023 QtVCP discussion recommends using the command object's serial and status echo as a non-blocking analogue of `wait_complete()`, again treating it as a command-stream acknowledgement mechanism.
- A 2024 field report warns that `wait_complete()` has a default timeout and should not be casually equated with "the physical action definitely happened". The pinned source confirms the five-second default and the aggregate-status/serial logic.
- A July 2026 forum investigation reports `EMC_TASK_PLAN_STEP` can write and echo even in an invalid MANUAL case before an asynchronous operator error says the command cannot be done. That is the same architectural separation predicted by pinned Task code: transport/echo and semantic acceptance are distinct evidence.

## Safety / physical boundary

NML acknowledgement and Task aggregate completion remain controller-software evidence. Neither a serial echo nor `RCS_STATUS::DONE` alone proves actuator position, fresh encoder feedback, fieldbus integrity, or a safety-rated state. Those claims require evidence from their own subsystems.

## Next experiment checkpoint

Freeze T03-020 before implementation with two separate command cases on the pinned stock simulation:

1. a valid, observable state transition with captured client serial, matching echo and requested Task state;
2. a source-confirmed state-inappropriate command that still writes/echoes but produces matching aggregate ERROR and an independently captured operator error message.

The experiment must preserve raw timestamped command serial, echo serial, top-level/task status, Task state/mode, `wait_complete()` return and error-channel tuples. It must explicitly reject `echo_serial >= command.serial => semantic success` as a circular/invalid oracle.
