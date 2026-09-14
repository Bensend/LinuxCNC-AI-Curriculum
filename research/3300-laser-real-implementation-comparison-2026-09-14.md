# 3300-L1 — real LinuxCNC laser implementation comparison

Date: 2026-09-14
LinuxCNC source baseline: `f666f1a51ae7c4d991cc61233e785dcc53fbe98d`
Comparison evidence: public CO2 config, public diode/Fusion config, LinuxCNC forum Raycus fiber retrofit
Status: CONFIG-CONFIRMED where repository files are inspectable; COMMUNITY-REPORTED for forum-only fiber details

## Purpose

The native `laserpower.comp` / `raster.comp` trace establishes reusable primitives but not a universal production architecture. This comparison tests those primitives against three materially different real laser classes and freezes only the common boundaries that survive the comparison.

## A. Buildlog 2.x CO2 — historical pulsed/raster architecture

Repository: `bjj/2x_laser` (LinuxCNC 2.5-era configuration).

The configuration uses several process layers:

- M3/M5 as a master laser enable. The author explicitly wanted M5/abort to prevent firing.
- laser firing can be driven by queued digital outputs or by an intentionally synthetic negative-Z convention for router-CAM compatibility;
- analog power uses M68;
- a custom realtime `laserfreq.comp` produces pulse-per-distance behavior;
- raster engraving is implemented with Python/external M scripts plus realtime streaming, predating the current upstream `raster.comp` architecture;
- chiller/assist-air power follows master laser enable and remains active for a configurable period after M5;
- raster overscan is intentionally sized so acceleration/reversal occurs outside the image.

This machine therefore separates **master process permission**, **pulse timing**, **analog power**, **motion**, and **auxiliaries**. It also demonstrates why raster quality cannot be reasoned about solely from image pixels: carriage acceleration and reversal materially affect deposited energy.

## B. JTrantow diode laser — direct M67 -> HostMot2 PWM chain

Repository: `JTrantow/LinuxCNC-F360-Cutting-Post-Processor`, inspected at public head `687c83c5906b2483e4f4754ee26e894832a7c259`.

The downloadable HAL exposes a compact production path:

`Fusion post -> M67/M68 E0 -> motion.analog-out-00 -> HostMot2 pwmgen.01.value -> 20 kHz PWM -> diode laser`

Specific config evidence:

- HostMot2 PWM frequency is set to 20 kHz;
- pwmgen scale is 100;
- `spindle-enable` drives both a GPIO relay controlling laser +12 V and the PWM generator enable;
- the HAL comments explicitly require this enable to be off during powerup and E-stop;
- `motion.analog-out-00` directly drives the PWM value;
- flood coolant is repurposed for the air relay and mist coolant for a crosshair laser.

The Fusion postprocessor is not just geometry output. Its `COMMAND_POWER_ON` path emits `M67 E<analog_out> Q...`, and the Q value depends on the CAM `jetMode` (for example `JET_MODE_THROUGH` selects configured through-power). Therefore in this implementation CAM/postprocessor owns part of the process recipe and feature-to-power mapping, while LinuxCNC owns synchronized application and hardware command generation.

This implementation does **not** route power through upstream `laserpower.comp`; it drives HostMot2 PWM directly from `motion.analog-out-00`. That is important negative evidence against teaching `laserpower.comp` as mandatory or canonical.

## C. 500 W Raycus fiber retrofit — QtPlasmaC adaptation

A 2024 LinuxCNC community build documented a 500 W Raycus fiber laser controlled with LinuxCNC, Mesa hardware and a customized/adapted QtPlasmaC workflow.

Reported architecture includes:

- a BCL-AMP capacitive height sensor integrated through a HostMot2 encoder/counter-style input;
- capacitive head distance converted/scaled into surfaces QtPlasmaC normally associates with arc-voltage/height control;
- a threshold-derived/fake ohmic signal for probing behavior;
- a fake/always-true Arc OK because the laser process does not provide plasma Arc OK semantics;
- a requested/customized `plasmac.comp` behavior so height control can remain active independent of plasma torch-on/current-velocity qualification, including dry-run/laser-off situations.

Classification: COMMUNITY-REPORTED unless a later pass obtains the final downloadable HAL/component fork.

This is evidence of **reuse by adaptation**, not evidence that plasma process semantics apply naturally to fiber laser. In fact, the adaptations identify the mismatch: capacitive standoff remains meaningful when laser emission is absent, while upstream plasma THC qualification assumes a plasma process relationship among torch state, velocity, Arc OK and arc voltage.

## Cross-implementation comparison

