# A01 Adversarial Exam — Process / Component Architecture

Revision under test: LinuxCNC development commit `8bf4605ae81042248add031e94c77300406e0413`.

This exam is source-navigation and reasoning work. Answers that merely repeat architecture nouns do not pass.

## 1. Misleading premise: all LinuxCNC IPC is NML

A developer says: “The GUI sends NML to Task, therefore Task must also send NML to motion.” Prove or disprove this statement at the pinned revision. Name the concrete userspace writer, the shared structure, the realtime receiving function, and the acknowledgement field.

### Expected answer

Disprove it. UI/external control↔Task uses NML channels (`emcCommand`, `emcStatus`, `emcError`). Task→motion goes through `taskintf.cc` to `usrmotWriteEmcmotCommand()` in `usrmotintf.cc`, which writes `emcmot_struct_t.command` in RTAPI shared memory. Realtime `emcmotCommandHandler()` receives it and updates `emcmotStatus->commandNumEcho`; userspace waits for that matching number and then checks `commandStatus`.

## 2. Misleading premise: `iocontrol.0` must be an OS process

You see `iocontrol.0.*` pins in HAL. Is `iocontrol.0` necessarily a separate executable? Prove the runtime shape at the pinned revision from the build/source chain.

### Expected answer

No. `taskclass.cc` is linked into `milltask`. `emcTaskOnce()` constructs `Task`; `Task::Task()` calls `hal_init("iocontrol.0")`; `Task::iocontrol_hal_init()` exports the pins. Thus `iocontrol.0` is a userspace HAL component registered from within `milltask`, not proof of a separate `iocontrol` process.

## 3. Startup-order trap

A reviewer claims: “Task cannot start until motmod is fully running, because Task depends on motion.” Explain why launcher source contradicts the implied sequencing and how startup remains possible.

### Expected answer

`scripts/linuxcnc.in` starts `linuxcncsvr`, realtime/HAL infrastructure, then Task before executing normal machine HAL files that load kinematics/motmod. `emctask_startup()` retries `emcMotionInit()` while later launcher steps load motion. Dependency therefore does not imply launcher ordering “motion fully running before Task process starts.”

## 4. Failure path: mutex contention

During one servo period, Task holds `emcmotStruct->command_mutex` while copying a new command. What should realtime motion do, and why is that preferable to blocking?

### Expected answer

`emcmotCommandHandler()` uses a try-lock. If it cannot take the mutex because Task is updating the command, it returns for that cycle rather than reading a torn command or blocking the realtime handler on userspace work. The next eligible cycle can observe the completed command.

## 5. Failure path: acknowledgement timeout versus command rejection

Explain the difference between these two observations:

1. no matching `commandNumEcho` appears before timeout;
2. a matching `commandNumEcho` appears but `commandStatus` reports failure.

### Expected answer

(1) is a communication/acknowledgement timeout: userspace cannot establish that realtime motion observed that command number in time. (2) means transport/observation occurred but realtime command handling rejected or failed the command. The command-number echo alone is not a success flag.

## 6. Version-sensitivity question

An old forum post depicts `iocontrol` as a standalone controller. May you use it to claim the current development revision runs a separate `iocontrol` process? What evidence would be required to make that claim for another release?

### Expected answer

No. Community diagrams/posts are leads and may reflect conceptual or historical architecture. For another release, inspect that release's task/iotask build files, launcher, HAL registration, and runtime process/component observations. Keep the conclusion version-scoped.

## 7. Bounded source modification

Requirement: add a debug counter recording how many servo invocations of `motion-command-handler` skipped because Task owned `command_mutex`. Describe the smallest architecturally appropriate change without implementing a new NML message or blocking the realtime thread.

### Expected answer

Instrument the existing try-lock failure branch in `emcmotCommandHandler()` with a realtime-safe counter/state field appropriate to motion diagnostics, then expose/report it through an existing suitable status/HAL diagnostic mechanism only if needed. Do not convert the transport to NML, do not replace try-lock with a blocking lock, and do not perform userspace logging from the realtime branch. Exact exposure design requires checking existing diagnostic/state structures before modifying ABI-visible data.

## 8. Runtime observation design

Design a cloud-safe experiment that distinguishes OS processes from HAL components for `linuxcncsvr`, `milltask`, `iocontrol.0`, `motmod`, and `trivkins`. State what it cannot prove.

### Expected answer

Launch a headless upstream simulation, capture `ps`/`pgrep`, `halcmd list comp`, and `halcmd list funct`. Expect OS processes for `linuxcncsvr`/`milltask`; HAL component entries for `iocontrol.0`, `motmod`, `trivkins`; and no standalone executable named `iocontrol` at the pinned revision. The test cannot qualify realtime latency, scheduling guarantees, hardware timing, or functional safety.

## 9. Adversarial lab-result interpretation

A workflow is cancelled at its 60-minute timeout and uploads a `LATEST.md` file showing a prior stable experiment as successful. May that file be used as evidence that the new topology experiment passed?

### Expected answer

No. Check workflow/job timing and metadata. If cancellation happened before the new result file was generated, uploaded workspace files may be stale checkout content. Treat the new experiment as unexecuted/indeterminate, preserve the lab-infrastructure failure, correct runtime bounds, and rerun.

## Pass criteria

A01 can advance past exam only if the answers preserve all three interface distinctions—NML, RTAPI motion shared memory, HAL—and correctly handle startup, runtime-process/component identity, failure semantics, version scope, and stale/cancelled laboratory evidence.
