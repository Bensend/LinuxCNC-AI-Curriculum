# 4000-LC-SPINDLE-64 — M5 stop-to-next-feed and G38 probe at-speed barrier, stable versus development

**2026-10-31 | NON-GRADUATED | SOURCE-CONFIRMED static, conditional runtime INFERENCE, TEST-CONFIRMED none.** LinuxCNC-first Task → canonical → motion → TP trace. No machine operation or isolated simulation.

## Precise new question and predecessor check

Does **M5** establish a stop-complete condition before a following feed or probe, and is the behavior the same in v2.9.10 and development? This is a **version-specific command-path extension**, not a rediscovery of the general all-spindles at-speed gate in [SPINDLE-22](4400_LINUXCNC_SPINDLE_22_MULTISPINDLE_ATSPEED_INDEX_HANDSHAKE_SOURCE_AUDIT_2026-10-31.md), nor the permissive default / synthetic-ramp examples in [MON-02](4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md). Those predecessors already describe the generic optional stop barrier. The incremental contribution is the **stable/development M5 canonical default, stable/development probe-segment distinction, and the concrete upstream Woodpecker integration in [ROUTER-65](4400_LINUXCNC_ROUTER_65_WOODPECKER_FORWARD_GATED_ATSPEED_CONFIG_SOURCE_AUDIT_2026-10-31.md)**.

## Immutable primary source

| Layer | Stable v2.9.10 | Pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` |
|---|---|---|
| Canonical stop declaration | [canon.hh](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/nml_intf/canon.hh#L545) `STOP_SPINDLE_TURNING(int spindle)`, blob `b64cba4cfe6186cecb38a244e23b8983241a3aa6` | [canon.hh](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/nml_intf/canon.hh#L667) `STOP_SPINDLE_TURNING(int spindle, int wait_for_atspeed=1)`, blob `9a0a4de911c37ddace624b175f7bc6992d4fb05b` |
| Canonical message | [emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/emccanon.cc#L1945-L1951), blob `663e9b7eb1504bbc2e59a404abe67cdc8a6bcc11` | [emccanon.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/emccanon.cc#L2929-L2936) sets `EMC_SPINDLE_OFF.wait_for_spindle_at_speed`, blob `5ad736c59e85495aa06573ebcad2d49d59145583` |
| Task / motion command | [taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/task/taskintf.cc#L1936-L1943) and [command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1630-L1659), blobs `96a041d1feef8560f37159a2f18b109171f084c3`, `0b79061d39be915bbea548b2c33bb794d31ab302` | [taskintf.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/task/taskintf.cc#L2015-L2023), [command.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c#L1813-L1847), blobs `2a429b0f66b2593cf669d6d25c5e54105390a696`, `fd9760e59ac0e9801cbee90a379acd98d47ca6ea` |
| Probe segment | [command.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1414-L1481): `tpAddLine(..., 0, -1, tag)` at 1455–1466 | [command.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c#L1613-L1634): consumes `atspeed_next_feed` and passes `issue_atspeed` to TP |
| Planner gate | [tp.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2798-L2902), blob `5768d6e6880569f72156ed9a761b5eee531c9fcf` | [tp.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/tp/tp.c#L3447-L3565), blob `2b4024c9ab131f708cc22760300231878c9b0fdc` |

The development M5 interpreter uses `enqueue_STOP_SPINDLE_TURNING` ([interp_convert.cc](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_convert.cc#L4277-L4294)); the [queue](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/rs274ngc/interp_queue.cc#L181-L194) invokes the canonical function without a second argument, so **its declared default of 1 applies**. Direct program-end/tool-change stop calls use that default too unless an explicit argument overrides it. A later M3/M4 command may replace the shared pending flag: do not claim every M5 is an unavoidable permanent barrier.

## Call-flow and version delta

```text
M5 [possibly with $N]
  -> Interp::convert_m spindle-stop branch
  -> enqueue_STOP_SPINDLE_TURNING(N)
  -> STOP_SPINDLE_TURNING(N) canonical
  -> EMC_SPINDLE_OFF
  -> Task emcSpindleOff
  -> EMCMOT_SPINDLE_OFF
     v2.9.10: set spindle state/speed/brake; no stop-to-feed flag here
     development: same stop plus atspeed_next_feed = wait_for_spindle_at_speed (default 1)
  -> next eligible feed:
     G1/G2/G3: command.c consumes flag into segment atspeed
     development G38 probe: consumes flag too
     v2.9.10 G38 probe: segment atspeed argument hard-coded 0
  -> tpActivateSegment/tpCheckAtSpeed:
     check every configured spindle.N.at-speed when segment has atspeed flag
     wait until ready; not a direct measured-speed or personnel-safety oracle
```

**SOURCE-CONFIRMED:** In development, M5 requests that the *next feed* wait for a HAL at-speed indication representing the **stopped** state. The name `at-speed` is overloaded: at zero commanded speed, a correct feedback comparator may assert when stopped. In stable, the inspected M5 command does not set that new barrier. In development, G38 probing is additionally brought under the pending barrier; stable probe motion explicitly passes zero. Both versions can still gate a probe or feed for other reasons; this audit does not assert universal probe behavior.

**Timing caveat:** The pending flag and HAL feedback are updated by different functions/threads. A following segment can encounter a stale high before the HAL chain publishes the new low, or can encounter low and wait. Therefore a source-composed low after M5 is **not** sufficient to claim a reproduced deadlock or deterministic same-cycle result.

## Falsifiable, disconnected acceptance predictions (NOT RUN)

- **S64-A:** Stable v2.9.10 M5 then G1, with no new spindle-on/speed command, does not attach an M5-specific `atspeed` flag. Development does, by canonical default. Oracle: TP segment flag plus pending flag, not merely Task success.
- **S64-B:** Development M5 then G0 then G1: G0 is not the first feed and should not consume the pending flag. Check G1's TP segment and wait reason.
- **S64-C:** Development M5 then G38.2: G38 probe receives the pending flag; stable v2.9.10's probe segment does not. Use a valid disconnected probe fixture; record probe-input state and whether any earlier command replaced the flag.
- **S64-D:** Development M5 then M3 then G1: new spindle-on may overwrite the pending stop barrier. Determine whether the G1 waits for spin-up instead, and do not misattribute the wait to M5.
- **S64-E:** At-speed wired to a true physical-speed comparator with a zero-speed tolerance: verify false while coasting, true after zero, with actual feedback retained. This is ordinary process sequencing, not a safety-rated stop.

## Engineering interpretation / unresolved

A successful M5 command **does not** mean the spindle has physically stopped; the development mechanism is a subsequent motion barrier, and it can only be as truthful as the HAL at-speed source. If the source is forward-gated, it may never assert after stopping. If it is unwired, [motion.c](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/motion.c#L744-L747) initializes it TRUE, so the barrier provides no physical verification. The exact Woodpecker example combines both concerns in [ROUTER-65](4400_LINUXCNC_ROUTER_65_WOODPECKER_FORWARD_GATED_ATSPEED_CONFIG_SOURCE_AUDIT_2026-10-31.md).

**Evidence ledger:** source/version delta CONFIRMED; conditional post-M5/probe wait INFERENCE; actual GUI/hardware timing and physical standstill UNKNOWN; TEST-CONFIRMED none. No LinuxCNC build, simulation, physical operation, Actions compute or independent evaluation. Preserve independent personnel-safety authority and OpenPressBrake G0/G1 HOLD.
