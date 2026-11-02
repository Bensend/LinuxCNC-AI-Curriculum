# 3100/3400/4000 — HAL loadusr -W userspace component readiness commissioning

**2026-11-02; LinuxCNC core HAL startup, disconnected exercise; NOT RUN.** Read [HALCMD-149](../research/4400_LINUXCNC_HALCMD_149_LOADUSR_W_READY_NAME_PID_TIMEOUT_SOURCE_AUDIT_2026-11-02.md).

## Use an actual upstream simulation, not a hypothetical HAL snippet

Stable [`configs/sim/axis/halui_pyvcp/pyvcp.hal`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/halui_pyvcp/pyvcp.hal) begins with `loadusr -W pyvcp -c pyvcp vcp.xml`, then wires `pyvcp.*` pins to `halui.*`. [`halui.ini`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/configs/sim/axis/halui_pyvcp/halui.ini) declares `HALFILE = pyvcp.hal` and `HALUI = halui`. The barrier ensures a component named `pyvcp` has marked itself ready before subsequent pin connections are attempted. It does **not** ensure any operator command has executed. Preserve prior [HALUI-MDI-145](../research/4400_LINUXCNC_HALUI_MDI_145_PANEL_TASK_ECHO_MODE_RESTORE_SOURCE_AUDIT_2026-11-02.md) distinction between NML echo, Task acceptance and execution completion.

## Implementation walkthrough

1. Read stable [`do_loadusr_cmd`](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/utils/halcmd_commands.cc) and development [equivalent](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/hal/utils/halcmd_commands.cc); identify `-W` component-ready, `-w` process-exit, `-n` explicit name and `-i` exit-status ignore. Do not confuse `-Wn name` with an external process watchdog.
2. Build a **software-only** userspace HAL component that registers name `fixture`, optionally delays `hal_ready`, and optionally exits. Run only in qualified disconnected LinuxCNC/halrun with an **external timeout**; the LinuxCNC `-W` loop has no built-in timeout. Capture PID, name, `ready`, return code and elapsed wall time.
3. Freeze A–G cases from [HALCMD-149](../research/4400_LINUXCNC_HALCMD_149_LOADUSR_W_READY_NAME_PID_TIMEOUT_SOURCE_AUDIT_2026-11-02.md) before running: normal ready, mismatched name, early failure, post-ready exit, `-w` status, preexisting-name race and fork failure. Mark F/G as conditional/harness-dependent, not automatically reproducible.
4. For normal machine configuration, explicitly name nondefault components with `loadusr -Wn component-name executable ...`; ensure `loadusr` appears before `net` commands referencing its pins. After startup, use a separate heartbeat/freshness/status contract if the device must remain available.
5. For a real machine, keep independent personnel-safety authority separate from userspace HAL process health. A ready GUI does not establish drive, actuator, sensor or safety readiness.

## Evidence ledger and acceptance

Record pinned LinuxCNC commit, source blob, sim config identity, exact HAL command, component name, process ID, `halcmd` exit, HAL ready state, external timeout and raw logs. A passing `-W` case is **startup registration evidence only**. The upstream getopt-reset test is an unrelated control and was inspected, NOT RUN. No local or hosted compute was consumed in this session.

[Checkpoint](../checkpoints/20261102T0446Z-4000-linuxcnc-hal-loadusr-next.md).
