# A01 — Verifying `iocontrol.0` process ownership

LinuxCNC revision studied: `8bf4605ae81042248add031e94c77300406e0413`.

## Question

The A01 runtime prediction says `iocontrol.0` is not a standalone userspace process at this revision; it is a userspace HAL component created inside Task (`milltask`). The existing `004` assertions only proved the weaker conjunction “`iocontrol.0` exists, `milltask` exists, and there is no process named `iocontrol`.” That does **not** establish component ownership.

## Source trace

### Task creates the component

`src/emc/task/taskclass.cc` defines `IOC0` as `"iocontrol.0"`. `Task::Task()` executes:

```cpp
comp_id = hal_init(IOC0);
```

`emcTaskOnce()` constructs `Task`, validates `comp_id`, and then calls `Task::iocontrol_hal_init()`, which exports the `iocontrol.0.*` pins and finally calls `hal_ready(comp_id)`.

Classification: **SOURCE-CONFIRMED**.

### Userspace `hal_init()` records the caller PID

`src/hal/hal_lib.c::hal_init()` creates the shared `hal_comp_t`. In the ULAPI/userspace build path it sets:

```c
comp->type = HAL_COMP_TYPE_USER;
comp->pid = getpid();
```

Therefore the PID recorded on the `iocontrol.0` HAL component is the PID of the process executing `Task::Task()` and `hal_init(IOC0)`.

Classification: **SOURCE-CONFIRMED**.

### `halcmd show comp` exposes that PID

`src/hal/utils/halcmd_commands.cc::print_comp_info_cb()` prints each userspace component as component ID, type, name, PID, and state. `print_comp_info()` labels the columns `ID`, `Type`, `Name`, `PID`, and `State` and obtains the records through `hal_list_comp()`.

The upstream HAL tutorial also demonstrates `halcmd show comp` with a userspace component PID column.

Classification: **SOURCE-CONFIRMED**, with official documentation/example corroboration.

## Experiment correction

A valid A01 topology observation should therefore do more than check that `iocontrol.0` exists. Once HAL readiness is established without a force-killed HAL participant, `004` should:

1. require exactly one live `milltask` PID;
2. run a bounded `halcmd show comp iocontrol.0`;
3. parse the exact `iocontrol.0` row and require its type to be `User`;
4. extract its recorded PID;
5. require the recorded HAL component PID to equal the live `milltask` PID;
6. still verify that no standalone process named `iocontrol` exists.

If the bounded `show comp` probe stalls and must be force-killed, no ownership assertion is valid for that HAL instance; the existing terminal-evidence rule applies.

## Evidence upgrade boundary

If the corrected experiment passes, the statement “at revision `8bf4605a...`, the tested `linuxcncrsh` simulation registers `iocontrol.0` as a userspace HAL component whose recorded PID is the live `milltask` PID” may be classified **TEST-CONFIRMED** in addition to the existing source evidence.

The experiment still does not establish behavior for other LinuxCNC revisions or prove that every configuration has identical userspace topology.

## Adversarial check

Misleading premise: “Because no executable named `iocontrol` appears in `ps`, `iocontrol.0` must be owned by `milltask`.”

Correction: process absence alone cannot prove ownership. The ownership link comes from `Task::Task() -> hal_init("iocontrol.0")`, userspace `hal_init()` storing `getpid()`, and a runtime comparison of `halcmd show comp iocontrol.0`'s PID to the live `milltask` PID.
