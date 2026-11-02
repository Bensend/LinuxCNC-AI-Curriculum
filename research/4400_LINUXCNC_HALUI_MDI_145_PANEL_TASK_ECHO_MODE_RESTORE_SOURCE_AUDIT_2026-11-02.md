# HALUI-MDI-145 — HAL pin → Task MDI mode, serial echo, completion and mode restoration

**2026-11-02 | LinuxCNC-first 4000 controller/UI implementation; 3100 mill, 3200 lathe, 3300 plasma, 3400 router, 3600 press-brake normal-control transfer | NON-GRADUATED | source inspection only.**

## Engineering question and predecessor boundary

A HALUI panel can expose `halui.mdi-command-NN` as a one-button operation. What exactly has happened when the button is pulsed, when the command write returns, and when a panel reports that an MDI operation is running or finished? Can the panel distinguish Task acceptance, actual interpreter execution, and completion of the particular button's operation?

This extends rather than repeats [OT-SEC-01](4400_OT_SEC_01_PINNED_LINUXCNC_HALUI_NML_COMMAND_ECHO_VS_PHYSICAL_AUTHORITY_SOURCE_TRACE_2026-10-26.md), which already establishes ordinary HALUI/NML command echo is not physical safety authority, [PEDAL-02](4400_LINUXCNC_PINNED_HALUI_PROGRAM_RUN_EDGE_VS_SAFETY_REARM_SOURCE_TRACE_2026-10-25.md), which covers rising-edge program-run semantics, and [ROS-45](4400_LINUXCNC_ROS_45_PYTHON_NML_STATUS_FRESHNESS_COMMAND_COMPLETION_BRIDGE_SOURCE_AUDIT_2026-10-31.md), which covers Python/NML status freshness. **Incremental scope here:** the complete *MDI-specific* HALUI mode-switch/restore state machine, source-version difference in `halui.halui-mdi-is-running`, actual Task MDI queue and completion conditions, and practical panel acceptance.

The current [ECAT-ENC-143/MOTION-144 checkpoint](../checkpoints/20261102T0236Z-4000-linuxcnc-ethercat-encoder-next.md) prefers qualified isolated runtime verification of the amplifier fault if available; without a positively qualified disconnected runner this is a distinct, source-accessible LinuxCNC core/UI question. No compute was dispatched.

## Immutable source inventory

