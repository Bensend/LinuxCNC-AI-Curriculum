# 4000-LC-ROUTER-65 — Upstream Woodpecker spindle readiness is forward-gated and command-derived

**2026-10-31 | SOURCE-CONFIRMED static integration, conditional runtime INFERENCE, TEST-CONFIRMED none | NON-GRADUATED.** LinuxCNC 3400 router/4000 realtime-HAL transfer, not a reopening of graduated 3400.

## Why this is new, and what is not

[SPINDLE-22](4400_LINUXCNC_SPINDLE_22_MULTISPINDLE_ATSPEED_INDEX_HANDSHAKE_SOURCE_AUDIT_2026-10-31.md) already covers all-spindle TP readiness and the upstream two-spindle index-enable crosswire. [MON-02](4400_LINUXCNC_PINNED_SPINDLE_AT_SPEED_DEFAULT_TRUE_RAMPED_COMMAND_VS_SAFETY_MONITOR_SOURCE_TRACE_2026-10-25.md) already covers the unwired default and a different soft-start example comparing commanded versus ramped command. This audit adds an **exact, previously uninspected shipped Woodpecker HAL topology** and integrates it with the **development-only M5/probe barrier** established in [SPINDLE-64](4400_LINUXCNC_SPINDLE_64_M5_STOP_AND_PROBE_ATSPEED_VERSION_BOUNDARY_SOURCE_AUDIT_2026-10-31.md). No new general claim is made about all routers or real VFDs.

## Immutable upstream source and configuration

