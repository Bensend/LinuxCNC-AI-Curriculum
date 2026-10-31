# 4000-LC-HAL-19 — A public Mesa 7i95T configuration puts hardware write before PID and gates probing after motion

**Session start:** 2026-10-31T02:38:35.130Z UTC. **LinuxCNC-first, NON-GRADUATED; static source/config inspection only.** Follows [G38 PROBE-16](4400_LINUXCNC_PROBE_16_TASK_VERDICT_BARRIER_PREVIEW_AND_POSITION_SOURCE_VERSION_AUDIT_2026-10-31.md), [software encoder ENCODER-17](4400_LINUXCNC_ENCODER_17_SOFTWARE_LATCH_DOC_CONFLICT_AND_G38_METROLOGY_BOUNDARY_2026-10-31.md) and [HostMot2 encoder HM2-ENCODER-18](4400_LINUXCNC_HM2_ENCODER_18_FIRMWARE_GATED_PROBE_LATCH_VS_G38_SOURCE_AUDIT_2026-10-31.md). **Novelty:** the exact selected INI, complete multi-file HAL addf order and staged probe gating were not covered in those predecessors. This is not a claim of a new graduated competency.

## Question and pinned provenance

Does a real, inspectable Mesa HAL+INI configuration demonstrate the timing boundary between FPGA input read, LinuxCNC probe consumption, motion/PID calculation and HostMot2 output write? Does a hardware probe latch appear in that configuration?

