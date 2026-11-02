# 3100/3400/4000 — Commission a HALUI MDI panel without mistaking echo for execution

**2026-11-02 | LinuxCNC v2.9.10 + pinned development source | practical disconnected implementation | NON-GRADUATED / NOT RUN.**

This is a reproducible implementation walkthrough for a mill/router operator panel, adaptable to lathe/plasma and ordinary press-brake controls. It is **not** a recommended way to implement independent protective-stop or guarded automatic restart logic. Read the [HALUI-MDI-145 source investigation](../research/4400_LINUXCNC_HALUI_MDI_145_PANEL_TASK_ECHO_MODE_RESTORE_SOURCE_AUDIT_2026-11-02.md) for version/line provenance.

## Start from an actual upstream configuration

Use a **temporary copy** of LinuxCNC v2.9.10 `configs/sim/axis/halui_pyvcp/` (upstream [INI](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/halui_pyvcp/halui.ini), [HAL](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/axis/halui_pyvcp/pyvcp.hal)). It already contains `[HAL] HALUI = halui`, two ordered `[HALUI] MDI_COMMAND` entries, and pyvcp-to-HALUI nets. Keep the rest of its simulation setup; **do not run against real stepgens, drives, torches, spindles or hydraulics**.

For a no-motion acceptance variant, replace the two MDI lines in the temporary INI with:

```ini
[HALUI]
MDI_COMMAND = G4 P0.5
MDI_COMMAND = G4 P0.1
```

The existing upstream `pyvcp.hal` nets remain:

```hal
net quill-up      pyvcp.quillup      halui.mdi-command-00
net reference-pos pyvcp.referencepos halui.mdi-command-01
```

These are **configuration fragments**, not a complete standalone INI/HAL; use the full upstream sim directory and verify its `vcp.xml` and simulation dependencies are installed. Use a deliberately qualified, physically disconnected `[self-hosted, openpressbrake]` environment for any actual execution; do not dispatch a GitHub-hosted Actions runner.

## Observe three separate boundaries

Capture an aligned timeline with (1) panel HAL input `halui.mdi-command-00/01`, (2) Task `mode`, `interpState`, `queuedMDIcommands`, `echo_serial_number`, `command_type`, top-level `status`, and (3) HALUI's saved/returned mode and, **development only**, `halui.halui-mdi-is-running`. The latter is absent from inspected stable v2.9.10. A `halcmd show pin halui.mdi` read and a userspace status poll are useful but **not servo-timestamped simultaneous samples**. For exact ordering, add a software-only Task/HALUI trace at the pinned revision and retain raw logs.

Treat each state separately:

- **Input observed:** a FALSE→TRUE sample was consumed by HALUI. A held TRUE does not generate another edge; pulses shorter than the userspace sampling interval can be missed.
- **Request echoed:** HALUI `emcCommandSend` saw `echo_serial_number >= request serial`. This is not success, execution or motion proof.
- **Operation completed:** Task's interpreter/queue/motion/IO are DONE and the operation's own expected effect or error is checked. HALUI's shared `halui_sent_mdi` / development running pin is not a per-button completion receipt.

## Discriminating disconnected cases (all NOT RUN)

| Case | Setup and action | Source-derived discriminator | What to record |
| --- | --- | --- | --- |
| A — MANUAL idle | Sim homed, MANUAL; pulse command 00 (G4 P0.5) | HALUI requests MDI, sends dwell, later restores MANUAL on global DONE | mode transitions; echo serial; actual Task dwell start/end |
| B — MDI origin | Sim homed, already MDI; pulse 00 | No mode switch; previous MDI remains MDI | mode history and completion |
| C — AUTO idle | Sim homed, AUTO interpreter IDLE; pulse 00 | HALUI may switch to MDI then restore AUTO; not always MANUAL | actual prior and restored mode |
| D — AUTO running | Run a software-only program containing `G4 P2` in AUTO; pulse 00 during active interpreter | Task denies leaving non-IDLE AUTO; command should not be treated as executed merely because mode request echoed | operator error, requested/actual mode, command serial and development running pin |
| E — unhomed | Sim not homed, force homing enabled; pulse G4 MDI | Task's `all_homed()` gate rejects even non-motion MDI | error channel and actual dwell absence |
| F — two simultaneous buttons | Homed; make both 00/01 rise within same HALUI sample | HALUI iterates by index; Task may queue; no per-button HALUI receipt | submission order, `queuedMDIcommands`, completion times |
| G — held button | Hold command 00 TRUE across several HALUI polls, then release and pulse again | One rising-edge dispatch while held, second only after release | HAL pin and Task command serial deltas |
| H — version compare | Repeat A/D on v2.9.10 and pinned development | Development `halui.halui-mdi-is-running` asserts **before** mode request; stable lacks that pin | status vs mode switch/acceptance chronology |

**Predeclared falsifiers:** A Task command executes while `all_homed()` is false and `no_force_homing` is false; development running pin remains false throughout a mode-request attempt; a held-high unchanged MDI pin generates repeated HALUI sends; a successful AUTO-origin MDI command always returns to MANUAL rather than the recorded AUTO mode. Such outcomes require a source/config/version reconciliation, not post-hoc relabeling.

## Implementation contract for an operator HMI or web UI

For a button that matters operationally, present at least **requested / accepted-or-rejected / executing / completed-or-failed / status-stale** as separate states. A source-level `halui.mdi-command-NN` pin alone does **not** provide this transaction model. For a new web UI, a supervised Task/Python/NML adapter with request IDs, explicit error-channel consumption, status freshness and machine-state checks is a more inspectable candidate than mapping a remote click directly to a raw HALUI MDI pulse. This is an **architectural recommendation**, not a validated implementation; see existing [ROS-45](../research/4400_LINUXCNC_ROS_45_PYTHON_NML_STATUS_FRESHNESS_COMMAND_COMPLETION_BRIDGE_SOURCE_AUDIT_2026-10-31.md) for Python status caveats.

On a real machine, verify machine-specific limits, homing/position trust, spindle/torch/tooling state, and independent safety authority before ever enabling such controls. HALUI's `estop`, mode and MDI pins are ordinary software control paths, not safety-rated proof. Keep OpenPressBrake G0/G1 HOLD.

## Evidence and handoff

**SOURCE/DOC-CONFIRMED:** INI order, HAL pin wiring, rising-edge sampling, NML serial echo, Task MDI guard/queue, global DONE and prior-mode restore. **INFERENCE:** exact event timelines in A–H. **UNKNOWN:** live GUI timing, status freshness, concurrent UI effects, hardware response. **TEST-CONFIRMED none.** No build, LinuxCNC session, HAL trace, simulator, machine operation or Actions job performed.

**Next checkpoint:** [HALUI-MDI-145](../checkpoints/20261102T0332Z-4000-linuxcnc-halui-mdi-next.md). Do not add more unrun UI fixtures without a new evidence path.
