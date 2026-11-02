# 4000-LC-INHIBIT-141 — Feed/spindle inhibit accidentally coupled to spindle-override bit

> **2026-11-02 EVIDENCE CORRECTION — DUPLICATE, NOT NEW:** The exact feed/spindle inhibit mask mechanism and selected-spindle Task loss were already published as [OVERRIDE-93](4400_LINUXCNC_OVERRIDE_93_FEED_INHIBIT_SS_BIT_COUPLING_SOURCE_AUDIT_2026-11-01.md), [OVERRIDE-94](4400_LINUXCNC_OVERRIDE_94_SPINDLE_INHIBIT_SS_BIT_SPEED_ON_SOURCE_AUDIT_2026-11-01.md), and [OVERRIDE-95](4400_LINUXCNC_OVERRIDE_95_M51_SELECTED_SPINDLE_DROPPED_AT_TASK_SOURCE_AUDIT_2026-11-01.md). This document is a later **source reinspection** at development 06864e, not a first discovery, independent confirmation, or additional competency. Its A–G runtime tests overlap preexisting [O93–O95 cases](../guides/4000-linuxcnc-m51-inhibit-coupling-disconnected-acceptance-2026-11-01.md); do not rerun duplicates. [THREAD-142](4400_LINUXCNC_THREAD_OVERRIDE_142_G33_G331_G76_GLOBAL_LOCK_VERSION_SOURCE_AUDIT_2026-11-02.md) covers the distinct synchronized-operation follow-through.

**2026-11-02 UTC | LinuxCNC-first, non-graduated | 3100 mills, 3200 lathes, 3400 routers, 4000 motion/HAL.** Static source comparison only. **SOURCE-CONFIRMED expression and flag semantics; INFERENCE for controller outcome; runtime NOT RUN; physical machine UNKNOWN.** No GitHub Actions, machine, simulation or independent evaluation.

## Provenance and predecessor audit

