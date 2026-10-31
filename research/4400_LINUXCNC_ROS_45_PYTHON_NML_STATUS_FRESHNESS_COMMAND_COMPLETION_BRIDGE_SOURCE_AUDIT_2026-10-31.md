# 4000-LC-ROS-45 — LinuxCNC Python/NML → ROS 2: status freshness and command-completion boundary

**2026-10-31 | LinuxCNC-first 4000 implementation / 3500 robotics integration | NON-GRADUATED.** This is a **source-grounded interface contract**, not a compulsory ROS 2 bridge product or a tested realtime architecture.

## Question and novelty
Can a ROS 2 adapter safely treat a successful `linuxcnc.stat().poll()` as fresh machine data and `linuxcnc.command().wait_complete()` as proof that its requested operation succeeded? Previous KINS-09/10 covered G12.1 Task/servo switching; this audit is **different**: the Python/NML API's snapshot and command-serial semantics, plus version-sensitive producer heartbeat availability. A ROS publisher's DDS liveliness is not the same thing as a fresh LinuxCNC controller status.

## Immutable LinuxCNC source and official documentation
- [Stable v2.9.10 `emcmodule.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/usr_intf/axis/extensions/emcmodule.cc), blob `6faf2b76d870387470fb38983b0a61e75032adae`: `emcWaitCommandComplete` ~210–231, `emcSendCommand` ~234–250, `Stat_init` ~258, `poll` ~288–316, `mdi` ~978–995, `wait_complete` ~1383, `Error_poll` ~1550.
- [Development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` `emcmodule.cc`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/usr_intf/axis/extensions/emcmodule.cc), blob `635726e7cd76467fb26ef0cefede7c4da4cd5efb`: `emcWaitCommandComplete` ~925–944, `poll` ~1080–1115, `Stat_heartbeat`/`Stat_taskbeat` ~1564–1577, getters ~1625–1630, `mdi` ~? (symbol), `Error_poll` (symbol).
- Official [stable Python interface](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/python-interface.adoc), blob `54d0c57b254c55fd237079676b920cb199c55226`, versus [development Python interface](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/config/python-interface.adoc), blob `f55ccb764a292f817a59f69a38d21e474864d571`.
- [ROS 2 QoS deadline/liveliness/lifespan design](https://design.ros2.org/articles/qos_deadline_liveliness_lifespan.html) (background design, not a LinuxCNC guarantee); [ROS 2 Jazzy QoS documentation](https://docs.ros.org/en/jazzy/Concepts/Intermediate/About-Quality-of-Service-Settings.html) (check installed distro/middleware support separately). The cited QoS documents describe DDS transport/application events, not controller state freshness.

## Source trace A — poll() does not report freshness
`Stat_init` creates an NML `RCS_STAT_CHANNEL` named `emcStatus`. In **both inspected versions**, `poll` checks channel validity and copies `EMC_STAT` into the Python object's stored snapshot **only if** `peek() == EMC_STAT_TYPE`; otherwise the function still returns Python `None`. There is no per-call Boolean `fresh` or timestamp return. **SOURCE-CONFIRMED:** a successful Python call is not evidence that a newer controller status was received on that call. The adapter may keep publishing the same stored state while its own ROS node remains alive.

Development exposes `stat.heartbeat` (motion servo-cycle counter) and `stat.taskbeat` (Task main-loop counter), documented and sourced from the stored `EMC_STAT`. These names were **not present in the inspected stable v2.9.10 Python getter/docs**. On development, tracking advancement of **both** counters across polls is a useful liveness discriminator. But the counters are sampled into the same Python snapshot; their advance does not independently prove every HAL/drive input was refreshed or any personnel-safety condition. On stable, this API inspection did not establish an equivalent exposed producer heartbeat, so an adapter must mark freshness UNKNOWN or obtain a separately verified producer-side witness rather than inventing one.

## Source trace B — wait_complete() can report DONE on a newer serial
`emcSendCommand` writes an NML command and stores its serial in the **Python command channel object**; it waits until the status echo serial is at least that serial or times out. Both versions' `emcWaitCommandComplete` compare `stat->echo_serial_number - s->serial`:
- if difference **>0**, immediately return DONE;
- if difference **==0** and status is DONE or ERROR, return that status;
- otherwise poll until timeout (stable returns -1; development returns UNINITIALIZED).

**SOURCE-CONFIRMED:** a later echoed command serial is treated as DONE for this command object's wait, **without rechecking the earlier command's individual result**. Under command supersession, competing clients, or Task abort/replan, this is not a transaction-specific success proof. The exact frequency and externally visible race are **UNKNOWN** and were not reproduced.

`mdi()` constructs `EMC_TASK_PLAN_EXECUTE`, calls `emcSendCommand`, then returns Python `None` without inspecting its integer return value; other Python command methods follow this pattern. Thus a successful `mdi()` Python call does not by itself establish successful send, Task acceptance, execution, or physical motion. `wait_complete()` is more informative, but its DONE value must be reconciled with the command's intended state transition, status/error channel and observed machine state.

### Task-side serial corroboration
Development [`src/emc/task/emctaskmain.cc`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emctaskmain.cc), blob `049c640f1af1b21c18161d6c065ff6f3e35fd83b`, `emcTaskPlan` treats a changed `emcCommand->serial_number` versus `emcStatus->echo_serial_number` as a new command. During Task's status publication it assigns the **current** `emcCommand->serial_number` to both `task.echo_serial_number` and top-level `echo_serial_number`, and separately computes status from current Task/motion/IO errors. This confirms the Python wait helper is observing a **latest-command echo**, not a persistent per-request result ledger. A newer echo can therefore overtake the serial being waited on without proving that earlier request's intended postcondition. The exact command-supersession schedule and errors remain untested.

## Source trace C — error channel is independent
`linuxcnc.error_channel().poll()` reads the separate `emcError` NML channel and returns a (type,message) tuple or None. The command API does not automatically include all operator errors in its completion return. A ROS service that returns success based only on `wait_complete()==RCS_DONE` can omit relevant errors. Preserve error messages and correlate them with status/command sequence; do not assert perfect one-to-one error attribution without a specific Task/NML test.

## Practical, bounded ROS 2 adapter contract (review-only)
**Recommended initial scope:** one **read-only userspace** ROS 2 status publisher, not a servo command source, motion safety controller, or hardware watchdog. Each published sample should include LinuxCNC revision, adapter monotonic receipt time, raw joint positions, machine Cartesian position, active kinematics type (where exposed), homing/task/interpreter state, status echo serial, and a `source_freshness` classification. On development also include motion heartbeat and Task taskbeat, their last-advance ages, and an explicit stale/unknown state. Do **not** stamp stale retained LinuxCNC data with a new producer timestamp merely because the ROS timer fired.

If later adding commands, serialize ownership through a single gateway, reject when status is stale/unknown, carry request ID and intended postcondition, capture the initial echo serial and error stream, and verify the **postcondition** after Task completion; do not map `wait_complete` directly to a successful ROS action result. For a robot, the active kinematics and units/fixture/tool-offset frame must be explicit; do not send joint targets through a Cartesian G-code interface by assumption. Never use ROS 2 QoS deadline/liveliness as independent personnel-safety authority.

### Minimal inspectable probe, not a ROS product
[Read-only status-heartbeat sampler](../examples/4000_linuxcnc_status_heartbeat_probe.py) uses only `linuxcnc.stat` and Python stdlib, emits JSON lines, never sends NML commands, and distinguishes stable's `UNKNOWN_NO_PRODUCER_COUNTERS` from development's two observed producer advances. It marks counter resets, independent stalls and poll errors instead of manufacturing fresh data. This source artifact is **UNTESTED** and requires the installed LinuxCNC Python module; it is deliberately not a ROS node, driver, servo loop or safety controller. Review the counters and run only in an isolated simulation if later justified.

## Version-sensitive acceptance matrix (NOT EXECUTED)
| Test | Setup | Discriminator |
|---|---|---|
| S1 | Stable v2.9.10, controller idle | `stat.poll()` returns None but is there a provably new status? No per-call freshness return in source |
| S2 | Development, controller healthy | `heartbeat` and `taskbeat` both advance across independent polls; record actual deltas |
| S3 | Development, Task stopped but servo running (isolated fixture) | Motion heartbeat may advance while Task beat stalls; classify source state stale/degraded, not healthy |
| S4 | Development, servo stopped but ROS publisher alive | ROS messages can still arrive; motion heartbeat must not advance; fail freshness |
| C1 | One command, no competing producer | Compare `mdi()` return, `wait_complete`, Task state, error channel and actual postcondition |
| C2 | Two command channels with intentionally overlapping serials, no physical I/O | Determine whether later echo triggers DONE for earlier wait despite distinct result; preserve exact serials |
| C3 | Inject NML send failure in a frozen harness | Determine whether `mdi()` Python None masks `emcSendCommand` failure; no claim until tested |

**Evidence:** SOURCE-CONFIRMED Python/NML code and development heartbeat exposure; DOC-CONFIRMED QoS and Python API; INFERENCE for ROS adapter failure manifestations; TEST-CONFIRMED none. No ROS node, LinuxCNC simulation, build, Actions workflow, physical motion, or independent evaluator was run. Only isolated `[self-hosted, openpressbrake]` may be used for any justified later runtime; no hosted Actions runner.

## Next questions
1. Inspect Task's command serial lifecycle for a realistic C2 fixture; do not infer physical outcomes from the Python helper alone.
2. Compare LinuxCNC v2.9.10 and development NML status freshness, including the producer-side heartbeat increment, before designing a ROS 2 health API.
3. If a qualified runner is available, implement **read-only** S1/S2/S4 first. A command bridge is optional, not a required product build.
