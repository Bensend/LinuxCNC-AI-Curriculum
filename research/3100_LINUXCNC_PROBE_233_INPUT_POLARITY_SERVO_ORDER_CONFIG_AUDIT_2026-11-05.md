# PROBE-233 — G38 input polarity, servo sampling, and real Mesa configuration audit (3100, NON-GRADUATED)

## Question and scope
Does LinuxCNC v2.9.10 debounce or invert `motion.probe-input` internally, when is it sampled relative to Mesa read, and can a real 7i76e mill example establish the complete electrical path? Continues [PROBE-230](3100_LINUXCNC_PROBE_230_G38_SOURCE_STATE_ABORT_2026-11-05.md) through [PROBE-232](3100_LINUXCNC_PROBE_232_G38_PARAMETER_WRITER_SYNC_2026-11-05.md). **No physical-machine or executable test.**

## Pinned source and real config
- LinuxCNC v2.9.10 [motion.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.c), blob `febe7f3ff3f2b80e34b00a9e60d3cdb3e9e41841`, around lines 471 and 619: `motion.probe-input` is exported as `HAL_IN` bit, initialized to 0.
- Same tag [control.c](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c), blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, `emcmotController` near line 252 and `process_probe_inputs` lines 679–737.
- Same tag [motion.h](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/motion.h), blob `f789f59cda93502e35e5ee156e6254d1d6591629`, `probeVal` field near 607 (comment says "debounced value").
- Public Mesa mill example [Skyfire-community/SVM2-LinuxCNC](https://github.com/Skyfire-community/SVM2-LinuxCNC/tree/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123) at commit `0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123`: [init.hal](https://github.com/Skyfire-community/SVM2-LinuxCNC/blob/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123/init.hal), blob `84ad49cf7474e8c725e652faeed29db69a7c1c00`; [axis.hal](https://github.com/Skyfire-community/SVM2-LinuxCNC/blob/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123/axis.hal), blob `1c7568f5bdb80aa40e47adf4e792b950e9793de4`; [Skyfire.ini](https://github.com/Skyfire-community/SVM2-LinuxCNC/blob/0fabfe4ba7baeea8f60ed39b66fc68c5ca5b3123/Skyfire.ini), blob `6f63c233875bd82b2eb426a4dfcb95b7bb612e43`.

## Source trace and consequences
**SOURCE-CONFIRMED (v2.9.10):** `process_probe_inputs` reads `!!*(emcmot_hal_data->probe_input)` directly into `probeVal`. There is no inversion, debounce counter, or filter *inside this function*. For ordinary G38.2/G38.3, a sampled logical 1 meets the contact predicate; for G38.4/G38.5, a sampled logical 0 meets the break-contact predicate, expressed as `probeVal ^ probe_whenclears`. The suppress-error bit changes unsuccessful-completion reporting, **not** contact polarity.

**SOURCE-CONFIRMED:** The function records `carte_pos_fb`, sets `probeTripped`, and calls `tpAbort` on a qualifying sample. On unsuccessful completion, it still records `carte_pos_fb` and reports an error unless suppressed. Outside probing, a rising logical edge can cause non-probe motion abort/error. The `motion.h` comment calling `probeVal` "debounced" does **not** establish filtering by this routine. An external HAL debounce component, input filter, or hardware input filtering may exist elsewhere; these must be audited per deployment.

**SOURCE-CONFIRMED (ordering):** `emcmotController` invokes `process_inputs`, then `do_forward_kins`, then `process_probe_inputs`. Consequently the probe result uses the feedback state available at that invocation, not a dedicated hardware timestamp. Do not equate reported contact position with the final stopped position.

**CONFIG-CONFIRMED, bounded:** Skyfire `init.hal` lines 22–24 schedule `hm2_7i76e.0.read`, `motion-command-handler`, `motion-controller` in that order; `hm2_7i76e.0.write` is line 32. In the **three inspected files** `init.hal`, `axis.hal`, and `Skyfire.ini`, there is no `motion.probe-input` connection or probe debounce component, even though the INI selects `DISPLAY = probe_basic`. **UNKNOWN:** whether additional HAL files, UI-generated wiring, or other startup scripts provide the probe net. The GUI name is not proof of a connected probe. This example establishes the Mesa scheduling order, **not** a verified probe wiring/polarity path. Do not claim a whole-repository negative from this three-file inspection.

## Minimal review fixture (not executed)
For a **disconnected simulated** input with `motion.probe-input` driven by a test signal and a known safe virtual axis:
1. With G38.3 active and input initially 0, change it to 1 during travel. Predict `#5070=1` and `#5063` equal to sampled Z feedback (after canonical coordinate mapping), not necessarily physical stop Z.
2. With G38.5 active and input initially 1, change it to 0. Predict success on clear.
3. Keep input 0 for G38.3 through the endpoint: `#5070=0`; coordinate parameters can still be populated. Never infer success from `#5063` alone.
4. Introduce a single-servo-period logical spike while G38.3 is active. **INFERENCE:** if sampled by the controller, the unfiltered input predicate can accept it; if between samples, it may be missed. This is not a measured pulse-width specification.
5. Move without probing and generate a rising edge; inspect the non-probe abort path. Do not run on physical equipment.

## Diagnostic implementation exercise
Read the complete active HAL file inclusion chain from the INI `[HAL]` section and inspect **all** `net` connections to `motion.probe-input`, Mesa GPIO `in`/`in_not` pins, any `not` or `debounce` component, and `addf` order. Confirm physical switch normally-open/normally-closed convention independently of the HAL logical convention. A proposed correct servo sequence for a software debounce is `hm2.read → debounce update → motion-controller → hm2.write`, with exact functions/pins verified from the installed component version. A filter placed after `motion-controller` produces a different observation latency. Use `halcmd show thread`, `halcmd show pin motion.probe-input`, and `halcmd show sig` to verify actual running topology. Avoid manipulating real axes for this exercise.

## Evidence ledger / limitations
| Finding | Class | Limit |
|---|---|---|
| Raw bit sampling and XOR trigger polarity | SOURCE-CONFIRMED | v2.9.10 function only |
| No debounce inside `process_probe_inputs` | SOURCE-CONFIRMED | Does not rule out upstream HAL/hardware filtering |
| `probeVal` field comment "debounced" | SOURCE-CONFIRMED comment | Not a demonstrated implementation guarantee |
| Mesa read before motion-controller in inspected Skyfire init | CONFIG-CONFIRMED | Config text only, not machine runtime |
| No probe wiring in three inspected Skyfire files | CONFIG-CONFIRMED narrow | Other files/inclusions unknown |
| Spike acceptance/missed pulses and capture error | INFERENCE | Requires bounded simulation/measurement |
| Physical stop distance, hardware input latency, full Skyfire wiring | UNKNOWN | Requires additional config/source or real evidence |

## Next
Trace **the complete Skyfire INI HAL inclusion chain** (not merely three files) or choose a public mill configuration with explicit `motion.probe-input` net and inspect the actual polarity/filter chain. If that source path remains blocked, rotate to spindle-at-speed and M6 tool-change control for higher information gain. Preserve graduated levels, blind evaluation, independent personnel-safety authority and physical HOLD. Only justified `[self-hosted, openpressbrake]` compute; no hosted Actions.
