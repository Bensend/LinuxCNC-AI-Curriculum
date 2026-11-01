# 3200/4000 practical walkthrough — EtherCAT spindle readiness and synchronized index

**2026-11-01 | Source-backed integration lesson; NON-GRADUATED, NOT RUN.** This is a machine-specific transfer exercise, not a required product build. Use the public 2024 EL8 example to distinguish feedback provenance, realtime ordering, readiness, spindle-index handshake and ordinary machine control. Source findings: [SPINDLE-100](../research/4400_LINUXCNC_SPINDLE_100_EL8_AT_SPEED_DEBOUNCE_AND_HAL_ORDER_SOURCE_AUDIT_2026-11-01.md), [SPINDLE-101](../research/4400_LINUXCNC_SPINDLE_101_EL8_SYNTHETIC_INDEX_WINDOW_AND_RIGID_TAPPING_SOURCE_AUDIT_2026-11-01.md). Earlier [ETHERCAT-51](../research/4400_LINUXCNC_ETHERCAT_51_CNC3_VS_2026_CSP_CONFIG_HOMING_DC_SOURCE_AUDIT_2026-10-31.md) already covers PDO, DC and joint wiring; do not count that as new.

## Step 1 — establish exact software and pin origins

Read public [EL8_machine.hal](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/EL8_machine.hal), [EL8_machine.ini](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/EL8_machine.ini), [ethercat-conf.xml](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/ethercat-conf.xml), [servospindle.comp](https://github.com/marcoreps/linuxcnc_leadshine_EL8/blob/1540a7131c1d512997ba2824c88dcd24d4177538/servospindle.comp). For LinuxCNC component behavior use pinned stable v2.9.10 [near.comp](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/components/near.comp) and [dbounce.comp](https://github.com/LinuxCNC/linuxcnc/blob/86cdca76fa2a36274c432caa21952b23c267989a/src/hal/components/dbounce.comp). The public HAL predates the current maintained EtherCAT C port; record the *actual* installed `cia402` binary before making compatibility claims.

Trace separately:

| Quantity | Source | Consumer | What it proves |
|---|---|---|---|
| Spindle target RPM | `spindle.0.speed-out` | `mult2.1 → cia402.4.velocity-cmd` | Requested speed only |
| Drive-reported velocity | 0x606C → `lcec.0.7.actual-velocity` | `cia402.4.velocity-fb → mult2.2 → spindle.0.speed-in` | PDO feedback as reported by drive; freshness/physical shaft correspondence not independently proven |
| At-speed | `near.0.out` | `dbounce.0.out → spindle.0.at-speed` | Long-integrated agreement of reported speeds, not separate drive-ready |
| Spindle position | 0x6064 → `conv-s32-float.6 → mult2.0` | `servospindle.pos-input → pos-output → spindle.0.revs` | Drive-reported position transformed by software |
| Index request | `spindle.0.index-enable` | `servospindle.index-enable` (bidirectional) | Software handshake, **not** independent physical index capture |
| Bus health | `lcec.0.wkc-state`, `all-op`, per-slave oper | diagnostic trace | Completeness and state indicators, not personnel safety |

For current maintained EtherCAT documentation see [master pins](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/documentation/master-pins.md). Pin availability must be checked against the installed driver revision.

## Step 2 — draw the actual servo-thread execution graph

From the HAL, write down the literal `addf` order; do not infer ordering from `net` syntax. In this example `servospindle`, `mult2`, `dbounce`, `near` and `conv-s32-float` all run **before** `lcec.read-all`; `dbounce` also runs before `near`. Draw a tick-indexed graph marking when each consumer sees the previous versus current cycle's signal. For a proposed revised configuration, *without editing the published original*, compare a logically ordered pipeline:

```text
lcec.read-all → cia402.read-all → feedback scale → near → dbounce
→ motion-command-handler → motion-controller → cia402.write-all → lcec.write-all
```

This is a **conceptual ordering sketch**, not a drop-in HAL replacement. Some other HAL components, particularly spindle position/index consumers, may require their own placement and thread dependencies.

## Step 3 — calculate readiness before running anything

With `near.scale=1.02` and `difference=0`, 1000 RPM command nominally accepts approximately 980.392–1020 RPM reported feedback. At 0 command and 0 reported feedback, `near=1`. With `dbounce.delay=10000` and a 1 ms servo period, a continuously true `near` takes 10,001 function calls to assert `at-speed` from empty state; continuously false takes 10,001 calls to clear it from saturated state. This is **integrator behavior**; alternating samples do not reset the counter.

An acceptance decision must distinguish: speed command, drive-reported speed, drive enable/op state, bus WKC/freshness, spindle on, and `spindle.0.at-speed`. An `at-speed=1` alone does not prove current physical speed or safe operation.

## Step 4 — calculate index capture before running anything

The custom `servospindle` generates `index=(uint32(pos_input)%100000 <= 1000)`. At 6,000 RPM, 100,000 counts/rev and 1 ms sampling, samples advance 10,000 counts. Starting at phase 5,000, every sample stays outside the window; an asserted index request is not acknowledged by this component. Starting at phase 0 does encounter the window. At low speed the window can remain true across multiple cycles. Compare against a true hardware-index latch and a boundary-crossing detector; neither is implemented in this source.

## Step 5 — disconnected acceptance worksheet (all NOT RUN)

| Case | Input sequence | Source-derived expected observation | What would falsify it |
|---|---|---|---|
| A | 0 command, 0 reported speed for 10001 nominal ticks | `near=1`; `dbounce.out` eventually 1 without `spindle.on` gating | Different installed `near`/`dbounce` implementation or HAL override |
| B | Start saturated, then 10000 bad near ticks | `dbounce.out` stays 1 through the discharge; next false tick clears | Reset-on-false implementation or different function count |
| C | Alternating near 1/0 for many ticks | `dbounce` state oscillates; no consecutive-timer reset | Observed immediate reset on false |
| D | 1000 RPM cmd, feedback 979/990/1021 | `near` false/true/false at scale 1.02 | Different installed near tolerance/scale |
| E | 20 samples at `5000+10000*k` modulo 100000 | No synthetic index, index request not cleared by index branch | Independent index mechanism or different compiled component |
| F | Samples beginning at phase 0 | Index window encountered; request can clear | Installed component differs |
| G | Read-before versus read-after `near`/feedback pipeline | Tick-level age differs; **not** a claim about hardware latency | Actual scheduled function order differs |

To execute these, first establish a positively qualified **disconnected** `[self-hosted, openpressbrake]` runner. Capture exact LinuxCNC/component source hashes, installed binary identity, source of every stimulus, per-cycle observations, exit status, and authoritative job start/end. Do not use GitHub-hosted runners or operate a physical machine. No tests have been run in this research session.

## Step 6 — diagnose without conflating authorities

In a permitted offline HAL session, inspect `halcmd show thread`, `halcmd show funct`, `halcmd show pin near.0`, `halcmd show pin dbounce.0`, `halcmd show pin spindle.0`, `halcmd show pin cia402.4`, and `halcmd show pin lcec.0` **read-only**. Pin names and `show` availability are version-dependent; do not assume a live machine or grant motion permission. For a non-running config, read the HAL/INI/XML text instead.

A clean design review should answer: Is the drive feedback genuinely measured? Is its PDO fresh? Is the spindle ready independently of speed agreement? Can the index handshake miss an entire revolution? Does any feedback freeze remain plausible? Is the configured 10-second filter intentional? What is the independent physical safety authority? The last question is a cross-cutting constraint, not a claim that ordinary LinuxCNC status is safety-rated.

**Promotion/next work:** test only the two most discriminating software cases (zero/zero at-speed and skipped index) when qualified compute exists; otherwise rotate to distinct LinuxCNC internals. This guide does not reopen graduated levels or change existing evaluation gates.
