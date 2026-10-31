# 4000 practical acceptance — Woodpecker spindle readiness and versioned M5/probe sequencing

**Status: DISCONNECTED TEST DESIGN — NOT RUN.** Do not operate a spindle, VFD, tool, probe or physical machine. Intended for a verified isolated LinuxCNC software-only host. Any Actions execution must use only an approved, positively isolated `[self-hosted, openpressbrake]` runner; no GitHub-hosted fallback.

**Source basis:** [SPINDLE-64](../research/4400_LINUXCNC_SPINDLE_64_M5_STOP_AND_PROBE_ATSPEED_VERSION_BOUNDARY_SOURCE_AUDIT_2026-10-31.md) and [ROUTER-65](../research/4400_LINUXCNC_ROUTER_65_WOODPECKER_FORWARD_GATED_ATSPEED_CONFIG_SOURCE_AUDIT_2026-10-31.md). Related predecessors: [SPINDLE-22](../research/4400_LINUXCNC_SPINDLE_22_MULTISPINDLE_ATSPEED_INDEX_HANDSHAKE_SOURCE_AUDIT_2026-10-31.md) and [MON-02](../research/4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md). Do not re-score their established generic claims as new findings.

## Version, isolation and evidence preflight

Freeze a copy of **LinuxCNC v2.9.10** and development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1`; record executable/source SHA, `configs/sim/woodpecker/{woodpecker.ini,core_sim.hal,woodpecker_postgui.hal}` blob SHAs, exact HAL `show thread` and `show sig` snapshots, and G-code fixture SHA-256. Use simulation with all external drives physically disconnected and no USB/EtherCAT/Mesa output access. Confirm the original config **loads** before applying any experimental HAL changes. Failure to load is a fixture result, not proof of an M5 deadlock.

Do not mutate an existing linked HAL input using `setp`. For controlled signal experiments, copy the config, disconnect only the intended net and attach a separate simulation signal/component; record every changed line. If the host cannot prove disconnection, do not run.

## Minimal program skeletons (adapt to a homed simulation and reachable coordinates)

**W1 — spindle-start feed:**
```ngc
G21 G90 G94
M3 S1000
G1 X1 F100
M5
M2
```

**W2 — spindle-stop feed:** first run W1, then in a separate copied fixture insert `G0 X2` and `G1 X3 F100` immediately after `M5`, before `M2`. Keep a nonzero finite feed and ensure all positions are inside the simulated envelope. The rapid should not consume the next-feed at-speed barrier; the following feed is the discriminating move.

**W3 — reverse spindle:** substitute `M4 S1000` for M3 in W1; observe whether `spindle.0.forward` remains FALSE and the first G1 is blocked or passes a stale high.

**W4 — probe:** substitute a valid `G38.2` move for the post-M5 G1, with a separate simulated probe-input source and correctly initialized probe state. This is a source-path exercise, not a real probing operation.

**W5 — overwrite:** insert `M3 S1000` between M5 and the post-stop feed. It should request spin-up rather than an old stop barrier. Inspect the actual TP flag before attributing any wait.

## Frozen acceptance matrix

| ID | Case and discriminating observation | Source-derived prediction | Oracle / status |
|---|---|---|---|
| A1 | Original v2.9.10 Woodpecker HAL load | No assumption about successful load | HAL exit, exact error, pin inventory — **NOT RUN** |
| A2 | Original development Woodpecker HAL load | Same postgui blob; full INI may differ | HAL exit and hash — **NOT RUN** |
| A3 | `near.0.in1` and `near.0.in2` | Both connected to `spindle-cmd` | `show sig spindle-cmd`, source wiring — **SOURCE-CONFIRMED; runtime NOT RUN** |
| A4 | `spindle.0.at-speed` driver | `and2.0.out = spindle.0.forward && near.0.out` | `show sig at_speed_fwd` and thread ordering — **SOURCE-CONFIRMED; runtime NOT RUN** |
| A5 | M3 S1000, then G1 | After propagation, at-speed TRUE even without independent RPM measurement | Compare commanded RPM, measured RPM (if independently simulated), and TP wait — **NOT RUN** |
| A6 | M4 S1000, then G1 | After propagation, at-speed FALSE; possible wait or stale-high admission | TP segment state plus time-aligned HAL pins — **NOT RUN** |
| A7 | M5 then G0 then G1, stable | No M5-specific stop barrier from stable command path | TP atspeed flag, not Task command OK — **NOT RUN** |
| A8 | M5 then G0 then G1, development | M5 requests a stop-to-feed barrier; FALSE may strand feed, stale high may admit it | TP pending flag, active segment, servo-phase trace — **NOT RUN** |
| A9 | M5 then G38.2, stable vs development | Stable probe passes 0 atspeed; development consumes pending stop flag | Probe command validation and TP segment flag — **NOT RUN** |
| A10 | M5 then M3 then G1, development | M3 may replace M5 pending barrier; wait is spin-up, not stop | Command sequence, pending flag, TP segment — **NOT RUN** |
| A11 | Replace only near input2 with independent simulated feedback | Readiness should track simulated feedback when forward, not merely command | HAL signal trace, command/feedback contrast — **NOT RUN** |
| A12 | Corrected zero-speed-capable readiness without forward-only AND | After stop, ready may become TRUE at measured zero, allowing development post-M5 feed | Source comparison and bounded runtime — **NOT RUN** |

## Measurement and failure discrimination

Sample at a single known servo-phase boundary if possible, rather than correlating unsynchronized `halcmd` snapshots as if atomic. At minimum retain `spindle.0.on`, `forward`, `speed-out-abs`, `speed-in`, `near.0.in1/in2/out`, `and2.0.in0/in1/out`, `spindle.0.at-speed`, commanded G-code line, Task status, and TP waiting/active segment state. A logger lacking the TP atspeed flag cannot distinguish a genuinely pending barrier from a normal pause or invalid G-code. Instrumenting TP is a test-only source modification and must be labeled as such.

**Important falsifiers:** If original HAL fails to load, do not claim the shipped example executed. If development's canonical stop default is not 1 at the actually tested revision, the M5 prediction must be revised. If a real independent feedback pin feeds near.0.in2 in a different installed configuration, the same-command conclusion does not transfer. If G1 starts before at-speed drops, preserve the stale-high phase trace rather than incorrectly marking the source-derived stop wait disproved.

## Practical integration checklist

For a real router/VFD, separately verify actual speed-feedback provenance and units (RPM versus RPS), start/stop and reverse semantics, `M5` zero-speed reporting, HAL function order, VFD fault/ready handling, probe operation after stop, and timeout/error handling. Do not force `spindle.0.at-speed=TRUE` to bypass a machine stall. Ordinary HAL/TP sequencing is not independent STO, safe standstill, enclosure interlocking or any personnel-safety function.

**Evidence classification:** SOURCE-CONFIRMED topology and versioned code; conditional runtime predictions; all A1–A12 **NOT RUN**; physical machine acceptance and independent evaluation **OPEN**. No Actions compute or lab runtime incurred by authoring this guide.
