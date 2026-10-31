# 4000-LC-HAL-20 — A real 7i96S mill corrects output order but leaves probe conditioning and an enable indicator behind consumers

**UTC session start:** 2026-10-31T03:32:53.631Z. **LinuxCNC-first, NON-GRADUATED, static inspection only.** This is a cross-machine integration comparison, **not** a new discovery of the general HAL ordering rule established in [HAL-19](4400_LINUXCNC_HAL_19_REAL_MESA_7I95T_PID_WRITE_PROBE_GATE_ORDER_SOURCE_AUDIT_2026-10-31.md).

## Question and immutable evidence

Can an inspectable machine configuration show the intended `hm2.read -> motion -> PID -> hm2.write` ordering, and which dependencies remain delayed? Does it preserve raw probe visibility outside G38?

- **Public machine repository:** [alexphredorg/mr1](https://github.com/alexphredorg/mr1/tree/a41576f09a4ab597bfe64621c233e439ea8c5e52), commit `a41576f09a4ab597bfe64621c233e439ea8c5e52`, **published 2023-10-26T16:59:58Z**, audited 2026-10-31 (do not call it a new 2026 revision). [`mr1.ini`](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.ini), blob `924603a57bfb932312b3786cac50fc3c1a2b86ec`, lines 101–114 selects `mr1.hal`, `qtdragon_postgui.hal` and 1,000,000-ns nominal servo. [`mr1.hal`](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/mr1.hal), blob `f94bd8f15c4ef40ef0192be5b476b3290bc491cb`. README blob `3a6bcec9895bded2f7f3a10620f1d712db1cee7f` identifies a Langmuir MR-1 gantry mill using Mesa 7i96S Ethernet and warns that the configuration is work-in-progress/lightly tested. **SOURCE-CONFIRMED configuration text / author-reported deployment, not our installed-machine proof.**
- **Upstream implementation:** LinuxCNC development `24e84c4506b41634240f7087f0295e361a954886`, published 2026-10-30T10:04:49Z, [`hostmot2.c`](https://github.com/LinuxCNC/linuxcnc/blob/24e84c4506b41634240f7087f0295e361a954886/src/hal/drivers/mesa-hostmot2/hostmot2.c), blob `f83e48fad84639eb1c095335ce908b4d408a4d38`, lines 94–123/126–177. Source establishes that `hm2.read` publishes input and stepgen/encoder feedback, and `hm2.write` prepares/transmits output values.

## Selected scheduling and dataflow

`mr1.hal` lines 22–38 schedule:

```text
hm2_7i96s.0.read
motion-command-handler
motion-controller
pid.x / pid.y / pid.y2 / pid.z / pid.s.do-pid-calcs
scale.spindle; abs.spindle; lowpass.spindle; near.0
hm2_7i96s.0.write
or2.0; not.0; not.1; debounce.0
```

**SOURCE-CONFIRMED:** unlike HAL-19's selected 7i95T, this configuration sends the newly computed PID output through `hm2.write` in the **same servo iteration**, assuming the upstream command is valid and no communication error prevents transmission. This is not proof of zero Ethernet latency, motor response or following-error accuracy. The same file connects `joint.*.motor-pos-cmd` through PID and `hm2_7i96s.0.stepgen.*.velocity-cmd`; the encoder is used for spindle feedback.

**A different one-cycle dependency remains:** `motion.motion-enabled -> not.0.in -> not.0.out -> hm2_7i96s.0.ssr.00.out-00` (HAL lines 43–44, 412–413). Because `not.0` runs **after** `hm2.write`, the current iteration's inverted enable state cannot reach the SSR output until a subsequent `hm2.write` (assuming the signal remains valid). The electrical meaning of SSR0, any physical enable-chain architecture, and physical timing are **UNKNOWN**; it is **not** a verified personnel-safety function. This contrasts with the correctly placed PID output and illustrates why a blanket “write last” check must include *all* output producers.

**Probe input path:** lines 400–408 combine two independent physical inputs using `or2.0`, then `debounce.0` with delay 10, then `motion.probe-input`:

```text
7i96S input-07-not (touch) ---+
                              OR2 -> debounce -> motion.probe-input
7i96S input-06-not (setter) --+
```

Both OR and debounce run after `motion-controller`; therefore an input image received in iteration `n` can first be observed at motion in iteration `n+1`, **after** the debounce's state-dependent filtering. This is a source-derived scheduling relationship, not a measured 1-ms guarantee. The combined `probe` signal loses which-probe identity, though `touch-probe-in` and `tool-setter-in` remain separately inspectable HAL signals. Unlike HAL-19, no `motion.motion-type=5` gate appears in these selected files: the ordinary non-probe contact diagnostic remains able to see the combined probe after conditioning. **Do not infer independent safety from that diagnostic.**

## Cross-file probe and GUI review

- [`probe_xyz_front_left_top.ngc`](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/subroutines/probe_xyz_front_left_top.ngc), blob `809b45b3b7b0afeb9102772f90126aa47ee19020`, uses **G38.3 for several positioning/retract moves** and does not immediately test `#5070` after each such move. Per earlier [PROBE-15](4400_LINUXCNC_PROBE_15_G383_G385_ALREADY_TARGET_STATE_RESULT_SOURCE_AUDIT_2026-10-31.md), G38.3 is a no-error probe, not an unconditional G0: it can terminate on a probe level. Do not assume all these moves reach their programmed endpoints. The script's intention and physical success remain unknown.
- [`tool_setter_measure_tool.ngc`](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/subroutines/tool_setter_measure_tool.ngc), blob `6ac2f8146bcb1dcddac1934f02972f5f748993d6`, uses G38.2 and explicitly checks `#5070` before using `#5063`. That is a distinct result-consumption pattern; the initial-state and Task-version limitations in PROBE-15/16 still apply.
- [`qtdragon_postgui.hal`](https://github.com/alexphredorg/mr1/blob/a41576f09a4ab597bfe64621c233e439ea8c5e52/qtdragon_postgui.hal), blob `e336e0585dcfd38e0687d4bdf306166d5064aa67`, nets `probe-in => qtdragon.led-probe`, whereas the main HAL names its conditioned signal **`probe`**. The inspected selected files do **not** show a bridge between those signal names. A probe LED's actual value/other GUI-created connections are **UNKNOWN**; do not assume it represents the motion input without inspecting `halcmd show sig` on the loaded configuration.

## Evidence, review case and boundary

| Proposition | Classification | Evidence limit |
|---|---|---|
| INI selects 7i96S HAL, 1-ms nominal servo, postgui file | SOURCE-CONFIRMED | Pinned public text, not installed-machine verification |
| PID is calculated before `hm2.write` | SOURCE-CONFIRMED conditional | No runtime packet/physical motor measurement |
| SSR0 inversion runs after `hm2.write` | SOURCE-CONFIRMED conditional | One-iteration causal lag INFERENCE; physical SSR purpose UNKNOWN |
| Combined touch/setter path is after motion | SOURCE-CONFIRMED conditional | Filtering time/real input waveform UNKNOWN |
| G38.3 is used for positioning without per-move result checks | SOURCE-CONFIRMED | Actual machine motion UNKNOWN |
| Probe LED and motion probe are the same signal | UNKNOWN / not established by selected files | Requires loaded HAL signal inspection |
| Personnel safety or hardware stop behavior | UNKNOWN | Ordinary LinuxCNC control is not independent protection |

**Adversarial transfer (unscored):** If the PID graph is ordered correctly but an SSR output still changes a cycle late, identify `not.0` after `hm2.write` before blaming Ethernet. If the GUI probe LED disagrees with G38, inspect `probe`, `probe-in`, and their actual pin writers before changing debounce. For a G38.3 reposition, explicitly check its resulting position and `#5070`; do not assume a full-distance move.

**Decision:** static source answers the scheduling question. No lab frozen; no workflow, build, machine motion, or physical safety conclusion. No GitHub-hosted or self-hosted compute. Next source-depth branch: DPLL timer-number defaults and firmware-gated sampling; see [DPLL-21](4400_LINUXCNC_DPLL_21_TIMER_DEFAULTS_ENCODER_STEPGEN_ASYMMETRY_SOURCE_AUDIT_2026-10-31.md).
