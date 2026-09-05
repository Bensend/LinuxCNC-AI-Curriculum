# A01 — LinuxCNC Process / Component Architecture

Status: SOURCE / EXPERIMENT

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`

Stable comparison baseline: `v2.9.10` → `86cdca76fa2a36274c432caa21952b23c267989a`

## Learning objective

A fresh AI engineer must be able to distinguish LinuxCNC's runtime processes, realtime modules/components, userspace control layers, HAL, interpreter, GUI, and NML/shared-memory boundaries; locate their source entry points; and trace who starts whom and which execution contexts exchange commands/status.

This guide is intentionally a runtime architecture map, not a repetition of L02's build-directory map.

## Official documentation pass

The current LinuxCNC Code Notes describe the coarse architecture as a task-level command handler/interpreter coordinating a motion controller and discrete-I/O controller, with multiple user interfaces. They describe the motion controller as realtime, receiving commands from non-realtime Task/interpreter/GUI code, with communication across the realtime boundary through message-passing shared memory and HAL.

Official current developer documentation also identifies `milltask` as the non-realtime task controller and documents `motion`/`motmod` as the realtime motion component accepting motion commands and interacting with HAL.

References:

- https://linuxcnc.org/docs/html/code/code-notes.html
- https://linuxcnc.org/docs/devel/html/en/man/man1/milltask.1.html
- https://linuxcnc.org/docs/devel/html/en/man/man9/axis.9.html

Evidence class: `DOC-CONFIRMED`, current documentation as inspected 2026-09-05. The source trace below refines several coarse documentation labels that are unsafe to treat as literal runtime process boundaries.

## Community/developer investigation leads

Forum discussions provide useful architecture traps rather than authoritative answers:

- a 2023 GUI/NML discussion treats a GUI as a separate process communicating through LinuxCNC's NML interface and asks how directly a custom UI may participate;
- a 2023 NML command-path investigation shows that the existence of an NML message type does not prove Task will accept it in every machine state/mode; the actual `emctaskmain.cc` command/state switches decide whether it is executable;
- a 2026 step-completion discussion highlights that public NML/status fields and realtime motion state do not necessarily preserve a one-to-one mapping back to authored G-code lines.

Investigation URLs:

- https://forum.linuxcnc.org/41-guis/47942-nml-and-gui-from-scratch
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/48855-traj-set-acceleration-not-possible-via-nml
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/58953-is-there-a-public-nml-status-signal-for-completion-of-one-emc-task-plan-step

Classification: `COMMUNITY-REPORTED` leads. Each architectural claim is promoted only where pinned source or a reproducible experiment supports it.

## Source inventory

| Path | Symbols / role | Context | Depth |
|---|---|---|---|
| `scripts/linuxcnc.in` | top-level launcher/config orchestration, startup and cleanup ordering | userspace shell process | deep |
| `src/emc/task/Submakefile` | `MILLTASKSRCS`, `../bin/milltask` link target | build-to-runtime mapping | normal |
| `src/emc/task/emctaskmain.cc` | `main`, `emctask_startup`, Task cyclic loop, NML command/status/error channels | non-realtime userspace | deep |
| `src/emc/task/taskintf.cc` | Task-side motion interface; constructs `emcmot_command_t` and calls `usrmotWriteEmcmotCommand` | non-realtime userspace | deep |
| `src/emc/motion/usrmotintf.cc` | RTAPI shared-memory attachment, command write/ack, motion-status read | userspace↔realtime motion boundary | deep |
| `src/emc/task/taskclass.cc` | `Task`, `emcTaskOnce`, `iocontrol_hal_init`, discrete/tool/coolant HAL interface | inside `milltask`, userspace HAL component | deep |
| `src/emc/motion/` | realtime motion implementation and shared structures | realtime boundary | inventory here; deep in A03/M03 |
| `src/emc/nml_intf/` | EMC NML message/status definitions | UI/Task IPC contract | normal/deep in A03/T03 |
| `src/emc/rs274ngc/` | interpreter implementation used by Task | non-realtime userspace | normal in A01; deep T01 |
| `src/hal/` | HAL core, components, drivers and tools | mixed realtime/userspace | normal in A01; deep H01+ |

All source findings below are scoped to development commit `8bf4605ae81042248add031e94c77300406e0413` unless explicitly stated otherwise.

## Exact launcher startup order

`linuxcnc` is an orchestration script, not the motion controller. `scripts/linuxcnc.in` reads the INI, chooses the configured Task/display/HAL files, establishes paths and cleanup behavior, then performs the following relevant startup sequence in actual script order:

1. **`linuxcncsvr` first.** The script hard-codes `EMCSERVER=linuxcncsvr` and comments that it now holds/creates all NML channels, therefore it must start as the first process. It executes `linuxcncsvr -ini <file>`.
2. **Realtime/RTAPI/HAL backend.** It invokes `$REALTIME start` and exports `HAL_RTMOD_DIR`.
3. **Trajectory-planning and homing modules.** It performs `halcmd loadrt "$TPMOD"` and `halcmd loadrt "$HOMEMOD"`.
4. **Task.** It starts the configured `[TASK]TASK` program through `halcmd loadusr -Wn inihal "$EMCTASK" -ini <file>`. A normal configuration selects `milltask`.
5. **Optional userspace HAL interfaces.** `halui` and `HALBRIDGE`, when configured, are loaded after Task.
6. **HAL configuration.** `[HAL]HALFILE` entries (or the twopass Tcl path) execute next, followed by discrete `[HAL]HALCMD` entries. This is where normal machine configurations load kinematics and `motmod`; for example, upstream `lib/hallib/core_sim.hal` explicitly runs `loadrt [KINS]KINEMATICS` followed by `loadrt [EMCMOT]EMCMOT ...`.
7. **Start HAL realtime functions.** The launcher calls `halcmd start` only after HAL configuration has been assembled.
8. **Applications, then foreground display.** Configured applications run; then the selected display/UI is run in the foreground. When it returns, launcher cleanup begins.

This corrects a tempting but false architecture diagram in which `linuxcnc` itself "loads motion before Task". The launcher starts Task before executing the machine HAL files that normally load `motmod`; Task's own `emctask_startup()` therefore contains retry logic for connecting to motion while the rest of startup catches up.

Classification: `SOURCE-CONFIRMED`.

### Shutdown ordering matters too

`Cleanup()` first requests display/UI shutdown, then kills remaining userspace controller processes such as `linuxcncsvr` and `milltask`, calls `halcmd stop`, unloads HAL components, stops the realtime backend, and removes NML shared-memory segments described by the NML file. The startup and shutdown paths therefore distinguish userspace processes, HAL components, RTAPI/realtime infrastructure, and NML shared memory rather than treating them as one subsystem.

Classification: `SOURCE-CONFIRMED`.

## `milltask` is a concrete executable built around `emctaskmain.cc`

`src/emc/task/Submakefile` defines `MILLTASKSRCS` including:

- `emc/task/emctaskmain.cc`
- `emc/task/emctask.cc`
- `emc/task/emccanon.cc`
- `emc/task/taskintf.cc`
- `emc/motion/usrmotintf.cc`
- `emc/task/taskclass.cc`
- supporting motion/global/tool/plugin sources

and links those objects into `../bin/milltask`.

This source-to-binary mapping is important for interpreting `iocontrol.0`: code in `taskclass.cc` is not evidence of a separate runtime executable merely because its historical file header describes an I/O interface. It is linked directly into `milltask` at this revision.

Classification: `SOURCE-CONFIRMED`.

## Function guide — `main()` and `emctask_startup()`

### `main()`

- Source: `src/emc/task/emctaskmain.cc`
- Purpose: process entry point and non-realtime Task cyclic coordinator.
- Startup calls of architectural importance: argument/INI load → allocate `EMC_STAT` → `emcTaskOnce()` → `emctask_startup()` → initial motion abort/estop/disable/unhome/mode setup → enter cyclic Task loop.
- Main-loop boundary: read new UI/controller command from `emcCommandBuffer`; run `emcTaskPlan()` and `emcTaskExecute()`; refresh motion state with `emcMotionUpdate()`; apply cross-subsystem error/state logic; update Task state; write combined status through `emcStatusBuffer`; wait for configured Task timer; run Task plugin/method hook.
- Execution context: ordinary non-realtime userspace process (`milltask`).
- Failure behavior: startup failures shut down and exit; subordinate motion/I/O error status causes Task abort/synchronization paths.
- Evidence: `SOURCE-CONFIRMED`.

### `emctask_startup()`

- Source: `src/emc/task/emctaskmain.cc`
- Purpose: attach Task to external NML channels and initialize Task's I/O, motion, interpreter and Task subsystems.
- NML connection order:
  1. `RCS_CMD_CHANNEL(emcFormat, "emcCommand", "emc", emc_nmlfile)`
  2. `RCS_STAT_CHANNEL(emcFormat, "emcStatus", "emc", emc_nmlfile)`
  3. `NML(nmlErrorFormat, "emcError", "emc", emc_nmlfile)`
- Each channel is retried for up to the startup retry window; failure is explicit.
- Subsystem init order after channels/timer: `emcIoInit()` → INI HAL init → retry `emcMotionInit()` → INI HAL pins → initial `emcMotionUpdate()` → interpreter init → Task init/update.
- Timing implication: motion may not be loaded yet when Task begins because the launcher starts Task before executing HAL files; retrying `emcMotionInit()` is therefore an architectural startup synchronization mechanism, not just generic defensive coding.
- Evidence: `SOURCE-CONFIRMED`.

## UI/Task NML boundary versus Task/motion boundary

A01 must not use "NML" as a synonym for every LinuxCNC communication path.

### UI/external control ↔ Task

The launcher starts `linuxcncsvr` first specifically to own/create NML buffers. `milltask` then attaches to named `emcCommand`, `emcStatus`, and `emcError` channels. In its cycle it reads the command channel and writes aggregate `EMC_STAT` status. User interfaces such as the standard userspace interfaces connect to these NML-facing channels.

Classification: `SOURCE-CONFIRMED` for channel creation/attachment and Task's read/write use. Detailed NML internals are deferred to A03/T03.

### Task ↔ realtime motion is RTAPI shared memory, not an RCS NML channel

The concrete source path is:

```text
Task command handling / interpreter result
        |
        v
