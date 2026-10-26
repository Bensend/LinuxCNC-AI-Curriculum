# 4400 TOOL-RET-02 — Pinned LinuxCNC M6 / IOCONTROL handshake versus physical tool retention
**2026-10-26 | SOURCE-CONFIRMED at LinuxCNC `c9a5a0a5034177c8db64cb44abf14d4f2eb166f7` | No execution, no machine validation**

## Narrow question
Could `M6 complete`, `iocontrol.0.tool-changed` or a successful tool-number update be accepted as proof that a heavy press-brake punch is physically retained? **No.** The source establishes an ordinary software handshake and tool-state bookkeeping; its semantics depend on the HAL wiring, and do not independently prove clamping force, mechanical capture, gravity retention, isolation or guarding. This is a cross-machine **transfer warning**, not a claim that OpenPressBrake uses M6 or iocontrol for die changes.

## Exact pinned source / call path
1. `src/emc/task/emctaskmain.cc`, around **L2169–2171**, handles `EMC_TOOL_LOAD_TYPE` by calling `emcToolLoad()`. The task execution state also recognizes `EMC_TOOL_LOAD_TYPE` as a command requiring I/O completion around L1589–1602.
2. `src/emc/task/taskclass.cc`, `Task::emcToolLoad()`, **L508–536**: for a prepared tool, it asserts the **HAL OUT** `iocontrol.0.tool-change` at L527, and sets `emcioStatus.status = RCS_STATUS::EXEC` if the feedback did not already complete (including loopback case).
3. Same file, `Task::read_tool_inputs()`, **L635–670**: when `tool-change` **AND** `tool-changed` are true, it updates the in-spindle tool number and pocket bookkeeping (L644–661), deasserts `tool-change` (L666), sets `RCS_STATUS::DONE` (L667), and returns 11. It does **not** measure tool tang engagement, clamp force, pressure, tool mass, retained load, physical stop or independent safety chain.
4. Same file, `Task::run()`, **L673–683**, calls `read_tool_inputs()` periodically and separately samples `iocontrol.0.emc-enable-in` for ordinary E-stop status; this is not proof of a safety-rated physical safe state.
5. `lib/hallib/core_sim.hal`, **L48–50**, explicitly wires `iocontrol.0.tool-change` directly to `iocontrol.0.tool-changed` (`net tool-change-loop ...`). This official repository simulation config can therefore satisfy the software handshake with **no physical tool, clamp, spindle, press brake or independent safety device**.
6. `docs/src/man/man1/io.1.adoc`, **L37–40**, documents `tool-change` as request output and `tool-changed` as completion input; the documentation does not claim safety-rated physical retention. Official HTML documentation: https://linuxcnc.org/docs/html/config/iov2.html and https://linuxcnc.org/docs/html/gcode/m-code.html .

Pinned URLs:
- https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/task/taskclass.cc
- https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/src/emc/task/emctaskmain.cc
- https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/lib/hallib/core_sim.hal
- https://github.com/LinuxCNC/linuxcnc/blob/c9a5a0a5034177c8db64cb44abf14d4f2eb166f7/docs/src/man/man1/io.1.adoc

## Evidence classification and adversarial check
| Claim | Evidence class | Boundary |
|---|---|---|
| `EMC_TOOL_LOAD_TYPE` calls `emcToolLoad()` | SOURCE-CONFIRMED pinned | Ordinary task command path |
| `tool-change` + `tool-changed` sets software `DONE` and tool number | SOURCE-CONFIRMED pinned | No independent mechanical witness |
| Core simulation wires request to completion | SOURCE-CONFIRMED pinned configuration | Illustrates software completion without a physical machine; **not** a TEST-CONFIRMED runtime result |
| A forged/stuck `tool-changed` could report completion while tool absent | INFERENCE from pin contract and loopback example | Not an observed fault or quantified failure rate |
| OpenPressBrake uses M6 for die clamping | UNKNOWN | Do not infer from general LinuxCNC |
| Physical tool retained on power/pressure loss | UNKNOWN | Requires selected OEM and independent qualified physical evidence |

**Counterexample:** in the published `core_sim.hal` configuration the request/completion signal is the same HAL net. Even perfect command-state coherence is insufficient to demonstrate payload retention. Do not “fix” this by declaring a normal FPGA clamp bit safety-rated. Keep the independent safety function and positive physical retention/hold mechanism separate.

## Architecture integration
`G-code / M6 / Task` → `ordinary IOCONTROL request` → `external HAL/ladder implementation` → `ordinary completion input` → `Task DONE` is a **normal control chain**. In parallel, selected-machine tool-drop hazards require a **physical retention chain** (tang/capture/clamp/roll-out stops/handling supports), independent ram stop/hold and a separately engineered safety/access/restart chain. The two chains can exchange *non-authoritative status*, but normal command completion is not a physical safety witness.

## Lab decision
The exact software handshake and loopback are resolved from pinned source and config. Running a synthetic loopback lab would add no useful safety evidence and is **not justified**. A physical clamp/retainer failure study is not authorized absent qualified G0/G1 design, no-exposure plan and selected-machine witness requirements. GitHub-hosted/local compute **0**. G0/G1 HOLD, external evaluation OPEN. See [TOOL-RET-01 OEM audit](4400_TOOL_RET_01_WILA_FORCE_LOCKED_SELF_LOCKING_SAFETY_CLICK_E2M_AND_LOTO_SOURCE_AUDIT_2026-10-26.md) and [field module](../safety-course/4400_TOOL_RET_01_TOOL_RETENTION_PRESSURE_LOSS_ROLLOUT_AND_FRESH_RESTART_FIELD_MODULE_2026-10-26.md).