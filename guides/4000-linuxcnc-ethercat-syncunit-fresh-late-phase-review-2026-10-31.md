# 4000 practical EtherCAT acceptance — Sync Unit freshness, output deadlines and DC state

**2026-10-31 | SOURCE-BASED REVIEW, NOT RUN.** Based on [ETHERCAT-50](../research/4400_LINUXCNC_ETHERCAT_50_SYNCUNIT_FRESHNESS_LATE_TX_DC_PHASE_SOURCE_AUDIT_2026-10-31.md), upstream commit `56515f4aac313551346289d9c227193f50e9602a`. Out-of-tree LinuxCNC EtherCAT driver; not a claim about stock LinuxCNC 2.9/2.10 or an installed machine.

## Pinned minimal topology

Review [upstream multirate HAL](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/examples/sync-units/multirate.hal) and [XML](https://github.com/linuxcnc-ethercat/linuxcnc-ethercat/blob/56515f4aac313551346289d9c227193f50e9602a/examples/sync-units/multirate-conf.xml). They intentionally contain incomplete generic PDO mappings; **do not run them as a machine configuration**.

| Thread | Period | Bus / unit functions | Rate |
|---|---:|---|---:|
| ecat-thread | 125,000 ns | `lcec.read-all` ... `lcec.write-all`; `initf lcec.activate` on 2.10+ | 8 kHz |
| servo-thread | 500,000 ns | `lcec.0.syncunit.motion.read` ... `.write` | 2 kHz |
| io-thread | 1,000,000 ns | `lcec.0.syncunit.io.read` ... `.write` | 1 kHz |

XML motion unit `syncUnitCycle="*4"`, `sync0Cycle="*4"`, phase 0; I/O `*8`, phase 2. Verify `appTimePeriod` exactly matches fastest thread. `initf` is not available on LinuxCNC 2.9; source fallback activates in the first write cycle.

## Inspectable timing worksheet

For bus period P=125 µs, divider N=4 and phase p=0, send on tick `t%4==0`, receive at tick `t+1`. Default phase offset `P/4=31.25 µs`; nominal compute window until next send `(N-1)P - P/4 = 343.75 µs`. Recompute for the actual `phase-offset`, drive SYNC0 shift and send latency. **Do not treat this idealized window as a guaranteed CPU budget.**

## Frozen software-only test matrix (all NOT RUN)

| ID | Stimulus | Oracle | Discriminator |
|---|---|---|---|
| EC1 | `lcec_su_due` N=4/p=0, N=8/p=2 | exact due ticks | phase grid vs app-time jitter |
| EC2 | unit `read` called twice without new `rx_gen` | second `fresh=0`, `stale-count` grows after OP; callbacks may still run | fresh vs reused process image |
| EC3 | bus sees a new RX image but WKC incomplete | `fresh` can be 1 while `wkc-state!=2` | generation vs valid exchange |
| EC4 | eleven consecutive due sends without new TX | repeated old image, rising `late-count`, first ten resend previous image; eleventh due miss suppresses domain until new output | stalled thread vs network drop |
| EC5 | disable `dc-sync-monitor` after convergence | DC pins hold previous values | cached diagnostic vs live measurement |
| EC6 | LinuxCNC 2.9 without `initf`, 2.10+ with it | inline versus clean activation path | version-dependent startup phase |
| EC7 | thread `write` scheduled on another task | source reports error and skips publication | HAL thread placement |

EC1–EC4 are candidates for pure-software unit tests of `lcec_syncunit.h` and a reviewed isolated driver harness; EC5–EC7 require a verified environment and must not be represented as run here.

## Live diagnostic inventory (read-only, **only on a qualified disconnected system**)

```sh
halcmd show pin 'lcec.*'
halcmd getp lcec.0.wkc-state
halcmd getp lcec.0.dc-sync-converged
halcmd getp lcec.0.syncunit.motion.fresh
halcmd getp lcec.0.syncunit.motion.late-count
halcmd getp lcec.0.syncunit.motion.stale-count
# if exported by the installed build:
halcmd getp lcec.0.syncunit.motion.phase-locked
```

Pin presence depends on the configured Sync Units and RTAPI PLL support. Readings sampled sequentially are not an atomic snapshot; use a bounded realtime trace for same-cycle assertions. Compare `fresh`, WKC, late/stale counters and phase separately; never declare a device or personnel-safety function healthy from one pin.

## Hardware and evidence boundary

No production bus connection, no energized motor/actuator, no disabling hardware watchdogs. A driver stopping EtherCAT frames after missed output generations does **not** independently establish what a particular slave's outputs do; verify device-specific watchdog/drive reaction under qualified procedures. Use only independently isolated `[self-hosted, openpressbrake]` compute for a justified software-only test; never GitHub-hosted Actions. Retain commit, exact config, source/test SHA, logs, traces, measured job runtime and independent review. Graduated levels, blind evaluation and G0/G1 HOLD remain unchanged.