src/emc/task/taskintf.cc
  populate static emcmot_command_t
        |
        | usrmotWriteEmcmotCommand(&emcmotCommand)
        v
src/emc/motion/usrmotintf.cc
  lock emcmotStruct->command_mutex
  copy complete command struct into shared memory
  unlock
  poll shared status for matching commandNumEcho
        |
        | RTAPI shared memory block: emcmot_struct_t
        v
realtime motmod / motion command handler
```

`usrmotInit("emc2_task")` calls `rtapi_init`, opens/creates the RTAPI shared-memory block keyed by `[EMCMOT]SHMEM_KEY`, maps it, and establishes local pointers to its `command`, `status`, `internal`, `config`, and `error` members.

`usrmotWriteEmcmotCommand()` then:

1. validates the motion ID;
2. increments a userspace command sequence number;
3. checks that the mapped command area exists;
4. takes `emcmotStruct->command_mutex`, copies the whole command structure to shared memory, then releases the mutex;
5. polls `usrmotReadEmcmotStatus()` until realtime motion echoes the same `commandNum` or the configured communication timeout expires;
6. distinguishes successful acknowledgement, invalid-command response, connection error and timeout.

`usrmotReadEmcmotStatus()` copies the shared status structure and accepts a sample only when its head/tail consistency markers match; it retries bounded split reads.

This is the first concrete A01 command/status transport boundary and is a correction to the earlier provisional diagram that labeled the Task→motion arrow generically as NML.

Classification: `SOURCE-CONFIRMED`.

## `iocontrol.0` runtime role: integrated userspace HAL component inside `milltask`

At this revision, `iocontrol.0` is **not a separately launched iocontrol process**.

The evidence chain is direct:

1. `taskclass.cc` is linked into `milltask` by `MILLTASKSRCS`.
2. `main()` calls `emcTaskOnce()` before `emctask_startup()`.
3. `emcTaskOnce()` constructs `new Task(emcioStatus)` and invokes `task_methods->iocontrol_hal_init()`.
4. `Task::Task()` calls `hal_init("iocontrol.0")`, making the Task process a userspace HAL component.
5. `Task::iocontrol_hal_init()` exports `iocontrol.0.*` pins for user enable, EMC enable, coolant, tool preparation/change, tool numbers/pockets, and related handshakes, then calls `hal_ready()`.
6. Glue functions such as `emcIoInit()`, `emcIoAbort()`, coolant and tool methods dispatch to the same `task_methods` object in-process.

Architecturally, the legacy/conceptual "discrete I/O controller" is represented here by Task-owned logic exposed into HAL as `iocontrol.0`, not by another operating-system process. HAL wiring may of course connect those pins to separate realtime or userspace components/drivers.

Classification: `SOURCE-CONFIRMED` at `8bf4605...`. Do not generalize this implementation shape to old LinuxCNC releases without checking their source.

## Refined runtime architecture map

```text
                    userspace UI / external interface processes
                                  |
                    EMC command/status/error NML channels
                    (buffers created/owned by linuxcncsvr)
                                  |
                                  v
