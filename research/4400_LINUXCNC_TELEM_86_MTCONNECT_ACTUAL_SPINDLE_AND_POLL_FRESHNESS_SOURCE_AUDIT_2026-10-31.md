# 4000-LC-TELEM-86 — LinuxCNC MTConnect ACTUAL spindle speed and freshness semantics for ROS 2 bridges (2026-10-31)

**Status:** LinuxCNC-first 4000 integration research, NON-GRADUATED. SOURCE-CONFIRMED selected development paths; DOC-CONFIRMED Python API; TEST-CONFIRMED none. This is a **distinct** integration question from Mesa Ethernet packet transport, not a new compulsory ROS product.

## Question / novelty
Can an external MTConnect or ROS 2 consumer safely interpret LinuxCNC's published `ROTARY_VELOCITY subType=ACTUAL` as a **measured spindle RPM**, and a new timestamp as proof of new controller state? Prior [WD-84](4400_LINUXCNC_HM2_WD_84_SOFT_PACKET_RECOVERY_REPLAY_ACK_SOURCE_AUDIT_2026-10-31.md) addressed Mesa recovery; this investigation addresses **telemetry semantic provenance**. The inspected MTConnect Python package exists at the pinned development revision; fetching `lib/python/mtc/lcnc_source.py` at stable v2.9.10 returned 404. Do not generalize the feature to stable.

## Exact upstream provenance
- Development LinuxCNC commit `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`:
  - [lib/python/mtc/observations.py:124–128](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/observations.py#L123-L130): `spdl_speed` is a SAMPLE `ROTARY_VELOCITY` with `subType="ACTUAL"`; `spdl_speed_cmd` is separately `COMMANDED`.
  - [lib/python/mtc/lcnc_source.py:75–110](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/lcnc_source.py#L75-L110): `available()` depends on last `stat.poll()` success and `_live`; exceptions mark offline.
  - [lib/python/mtc/lcnc_source.py:113–157](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/lcnc_source.py#L113-L157): sample construction; spindle **index 0 only**, `spdl_speed_cmd=sp["speed"]`, `spdl_speed=sp["speed"] * override` when override enabled.
  - [lib/python/mtc/agent.py:82–94](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/agent.py#L82-L94): poll, sample, stamp with `now_iso()`, ingest; timestamp created at agent poll, not a hardware encoder latch.
  - [src/emc/usr_intf/axis/extensions/emcmodule.cc:1444–1455](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/usr_intf/axis/extensions/emcmodule.cc#L1444-L1455): Python spindle dictionary `speed` and `override` map to NML motion spindle fields `speed` and `spindle_scale`, **not an independently sampled tachometer pin**.
  - [configs/sim/axis/mtconnect/test_mtc.py:280–289](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/configs/sim/axis/mtconnect/test_mtc.py#L280-L289): offline-source test checks graceful empty results; does not establish a physical spindle-speed measurement.
- [Official LinuxCNC Python API docs](https://linuxcnc.org/docs/html/config/python-interface.html), mirrored in pinned [docs/src/config/python-interface.adoc:198–200](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/config/python-interface.adoc#L198-L200), state motion `heartbeat` increments every servo cycle. [Spindle dictionary documentation:526–554](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/config/python-interface.adoc#L526-L554) defines `speed` as a status speed value and explicitly notes that under **G96** it reflects the maximum speed (D word or default), not a measured shaft-speed sample.

## Source-confirmed semantic mismatch
`observations.py` advertises `spdl_speed` as ACTUAL; `lcnc_source.sample_values` calculates it from the *same status speed value* as `spdl_speed_cmd`, multiplied by spindle override. No independent tachometer/encoder measurement is accessed by this function. A consumer treating `spdl_speed` as an actual measured RPM can therefore make an unsupported inference. In G96, the documented `speed` status field can represent a **limit**, making the distinction especially important. This is a **source-confirmed field-provenance mismatch**, not proof that a particular running MTConnect agent displays an incorrect physical RPM.

**Illustrative model-only values (NOT RUN):** if `spindle[0]["speed"]=1000`, override=0.8 and enabled, the inspected function yields `spdl_speed_cmd=1000`, `spdl_speed=800`. Both derive from NML status; neither demonstrates that a shaft tachometer measured 800 RPM. If override is disabled, the computed second value is 1000.

## Freshness and sampling boundary
`LcncSource.poll()` sets `_live=True` after a successful Python `stat.poll()`; it does not itself check that motion `heartbeat` advanced. `AgentState.poll_once()` stamps the sample at the **agent's current time**. A new agent timestamp therefore establishes an attempted sample/ingest time, not an FPGA sample time or a changed servo heartbeat. This is SOURCE-CONFIRMED in the inspected code; whether the underlying NML channel delivers stale data under a particular failure requires separate tests.

## Recommended external ROS 2/analytics mapping (design inference, not an upstream claim)
| Proposed field | Source | Meaning / prohibition |
|---|---|---|
| `spindle_speed_status_rpm` | `linuxcnc.stat().spindle[0]["speed"]` | NML spindle speed status, **not measured RPM** |
| `spindle_override` | `spindle[0]["override"]` and enabled flag | commanded override |
| `spindle_speed_measured_rpm` | independent encoder/tachometer channel with provenance | **UNAVAILABLE** absent a real independent sensor |
| `motion_heartbeat` | `stat.heartbeat` | controller progress witness, compare over time with rollover awareness |
| `poll_received_at` | bridge local clock | acquisition attempt timestamp, not motion/FPGA capture time |
| `data_validity` | explicit disconnected/stalled/fresh state | do not map successful `poll()` directly to controller healthy |
| `spindle_index` | explicitly selected spindle | native MTConnect source uses index 0 only |

For a ROS 2 `JointState` or diagnostic publisher, separately label command and feedback, machine linear/rotary units, frame, sample age, and status validity. Do not treat ROS topics, NML status or a dashboard as a personnel-safety authority. No control commands or safety actuation are proposed.

## Counterexample and minimal acceptance questions
- A G96 program with spindle max D value and no tachometer: what would ACTUAL mean? **It cannot be established from this code**.
- A polling loop continues with identical motion heartbeat but new wall-clock timestamps: should an external consumer mark it fresh? **No, not without a defined heartbeat/timing policy**.
- A dual-spindle lathe: does this native source report spindle 1? **No; the inspected loop reads `spindles[0]`**.
- The existing upstream test's offline pass: does it verify the ACTUAL value? **No**.

## Evidence limits and next step
This is static source analysis of one pinned development revision. No MTConnect server, Python module, ROS 2 node, simulation, physical machine or independent evaluator was run. A useful disconnected future test should inject fake `stat.spindle` values, G96 metadata and frozen heartbeat, then verify field names, values, units, and UNAVAILABLE handling. Source correction candidates: change ACTUAL labeling or supply actual tachometer-backed data with explicit provenance; maintainers must decide the intended MTConnect contract. See [read-only bridge design walkthrough](../guides/4000-linuxcnc-ros2-mtconnect-status-provenance-review-2026-10-31.md).
