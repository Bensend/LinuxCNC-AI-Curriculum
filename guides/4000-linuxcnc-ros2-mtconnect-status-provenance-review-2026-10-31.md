# Read-only LinuxCNC → ROS 2 / MTConnect status provenance walkthrough (source-based, no product build)

**Scope:** Practical 4000-series integration research only. [TELEM-86 audit](../research/4400_LINUXCNC_TELEM_86_MTCONNECT_ACTUAL_SPINDLE_AND_POLL_FRESHNESS_SOURCE_AUDIT_2026-10-31.md) is the primary evidence. LinuxCNC development commit `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`; stable v2.9.10 lacks the inspected MTConnect Python source path. All behavior below is **unexecuted design**, not a working ROS 2 integration.

## Inspect first
Read [Python interface docs](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/docs/src/config/python-interface.adoc), [native MTConnect LcncSource](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/lcnc_source.py#L75-L157), [MTConnect observation definitions](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/observations.py#L123-L130), and [agent poll timestamp](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/lib/python/mtc/agent.py#L82-L94).

## Minimal read-only conceptual loop
```python
# PSEUDOCODE ONLY: not an installed ROS node or executable LinuxCNC test.
s = linuxcnc.stat()
last_heartbeat = None
last_change_monotonic = None
while bridge_running:
    try:
        s.poll()                     # can raise if no running task
        now = monotonic()
        hb = s.heartbeat             # servo-cycle counter, not packet timestamp
        if last_heartbeat is None or hb != last_heartbeat:
            last_heartbeat = hb
            last_change_monotonic = now
        stale = (now - last_change_monotonic) > configured_heartbeat_age_limit
        sp = s.spindle[0]
        snapshot = {
            "poll_received_at": now,
            "heartbeat": hb,
            "validity": "STALE" if stale else "POLL_OK_HEARTBEAT_ADVANCING",
            "spindle_status_speed_rpm": sp["speed"],
            "spindle_override": sp["override"] if sp["override_enabled"] else 1.0,
            "spindle_measured_speed_rpm": None,  # absent tachometer
        }
    except Exception:
        snapshot = {"validity": "DISCONNECTED", "spindle_measured_speed_rpm": None}
    publish_read_only(snapshot)       # ROS 2 topic / MTConnect observer, no command
```

This illustrates a **necessary but not sufficient** freshness check. Counter rollover, legitimate controller shutdown, task heartbeat semantics, multiple spindles, polling races and machine-specific status validity still require an explicit policy. The bridge clock is not a synchronized FPGA timestamp. The sample age limit must be justified from the configured servo period and consumer purpose; do not copy an arbitrary timeout.

## Reproducible minimal offline reasoning fixtures (not executed)
| Scenario | Frozen fake status | Required interpretation |
|---|---|---|
| R1 | `speed=1000`, override=0.8, override enabled, no tachometer | computed status/override may be 800; measured RPM remains **UNAVAILABLE** |
| R2 | Same status with override disabled | command/status 1000; measured RPM still **UNAVAILABLE** |
| R3 | Successful polls with unchanged heartbeat beyond chosen age limit | stale/not validated, even with new bridge timestamps |
| R4 | Poll raises | disconnected and no asserted healthy/actual speed |
| R5 | Two spindle dictionaries | do not silently label spindle-0 data as spindle-1 |
| R6 | G96 maximum-speed status | do not interpret maximum RPM as tachometer measurement |

A future isolated unit test may inject a fake Python status object and assert R1–R6. **All NOT RUN.** If ROS 2 publication is ever added, document exact message type, QoS, unit/frame conventions, rate, timestamp source, bridge permissions and reconnection behavior before use. No compulsory ROS 2 package, command bridge, or safety controller is requested.

## Machine integration boundary
External dashboards and ROS 2 subscribers may aid diagnostics and planning but cannot replace LinuxCNC motion authority, drive feedback, independent personnel-safety logic, or qualified hardware verification. Any command-side bridge would be a separate, reviewed architecture decision. Do not publish false measured feedback to a controller.

**Checkpoint:** [watchdog/telemetry next](../checkpoints/20261031T234000Z-4000-linuxcnc-hm2-watchdog-recovery-next.md).

## Inspectable reference fixture
[Pure Python source-semantics reference](../examples/4000_linuxcnc_mtconnect_spindle_semantics_reference.py) contains five standard-library `unittest` cases: enabled/disabled override, frozen/advancing heartbeat, and disconnect. **Written but NOT RUN.** It does not import LinuxCNC or ROS 2; a passing future test verifies the model contract, **not** a running spindle or actual MTConnect stream.