+------------------------------------------------------------------+
| milltask — non-realtime userspace Task process                   |
|                                                                  |
| emctaskmain                                                      |
|   - state/mode gating                                            |
|   - RS274 interpreter sequencing                                 |
|   - interp_list pre/postconditions                               |
|   - aggregate EMC_STAT                                           |
|                                                                  |
| Task/taskclass                                                   |
|   - discrete/tool/coolant logic                                  |
|   - registers HAL component iocontrol.0                          |
+---------------+-----------------------------------+--------------+
                |                                   |
                | taskintf → usrmotintf             | HAL pins
                | RTAPI shared emcmot_struct_t      | iocontrol.0.*
                | command mutex + commandNum echo   |
                v                                   v
      realtime motion / motmod              HAL-connected components
                |
                | motion HAL pins/functions
                v
      realtime components / hardware drivers
```

Two distinct shared-memory systems are therefore visible at this level and must not be conflated:

- NML/RCS channels used at the UI/external-control ↔ Task boundary;
- RTAPI motion shared memory used by Task's `usrmotintf` ↔ realtime motion.

HAL is a third architectural interface used both by realtime motion and by the userspace `iocontrol.0` component.

## Failure-flow observations

### NML channel unavailable during Task startup

`emctask_startup()` retries command/status/error channel attachment. Exhaustion produces a specific "can't get ... buffer" error and startup failure. Because `linuxcncsvr` is deliberately launched first, failure here indicates that "process exists" and "usable NML buffer exists" are separate conditions.

### Motion not available yet

Task retries `emcMotionInit()` because motion can be loaded later by the HAL files. `usrmotInit()` itself fails if RTAPI initialization, shared-memory opening, or mapping fails. `emctask_startup()` retries the motion init until its startup timeout and then reports `can't initialize motion`.

