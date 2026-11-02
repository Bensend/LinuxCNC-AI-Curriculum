# HALCMD-149 — loadusr -W readiness, child PID, component name and unbounded wait

**2026-11-02 | 4000 core LinuxCNC implementation; 3100/3400 GUI/panel and userspace HAL integration | NON-GRADUATED | source-only.**

## Selection and novelty

Following [ECAT-EL7041-146/147/148](4400_LINUXCNC_ECAT_EL7041_148_FAULT_RESET_GATE_AND_STICKY_RESET_SOURCE_AUDIT_2026-11-02.md), rotated from device-specific EtherCAT into **core LinuxCNC HAL startup**. Full historical PROGRESS, lesson/lab ledgers and repository path inventory show no `loadusr -W` predecessor. HALUI-MDI-145 examines command submission/completion *after* HAL startup; this is **component registration/readiness and process-lifecycle ownership**, not another HALUI MDI investigation. No qualified isolated compute established.

## Pinned source and real configuration

Stable LinuxCNC v2.9.10 commit `86cdca76fa2a36274c432caa21952b23c267989a`: [`src/hal/utils/halcmd_commands.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/utils/halcmd_commands.cc), blob `1899082b63d49aafadeccf0ec7f0b01c66f798b5`, lines **1407–1418** (default name), **1465–1614** (`loadusr`); [`halcmd.c`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/utils/halcmd.c), blob `c2d82b292ad27888e3678393f2bedfffd1a1ee65`, lines **191–235** (fork/exec/reconnect); [`docs/man/man1/halcmd.1`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/docs/man/man1/halcmd.1) lines 128–142 (`-W`, `-Wn`, `-w`, `-i`, `waitusr`). Development commit `06864e23559e70463fc7112d5ce77138bcbc288c` [`halcmd_commands.cc`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/utils/halcmd_commands.cc), blob `35241919828ea35055a56278785aba0f1886dd3a`, retains the same wait loop but replaces stable's mutex-protected `halpr_find_comp_by_name` with `hal_comp_by_name` query API. This is an implementation difference, **not** evidence of different runtime outcome.

Actual upstream simulation: [`configs/sim/axis/halui_pyvcp/pyvcp.hal`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/halui_pyvcp/pyvcp.hal) starts with `loadusr -W pyvcp -c pyvcp vcp.xml`, then connects `pyvcp.*` pins to `halui.*`. [`halui.ini`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/halui_pyvcp/halui.ini) loads `pyvcp.hal` and enables HALUI. This is a shipped sim example, **not** evidence of a deployed machine. Existing upstream [`tests/halrun-getopt-reset/test.hal`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/tests/halrun-getopt-reset/test.hal) tests `loadusr -w true` then `loadusr true`; it does **not** test `-W` ready/name/timeout behavior. Inspected, NOT RUN.

## Exact control flow

1. Parse `+wWin:`: `-w` waits for process exit, `-W` waits for HAL component `ready`, `-n NAME` overrides the expected component name, `-i` ignores nonzero exit **only with -w**. Default expected name is executable basename without final extension.
2. Snapshot existing component names, build argv, call `hal_systemv_nowait`: parent disconnects from HAL shared memory, forks, child `execvp`, parent reconnects and calls `hal_ready(comp_id)` for **halcmd itself**.
3. With `-W`, poll every nominal 10 ms: first `waitpid(child_pid, ..., WNOHANG)` to see if child exited; then search for a component **by name** and check its `ready` bit. After 200 polls (~2 s nominal), print periodic waiting diagnostics; **there is no timeout/maximum-poll exit condition**. Exit when ready or child exits.
4. If ready, return success (unless `-w` also requested, which separately waits for process termination); without `-w`, success says **component registration ready at the sampled instant**, not command completion, health, future liveness, pin semantics or machine readiness.

## Distinct failure/ambiguity boundaries

- **Name mismatch:** if program creates a component named `my_panel` but `loadusr -W panel` expects `panel`, a live process can leave HAL startup waiting indefinitely. `loadusr -Wn my_panel panel` names the intended component explicitly; external bounded timeout is necessary for a negative test.
- **No child identity correlation:** stable code checks `comp && comp->ready` and development checks `!rv && q.comp.ready`; neither compares that component's PID/identity to the newly spawned `pid`. A *preexisting* ready component with the requested name could satisfy `-W` while the newly launched child is still alive, before its eventual failure. The source does not prove that duplicate component names are accepted or that this race occurs in a real installation; **conditional hypothesis** only.
- **Readiness is not continuous:** after `-W` returns, the process may later exit or lose its upstream device. The function does not establish an ongoing health/freshness contract.
- **Fork failure corner:** `hal_systemv_nowait` returns -1 on fork failure; `do_loadusr_cmd` does not explicitly check negative PID before entering the wait path. With `-W`, `waitpid(-1,...)` semantics and status handling need a separate bounded test. Do not conflate this source concern with observed startup failure.

## Python HAL implementation witness and retained fixture

Pinned stable [`src/hal/halmodule.cc`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/halmodule.cc), blob `b37a3c940705f8c4df0a7cf03b4d1a8470c91bdc`, lines 181–207 (`hal.component(name)` calls `hal_init`), 456–479 (`ready()` calls `hal_ready`; `exit()` calls `hal_exit`) and 541–560 (Python methods) confirms the exact userspace readiness producer. A [minimal, unexecuted Python fixture](../examples/4000_halcmd_149/hal_ready_fixture.py) and [bounded A–D run card](../examples/4000_halcmd_149/README.md) now preserve the actual call sequence without requiring a physical machine. They are **NOT RUN**, not test evidence.

## Reproducible software-only acceptance matrix

| Case | Test component behavior | Expected source-level observation |
|---|---|---|
| A | Register requested name, call `hal_ready`, stay alive | `-W` returns success after observing ready |
| B | Register different name, stay alive | `-W` does not complete on name mismatch; **external** timeout terminates test |
| C | Exit nonzero before registering ready | `-W` returns failure, not ready |
| D | Register/ready then later exit | `-W` can already have returned success; no health guarantee |
| E | `-w` process exits nonzero | returns failure unless `-i` supplied |
| F | Existing same-name ready component, new child alive but not ready | check whether existing component satisfies name-only gate; conditional, must not assume duplicates allowed |
| G | Simulate fork failure | record PID/error handling without launching any machine |

Freeze raw `halcmd` return, process PID, component name/PID/ready snapshots and timestamps. Use a **qualified, physically disconnected** runner only, with an external per-case timeout for B/F/G. No hosted Actions, no execution this session.

## Practical engineering consequence

For mills/routers/press-brake HMI integration, `loadusr -W` is a startup **HAL registration barrier**, not proof of a connected PLC, valid position, responsive panel, successful MDI transaction or independent safety authority. Couple it to explicit process supervision, data freshness, device-specific ready/fault feedback and machine-state gates at their own layers; do not infer physical safety from HAL startup. **SOURCE/DOC-CONFIRMED** loop/name/options and real sim use; **INFERENCE** conditional PID/name race and future failure; **TEST-CONFIRMED none**. No builds/HAL/GUI/machine/evaluator/Actions; hosted/self-hosted 0/0 min.

[Practical guide](../guides/3100-3400-4000-linuxcnc-loadusr-w-component-readiness-commissioning-2026-11-02.md) · [Checkpoint](../checkpoints/20261102T0446Z-4000-linuxcnc-hal-loadusr-next.md).