| Concern | CO2 Buildlog | Diode/Fusion | Raycus fiber retrofit |
| --- | --- | --- | --- |
| Emission/master permission | M3/M5 master | `spindle-enable` relay + PWM enable | adapted process enable / reported QtPlasmaC path |
| Power request | M68 analog + custom PPI | Fusion post emits M67/M68 | process-specific source command not yet source-inspected |
| Hardware power generation | parallel-port/PPI custom component | HostMot2 20 kHz PWM | not yet inspectable in final config |
| Height/focus | no active cutting-height loop established | no active loop in inspected files | capacitive head sensing is central |
| Raster | custom scripts + streaming | not established by inspected post | not relevant to metal-cutting build |
| Motion-energy correction | overscan / pulse-per-distance strategy | queued power by CAM feature | height/standoff adaptation; power dynamics unresolved |
| Auxiliaries | chiller + assist air | air relay + crosshair | gas/source/focus details still incomplete |
| CAM authority | router compatibility + custom raster calls | Fusion jet mode selects power | production post/material provenance unresolved |

## Reusable architecture lessons

### 1. Power intent and emission authority are separate

All three examples require distinguishing a requested power level from permission/readiness to emit. A numeric PWM/analog command must not be treated as proof that the source is enabled, ready, or safe to fire.

### 2. `laserpower.comp` is optional infrastructure

Upstream provides a useful velocity-aware scaler, but a real downloadable diode machine bypasses it and uses `motion.analog-out-00` directly. A future playbook should present at least two valid patterns:

- direct synchronized power command -> hardware PWM/analog;
- synchronized power intent -> `laserpower.comp` velocity normalization -> hardware PWM/analog.

The second may improve energy consistency through velocity variation but must be verified against the process and hardware response.

### 3. Height/focus architecture is process-specific

CO2/diode examples inspected here do not establish active standoff control. The Raycus build makes capacitive standoff fundamental and demonstrates why importing plasma THC qualification unchanged is wrong. Fiber/metal cutting needs a dedicated evidence path for capacitive sensing, focus position, pierce/cut height, gas state and source readiness.

### 4. CAM/postprocessor can own substantial process intent

The JTrantow Fusion post emits synchronized analog power according to `jetMode`, proving that feature/process semantics may enter LinuxCNC through the post rather than a LinuxCNC-specific process controller. Recipe provenance must therefore name CAD/CAM/post version and configuration, not only HAL.

### 5. Abort/safety claims remain bounded

The CO2 author and diode HAL explicitly arrange software master enables with safe-off intent, but none of the inspected software evidence makes LinuxCNC/HAL a functional-safety system. Physical source disable, interlocks, guarding and hazardous-energy control remain separate engineering responsibilities.

## Failure/diagnostic model

For a vector laser that does not emit or emits wrong power, inspect in this order:

`CAM feature/jet mode -> post emitted M67/M68/M62/M63 -> following-motion synchronization -> motion.analog-out -> optional laserpower scaler -> PWM/analog generator enable + value -> electrical source input -> source READY/FAULT/emission state -> optical/process result`

For active-height metal laser add:

`head capacitance -> sensor electronics -> acquisition/scaling -> standoff controller qualification -> Z command/offset -> motion limits -> physical head distance`

Do not merge those two chains merely because both end at a laser cut.

## Adversarial review — 8/8

1. Does a native upstream laser component mean all LinuxCNC lasers should use it? **No.** A real inspected diode configuration bypasses it.
2. Does `motion.analog-out` prove emission? **No.** Enable/readiness/hardware remain separate.
3. Can QtPlasmaC be reused for fiber? **Community evidence says yes with adaptation, but the required semantic substitutions prove it is not a drop-in process model.**
4. Is fake Arc OK evidence that fiber has an Arc OK equivalent? **No.** It is compatibility glue for a plasma-oriented workflow.
5. Is capacitive head sensing equivalent to plasma arc voltage? **No.** The build maps it into existing software surfaces; the physical measurement and qualification semantics differ.
6. Does CAM merely supply XY geometry? **No.** The inspected Fusion post selects/emits process power intent.
7. Does software E-stop/off wiring establish safety rating? **No.**
8. Can raster, diode vector cutting and fiber metal cutting share one recipe/state machine without process-specific evidence? **No.**

## Breadth decision

L1 now has source-level native primitives plus three differing implementation patterns. Further laser work still has high value, especially a downloadable contemporary fiber configuration and source READY/gas/focus handling, but the breadth-first curriculum should begin W1 waterjet in parallel rather than deepen only laser.