### Motion command not acknowledged

`usrmotWriteEmcmotCommand()` does not equate "copied to shared memory" with "executed." It waits for a matching `commandNumEcho`, then checks `commandStatus`. A missing acknowledgement becomes `EMCMOT_COMM_ERROR_TIMEOUT`; an acknowledged invalid command becomes `EMCMOT_COMM_ERROR_COMMAND`.

### Integrated I/O/HAL initialization failure

If `hal_init("iocontrol.0")`, HAL memory allocation, pin export, or `hal_ready()` fails, `emcTaskOnce()`/Task startup fails. There is no separate iocontrol daemon for the launcher to restart independently in this architecture.

## Claims ledger

| Claim | Class | Scope | Evidence / verification |
|---|---|---|---|
| `linuxcnc` is the top-level launcher/orchestrator, not motion itself | SOURCE-CONFIRMED | dev `8bf4605...` | `scripts/linuxcnc.in` |
| `linuxcncsvr` is started first because it owns/creates NML channels | SOURCE-CONFIRMED | dev `8bf4605...` | launcher comment and call order |
| Task is started before normal HAL files load machine kinematics/motmod | SOURCE-CONFIRMED | dev `8bf4605...` | launcher text order + upstream HAL configs |
| `milltask` contains `emctaskmain.cc`, `taskintf.cc`, `usrmotintf.cc`, and `taskclass.cc` | SOURCE-CONFIRMED | dev `8bf4605...` | `src/emc/task/Submakefile` |
| Task attaches `emcCommand`, `emcStatus`, `emcError` NML channels | SOURCE-CONFIRMED | dev `8bf4605...` | `emctask_startup()` |
| Task→motion commands use an RCS NML channel | CONTRADICTED | dev `8bf4605...` | actual path is `taskintf` → `usrmotWriteEmcmotCommand` → RTAPI shared `emcmot_struct_t` |
| Motion command write waits for realtime acknowledgement | SOURCE-CONFIRMED | dev `8bf4605...` | `commandNum` / `commandNumEcho` + timeout in `usrmotWriteEmcmotCommand()` |
| `iocontrol.0` is a standalone OS process at this revision | CONTRADICTED | dev `8bf4605...` | `Task::Task()` calls `hal_init("iocontrol.0")`; taskclass linked into milltask; launcher does not start iocontrol |
| `iocontrol.0` exposes tool/coolant/enable handshakes through HAL | SOURCE-CONFIRMED | dev `8bf4605...` | `Task::iocontrol_hal_init()` |
| Any defined NML message is executable in any machine state | CONTRADICTED / false premise | current Task design | command/state gating in `emctaskmain.cc`; deeper A03 trace pending |
| A GitHub Actions topology observation proves realtime scheduling quality | CONTRADICTED / invalid inference | cloud lab | Phase-0 evidence boundary remains in force |

