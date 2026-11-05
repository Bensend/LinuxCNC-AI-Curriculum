# PROBE-234 — Complete Skyfire 7i76e probe HAL inclusion trace (3100, NON-GRADUATED)

## Question and provenance
PROBE-233 inspected only init.hal, axis.hal and Skyfire.ini and left the real probe wiring unresolved. This investigation reads the **entire explicit [HAL] startup inclusion list** at immutable Skyfire-community/SVM2-LinuxCNC commit `0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123`: init.hal (blob `84ad49cf7474e8c725e652faeed29db69a7c1c00`), io.hal (`259cfd2235eed94dd444ff6aceaedaf80288d090`), axis.hal (previous PROBE-233), spindle.hal (`1abd0f24f5563afdfc6f1524548b2c105c335d7e`), mpg.hal (`9b867e5ddb9a9f956f21529e93214bfe0234299a`), e_stop_ladder.hal (`589766b4e64d3e5fa0d8462ac56fcd5e9503f368`), post-GUI messages.hal (`210017e70e8bc5e99d12697e453f7cb91412948b`), shutdown.hal (`8766c9e72e6bd9a8f2fc157089699f02a5c64992`), and Skyfire.ini (`6f63c233875bd82b2eb426a4dfcb95b7bb612e43`). Pinned files: https://github.com/Skyfire-community/SVM2-LinuxCNC/tree/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123

## Resolved probe connection
**CONFIG-CONFIRMED:** `io.hal` defines `net touch_probe <= hm2_7i76e.0.7i76.0.0.input-04-not` and later `net touch_probe => motion.probe-input`. The separate `tool_probe_touch` signal originates at `input-09`, but the inspected `io.hal` does **not** connect it to `motion.probe-input`. These are distinct signals; do not assume a tool-setting input is automatically the G38 input.

**CONFIG-CONFIRMED:** The selected `input-04-not` is the logically inverted HostMot2/Mesa input pin. With that pin high, `motion.probe-input` is high. The wiring alone does not prove whether the actual probe switch is normally-open or normally-closed, whether the raw electrical state is active-low, or whether its rest state meets G38 preconditions. For G38.2/G38.3 LinuxCNC v2.9.10 expects the logical probe input to become high at contact; for G38.4/G38.5 it expects a high-to-low release (see PROBE-233 source trace). Physical polarity and probe health remain UNKNOWN.

**CONFIG-CONFIRMED (explicit startup chain):** `Skyfire.ini` [HAL] loads `init.hal`, `io.hal`, `axis.hal`, `spindle.hal`, `mpg.hal`, `e_stop_ladder.hal`, then `POSTGUI_HALFILE=messages.hal`. The shutdown file is listed separately. Among these inspected files, no explicit probe debounce component or probe filtering function is configured. This is a **bounded negative for these explicit HAL files**, not proof about FPGA input hardware filtering, GUI runtime changes, external scripts, or deployed machine wiring.

## Servo scheduling, an additional integration finding
`init.hal` orders `hm2_7i76e.0.read` **before** `motion-command-handler` and `motion-controller`; thus the Mesa input is sampled by HostMot2 before the controller consumes the probe signal. `hm2_7i76e.0.write` follows motion and PID. This is config ordering, not a hardware timestamp or measured latency.

The same file orders `hm2_7i76e.0.write` **before** `n-spindle-at-speed`, `n-spindle-at-zero-for-disable`, `spindle-enabled-or-spinning`, `spindle-ramp`, and `spindle-enable-delay`. The `spindle.hal` connections drive `spindle.0.at-speed` from `n-spindle-at-speed.out` and drive `hm2_7i76e.0.stepgen.05.velocity-cmd` from `spindle-ramp.out`. **INFERENCE:** a change computed by these later functions is not available to the preceding HostMot2 write in the *same* servo pass, introducing a scheduling boundary before its next write. Do not claim measured delay or incorrect operation without runtime evidence. This is a higher-value candidate for subsequent spindle-at-speed analysis than repeating probe wiring searches.

## Reproducible disconnected inspection exercise
1. Fetch the pinned `Skyfire.ini` and follow every [HAL] HALFILE and POSTGUI_HALFILE; classify shutdown separately.
2. Search each for `motion.probe-input`, `touch_probe`, `tool_probe_touch`, `debounce`, `addf`, `hm2_7i76e.0.read`, `hm2_7i76e.0.write`.
3. Draw two distinct chains: `input-04-not → touch_probe → motion.probe-input` and `input-09 → tool_probe_touch` (destination not established here).
4. For a hypothetical virtual G38.3, predict contact recognition when logical `touch_probe` becomes 1; for G38.5 predict recognition when it becomes 0. Label both **analytical**, not tested.
5. In a disconnected LinuxCNC simulation with an explicitly virtual input (not a physical 7i76e), inspect `halcmd show thread`, `halcmd show sig touch_probe`, and `halcmd show pin motion.probe-input`. Never infer hardware response from a simulated test.

## Evidence ledger and dependency decision
| Claim | Class | Scope |
|---|---|---|
| `input-04-not` feeds `motion.probe-input` | CONFIG-CONFIRMED | Pinned Skyfire io.hal |
| `input-09` is a distinct tool probe signal | CONFIG-CONFIRMED | No motion probe sink in inspected io.hal |
| No explicit probe debounce in the full enumerated HAL file chain | CONFIG-CONFIRMED bounded | Not an electrical/filtering guarantee |
| Mesa read precedes controller, write follows | CONFIG-CONFIRMED | Source config, not live execution |
| Later spindle computation can miss same-pass Mesa write | INFERENCE from config ordering | No runtime verification |
| Electrical polarity, switch type, hardware filter and trigger latency | UNKNOWN | Requires actual device docs/wiring/runtime |

**Next:** Close probe wiring branch at information-gain stop; rotate to source-level spindle-at-speed, G33/G76 synchronization or M6 tool-change execution. Use the observed `near`/lowpass/write ordering as a concrete real-machine case, trace LinuxCNC spindle-at-speed consumers and confirm whether any `near` comparator has a special zero-speed behavior. No machine motion, no compute and no hosted Actions. Preserve all graduation, independent personnel safety and blind gates.
