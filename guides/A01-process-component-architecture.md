# A01 — LinuxCNC Process / Component Architecture

Status: RESEARCH

Primary development revision: `8bf4605ae81042248add031e94c77300406e0413`

Stable comparison baseline: `v2.9.10` → `86cdca76fa2a36274c432caa21952b23c267989a`

## Learning objective

A fresh AI engineer must be able to distinguish LinuxCNC's runtime processes, realtime modules/components, userspace control layers, HAL, interpreter, GUI, and NML/shared-memory boundaries; locate their source entry points; and trace who starts whom and which execution contexts exchange commands/status.

This guide is intentionally a runtime architecture map, not a repetition of L02's build-directory map.

## Official documentation pass — initial findings

The current LinuxCNC Code Notes describe the coarse architecture as a task-level command handler/interpreter coordinating a motion controller and discrete-I/O controller, with multiple user interfaces. They describe the motion controller as realtime, receiving commands from non-realtime Task/interpreter/GUI code, with communication across the realtime boundary through message-passing shared memory and HAL.

Official current developer documentation also identifies `milltask` as the non-realtime task controller and documents `motion`/`motmod` as the realtime motion component accepting NML motion commands and interacting with HAL.

References:

- https://linuxcnc.org/docs/html/code/code-notes.html
- https://linuxcnc.org/docs/devel/html/en/man/man1/milltask.1.html
- https://linuxcnc.org/docs/devel/html/en/man/man9/axis.9.html

Evidence class: `DOC-CONFIRMED`, current documentation as inspected 2026-09-05. Source-level process boundaries still require exact-revision confirmation below.

## Community/developer investigation leads

Forum discussions provide useful architecture traps rather than authoritative answers:

- a 2023 GUI/NML discussion treats a GUI as a separate process communicating through LinuxCNC's NML interface and asks how directly a custom UI may participate;
- a 2023 NML command-path investigation shows that the existence of an NML message type does not prove Task will accept it in every machine state/mode; the actual `emctaskmain.cc` command/state switches decide whether it is executable;
- a 2026 step-completion discussion highlights that public NML/status fields and realtime motion state do not necessarily preserve a one-to-one mapping back to authored G-code lines.

Investigation URLs:

- https://forum.linuxcnc.org/41-guis/47942-nml-and-gui-from-scratch
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/48855-traj-set-acceleration-not-possible-via-nml
- https://forum.linuxcnc.org/38-general-linuxcnc-questions/58953-is-there-a-public-nml-status-signal-for-completion-of-one-emc-task-plan-step

Classification: `COMMUNITY-REPORTED` leads. Each architectural claim must be checked against pinned source before promotion.

## Source inventory — first pass

| Path | Symbols / role | Context | Depth |
|---|---|---|---|
| `scripts/linuxcnc.in` | top-level launcher/config orchestration | userspace shell process | deep next |
| `src/emc/task/emctaskmain.cc` | task main loop, command/status/error NML channels, interpreter/task sequencing | non-realtime userspace | deep |
| `src/emc/motion/` | motion command interface and realtime motion implementation | realtime boundary | deep in A03/M03 |
| `src/emc/nml_intf/` | EMC NML messages/status definitions | userspace↔subsystem IPC contract | normal/deep |
| `src/emc/rs274ngc/` | interpreter implementation used by Task | non-realtime userspace | normal in A01; deep T01 |
| `src/hal/` | HAL core, components, drivers and tools | mixed realtime/userspace | normal in A01; deep H01+ |

## Source finding: launcher is orchestration, not the controller

At development commit `8bf4605...`, `scripts/linuxcnc.in` is the top-level Bash launcher. It establishes configured paths/environment, handles run-in-place setup, processes the selected INI/configuration context, and is responsible for starting the required LinuxCNC processes/modules later in the script. This makes `linuxcnc` an orchestration entry point rather than the realtime motion controller itself.

Classification: `SOURCE-CONFIRMED` for the launcher role at the pinned development revision. The exact process/module startup sequence remains the next source-reading task.