**Public third-party config (not proof of installed/working machine):** [zmrdko/mesa_7i95t_config at `94af1eb5b86127b314181fc5809d75f2d59526e8`](https://github.com/zmrdko/mesa_7i95t_config/tree/94af1eb5b86127b314181fc5809d75f2d59526e8). [`7i95t_xyz2.ini`](https://github.com/zmrdko/mesa_7i95t_config/blob/94af1eb5b86127b314181fc5809d75f2d59526e8/7i95t_xyz2.ini#L80-L97), blob `d1d34724dec8b4df2a1895ef35e72ca1bf29711f`, selects **`hallib/01_main_pid.hal`**, *not* the commented-out `01_main.hal`, then `hallib/02_io.hal`, and sets `TWOPASS=on`. It requests `SERVO_PERIOD=1000000` ns (line 9). [`01_main_pid.hal`](https://github.com/zmrdko/mesa_7i95t_config/blob/94af1eb5b86127b314181fc5809d75f2d59526e8/hallib/01_main_pid.hal#L21-L31), blob `ec9978f5d128d5809691f9c3060d5404674044b9`; [`02_io.hal`](https://github.com/zmrdko/mesa_7i95t_config/blob/94af1eb5b86127b314181fc5809d75f2d59526e8/hallib/02_io.hal#L99-L137), blob `2ca7611a874e40844d909aa8d3bf2fc178c1a25c`. The alternate `01_main.hal` was inspected but is **not selected** by this INI. No claim that this is the actual currently loaded configuration of a running mill.

**Upstream LinuxCNC:** development commit [`24e84c4506b41634240f7087f0295e361a954886`](https://github.com/LinuxCNC/linuxcnc/tree/24e84c4506b41634240f7087f0295e361a954886), plus stable **v2.9.10** where noted. [`tcl/twopass.tcl` lines 1–39](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/tcl/twopass.tcl#L1-L39), blob `1614a607a36eddd887d1b7d46c5b5ff79cd9daa6`, says `addf` is deferred to pass1 and executed in occurrence order across HALFILEs; [`halcmd(1)`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/docs/src/man/man1/halcmd.1.adoc) confirms a realtime thread calls added functions in insertion order. **SOURCE+DOC-CONFIRMED** scheduling model, not a runtime trace of this installation.

## 1. Selected realtime execution graph

From `01_main_pid.hal` lines 24–31, then `02_io.hal` lines 102–117:

```text
servo-thread, each scheduled iteration (selected INI; not a measured trace):
  hm2.read
  hm2.write                         <-- before new motion/PID/aux outputs
  motion-command-handler
  motion-controller                 <-- consumes prior motion.probe-input
  pid.x1.do-pid-calcs
  pid.y1.do-pid-calcs
  pid.y2.do-pid-calcs
  pid.z1.do-pid-calcs
  ...other 02_io functions...
  and2.probe                         <-- reads previous comparator/debounce
  comp.probe                         <-- reads previous converter/constant
  conv_s32_float.probe               <-- reads current motion.motion-type
  constant.motion-probe              <-- publishes value 5
  debounce.0                         <-- reads current hm2 input
  ...later HALFILE functions...
```

`hm2.write` is not a no-op marker. [`hostmot2.c::hm2_write` lines 126–153](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hostmot2.c#L126-L153), blob `f83e48fad84639eb1c095335ce908b4d408a4d38`, prepares stepgen and other TRAM outputs and invokes `hm2_tram_write`; [`stepgen.c::hm2_stepgen_prepare_tram_write` lines 342–350](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/stepgen.c#L342-L350), blob `4daaa54f3fb63b6af2dc2d83a31ebfbb7b47ca23`, reads HAL command/enable pins. The selected HAL nets `pid.x1.output` to `[MESA](CARD0).stepgen.00.velocity-cmd` (lines 87–88), and likewise for other joints. **SOURCE-CONFIRMED conditional:** when `hm2.write` runs before `pid.*.do-pid-calcs`, it cannot transmit that iteration's newly computed PID output. It reads the previously published value; a later servo iteration can send it. This is **one scheduling iteration of stale command**, not a measured 1.000-ms physical delay or a claim about actuator dynamics. Communication errors and drive behavior can add other effects.

The INI's `TWOPASS=on` does **not** move the write to the end. The two-pass implementation explicitly preserves occurrence order of `addf` commands. A machine engineer must inspect the **selected** HALFILEs, not the similarly named unused alternative or an assumed generator default.

## 2. Probe input is deliberately gated by motion type — with a multi-stage delay

The selected `02_io.hal` implements:

```text
hm2.inmux.00.input-08-not -> debounce.0.0.in
motion.motion-type -> conv_s32_float.probe -> comp.probe.in0
constant.motion-probe.value = 5 -> comp.probe.in1
comp.probe.equal -> and2.probe.in0
debounce.0.0.out -> and2.probe.in1
and2.probe.out -> motion.probe-input
debounce.0.delay = 10
```

[Upstream `include/motion_types.h`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/include/motion_types.h) defines `EMC_MOTION_TYPE_PROBING=5`; [`control.c::process_probe_inputs` lines 752–841](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c#L752-L841), blob in pinned upstream source, reads **the gated** `motion.probe-input`. During an ordinary non-probe move it has a separate rising-edge branch that can abort the trajectory with “Probe tripped during non-probe move.” **SOURCE-CONFIRMED:** this selected gate normally forces that input FALSE whenever the comparator reports a motion type other than 5, so it removes the ordinary non-probe probe-trip diagnostic path for those intervals. This is not a personnel-safety function and does not establish whether another limit/interlock exists.

The `addf` order compounds latency. Let `n` mean one servo-thread iteration after startup has stabilized; these are **causal indices**, not measured timestamps:

| Stage | Value consumed in iteration n | Value published in n |
|---|---|---|
| `hm2.read` | board input image | `inmux(n)` |
| `motion-controller` | `and2(n-1)` | `motion-type(n)` |
| `and2.probe` | `comp(n-1)`, `debounce(n-1)` | `and2(n)` |
| `comp.probe` | `conv(n-1)`, `constant(n-1)` | `comp(n)` |
| `conv_s32_float.probe` | `motion-type(n)` | `conv(n)` |
| `debounce.0` | `inmux(n)` | `debounce(n)` |

Therefore a motion-type value published in iteration `n` can first affect the `motion.probe-input` sampled by `motion-controller` in **iteration n+3**. A debounced input value published in iteration `n` can first be consumed by motion in **n+2**. This is a static, steady-state same-thread dependency calculation; do **not** turn it into a guaranteed wall-clock stop distance. The actual input also passes the debounce filter. [`debounce.c` lines 183–232](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/components/debounce.c#L183-L232), blob `b8fe3d0ca4f72b2892fdbf49d8e789d40b4c739b`, implements a saturating up/down counter, so `delay=10` is not universally “ten uninterrupted TRUE samples” after a partly charged filter.

**Failure-path questions:** A short probe move may reach its endpoint while the gate is still catching up; a short pulse may not pass debounce; the gate can remain TRUE for a few iterations after motion-type changes; a previously asserted probe can be mistaken for a fresh contact by G38.3 (see PROBE-15). The exact machine outcome is **UNKNOWN** without a captured waveform, controller status and loaded configuration. These are conditional source-derived hazards, not witnessed failures.

## 3. The public config does not prove HostMot2 hardware probe latching

`01_main_pid.hal` uses `hm2.encoder.00.position` as PID and joint feedback and nets `joint.0.index-enable` to **encoder** index-enable; its `stepgen.00.index-enable` line is commented out (lines 55–58). The selected probe signal ends at `motion.probe-input`. No `encoder.NN.probe-enable` or `stepgen.NN.probe-enable` is connected in the inspected selected files. The absence of a net is **not** proof the firmware lacks the capability.

A distinct new implementation path was verified in both upstream revisions: [`mesa-hostmot2/stepgen.c::hm2_stepgen_parse_md` lines 708–739](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/stepgen.c#L708-L739) exports stepgen index/probe support **only for module descriptor version `0xC2`**; lines 964–999 conditionally create `stepgen.NN.position-latch`, `index-enable`, `probe-enable` and `probe-invert`. `hm2_stepgen_update_mode` lines 406–440 writes the arm/polarity bits; `hm2_stepgen_process_tram_read` lines 40–110 reads the latched stepgen **commanded step accumulator**, publishes `position-latch`, and clears `probe-enable` on a recognized event. Stable v2.9.10 source blob `8eb43d9a7d8e42573ef653cb82460609d2864ae4` independently contains the 0xC2 gate and latch path. This is **not** the same as an external quadrature encoder's measured position or G38 `#506x`. Encoder module probe support has a **different** descriptor gate (0x83/0x84; HM2-ENCODER-18). Do not conflate them or assume a 7i95T installed bitfile supports either.

## 4. Source-versus-runtime evidence ledger

| Claim | Class | Basis / limit |
|---|---|---|
| Selected INI uses PID HAL then IO HAL, two-pass, nominal 1-ms servo | SOURCE-CONFIRMED **configuration text** | Pinned public config; actual machine loading and clock jitter UNKNOWN |
| `addf` order is the effective same-thread order | SOURCE+DOC-CONFIRMED | Pinned twopass.tcl, halcmd(1) |
| `hm2.write` precedes new PID output; sends older command | SOURCE-CONFIRMED **conditional** | Pinned hostmot2/stepgen driver and selected HAL order; no measured output |
| Probe comparator uses motion type 5, gating non-probe contact from motion | SOURCE-CONFIRMED **conditional** | Pinned config + motion_types.h + process_probe_inputs |
| Multi-stage n+2/n+3 dependency and debounce behavior | INFERENCE from SOURCE-CONFIRMED scheduling | Requires actual thread trace to claim timing/jitter |
| Stepgen 0xC2 optional FPGA probe latch, separate from encoder 0x83/0x84 | SOURCE-CONFIRMED | Pinned stable/development HostMot2 driver; selected firmware UNKNOWN |
| Installed machine collision, missed probe, physical stop, metrology error, safety performance | UNKNOWN | No test, OEM wiring, firmware descriptor, physical witness |

## Practical verification / adversarial transfer (UNSCORED)

1. Before changing an installation, save its **actual** INI, every loaded HALFILE, `halcmd show thread`, `halcmd show pin`, `halcmd show sig`, and firmware/module descriptor inventory. The public repository may differ from deployed state.
2. Draw the complete `read -> input conditioning -> motion -> PID -> output conditioning -> write` dependency graph. Do not merely count `addf` commands. If a producer runs after its consumer, label the value as from the preceding iteration.
3. For a probe, independently record **raw input**, debounce state/output, `motion.motion-type`, `comp.probe.equal`, `and2.probe.out`, `motion.probe-input`, `#5070` and `#506x`; an ordinary G38 result is not proof of a hardware-latched encoder count.
4. Misleading premise: “The INI enables TWOPASS, so hm2.write will automatically run last.” **False**; the source preserves `addf` order.
5. Version/firmware question: “Mesa stepgen always has a probe latch.” **False**; require a `0xC2` stepgen module and matching pin export. External encoder latch has a different descriptor.
6. Minimal review-only change proposal: move hardware write **after** the motion/PID/output producers; place physical input conditioning before motion consumption if same-cycle input is desired. **Do not blindly move the existing motion-type comparator**: its input is produced by motion, creating an inherent causal loop. First decide whether motion-type gating is even needed and whether removing it restores useful ordinary non-probe contact diagnostics. This is not a ready-to-deploy machine patch.

**Decision:** no new lab frozen. Static source, two-pass scheduling and selected config already answer the dependency question. No hosted/self-hosted Actions, no simulation, no physical operation, no evaluator. Local panel runner access and physical isolation UNKNOWN; do not dispatch. Personnel safety remains independent; OpenPressBrake G0/G1 HOLD. **Next:** examine whether the same selected HAL has other high-consequence stale control/feedback dependencies, or rotate to maintained LinuxCNC HostMot2 stepgen/encoder index homing source with a concrete timing question. Avoid re-auditing the same G38 mechanisms.


## 5. Same-session follow-through: G38.4 and G38.5 **clear-on-contact** counterexample

This is a **new interaction** between the selected HAL's motion-type gate and LinuxCNC's clear-on-probe variants; it does not alter the earlier PROBE-15 source finding.

- [`interp_convert.cc::convert_probe` lines 4688–4715](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/rs274ngc/interp_convert.cc#L4688-L4715), blob `379b21eaba65840ce4160e7ea70df60c12fad9ff`, assigns `probe_type = g_code - G_38_2`: G38.2=0, G38.3=1, G38.4=2, G38.5=3. Bit 0 suppresses a failure error; bit 1 means trigger on **clearing** the input.
- [`command.c::EMCMOT_PROBE` lines 1592–1609](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/command.c#L1592-L1609), blob `fd9760e59ac0e9801cbee90a379acd98d47ca6ea`, checks the **current HAL-gated probe input** only when bit 0 is clear. Therefore **G38.4** with the selected gate FALSE can be rejected as “Probe is already clear” before movement. **G38.5** bypasses that initial-state guard.
- [`control.c::process_probe_inputs` lines 752–779](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/emc/motion/control.c#L752-L779) treats `probeVal ^ probe_whenclears` as the success condition. For G38.5, `probe_whenclears=1`, so a **FALSE** HAL input is a success-level observation. If `and2.probe` is still FALSE at the first servo iteration with `probing=1`, **G38.5 can report success immediately without a new physical clear transition**, even when the actual probe contact remains TRUE upstream of the gate. This is a **SOURCE-CONFIRMED conditional failure path**, not a reproduced run; whether this public configuration ever executes G38.5, and actual installed machine behavior, remain UNKNOWN.
- The reverse-gate latency is not cured by the 10-count debounce: the comparator waits for `motion.motion-type` to become 5 and then traverses the converter/comparator/and2 stages. A conditional false result during this interval can be a **gate artifact**, not a sensor state.

**Minimal falsifiable review case (paper only):** before a G38.5 move, assume the physical probe remains asserted TRUE, `motion.motion-type != 5`, and the selected gate has settled to FALSE. `EMCMOT_PROBE` skips the initial-state guard (bit 0 set), sets `probing=1`, and the first `process_probe_inputs` reads FALSE and satisfies `0 ^ 1`. The verdict does not prove the physical input changed. For G38.4 under the same state, the precondition can reject the command. Do **not** test this with physical motion; verify the actual deployed HAL and use a physically isolated simulator only if a concrete unresolved question justifies it.

**Review correction:** a probe input conditioned on `motion.motion-type` should not be treated as a faithful sensor-level input across all four G38 variants. If ordinary LinuxCNC probe-trip diagnostics are desired, a constantly observed, appropriately conditioned input is the simpler architecture. A machine-specific alternative requires explicit prearming and separate fault detection, and neither is a personnel-safety function.


**Stable-version cross-check:** LinuxCNC **v2.9.10** independently contains the same `probe_type=g_code-G_38_2` mapping in [`interp_convert.cc`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/rs274ngc/interp_convert.cc) (blob `f01a359652d588d59c9e210fa441a99d2ee19598`, ~3913), the same initial-state guard in [`motion/command.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/command.c) (blob `0b79061d39be915bbea548b2c33bb794d31ab302`, ~1435–1450), and the same `probeVal ^ probe_whenclears` success predicate and non-probe trip branch in [`motion/control.c`](https://github.com/LinuxCNC/linuxcnc/blob/v2.9.10/src/emc/motion/control.c) (blob `b6e45d590c7d11030654d8f7d13d118f581b6439`, ~693/724). The **source mechanism** therefore spans the two inspected revisions; the **specific third-party HAL configuration** remains pinned separately and is not asserted deployed with either binary.