## Experiment 004 — A01 runtime topology observation

Artifact: `lab-jobs/004-a01-runtime-topology.sh`

Pinned LinuxCNC revision: `8bf4605ae81042248add031e94c77300406e0413`

Upstream configuration: `tests/linuxcncrsh/linuxcncrsh-test.ini`, a headless simulation using `linuxcncrsh`, `milltask`, `motmod`, `trivkins`, and an upstream HAL file.

### Pre-registered prediction

Once the configuration is running, the lab should observe:

- `linuxcncsvr` and `milltask` as userspace processes;
- no standalone executable/process named `iocontrol`;
- `iocontrol.0` in the HAL component inventory;
- `motmod` and `trivkins` in the HAL component inventory;
- a populated HAL function inventory consistent with the simulation configuration.

The job captures `ps`, `halcmd list comp`, and `halcmd list funct` and fails if the key topology assertions are not observed.

### Evidence boundary

Even if the experiment passes, it confirms only observable software topology on the uspace GitHub runner. It is not evidence of `SCHED_FIFO`, realtime latency, hardware timing suitability, or functional safety.

### Current execution state

Workflow run `33957356410` was triggered by the lab-job commit and was still in progress at the source-document checkpoint. The next session must inspect the committed result rather than assume the prediction passed.

## Architecture traps

1. **Defined message ≠ accepted command.** State/mode gating in Task can reject commands even when an NML message type exists.
2. **NML ≠ every IPC path.** UI↔Task NML and Task↔motion RTAPI shared memory are distinct mechanisms.
3. **HAL component ≠ OS process.** `iocontrol.0` is the clearest A01 example: a named HAL component registered by code executing inside `milltask`.
4. **Launcher order ≠ final component dependency order.** Task starts before HAL files load motion and therefore retries its motion attachment.
5. **Realtime name ≠ realtime qualification.** Phase 0 demonstrated that the cloud lab can execute LinuxCNC realtime code paths in POSIX non-realtime fallback.
6. **Build directory ≠ runtime process.** Runtime boundaries must come from executable linkage, launcher/source entry points and observation.
7. **Status visibility ≠ semantic identity.** A public motion/status field may not preserve an exact authored G-code boundary through interpretation and planning.

## Next exact checkpoint

1. Inspect workflow run `33957356410` and `lab-results/LATEST.md`; reconcile every 004 prediction with observed process/HAL output. If it fails, preserve and diagnose the exact topology/startup assumption that failed before changing the experiment.
2. On a passing topology result, promote the corresponding process/component claims to `TEST-CONFIRMED` in addition to source confirmation.
3. Trace the realtime receiving side of the `emcmot_struct_t.command` path only far enough to establish the opposite endpoint and command acknowledgement; defer full servo-period execution to M03.
4. Create the A01 adversarial exam covering: launcher-vs-runtime distinction, NML-vs-RTAPI shared memory, integrated `iocontrol.0`, startup race/retry behavior, and a misleading "all LinuxCNC IPC is NML" premise.
5. Run corrections and a fresh-AI handoff. Do not unblock R01 until A01 can reproduce the runtime topology and survive the adversarial/handoff checks.
