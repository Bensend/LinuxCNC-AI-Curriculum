# Practical LinuxCNC HAL ordering review — Mesa read, probing, PID, write

**4000 implementation exercise; source/config inspection only; not a tested machine patch.** Companion: [HAL-19 pinned source audit](../research/4400_LINUXCNC_HAL_19_REAL_MESA_7I95T_PID_WRITE_PROBE_GATE_ORDER_SOURCE_AUDIT_2026-10-31.md).

## Why review a complete selected INI

A public 7i95T example has `[HAL] TWOPASS=on`, selects `01_main_pid.hal` (not `01_main.hal`) then `02_io.hal`, and requests a 1-ms servo period. The selected `addf` sequence starts `hm2.read; hm2.write; motion-command-handler; motion-controller; pid.*`. A later file adds `and2.probe; comp.probe; conv_s32_float.probe; constant.motion-probe; debounce.0`. The source for LinuxCNC's two-pass loader explicitly preserves `addf` occurrence order. Thus the configuration text has two different producer/consumer timing traps.

## The two dependency traps

**Output command:** `pid.output -> stepgen.velocity-cmd -> hm2.write`. The selected `hm2.write` executes before PID; it can transmit the preceding iteration's command, not the new command. Reordering can remove a software-scheduling delay but does not establish physical drive latency or stability.

**Probe:** `inmux -> debounce -> and2 -> motion.probe-input` and `motion.motion-type -> converter -> comparator -> and2`. Here `motion-controller` runs before all the conditioning functions; additionally, `and2` runs before its own producers. For a stable running schedule, a new motion-type output takes three iterations to reach the next motion input read; a new debounce output takes two. `delay=10` is an up/down counter threshold, not a calibrated stop time.

The comparator permits probe input only for motion type 5 (probing). LinuxCNC's `process_probe_inputs` has an ordinary diagnostic abort on probe rising during non-probe motion, but that branch cannot see a contact while the HAL gate holds `motion.probe-input` false. That software diagnostic is **not** an independent protective device.

## Review checklist (not a commissioning instruction)

1. Preserve the **actually loaded** INI and all referenced HAL/POSTGUI files. Check `TWOPASS`, include order, duplicate `addf`, `#NOTWOPASS` exceptions, and any later runtime HAL edits.
2. Map every signal's **producer function, consumer function and ordered thread**; `net` arrows are only notation, not a scheduler. Verify with `halcmd show thread`, `show pin`, `show sig` and the HAL report facility where available.
3. Record the physical input polarity, debounce state, actual FPGA descriptor and firmware, and whether `motion.probe-input` is continuously monitored or gated. A successful `#5070` alone does not prove a new edge or a hardware latch.
4. For a proposed change, independently review the timing of `hm2.read -> input filters -> motion -> PID -> hm2.write`. The motion-type comparator depends on motion's own output, so simply moving it ahead of motion cannot create a zero-delay loop.
5. Check both **normal G38 probing** and **unexpected contact during non-probe motion**, including short moves, already-asserted input, and transitions into/out of motion type 5. Retain existing independent hardwired protective functions.
6. Do not execute on a hazardous machine from this guide. First review actual wiring, machine-specific stopping behavior, fail states, and independent safety architecture. If runtime evidence is truly needed, use an isolated local `[self-hosted, openpressbrake]` setup only after proving it cannot energize physical outputs.

## Adversarial handoff exercise (not scored)

A new config lists `hm2.read, motion-controller, pid.do-pid-calcs, hm2.write`, but a second HALFILE later adds `debounce.0` feeding `motion.probe-input`. **Question:** which dependencies are same-cycle and which are stale? **Expected reasoning:** the PID output can be consumed by the later write in the same iteration, but the motion controller consumes the prior iteration's debounce output; move input conditioning before motion if appropriate. Do not infer that a firmware probe latch is connected merely because an encoder pin exists.

**Evidence:** [LinuxCNC twopass loader](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/tcl/twopass.tcl), [HostMot2 write path](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hostmot2.c#L126-L153), [G38 input path](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c#L752-L841), and pinned public [selected HAL](https://github.com/zmrdko/mesa_7i95t_config/blob/94af1eb5b86127b314181fc5809d75f2d59526e8/hallib/01_main_pid.hal#L21-L31). No runtime or physical claims.


### Clear-on-probe G38.4/G38.5 trap

LinuxCNC `G38.4` and `G38.5` seek a **cleared** probe input, unlike G38.2/.3. In the selected 7i95T HAL, `motion.probe-input` is artificially FALSE until the motion-type=5 comparator and `and2.probe` catch up. Pinned `EMCMOT_PROBE` source rejects G38.4 when the gated input is already clear, while G38.5 skips the initial-state check and can report success on the **FALSE gate output** before a real contact-release transition. This is conditional source reasoning, not a machine test. Review all four G38 variants, not just the usual G38.2, and never infer physical contact from `#5070` without sensor provenance. [Exact source addendum](../research/4400_LINUXCNC_HAL_19_REAL_MESA_7I95T_PID_WRITE_PROBE_GATE_ORDER_SOURCE_AUDIT_2026-10-31.md#5-same-session-follow-through-g384-and-g385-clear-on-contact-counterexample).
