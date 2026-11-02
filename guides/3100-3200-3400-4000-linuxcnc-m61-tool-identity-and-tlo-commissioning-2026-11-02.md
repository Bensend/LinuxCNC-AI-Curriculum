# M61 commissioning: identity is not physical tool, pocket, or applied G43 (3100/3200/3400/4000)

**2026-11-02 | 4000-LC-M61-165 | NON-GRADUATED | all checks below NOT RUN.** Intended for a **physically disconnected** LinuxCNC simulation, never an installed spindle, turret, automatic changer, press brake or live toolsetter. This is a source/test-oracle walkthrough, not machine release. See [source audit](../research/4400_LINUXCNC_M61_165_TOOL_IDENTITY_POCKET_TLO_Q_ROUNDING_SOURCE_TEST_AUDIT_2026-11-02.md).

## Start with upstream, not a bespoke controller

Use pinned LinuxCNC v2.9.10 commit `86cdca76fa2a36274c432caa21952b23c267989a` and inspect `tests/toolchanger/m61/{test.sh,m61-test.ini,test-ui.py,mod_core_sim.hal,postgui.hal}` plus `tests/toolchanger/simpockets.tbl.original`. Its fixture copies a disposable table, uses a simulated trivkins/servo loopback, starts a Python UI, and manually drives the simulated `tool-prepared` and `tool-changed` inputs. **The test source is upstream; its execution and pass/fail are not claimed here.** A qualified, isolated runner with LinuxCNC built and test environment configured may execute upstream `tests/toolchanger/m61/test.sh` from its expected working directory; preserve revision, actual stdout/stderr, exit, IO/Task status and run duration.

Do not use the curriculum's historical hosted workflow, touch automatic lab triggers or dispatch a local panel-PC job without independently demonstrated physical I/O isolation and a frozen oracle. The priority isolated MOTION-144 test remains ahead of this optional extension.

## Snapshot protocol

Before each MDI command, capture `linuxcnc.stat().tool_in_spindle`, `iocontrol.0.tool-number`, `iocontrol.0.tool-from-pocket` **if that pin exists**, `iocontrol.0.tool-prepare/tool-change`, `#5400`, `#5403`, `#5422`, active G43 mode, current `linuxcnc.stat().tool_offset`, `[RS274NGC]RETAIN_G43`, `[EMCIO]RANDOM_TOOLCHANGER`, and the tool table (hash and content). After a command completes, poll and capture the same snapshot. `wait_complete` is an NML/Task completion observation, **not** a physical clamp/retention witness. `#5422` is a coordinate observable, not an independent tool-length measurement.

Capture `#5400/#5403/#5422` through MDI debug expressions as upstream `test-ui.py` does; do not assume a GUI's preview uses live Task data. Observe HAL signals using `halcmd show pin` in the disconnected sim. If a pin is absent (notably alternate IO components), mark **NOT EXPOSED**, not zero.

## Predeclared A–J oracles

| Case | Disconnected sequence / setup | Prediction and discriminator |
|---|---|---|
| A | Nonrandom stock upstream T1 M6, simulate prepare/change ACK, then G43 | T1 identity, last pocket 1, `#5403=1`, `#5422=-1` inch in upstream fixture |
| B | A then M61 Q10, RETAIN_G43=0 | identity 10, no new prepare/change, last pocket remains **1** despite T10 P3; `#5403=3`, `#5422=-1` |
| C | B then explicit G43 | `#5422=-3`; identity remains 10 |
| D | M61 Q0 after B/C | identity 0 and stock `tool-from-pocket=0`; record G43 state independently |
| E | M61 Q-0.4 with existing T0, default rounding | **Source predicts acceptance as Q0** despite docs saying negative Q is an error; must be tested, not asserted as measured |
| F | M61 Q-0.6 | Source predicts negative rounded value and interpreter rejection |
| G | Add T2 to disposable table, then M61 Q1.6 | Source predicts rounded T2 identity rather than integer-format rejection; a missing T2 would test lookup failure instead |
| H | RETAIN_G43=1, G43 active, selected_pocket>0, then M61 Q10 | Source's opt-in branch may automatically reapply offset; snapshot before/after and distinguish from default B |
| I | RETAIN_G43=1 with selected_pocket=0 or G43 inactive | Record whether G49/no reapply branch occurs; do not generalize H |
| J | Random changer with disposable tooldata/DB_PROGRAM | Inspect spindle/pocket internal swap and `l/u` notifications separately from **no physical changer handshake**; never use real changer |