- LinuxCNC **v2.9.10** (stable tag; source commit `86cdca76fa2a36274c432caa21952b23c267989a`): [`src/emc/usr_intf/halui.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/halui.cc), blob `6aa51870512c9d29919452aaec0377338e350a04`; [`src/emc/task/emctaskmain.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emctaskmain.cc), blob `7292a172023a5b42b023447c2458cb766c93fc9b`.
- LinuxCNC development **`06864e23559e70463fc7112d5ce77138bcbc288c`**: [`src/emc/usr_intf/halui.cc`](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/usr_intf/halui.cc), blob `c40e2831e737b3ff8bc4a8b9e750092b5a951379`.
- Official [v2.9.10 HALUI guide](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gui/halui.adoc), blob `318eaa86b2fab3f7203145583e1fc9e5e6e5f440`; [development guide](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/docs/src/gui/halui.adoc), blob `e9c87f8c1ae6671bab868a6aa85aa64db287ad34`.
- Real upstream **software simulation**: [`configs/sim/axis/halui_pyvcp/halui.ini`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/halui_pyvcp/halui.ini), blob `1d290fbdadb5bab31328c4001d0b71ab25026690`, and [`pyvcp.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/halui_pyvcp/pyvcp.hal), blob `f056d953fbbef8efc499f669bbad124faa70ad1a`.

These are read-only source/configuration observations; no running LinuxCNC binary, installed configuration or physical machine was inspected.

## End-to-end call and state trace

| Boundary | Stable v2.9.10 source | Effect / what is **not** proved |
| --- | --- | --- |
| INI startup | `halui.cc:1514–1516` reads up to `MDI_MAX=64` repeated `[HALUI] MDI_COMMAND` entries; `:944–945` exports `halui.mdi-command-%02d` | Pin order follows INI entry order. Pin exists only for configured command. |
| Input sampling | `check_hal_changes:2108–2111` calls `check_bit_changed` `:1591–1598`; userspace main loop `:2359–2373` nominally sleeps 20 ms | Rising-edge dispatch; an unchanged high does not resend. Sampling is userspace, **not** a guaranteed 20 ms realtime event capture. |
| Initial mode | `sendMdiCommand:1025–1057` saves `halui_old_mode` if no HALUI MDI is already outstanding; `sendMdi` `:1009–1019` sends `EMC_TASK_SET_MODE{MDI}` if needed | HALUI attempts mode change, not unconditional permission to execute. |
| Submission | `sendMdiCommand:1051–1056` writes `EMC_TASK_PLAN_EXECUTE`; `emcCommandSend:450–474` waits for `echo_serial_number >= command serial` | **Echo means Task saw a command serial, not that the command completed or succeeded.** `sendMdiCommand` returning zero is not a per-command success oracle. |
| Task authorization | `emctaskmain.cc:2204–2217` checks `all_homed() || no_force_homing` and MDI mode; `:1422–1439` can append an MDI command to `mdi_execute_queue` | A successfully echoed request may still be rejected by Task or queued behind another MDI operation. |
| Global Task status | `emctaskmain.cc:3538–3565` sets command echo serial and computes top-level `RCS_DONE` only when exec, motion and IO are DONE, MDI queue and interpreter list empty, no Task command and interpreter IDLE | Top-level DONE is a **global Task condition**, not a dedicated completion receipt for a particular `halui.mdi-command-NN`. |
| Mode restoration | `halui.cc:2133–2142` clears `halui_sent_mdi` on top-level status `RCS_DONE` and requests the saved MANUAL/MDI/AUTO mode | HALUI restores the **previous mode**, not necessarily MANUAL. A status ERROR is not handled by this DONE branch; recovery behavior requires runtime observation. |

**Version delta:** Development `halui.cc:834–877` sets `halui_sent_mdi=1` and publishes `halui.halui-mdi-is-running=TRUE` at `:849–853` **before** attempting `sendMdi()` and before submitting the MDI command. Development `:1909–1946` determines completion using the same **global** `RCS_STATUS::DONE`, restores the saved mode, then clears the HALUI running pin. Stable v2.9.10 sets `halui_sent_mdi=1` only **after** the MDI request has been echoed (`:1052–1056`) and does not export this new running pin in the inspected file. Thus the development pin explicitly includes mode-switch/request time; it is **not** proof of Task acceptance or actual motion. The development guide also says it is active during mode switching, consistent with source.

**Documentation nuance:** The development HALUI pin reference describes successful MDI command handling as returning to *Manual* mode, but source `:1915–1919` explicitly restores the recorded prior **MANUAL, AUTO or MDI** mode. The guide's sentence is an oversimplification for non-MANUAL origins; actual success/restore under concurrent GUIs remains NOT RUN.

## Concrete simulation and failure boundaries

The shipped `halui_pyvcp/halui.ini` configures `MDI_COMMAND = G0 G53 Z0` and `MDI_COMMAND = G28`. Its `pyvcp.hal` wires `pyvcp.quillup` to `halui.mdi-command-00` and `pyvcp.referencepos` to `halui.mdi-command-01`. This is **configuration evidence** of real pin/INI wiring, not proof the buttons execute on a machine. Both commands are motion commands: for disconnected acceptance, replace them **in a temporary copy of the simulation config** with `G4 P0.5` and `G4 P0.1`, and keep all physical outputs disconnected.

The high-value negative case is an MDI pulse while AUTO is actively executing. Task refuses a mode change out of non-idle AUTO (`emctaskmain.cc:2125–2131`); `emcCommandSend` may nevertheless observe the mode-request serial echo. HALUI then explicitly checks whether the status mode actually changed (`halui.cc:1042–1049` stable; `:862–869` development). **Conditional inference:** the panel's button pulse can be consumed without its MDI operation ever being executed; in development the running pin can briefly or persistently indicate an attempted operation even when mode switching failed. Exact status transitions and recovery require execution.

A second failure case is an unhomed controller with force-homing enabled. Task rejects the MDI execute request at `emctaskmain.cc:2208–2211`, even for a non-motion `G4`; HALUI's echo-based send return cannot be used to assert that the dwell ran. Again, the actual GUI/error timing is NOT RUN.

A third case is two rising MDI pins in the same HALUI polling iteration: the `for(n=0;n<num_mdi_commands;n++)` loop submits them in increasing index order, but Task may queue them, and the HALUI completion flag is **shared**, not per-pin. The source does not establish a transaction-ID/result pin per button. Avoid assuming the two buttons completed separately or in the same poll.

## Evidence ledger and correction boundary

| Claim | Evidence | Scope | Status |
| --- | --- | --- | --- |
| MDI pins are rising-edge sampled and mapped by INI order | HALUI source and official guide | v2.9.10 + inspected development | **SOURCE/DOC-CONFIRMED** |
| HALUI send returns after serial echo, not MDI execution | HALUI source + Task issue/queue/status source | v2.9.10, dev HALUI send path | **SOURCE-CONFIRMED** |
| Development running pin asserts before mode request | Development HALUI source and guide | pinned development only | **SOURCE/DOC-CONFIRMED** |
| Prior mode restored on top-level DONE | Both HALUI sources | both pinned versions | **SOURCE-CONFIRMED** |
| AUTO-active / unhomed negative-case button outcomes | Task guards plus HALUI code | conditional | **INFERENCE / NOT RUN** |
| Any actual machine movement, panel pulse capture rate, mode-race outcome | No execution/physical witness | installation-specific | **UNKNOWN** |

No new runtime tests, independent evaluation or Actions compute. Existing historical HALUI/NML and Python status work remains credited; no new graduation or safety release is claimed. Ordinary HALUI panel requests are not independent personnel-safety authority, and OpenPressBrake G0/G1 remain HOLD.

**Next:** [practical acceptance walkthrough](../guides/3100-3400-4000-linuxcnc-halui-mdi-panel-transaction-commissioning-2026-11-02.md) and [precise checkpoint](../checkpoints/20261102T0332Z-4000-linuxcnc-halui-mdi-next.md).
