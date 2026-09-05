# A01 Call Flow — Task to Realtime Motion Command/Acknowledgement

Development revision: `8bf4605ae81042248add031e94c77300406e0413`

## Scope

This closes the architecture-level command/ack boundary without attempting the full servo-period internals reserved for M03.

## End-to-end flow

```text
UI / external controller
    |
    | EMC NML command channel
    v
milltask / emctaskmain.cc
    |
    | state/mode gating + sequencing
    v
taskintf.cc
    |
    | populate emcmot_command_t
    v
usrmotWriteEmcmotCommand()  [usrmotintf.cc, userspace]
    |
    | commandNum++
    | mutex lock
    | copy command into emcmot_struct_t.command
    | mutex unlock
    v
RTAPI shared memory
    |
    v
motion-command-handler HAL function
    |
    | emcmotCommandHandler() [command.c, realtime]
    | try command mutex; if Task owns it, return this cycle
    | compare commandNum against status.commandNumEcho
    | on new command, echo command + commandNum into status
    | default status to EMCMOT_COMMAND_OK
    | execute command-specific switch / set error when invalid
    v
emcmot_struct_t.status
    |
    v
usrmotWriteEmcmotCommand()
    |
    | poll usrmotReadEmcmotStatus()
    | require matching commandNumEcho
    | inspect commandStatus
    v
Task sees acknowledgement, command error, connection error, or timeout
```

## Source-grounded findings

### Userspace writer

`src/emc/motion/usrmotintf.cc::usrmotWriteEmcmotCommand()` increments a userspace command sequence number, copies the complete command structure into the RTAPI shared-memory command area under `emcmotStruct->command_mutex`, then polls status for the same `commandNumEcho`. A successful shared-memory copy is therefore not treated as command completion.

Classification: `SOURCE-CONFIRMED`.

### Realtime receiving endpoint

`src/emc/motion/motion.c` exports `emcmotCommandHandler` to HAL as the realtime function named `motion-command-handler`.

`src/emc/motion/command.c::emcmotCommandHandler(void *, long)` is the receiving endpoint. It first tries the command mutex. Failure to acquire it means Task is currently updating the command, so the realtime handler returns rather than reading a torn command. When `emcmotCommand->commandNum != emcmotStatus->commandNumEcho`, the handler recognizes a new command and writes both `commandEcho` and `commandNumEcho` into motion status before dispatching the command switch.

Classification: `SOURCE-CONFIRMED`.

### Scheduling boundary

The official Code Notes state that `emcmotCommandHandler()` is called at the servo rate. Machine HAL commonly adds `motion-command-handler` to the servo thread. This is architecturally different from saying that `usrmotWriteEmcmotCommand()` itself runs in realtime: the writer is inside userspace `milltask`; the receiver is an exported realtime HAL function.

Classification: `DOC-CONFIRMED` + `SOURCE-CONFIRMED`.

### Error semantics

The acknowledgement sequence number only proves that realtime motion observed the command number. `usrmotWriteEmcmotCommand()` separately checks motion's `commandStatus`, distinguishing a successful acknowledgement from an acknowledged invalid/error command. If no matching echo appears within the configured communication timeout, userspace returns a timeout error.

Classification: `SOURCE-CONFIRMED`.

## Important architecture correction

Do not draw the Task→motion path as another RCS/NML command channel. The source at this revision shows RTAPI shared memory (`emcmot_struct_t`) plus a mutex and command-number echo protocol. NML remains the UI/external-control↔Task interface at this level.

## Community cross-check

Community examples commonly show `addf motion-command-handler servo-thread`, which is consistent with the exported HAL function in `motion.c`. Older forum explanations sometimes describe `task` and `iocontrol` as separate conceptual modules/processes. At this pinned development revision, source/build evidence is more specific: `taskclass.cc` is linked into `milltask`, and `Task::Task()` registers `iocontrol.0` as a userspace HAL component in that process. Treat older conceptual diagrams/posts as historical leads, not runtime-process proof.

## Failure cases to retain for later modules

- Task holds the command mutex when the servo-thread handler runs: handler skips that cycle rather than reading partial data.
- New command reaches shared memory but no matching `commandNumEcho` arrives before timeout: userspace reports communication timeout.
- Command is acknowledged but rejected by the command switch: userspace sees command-status failure, not transport success.
- Full implications of servo-thread ordering, deadline misses, and controller execution belong to R02/R04/M03.

## Evidence references

- `src/emc/motion/usrmotintf.cc` — `usrmotWriteEmcmotCommand`, `usrmotReadEmcmotStatus`
- `src/emc/motion/command.c` — `emcmotCommandHandler`
- `src/emc/motion/motion.c` — HAL export of `motion-command-handler`
- `docs/src/code/code-notes.adoc` — command handler described as servo-rate work

## Handoff checkpoint

A fresh AI should now be able to answer: which process writes the command, which data structure crosses the realtime boundary, which realtime function receives it, how torn writes are avoided, where `commandNumEcho` is produced, and why an echoed command number is not itself proof of success.