Stable **v2.9.10** and development **`06864e23559e70463fc7112d5ce77138bcbc288c`** fetched directly from `LinuxCNC/linuxcnc`. Stable `control.c` blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, `motion.h` `f789f59cda93502e35e5ee156e6254d1d6591629`, `command.c` `0b79061d39be915bbea548b2c33bb794d31ab302`; development `control.c` `7c9a35c237ba05326372294587c33d53aff1a6a9`, `motion.h` `1a48aa02f5772b8fd5e50862e13b097f1b789cc4`, `command.c` `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`. [Stable control](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L362-L434), [stable flags](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.h#L421-L429), [stable override command](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c#L1268-L1279), [development control](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/control.c#L475-L508), [development override command](https://github.com/LinuxCNC/linuxcnc/blob/06864e23559e70463fc7112d5ce77138bcbc288c/src/emc/motion/command.c#L1408-L1427).

Prior `PROGRESS.md` and `LAB_COMPUTE_LOG.md` checked by mechanism/synonyms. Earlier STEPGEN-97 and HM2-GPIO-132 discuss *different* feedback/command-authority boundaries; SPINDLE-100 addresses at-speed, M66-140 wait ownership. No earlier named inhibit-bitmask investigation found in those ledgers. A negative ledger match is not proof of global novelty.

## Reproducible source trace

1. `motion.h` defines **`SS_ENABLED=0x01`**, `FS_ENABLED=0x02`, `AF_ENABLED=0x04`, `FH_ENABLED=0x08`. `motion.c` initializes `enables_new = FS_ENABLED | SS_ENABLED | FH_ENABLED` (0x0B). The HAL inhibit pins are bits (0 or 1).
2. `command.c` handles `EMCMOT_SS_ENABLE`: stable `mode=0` clears **SS_ENABLED**; development `EMC_SO_OVERRIDE_OFF` clears **SS_ENABLED | SS_LOCKED**. `M51 P0` is documented as disabling *spindle speed override*, not disabling feed/spindle inhibit. `M49` disables feed and spindle overrides. [M-code manual](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/gcode/m-code.adoc#L263-L304).
3. `control.c` selects `enables_queued` during coordinated motion, otherwise `enables_new`. The trajectory planner copies each active segment's `tc->enables` to `enables_queued` ([tp.c lines 2596–2627](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/tp/tp.c#L2596-L2627)). Thus compare *a newly queued ordinary move after M51*, not an older already-queued segment.
4. Both versions use **`if (enables & feed_inhibit_bit) scale=0`** and **`if (enables & spindle_inhibit_bit) scale=0`**. Stable dereferences `hal_bit_t*`; development uses `hal_get_bool()`. For a TRUE pin the expression reduces to `enables & 0x01` — **the spindle-speed-override bit**, not a dedicated inhibit-permission flag. When SS_ENABLED is cleared, both conditions evaluate false even with inhibit TRUE. Development's SS_LOCKED bit does not fix this.
5. The resulting `net_feed_scale` affects feed calculation, and spindle `net_scale` multiplies spindle speed in [stable control lines 1868–1910](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c#L1868-L1910). This is a commanded-scale conclusion; it does not establish physical actuator motion or whether another inhibit/stop path intervenes.

### Frozen static truth table (TRUE HAL inhibit pins, ordinary non-synchronized segment)

| Selected flags | Mask | `mask & 1` | Source-derived feed/spindle inhibit effect |
|---|---:|---:|---|
| Default SS+FS+FH | 0x0B | 1 | scale forced 0 |
| After M51 P0: FS+FH | 0x0A | 0 | **not forced 0** |
| After M49: FH (assuming no AF) | 0x08 | 0 | **not forced 0** |
| After M51 P1: SS+FS+FH | 0x0B | 1 | scale forced 0 |
| SS disabled, AF enabled | 0x0E | 0 | **not forced 0** |

This is a **bitwise source calculation**, not measured motion. A TRUE `motion.feed-hold` is a separate gate when FH_ENABLED is set and can mask the effect; keep it FALSE in a discriminating test. Likewise keep `motion.adaptive-feed=1` or M52 P0. A spindle test needs nonzero commanded S and appropriate normal enable.

## Documentation and real-config transfer

[Core motion pins](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/config/core-components.adoc#L125-L132) describe `motion.feed-inhibit` as stopping G-code feed regardless of M53, except delayed during spindle-synchronized moves. This source coupling to M51/M49 is **not described**. Real upstream QtDragon simulation [`qtdragon_postgui.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/qtdragon/qtdragon_xyz/qtdragon_postgui.hal#L9-L18) connects `qtdragon.spindle-inhibit` to `spindle.0.inhibit` for its spindle-pause/external-Z-offset feature. **This is an upstream SIM configuration, not a physical-machine incident.** Its relevance is that the pin is used in a real published integration path.

## Correction review boundary

The expression strongly suggests an unintended bitmask/Boolean mix-up. **Do not blindly replace with `if (inhibit)`**: the comment explicitly excepts spindle-synchronized moves, and the current `enables` flags may be used to represent that exception. Nor assume `if (enables != 0 && inhibit)` is correct for all synchronized/override combinations. First trace how G33/G33.1 suppress/restore flags and how per-spindle M51 $ selection maps to the shared bit. A candidate fix needs a *separate, explicit inhibit-eligibility predicate* with source-verified synchronized-motion semantics. Preserve M51/M49 as override-only operations and distinguish ordinary feed, rapid, jog, threading and multi-spindle paths.

## Independent verification still needed

On positively qualified **physically disconnected** `[self-hosted, openpressbrake]` compute only, run the paired [G-code fixtures](../examples/4000_inhibit_141/) using a simulated HAL pin with an actual writer and no hardware driver. Before execution freeze revision, binary, INI, HAL, pin state, test hashes, expected oracle and job timestamp. Compare M51 P1 vs P0 with feed-inhibit TRUE and feed-hold FALSE; capture `motion.feed-inhibit`, `motion.feed-hold`, `motion.feed-upm`, motion position command, active segment flags, `net_feed_scale` (instrument if not exposed), and exit status. Repeat separately for `spindle.0.inhibit` and M49; verify M51 P1 restores. Test G33/G33.1 only after understanding the synchronized-motion exception. **No such test ran this session.**

### Adversarial checks

- Why is `enables & 1` not equivalent to `enables != 0`? Because SS_ENABLED alone occupies bit zero.
- Why can a moving axis still appear stationary in a careless test? Another independent feed hold, machine disable, or no queued motion may mask the bug.
- Does `spindle.0.inhibit` establish independent motor stop? No: it scales LinuxCNC's normal spindle request and is not a personnel-safety authority.
- Does a published QtDragon HAL file prove a machine fault? No: it establishes a wiring use case only.

**Evidence:** SOURCE-CONFIRMED static (both pinned versions); DOC-CONFIRMED stated intended pin contract; source-derived truth table INFERENCE; runtime/physical/evaluator NOT RUN. No graduation or safety-gate change.