## Source finding: Task is a cyclic non-realtime coordinator

`src/emc/task/emctaskmain.cc` states its operating model directly and exposes the architecture in code:

- the Task main program cyclically calls planning and execution logic;
- planning reads a new command and decides behavior based on machine mode/state;
- in AUTO, the interpreter can append NML commands to an interpreter list;
- execution takes commands from that list, waits for preconditions such as motion/I/O completion, issues them, and waits for postconditions;
- the file includes the motion userspace interface and NML interfaces;
- it owns command, status, and error NML channel objects (`RCS_CMD_CHANNEL`, `RCS_STAT_CHANNEL`, `NML`) and a global `EMC_STAT` view.

This is stronger than the coarse documentation statement: Task is not merely a conceptual box; the pinned source shows a concrete non-realtime coordinator with NML channels, interpreter sequencing, machine-state gating, and explicit interaction with motion/I/O interfaces.

Classification: `SOURCE-CONFIRMED` at `8bf4605...`.

## First architecture map

```text
GUI / external UI processes
        |
        | command/status/error interfaces (primarily NML-facing APIs)
        v
non-realtime Task / milltask
  - machine state/mode gating
  - RS274 interpreter integration
  - command sequencing / preconditions / postconditions
        |
        | motion command/status interface across userspace↔realtime boundary
        v
realtime motion / motmod
        |
        | HAL pins/signals/functions
        v
HAL-connected realtime components / hardware drivers

Discrete I/O / iocontrol-related behavior is coordinated by Task but needs a dedicated source trace before this diagram is treated as complete.
```

This diagram is deliberately provisional. A01 must identify exact launched processes/modules and distinguish NML-backed channels from HAL interactions rather than labeling every arrow simply "NML".

## Claims ledger — initial

| Claim | Class | Scope | Verification needed |
|---|---|---|---|
| LinuxCNC has non-realtime Task coordinating motion and I/O | DOC + SOURCE-CONFIRMED | current docs + dev `8bf4605...` | stable comparison later if material |
| Motion is a realtime component interacting with HAL | DOC-CONFIRMED | current docs | source trace in A01/R01/M03 |
| `linuxcnc` is the top-level launcher/orchestrator | SOURCE-CONFIRMED | dev `8bf4605...` | trace exact launch sequence |
| Task owns command/status/error NML channel objects | SOURCE-CONFIRMED | dev `emctaskmain.cc` | trace channel creation/open and message flow |
| Any defined NML message is executable in any machine state | CONTRADICTED / false premise | community lead + Task design | source-trace representative gating branches |
| GUI-to-controller communication is exclusively direct motion access | unsupported | — | trace UI APIs/NML and HAL UI exceptions in A03/T04 |

## Failure/architecture traps already identified

1. **Defined message ≠ accepted command.** State/mode gating in Task can reject commands even when an NML message type exists.
2. **Realtime name ≠ realtime execution evidence.** Phase 0 demonstrated that software can load realtime components under POSIX non-realtime fallback in the lab.
3. **Build directory ≠ runtime process.** L02's repository map must not be converted mechanically into process boundaries.
4. **Status visibility ≠ semantic identity.** A public motion/status field may not preserve an exact authored G-code boundary through interpretation and planning.

## Next exact source-reading checkpoint

1. Continue through `scripts/linuxcnc.in` at `8bf4605...` and record the exact startup order for realtime backend, HAL, `motmod`/kinematics, Task, UI and auxiliary processes.
2. Locate the executable/main entry point that builds `milltask` from `emctaskmain.cc` and trace NML channel initialization.
3. Identify the concrete userspace↔motion command/status transport path beginning from Task's motion interface includes and calls.
4. Identify where `iocontrol`/discrete-I/O behavior is a separate process/component versus logic represented inside Task/HAL.
5. Design a bounded process-observation lab that launches a minimal simulation configuration and captures process tree plus loaded HAL components without asserting realtime timing.

Do not advance to R01 until A01 can explain the runtime component/process boundaries from source and one reproducible observation rather than documentation alone.