- [v2.9.10 `configs/sim/woodpecker/woodpecker.ini`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/woodpecker/woodpecker.ini#L78-L88), blob `dbcb9e416b8d25c48beeede3a2cc508670e2056b`: `SPINDLES=1`, `HALFILE=core_sim.hal`, `POSTGUI_HALFILE=woodpecker_postgui.hal`.
- [v2.9.10 `core_sim.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/woodpecker/core_sim.hal#L5-L24), blob `a46f0092347379b62dffc7e7ea3059c538dd28b2`: motion-command-handler then motion-controller in servo-thread.
- [v2.9.10 `woodpecker_postgui.hal`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/configs/sim/woodpecker/woodpecker_postgui.hal#L3-L34), blob `1885b70827ffa8ab44cae9b823c2b48d6e4a56d5`: adds `and2.0` **before** `near.0` to servo-thread, then connects speed command and forward to at-speed.
- [v2.9.10 `near.comp`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/near.comp), blob `531c21b0c71c35163ba275da83f0a87c97dc5544`: `(scale>1 && ratio-within-range) || (fabs(in1-in2)<=difference)`.
- [v2.9.10 `and2.comp`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/hal/components/and2.comp), blob `ed446fc499fd9722001fedd444a77a1b452206c6`: `out = in0 && in1`.
- [Pinned development `control.c`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/control.c#L2048-L2056), blob `7c9a35c237ba05326372294587c33d53aff1a6a9`: `spindle_forward` is published from `speed > 0`, `spindle_reverse` from `speed < 0`, and `spindle_on` from state. [Development `command.c`](https://github.com/LinuxCNC/linuxcnc/blob/537cf2d765c96b6e75ae1db44e1dc0b9dba906a1/src/emc/motion/command.c#L1828-L1834) explicitly sets speed/state to zero on M5. Therefore the forward gate is FALSE for M4's negative command and M5's zero command, without assuming that a VFD actually reversed or stopped.
- Pinned development `537cf2d765c96b6e75ae1db44e1dc0b9dba906a1` has **identical** `woodpecker_postgui.hal` blob `1885b70827ffa8ab44cae9b823c2b48d6e4a56d5`, despite its changed M5 barrier in [SPINDLE-64](4400_LINUXCNC_SPINDLE_64_M5_STOP_AND_PROBE_ATSPEED_VERSION_BOUNDARY_SOURCE_AUDIT_2026-10-31.md). The INI changed across revisions, so this is **not** a claim that the complete machine config is identical.
- [Official spindle examples](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/docs/src/examples/spindle.adoc) distinguish a command-ramp proxy from encoder feedback. The Woodpecker HAL here uses neither for its near comparator.

## Actual shipped signal graph

```text
spindle.0.speed-out-abs
    -> HAL signal "spindle-cmd"
       -> near.0.in1
       -> near.0.in2          SAME SIGNAL, not independent speed feedback
near.0.out -> and2.0.in1
spindle.0.forward -> and2.0.in0
and2.0.out -> spindle.0.at-speed
spindle.0.speed-out-rps -> spindle.0.speed-in  (command copied as "feedback")
```

**SOURCE-CONFIRMED:** With both `near.0` inputs tied to the same HAL signal, their difference is zero; after `near.0` runs, its output is TRUE regardless of the real spindle's measured speed. The resulting `spindle.0.at-speed` is therefore essentially a **delayed copy of `spindle.0.forward`**, not a feedback-derived readiness indication. The config's `speed-in` is also a commanded-RPS loopback rather than a measured encoder velocity. The `abs_spindle_feedback` component is loaded and scheduled but is not connected to this readiness comparison in the inspected postgui file.

## Three versioned command consequences

| Command context | HAL logic after settling | Source-derived scheduling consequence (NOT RUN) |
|---|---|---|
| M3 S>0, forward TRUE | near TRUE; and2 TRUE | Normal G1 at-speed barrier can clear without measured spindle rotation. No physical speed proof. |
| M4 S>0, forward FALSE | near TRUE; and2 FALSE | First feed after M4 may wait indefinitely once the FALSE is sampled. Whether a stale previous TRUE permits an earlier start is a scheduling question. |
| M5, forward FALSE | near TRUE; and2 FALSE | In **development**, M5's default stop-to-next-feed barrier may remain blocked after the spindle is fully stopped. Stable v2.9.10 lacks that M5-specific barrier. |
| M5 followed by G38 probe | near TRUE; and2 FALSE | In **development**, probe now consumes the pending barrier and may wait; stable probe segment passes atspeed=0. Probe-input preconditions still apply. |

This is a **source-composed compatibility hazard**, not a reproduced GUI failure or a physical machine report. A stop command could be followed by a feed before the false propagates, because HAL functions execute after motion-controller. Thus the source permits two observable outcomes depending on command/servo phase: a later indefinite wait or a stale-high pass. Do **not** claim deterministic deadlock without a synchronized runtime trace.

## Realtime phase and observability

The INI loads `core_sim.hal` first, scheduling `motion-controller`. The post-GUI file later schedules `and2.0` then `near.0`. At a servo iteration:

1. motion-controller consumes the previously published `spindle.0.at-speed`;
2. and2 computes from current `spindle.0.forward` but **previous** near output;
3. near computes the new comparator output (always TRUE after evaluation in this wiring).

Consequently an at-speed state transition is not guaranteed to be visible to motion in the same servo iteration. The actual LinuxCNC HAL schedule, load success, user-command dispatch and TP segment timing must be recorded to claim a particular number of cycles. Do not replace this with an assumed wall-clock delay.

## Minimal review-only corrected topology, NOT a machine patch

For a process-ready comparator, a meaningful speed feedback source should replace the second command-side input, and the ready signal should be defined for **both** rotation and stopped state:

```hal
# Illustrative wiring only: first verify actual drive feedback, units and polarity.
# net spindle-cmd-rpm spindle.0.speed-out-abs => near.0.in1
# net measured-spindle-rpm <real VFD/encoder RPM signal> => near.0.in2
# net spindle-ready near.0.out => spindle.0.at-speed
# setp near.0.scale 1.01
# setp near.0.difference <appropriate zero-speed tolerance in RPM>
```

This removes the forward-only gate but does **not** by itself establish feedback integrity, drive fault handling, signal freshness, a safe standstill or personnel-safety authority. Real encoder/VFD pins and thread order must be inspected for a specific machine. Do not edit installed machine wiring based solely on this example.

## Bounded discriminators and falsifiers

- **R65-A (static):** compare `show sig spindle-cmd`, `show pin near.0.in1/in2`; both should share one source in the original simulation. A revision with independent feedback would falsify this topology claim.
- **R65-B (static):** `show sig at_speed`, `show sig forward`, `show sig at_speed_fwd`; prove exact `and2` fan-in/out, not just an LED label.
- **R65-C (software only):** observe at-speed through M3/M4/M5 and preserve timestamped command/forward/near/and2/at-speed/TP-wait state. Freeze stable/development source and HAL file hashes.
- **R65-D (software only):** compare G1 after M5 versus G38.2 after M5, including stale-high races; do not use a real probe or spindle.
- **R65-E (software only):** replace only `near.in2` with a separately controlled simulated measured-speed signal; verify the command-vs-feedback distinction without asserting hardware safety.

## Evidence and transfer

**SOURCE-CONFIRMED:** original postgui wiring, same-command comparator, forward gate, command loopback, scheduling order, development M5/probe code. **INFERENCE:** first-feed stall or stale-high pass, exact timing. **UNKNOWN:** whether original sample starts cleanly, actual runtime outcomes, real VFD behavior and installed machine wiring. **TEST-CONFIRMED:** none. No build, simulation, hardware, evaluator or Actions compute. Ordinary LinuxCNC readiness is never independent personnel-safety authority; OpenPressBrake physical G0/G1 HOLD unchanged.