A–D are covered in part by existing upstream test source; E–J are **proposed additions**, not executed. Cases E/G are also candidates for a review-only validation fix; run original and patched versions in isolated builds before proposing upstream changes. Distinguish parser rejection, missing-tool lookup, command timeout, and toolchanger handshake failure.

## Practical machine integration rules

For 3100 mills and 3400 routers, an HMI restart-recovery action labeled “tool installed” may issue M61 only **after** an independent operator/fixture confirmation of actual tool identity and retention. Then verify/explicitly apply the intended G43 state, and check machine coordinates before any movement. For 3200 lathes, tool number and turret indexed/locked state are separate signals; M61 must not be used as a turret motion command. For tool databases, M61 can emit `l/u` bookkeeping messages without physical movement, and a DB reply is not a physical witness. For 3600 press-brake transfer, this is only a caution about normal-control/tool identity, not a tooling-authorization or safety design.

Do not wire `iocontrol.0.tool-number`, `tool-from-pocket`, `linuxcnc.stat().tool_in_spindle`, or a successful MDI return as the sole condition for any hazardous motion or independent personnel-safety final element. Preserve independent safety authority, and OpenPressBrake G0/G1 HOLD.

## Evidence acceptance

Pass a case only with pinned source/config/tool table, full ordered MDI and Task logs, expected-versus-actual HAL/status/parameter snapshots, LinuxCNC exit status, and isolation witness. A single value changing is insufficient. A missing pin, remapped M61, custom IO implementation, or RETAIN_G43 enabled invalidates the stock upstream oracle unless separately accounted for. Record actual self-hosted job start/end in LAB_COMPUTE_LOG only after an authoritative execution. No hosted fallback.

## K — QtVCP restart-tool GUI handoff (source-only, NOT RUN)

The upstream stable QtLathe **test screen** `share/qtvcp/screens/qtlathe/qtlathe_handler.py` contains a first-homed reload method that **would** call `M61 Qn` alone, but the inspected QtLathe handler does **not** connect that method to the `all-homed` Status signal. Its **manual tool-selection button is wired** in `qtlathe.ui` to call M61 alone. Stable QtDragon and development QtDragon Lathe issue `M61 Qn G43` on comparable paths. Therefore **do not infer tool-length reapplication from a GUI's “Reload Tool” label**. Inspect the actual handler, `[RS274NGC]RETAIN_G43`, active G43 state, remap configuration and tool table. Capture a before/after `linuxcnc.stat().tool_offset` and coordinate snapshot in an isolated simulation.

The inspected stable/development QtLathe handler files also *use* `self.first_turnon`, `self.reload_tool`, and `self.last_loaded_program` without **file-local initialization**, unlike QtDragon. This is a conditional source-review flag, **not** a proven runtime failure: the method is **not explicitly registered to the homing Status signal** in QtLathe, unlike QtDragon. Inspect `qtlathe.ui`'s connected slots and QtVCP `qt_makegui.py` handler registration; mere registration of a method is not a Status signal connection. Trace any alternate caller/framework injection and execute a disconnected GUI callback before asserting an exception. An absent or failed callback cannot be treated as evidence that the tool was reidentified. See research addendum 165D for pinned source.

## L — QtVCP MDI dispatch is not tool-state acceptance (NOT RUN)

Stable `qt_action.py` `CALL_MDI(code)` sends an MDI command without `wait_complete` or error-channel readback; the QtLathe manual M61 button does not check a result. Development `CALL_MDI(code, mode_return=False)` returns 1 after dispatch and optionally restores the previous mode, **still without waiting**. Do not use `mode_return=True` on stable v2.9.10's one-argument method. A source-correct GUI verification must separately observe command completion/error, `stat.tool_in_spindle`, applied `stat.tool_offset`, `#5403` and HAL status, then independently verify actual installed tool/retention where relevant. Freeze the original command, version, timing and readback; never infer completion from a click or a returned 1.
